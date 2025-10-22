---
layout: center
---

# 📊 ハンズオン ⑥

運用・監視・トラブルシューティング

---

## ハンズオン ⑥ の概要

App Service の運用に必要な監視とトラブルシューティングを学びます。

<div class="pt-6">

### 🎯 学習目標

- ログの種類と違いを理解する
- Log Stream でリアルタイム監視する方法を学ぶ
- Application Insights の活用方法を習得する
- Container Crash Loop の対策を理解する

### 📋 実施内容

1. **ログの種類** - Application / Container / Web Server Logs
2. **Log Stream** - リアルタイムログ監視
3. **Application Insights** - 詳細な監視と診断
4. **トラブルシューティング** - よくある問題と対処法
5. **アラート設定** - 障害検知と通知

</div>

---

## ログの種類と違い

App Service には 3 種類のログがあります。

<div class="grid grid-cols-3 gap-4 pt-4 text-xs">

<div class="bg-blue-500/10 p-3 rounded">

### Application Logs

**内容:**

- アプリケーションが出力するログ
- `console.log()`, `print()` など
- アプリケーションエラー

**用途:**

- デバッグ
- ビジネスロジックの追跡

**例:**

```
2025-10-21 10:30:15
Server running on port 3000
User login: user@example.com
```

</div>

<div class="bg-green-500/10 p-3 rounded">

### Container Logs

**内容:**

- Docker コンテナの起動ログ
- イメージのプル
- コンテナの起動・停止

**用途:**

- デプロイ確認
- コンテナ起動トラブル

**例:**

```
Pulling image from ACR...
Successfully pulled image
Starting container...
Container started successfully
```

</div>

<div class="bg-orange-500/10 p-3 rounded">

### Web Server Logs

**内容:**

- HTTP リクエスト・レスポンス
- ステータスコード
- レスポンスタイム

**用途:**

- トラフィック分析
- パフォーマンス監視

**例:**

```
GET / 200 0.123s
POST /api/data 201 0.456s
GET /health 200 0.012s
```

</div>

</div>

---

## STEP 6-1: ログの有効化

3 種類すべてのログを有効にします。

```bash
# Application Logs を有効化（ファイルシステム）
az webapp log config \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --application-logging filesystem \
  --level information

# Docker Container Logs を有効化
az webapp log config \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --docker-container-logging filesystem

# Web Server Logs を有効化
az webapp log config \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --web-server-logging filesystem

# 設定確認
az webapp log show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --output table
```

---

## STEP 6-2: Log Stream でリアルタイム監視

ログをリアルタイムで表示します。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">

<div>

### CLI でのログストリーム

```bash
# すべてのログをストリーム
az webapp log tail \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP

# アプリケーションログのみ
az webapp log tail \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --filter application

# コンテナログのみ
az webapp log tail \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --filter docker

# Ctrl+C で終了
```

</div>

<div>

### Portal でのログストリーム

1. **App Service を開く**

2. **ログ ストリームを開く**

   - 左メニューの「監視」→「ログ ストリーム」

3. **ログの種類を選択**

   - アプリケーション ログ
   - Web サーバー ログ

4. **リアルタイムで表示**
   - 新しいリクエストが来るたびに表示
   - デバッグに便利

</div>

</div>

---

## STEP 6-3: ログのダウンロード

過去のログをダウンロードして分析します。

```bash
# ログファイルを ZIP でダウンロード
az webapp log download \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --log-file app-logs.zip

# ZIP を展開
unzip app-logs.zip -d app-logs

# ログファイルの確認
ls -R app-logs/

# ディレクトリ構造の例
app-logs/
├── LogFiles/
│   ├── Application/  # アプリケーションログ
│   ├── kudu/         # デプロイログ
│   └── http/         # HTTPログ

# ログ内容を確認
cat app-logs/LogFiles/Application/*.log
```

---

## STEP 6-4: Application Insights の作成

より詳細な監視のために Application Insights を設定します。

```bash
# Application Insights の作成
az monitor app-insights component create \
  --app $APP_NAME-insights \
  --location $LOCATION \
  --resource-group $RESOURCE_GROUP \
  --application-type web

# Connection String を取得
export APPINSIGHTS_CONNECTION_STRING=$(az monitor app-insights component show \
  --app $APP_NAME-insights \
  --resource-group $RESOURCE_GROUP \
  --query connectionString \
  --output tsv)

echo "Connection String: $APPINSIGHTS_CONNECTION_STRING"

# Instrumentation Key を取得（後方互換性用）
export APPINSIGHTS_INSTRUMENTATION_KEY=$(az monitor app-insights component show \
  --app $APP_NAME-insights \
  --resource-group $RESOURCE_GROUP \
  --query instrumentationKey \
  --output tsv)

echo "Instrumentation Key: $APPINSIGHTS_INSTRUMENTATION_KEY"
```

---

## STEP 6-5: App Service に Application Insights を統合

App Service から Application Insights にデータを送信します。

```bash
# App Settings に Application Insights の設定を追加
az webapp config appsettings set \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --settings \
    APPINSIGHTS_INSTRUMENTATIONKEY=$APPINSIGHTS_INSTRUMENTATION_KEY \
    APPLICATIONINSIGHTS_CONNECTION_STRING=$APPINSIGHTS_CONNECTION_STRING \
    ApplicationInsightsAgent_EXTENSION_VERSION=~3

# 設定確認
az webapp config appsettings list \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "[?contains(name, 'APPINSIGHTS') || contains(name, 'APPLICATION')]" \
  --output table

# App Service を再起動して設定を反映
az webapp restart \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP
```

<div class="mt-4 bg-green-500/10 p-3 rounded text-xs">
✅ <strong>設定完了:</strong> 数分後に Application Insights のポータルでデータが表示されます。
</div>

---

## STEP 6-6: Application Insights でのデータ確認

Portal で監視データを確認します。

<div class="text-sm">

### Portal での確認

1. **Application Insights を開く**

   - Azure Portal で作成した Application Insights リソースを開く

2. **主要なメトリクスを確認**

   - **概要** ページ
     - サーバー リクエスト数
     - 平均応答時間
     - 失敗したリクエスト数
     - 可用性

3. **詳細な分析**
   - **パフォーマンス**: 遅いリクエストの特定
   - **失敗**: エラーの詳細
   - **ライブ メトリック**: リアルタイムデータ
   - **トランザクション検索**: 個別リクエストの追跡

</div>

---

## STEP 6-7: Kusto クエリでログ分析

Application Insights のログを KQL で分析します。

<div class="text-xs">

```kusto
// 過去1時間のリクエスト数
requests
| where timestamp > ago(1h)
| summarize count() by bin(timestamp, 5m)
| render timechart

// 遅いリクエストの特定（500ms以上）
requests
| where duration > 500
| project timestamp, name, url, duration
| order by duration desc

// エラーレートの計算
requests
| where timestamp > ago(1h)
| summarize
    Total = count(),
    Failed = countif(success == false)
| extend ErrorRate = (Failed * 100.0) / Total

// 最も多くリクエストされているエンドポイント
requests
| where timestamp > ago(24h)
| summarize count() by name
| order by count_ desc
| take 10

// 例外の詳細
exceptions
| where timestamp > ago(1h)
| project timestamp, type, outerMessage, innermostMessage
| order by timestamp desc
```

</div>

---

## STEP 6-8: Container Crash Loop の対策

コンテナが繰り返しクラッシュする問題の対処法です。

<div class="grid grid-cols-2 gap-6 pt-4 text-xs">

<div>

### よくある原因

1. **ポート設定ミス**

   ```bash
   # WEBSITES_PORT が未設定or間違い
   az webapp config appsettings set \
     --settings WEBSITES_PORT=3000
   ```

2. **起動タイムアウト**

   ```
   原因: 230秒以内に起動しない
   対策: 起動時間を短縮
   ```

3. **メモリ不足**

   ```bash
   # Plan をスケールアップ
   az appservice plan update --sku B2
   ```

4. **アプリケーションエラー**
   ```bash
   # ログで確認
   az webapp log tail
   ```

</div>

<div>

### 診断手順

**1. ログを確認**

```bash
az webapp log tail \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP

# エラーメッセージを探す
# "Container didn't respond..."
# "Application error"
# "Exit code: 1"
```

**2. ローカルで再現**

```bash
# 同じイメージをローカルで実行
docker run -p 8080:3000 \
  $ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG

# ログを確認
docker logs <container-id>
```

**3. ヘルスチェックを追加**

```javascript
app.get("/health", (req, res) => {
  res.status(200).json({ status: "healthy" });
});
```

</div>

</div>

---

## STEP 6-9: 診断とアラートの設定

問題を自動検知して通知します。

```bash
# ダウンタイムを検知するアラートルール
az monitor metrics alert create \
  --name "App Service Down" \
  --resource-group $RESOURCE_GROUP \
  --scopes $(az webapp show \
    --name $APP_NAME \
    --resource-group $RESOURCE_GROUP \
    --query id --output tsv) \
  --condition "avg Http5xx > 5" \
  --window-size 5m \
  --evaluation-frequency 1m \
  --description "Alert when HTTP 5xx errors exceed 5"

# 高CPU使用率を検知
az monitor metrics alert create \
  --name "High CPU Usage" \
  --resource-group $RESOURCE_GROUP \
  --scopes $(az appservice plan show \
    --name $PLAN_NAME \
    --resource-group $RESOURCE_GROUP \
    --query id --output tsv) \
  --condition "avg Percentage CPU > 80" \
  --window-size 5m \
  --evaluation-frequency 1m

# アラート一覧を確認
az monitor metrics alert list \
  --resource-group $RESOURCE_GROUP \
  --output table
```

---

## STEP 6-10: アクショングループの作成

アラート発生時の通知先を設定します。

```bash
# メール通知のアクショングループ
az monitor action-group create \
  --name "Email Admins" \
  --resource-group $RESOURCE_GROUP \
  --short-name "EmailAdm" \
  --email-receiver \
    name="Admin Email" \
    email-address="admin@example.com"

# アラートにアクショングループを関連付け
az monitor metrics alert update \
  --name "App Service Down" \
  --resource-group $RESOURCE_GROUP \
  --add-action $(az monitor action-group show \
    --name "Email Admins" \
    --resource-group $RESOURCE_GROUP \
    --query id --output tsv)

# Webhook 通知（Slack、Teams など）
az monitor action-group create \
  --name "Webhook Notifications" \
  --resource-group $RESOURCE_GROUP \
  --short-name "Webhook" \
  --webhook-receiver \
    name="Slack Webhook" \
    service-uri="https://hooks.slack.com/services/YOUR/WEBHOOK/URL"
```

---

## STEP 6-11: Availability Test（可用性テスト）

定期的に URL にアクセスして可用性を監視します。

<div class="text-sm">

### Portal での設定

1. **Application Insights を開く**

2. **可用性テストを作成**

   - 左メニューの「可用性」→「+ テストの追加」

3. **設定**

   - **テスト名**: `Homepage Availability`
   - **URL**: `https://$APP_NAME.azurewebsites.net`
   - **テストの頻度**: `5 分`
   - **テストの場所**: 複数のリージョンを選択
   - **成功の条件**: `HTTP 200`

4. **アラートルール**
   - 失敗が 2 つの場所で発生した場合に通知

</div>

<div class="mt-4 bg-blue-500/10 p-3 rounded text-xs">
💡 <strong>複数リージョン:</strong> 複数の場所からテストすることで、グローバルな可用性を確認できます。
</div>

---

## STEP 6-12: Diagnostic Settings（診断設定）

ログを Log Analytics ワークスペースに送信します。

```bash
# Log Analytics ワークスペースの作成
az monitor log-analytics workspace create \
  --workspace-name logs-container-handson \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION

# ワークスペース ID を取得
export WORKSPACE_ID=$(az monitor log-analytics workspace show \
  --workspace-name logs-container-handson \
  --resource-group $RESOURCE_GROUP \
  --query id \
  --output tsv)

# App Service の診断設定を作成
az monitor diagnostic-settings create \
  --name "Send to Log Analytics" \
  --resource $(az webapp show \
    --name $APP_NAME \
    --resource-group $RESOURCE_GROUP \
    --query id --output tsv) \
  --workspace $WORKSPACE_ID \
  --logs '[{"category": "AppServiceConsoleLogs", "enabled": true}]' \
  --metrics '[{"category": "AllMetrics", "enabled": true}]'
```

---

## STEP 6-13: トラブルシューティングチェックリスト

問題が発生したときの確認手順です。

<div class="text-xs">

**1. アプリケーションにアクセスできない**

```bash
# ステータスを確認
az webapp show --name $APP_NAME --resource-group $RESOURCE_GROUP --query state

# ログを確認
az webapp log tail --name $APP_NAME --resource-group $RESOURCE_GROUP

# コンテナが起動しているか確認
# ログに "Container started successfully" があるか
```

**2. 遅い・タイムアウト**

```bash
# CPU/メモリ使用率を確認
az monitor metrics list --metric "CpuPercentage" ...
az monitor metrics list --metric "MemoryPercentage" ...

# Application Insights で遅いリクエストを特定
# Performance ブレードを確認
```

**3. 502/503 エラー**

```bash
# コンテナログでエラーを確認
az webapp log tail --filter docker

# ポート設定を確認
az webapp config appsettings list --query "[?name=='WEBSITES_PORT']"

# Always On を確認（コールドスタート防止）
az webapp config show --query alwaysOn
```

**4. イメージがプルできない**

```bash
# ACR 認証を確認
az webapp config container show

# ACR へのアクセスをテスト
az acr repository list --name $ACR_NAME
```

</div>

---

## ハンズオン ⑥ のまとめ

<div class="grid grid-cols-2 gap-6">
<div>

### ✅ 達成したこと

- ✅ 3 種類のログの有効化
- ✅ Log Stream でのリアルタイム監視
- ✅ Application Insights の統合
- ✅ KQL でのログ分析
- ✅ アラート設定
- ✅ Availability Test の設定
- ✅ トラブルシューティング手法の習得

</div>
<div>

### 🔑 重要なポイント

- **ログの種類**
  - Application, Container, Web Server
  - 用途に応じて使い分け
- **Application Insights**
  - 詳細な監視・診断
  - KQL で分析
- **アラート**
  - 問題の早期検知
  - アクショングループで通知
- **Crash Loop 対策**
  - ポート設定、起動時間、メモリ
- **診断手順**
  - ログ → ローカル再現 → 修正

</div>
</div>
<div class="mt-4 bg-green-500/10 p-3 rounded text-sm">
✅ <strong>次のステップ:</strong> CI/CD による自動デプロイを設定します。
</div>
