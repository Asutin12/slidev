---
theme: "default"
style: "./style.css"
title: "EKS Auto Mode × Kro ハンズオン"
lang: "ja-JP"
drawings:
  enabled: true
highlighter: shiki
lineNumbers: false
info: |
  ## EKS Auto Mode × Kro ハンズオン

  Amazon EKS Auto Modeの新機能とKro (Kube Resource Orchestrator)を
  組み合わせた次世代Kubernetes運用を実際に触って学ぶハンズオンです。
  従来の運用方法との違いを理解しながら、両技術の特徴と活用方法を解説します。
---

# EKS Auto Mode × Kro ハンズオン

次世代 Kubernetes 運用を体験しよう

<div class="pt-12">
  <span @click="$slidev.nav.next" class="px-2 py-1 rounded cursor-pointer" hover="bg-white bg-opacity-10">
    Press Space for next page <carbon:arrow-right class="inline"/>
  </span>
</div>

---

## アジェンダ

<v-click>

- 🚀 **EKS Auto Mode とは？** - 完全自動化されたインフラ
- 🎯 **Kro とは？** - Kubernetes リソース抽象化ツール
- 🔄 **従来の運用との違い** - なぜ今この 2 つが注目されるか
- ⚡ **技術的特徴** - Auto Mode と Kro の強み
- 🛠️ **ハンズオン環境構築** - クラスター作成から Kro セットアップ
- 📝 **実践 1** - Auto Mode による自動スケーリング
- 🎨 **実践 2** - Kro による抽象化 API 作成
- 🚀 **実践 3** - 両技術を活用した複雑アプリのシンプル管理
- 🔧 **トラブルシューティング** - よくある問題と解決策
- 📋 **まとめ** - 次世代運用への移行指針

</v-click>

---

## layout: center

# EKS Auto Mode とは？

完全マネージドな Kubernetes 体験

---

## EKS Auto Mode の概要

<v-click>

- 🤖 **完全自動化** - ノード管理が不要
- 📊 **リソース最適化** - ワークロードに応じた自動調整
- 💰 **コスト効率** - 使用した分だけの課金
- 🔒 **セキュリティ向上** - 自動パッチ適用
- ⚡ **高速起動** - 数秒で Pod が起動
- 🌐 **マルチ AZ 対応** - 自動的な可用性分散

</v-click>

<br>

<v-click>

```bash
# Auto Mode クラスター作成
aws eks create-cluster \
  --name my-auto-cluster \
  --version 1.29 \
  --compute-config nodePool=auto
```

</v-click>

---

## 従来の EKS との比較

<div class="grid grid-cols-2 gap-8">
<div>

### Managed Node Groups

<v-click>

- 🔧 **手動ノード管理** - インスタンスタイプ選択が必要
- 📈 **事前スケーリング** - 予測に基づくキャパシティ設定
- 💸 **固定コスト** - 未使用リソースも課金
- 🔄 **手動更新** - パッチ適用タイミングを管理
- ⏰ **起動時間** - 数分でノード追加

</v-click>

</div>
<div>

### Auto Mode

<v-click>

- 🤖 **自動ノード管理** - AWS が最適なリソースを選択
- ⚡ **オンデマンド** - 必要な時に必要な分だけ
- 💰 **従量課金** - 使用したリソース分のみ
- 🛡️ **自動更新** - セキュリティパッチ自動適用
- 🚀 **即座に起動** - 数秒でコンテナ実行

</v-click>

</div>
</div>

<v-click>

<div class="text-center mt-8">
  <h3 class="text-green-400">Auto Mode = サーバーレスKubernetes</h3>
</div>

</v-click>

---

## Auto Mode が解決する課題

<v-click>

### 🎯 **運用負荷の軽減**

- ノードサイズ選択の悩み解消
- キャパシティプランニング不要
- パッチ管理からの解放

### 💡 **コスト最適化**

- リソースの無駄遣い防止
- オーバープロビジョニング回避
- 使用量に応じた精密な課金

### ⚡ **開発速度の向上**

- インフラ設定の簡素化
- 高速なスケーリング
- デプロイ時間の短縮

</v-click>

---

## layout: center

# ハンズオン環境構築

実際に Auto Mode を体験してみよう

---

## 前提条件

<v-click>

### 必要なツール

- AWS CLI (v2.0 以降)
- kubectl (v1.29 以降)
- eksctl (最新版推奨)

### 権限要件

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["eks:*", "ec2:*", "iam:*"],
      "Resource": "*"
    }
  ]
}
```

</v-click>

---

## クラスター作成

<v-click>

### 1. Auto Mode クラスター作成

```bash
# 基本的なAuto Modeクラスター
aws eks create-cluster \
  --name automode-cluster \
  --version 1.29 \
  --role-arn arn:aws:iam::ACCOUNT:role/eks-service-role \
  --compute-config nodePool=auto \
  --vpc-config subnetIds=subnet-xxx,subnet-yyy

# 作成完了確認（5-10分程度）
aws eks describe-cluster --name automode-cluster
```

</v-click>

<v-click>

### 2. kubectl 設定

```bash
# kubeconfig更新
aws eks update-kubeconfig --name automode-cluster

# 接続確認
kubectl get nodes
```

</v-click>

---

## 初回デプロイ

<v-click>

### サンプルアプリケーション

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-automode
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:latest
          resources:
            requests:
              cpu: 100m
              memory: 128Mi
```

</v-click>

---

## デプロイと確認

<v-click>

```bash
# アプリケーションデプロイ
kubectl apply -f nginx-deployment.yaml

# Pod状態確認（数秒で起動するはず）
kubectl get pods -w

# ノード確認（自動的に作成される）
kubectl get nodes

# リソース使用量確認
kubectl top nodes
kubectl top pods
```

### 期待される結果

- Pod が数秒で`Running`状態になる
- ノードが自動的に作成される
- リソースが効率的に配置される

</v-click>

---

## オートスケーリングテスト

<div class="grid grid-cols-2 gap-6">
<div>

### 負荷テスト用 Pod

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: load-test
spec:
  replicas: 1
  selector:
    matchLabels:
      app: load-test
  template:
    spec:
      containers:
        - name: busybox
          image: busybox
          command: ["sh", "-c"]
          args:
            - while true; do
              stress --cpu 2 --timeout 60s;
              sleep 30;
              done
          resources:
            requests:
              cpu: 2
              memory: 1Gi
```

</div>
<div>

### スケーリング確認

```bash
# 負荷テスト開始
kubectl apply -f load-test.yaml

# スケーリング確認
kubectl get pods -w
kubectl get nodes -w

# レプリカ数増加
kubectl scale deployment nginx-automode --replicas=10

# リソース使用量監視
watch 'kubectl top nodes && echo "" && kubectl top pods'
```

</div>
</div>

---

## 高度な機能：リソース最適化

<v-click>

### Vertical Pod Autoscaler (VPA)

```yaml
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  name: nginx-vpa
spec:
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: nginx-automode
  updatePolicy:
    updateMode: "Auto" # リソース要求を自動調整
```

### リソース監視

```bash
# VPAの推奨値確認
kubectl describe vpa nginx-vpa

# 実際のリソース使用量
kubectl get --raw /apis/metrics.k8s.io/v1beta1/nodes
```

</v-click>

---

## トラブルシューティング

<v-click>

### よくある問題

1. **Pod 起動が遅い**

   ```bash
   # イベント確認
   kubectl describe pod <pod-name>
   kubectl get events --sort-by=.metadata.creationTimestamp
   ```

2. **ノードが作成されない**

   ```bash
   # クラスター設定確認
   aws eks describe-cluster --name automode-cluster
   # IAMロール確認
   aws sts get-caller-identity
   ```

3. **リソース制限エラー**
   ```bash
   # 制限値確認
   kubectl describe limitrange
   kubectl describe resourcequota
   ```

</v-click>

---

## コスト監視

<v-click>

### AWS Cost Explorer 設定

- **サービス:** Amazon Elastic Kubernetes Service
- **使用タイプ:** Compute (Auto Mode)
- **ディメンション:** クラスター名別

### コスト最適化のポイント

```yaml
# リソース要求を適切に設定
resources:
  requests:
    cpu: 100m # 過度に大きく設定しない
    memory: 128Mi
  limits:
    cpu: 500m # バーストを考慮した上限
    memory: 512Mi
```

### 監視ダッシュボード作成

CloudWatch で EKS メトリクスを可視化

</v-click>

---

## セキュリティ設定

<v-click>

### Pod Security Standards

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: secure-namespace
  labels:
    pod-security.kubernetes.io/enforce: restricted
    pod-security.kubernetes.io/audit: restricted
    pod-security.kubernetes.io/warn: restricted
```

### Network Policies

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
spec:
  podSelector: {}
  policyTypes:
    - Ingress
    - Egress
```

</v-click>

---

## Auto Mode 採用のメリット・デメリット

<div class="grid grid-cols-2 gap-8">
<div>

### 🟢 **メリット**

<v-click>

- 運用負荷の大幅削減
- コスト効率の向上
- 高速なスケーリング
- セキュリティの自動化
- 開発者体験の向上

</v-click>

</div>
<div>

### 🟡 **検討事項**

<v-click>

- 新しい課金モデル
- 既存 workload の移行コスト
- 特定インスタンスタイプへの依存
- カスタム AMI の利用制限
- Spot Instance との併用

</v-click>

</div>
</div>

<v-click>

### 🎯 **適用を検討すべき場面**

- 新規プロジェクト
- 可変負荷のワークロード
- 運用チームのリソースが限られている場合

</v-click>

---

## layout: center

# Kro とは？

Kubernetes リソース抽象化の新時代

---

## Kro (Kube Resource Orchestrator) の概要

<v-click>

- 🎯 **リソース抽象化** - 複雑な YAML を簡単な API に変換
- 📝 **Resource Graph Definition (RGD)** - 宣言的なリソース定義
- 🤖 **自動 CRD 生成** - スキーマから Custom Resource を自動作成
- ⚡ **CEL 式サポート** - 動的な値参照と条件分岐
- 🔄 **依存関係管理** - リソース間の関係を自動解決
- 🎨 **再利用性** - 一度定義すれば何度でも利用可能

</v-click>

<br>

<v-click>

```yaml
# 複雑なDeployment + Service + Ingressを...
apiVersion: v1alpha1
kind: WebApplication # シンプルなAPIで管理
metadata:
  name: my-app
spec:
  name: awesome-app
  image: nginx:latest
  ingress:
    enabled: true
```

</v-click>

---

## 従来のマニフェスト管理との比較

<div class="grid grid-cols-2 gap-8">
<div>

### 従来の方法

<v-click>

- 📄 **大量の YAML** - Deployment、Service、Ingress を個別管理
- 🔗 **手動での関連付け** - リソース間の参照を手動設定
- 🐛 **設定ミスが多発** - 複雑な設定による人的ミス
- 📚 **学習コストが高い** - Kubernetes の深い知識が必要
- 🔄 **変更が困難** - 複数ファイルの一貫性維持が大変

</v-click>

</div>
<div>

### Kro による方法

<v-click>

- 🎯 **シンプルな API** - 必要な設定のみを公開
- 🤖 **自動関連付け** - CEL 式による動的参照
- ✅ **設定ミス防止** - スキーマ定義によるバリデーション
- 📖 **学習コストが低い** - 抽象化されたインターフェース
- ⚡ **変更が簡単** - 1 つのリソースで全体を管理

</v-click>

</div>
</div>

<v-click>

<div class="text-center mt-8">
  <h3 class="text-purple-400">Kro = Platform Engineering の実現</h3>
</div>

</v-click>

---

## Resource Graph Definition (RGD) の仕組み

<v-click>

### 1. スキーマ定義

```yaml
schema:
  apiVersion: v1alpha1
  kind: WebApplication
  spec:
    name: string | required=true
    image: string | default="nginx"
    replicas: integer | default=3 minimum=1 maximum=10
```

### 2. リソーステンプレート

```yaml
resources:
  - id: deployment
    template:
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: ${schema.spec.name}
      spec:
        replicas: ${schema.spec.replicas}
```

</v-click>

---

## Kro の高度な機能

<div class="grid grid-cols-2 gap-6">
<div>

### CEL 式による動的参照

```yaml
status:
  # 他のリソースから値を自動取得
  availableReplicas: ${deployment.status.availableReplicas}
  endpoint: ${service.status.loadBalancer.ingress[0].hostname}

resources:
  - id: service
    template:
      spec:
        # deploymentのlabelを参照
        selector: ${deployment.spec.selector.matchLabels}
```

</div>
<div>

### 条件付きリソース作成

```yaml
resources:
  - id: ingress
    # 条件に応じて作成
    includeWhen:
      - ${schema.spec.ingress.enabled}
    template:
      apiVersion: networking.k8s.io/v1
      kind: Ingress
      metadata:
        name: ${schema.spec.name}-ingress
```

</div>
</div>

---

## EKS Auto Mode × Kro の相乗効果

<v-click>

### 🏗️ **インフラとアプリの完全自動化**

- Auto Mode: サーバーレス Kubernetes インフラ
- Kro: アプリケーション抽象化レイヤー

### 💡 **開発者体験の劇的向上**

- インフラの知識不要でアプリをデプロイ
- 複雑な設定をシンプルな API に隠蔽

### 🚀 **運用負荷の最小化**

- Auto Mode: ノード管理完全不要
- Kro: マニフェスト管理の簡素化

### 💰 **コスト最適化**

- Auto Mode: 使った分だけ課金
- Kro: 設定ミスによる無駄なリソースを防止

</v-click>

---

## 実践ハンズオン: Kro セットアップ

<v-click>

### 1. Kro インストール

```bash
# 最新バージョン取得
export KRO_VERSION=$(curl -sL \
  https://api.github.com/repos/kro-run/kro/releases/latest | \
  jq -r '.tag_name | ltrimstr("v")')

# Helm でインストール
helm install kro oci://ghcr.io/kro-run/kro/kro \
  --namespace kro \
  --create-namespace \
  --version=${KRO_VERSION}
```

</v-click>

<v-click>

### 2. ResourceGraphDefinition 作成

```bash
# サンプル RGD を適用
kubectl apply -f manifests/simple-web-app-rgd.yaml

# RGD 状態確認
kubectl get rgd
```

</v-click>

---

## 実践例: シンプルな WebApplication API

<v-click>

### ResourceGraphDefinition

```yaml
apiVersion: kro.run/v1alpha1
kind: ResourceGraphDefinition
metadata:
  name: web-application
spec:
  schema:
    apiVersion: v1alpha1
    kind: WebApplication
    spec:
      name: string | required=true
      image: string | default="nginx"
      replicas: integer | default=3
      ingress:
        enabled: boolean | default=false
```

</v-click>

<v-click>

### インスタンス作成

```yaml
apiVersion: v1alpha1
kind: WebApplication
metadata:
  name: my-app
spec:
  name: awesome-app
  image: nginx:latest
  replicas: 3
  ingress:
    enabled: true
```

</v-click>

---

## layout: center

## まとめ

<v-click>

### EKS Auto Mode × Kro で**Kubernetes 運用が根本的に変わる**

🤖 **完全自動化**：インフラからアプリまで全てが自動化  
🎯 **抽象化の力**：複雑さを隠蔽し、本質に集中  
💰 **コスト最適化**：無駄なリソースとミスを徹底排除  
⚡ **開発速度向上**：数秒でアプリをデプロイ可能

<br>

### 🚀 次世代運用の実現

- **Platform Engineering** が誰でも実践可能
- **DevOps の民主化** により全チームが恩恵を受ける
- **運用負荷を 90% 削減**し、イノベーションに集中

</v-click>

---

## layout: center

# ありがとうございました！

## 質疑応答

<div class="pt-12">
  <span class="text-sm opacity-50">
    このスライドも Cursor × Slidev で作成しました 🚀
  </span>
</div>
