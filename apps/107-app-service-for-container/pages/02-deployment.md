---
layout: center
---

# 🚀 ハンズオン ②

App Service for Containers のデプロイ

---

## ハンズオン ② の概要

準備したコンテナイメージを App Service にデプロイします。

<div class="pt-6">

### 🎯 学習目標

- App Service Plan の作成方法を理解する
- コンテナイメージの設定を学ぶ
- ACR 認証の設定を習得する
- デプロイ後の動作確認方法を理解する

### 📋 実施内容

1. **App Service Plan の作成** - コンピューティングリソースの準備
2. **App Service の作成** - コンテナアプリの作成
3. **ACR 認証の設定** - イメージ取得の認証
4. **初回デプロイと確認** - アプリケーションの起動確認
5. **ログの確認** - デプロイ状況の監視

</div>

---

## STEP 2-1: App Service Plan の作成（Portal）

App Service が実行される環境（Plan）を作成します。

<div class="grid grid-cols-2 gap-6">
<div>

### Portal での作成手順

1. **App Service Plan の検索**

   - Azure Portal で「App Service プラン」を検索
   - 「+ 作成」をクリック

2. **基本設定**

   - **サブスクリプション**: 使用するサブスクリプション
   - **リソース グループ**: 作成済みのリソースグループ
   - **名前**: `plan-container-handson`
   - **オペレーティング システム**: `Linux`
   - **リージョン**: `Japan East`

3. **価格レベル**

   - **SKU とサイズ**: `Basic B1`
     - 1.75 GB RAM、100 GB ストレージ
     - 約 ¥1,400/月

4. **確認と作成**
   - 設定を確認して「作成」をクリック

</div>
<div>

### CLI での作成（推奨）

```bash
# 変数設定
export PLAN_NAME="plan-container-handson"
export SKU="B1"  # Basic B1

# App Service Plan の作成
az appservice plan create \
  --name $PLAN_NAME \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --is-linux \
  --sku $SKU

# 作成確認
az appservice plan show \
  --name $PLAN_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "{Name:name, Sku:sku.name, OS:reserved}" \
  --output table
# 期待される出力
# Name                      Sku  OS
# ------------------------  ---  -----
# plan-container-handson    B1   True
```

</div>
</div>

---

## STEP 2-2: App Service Plan の価格レベル比較

使用目的に応じて適切な価格レベルを選択します。

<div class="text-xs pt-4">

| 価格レベル | vCPU | メモリ  | ストレージ | 用途         | 料金/月 | 主な機能                             |
| ---------- | ---- | ------- | ---------- | ------------ | ------- | ------------------------------------ |
| **F1**     | 共有 | 1 GB    | 1 GB       | 開発・テスト | 無料    | カスタムドメイン不可、常時起動不可   |
| **D1**     | 共有 | 1 GB    | 1 GB       | 小規模テスト | ¥1,000  | カスタムドメイン可、常時起動不可     |
| **B1**     | 1    | 1.75 GB | 10 GB      | 小規模本番   | ¥1,400  | 常時起動可、手動スケーリング         |
| **B2**     | 2    | 3.5 GB  | 10 GB      | 中規模本番   | ¥2,800  | 同上                                 |
| **S1**     | 1    | 1.75 GB | 50 GB      | 本番環境     | ¥8,500  | オートスケール、ステージングスロット |
| **P1v3**   | 2    | 8 GB    | 250 GB     | 高性能本番   | ¥16,000 | プレミアム機能、VNet 統合            |

</div>
<div class="mt-4 bg-blue-500/10 p-3 rounded text-xs">
💡 <strong>ハンズオンでの推奨:</strong> B1 または B2 を選択してください。F1（無料）は常時起動ができず、コンテナが頻繁に停止するため不向きです。
</div>

---

## STEP 2-3: App Service の作成（Portal）

1. **App Service の検索**

   - Azure Portal で「Web App」または「App Service」を検索
   - 「+ 作成」→「Web アプリ」を選択

2. **基本タブ**

   - **サブスクリプション**: 使用するサブスクリプション
   - **リソース グループ**: 作成済みのリソースグループ
   - **名前**: `app-container-taro`
     - グローバルに一意（`https://app-container-taro.azurewebsites.net` になる）
   - **公開**: `Docker コンテナー`
   - **オペレーティング システム**: `Linux`
   - **リージョン**: `Japan East`
   - **App Service プラン**: 作成済みの Plan を選択

3. **Docker タブ**
   - **イメージ ソース**: `Azure Container Registry`
   - **レジストリ**: 作成した ACR を選択
   - **イメージ**: `sample-app`
   - **タグ**: `v1.0` または `v1.0-<your-name>`

---

## STEP 2-4: App Service の作成（CLI）- 1/2

CLI で App Service を作成する方法です。

```bash
# 変数設定
export APP_NAME="app-container-taro"  # グローバルに一意の名前

# App Service の作成
az webapp create \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --plan $PLAN_NAME \
  --deployment-container-image-name \
    $ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG

# 作成には1〜2分かかります
```

<div class="mt-4 bg-yellow-500/10 p-3 rounded text-xs">
⚠️ <strong>エラーが出る場合:</strong> App Service の名前が既に使用されている可能性があります。別の名前（例: `app-container-taro-20251022`）を試してください。
</div>

---

## STEP 2-5: App Service の作成（CLI）- 2/2

ACR 認証を設定して、イメージを取得できるようにします。<br/>
パスワードを使わず、Managed Identity で ACR にアクセスする方法です。（推奨）

```bash
# App Service の System Managed Identity を有効化
az webapp identity assign \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP

# Managed Identity の Object ID を取得
export IDENTITY_PRINCIPAL_ID=$(az webapp identity show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query principalId \
  --output tsv)

# ACR へのアクセス権限を付与
az role assignment create \
  --assignee $IDENTITY_PRINCIPAL_ID \
  --role "AcrPull" \
  --scope $(az acr show --name $ACR_NAME --query id --output tsv)

# App Service の設定を更新
az webapp config set \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --generic-configurations '{"acrUseManagedIdentityCreds": true}'
```

<div class="mt-4 bg-green-500/10 p-3 rounded text-xs">
✅ <strong>本番環境推奨:</strong> Managed Identity を使うことで、パスワード管理が不要になり、セキュリティが向上します。
</div>

---

## パスワードを使った認証（参考）

こちらは先ほどの認証方法とは異なったパスワードを使った認証方法です。

```bash
# ACR の認証情報を取得
export ACR_USERNAME=$(az acr credential show \
  --name $ACR_NAME \
  --query username \
  --output tsv)

export ACR_PASSWORD=$(az acr credential show \
  --name $ACR_NAME \
  --query passwords[0].value \
  --output tsv)

# App Service に ACR 認証情報を設定
az webapp config container set \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --docker-custom-image-name $ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG \
  --docker-registry-server-url https://$ACR_NAME.azurecr.io \
  --docker-registry-server-user $ACR_USERNAME \
  --docker-registry-server-password $ACR_PASSWORD

# 作成確認
az webapp show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "{Name:name, State:state, DefaultHostName:defaultHostName}" \
  --output table
```

---

## STEP 2-6: コンテナポート設定

App Service にコンテナがリッスンしているポートを教えます。

```bash
# WEBSITES_PORT 環境変数を設定
az webapp config appsettings set \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --settings WEBSITES_PORT=3000

# 設定確認
az webapp config appsettings list \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "[?name=='WEBSITES_PORT']" \
  --output table
```

**期待される出力:**

```
Name           Value   SlotSetting
-------------  ------  -------------
WEBSITES_PORT  3000    False
```

<div class="mt-4 bg-blue-500/10 p-3 rounded text-xs">
💡 <strong>ポイント:</strong> サンプルアプリはポート 3000 でリッスンしているため、`WEBSITES_PORT=3000` を設定します。Dockerfile の `EXPOSE` とは別に設定が必要です。
</div>

---

## STEP 2-7: アプリケーションの起動確認

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

#### ブラウザでアクセス

```bash
# アプリケーションのURLを取得
az webapp show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query defaultHostName \
  --output tsv
# 出力例
# app-container-taro.azurewebsites.net

# ブラウザで開く
echo "https://$(az webapp show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query defaultHostName \
  --output tsv)"
# 期待される出力（ブラウザ）:**
# {
#  "message": "Hello from Container!",
#  "hostname": "abc123",
#  "timestamp": "2025-10-21T..."
# }
```

</div>
<div>

#### curl でアクセス

```bash
# curl でテスト
curl https://$(az webapp show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query defaultHostName \
  --output tsv)

# ヘルスチェックエンドポイント
curl https://$(az webapp show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query defaultHostName \
  --output tsv)/health

# 期待される出力
{"status":"healthy"}
```

</div>
</div>
<div class="mt-4 bg-yellow-500/10 p-3 rounded text-xs">
⚠️ <strong>初回起動:</strong> 最初のアクセス時は、コンテナの起動に 1〜2 分かかる場合があります。503 エラーが出る場合は、少し待ってから再度アクセスしてください。
</div>

---

## STEP 2-8: デプロイログの確認

コンテナの起動状況をログで確認します。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">
<div>

### Portal でのログ確認

1. **App Service を開く**

   - 作成した App Service リソースを開く

2. **ログ ストリームを開く**

   - 左メニューの「監視」→「ログ ストリーム」
   - 「アプリケーション ログ」を選択

3. **ログの確認**
   - コンテナの起動ログが表示される
   - エラーがないか確認

</div>
<div>

### CLI でのログ確認

```bash
# ログストリームをリアルタイムで表示
az webapp log tail \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP

# 起動ログの例
2025-10-21T... Pulling image...
2025-10-21T... Successfully pulled image
2025-10-21T... Starting container...
2025-10-21T... Server running on port 3000
2025-10-21T... Container started successfully

# Ctrl+C で終了
```

**正常な起動ログの例:**

```
Starting container...
Server running on port 3000
```

</div>
</div>

---

## STEP 2-9: コンテナログの有効化

アプリケーションのログを保存・確認できるようにします。

```bash
# アプリケーションログを有効化
az webapp log config \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --application-logging filesystem \
  --level information

# Web サーバーログを有効化
az webapp log config \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --web-server-logging filesystem

# Docker コンテナログを有効化
az webapp log config \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --docker-container-logging filesystem

# 設定確認
az webapp log show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --output table
```

---

## STEP 2-10: トラブルシューティング

デプロイ時によくある問題と対処法です。

<div class="grid grid-cols-2 gap-6">
<div>

**1. 503 Service Unavailable**

```
原因: コンテナが起動していない、または起動に失敗している
```

**解決策**

- ログストリームで起動ログを確認: `az webapp log tail`
- `WEBSITES_PORT` が正しく設定されているか確認
- コンテナイメージが正常にプルできているか確認
- ACR 認証情報が正しいか確認

**2. Container didn't respond to HTTP pings**

```
原因: コンテナはポート 80/443 でヘルスチェックを受け取れていない
```

**解決策**

- `WEBSITES_PORT` 環境変数を設定
- コンテナが `0.0.0.0` でリッスンしているか確認（`localhost` では不可）
- 起動に 230 秒以上かかっていないか確認

</div>
<div>

**3. Image pull failed**

```
原因: ACR からイメージをプルできない
```

**解決策**

- ACR 認証情報を再設定
- イメージ名・タグが正しいか確認: `az acr repository show-tags`
- Managed Identity の権限を確認

</div>
</div>

---

## STEP 2-11: 動作確認のためのテストコマンド集

デプロイが成功したことを確認するための便利なコマンドです。

```bash
# 1. App Service の状態確認
az webapp show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "{Name:name, State:state, URL:defaultHostName}" \
  --output table

# 2. アプリケーションへのHTTPリクエスト
curl -s https://$(az webapp show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query defaultHostName \
  --output tsv) | jq .

# 3. ヘルスチェック
curl -s https://$(az webapp show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query defaultHostName \
  --output tsv)/health | jq .

# 4. コンテナイメージの確認
az webapp config container show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "[].{Image:value}" \
  --output table

# 5. 環境変数の確認
az webapp config appsettings list \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --output table
```

---

## ハンズオン ② のまとめ

<div class="grid grid-cols-2 gap-6">
<div>

### ✅ 達成したこと

- ✅ App Service Plan の作成
- ✅ App Service の作成
- ✅ ACR 認証の設定
- ✅ コンテナイメージのデプロイ
- ✅ ポート設定の構成
- ✅ ログの有効化と確認
- ✅ アプリケーションの動作確認

</div>
<div>

### 🔑 重要なポイント

- **App Service Plan**
  - アプリが実行されるコンピューティングリソース
  - CPU・メモリ・ストレージを提供
- **グローバルに一意の名前**
  - 既存の名前と重複不可
- **WEBSITES_PORT**
  - コンテナがリッスンするポートを明示
  - 必須設定
- **ACR 認証**
  - パスワード方式と Managed Identity
  - 本番は Managed Identity 推奨
- **初回起動時間**
  - 1〜2 分かかる場合あり

</div>
</div>
<div class="mt-4 bg-green-500/10 p-3 rounded text-sm">
✅ <strong>次のステップ:</strong> コンテナの詳細設定（環境変数、スタートアップコマンドなど）を学びます。
</div>
