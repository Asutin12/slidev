---
layout: center
---

# ⚡ ハンズオン ①

環境準備

---

## ハンズオン ① の概要

このハンズオンでは、App Service for Containers を使用するための環境を準備します。

<div class="pt-6">

### 🎯 学習目標

- リソースグループの作成方法を理解する
- Azure Container Registry (ACR) の作成と設定を学ぶ
- サンプルアプリをコンテナ化してプッシュする
- コンテナイメージの管理方法を習得する

### 📋 実施内容

1. **リソースグループの作成** - すべてのリソースを格納するグループ
2. **ACR の作成** - Docker イメージを保管するレジストリ
3. **サンプルアプリの準備** - シンプルな Node.js/Go アプリ
4. **イメージのビルドとプッシュ** - ACR へのアップロード

</div>

---

## STEP 1-1: リソースグループの作成（Portal）

すべてのリソースを格納するリソースグループを作成します。

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
   - **リソース グループ**: `rg-container-handson`
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
export RESOURCE_GROUP="rg-container-handson"
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
Name                     Location
-----------------------  ----------
rg-container-handson     japaneast
```

</div>

</div>

---

## STEP 1-2: Azure Container Registry の作成（Portal）

<div class="text-sm">

1. **ACR の検索**

   - Azure Portal で「コンテナー レジストリ」を検索
   - 「+ 作成」をクリック

2. **基本タブの設定**

   - **サブスクリプション**: 使用するサブスクリプション
   - **リソース グループ**: 作成したリソースグループ
   - **レジストリ名**: `acr-handson-<unique-id>`
     - 例: `acr-handson-taro`
     - 英数字のみ、グローバルに一意
   - **場所**: `Japan East`
   - **SKU**: `Basic`（¥500/月、10GB ストレージ）

3. **ネットワーク タブ**

   - デフォルト設定のまま（パブリック アクセス）

4. **確認および作成**
   - 設定を確認して「作成」をクリック

</div>

<div class="mt-4 bg-yellow-500/10 p-3 rounded text-xs">
⚠️ <strong>複数人で実施する場合:</strong> ACR は1つを全員で共有することを推奨します。チームリーダーが1つ作成し、他のメンバーは同じACRを使用します。
</div>

---

## STEP 1-3: Azure Container Registry の作成（CLI）

```bash
# 変数設定
export ACR_NAME="acr-handson-taro"  # ユニークな名前に変更
export SKU="Basic"
export LOCATION="japaneast"
export RESOURCE_GROUP="resource-group" # 作成したリソースグループ名

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
Name                LoginServer                      Sku
------------------  -------------------------------  -----
acr-handson-taro  acr-handson-taro.azurecr.io    Basic
```

<div class="mt-4 bg-blue-500/10 p-3 rounded text-xs">
💡 <strong>ログインサーバー名:</strong> `acr-handson-taro.azurecr.io` が Docker イメージのプッシュ/プル時に使用するアドレスです。
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
# 管理者ユーザーの有効化
az acr update \
  --name $ACR_NAME \
  --admin-enabled true

# 認証情報の取得
az acr credential show \
  --name $ACR_NAME \
  --resource-group $RESOURCE_GROUP \
  --output table

# 期待される出力
Username            Password                          Password2
------------------  --------------------------------  --------------------------------
acr-handson-taro  <password>                        <password2>

# Docker ログイン
az acr login --name $ACR_NAME

# 成功メッセージ
Login Succeeded
```

</div>
</div>

---

## STEP 1-6: サンプルアプリの準備①

シンプルな Node.js Web アプリケーションを用意します。

<div class="grid grid-cols-2 gap-6 pt-4 text-xs">
<div>

**app.js**

```javascript
const express = require("express");
const app = express();
const port = process.env.PORT || 3000;

app.get("/", (req, res) => {
  res.json({
    message: "Hello from Container!",
    hostname: require("os").hostname(),
    timestamp: new Date().toISOString(),
  });
});

app.get("/health", (req, res) => {
  res.json({ status: "healthy" });
});

app.listen(port, "0.0.0.0", () => {
  console.log(`Server running on port ${port}`);
});
```

</div>
<div>

**package.json**

```json
{
  "name": "container-app",
  "version": "1.0.0",
  "main": "app.js",
  "dependencies": {
    "express": "^4.18.0"
  },
  "scripts": {
    "start": "node app.js"
  }
}
```

</div>
</div>

---

## STEP 1-7: サンプルアプリの準備②

<div class="grid grid-cols-2 gap-6 pt-4 text-xs">
<div>

### Dockerfile

```dockerfile
FROM node:20-alpine

WORKDIR /app

# 依存関係のコピーとインストール
COPY package*.json ./
RUN npm install --production

# アプリケーションコードのコピー
COPY . .

# ポート公開
EXPOSE 3000

# ヘルスチェック
HEALTHCHECK --interval=30s --timeout=3s \
  CMD node -e "require('http').get('http://localhost:3000/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# アプリケーション起動
CMD ["npm", "start"]
```

</div>
<div>

**ディレクトリ構造:**

```
sample-app/
├── app.js
├── package.json
└── Dockerfile
```

</div>
</div>

---

## STEP 1-7: サンプルアプリをCLIで作成

```bash
# 作業ディレクトリを作成
mkdir container-handson
cd container-handson

# app.js を作成
cat > app.js << 'EOF'
const express = require("express");
const app = express();
const port = process.env.PORT || 3000;

app.get("/", (req, res) => {
  res.json({
    message: "Hello from Container!",
    hostname: require("os").hostname(),
    timestamp: new Date().toISOString(),
  });
});

app.get("/health", (req, res) => {
  res.json({ status: "healthy" });
});

app.listen(port, "0.0.0.0", () => {
  console.log(`Server running on port ${port}`);
});
EOF

# package.json を作成
cat > package.json << 'EOF'
{
  "name": "container-app",
  "version": "1.0.0",
  "main": "app.js",
  "dependencies": {
    "express": "^4.18.0"
  },
  "scripts": {
    "start": "node app.js"
  }
}
EOF

# Dockerfile を作成
cat > Dockerfile << 'EOF'
FROM node:20-alpine

WORKDIR /app

# 依存関係のコピーとインストール
COPY package*.json ./
RUN npm install --production

# アプリケーションコードのコピー
COPY . .

# ポート公開
EXPOSE 3000

# ヘルスチェック
HEALTHCHECK --interval=30s --timeout=3s \
  CMD node -e "require('http').get('http://localhost:3000/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# アプリケーション起動
CMD ["npm", "start"]
EOF
```

---

## STEP 1-8: Docker イメージのビルド

サンプルアプリを Docker イメージとしてビルドします。

```bash
# 変数設定（各自の名前に変更）
export IMAGE_NAME="sample-app"
export IMAGE_TAG="v1.0"

# イメージのビルド（ローカル）
docker buildx build --platform linux/amd64 -t $IMAGE_NAME:$IMAGE_TAG .

# ビルド確認
docker images | grep $IMAGE_NAME
# 期待される出力
# sample-app   v1.0   abc123def456   1 minute ago   150MB

# ローカルでテスト実行（任意）
docker run -d -p 8080:3000 --name test-app $IMAGE_NAME:$IMAGE_TAG

# 動作確認
curl http://localhost:8080
# {"message":"Hello from Container!","hostname":"abc123","timestamp":"..."}

# コンテナ停止・削除
docker stop test-app
docker rm test-app
```

---

## STEP 1-9: ACR へのイメージプッシュ

ビルドしたイメージを ACR にプッシュします。

```bash
# ACR ログイン（まだの場合）
az acr login --name $ACR_NAME

# イメージにACRタグを付与
docker tag $IMAGE_NAME:$IMAGE_TAG \
  $ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG

# ACR へプッシュ
docker push $ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG

# プッシュ確認
az acr repository list \
  --name $ACR_NAME \
  --output table
# 期待される出力
# Result
# ----------
# sample-app

# タグ確認
az acr repository show-tags \
  --name $ACR_NAME \
  --repository $IMAGE_NAME \
  --output table

# 期待される出力
# Result
# ------
# v1.0
```

---

## STEP 1-10: ACR Build を使った代替方法（Advanced）

ローカルで Docker を使わず、ACR 上で直接ビルドすることもできます。

```bash
# ACR Build を使用（Dockerfileがあるディレクトリで実行）
az acr build \
  --registry $ACR_NAME \
  --image $IMAGE_NAME:$IMAGE_TAG \
  --file Dockerfile \
  .

# ビルド状況がリアルタイムで表示される
# 完了後、自動的にACRにプッシュされる

# 確認
az acr repository show-tags \
  --name $ACR_NAME \
  --repository $IMAGE_NAME \
  --output table
```

<div class="grid grid-cols-2 gap-4 text-xs">
<div class="bg-green-500/10 p-3 rounded">

**メリット**

- ローカルに Docker 不要
- ビルドが ACR 上で実行される
- CI/CD に組み込みやすい

</div>
<div class="bg-yellow-500/10 p-3 rounded">

**デメリット**

- ローカルでのテストができない
- ビルドに時間がかかる場合あり
- 追加コスト（ビルド時間分）

</div>
</div>

---

## STEP 1-11: トラブルシューティング

環境準備時によくある問題と対処法です。

**1. ACR ログインに失敗する**

```bash
Error: UNAUTHORIZED: authentication required
```

**解決策:**

- 管理者ユーザーが有効になっているか確認
- `az acr login --name <acr-name>` を再実行
- Azure CLI でログインしているか確認: `az account show`

**2. Docker イメージのプッシュが遅い**

**解決策:**

- `.dockerignore` ファイルを作成して不要なファイルを除外
- マルチステージビルドを使用してイメージサイズを削減

**3. ACR の容量不足**

**解決策:**

- Basic tier は 10GB まで
- 不要なイメージを削除: `az acr repository delete`
- 必要に応じて Standard tier にアップグレード

---

## ハンズオン ① のまとめ

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">
<div>

### ✅ 達成したこと

- ✅ リソースグループの作成
- ✅ Azure Container Registry の作成
- ✅ サンプルアプリの準備
- ✅ Docker イメージのビルド
- ✅ ACR へのイメージプッシュ

</div>
<div>

### 🔑 重要なポイント

- **ACR の役割**
  - Docker イメージの保管場所
  - App Service からイメージを取得
- **グローバルに一意な名前**
  - ACR、App Service は一意の名前が必要
  - 既存の名前と衝突しないよう注意
- **管理者認証**
  - ハンズオンでは管理者認証で簡単に
  - 本番環境は Managed Identity 推奨
- **ログインサーバー名**
  - `<acr-name>.azurecr.io`
  - App Service で使用

</div>
</div>

<div class="mt-4 bg-green-500/10 p-3 rounded text-sm">
✅ <strong>次のステップ:</strong> 準備したイメージを使って、App Service for Containers にデプロイします。
</div>
