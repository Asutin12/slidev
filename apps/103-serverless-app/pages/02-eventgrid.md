---
layout: center
---

# ハンズオン ② Event Grid

イベント駆動アーキテクチャでサービス間連携

---

## Event Grid ハンズオン概要

**目的:** Event Grid を使ってイベント駆動アーキテクチャを構築し、疎結合なサービス連携を実装する

<div class="grid grid-cols-2 gap-8 pt-6">
<div>

### 📚 学べるポイント

- **カスタムトピックの作成**
  - イベントの発行基盤構築
- **イベントサブスクリプション**
  - Function App へのイベント配信
- **イベントフィルタリング**
  - サブジェクトとデータによるフィルタ
- **システムトピック**
  - Azure サービスからのイベント受信
- **デッドレター処理**
  - 配信失敗時の対応

</div>
<div>

### 🎯 ハンズオン内容

1. **Event Grid カスタムトピックの作成**
2. **イベントサブスクリプションの作成**
3. **Function App でイベントを受信**
4. **イベントの発行とテスト**
5. **複数サブスクライバーの設定**
6. **イベントフィルタリングの実装**
7. **システムトピックの活用**
8. **エラーハンドリングとリトライ**

</div>
</div>

---

<div class="flex items-center gap-x-4">

## ステップ 1: Event Grid カスタムトピックの作成

<div class="text-sm bg-blue-500/20 px-2 py-1 rounded mb-3">👥 共有可能</div>
</div>

イベントを発行するための Event Grid トピックを作成します。

```bash
# Event Gridカスタムトピックを作成
az eventgrid topic create \
  --name $TOPIC_NAME \
  --resource-group $RESOURCE_GROUP \
  --location japaneast

# 作成確認
az eventgrid topic list --output table

# エンドポイントURLを取得
TOPIC_ENDPOINT=$(az eventgrid topic show \
  --name $TOPIC_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "endpoint" -o tsv)

# アクセスキーを取得
TOPIC_KEY=$(az eventgrid topic key list \
  --name $TOPIC_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "key1" -o tsv)

echo "Topic Endpoint: $TOPIC_ENDPOINT"
echo "Topic Key: $TOPIC_KEY"
```

**💡 Tip:** エンドポイントとキーはイベント発行時に使用します。メモしておいてください。

---

## ステップ 2: イベント受信用 Function の作成

Event Grid からイベントを受信する Function を作成します。

**`function_app.py` に Event Grid Trigger 関数を追加:**

```python
@app.function_name(name="EventGridTriggerDemo")
@app.event_grid_trigger(arg_name="event")
def event_grid_trigger_demo(event: func.EventGridEvent):
    logging.info('Event Grid trigger function processed an event')
    logging.info('Event Type: %s', event.event_type)
    logging.info('Event Subject: %s', event.subject)
    logging.info('Event Data: %s', json.dumps(event.get_json()))
    logging.info('Event Time: %s', event.event_time)

    # イベントタイプに応じた処理
    event_data = event.get_json()

    if event.event_type == "OrderCreated":
        logging.info('Processing new order: %s', event_data.get('orderId'))
        # 注文処理ロジック
    elif event.event_type == "OrderCancelled":
        logging.info('Processing order cancellation: %s', event_data.get('orderId'))
        # キャンセル処理ロジック
    elif event.event_type == "OrderShipped":
        logging.info('Processing order shipment: %s', event_data.get('orderId'))
        # 発送処理ロジック
    else:
        logging.info('Unknown event type')
```

---

## ステップ 3: Function を Azure にデプロイ

Event Grid Trigger 関数をデプロイします。

```bash
# Azureにデプロイ
func azure functionapp publish $MY_FUNC_NAME

# デプロイ確認
az functionapp function list \
  --name $MY_FUNC_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "[?name=='EventGridTriggerDemo']" \
  --output table
```

---

## ステップ 4: イベントサブスクリプションの作成

Event Grid トピックから Function へイベントを配信するサブスクリプションを作成します。

```bash
# Function AppのリソースIDを取得
FUNCTION_APP_ID=$(az functionapp show \
  --name $MY_FUNC_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "id" -o tsv)

# イベントサブスクリプションを作成
az eventgrid event-subscription create \
  --name $SUBSCRIPTION_NAME \
  --source-resource-id "/subscriptions/$(az account show --query id -o tsv)/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.EventGrid/topics/$TOPIC_NAME" \
  --endpoint "${FUNCTION_APP_ID}/functions/EventGridTriggerDemo" \
  --endpoint-type azurefunction

# サブスクリプション確認
az eventgrid event-subscription list \
  --source-resource-id "/subscriptions/$(az account show --query id -o tsv)/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.EventGrid/topics/$TOPIC_NAME" \
  --output table
```

**💡 Tip:** サブスクリプション作成時に Event Grid が Function のエンドポイントを検証します。

---

## ステップ 5: イベントの発行

Event Grid トピックにイベントを発行します。

```bash
# イベントデータを定義
EVENT_DATA='[
  {
    "id": "event-001",
    "eventType": "OrderCreated",
    "subject": "orders/12345",
    "eventTime": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'",
    "data": {
      "orderId": "12345",
      "customerId": "customer-001",
      "amount": 15000,
      "items": [
        {"productId": "prod-001", "quantity": 2},
        {"productId": "prod-002", "quantity": 1}
      ]
    },
    "dataVersion": "1.0"
  }
]'

# イベントを発行
curl -X POST "$TOPIC_ENDPOINT?api-version=2018-01-01" \
  -H "aeg-sas-key: $TOPIC_KEY" \
  -H "Content-Type: application/json" \
  -d "$EVENT_DATA"
```

---

## ステップ 6: イベント発行の実行とログ確認

イベントを発行して、Function で受信できることを確認します。

```bash
# スクリプトに実行権限を付与
chmod +x publish-event.sh

# イベントを発行
./publish-event.sh

# Azure Portalでログを確認
# Function App → Functions → EventGridTriggerDemo → Monitor
# または Application Insightsでログを確認
```

<div class="grid grid-cols-2 gap-8 pt-4">
<div>

**Application Insights でのログ確認（KQL）:**

```kusto
traces
| where timestamp > ago(10m)
| where operation_Name == "EventGridTriggerDemo"
| project timestamp, message
| order by timestamp desc
```

</div>
<div>

**期待されるログ出力:**

```
Event Grid trigger function processed an event
Event Type: OrderCreated
Event Subject: orders/12345
Event Data: {"orderId":"12345","customerId":"customer-001","amount":15000,...}
Processing new order: 12345
```

</div>
</div>

---

## ステップ 7: 複数サブスクライバーの設定

同じイベントを複数の Function で処理します。

**新しい Function を作成（通知用）:**

```bash
cd my-functions-app
```

**`function_app.py` に Event Grid Notification 関数を追加:**

```python
@app.function_name(name="EventGridNotificationDemo")
@app.event_grid_trigger(arg_name="event")
def event_grid_notification_demo(event: func.EventGridEvent):
    logging.info('Notification function processed an event')

    # 通知ロジック
    if event.event_type == "OrderCreated":
        logging.info('Sending confirmation email to customer')
        # メール送信処理
    elif event.event_type == "OrderShipped":
        logging.info('Sending shipment notification')
        # 発送通知送信処理
```

---

## ステップ 8: 2 つ目のサブスクリプション作成

通知用 Function へのサブスクリプションを作成します。

```bash
# Functionを再デプロイ
func azure functionapp publish $MY_FUNC_NAME

# 2つ目のサブスクリプションを作成
az eventgrid event-subscription create \
  --name order-notification-sub \
  --source-resource-id "/subscriptions/$(az account show --query id -o tsv)/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.EventGrid/topics/$TOPIC_NAME" \
  --endpoint "${FUNCTION_APP_ID}/functions/EventGridNotificationDemo" \
  --endpoint-type azurefunction

# サブスクリプション一覧を確認
az eventgrid event-subscription list \
  --source-resource-id "/subscriptions/$(az account show --query id -o tsv)/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.EventGrid/topics/$TOPIC_NAME" \
  --output table
```

**💡 ポイント:** 1 つのイベントが複数のサブスクライバーに配信されます（パブリッシュ-サブスクライブパターン）

---

## ステップ 8-2: 複数サブスクライバーの検証

1 つのイベントが両方の Function で処理されることを確認します。

<div class="grid grid-cols-2 gap-8">
<div>

```bash
# イベントを発行
EVENT_DATA='[
  {
    "id": "event-002",
    "eventType": "OrderCreated",
    "subject": "orders/67890",
    "eventTime": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'",
    "data": {
      "orderId": "67890",
      "customerId": "customer-002",
      "amount": 25000
    },
    "dataVersion": "1.0"
  }
]'

curl -X POST "$TOPIC_ENDPOINT?api-version=2018-01-01" \
  -H "aeg-sas-key: $TOPIC_KEY" \
  -H "Content-Type: application/json" \
  -d "$EVENT_DATA"
```

</div>
<div>

**Application Insights で両方の関数のログを確認:**

```kusto
traces
| where timestamp > ago(5m)
| where operation_Name in ("EventGridTriggerDemo", "EventGridNotificationDemo")
| project timestamp, operation_Name, message
| order by timestamp desc
```

**期待される結果:** 同じイベントが両方の Function で処理される

</div>
</div>
---

## ステップ 9-1: イベントフィルタリングの実装

特定のイベントタイプやサブジェクトのみを受信するようにフィルタリングします。

```bash
# OrderCreatedイベントのみを受信するサブスクリプション
az eventgrid event-subscription create \
  --name order-created-only-sub \
  --source-resource-id "/subscriptions/$(az account show --query id -o tsv)/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.EventGrid/topics/$TOPIC_NAME" \
  --endpoint "${FUNCTION_APP_ID}/functions/EventGridTriggerDemo" \
  --endpoint-type azurefunction \
  --included-event-types OrderCreated

# サブジェクトフィルタリング（特定の注文のみ）
az eventgrid event-subscription create \
  --name vip-orders-sub \
  --source-resource-id "/subscriptions/$(az account show --query id -o tsv)/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.EventGrid/topics/$TOPIC_NAME" \
  --endpoint "${FUNCTION_APP_ID}/functions/EventGridTriggerDemo" \
  --endpoint-type azurefunction \
  --subject-begins-with "orders/vip/"
```

---

## ステップ 9-2: イベントフィルタリングの実装

**高度なフィルタリング（データフィールド）:**

```bash
# 金額が10000以上の注文のみ
az eventgrid event-subscription create \
  --name high-value-orders-sub \
  --source-resource-id "/subscriptions/$(az account show --query id -o tsv)/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.EventGrid/topics/$TOPIC_NAME" \
  --endpoint "${FUNCTION_APP_ID}/functions/EventGridTriggerDemo" \
  --endpoint-type azurefunction \
  --advanced-filter data.amount NumberGreaterThanOrEquals 10000
```

---

## ステップ 9-3: フィルタリングの検証

フィルタリングが正しく動作することを確認します。

<div class="grid grid-cols-2 gap-8">
<div>

**テスト 1: OrderShipped イベントを発行（フィルタリングされる）**

```bash
EVENT_DATA='[{
  "id": "event-003",
  "eventType": "OrderShipped",
  "subject": "orders/11111",
  "eventTime": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'",
  "data": {"orderId": "11111"},
  "dataVersion": "1.0"
}]'

curl -X POST "$TOPIC_ENDPOINT?api-version=2018-01-01" \
  -H "aeg-sas-key: $TOPIC_KEY" \
  -H "Content-Type: application/json" \
  -d "$EVENT_DATA"
```

→ `order-created-only-sub` は受信しない

</div>
<div>

**テスト 2: VIP 注文イベントを発行**

```bash
EVENT_DATA='[{
  "id": "event-004",
  "eventType": "OrderCreated",
  "subject": "orders/vip/22222",
  "eventTime": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'",
  "data": {"orderId": "22222", "amount": 50000},
  "dataVersion": "1.0"
}]'

curl -X POST "$TOPIC_ENDPOINT?api-version=2018-01-01" \
  -H "aeg-sas-key: $TOPIC_KEY" \
  -H "Content-Type: application/json" \
  -d "$EVENT_DATA"
```

→ `vip-orders-sub` と `high-value-orders-sub` が受信

</div>
</div>

---

## ステップ 9-4: フィルタリング結果の確認

各サブスクリプションのメトリクスで配信状況を確認します。

```bash
# サブスクリプションごとの配信統計を確認
az monitor metrics list \
  --resource "/subscriptions/$(az account show --query id -o tsv)/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.EventGrid/topics/$TOPIC_NAME" \
  --metric "PublishSuccessCount" \
  --output table

# Azure Portalで確認する場合:
# Event Grid Topic → Metrics → "Matched Events" / "Delivery Succeeded Events"
```

**Application Insights で特定のサブスクリプションのログのみ表示:**

```kusto
traces
| where timestamp > ago(10m)
| where operation_Name == "EventGridTriggerDemo"
| where message contains "OrderCreated" or message contains "orders/vip"
| project timestamp, message
| order by timestamp desc
```

**💡 Tip:** フィルタリングは Event Grid 側で行われるため、Function は条件に合うイベントのみを受信します。

---

## ステップ 10: システムトピックの活用

Azure サービスからのイベントを受信します（例: Blob Storage）。

```bash
# Blob StorageのシステムトピックにサブスクリプションBlobを作成
az eventgrid event-subscription create \
  --name blob-created-sub \
  --source-resource-id "/subscriptions/$(az account show --query id -o tsv)/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Storage/storageAccounts/$MY_STORAGE_NAME" \
  --endpoint "${FUNCTION_APP_ID}/functions/EventGridTriggerDemo" \
  --endpoint-type azurefunction \
  --included-event-types Microsoft.Storage.BlobCreated

# テストファイルをアップロードしてイベントを発生させる
echo "Test content" > test-eventgrid.txt
az storage blob upload \
  --account-name $MY_STORAGE_NAME \
  --container-name images \
  --name test-eventgrid.txt \
  --file test-eventgrid.txt

# Function のログで受信を確認
```

**💡 ポイント:** システムトピックを使うと、Azure リソースのイベントを簡単に取得できます。

---

## ステップ 11: デッドレター処理の設定

イベント配信に失敗した場合の処理を設定します。

```bash
# デッドレター用のBlobコンテナを作成
az storage container create \
  --name deadletter \
  --account-name $MY_STORAGE_NAME

# デッドレター設定付きサブスクリプション
az eventgrid event-subscription create \
  --name order-processing-with-dl \
  --source-resource-id "/subscriptions/$(az account show --query id -o tsv)/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.EventGrid/topics/$TOPIC_NAME" \
  --endpoint "${FUNCTION_APP_ID}/functions/EventGridTriggerDemo" \
  --endpoint-type azurefunction \
  --deadletter-endpoint "/subscriptions/$(az account show --query id -o tsv)/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Storage/storageAccounts/$MY_STORAGE_NAME/blobServices/default/containers/deadletter" \
  --max-delivery-attempts 3 \
  --event-ttl 1440
```

**設定内容:**

- **max-delivery-attempts**: 最大配信試行回数（デフォルト: 30）
- **event-ttl**: イベントの有効期限（分単位、デフォルト: 1440 分=24 時間）
- **deadletter-endpoint**: 配信失敗したイベントの保存先

---

## Event Grid のベストプラクティス

Event Grid を本番環境で使用する際のベストプラクティスです。

<div class="grid grid-cols-2 gap-8 pt-4">
<div>

### 🎯 設計のポイント

**イベントスキーマの設計:**

- バージョニングを考慮
- 後方互換性を維持
- 必要最小限のデータのみ含める

**べき等性の確保:**

- 同じイベントが複数回配信される可能性
- 処理の冪等性を実装
- イベント ID で重複チェック

**エラーハンドリング:**

- 適切なリトライ設定
- デッドレター処理の実装
- 監視とアラート設定

</div>
<div>

### 🔒 セキュリティ

**アクセス制御:**

- Managed Identity の使用
- アクセスキーの定期的なローテーション
- 最小権限の原則

**データ保護:**

- 機密データの暗号化
- Private Endpoint の使用
- ネットワーク制限

**監視:**

- 配信成功率の監視
- レイテンシの追跡
- 異常検知とアラート

</div>
</div>
