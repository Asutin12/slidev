#!/bin/bash

# Kro (Kube Resource Orchestrator) インストールスクリプト
# EKS Auto Mode クラスターに Kro をインストールし、サンプルRGDを展開します

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
NAMESPACE=${NAMESPACE:-"kro"}
TIMEOUT=${TIMEOUT:-"300"}

log_info "=== Kro インストール開始 ==="

# 必要なツールの確認
check_tools() {
    local tools=("kubectl" "helm" "curl" "jq")
    
    log_info "必要なツールを確認中..."
    
    for tool in "${tools[@]}"; do
        if ! command -v $tool &> /dev/null; then
            log_error "$tool がインストールされていません"
            exit 1
        fi
    done
    
    log_success "すべてのツールが確認できました"
}

# Kubernetesクラスター接続確認
check_k8s_connection() {
    log_info "Kubernetesクラスター接続を確認中..."
    
    if ! kubectl cluster-info &> /dev/null; then
        log_error "Kubernetesクラスターに接続できません"
        log_info "以下を確認してください:"
        log_info "1. kubectl が正しく設定されているか"
        log_info "2. EKS クラスターが作成済みか"
        exit 1
    fi
    
    local cluster_name=$(kubectl config current-context)
    log_success "Kubernetesクラスター接続確認完了"
    log_info "現在のコンテキスト: $cluster_name"
}

# Kro の最新バージョン取得
get_kro_version() {
    log_info "Kroの最新バージョンを取得中..."
    
    KRO_VERSION=$(curl -sL \
        https://api.github.com/repos/kro-run/kro/releases/latest | \
        jq -r '.tag_name | ltrimstr("v")')
    
    if [ "$KRO_VERSION" = "null" ] || [ -z "$KRO_VERSION" ]; then
        log_error "Kroのバージョン情報を取得できませんでした"
        exit 1
    fi
    
    log_success "Kro最新バージョン: v$KRO_VERSION"
}

# Kro インストール
install_kro() {
    log_info "Kro を Helm でインストール中..."
    
    # 既存のインストールをチェック
    if kubectl get namespace $NAMESPACE &> /dev/null; then
        log_warning "名前空間 '$NAMESPACE' は既に存在します"
        if helm list -n $NAMESPACE | grep -q kro; then
            log_info "Kro は既にインストールされています"
            log_info "アップグレードしますか? (y/N)"
            read -r response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                log_info "Kroをアップグレード中..."
                helm upgrade kro oci://ghcr.io/kro-run/kro/kro \
                    --namespace $NAMESPACE \
                    --version=${KRO_VERSION}
                log_success "Kroアップグレード完了"
            else
                log_info "既存のKroインストールを使用します"
            fi
        fi
    else
        # 新規インストール
        log_info "Kroを新規インストール中..."
        helm install kro oci://ghcr.io/kro-run/kro/kro \
            --namespace $NAMESPACE \
            --create-namespace \
            --version=${KRO_VERSION}
        
        log_success "Kroインストール完了"
    fi
}

# Kro の起動確認
verify_kro_installation() {
    log_info "Kroの起動を確認中..."
    
    local timeout_count=0
    local max_timeout=$((TIMEOUT / 5))
    
    while [ $timeout_count -lt $max_timeout ]; do
        if kubectl get pods -n $NAMESPACE | grep kro | grep -q Running; then
            log_success "Kroが正常に起動しました"
            kubectl get pods -n $NAMESPACE
            return 0
        fi
        
        log_info "Kroの起動を待機中... ($((timeout_count * 5))/$TIMEOUT 秒)"
        sleep 5
        ((timeout_count++))
    done
    
    log_error "Kroの起動がタイムアウトしました"
    log_info "Pod状態を確認してください:"
    kubectl get pods -n $NAMESPACE
    kubectl describe pods -n $NAMESPACE
    exit 1
}

# サンプル ResourceGraphDefinition の展開
deploy_sample_rgds() {
    log_info "サンプルResourceGraphDefinitionsを展開中..."
    
    # manifestsディレクトリの存在確認
    if [ ! -d "manifests" ]; then
        log_error "manifestsディレクトリが見つかりません"
        log_info "このスクリプトをプロジェクトルートから実行してください"
        exit 1
    fi
    
    # RGDファイルの展開
    for rgd_file in manifests/*-rgd.yaml; do
        if [ -f "$rgd_file" ]; then
            log_info "RGD適用中: $rgd_file"
            kubectl apply -f "$rgd_file"
        fi
    done
    
    log_success "RGD展開完了"
    
    # RGD状態確認
    log_info "ResourceGraphDefinition状態確認:"
    kubectl get rgd
}

# 動作確認用のサンプルインスタンス作成
create_sample_instances() {
    log_info "動作確認用サンプルインスタンス作成の準備完了"
    log_info ""
    log_info "以下のコマンドでサンプルインスタンスを作成できます:"
    log_info "kubectl apply -f manifests/example-instances.yaml"
    log_info ""
    log_info "作成しますか? (y/N)"
    read -r response
    
    if [[ "$response" =~ ^[Yy]$ ]]; then
        log_info "サンプルインスタンスを作成中..."
        kubectl apply -f manifests/example-instances.yaml
        
        log_success "サンプルインスタンス作成完了"
        log_info ""
        log_info "インスタンス状態確認:"
        kubectl get webapplication
        kubectl get dataprocessor
    else
        log_info "サンプルインスタンスの作成をスキップしました"
    fi
}

# Kro の基本的な使用方法を表示
show_usage_guide() {
    log_success "=== Kro使用ガイド ==="
    log_info ""
    log_info "📋 ResourceGraphDefinition確認:"
    log_info "kubectl get rgd"
    log_info ""
    log_info "🚀 WebApplication作成例:"
    echo "cat <<EOF | kubectl apply -f -
apiVersion: v1alpha1
kind: WebApplication
metadata:
  name: my-test-app
spec:
  name: my-test-app
  image: nginx:latest
  replicas: 2
  ingress:
    enabled: true
    host: test.example.com
EOF"
    log_info ""
    log_info "📊 インスタンス状態確認:"
    log_info "kubectl get webapplication"
    log_info "kubectl describe webapplication my-test-app"
    log_info ""
    log_info "🗑️ インスタンス削除:"
    log_info "kubectl delete webapplication my-test-app"
    log_info ""
    log_info "📚 詳細ドキュメント: https://kro.run/"
}

# メイン実行
main() {
    check_tools
    check_k8s_connection
    get_kro_version
    install_kro
    verify_kro_installation
    deploy_sample_rgds
    create_sample_instances
    show_usage_guide
    
    log_success "=== Kroセットアップ完了! ==="
    log_info ""
    log_info "🎉 EKS Auto Mode + Kro 環境が利用可能になりました!"
    log_info "Slidevプレゼンテーションで詳細な使用方法を確認してください。"
}

# スクリプト実行
main "$@"
