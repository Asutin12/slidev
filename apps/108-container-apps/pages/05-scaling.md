---
layout: center
---

# 📈 ハンズオン ④

スケーリングとオートスケール

---

## ハンズオン ④ の概要

このハンズオンでは、Container Apps のスケーリング機能を学びます。

<div class="pt-6">

### 🎯 学習目標

- スケーリングの基本概念を理解する
- HTTP ベースのスケーリングを設定する
- KEDA によるイベント駆動スケーリングを学ぶ
- 0 へのスケールダウンを実践する

### 📋 実施内容

1. **基本的なスケーリング設定** - min/max replicas の設定
2. **HTTP スケーリング** - 同時リクエスト数に基づくスケール
3. **CPU/メモリベースのスケーリング** - リソース使用率でのスケール
4. **0 へのスケールダウン** - アイドル時の完全停止

</div>

---

## Container Apps のスケーリングモデル

Container Apps は KEDA（Kubernetes Event-Driven Autoscaling）を使用します。

<div class="grid grid-cols-2 gap-6 text-sm">

<div>

### スケーリングの特徴

- **イベント駆動**

  - HTTP リクエスト
  - キューのメッセージ数
  - カスタムメトリクス

- **0 へのスケール**

  - トラフィックがない場合は 0 まで縮小
  - コストを大幅削減
  - イベント発生時に自動起動

- **高速スケーリング**
  - 秒単位でレプリカを追加
  - 負荷に素早く対応

</div>

<div>

### スケーリングトリガー

1. **HTTP**

   - 同時リクエスト数
   - リクエスト/秒

2. **Azure Queue**

   - キューのメッセージ数

3. **Azure Service Bus**

   - トピック/キューの長さ

4. **Cron (Schedule)**

   - 時間ベースのスケール

5. **Custom (Prometheus)**
   - カスタムメトリクス

</div>

</div>

---

## STEP 4-1: 基本的なスケーリング設定

min/max replicas を設定します。

```bash
# 現在のスケーリング設定を確認
az containerapp show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "properties.template.scale" \
  --output yaml

# スケーリング設定を更新
az containerapp update \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --min-replicas 1 \
  --max-replicas 10

# 確認
az containerapp show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "properties.template.scale.{MinReplicas:minReplicas, MaxReplicas:maxReplicas}" \
  --output table

# 期待される出力
# MinReplicas    MaxReplicas
# -------------  -------------
# 1              10
```

---

## レプリカ数の設定パターン

用途に応じた設定例です。

<div class="grid grid-cols-3 gap-4 text-xs">

<div class="bg-blue-500/10 p-3 rounded">

#### 開発/テスト環境

```bash
--min-replicas 0 \
--max-replicas 3
```

**特徴:**

- コスト最小化
- 0 へのスケールダウン
- 負荷は小さい

**適用:**

- 開発環境
- テスト環境
- デモ環境

</div>

<div class="bg-green-500/10 p-3 rounded">

#### ステージング環境

```bash
--min-replicas 1 \
--max-replicas 5
```

**特徴:**

- 常時 1 インスタンス稼働
- 中程度の負荷対応
- 本番に近い構成

**適用:**

- ステージング
- プレプロダクション
- 負荷テスト

</div>

<div class="bg-purple-500/10 p-3 rounded">

#### 本番環境

```bash
--min-replicas 2 \
--max-replicas 20
```

**特徴:**

- 高可用性（最低 2 台）
- 大規模トラフィック対応
- 即座の応答

**適用:**

- 本番環境
- ミッションクリティカル
- 24/7 稼働

</div>

</div>

---

## STEP 4-2: HTTP スケーリングルールの設定

同時リクエスト数に基づいてスケールします。

```bash
# HTTP スケーリングルールを追加
az containerapp update \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --min-replicas 0 \
  --max-replicas 10 \
  --scale-rule-name http-scale \
  --scale-rule-type http \
  --scale-rule-http-concurrency 10

# 確認
az containerapp show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "properties.template.scale.rules" \
  --output yaml

# 期待される出力
# - http:
#     metadata:
#       concurrentRequests: '10'
#   name: http-scale
```

<div class="mt-4 bg-blue-500/10 p-3 rounded text-sm">
💡 <strong>concurrentRequests: 10</strong> - 1レプリカあたり同時に10リクエストまで処理。それを超えると新しいレプリカが追加されます。
</div>

---

## HTTP スケーリングの動作

スケーリングの計算方法を理解します。

<div class="text-sm">

### スケーリングの計算式

```
必要なレプリカ数 = ceil(現在の同時リクエスト数 / concurrentRequests)
```

### 例

**設定: concurrentRequests = 10**

| 同時リクエスト数 | 計算                | 必要なレプリカ数 |
| ---------------- | ------------------- | ---------------- |
| 5                | ceil(5 / 10) = 1    | 1                |
| 15               | ceil(15 / 10) = 2   | 2                |
| 25               | ceil(25 / 10) = 3   | 3                |
| 100              | ceil(100 / 10) = 10 | 10               |
| 150              | ceil(150 / 10) = 15 | 10（max 制限）   |

</div>

---

## STEP 4-3: スケーリング動作の確認

負荷をかけてスケーリングを確認します。

<div class="grid grid-cols-2 gap-6 text-sm">

<div>

### 負荷テストの実行

```bash
# Apache Bench で負荷をかける
# 100同時接続、1000リクエスト
ab -n 1000 -c 100 https://${APP_URL}/

# または hey を使用
hey -n 1000 -c 100 https://${APP_URL}/

# -n: 総リクエスト数
# -c: 同時実行数
```

### 継続的な負荷

```bash
# 継続的に負荷をかける
while true; do
  ab -n 100 -c 50 https://${APP_URL}/ > /dev/null 2>&1
  sleep 1
done
```

</div>

<div>

### レプリカ数の監視

```bash
# リアルタイムでレプリカ数を監視
watch -n 2 'az containerapp replica list \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --output table'

# 出力例
# Name                           Status    Created
# ----------------------------  --------  ----------
# ca-todo-web--xxx-111         Running   2m ago
# ca-todo-web--xxx-222         Running   30s ago
# ca-todo-web--xxx-333         Running   15s ago
# ca-todo-web--xxx-444         Running   5s ago

# 負荷が増えるとレプリカが増加
# 負荷が減るとレプリカが減少
```

</div>

</div>

---

## STEP 4-4: CPU ベースのスケーリング

CPU 使用率に基づいてスケールします。

```bash
# CPU スケーリングルールを追加
az containerapp update \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --scale-rule-name cpu-scale \
  --scale-rule-type cpu \
  --scale-rule-auth trigger=cpu \
  --scale-rule-metadata type=Utilization value=70

# 複数のスケーリングルールが設定される
az containerapp show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "properties.template.scale.rules[].name" \
  --output table

# 期待される出力
# Result
# ----------
# http-scale
# cpu-scale
```

<div class="mt-4 bg-blue-500/10 p-3 rounded text-sm">
💡 <strong>CPU 70%:</strong> CPU 使用率が 70% を超えると、新しいレプリカが追加されます。
</div>

---

## STEP 4-5: メモリベースのスケーリング

メモリ使用率に基づいてスケールします。

```bash
# メモリスケーリングルールを追加
az containerapp update \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --scale-rule-name memory-scale \
  --scale-rule-type memory \
  --scale-rule-auth trigger=memory \
  --scale-rule-metadata type=Utilization value=80

# 確認
az containerapp show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "properties.template.scale.rules[].{Name:name, Type:type}" \
  --output table

# 期待される出力
# Name          Type
# ------------  ------
# http-scale    http
# cpu-scale     cpu
# memory-scale  memory
```

---

## STEP 4-6: スケーリングルールの優先順位

複数のルールがある場合の動作を理解します。

<div class="text-sm">

### スケーリングの判断

Container Apps は、**すべてのルールを評価し、最も大きなレプリカ数を採用**します。

**例: 以下のルールが設定されている場合**

1. HTTP ルール: 5 レプリカ必要
2. CPU ルール: 3 レプリカ必要
3. メモリルール: 7 レプリカ必要

**結果: 7 レプリカが起動**（最大値を採用）

### 推奨設定

```bash
# 本番環境の推奨設定
az containerapp update \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --min-replicas 2 \
  --max-replicas 20 \
  --scale-rule-name http-scale \
  --scale-rule-type http \
  --scale-rule-http-concurrency 10
```

</div>

---

## STEP 4-7: 0 へのスケールダウン

アイドル時に完全に停止します。

```bash
# 0 へのスケールダウンを有効化
az containerapp update \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --min-replicas 0 \
  --max-replicas 10

# 確認
az containerapp show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "properties.template.scale.minReplicas" \
  --output tsv

# 期待される出力: 0
```

<div class="grid grid-cols-2 gap-6 text-sm mt-4">

<div>

### スケールダウンの動作

1. **アイドル検知**

   - トラフィックがなくなる
   - 待機時間経過（通常数分）

2. **レプリカの削除**

   - すべてのレプリカが停止
   - リソース課金が停止

3. **コールドスタート**
   - 新しいリクエスト到着
   - レプリカが起動（数秒）
   - リクエストを処理

</div>

<div>

### コスト削減効果

**開発環境の例:**

- 稼働時間: 8 時間/日
- 月間稼働: 160 時間

```
従来（常時1レプリカ）:
  720時間 × ¥0.5/時間 = ¥360/月

0スケール有効:
  160時間 × ¥0.5/時間 = ¥80/月

削減: 78% のコスト削減
```

</div>

</div>

---

## STEP 4-8: コールドスタートの確認

0 からのスケールアップを確認します。

<div class="grid grid-cols-2 gap-6 text-sm">

<div>

### レプリカの確認

```bash
# レプリカ数を確認
az containerapp replica list \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --output table

# 期待される出力（アイドル時）
# Name    Status    Created
# ------  --------  -------
# (empty) - レプリカなし

# 10分ほど待つと0にスケールダウン
```

</div>

<div>

### リクエスト送信

```bash
# リクエストを送信
time curl https://${APP_URL}/

# 初回（コールドスタート）
# real    0m3.456s  ← 3秒以上
# （レプリカの起動時間）

# 2回目以降
time curl https://${APP_URL}/

# real    0m0.123s  ← 1秒未満
# （レプリカが既に起動）
```

</div>

</div>

<div class="mt-4 bg-yellow-500/10 p-3 rounded text-sm">
⚠️ <strong>コールドスタート:</strong> 0 からのスケールアップには数秒かかります。即座のレスポンスが必要な場合は `min-replicas 1` 以上を設定してください。
</div>

---

## STEP 4-9: スケーリング速度の調整

スケーリングの挙動を調整します。

<div class="text-sm">

### スケールアップ/ダウンの期間

```yaml
# containerapp.yaml で設定
scale:
  minReplicas: 0
  maxReplicas: 10
  rules:
    - name: http-scale
      http:
        metadata:
          concurrentRequests: "10"
      # スケーリングの調整
      scaleDown:
        stabilizationWindowSeconds: 300 # 5分間安定後にスケールダウン
      scaleUp:
        stabilizationWindowSeconds: 60 # 1分間安定後にスケールアップ
```

### 適用

```bash
az containerapp update \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --yaml containerapp.yaml
```

</div>

---

## STEP 4-10: Queue ベースのスケーリング

Azure Storage Queue を使用したスケーリングです。

<div class="grid grid-cols-2 gap-6 text-sm">

<div>

### Storage Queue の作成

```bash
# Storage Account の作成
export STORAGE_ACCOUNT="stcontainerapps${RANDOM}"

az storage account create \
  --name $STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --sku Standard_LRS

# Queue の作成
az storage queue create \
  --name tasks \
  --account-name $STORAGE_ACCOUNT

# 接続文字列の取得
export STORAGE_CONNECTION=$(az storage account show-connection-string \
  --name $STORAGE_ACCOUNT \
  --query connectionString \
  --output tsv)
```

</div>

<div>

### Queue スケーリングルール

```bash
# シークレットに接続文字列を保存
az containerapp secret set \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --secrets storage-connection="$STORAGE_CONNECTION"

# Queue スケーリングルールを追加
az containerapp update \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --scale-rule-name queue-scale \
  --scale-rule-type azure-queue \
  --scale-rule-metadata \
    queueName=tasks \
    queueLength=5 \
    connection=storage-connection
```

</div>

</div>

---

## Queue スケーリングの動作確認

メッセージを追加してスケーリングを確認します。

```bash
# メッセージを追加（キューに50件追加）
for i in {1..50}; do
  az storage message put \
    --queue-name tasks \
    --content "Task $i" \
    --account-name $STORAGE_ACCOUNT \
    --connection-string "$STORAGE_CONNECTION"
done

# レプリカ数を確認
watch -n 2 'az containerapp replica list \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --output table'

# queueLength=5 なので、50件 ÷ 5 = 10レプリカが起動
# （max-replicas の制限内）

# メッセージが処理されるとレプリカが減少
```

<div class="mt-4 bg-blue-500/10 p-3 rounded text-sm">
💡 <strong>Queue スケーリング:</strong> キューの長さに応じて自動的にレプリカ数が調整されます。バッチ処理に最適です。
</div>

---

## STEP 4-11: Cron (Schedule) ベースのスケーリング

時間ベースでスケールします。

```bash
# 平日の営業時間（9:00-18:00）にスケールアップ
az containerapp update \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --scale-rule-name business-hours \
  --scale-rule-type cron \
  --scale-rule-metadata \
    timezone="Asia/Tokyo" \
    start="0 9 * * 1-5" \
    end="0 18 * * 1-5" \
    desiredReplicas="5"

# Cron 形式
# 分 時 日 月 曜日
# 0  9  *  *  1-5  ← 月〜金の9時
```

<div class="grid grid-cols-2 gap-4 text-xs mt-4">

<div>

### スケジュール例

```bash
# 毎日9時にスケールアップ
start="0 9 * * *"
end="0 18 * * *"

# 平日のみ
start="0 9 * * 1-5"

# 特定の日時
start="0 0 1 * *"  # 毎月1日0時
```

</div>

<div>

### 用途

- **営業時間に合わせたスケール**
- **バッチ処理の事前準備**
- **定期メンテナンス**
- **トラフィック予測に基づく調整**

</div>

</div>

---

## STEP 4-12: カスタムメトリクスでのスケーリング

Prometheus メトリクスを使用します。

<div class="text-sm">

### Prometheus メトリクスの公開

```javascript
// app.js にメトリクスエンドポイントを追加
const promClient = require("prom-client");
const register = new promClient.Registry();

// カスタムメトリクス
const activeUsers = new promClient.Gauge({
  name: "active_users",
  help: "Number of active users",
  registers: [register],
});

app.get("/metrics", async (req, res) => {
  res.set("Content-Type", register.contentType);
  res.end(await register.metrics());
});
```

### スケーリングルール

```bash
az containerapp update \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --scale-rule-name custom-metric \
  --scale-rule-type prometheus \
  --scale-rule-metadata \
    serverAddress="http://localhost:3000" \
    metricName="active_users" \
    threshold="100" \
    query="active_users"
```

</div>

---

## スケーリング戦略のまとめ

用途に応じた最適なスケーリング戦略です。

<div class="text-xs">

| ワークロード             | 推奨設定                           | 理由                             |
| ------------------------ | ---------------------------------- | -------------------------------- |
| **Web API（開発）**      | min=0, max=3, HTTP スケール        | コスト削減、コールドスタート許容 |
| **Web API（本番）**      | min=2, max=20, HTTP スケール       | 高可用性、即座の応答             |
| **バックグラウンド処理** | min=0, max=10, Queue スケール      | コスト効率、必要時のみ稼働       |
| **定期バッチ**           | min=0, max=5, Cron スケール        | スケジュール実行、コスト最適化   |
| **高負荷 API**           | min=3, max=50, HTTP + CPU スケール | 高パフォーマンス、安定性         |
| **マイクロサービス**     | min=1, max=10, HTTP スケール       | 柔軟性、サービス間通信           |

### ベストプラクティス

1. **開発環境**: `min-replicas 0` でコスト削減
2. **本番環境**: `min-replicas 2+` で高可用性確保
3. **max-replicas**: トラフィックの 2-3 倍を見積もる
4. **複数ルール**: HTTP + CPU/Memory で安定性向上
5. **監視**: メトリクスを定期的に確認し、調整

</div>

---

## トラブルシューティング

スケーリングに関する問題と解決方法です。

<div class="text-xs">

| 問題                      | 原因                   | 解決方法                                             |
| ------------------------- | ---------------------- | ---------------------------------------------------- |
| スケールアップしない      | ルールの閾値が高すぎる | `concurrentRequests` を下げる（例: 10 → 5）          |
| スケールダウンしない      | 継続的なリクエスト     | 正常動作、または `stabilizationWindowSeconds` を短縮 |
| 0 にスケールダウンしない  | アクティブな接続がある | 数分待つ、または手動でレプリカを削除                 |
| レプリカが頻繁に増減      | 閾値が低すぎる         | `stabilizationWindowSeconds` を延長                  |
| コールドスタートが遅い    | イメージサイズが大きい | イメージを最適化、または `min-replicas 1` に設定     |
| max-replicas に達している | トラフィックが多すぎる | `max-replicas` を増やす、またはリソースを増強        |

### デバッグコマンド

```bash
# スケーリング設定の確認
az containerapp show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "properties.template.scale"

# 現在のレプリカ状態
az containerapp replica list \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP

# メトリクスの確認
az monitor metrics list \
  --resource $(az containerapp show \
    --name $APP_NAME \
    --resource-group $RESOURCE_GROUP \
    --query id -o tsv) \
  --metric "Replicas"
```

</div>

---

## まとめ

スケーリングとオートスケールを学びました。

<div class="grid grid-cols-2 gap-6 text-sm">

<div>

### 実施したこと

✅ **基本スケーリング**

- min/max replicas の設定
- レプリカ数の監視

✅ **イベント駆動スケーリング**

- HTTP ベースのスケール
- CPU/メモリベースのスケール
- Queue ベースのスケール
- Cron ベースのスケール

✅ **0 へのスケール**

- コストの最適化
- コールドスタートの確認

</div>

<div>

### 次のステップ

次のハンズオンでは、Container Apps 同士の連携を学びます。

1. **内部通信（Service-to-Service）**
2. **Dapr による Pub/Sub**
3. **外部アクセス制御**
4. **マイクロサービス構成**

</div>

</div>

<div class="mt-4 bg-green-500/10 p-3 rounded text-sm">
✅ <strong>スケーリング完了!</strong> 次のハンズオンでサービス連携を学びます。
</div>
