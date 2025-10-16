# EKS Auto Mode × Kro ハンズオン

Amazon EKS Auto Mode の新機能と Kro (Kube Resource Orchestrator) を組み合わせた次世代 Kubernetes 運用を実際に触って学ぶハンズオン用の Slidev プレゼンテーションです。

## プレゼンテーション概要

このスライドでは以下の内容を学習できます：

### EKS Auto Mode

- 完全自動化された Kubernetes インフラ
- 従来の Managed Node Groups との違い
- サーバーレス Kubernetes の実現
- コスト最適化と運用負荷軽減

### Kro (Kube Resource Orchestrator)

- Kubernetes リソースの抽象化
- ResourceGraphDefinition (RGD) による宣言的リソース管理
- 複雑な YAML を簡単な API に変換
- Platform Engineering の実践

### 両技術の相乗効果

- インフラとアプリケーションの完全自動化
- 開発者体験の劇的向上
- 運用負荷の最小化
- 次世代 Kubernetes 運用の実現

## 開発環境

### 前提条件

- [Bun](https://bun.sh/) がインストールされていること
- Node.js v18 以降

### セットアップ

```bash
# 依存関係のインストール
bun install

# 開発サーバー起動
bun run dev
```

### ビルド

```bash
# 静的ファイル生成
bun run build

# PDF出力
bun run export
```

## プロジェクト構造

```
eks-automode-hands-on/
├── slides.md                 # メインのスライドファイル（EKS Auto Mode + Kro）
├── style.css                 # カスタムスタイル（AWS・Kubernetes テーマ）
├── package.json              # プロジェクト設定（bun ベース）
├── README.md                 # このファイル
├── components/               # Vue コンポーネント
│   └── Counter.vue          # サンプルコンポーネント
├── snippets/                 # コードスニペットとスクリプト
│   ├── external.ts          # 外部コード参照用
│   ├── k8s-manifests.yaml   # Auto Mode 用 Kubernetes マニフェスト
│   ├── setup-cluster.sh     # EKS Auto Mode クラスター作成スクリプト
│   └── install-kro.sh       # Kro インストールスクリプト
├── manifests/               # Kro ResourceGraphDefinitions
│   ├── simple-web-app-rgd.yaml    # Web アプリ用 RGD
│   ├── data-processor-rgd.yaml    # データ処理用 RGD
│   └── example-instances.yaml     # サンプルインスタンス
└── assets/                   # 静的ファイル
    └── images/              # 画像ファイル
```

## ハンズオン用ファイル詳細

### EKS Auto Mode 関連

- `snippets/k8s-manifests.yaml`: Auto Mode で使用する基本的な Kubernetes リソース
  - Nginx Deployment with Auto Mode 最適化
  - Load Balancer Service 設定
  - 負荷テスト用 Deployment
  - Vertical Pod Autoscaler 設定
  - Network Policy 例

### Kro (ResourceGraphDefinition) 関連

- `manifests/simple-web-app-rgd.yaml`: シンプルな Web アプリケーション API
  - Deployment + Service + Ingress を抽象化
  - リソース要求、レプリカ数、Ingress 設定をカスタマイズ可能
  - AWS Load Balancer Controller 対応

- `manifests/data-processor-rgd.yaml`: データ処理アプリケーション API
  - CronJob + PVC + ConfigMap + Database を組み合わせ
  - バッチ処理とストレージ管理を抽象化
  - 監視とアラート設定を含む

- `manifests/example-instances.yaml`: 実行可能なサンプルインスタンス集
  - 各種設定パターンの実例
  - すぐに試せる動作例

### セットアップスクリプト

- `snippets/setup-cluster.sh`: EKS Auto Mode クラスター自動作成
  - IAM ロール作成
  - VPC 設定
  - AWS Load Balancer Controller インストール
- `snippets/install-kro.sh`: Kro 自動インストール・設定
  - Helm による Kro インストール
  - ResourceGraphDefinition 展開
  - 動作確認

## 使い方

### 1. スライド表示

```bash
# 依存関係のインストール
bun install

# 開発サーバー起動
bun run dev
```

ブラウザで `http://localhost:3030` にアクセスして、矢印キーまたはスペースキーでスライドを操作します。

### 2. 実践ハンズオン

#### Step 1: EKS Auto Mode クラスター作成

```bash
# AWS CLI 設定済みであることを確認
aws sts get-caller-identity

# EKS Auto Mode クラスター作成（10-15分）
./snippets/setup-cluster.sh
```

#### Step 2: Kro インストール

```bash
# Kro をインストールし、ResourceGraphDefinition を展開
./snippets/install-kro.sh
```

#### Step 3: サンプルアプリケーション実行

```bash
# サンプルインスタンスを作成
kubectl apply -f manifests/example-instances.yaml

# 作成されたリソースを確認
kubectl get webapplication
kubectl get dataprocessor

# 詳細確認
kubectl describe webapplication frontend-app
```

#### Step 4: カスタム API の活用

```bash
# 独自の Web アプリケーションを作成
cat <<EOF | kubectl apply -f -
apiVersion: v1alpha1
kind: WebApplication
metadata:
  name: my-custom-app
spec:
  name: my-custom-app
  image: nginx:latest
  replicas: 2
  ingress:
    enabled: true
    host: my-app.example.com
EOF

# 状態確認
kubectl get webapplication my-custom-app -o wide
```

#### Step 5: クリーンアップ

```bash
# インスタンス削除
kubectl delete -f manifests/example-instances.yaml

# クラスター削除
aws eks delete-cluster --name automode-kro-cluster --region us-east-1
```

## 学習のポイント

### EKS Auto Mode で体験できること

- 🤖 **完全自動化**: ノード管理不要のサーバーレス Kubernetes
- ⚡ **高速スケーリング**: 数秒でのワークロード起動
- 💰 **コスト最適化**: 使用リソース分のみの課金
- 🛡️ **自動セキュリティ**: パッチ適用の自動化

### Kro で体験できること

- 🎯 **抽象化**: 複雑な YAML を簡単な API に変換
- 📝 **宣言的管理**: ResourceGraphDefinition による一元管理
- 🔄 **再利用性**: 一度作成した RGD の繰り返し利用
- 🤖 **自動生成**: CRD とコントローラーの自動作成

### 次世代運用の実現

- Platform Engineering の実践
- DevOps の民主化
- 運用負荷の大幅削減
- 開発者体験の向上

## 前提条件・動作環境

### 必要なツール

- [AWS CLI v2](https://aws.amazon.com/cli/)
- [kubectl v1.29+](https://kubernetes.io/docs/tasks/tools/)
- [Helm v3](https://helm.sh/)
- [jq](https://stedolan.github.io/jq/)
- [Bun](https://bun.sh/) または Node.js v18+

### 必要な権限

- EKS クラスター作成・管理権限
- IAM ロール・ポリシー作成権限
- VPC・EC2 リソース管理権限

### コスト目安

- EKS Auto Mode クラスター: 使用したリソース分のみ
- ハンズオン実行時間: 約2-3時間
- 推定コスト: $5-10（リソース削除前提）

## カスタマイズ

### スライド内容

- `slides.md`: スライドの内容を編集
- `style.css`: デザインやスタイルの変更
- `components/`: 新しい Vue コンポーネントを追加

### ハンズオン内容

- `manifests/`: 独自の ResourceGraphDefinition を作成
- `snippets/`: セットアップスクリプトのカスタマイズ
- 環境変数での設定変更（クラスター名、リージョンなど）

## トラブルシューティング

### よくある問題

1. **AWS 認証エラー**: `aws configure` で認証情報を設定
2. **権限エラー**: IAM ユーザー/ロールに適切な権限を付与
3. **クラスター作成失敗**: VPC の利用可能な IP アドレスを確認
4. **Kro インストール失敗**: kubectl の接続確認、Helm バージョン確認

### 参考リンク

- [EKS Auto Mode ドキュメント](https://docs.aws.amazon.com/ja_jp/eks/latest/userguide/automode.html)
- [Kro 公式サイト](https://kro.run/)
- [AWS Load Balancer Controller](https://kubernetes-sigs.github.io/aws-load-balancer-controller/)

## ライセンス

MIT License
