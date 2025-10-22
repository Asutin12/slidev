---
layout: center
---

# ⚙️ ハンズオン ③

コンテナ構成の詳細設定

---

## ハンズオン ③ の概要

コンテナの詳細な設定方法を学びます。

<div class="pt-6">

### 🎯 学習目標

- 環境変数と App Settings の違いを理解する
- ポート設定の仕組みを学ぶ
- スタートアップコマンドの使い方を習得する
- 複数コンテナ（Docker Compose）の構成を理解する

### 📋 実施内容

1. **環境変数の設定** - アプリケーション設定の管理
2. **ポート設定の詳細** - WEBSITES_PORT の理解
3. **スタートアップコマンド** - コンテナ起動時の制御
4. **複数コンテナ構成** - Docker Compose の利用（Advanced）
5. **再起動とデプロイの挙動** - 運用時の動作理解

</div>

---

## 環境変数と App Settings の違い

App Service には複数の設定方法があります。違いを理解しましょう。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">
<div>

### App Settings（推奨）

**Azure 側で管理する環境変数**

- Portal または CLI で設定
- コンテナに環境変数として渡される
- **再起動が必要**
- Key Vault 参照が可能
- スロットごとに設定可能

```bash
# App Settings の設定
az webapp config appsettings set \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --settings \
    NODE_ENV=production \
    API_KEY=@Microsoft.KeyVault(...)
```

</div>
<div>

### Dockerfile の ENV

**イメージに焼き込む環境変数**

- Dockerfile で定義
- イメージ再ビルドが必要
- **動的な変更不可**
- 機密情報は含めない

```dockerfile
# Dockerfile
# デフォルト値を設定
ENV NODE_ENV=development
ENV PORT=3000
```

**App Settings で上書き可能**

</div>
</div>
<div class="mt-4 bg-blue-500/10 p-3 rounded text-xs">
💡 <strong>ベストプラクティス:</strong> Dockerfile には デフォルト値、App Settings には環境固有の値（本番APIキーなど）を設定します。
</div>

---

## STEP 3-1: 環境変数の設定（Portal）

1. **App Service を開く**

   - 作成した App Service リソースを開く

2. **構成ページを開く**

   - 左メニューの「設定」→「構成」

3. **アプリケーション設定の追加**

   - 「+ 新しいアプリケーション設定」をクリック
   - **名前**: `NODE_ENV`
   - **値**: `production`
   - 「OK」をクリック

4. **追加の設定**

   - `LOG_LEVEL`: `info`
   - `API_BASE_URL`: `https://api.example.com`
   - `MAX_CONNECTIONS`: `100`

5. **保存**
   - 上部の「保存」をクリック
   - 「続行」を選択（アプリが再起動されます）

---

## STEP 3-2: 環境変数の設定（CLI）

CLI で一括設定する方法です。

```bash
# 複数の環境変数を一度に設定
az webapp config appsettings set \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --settings \
    NODE_ENV=production \
    LOG_LEVEL=info \
    API_BASE_URL=https://api.example.com \
    MAX_CONNECTIONS=100 \
    WEBSITES_PORT=3000

# 設定確認
az webapp config appsettings list \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --output table

# 特定の設定のみ確認
az webapp config appsettings list \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "[?name=='NODE_ENV' || name=='LOG_LEVEL']" \
  --output table
# **期待される出力:**
# Name          Value          SlotSetting
# ------------  -------------  -------------
# NODE_ENV      production     False
# LOG_LEVEL     info           False
# ...
```

---

## STEP 3-3: アプリケーションで環境変数を使用

サンプルアプリを更新して、環境変数を読み込むようにします。

```javascript
// app.js
const express = require("express");
const app = express();

// 環境変数から設定を読み込み
const port = process.env.PORT || process.env.WEBSITES_PORT || 3000;
const nodeEnv = process.env.NODE_ENV || "development";
const logLevel = process.env.LOG_LEVEL || "info";
const apiBaseUrl = process.env.API_BASE_URL || "http://localhost:8080";

app.get("/", (req, res) => {
  res.json({
    message: "Hello from Container!",
    environment: nodeEnv,
    logLevel: logLevel,
    apiBaseUrl: apiBaseUrl,
    hostname: require("os").hostname(),
    timestamp: new Date().toISOString(),
  });
});

app.get("/env", (req, res) => {
  // 設定情報を表示（機密情報は除外）
  res.json({
    NODE_ENV: process.env.NODE_ENV,
    LOG_LEVEL: process.env.LOG_LEVEL,
    API_BASE_URL: process.env.API_BASE_URL,
    // パスワードやAPIキーは含めない
  });
});

app.listen(port, "0.0.0.0", () => {
  console.log(`Server running on port ${port} (${nodeEnv} mode)`);
});
```

---

## STEP 3-4: 更新されたイメージのデプロイ

アプリケーションを更新し、新しいイメージをデプロイします。

```bash
# サンプルアプリのディレクトリに移動
cd container-handson

# 新しいバージョンとしてビルド
export IMAGE_TAG="v1.1"

docker buildx build --platform linux/amd64 -t $IMAGE_NAME:$IMAGE_TAG .

# ACR にプッシュ
docker tag $IMAGE_NAME:$IMAGE_TAG \
  $ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG

docker push $ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG

# App Service のイメージを更新
az webapp config container set \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --docker-custom-image-name $ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG

# App Service を再起動
az webapp restart \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP
```

---

## STEP 3-5: ポート設定の詳細

<div class="grid grid-cols-2 gap-6">
<div>

### なぜ必要なのか

**App Service の動作:**

1. コンテナを起動
2. ヘルスチェック（HTTP ping）を送信
3. **どのポートに送るべきか？**

**デフォルトの挙動:**

- Dockerfile の `EXPOSE` を確認
- なければポート 80 を試行
- 複数の `EXPOSE` がある場合は最初のもの

**問題:**

- Dockerfile の `EXPOSE` は documentation のみ
- 実際のポートと異なる場合がある

**解決策:**

- `WEBSITES_PORT` で明示的に指定

</div>
<div>

### 設定例

```bash
# Node.js アプリ（ポート3000）
az webapp config appsettings set \
  --settings WEBSITES_PORT=3000

# Python Flask（ポート5000）
az webapp config appsettings set \
  --settings WEBSITES_PORT=5000

# Go アプリ（ポート8080）
az webapp config appsettings set \
  --settings WEBSITES_PORT=8080
```

**確認方法:**

```bash
# ログで確認
az webapp log tail \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP

# 正常な場合
Container started successfully
HTTP Requests to port 3000
```

</div>
</div>

---

## スタートアップコマンドの設定（参考）

コンテナ起動時のコマンドをカスタマイズします。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">
<div>

### Portal での設定

1. **App Service を開く**
2. **構成 → 全般設定**
3. **スタートアップ コマンド** に入力:
   ```bash
   npm run start:prod
   ```
4. **保存**

</div>
<div>

### CLI での設定

```bash
# スタートアップコマンドの設定
az webapp config set \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --startup-file "npm run start:prod"

# 設定確認
az webapp config show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "appCommandLine" \
  --output tsv
```

</div>
</div>
<div class="mt-4 bg-yellow-500/10 p-3 rounded text-xs">
⚠️ <strong>注意:</strong> スタートアップコマンドは Dockerfile の `CMD` を上書きします。複雑なコマンドは、シェルスクリプトにまとめることを推奨します。
</div>

---

## スタートアップスクリプトの活用（参考）

複雑な初期化処理をスクリプトにまとめます。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">
<div>

**startup.sh**

```bash
#!/bin/sh
set -e

echo "Starting application..."

# データベース マイグレーション
if [ "$RUN_MIGRATIONS" = "true" ]; then
  echo "Running database migrations..."
  npm run migrate
fi

# キャッシュのウォームアップ
if [ "$WARM_CACHE" = "true" ]; then
  echo "Warming up cache..."
  npm run cache:warm
fi

# アプリケーション起動
echo "Starting Node.js application..."
exec npm start
```

</div>
<div>

**Dockerfile に追加**

```dockerfile
FROM node:20-alpine

WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY . .

# スタートアップスクリプトをコピー
COPY startup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/startup.sh

CMD ["startup.sh"]
```

**App Settings で制御**

```bash
az webapp config appsettings set \
  --settings \
    RUN_MIGRATIONS=true \
    WARM_CACHE=false
```

</div>
</div>

---

## 複数コンテナ構成 - Docker Compose（参考）

Web + Redis のような複数コンテナ構成を実現します。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">
<div>

**docker-compose.yml**

```yaml
version: "3.8"
services:
  web:
    image: ${ACR_NAME}.azurecr.io/sample-app:v1.1
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - REDIS_HOST=redis
      - REDIS_PORT=6379
    depends_on:
      - redis

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis-data:/data

volumes:
  redis-data:
```

</div>
<div>

**App Service での設定（CLI）**

```bash
# Docker Compose ファイルをBase64エンコード
export COMPOSE_FILE_CONTENT=$(cat docker-compose.yml | base64 -w 0)

# App Service に設定
az webapp config container set \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --multicontainer-config-type compose \
  --multicontainer-config-file docker-compose.yml
```

</div>
</div>

---

## STEP 3-6: 再起動とデプロイの挙動

App Service の再起動とデプロイの違いを理解します。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">
<div>

### 再起動（Restart）

**動作:**

- 現在のコンテナを停止
- 同じイメージで再起動
- 環境変数の変更を反映

```bash
az webapp restart \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP
```

**使用タイミング:**

- App Settings 変更後
- アプリケーションが応答しない
- メモリリークのクリア

**ダウンタイム:**

- あり（数秒〜数十秒）

</div>
<div>

### 停止・開始

**停止:**

```bash
az webapp stop \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP
```

**開始:**

```bash
az webapp start \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP
```

**使用タイミング:**

- メンテナンス中
- コスト削減（停止中は課金継続）

**ダウンタイム:**

- あり（停止期間中）

</div>
</div>

---

## STEP 3-7: 継続的デプロイの設定

ACR の Webhook を使って自動デプロイを設定します。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">
<div>

```bash
# App Service の Webhook URL を取得
export WEBHOOK_URL=$(az webapp deployment container config \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --enable-cd true \
  --query "CI_CD_URL" \
  --output tsv)

# ACR に Webhook を作成
az acr webhook create \
  --name appServiceWebhook \
  --registry $ACR_NAME \
  --uri $WEBHOOK_URL \
  --actions push \
  --scope "$IMAGE_NAME:*"

# Webhook の確認
az acr webhook list \
  --registry $ACR_NAME \
  --output table
```

</div>
<div>

**動作:**

1. イメージを ACR にプッシュ
2. Webhook が App Service に通知
3. App Service が自動的に新しいイメージをプル・デプロイ

</div>
</div>

---

## STEP 3-8: デプロイ動作の確認

Webhook が正しく動作するか確認します。

```bash
# 新しいバージョンをビルド・プッシュ
export IMAGE_TAG="v1.2"

docker buildx build --platform linux/amd64 -t $IMAGE_NAME:$IMAGE_TAG .
docker tag $IMAGE_NAME:$IMAGE_TAG \
  $ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG
docker push $ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG

# ログストリームで自動デプロイを確認
az webapp log tail \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP
# 期待されるログ
# Webhook triggered by ACR push
# Pulling new image...
# Restarting container...
# Container started successfully
```

<div class="mt-4 bg-green-500/10 p-3 rounded text-xs">
✅ <strong>自動デプロイ完了:</strong> これで、ACR にイメージをプッシュするだけで自動的にデプロイされるようになりました。
</div>

---

## STEP 3-9: トラブルシューティング

**1. 環境変数が反映されない**

```
原因: App Service を再起動していない
```

**解決策:**

- 設定変更後は必ず再起動: `az webapp restart`

**2. スタートアップコマンドが実行されない**

```
原因: コマンドの構文エラー
```

**解決策:**

- ログで確認: `az webapp log tail`
- シェルスクリプトの場合は `#!/bin/sh` を追加
- 実行権限を確認: `chmod +x script.sh`

**3. 複数コンテナでネットワーク接続できない**

```
原因: サービス名の解決ができていない
```

**解決策:**

- Docker Compose の `services` 名を使用
- `depends_on` で起動順序を制御
- ログで接続エラーを確認

---

## ハンズオン ③ のまとめ

<div class="grid grid-cols-2 gap-6">
<div>

### ✅ 達成したこと

- ✅ 環境変数と App Settings の理解
- ✅ ポート設定の仕組みを学習
- ✅ スタートアップコマンドの活用
- ✅ 複数コンテナ構成の理解
- ✅ 継続的デプロイの設定
- ✅ 再起動・デプロイの挙動理解

</div>
<div>

### 🔑 重要なポイント

- **App Settings 推奨**
  - 環境ごとに異なる値
  - Key Vault 参照可能
- **WEBSITES_PORT 必須**
  - コンテナのリッスンポートを明示
- **スタートアップスクリプト**
  - 複雑な初期化はスクリプト化
- **Webhook 自動デプロイ**
  - ACR プッシュで自動更新
- **再起動必要な変更**
  - App Settings
  - コンテナイメージ

</div>
</div>
<div class="mt-4 bg-green-500/10 p-3 rounded text-sm">
✅ <strong>次のステップ:</strong> スケーリング設定とパフォーマンス最適化を学びます。
</div>
