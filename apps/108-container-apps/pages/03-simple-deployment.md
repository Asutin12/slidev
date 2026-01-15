---
layout: center
---

# 🚀 ハンズオン ②

シンプル Web アプリのデプロイ

---

## ハンズオン ② の概要

このハンズオンでは、Container Apps に初めてのコンテナアプリをデプロイします。

<div class="pt-6">

### 🎯 学習目標

- Container Apps へのデプロイ方法を理解する
- Ingress 設定とパブリックアクセスを学ぶ
- Revision の概念を実践的に理解する
- ログとメトリクスの確認方法を習得する

### 📋 実施内容

1. **Hello World アプリのデプロイ** - 最初の Container App 作成
2. **パブリックアクセスの確認** - HTTPS URL での動作確認
3. **Revision の確認** - デプロイされた Revision を確認
4. **ログの確認** - Log Analytics でログを確認

</div>

---

## STEP 2-1: Container App の作成（CLI）

ACR に保存したイメージを使用して、Container App を作成します。

```bash
# 環境変数の確認（ハンズオン①で設定したもの）
echo $RESOURCE_GROUP
echo $CONTAINERAPPS_ENVIRONMENT
echo $ACR_NAME

# Container App の作成
export APP_NAME="ca-todo-web"

az containerapp create \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --environment $CONTAINERAPPS_ENVIRONMENT \
  --image ${ACR_NAME}.azurecr.io/todo-containerapp:v1 \
  --target-port 3000 \
  --ingress external \
  --registry-server ${ACR_NAME}.azurecr.io \
  --registry-username $ACR_NAME \
  --registry-password $(az acr credential show --name $ACR_NAME --query "passwords[0].value" -o tsv) \
  --cpu 0.25 \
  --memory 0.5Gi \
  --min-replicas 0 \
  --max-replicas 3

# デプロイには2〜3分かかります
```

---

## パラメータの説明

各パラメータの意味を理解します。

<div class="text-xs">

| パラメータ            | 説明                                     | 例                             |
| --------------------- | ---------------------------------------- | ------------------------------ |
| `--name`              | Container App の名前                     | `ca-todo-web`                  |
| `--resource-group`    | リソースグループ                         | `rg-containerapps-handson`     |
| `--environment`       | Container Apps Environment               | `env-containerapps`            |
| `--image`             | コンテナイメージの URL                   | `acrhandson.azurecr.io/app:v1` |
| `--target-port`       | コンテナがリッスンするポート             | `3000`                         |
| `--ingress`           | Ingress タイプ（external/internal/none） | `external`                     |
| `--registry-server`   | コンテナレジストリのサーバー             | `acrhandson.azurecr.io`        |
| `--registry-username` | レジストリのユーザー名                   | ACR 名                         |
| `--registry-password` | レジストリのパスワード                   | ACR の管理者パスワード         |
| `--cpu`               | CPU リソース（vCPU）                     | `0.25` (0.25〜4.0)             |
| `--memory`            | メモリリソース                           | `0.5Gi` (0.5Gi〜8Gi)           |
| `--min-replicas`      | 最小レプリカ数                           | `0` (0 へのスケールダウン可能) |
| `--max-replicas`      | 最大レプリカ数                           | `3`                            |

</div>

<div class="mt-4 bg-blue-500/10 p-3 rounded text-xs">
💡 <strong>min-replicas 0:</strong> トラフィックがない場合、すべてのレプリカが停止し、課金も停止します。リクエストが来ると自動的に起動します（コールドスタート）。
</div>

---

## STEP 2-2: デプロイの確認

Container App が正常にデプロイされたか確認します。

```bash
# Container App の詳細を表示
az containerapp show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "{Name:name, FQDN:properties.configuration.ingress.fqdn, ProvisioningState:properties.provisioningState}" \
  --output table
# 期待される出力
# Name           FQDN                                                          ProvisioningState
# -------------  ------------------------------------------------------------  -------------------
# ca-todo-web  ca-todo-web.<unique-id>.japaneast.azurecontainerapps.io     Succeeded
```

<div class="grid grid-cols-2 gap-6">

<div>

### FQDN の取得

```bash
# FQDN（URL）のみを取得
export APP_URL=$(az containerapp show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query properties.configuration.ingress.fqdn \
  --output tsv)

echo "https://${APP_URL}"
```

</div>

<div>

### 動作確認

```bash
# HTTP リクエストを送信
curl https://${APP_URL}

# 期待される出力
# {
#   "message": "Hello from Container Apps!",
#   "timestamp": "2025-10-22T10:30:00.000Z",
#   "hostname": "ca-todo-web--xxx"
# }
```

</div>

</div>

---

## STEP 2-3: ブラウザでの確認

ブラウザで Container App にアクセスします。

<div class="grid grid-cols-2 gap-6">

<div>

### アクセス方法

1. **URL の取得**

```bash
echo "https://${APP_URL}"
```

2. **ブラウザで開く**

   - 表示された URL をブラウザで開く
   - HTTPS で自動的にアクセスされる
   - Azure が提供する証明書で保護されている

3. **レスポンスの確認**

   - JSON 形式でレスポンスが返される
   - `hostname` でコンテナを識別できる
   - `timestamp` で現在時刻が表示される

</div>

<div>

### ヘルスチェック

```bash
# ヘルスエンドポイントの確認
curl https://${APP_URL}/health

# 期待される出力
# {
#   "status": "healthy"
# }
```

### リクエストの繰り返し

```bash
# 複数回リクエストを送信
for i in {1..5}; do
  curl https://${APP_URL}
  echo ""
  sleep 1
done

# hostname が変わる場合がある
# = 複数のレプリカが稼働している
```

</div>

</div>

---

## STEP 2-4: Container App の詳細確認

Portal で Container App の詳細を確認します。

<div class="text-sm">

### Portal での確認手順

1. **Azure Portal にアクセス**

   - [https://portal.azure.com](https://portal.azure.com)

2. **Container App を開く**

   - リソースグループ `rg-containerapps-handson` を開く
   - `ca-todo-web` を選択

3. **概要ページの確認**

   - **アプリケーション URL**: HTTPS URL が表示される
   - **状態**: Running / Stopped
   - **レプリカ数**: 現在稼働中のレプリカ数
   - **Revision**: 現在アクティブな Revision

4. **メトリクスの確認**

   - CPU 使用率
   - メモリ使用率
   - リクエスト数
   - レスポンス時間

</div>

---

## STEP 2-5: Revision の確認

デプロイされた Revision を確認します。

<div class="grid grid-cols-2 gap-6 text-sm">

<div>

### CLI での Revision 確認

```bash
# Revision の一覧を表示
az containerapp revision list \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "[].{Name:name, Active:properties.active, CreatedTime:properties.createdTime, TrafficWeight:properties.trafficWeight}" \
  --output table
# 期待される出力
# Name                      Active  CreatedTime            TrafficWeight
# ------------------------  ------  ---------------------  -------------
# ca-todo-web--xxx         True    2025-10-22T10:00:00Z   100
```

### Revision の詳細

```bash
# 特定の Revision の詳細を表示
export REVISION_NAME=$(az containerapp revision list \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "[0].name" \
  --output tsv)

az containerapp revision show \
  --revision $REVISION_NAME \
  --resource-group $RESOURCE_GROUP
```

</div>

<div>

### Portal での Revision 確認

1. **Revision 管理ページを開く**

   - Container App を開く
   - 左メニューの「Revision 管理」を選択

2. **Revision の情報**

   - **名前**: 自動生成された Revision 名
   - **状態**: Active / Inactive
   - **トラフィック**: 割り当てられたトラフィックの割合
   - **作成日時**: Revision の作成日時

3. **Revision の詳細**

   - イメージ
   - CPU/メモリ
   - 環境変数
   - スケール設定

</div>

</div>

---

## STEP 2-6: ログの確認（CLI）

Container App のログを確認します。

```bash
# 最新のログを表示
az containerapp logs show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --follow

# 出力例
# Server running on port 3000
# GET / 200 - - 12.345 ms
# GET / 200 - - 8.123 ms
# GET /health 200 - - 5.678 ms

# Ctrl+C で終了
```

<div class="grid grid-cols-2 gap-6 text-sm mt-4">

<div>

### 過去のログを表示

```bash
# 過去のログを表示（最新100行）
az containerapp logs show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --tail 100
```

</div>

<div>

### 特定の Revision のログ

```bash
# 特定の Revision のログを表示
az containerapp logs show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --revision $REVISION_NAME \
  --tail 50
```

</div>

</div>

---

## STEP 2-7: Log Analytics でのログ確認

Log Analytics を使用して、より詳細なログ分析を行います。

<div class="text-sm">

### Portal での Log Analytics 確認

1. **Log Analytics を開く**

   - リソースグループから `log-containerapps` を開く
   - 左メニューの「ログ」を選択

2. **クエリの実行**

```kusto
// コンソールログの表示
ContainerAppConsoleLogs_CL
| where ContainerAppName_s == "ca-todo-web"
| project TimeGenerated, Log_s
| order by TimeGenerated desc
| take 100
```

3. **システムログの表示**

```kusto
// システムログの表示
ContainerAppSystemLogs_CL
| where ContainerAppName_s == "ca-todo-web"
| project TimeGenerated, Type_s, Reason_s
| order by TimeGenerated desc
```

</div>

---

## STEP 2-8: リソース使用状況の確認

Container App のリソース使用状況を確認します。

<div class="grid grid-cols-2 gap-6 text-xs">

<div>

### メトリクスの確認（Portal）

1. **Container App を開く**
2. **左メニューの「メトリクス」を選択**
3. **メトリクスを追加**

**確認できるメトリクス:**

- **Requests**: リクエスト数
- **CPU Usage**: CPU 使用率
- **Memory Usage**: メモリ使用率
- **Replica Count**: レプリカ数
- **Response Time**: レスポンス時間

</div>

<div>

### メトリクスの確認（CLI）

```bash
# CPU 使用率を取得（過去1時間）
az monitor metrics list \
  --resource $(az containerapp show \
    --name $APP_NAME \
    --resource-group $RESOURCE_GROUP \
    --query id -o tsv) \
  --metric "UsageNanoCores" \
  --start-time $(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%SZ) \
  --interval PT1M

# レプリカ数を取得
az monitor metrics list \
  --resource $(az containerapp show \
    --name $APP_NAME \
    --resource-group $RESOURCE_GROUP \
    --query id -o tsv) \
  --metric "Replicas" \
  --start-time $(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%SZ) \
  --interval PT1M
```

</div>

</div>

---

## STEP 2-9: スケーリング動作の確認

負荷をかけてスケーリング動作を確認します。

<div class="grid grid-cols-2 gap-6 text-sm">

<div>

### 負荷ツールのインストール

```bash
# Apache Bench（macOS）
brew install httpd

# Apache Bench（Ubuntu）
sudo apt-get install apache2-utils

# または hey（Go製）
go install github.com/rakyll/hey@latest
```

### 負荷テスト

```bash
# Apache Bench で負荷をかける
ab -n 1000 -c 100 https://${APP_URL}/api/health

# hey で負荷をかける
hey -n 10000 -c 100 https://${APP_URL}/api/health

# -n: 総リクエスト数
# -c: 同時実行数
```

</div>

<div>

### レプリカ数の確認

```bash
# レプリカ数を確認（別のターミナルで実行）
watch -n 2 'az containerapp replica list \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "[].{Name:name, Status:properties.runningState}" \
  --output table'
# 出力例
# Name                           Status
# ----------------------------  --------
# ca-todo-web--xxx-111         Running
# ca-todo-web--xxx-222         Running
# ca-todo-web--xxx-333         Running

# 負荷が増えるとレプリカが増加
# 負荷が減るとレプリカが減少
```

</div>

</div>

---

## STEP 2-10: Ingress 設定の確認

```bash
# Ingress 設定の確認
az containerapp ingress show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP
# 出力（JSON形式）
# {
#   "external": true,
#   "fqdn": "ca-todo-web.<unique>.japaneast.azurecontainerapps.io",
#   "targetPort": 3000,
#   "transport": "auto",
#   "traffic": [
#     {
#       "latestRevision": true,
#       "weight": 100
#     }
#   ]
# }
```

<div class="grid grid-cols-2 gap-6">

<div>

### Ingress の主要設定

- **external**: 外部アクセス可能
- **fqdn**: パブリック URL
- **targetPort**: コンテナのポート
- **transport**: HTTP/1.1、HTTP/2、gRPC
- **traffic**: トラフィック分割設定

</div>

<div>

### トラフィック設定

```bash
# トラフィック設定の確認
az containerapp ingress traffic show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP

# 出力
# [
#   {
#     "latestRevision": true,
#     "revisionName": null,
#     "weight": 100
#   }
# ]
```

</div>

</div>

---

## STEP 2-11: Container App の更新

新しいバージョンをデプロイして、Revision の動作を確認します。

<div class="text-sm">

### アプリケーションの更新

**page.tsx** を更新

```typescript
  <h1 className="text-4xl font-bold bg-gradient-to-r from-gray-900 via-gray-800 to-gray-600 bg-clip-text text-transparent">
    Todo App v2
  </h1>
```

### イメージのビルドとプッシュ

```bash
# イメージのビルド
docker buildx build --platform linux/amd64 -t todo-containerapp:v2 .

# タグ付け
docker tag todo-containerapp:v2 ${ACR_NAME}.azurecr.io/todo-containerapp:v2

# プッシュ
docker push ${ACR_NAME}.azurecr.io/todo-containerapp:v2
```

</div>

---

## STEP 2-12: 新しい Revision のデプロイ

v2 イメージをデプロイします。

```bash
# Container App を更新（新しい Revision が作成される）
az containerapp update \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --image ${ACR_NAME}.azurecr.io/todo-containerapp:v2

# デプロイには1〜2分かかります
# 動作確認
curl https://${APP_URL}
# 期待される出力
# {
#   "message": "Hello from Container Apps v2!",
#   "version": "2.0",
#   ...
# }
```

<div class="mt-4 bg-blue-500/10 p-3 rounded text-sm">
💡 <strong>Single Revision モード:</strong> デフォルトでは Single Revision モードのため、v2 がデプロイされると v1 は自動的に非アクティブになります。
</div>

---

## STEP 2-13: Revision の履歴確認

複数の Revision を確認します。

```bash
# すべての Revision を表示
az containerapp revision list \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "[].{Name:name, Active:properties.active, CreatedTime:properties.createdTime, TrafficWeight:properties.trafficWeight}" \
  --output table
# 期待される出力
# Name                      Active  CreatedTime            TrafficWeight
# ------------------------  ------  ---------------------  -------------
# ca-todo-web--v2-xxx      True    2025-10-22T11:00:00Z   100
# ca-todo-web--v1-yyy      False   2025-10-22T10:00:00Z   0

# v2 がアクティブ、v1 は非アクティブ
```

<div class="mt-4 bg-yellow-500/10 p-3 rounded text-sm">
💡 <strong>Revision の保持:</strong> 非アクティブな Revision も保持されます。必要に応じて、古い Revision に戻すことができます。
</div>

---

## STEP 2-14: 以前の Revision へのロールバック

問題が発生した場合、以前の Revision に戻すことができます。

```bash
# リビジョンモードを multiple に変更
az containerapp revision set-mode \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --mode multiple

# v1 の Revision 名を取得
# 取得できない場合はPortalでリビジョンとレプリカ > 非アクティブ リビジョンにて名前取得可能(ハイフン以下をv1と置き換える)
export V1_REVISION=$(az containerapp revision list \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "[?contains(name, 'v1')].name" \
  --output tsv)

# v1 に戻す
az containerapp ingress traffic set \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --revision-weight ${V1_REVISION}=100

# 確認
curl https://${APP_URL}

# v1 のレスポンスが返ってくる
```

<div class="mt-4 bg-blue-500/10 p-3 rounded text-sm">
💡 <strong>即座にロールバック:</strong> トラフィックの切り替えのみなので、数秒でロールバックが完了します。
</div>

---

## STEP 2-15: Container App の停止と起動

Container App を一時的に停止することができます。

<div class="grid grid-cols-2 gap-6 text-sm">

<div>

### Container App の停止

```bash
# Container App を停止
az containerapp revision deactivate \
  --revision $REVISION_NAME \
  --resource-group $RESOURCE_GROUP

# 確認
curl https://${APP_URL}

# エラーが返ってくる
# （すべての Revision が非アクティブ）
```

</div>

<div>

### Container App の起動

```bash
# Revision を再度アクティブ化
az containerapp revision activate \
  --revision $REVISION_NAME \
  --resource-group $RESOURCE_GROUP

# 確認
curl https://${APP_URL}

# 正常にレスポンスが返ってくる
```

</div>

</div>

<div class="mt-4 bg-yellow-500/10 p-3 rounded text-xs">
⚠️ <strong>停止中の課金:</strong> Revision が非アクティブでも、Container App 自体は存在するため、最小限の課金が発生する場合があります。完全に削除する場合は `az containerapp delete` を使用します。
</div>

---

## 動作確認チェックリスト

デプロイが正常に完了したか確認します。

<div class="text-sm">

### ✅ チェック項目

- [ ] Container App が正常にデプロイされた
- [ ] HTTPS URL でアクセスできる
- [ ] ブラウザでレスポンスが表示される
- [ ] ログが確認できる
- [ ] Log Analytics でログが確認できる
- [ ] メトリクスが表示される
- [ ] 負荷テストでスケーリングが確認できる
- [ ] 新しい Revision がデプロイできる
- [ ] 以前の Revision にロールバックできる

### 確認コマンド

```bash
# 総合確認
az containerapp show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "{Name:name, URL:properties.configuration.ingress.fqdn, State:properties.provisioningState, Replicas:properties.runningStatus}" \
  --output yaml
```

</div>

---

## トラブルシューティング

よくある問題と解決方法です。

<div class="text-xs">

| 問題                   | 原因                         | 解決方法                                                       |
| ---------------------- | ---------------------------- | -------------------------------------------------------------- |
| デプロイが失敗する     | イメージが見つからない       | ACR にイメージが正しくプッシュされているか確認                 |
| 502 Bad Gateway エラー | コンテナが起動していない     | ログを確認、`target-port` がアプリのポートと一致しているか確認 |
| URL にアクセスできない | Ingress が external でない   | `--ingress external` で作成されているか確認                    |
| レプリカが 0 のまま    | min-replicas が 0            | 正常動作、リクエストを送信するとレプリカが起動する             |
| ログが表示されない     | Log Analytics の同期待ち     | 数分待ってから再度確認                                         |
| 認証エラー             | ACR の認証情報が間違っている | `az acr credential show` で認証情報を確認                      |

### デバッグコマンド

```bash
# Revision のステータス確認
az containerapp revision show \
  --revision $REVISION_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "properties.provisioningState"

# コンテナのイベント確認
az containerapp logs show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --type system
```

</div>

---

## まとめ

Container Apps へのデプロイが完了しました。

<div class="grid grid-cols-2 gap-6 text-sm">

<div>

### 実施したこと

✅ **Container App のデプロイ**

- ACR からイメージを取得
- External Ingress でパブリック公開

✅ **動作確認**

- HTTPS URL でのアクセス
- ログとメトリクスの確認

✅ **Revision 管理**

- 新しいバージョンのデプロイ
- 以前のバージョンへのロールバック

✅ **スケーリング**

- 負荷テストによる自動スケール確認

</div>

<div>

### 次のステップ

次のハンズオンでは、より実践的な機能を学びます。

1. **環境変数とシークレット管理**
2. **Key Vault 連携**
3. **Revision 管理の詳細**
4. **トラフィック分割**

</div>

</div>

<div class="mt-4 bg-green-500/10 p-3 rounded text-sm">
✅ <strong>デプロイ完了!</strong> 次のハンズオンで環境変数とシークレット管理を学びます。
</div>
