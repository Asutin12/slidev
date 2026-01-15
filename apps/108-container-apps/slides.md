---
theme: "default"
style: "./style.css"
title: "Azure Container Apps ハンズオン"
lang: "ja-JP"
drawings:
  enabled: true
highlighter: shiki
lineNumbers: false
info: |
  ## Azure Container Apps ハンズオン

  Azure Container Apps を使ってマイクロサービスアプリを構築・デプロイし、
  イベント駆動型アーキテクチャを実践的に学びます。
---

## Azure Container Apps<br>ハンズオン

マイクロサービス時代のコンテナ PaaS を実践的に学ぶ

<div class="pt-12">
  <span @click="$slidev.nav.next" class="px-2 py-1 rounded cursor-pointer" hover="bg-white bg-opacity-10">
    Press Space for next page <carbon:arrow-right class="inline"/>
  </span>
</div>

---

## 本日のアジェンダ

Azure Container Apps を使って、コンテナベースのマイクロサービスアプリケーションを構築する実践的なスキルを習得します。

<div class="grid grid-cols-2 gap-x-6 text-sm">
<div>

### 基礎知識

- 🌐 **Container Apps とは**
- 📋 **他サービスとの比較**
  - AKS との違い
  - App Service for Containers との違い
- 🏗️ **アーキテクチャ概要**
  - Environment、Revision、Dapr

### ハンズオン

- ⚡ **① 環境準備**
  - リソースグループ作成
  - ACR（Container Registry）準備
  - Container Apps 環境の作成
- 🚀 **② シンプル Web アプリのデプロイ**
  - Hello World コンテナのデプロイ
  - パブリックアクセス確認

</div>
<div>

- ⚙️ **③ 環境変数とシークレット管理**
  - 環境変数設定
  - Key Vault 連携
  - Revision 管理
- 📈 **④ スケーリングとオートスケール**
  - HTTP ベースのスケーリング
  - KEDA による自動スケール
- 🔗 **⑤ Container Apps 同士の連携**
  - 内部通信（Service-to-Service）
  - Dapr による Pub/Sub
- 🔐 **⑥ VNet 連携とセキュリティ**
- 📊 **⑦ モニタリングとログ管理**
- 🎯 **⑧ 実践演習**
  - マイクロサービス構成の構築

### まとめ

</div>
</div>

---

## layout: center

# Container Apps とは？

**Kubernetes の複雑さを隠蔽した<br>サーバーレスコンテナプラットフォーム**

---

## Azure Container Apps の魅力

Azure Container Apps は、マネージド Kubernetes をベースにした、イベント駆動型のサーバーレスコンテナプラットフォームです。

<div class="grid grid-cols-2 gap-x-8 gap-y-4 pt-6">
<div class="bg-gray-500/10 p-4 rounded">

#### 🚀 Kubernetes の運用不要

Kubernetes の複雑さを隠蔽し、コンテナの実行に集中できます。インフラ管理は Azure が自動で行います。

</div>
<div class="bg-gray-500/10 p-4 rounded">

#### ⚡ イベント駆動スケーリング

KEDA を活用したイベントベースの自動スケーリング。HTTP、キュー、カスタムメトリクスに対応します。

</div>
<div class="bg-gray-500/10 p-4 rounded">

#### 🔁 リビジョン管理

アプリケーションの複数バージョンを共存させ、トラフィックを段階的に移行できます（Blue/Green、Canary デプロイ）。

</div>
<div class="bg-gray-500/10 p-4 rounded">

#### 🧩 Dapr 統合

マイクロサービス構築に必要な機能（サービス間通信、Pub/Sub、State Store）を標準搭載しています。

</div>
</div>

---

## Container Apps の主要な機能

<div class="grid grid-cols-3 gap-4 pt-6 text-xs">
<div class="bg-blue-500/10 p-3 rounded">

#### 📦 マイクロサービス対応

<div class="mt-2">
<strong>用途：</strong>複数サービスの連携<br>
<strong>特徴：</strong>内部通信、Dapr、サービスディスカバリ
</div>
</div>
<div class="bg-green-500/10 p-3 rounded">

#### 📈 イベント駆動スケーリング

<div class="mt-2">
<strong>用途：</strong>需要に応じた自動スケール<br>
<strong>特徴：</strong>KEDA、HTTP/Queue/Custom、0へのスケール
</div>
</div>
<div class="bg-purple-500/10 p-3 rounded">

#### 🔄 リビジョン管理

<div class="mt-2">
<strong>用途：</strong>安全なデプロイ<br>
<strong>特徴：</strong>Blue/Green、Canary、トラフィック分割
</div>
</div>
<div class="bg-orange-500/10 p-3 rounded">

#### 🔐 セキュリティ

<div class="mt-2">
<strong>用途：</strong>安全な運用<br>
<strong>特徴：</strong>Managed Identity、シークレット、VNet統合
</div>
</div>
<div class="bg-cyan-500/10 p-3 rounded">

#### 📊 監視・診断

<div class="mt-2">
<strong>用途：</strong>運用管理<br>
<strong>特徴：</strong>Log Analytics、Application Insights連携
</div>
</div>
<div class="bg-pink-500/10 p-3 rounded">

#### 💰 コスト最適化

<div class="mt-2">
<strong>用途：</strong>効率的な運用<br>
<strong>特徴：</strong>使用時のみ課金、0へのスケール、リソース共有
</div>
</div>
</div>

---

## 今回構築するアーキテクチャ

Container Apps を使ったマイクロサービス構成を構築します。

**フロー**

1. 開発者がアプリケーションをコンテナ化し、ACR にプッシュ
2. Container Apps が ACR からイメージを取得・デプロイ
3. Web App（パブリック）と Worker App（内部）が連携
4. Dapr を使った Pub/Sub とサービス間通信
5. Log Analytics で一元的なログ管理

---

## Container Apps vs App Service for Containers

Azure でコンテナを動かす選択肢を比較します。

<div class="grid grid-cols-1 gap-4 pt-4 text-sm">

| サービス                       | 特徴                                        | 適したケース                                | 管理の複雑さ |
| ------------------------------ | ------------------------------------------- | ------------------------------------------- | ------------ |
| **Container Apps**             | イベント駆動、Kubernetes ベース、Dapr       | マイクロサービス、イベント駆動、バッチ処理  | ⭐⭐         |
| **App Service for Containers** | PaaS、シンプル、単一コンテナ中心            | Web アプリ、API、既存 Docker イメージ       | ⭐           |
| **Azure Kubernetes Service**   | フル Kubernetes、高度なオーケストレーション | 複雑なマイクロサービス、本格的な Kubernetes | ⭐⭐⭐⭐     |
| **Container Instances**        | 軽量、短期間実行                            | バッチジョブ、CI/CD エージェント            | ⭐           |

</div>
<div class="mt-4 bg-blue-500/10 p-3 rounded text-sm">
💡 <strong>今回のハンズオンでは:</strong> Container Apps を使用します。マイクロサービス構成、イベント駆動、複数コンテナ間の連携を学びます。
</div>

---

## Container Apps の主要コンポーネント

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">
<div>

### Environment（環境）

複数の Container Apps が共有する実行環境です。

- **Log Analytics Workspace** を共有
- **VNet 統合**を環境単位で設定
- **Dapr コンポーネント**を共有
- **同じ Environment 内のアプリは相互通信可能**

```bash
az containerapp env create \
  --name my-env \
  --resource-group rg-containerapps \
  --location japaneast
```

</div>
<div>

### Revision（リビジョン）

Container Apps のデプロイ単位（バージョン）です。

- **イミュータブル**（変更不可）
- **複数の Revision を並行稼働**可能
- **トラフィック分割**で段階的移行

```bash
# 新しいリビジョンをデプロイ
az containerapp update \
  --name my-app \
  --image myapp:v2

# トラフィック分割（v1:80%, v2:20%）
az containerapp ingress traffic set \
  --name my-app \
  --revision-weight v1=80 v2=20
```

</div>
</div>

---

## 前提条件

<div class="grid grid-cols-2 gap-6">
<div>

### Azure アカウント

- ✅ **Azure サブスクリプション**
- ✅ **リソースグループ作成権限**

### 必要なツール

- ✅ **Azure Portal アクセス**
  - [https://portal.azure.com](https://portal.azure.com)
- ✅ **Azure CLI（推奨）**
  - バージョン 2.55 以降
  - Container Apps 拡張機能
- ✅ **Docker Desktop**
  - ローカルでのイメージビルド用
- ✅ **Git（任意）**
  - サンプルアプリのクローン用

</div>
<div>

### 開発環境

- ✅ **テキストエディタ**
  - VS Code 推奨
  - Docker 拡張機能
  - Azure 拡張機能
- ✅ **基本的なコマンドライン操作**
  - ターミナル/PowerShell の使用経験

### 知識要件

- ✅ **Docker の基礎**
  - イメージのビルド経験
  - Dockerfile の基本的な理解
- ✅ **Azure の基礎**
  - リソースグループの概念
  - 基本的なポータル操作
- ✅ **マイクロサービスの基礎（推奨）**
  - サービス間通信の概念
  - イベント駆動アーキテクチャの理解

</div>
</div>

---

## 料金について

このハンズオンで発生する料金の概算です。

<div class="grid grid-cols-2 gap-6 text-sm">

<div class="bg-blue-500/10 p-4 rounded">

#### 💰 推定料金

**ハンズオン全体：約 ¥1,500 / 月**

- Azure Container Registry（Basic）：約 ¥500/月
  - 10 GB ストレージ、無制限の Webhook
- Container Apps Environment：無料
  - 基本料金なし、使用リソース分のみ課金
- Container Apps：約 ¥800/月
  - vCPU 0.5、メモリ 1 GB、常時稼働の場合
  - 0 へのスケールダウンで大幅削減可能
- Log Analytics：約 ¥200/月
  - 5 GB 無料枠を超えた場合

<div class="mt-4 text-xs opacity-75">
※ 料金は 2025 年 10 月時点の東日本リージョン価格
</div>

</div>

<div class="bg-yellow-500/10 p-4 rounded">

#### 💡 コスト削減のヒント

1. **0 へのスケールダウン**
   - `min-replicas 0` で未使用時は課金なし
   - イベント駆動で自動起動
2. **ハンズオン終了後は削除**
   - リソースグループごと削除が簡単
   - 不要なリソースを残さない
3. **リソース最適化**
   - 必要最小限の vCPU/メモリ設定
   - 開発環境は小さめに
4. **モニタリング**
   - Azure Cost Management でコスト確認
   - 予算アラートの設定

<div class="mt-4 text-xs opacity-75">
※ Container Apps は使用時のみ課金される従量課金モデル
</div>
</div>
</div>

---

## リソース命名規則

適切なリソース名を付けることで、管理しやすくなります。

<div class="text-sm pt-4">

### 推奨パターン

```bash
rg-containerapps-handson          # リソースグループ
acr-handson-<name>                # ACR（グローバルに一意）
env-containerapps-<env>           # Container Apps Environment
ca-web-<name>                     # Container App (Web)
ca-worker-<name>                  # Container App (Worker)
log-containerapps-<name>          # Log Analytics Workspace
```

### グローバルに一意な名前が必要なリソース

以下のリソースは、Azure 全体で一意の名前である必要があります：

- **Container Apps**: `https://<app-name>.<env-unique-id>.<region>.azurecontainerapps.io`
- **Container Registry**: `<registry-name>.azurecr.io`

名前が既に使用されている場合は、日付や数字を追加してください（例: `ca-web-20251022`）。

</div>

---
src: ./pages/01-preparation.md
---
---
src: ./pages/02-basic-concepts.md
---
---
src: ./pages/03-simple-deployment.md
---
---
src: ./pages/04-env-and-secrets.md
---
---
src: ./pages/05-scaling.md
---
---
src: ./pages/06-service-connectivity.md
---
---
src: ./pages/07-vnet-security.md
---
---
src: ./pages/08-monitoring.md
---
---
src: ./pages/09-microservices.md
---
---
src: ./pages/99-summary.md
---