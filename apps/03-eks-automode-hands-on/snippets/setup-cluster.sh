#!/bin/bash

# EKS Auto Mode クラスターセットアップスクリプト
# このスクリプトは EKS Auto Mode クラスターを作成し、必要な設定を行います

set -e

# カラー設定
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ログ関数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 設定値
CLUSTER_NAME=${CLUSTER_NAME:-"automode-kro-cluster"}
REGION=${AWS_REGION:-"us-east-1"}
NODE_TYPE=${NODE_TYPE:-"m5.large"}
MIN_NODES=${MIN_NODES:-"1"}
MAX_NODES=${MAX_NODES:-"10"}

log_info "=== EKS Auto Mode クラスター セットアップ開始 ==="
log_info "クラスター名: $CLUSTER_NAME"
log_info "リージョン: $REGION"

# 必要なツールの確認
check_tools() {
    local tools=("aws" "kubectl" "jq")
    
    log_info "必要なツールを確認中..."
    
    for tool in "${tools[@]}"; do
        if ! command -v $tool &> /dev/null; then
            log_error "$tool がインストールされていません"
            exit 1
        fi
    done
    
    log_success "すべてのツールが確認できました"
}

# AWS認証確認
check_aws_auth() {
    log_info "AWS認証を確認中..."
    
    if ! aws sts get-caller-identity &> /dev/null; then
        log_error "AWS認証が設定されていません"
        log_info "以下のコマンドを実行してください: aws configure"
        exit 1
    fi
    
    local account_id=$(aws sts get-caller-identity --query Account --output text)
    local user_arn=$(aws sts get-caller-identity --query Arn --output text)
    
    log_success "AWS認証確認完了"
    log_info "アカウントID: $account_id"
    log_info "ユーザー/ロール: $user_arn"
}

# EKS Auto Mode クラスター作成
create_cluster() {
    log_info "EKS Auto Mode クラスターを作成中..."
    log_warning "この処理は10-15分程度かかります"
    
    # IAM サービスロールの作成
    local service_role_name="${CLUSTER_NAME}-service-role"
    
    # サービスロール作成（既に存在する場合はスキップ）
    if ! aws iam get-role --role-name $service_role_name &> /dev/null; then
        log_info "EKS サービスロールを作成中..."
        
        cat > trust-policy.json << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
        
        aws iam create-role \
            --role-name $service_role_name \
            --assume-role-policy-document file://trust-policy.json
        
        aws iam attach-role-policy \
            --role-name $service_role_name \
            --policy-arn arn:aws:iam::aws:policy/AmazonEKSClusterPolicy
        
        rm -f trust-policy.json
        
        log_success "EKS サービスロール作成完了"
    else
        log_info "EKS サービスロールは既に存在します"
    fi
    
    # VPC とサブネット情報を取得（デフォルトVPC使用）
    local vpc_id=$(aws ec2 describe-vpcs --filters "Name=is-default,Values=true" --query 'Vpcs[0].VpcId' --output text)
    local subnet_ids=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpc_id" --query 'Subnets[*].SubnetId' --output text | tr '\t' ',')
    
    log_info "VPC ID: $vpc_id"
    log_info "Subnet IDs: $subnet_ids"
    
    # サービスロールのARNを取得
    local service_role_arn=$(aws iam get-role --role-name $service_role_name --query Role.Arn --output text)
    
    # EKS Auto Mode クラスター作成
    if ! aws eks describe-cluster --name $CLUSTER_NAME --region $REGION &> /dev/null; then
        log_info "クラスター作成を開始..."
        
        # Auto Mode設定でクラスター作成
        aws eks create-cluster \
            --name $CLUSTER_NAME \
            --version 1.29 \
            --role-arn $service_role_arn \
            --resources-vpc-config subnetIds=$subnet_ids \
            --compute-config nodePool=auto \
            --region $REGION
        
        # クラスター作成完了まで待機
        log_info "クラスター作成完了を待機中..."
        aws eks wait cluster-active --name $CLUSTER_NAME --region $REGION
        
        log_success "EKS Auto Mode クラスター作成完了!"
    else
        log_info "クラスターは既に存在します"
    fi
}

# kubectl設定
configure_kubectl() {
    log_info "kubectl設定を更新中..."
    
    aws eks update-kubeconfig --name $CLUSTER_NAME --region $REGION
    
    # 接続確認
    if kubectl cluster-info &> /dev/null; then
        log_success "kubectl設定完了"
        log_info "クラスター情報:"
        kubectl cluster-info
    else
        log_error "kubectl設定に失敗しました"
        exit 1
    fi
}

# AWS Load Balancer Controller のインストール
install_alb_controller() {
    log_info "AWS Load Balancer Controller をインストール中..."
    
    # IAM OIDC プロバイダーの作成
    local oidc_id=$(aws eks describe-cluster --name $CLUSTER_NAME --region $REGION --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)
    
    if ! aws iam list-open-id-connect-providers | grep $oidc_id &> /dev/null; then
        log_info "OIDC プロバイダーを作成中..."
        eksctl utils associate-iam-oidc-provider --cluster $CLUSTER_NAME --region $REGION --approve
    fi
    
    # AWS Load Balancer Controller用のサービスアカウント作成
    if ! kubectl get sa aws-load-balancer-controller -n kube-system &> /dev/null; then
        log_info "AWS Load Balancer Controller サービスアカウント作成中..."
        
        eksctl create iamserviceaccount \
            --cluster=$CLUSTER_NAME \
            --region=$REGION \
            --namespace=kube-system \
            --name=aws-load-balancer-controller \
            --role-name AmazonEKSLoadBalancerControllerRole \
            --attach-policy-arn=arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess \
            --approve
    fi
    
    # Helm リポジトリ追加
    if ! helm repo list | grep eks &> /dev/null; then
        helm repo add eks https://aws.github.io/eks-charts
        helm repo update
    fi
    
    # AWS Load Balancer Controller インストール
    if ! kubectl get deployment aws-load-balancer-controller -n kube-system &> /dev/null; then
        log_info "AWS Load Balancer Controller をデプロイ中..."
        
        helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
            -n kube-system \
            --set clusterName=$CLUSTER_NAME \
            --set serviceAccount.create=false \
            --set serviceAccount.name=aws-load-balancer-controller \
            --set region=$REGION \
            --set vpcId=$vpc_id
        
        log_success "AWS Load Balancer Controller インストール完了"
    else
        log_info "AWS Load Balancer Controller は既にインストールされています"
    fi
}

# メイン実行
main() {
    check_tools
    check_aws_auth
    create_cluster
    configure_kubectl
    install_alb_controller
    
    log_success "=== EKS Auto Mode クラスターセットアップ完了! ==="
    log_info ""
    log_info "次のステップ:"
    log_info "1. Kroをインストール: ./install-kro.sh"
    log_info "2. サンプルアプリケーションをデプロイ: kubectl apply -f manifests/example-instances.yaml"
    log_info ""
    log_info "クラスター削除時: aws eks delete-cluster --name $CLUSTER_NAME --region $REGION"
}

# スクリプト実行
main "$@"
