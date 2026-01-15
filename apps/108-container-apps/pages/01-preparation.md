---
layout: center
---

# ⚡ ハンズオン ①

環境準備

---

## ハンズオン ① の概要

このハンズオンでは、Azure Container Apps を使用するための環境を準備します。

<div class="pt-6">

### 🎯 学習目標

- リソースグループの作成方法を理解する
- Azure Container Registry (ACR) の作成と設定を学ぶ
- Container Apps 拡張機能のインストール
- Container Apps Environment の作成方法を習得する

### 📋 実施内容

1. **リソースグループの作成** - すべてのリソースを格納するグループ
2. **ACR の作成** - Docker イメージを保管するレジストリ
3. **Container Apps 拡張のインストール** - Azure CLI 拡張機能
4. **Container Apps Environment の作成** - 実行環境の準備

</div>

---

## STEP 1-1: リソースグループの作成（Portal）

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

### Portal での作成手順

1. **Azure Portal にアクセス**

   - [https://portal.azure.com](https://portal.azure.com)

2. **リソースグループを検索**

   - ホーム画面で「リソース グループ」を検索
   - 「+ 作成」をクリック

3. **基本設定**

   - **サブスクリプション**: 使用するサブスクリプション
   - **リソース グループ**: `rg-containerapps-handson`
   - **リージョン**: `Japan East`

4. **確認と作成**
   - 「確認および作成」→「作成」をクリック

</div>
<div>

### CLI での作成（推奨）

```bash
# Azure CLI でログイン（初回のみ）
az login

# 変数設定
export RESOURCE_GROUP="rg-containerapps-handson"
export LOCATION="japaneast"

# リソースグループの作成
az group create \
  --name $RESOURCE_GROUP \
  --location $LOCATION

# 作成確認
az group show \
  --name $RESOURCE_GROUP \
  --query "{Name:name, Location:location}" \
  --output table

# 期待される出力
# Name                         Location
# ---------------------------  ----------
# rg-containerapps-handson    japaneast
```

</div>
</div>

---

## STEP 1-2: Azure Container Registry の作成（Portal）

1. **ACR の検索**

   - Azure Portal で「コンテナー レジストリ」を検索
   - 「+ 作成」をクリック

2. **基本タブの設定**

   - **サブスクリプション**: 使用するサブスクリプション
   - **リソース グループ**: `rg-containerapps-handson`
   - **レジストリ名**: `acrhandson<unique-id>`
     - 例: `acrhandson20251022`
     - 英数字のみ、グローバルに一意
   - **場所**: `Japan East`
   - **SKU**: `Basic`（¥500/月、10GB ストレージ）

3. **ネットワーク タブ**

   - デフォルト設定のまま（パブリック アクセス）

4. **確認および作成**
   - 設定を確認して「作成」をクリック

<div class="mt-4 bg-yellow-500/10 p-3 rounded text-xs">
⚠️ <strong>複数人で実施する場合:</strong> ACR は1つを全員で共有することを推奨します。チームリーダーが1つ作成し、他のメンバーは同じACRを使用します。
</div>

---

## STEP 1-3: Azure Container Registry の作成（CLI）

```bash
# 変数設定
export ACR_NAME="acrhandson20251022"  # ユニークな名前に変更
export SKU="Basic"

# Microsoft.ContainerRegistryリソースプロバイダーを登録
az provider register --namespace Microsoft.ContainerRegistry

# ACR の作成
az acr create \
  --resource-group $RESOURCE_GROUP \
  --name $ACR_NAME \
  --sku $SKU \
  --location $LOCATION

# 作成には2〜3分かかります

# 作成確認
az acr show \
  --name $ACR_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "{Name:name, LoginServer:loginServer, Sku:sku.name}" \
  --output table

# 期待される出力
# Name                  LoginServer                         Sku
# --------------------  --------------------------------   -----
# acrhandson20251022   acrhandson20251022.azurecr.io      Basic
```

<div class="mt-4 bg-blue-500/10 p-3 rounded text-xs">
💡 <strong>ログインサーバー名:</strong> `acrhandson20251022.azurecr.io` が Docker イメージのプッシュ/プル時に使用するアドレスです。
</div>

---

## STEP 1-4: ACR の管理者認証を有効化

Docker クライアントから ACR にアクセスするため、管理者認証を有効にします。

<div class="grid grid-cols-2 gap-6">
<div>

### Portal での有効化

1. **ACR を開く**

   - 作成した ACR リソースを開く

2. **アクセス キー ページを開く**

   - 左メニューの「設定」→「アクセス キー」

3. **管理者ユーザーを有効化**

   - 「管理者ユーザー」をオンに切り替え
   - ユーザー名とパスワードが表示される

4. **認証情報をメモ**
   - **ログイン サーバー**: `<acr-name>.azurecr.io`
   - **ユーザー名**: `<acr-name>`
   - **password**: 表示されたパスワード

</div>
<div>

### CLI での有効化

```bash
# 管理者ユーザーを有効化
az acr update \
  --name $ACR_NAME \
  --admin-enabled true

# 認証情報の取得
az acr credential show \
  --name $ACR_NAME \
  --query "{Username:username, Password:passwords[0].value}" \
  --output table

# 期待される出力
# Username             Password
# -------------------  --------------------
# acrhandson20251022  <password-string>
```

<div class="mt-4 bg-yellow-500/10 p-2 rounded text-xs">
⚠️ <strong>本番環境では:</strong> 管理者認証ではなく、Managed Identity やサービスプリンシパルを使用することを推奨します。
</div>
</div>
</div>

---

## STEP 1-5: Container Apps 拡張機能のインストール

Azure CLI で Container Apps を操作するための拡張機能をインストールします。

```bash
# Container Apps 拡張機能をインストール（または更新）
az extension add --name containerapp --upgrade

# 必要なリソースプロバイダーを登録
az provider register --namespace Microsoft.App
az provider register --namespace Microsoft.OperationalInsights

# インストール確認
az version
# 期待される出力
# {
#   "azure-cli": "2.78.0",
#   "azure-cli-core": "2.78.0",
#   "azure-cli-telemetry": "1.1.0",
#   "extensions": {
#     "application-insights": "1.2.3",
#     "containerapp": "1.2.0b4",
#     "logic": "1.1.0"
#   }
# }
```

---

## STEP 1-6: Log Analytics Workspace の作成

Container Apps のログを収集するための Log Analytics Workspace を作成します。

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

### Portal での作成

1. **Log Analytics の検索**

   - Azure Portal で「Log Analytics」を検索
   - 「+ 作成」をクリック

2. **基本設定**

   - **サブスクリプション**: 使用するサブスクリプション
   - **リソース グループ**: `rg-containerapps-handson`
   - **名前**: `log-containerapps`
   - **リージョン**: `Japan East`

3. **確認と作成**
   - 「確認および作成」→「作成」をクリック

</div>
<div>

### CLI での作成

```bash
# Log Analytics Workspace の作成
export LOG_ANALYTICS_WORKSPACE="log-containerapps"

az monitor log-analytics workspace create \
  --resource-group $RESOURCE_GROUP \
  --workspace-name $LOG_ANALYTICS_WORKSPACE \
  --location $LOCATION

# Workspace ID の取得（後で使用）
export LOG_ANALYTICS_WORKSPACE_ID=$(az monitor log-analytics workspace show \
  --resource-group $RESOURCE_GROUP \
  --workspace-name $LOG_ANALYTICS_WORKSPACE \
  --query customerId \
  --output tsv)

# Workspace Key の取得（後で使用）
export LOG_ANALYTICS_WORKSPACE_KEY=$(az monitor log-analytics workspace get-shared-keys \
  --resource-group $RESOURCE_GROUP \
  --workspace-name $LOG_ANALYTICS_WORKSPACE \
  --query primarySharedKey \
  --output tsv)

echo "Workspace ID: $LOG_ANALYTICS_WORKSPACE_ID"
```

</div>
</div>

---

## STEP 1-7: Container Apps Environment の作成

Container Apps が実行される環境を作成します。

<div class="grid grid-cols-2 gap-6">
<div>

```bash
# Container Apps Environment の作成
export CONTAINERAPPS_ENVIRONMENT="env-containerapps"

az containerapp env create \
  --name $CONTAINERAPPS_ENVIRONMENT \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --logs-workspace-id $LOG_ANALYTICS_WORKSPACE_ID \
  --logs-workspace-key $LOG_ANALYTICS_WORKSPACE_KEY

# 作成には5〜10分かかります

# 作成確認
az containerapp env show \
  --name $CONTAINERAPPS_ENVIRONMENT \
  --resource-group $RESOURCE_GROUP \
  --query "{Name:name, Location:location, ProvisioningState:properties.provisioningState}" \
  --output table
# 期待される出力
# Name                  Location    ProvisioningState
# --------------------  ----------  -------------------
# env-containerapps    japaneast   Succeeded
```

</div>
<div>
<div class="mt-4 bg-blue-500/10 p-3 rounded text-sm">
💡 <strong>Environment とは:</strong> 複数の Container Apps が共有する実行環境です。同じ Environment 内のアプリは、Log Analytics、VNet、Dapr コンポーネントを共有できます。
</div>
</div>
</div>

---

## STEP 1-8: サンプルアプリの準備

シンプルな Node.js アプリを作成して、コンテナイメージをビルドします。

### ローカルでのビルドとテスト

```bash
# git clone
git clone
cd 

# イメージのビルド
docker buildx build --platform linux/amd64 -t todo-containerapp:v1 .

# ローカルでのテスト
docker run -p 3000:3000 todo-containerapp:v1

# 別のターミナルで確認
curl http://localhost:3000

# コンテナの停止
docker stop $(docker ps -q --filter ancestor=todo-containerapp:v1)
```

---

## STEP 1-9: イメージを ACR にプッシュ

作成したイメージを ACR にプッシュします。

```bash
# ACR にログイン
az acr login --name $ACR_NAME

# または Docker CLI でログイン
docker login ${ACR_NAME}.azurecr.io

# イメージにタグ付け
docker tag todo-containerapp:v1 ${ACR_NAME}.azurecr.io/todo-containerapp:v1

# ACR にプッシュ
docker push ${ACR_NAME}.azurecr.io/todo-containerapp:v1

# プッシュ確認
az acr repository list --name $ACR_NAME --output table
# 期待される出力
# Result
# ---------------------
# todo-containerapp

# タグの確認
az acr repository show-tags \
  --name $ACR_NAME \
  --repository todo-containerapp \
  --output table
# 期待される出力
# Result
# ------
# v1
```

---

## STEP 1-10: 環境変数の設定（任意）

今後のハンズオンで使用する環境変数をまとめて設定しておきます。

```bash
# 環境変数の設定（~/.bashrc または ~/.zshrc に追加推奨）
export RESOURCE_GROUP="rg-containerapps-handson"
export LOCATION="japaneast"
export ACR_NAME="acrhandson20251022"
export LOG_ANALYTICS_WORKSPACE="log-containerapps"
export CONTAINERAPPS_ENVIRONMENT="env-containerapps"

# Workspace ID と Key の取得（必要に応じて）
export LOG_ANALYTICS_WORKSPACE_ID=$(az monitor log-analytics workspace show \
  --resource-group $RESOURCE_GROUP \
  --workspace-name $LOG_ANALYTICS_WORKSPACE \
  --query customerId \
  --output tsv)

export LOG_ANALYTICS_WORKSPACE_KEY=$(az monitor log-analytics workspace get-shared-keys \
  --resource-group $RESOURCE_GROUP \
  --workspace-name $LOG_ANALYTICS_WORKSPACE \
  --query primarySharedKey \
  --output tsv)

# 環境変数の確認
echo "Resource Group: $RESOURCE_GROUP"
echo "Location: $LOCATION"
echo "ACR Name: $ACR_NAME"
echo "Environment: $CONTAINERAPPS_ENVIRONMENT"
```

---

## 環境準備の完了確認

すべての準備が完了したか確認します。

<div class="grid grid-cols-2 gap-6">
<div>

### ✅ チェックリスト

- [ ] リソースグループ作成完了
- [ ] ACR 作成・管理者認証有効化完了
- [ ] Container Apps 拡張機能インストール完了
- [ ] Log Analytics Workspace 作成完了
- [ ] Container Apps Environment 作成完了
- [ ] サンプルアプリのビルド完了
- [ ] ACR へのイメージプッシュ完了

</div>
<div>

### 確認コマンド

```bash
# すべてのリソースを確認
az resource list \
  --resource-group $RESOURCE_GROUP \
  --output table

# 期待される出力（4つのリソース）
# Name                   ResourceGroup              Type
# ---------------------  ------------------------  -----------------------------
# acrhandson20251022    rg-containerapps-handson  Microsoft.ContainerRegistry/registries
# log-containerapps     rg-containerapps-handson  Microsoft.OperationalInsights/workspaces
# env-containerapps     rg-containerapps-handson  Microsoft.App/managedEnvironments
```

</div>
</div>
<div class="mt-4 bg-green-500/10 p-3 rounded text-sm">
✅ <strong>環境準備完了!</strong> 次のハンズオンで Container Apps のデプロイを行います。
</div>

---

## トラブルシューティング

よくある問題と解決方法です。

<div class="text-xs">

| 問題                                     | 原因                         | 解決方法                                                         |
| ---------------------------------------- | ---------------------------- | ---------------------------------------------------------------- |
| ACR 名が既に使用されている               | グローバルに一意な名前が必要 | 日付や番号を追加（例: `acrhandson20251022`）                     |
| `az containerapp` コマンドが見つからない | 拡張機能未インストール       | `az extension add --name containerapp --upgrade` を実行          |
| リソースプロバイダー登録エラー           | 登録に時間がかかる           | 数分待ってから再試行、または `az provider show` でステータス確認 |
| Docker ログインエラー                    | 管理者認証が無効             | ACR の管理者認証を有効化                                         |
| Environment 作成が失敗する               | Log Analytics 未作成         | Log Analytics Workspace を先に作成                               |

### コマンド例

```bash
# リソースプロバイダーのステータス確認
az provider show --namespace Microsoft.App --query "registrationState"

# ACR の管理者認証ステータス確認
az acr show --name $ACR_NAME --query "adminUserEnabled"
```

</div>
