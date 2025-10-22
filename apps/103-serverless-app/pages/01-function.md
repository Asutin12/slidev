---
layout: center
---

# ハンズオン ① Azure Functions

サーバーレス関数で REST API と自動処理を構築

---

## Azure Functions / Function Apps の用語整理

まず、よく混同される 2 つの用語を整理しましょう。

<div class="grid grid-cols-2 gap-8 pt-6">
<div class="bg-blue-500/10 p-4 rounded">

### 🔧 Azure Functions

**= プログラミングモデル / ランタイム**

- 実際のコード（関数）を書く仕組み
- トリガー、バインディングなどの機能を提供
- コードの実行エンジン

**例:** Python、Node.js、C# で書いた関数

</div>
<div class="bg-green-500/10 p-4 rounded">

### 📦 Function App

**= ホスティング環境 / リソース管理単位**

- Azure Functions を実行する「コンテナ」
- ストレージアカウントや設定を管理
- スケーリング、デプロイの単位

**例:** `func-app-20251016`（Azure リソース）

</div>
</div>

<div class="mt-6 bg-yellow-500/10 p-3 rounded text-sm">
<strong>📝 わかりやすい例え：</strong>
<ul class="mt-2">
<li><strong>Function App</strong> = アパート（建物）</li>
<li><strong>Azure Functions</strong> = 各部屋（実際に住む場所）</li>
</ul>
1つのアパート（Function App）に複数の部屋（個別の関数）が入っています。
</div>

---

## Function Apps ハンズオン概要

**目的:** サーバーレス関数（Azure Functions）を作成し、イベント駆動処理を実装する

<div class="grid grid-cols-2 gap-8 pt-6">
<div>

### 📚 学べるポイント

- **サーバーレスの概念**
  - イベント駆動アーキテクチャ
- **Trigger/Binding**
  - Blob Trigger、HTTP Trigger
- **Storage Account 連携**
  - Blob Storage の使用
- **ログ監視**
  - Application Insights でのログ確認

</div>
<div>

### 🎯 ハンズオン内容

1. **Storage Account の作成**
2. **Function App の作成**
3. **HTTP Trigger 関数の作成とデプロイ**
4. **Timer Trigger 関数の作成**
5. **Blob Trigger 関数の作成**
6. **Queue Trigger 関数の作成**
7. **ローカル開発とデバッグ**
8. **Application Insights でのモニタリング**

</div>
</div>

---

## Storage Account とは？

**Azure Storage Account** は、クラウド上でデータを保存するための統合ストレージサービスです。

<div class="grid grid-cols-2 gap-8 pt-6">
<div>

### 🗄️ 主な機能

- **Blob Storage:** ファイル・画像・動画などの非構造化データ
- **Queue Storage:** メッセージキュー（非同期処理）
- **Table Storage:** NoSQL データストア
- **File Storage:** SMB ファイル共有

<br>

**💡 今回のハンズオンでは Blob Storage を使用**

画像ファイルを保存し、Function App から自動的にサムネイルを生成します。

</div>
<div>

### ✨ 特徴

- **高い可用性:** データは自動的に複製される
- **スケーラブル:** 容量制限なく拡張可能
- **低コスト:** 使った分だけ課金、GB 単位で安価
- **セキュア:** 暗号化、アクセス制御が標準装備

### 📦 料金体系

- ストレージ容量（GB/月）
- データ転送量（アップロード・ダウンロード）
- 操作回数（読み取り・書き込み）

</div>
</div>

---

## Blob Storage の「コンテナ」とは？

**コンテナ（Container）**は、Blob（ファイル）を格納するための**論理的なフォルダ**です。

<div class="grid grid-cols-2 gap-8 pt-6">
<div>

### 🗂️ 概念の理解

```
Storage Account (ストレージアカウント)
 └── Container (コンテナ) = フォルダ
      └── Blob (ファイル) = 実際のデータ
```

**例：写真管理アプリの場合**

```
mystorageacct
 ├── images/          ← 元画像を保存
 │    ├── photo1.jpg
 │    └── photo2.png
 └── thumbnails/      ← サムネイルを保存
      ├── photo1.jpg
      └── photo2.png
```

</div>
<div>

### 🔑 コンテナの役割

- **データの整理:** 用途別にファイルを分類
- **アクセス制御:** コンテナ単位で権限設定
- **バックアップ:** コンテナ単位で管理しやすい

### 📝 アクセスレベル

- **Private（既定）:** 認証が必要
- **Blob:** Blob への匿名読み取り可
- **Container:** コンテナと Blob の一覧も取得可

**💡 セキュリティのため、通常は Private を推奨**

</div>
</div>

---

## 接続文字列とは？

**接続文字列（Connection String）**は、Storage Account にアクセスするための**認証情報が含まれた文字列**です。

<div class="grid grid-cols-2 gap-8 pt-6">
<div>

### 🔐 接続文字列の構造

```
DefaultEndpointsProtocol=https;
AccountName=mystorageacct20251007;
AccountKey=abc123xyz...;
EndpointSuffix=core.windows.net
```

**含まれる情報:**

- **AccountName:** ストレージアカウント名
- **AccountKey:** アクセスキー（パスワードのようなもの）
- **Endpoint:** 接続先 URL

**⚠️ 重要:** AccountKey は機密情報です！

</div>
<div>

### 🔑 なぜ必要？

アプリケーションが Storage Account にアクセスするには、**誰がアクセスしているか**を証明する必要があります。

**接続文字列の用途:**

1. **Function App の設定**
   - Blob Trigger で画像を監視
   - サムネイルを自動保存
2. **アプリケーションコード**
   - SDK から Storage 操作
3. **Azure CLI/SDK**
   - コマンドラインからの操作

</div>
</div>

---

## 接続文字列の安全な管理

接続文字列は機密情報のため、適切に管理する必要があります。

**1. 環境変数を使用**

```javascript
// アプリケーションコード
const connectionString = process.env.AZURE_STORAGE_CONNECTION_STRING;
```

**2. App Service の環境変数に設定**

```bash
az webapp config appsettings set \
  --name my-function-app \
  --settings \
    AzureWebJobsStorage="<接続文字列>"
```

**3. Azure Key Vault を使用（本番推奨）**

- より高度なシークレット管理
- アクセスログ・監査機能

---

<div class="flex items-center gap-x-4">

## ステップ 1: Storage Account の作成

<div class="text-sm bg-blue-500/20 px-2 py-1 rounded mb-3">👥 共有可能</div>
</div>

それでは実際に Storage Account を作成し、コンテナと接続文字列を取得します。

```bash
# Storage Account作成（名前は世界で一意である必要があります）
az storage account create \
  --name $MY_STORAGE_NAME \
  --resource-group $RESOURCE_GROUP \
  --location japaneast \
  --sku Standard_LRS

# コンテナ作成（元画像用）
az storage container create \
  --name images \
  --account-name $MY_STORAGE_NAME

# コンテナ作成（サムネイル用）
az storage container create \
  --name thumbnails \
  --account-name $MY_STORAGE_NAME

# 接続文字列取得（後で使用するのでメモしておく）
az storage account show-connection-string \
  --name $MY_STORAGE_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "connectionString" -o tsv
```

**💡 Tip:** 取得した接続文字列は後のステップで使用します。安全な場所に保存してください。

---

## ステップ 2: Function App の作成

**Function App**（Azure Functions を実行する環境）を作成します。

<div class="bg-orange-500/10 p-3 rounded mb-4 text-sm">
<strong>👤 複数人での実施:</strong> Function Appの名前も世界で一意である必要があります（例: <code>func-app-tanaka-20251016</code>）
</div>

<div class="grid grid-cols-2 gap-8">
<div>

```bash
# Function App作成（Python 3.12）
az functionapp create \
  --name $MY_FUNC_NAME \
  --resource-group $RESOURCE_GROUP \
  --consumption-plan-location japaneast \
  --runtime python \
  --runtime-version 3.12 \
  --functions-version 4 \
  --storage-account $MY_STORAGE_NAME \
  --os-type Linux

# 作成確認
az functionapp list --output table
```

</div>
<div>

**プランの選択:**

- **Consumption Plan（従量課金）**: 実行時のみ課金、自動スケール（推奨）
- **Premium Plan**: 常時稼働、VNet 統合、より高性能
- **Dedicated Plan（App Service Plan）**: 予測可能な価格、既存の App Service Plan 利用
</div>
</div>

<div class="bg-blue-500/10 p-3 rounded mt-4 text-sm">
<strong>💡 補足:</strong> このコマンドで作成されるのは <strong>Function App</strong>（実行環境）です。この後、<code>func new</code> コマンドで個別の <strong>Azure Functions</strong>（関数コード）を作成していきます。
</div>

---

## ステップ 3-1: HTTP Trigger 関数の作成

ローカル開発環境で **Azure Functions**（個別の関数コード）を作成します。

```bash
# プロジェクトディレクトリの作成と初期化
mkdir my-functions-app && cd my-functions-app

# Functionsプロジェクトの初期化（Python v2モデル）
func init --worker-runtime python --model V2

# HTTP Trigger関数を作成
func new --name HttpTriggerDemo --template "HTTP trigger"

# プロンプトが表示されるので以下を入力:
# Authorization level: anonymous
```

<div class="bg-blue-500/10 p-3 rounded mt-4 text-sm">
<strong>💡 ポイント:</strong>
<ul class="mt-2 mb-0">
<li><code>func init</code>: Function App プロジェクト（複数の関数をまとめる単位）を初期化</li>
<li><code>func new</code>: 個別の Azure Functions（関数）を作成</li>
<li>1つのプロジェクトに複数の関数を含めることができます</li>
</ul>
</div>

---

## ステップ 3-2: HTTP Trigger 関数の作成

**`function_app.py` を編集:**

```python
import azure.functions as func
import logging
import json
from datetime import datetime

app = func.FunctionApp()

@app.function_name(name="HttpTriggerDemo")
@app.route(route="HttpTriggerDemo", methods=["GET", "POST"], auth_level=func.AuthLevel.ANONYMOUS)
def http_trigger_demo(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('HTTP trigger function processed a request.')

    name = req.params.get('name')
    if not name:
        try:
            req_body = req.get_json()
            name = req_body.get('name')
        except ValueError:
            name = req.get_body().decode('utf-8') if req.get_body() else None

    if not name:
        name = "World"

    response_data = {
        "message": f"Hello, {name}!",
        "timestamp": datetime.utcnow().isoformat() + "Z"
    }

    return func.HttpResponse(
        json.dumps(response_data),
        status_code=200,
        mimetype="application/json"
    )
```

---

## ステップ 4: ローカルでのテスト

ローカル環境で関数を実行してテストします。

```bash
# ローカルで関数を起動
func start

# 別のターミナルでテスト
curl "http://localhost:7071/api/HttpTriggerDemo?name=Azure"

# POSTリクエストのテスト
curl -X POST http://localhost:7071/api/HttpTriggerDemo \
  -H "Content-Type: application/json" \
  -d '{"name": "Serverless"}'
```

**期待されるレスポンス:**

```json
{
  "message": "Hello, Azure!",
  "timestamp": "2025-10-16T12:34:56.789Z"
}
```

**💡 Tip:** `Ctrl + C` でローカルサーバーを停止できます。

---

## ステップ 5: Azure へのデプロイ

ローカルで作成した **Azure Functions**（関数コード）を Azure の **Function App**（実行環境）にデプロイします。

```bash
# Azureにデプロイ（ローカルの関数 → Azure Function App）
func azure functionapp publish $MY_FUNC_NAME

# デプロイ完了後、URLを確認
echo "Function URL:"
az functionapp function show \
  --name $MY_FUNC_NAME \
  --resource-group $RESOURCE_GROUP \
  --function-name HttpTriggerDemo \
  --query "invokeUrlTemplate" -o tsv

# ブラウザまたはcurlでテスト
curl "https://$MY_FUNC_NAME.azurewebsites.net/api/HttpTriggerDemo?name=Production"
```

<div class="bg-blue-500/10 p-3 rounded mt-4 text-sm">
<strong>💡 理解ポイント:</strong>
<ul class="mt-2 mb-0">
<li><code>func azure functionapp publish</code>: ローカルのプロジェクト全体を Azure にデプロイ</li>
<li>デプロイ先は、ステップ2で作成した <strong>Function App</strong></li>
<li>1つの Function App に複数の関数をまとめてデプロイできます</li>
</ul>
</div>

**💡 Tip:** デプロイには数分かかる場合があります。完了するまで待ちましょう。

---

## ステップ 6-1: Timer Trigger 関数の作成

定期実行される関数を作成します。

```bash
# Timer Trigger関数を作成
func new --name TimerTriggerDemo --template "Timer trigger"
```

**Cron 式の例:**

- `0 */5 * * * *` - 5 分ごと
- `0 0 * * * *` - 1 時間ごと
- `0 0 9 * * *` - 毎日午前 9 時
- `0 0 0 * * MON` - 毎週月曜日の午前 0 時

---

## ステップ 6-2: Timer Trigger 関数の作成

**`function_app.py` に Timer Trigger 関数を追加:**

```python
@app.function_name(name="TimerTriggerDemo")
@app.schedule(
    schedule="0 */5 * * * *",  # ← 5分おきに実行
    arg_name="myTimer",
    run_on_startup=False,
    use_monitor=False
)
def timer_trigger_demo(myTimer: func.TimerRequest) -> None:
    logging.info('Timer trigger function executed at: %s', datetime.utcnow().isoformat())

    # 定期実行したい処理を書く
    logging.info('Periodic task executed')

    if myTimer.past_due:
        logging.info('The timer is past due!')
```

---

## ステップ 7-1: Blob Trigger 関数の作成

ローカルで Function App プロジェクトを作成します。

```bash
# Blob Trigger関数を追加（対話形式）
func new --name ThumbnailGenerator --template "Blob trigger"
```

**対話形式で以下を入力:**

- **Container Path:** `images/{name}` （監視するコンテナとファイルパターン）
- **Storage Account Connection String:** `AzureWebJobsStorage` （環境変数名）

**💡 Tip:** Azure Functions Python v2 プログラミングモデルでは、デコレーターベースの簡潔な構文を使用します。

---

## ローカル開発用の接続文字列設定

`local.settings.json` に接続文字列を設定します。

```json
{
  "IsEncrypted": false,
  "Values": {
    "AzureWebJobsStorage": "<ステップ1で取得した接続文字列をここに貼り付け>",
    "FUNCTIONS_WORKER_RUNTIME": "python"
  }
}
```

**接続文字列の取得コマンド（再掲）:**

```bash
az storage account show-connection-string \
  --name $MY_STORAGE_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "connectionString" -o tsv
```

**⚠️ 重要:**

- `local.settings.json` はローカル開発専用で、Azure にはデプロイされません
- `.gitignore` に含まれているため、Git にコミットされません（セキュリティのため）
- 本番環境では、Function App の環境変数として自動設定されます

---

## ステップ 7-2: Blob Trigger 関数の作成

まず、Pillow ライブラリを`requirements.txt`に追加します。

```txt
# requirements.txt
azure-functions
Pillow
```

```bash
#仮想環境の作成（推奨）
python3 -m venv venv
source venv/bin/activate  # macOS/Linux
# または
venv\Scripts\activate  # Windows

# 依存関係をインストール
pip install -r requirements.txt
```

---

## ステップ 7-3: Blob Trigger 関数の作成

次に、関数のコードを実装します（Python v2 プログラミングモデル）。

```python
# function_app.py
from PIL import Image
from io import BytesIO


@app.function_name(name="BlobTriggerDemo")
@app.blob_trigger(
    arg_name="inputblob",
    path="images/{name}",
    connection="AzureWebJobsStorage"
)
@app.blob_output(
    arg_name="outputblob",
    path="thumbnails/{name}",
    connection="AzureWebJobsStorage"
)
def ThumbnailGenerator(inputblob: func.InputStream, outputblob: func.Out[bytes]):
    logging.info(f'Blob trigger processing: {inputblob.name}')

    try:
        # 画像を読み込み
        image = Image.open(inputblob)

        # サムネイル生成（幅200pxに縮小、アスペクト比維持）
        image.thumbnail((200, 200), Image.Resampling.LANCZOS)

        # BytesIOに保存
        output = BytesIO()
        image.save(output, format=image.format or 'JPEG')

        # Output Bindingに設定
        outputblob.set(output.getvalue())

        logging.info('Thumbnail generated successfully')
    except Exception as e:
        logging.error(f'Error generating thumbnail: {e}')
        raise
```

**💡 重要:** Python v2 プログラミングモデルでは、デコレーターを使ってトリガーと出力バインディングを定義します。

---

## ステップ 8-1: Queue Trigger 関数の作成

Queue からメッセージを受け取って処理する関数を作成します。

```bash
# Queueを作成
az storage queue create \
  --name tasks \
  --account-name $MY_STORAGE_NAME

# Queue Trigger関数を作成
func new --name QueueTriggerDemo --template "Queue trigger"

# プロンプトが表示されるので以下を入力:
# Queue Name: tasks
# Storage Connection String: AzureWebJobsStorage
```

---

## ステップ 8-2: Queue Trigger 関数の作成

**`function_app.py` に Queue Trigger 関数を追加:**

```python
@app.function_name(name="QueueTriggerDemo")
@app.queue_trigger(
    arg_name="msg",
    queue_name="tasks",
    connection="AzureWebJobsStorage"
)
def queue_trigger_demo(msg: func.QueueMessage):
    try:
        # メッセージの取得
        message_body = msg.get_body().decode('utf-8')
        logging.info('Queue trigger function received message: %s', message_body)

        # JSON 解析
        try:
            task = json.loads(message_body)
        except json.JSONDecodeError as e:
            logging.error('Failed to decode JSON: %s', e)
            # JSON 解析失敗は Poison に入れないよう処理を終了
            return

        logging.info('Task ID: %s', task.get('id'))
        logging.info('Task Type: %s', task.get('type'))
        logging.info('Task Data: %s', task.get('data'))

        # ここで非同期タスク処理を実装
        # 例: メール送信、データベース更新など
        # 必要に応じて try/except で個別に保護

    except Exception as error:
        # 全体例外はログに残すだけで Poison に入れない
        logging.error('Unexpected error processing queue message: %s', error)
```

---

## ステップ 9: すべての関数をデプロイ

作成したすべての **Azure Functions** を 1 つの **Function App** にデプロイします。

```bash
# Azureに再デプロイ（プロジェクト内のすべての関数をデプロイ）
func azure functionapp publish $MY_FUNC_NAME

# 関数一覧を確認
az functionapp function list \
  --name $MY_FUNC_NAME \
  --resource-group $RESOURCE_GROUP \
  --output table
```

<strong>💡 アーキテクチャの整理:</strong>

```
Function App ← 実行環境
 ├── HttpTriggerDemo     ← Azure Functions（個別の関数）- REST API（HTTP リクエストで実行）
 ├── TimerTriggerDemo    ← Azure Functions（個別の関数）- 定期実行（スケジュールで実行）
 ├── BlobTriggerDemo     ← Azure Functions（個別の関数）- ファイルアップロード時の処理（Blob イベントで実行）
 └── QueueTriggerDemo    ← Azure Functions（個別の関数）- キューメッセージ処理（Queue メッセージで実行）
```

---

## ステップ 10-1: 各関数のテスト

デプロイした関数をテストします。

**1. HTTP Trigger のテスト:**

```bash
curl "https://$MY_FUNC_NAME.azurewebsites.net/api/HttpTriggerDemo?name=Test"
```

**2. Timer Trigger のテスト:**

Timer Trigger は自動的に定期実行されます。Azure Portal でログを確認できます。

**3. Blob Trigger のテスト:**

```bash
# 画像をアップロードしてテスト（imagesコンテナに保存すると自動的にサムネイルが生成される）
az storage blob upload \
  --account-name $MY_STORAGE_NAME \
  --container-name images \
  --name test.png \
  --file ./test.png

# サムネイルが生成されたか確認
az storage blob list \
  --account-name $MY_STORAGE_NAME \
  --container-name thumbnails \
  --output table

# Azure Portalのログで実行確認
```

---

## ステップ 10-2: 各関数のテスト

**4. Queue Trigger のテスト:**

```bash
# キューにメッセージを送信（base64エンコード）
az storage message put \
  --account-name $MY_STORAGE_NAME \
  --queue-name tasks \
  --content $(echo -n '{"id":"task-001","type":"email","data":{"to":"user@example.com"}}' | base64)

# Azure Portalのログで実行確認
```

---

## ステップ 11: Application Insights でのモニタリング

Application Insights で関数の実行状況を監視します。

**Application Insights の有効化:**

```bash
# Application Insightsを作成
az monitor app-insights component create \
  --app $APP_INSIGHTS_NAME \
  --location japaneast \
  --resource-group $RESOURCE_GROUP \
  --application-type web

# Instrumentation Keyを取得
INSTRUMENTATION_KEY=$(az monitor app-insights component show \
  --app $APP_INSIGHTS_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "instrumentationKey" -o tsv)

# Function AppにInstrumentation Keyを設定
az functionapp config appsettings set \
  --name $MY_FUNC_NAME \
  --resource-group $RESOURCE_GROUP \
  --settings APPINSIGHTS_INSTRUMENTATIONKEY="$INSTRUMENTATION_KEY"
```
