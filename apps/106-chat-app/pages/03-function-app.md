---
layout: center
---

# 🔧 ハンズオン ②

Azure Functions の開発とデプロイ（Python）

---

## ハンズオン ② の概要

このハンズオンでは、SignalR Service と連携する Azure Functions を Python で開発し、デプロイします。

<div class="pt-6">

### 🎯 学習目標

- Python での Azure Functions プロジェクト作成方法を習得する
- SignalR バインディングの使い方を理解する
- ローカル開発環境でのテスト方法を学ぶ
- Azure へのデプロイ方法を理解する

### 📋 実施内容

1. **Function App の作成** - Azure に Functions をホストするリソースを作成
2. **Python プロジェクト作成** - Functions プロジェクトを初期化
3. **Functions の実装** - negotiate、messages 関数を作成
4. **ローカルテスト** - Azure Functions Core Tools でテスト
5. **Azure へデプロイ** - 本番環境にデプロイ

</div>

---

## STEP 2-1: Function App の作成（Portal）- 1/2

Azure Functions をホストするための Function App を作成します。

1. **Function App の検索**

   - Azure Portal で「関数アプリ」または「Function App」を検索
   - 「+ 作成」をクリック

2. **基本タブの設定**

   - **サブスクリプション**: 使用するサブスクリプション
   - **リソース グループ**: `rg-chat-app-handson`
   - **関数アプリ名**: `func-chat-<your-unique-name>`
     - 例: `func-chat-taro123`
     - グローバルに一意である必要があります

---

## STEP 2-2: Function App の作成（Portal）- 2/2

続けて、ランタイムとホスティングの設定を行います。

3. **ランタイム設定**

   - **公開**: `コード`
   - **ランタイム スタック**: `Python`
   - **バージョン**: `3.12`
   - **リージョン**: `Japan East`
   - **オペレーティング システム**: `Linux`（Python は Linux のみサポート）
   - **価格プラン**: `Basic B1`

4. **ホスティング タブ**

   - **ストレージ アカウント**: `（新規）stchat<random>`
     - 自動生成される名前で OK

5. **確認および作成**

   - 「作成」をクリック
   - デプロイ完了まで約 2〜3 分待機

---

## STEP 2-3: Function App の作成（CLI）

Azure CLI で Function App を作成します。

```bash
# Storage Accountの作成（Functions用）
az storage account create \
  --name stchattaro123 \
  --resource-group rg-chat-app-handson \
  --location japaneast \
  --sku Standard_LRS

# Function Appの作成（Python 3.12）
az functionapp create \
  --name func-chat-taro123 \
  --resource-group rg-chat-app-handson \
  --storage-account stchattaro123 \
  --consumption-plan-location japaneast \
  --runtime python \
  --runtime-version 3.12 \
  --functions-version 4 \
  --os-type Linux

# 作成確認
az functionapp show \
  --name func-chat-taro123 \
  --resource-group rg-chat-app-handson \
  --query "{Name:name, State:state, Location:location, Runtime:siteConfig.linuxFxVersion}" \
  --output table
```

---

## STEP 2-4: SignalR 接続文字列の設定（Portal）

Function App から SignalR Service に接続するための設定を行います。

1. **Function App を開く**

   - 作成した Function App を開く

2. **構成ページを開く**

   - 左メニューの「設定」セクション
   - 「構成」または「環境変数」をクリック

3. **アプリケーション設定の追加**

   - 「+ 新しいアプリケーション設定」をクリック
   - **名前**: `AzureSignalRConnectionString`
   - **値**: SignalR Service の接続文字列（ハンズオン ① で取得したもの）
   - 「OK」をクリック

4. **保存**

   - 上部の「保存」をクリック
   - 確認ダイアログで「続行」をクリック

---

## STEP 2-5: SignalR 接続文字列の設定（CLI）

Azure CLI でアプリケーション設定を追加します。

```bash
# SignalR接続文字列を取得
SIGNALR_CONNECTION_STRING=$(az signalr key list \
  --name signalr-chat-taro123 \
  --resource-group rg-chat-app-handson \
  --query primaryConnectionString \
  --output tsv)

# Function Appにアプリケーション設定を追加
az functionapp config appsettings set \
  --name func-chat-taro123 \
  --resource-group rg-chat-app-handson \
  --settings AzureSignalRConnectionString="$SIGNALR_CONNECTION_STRING"

# 設定確認
az functionapp config appsettings list \
  --name func-chat-taro123 \
  --resource-group rg-chat-app-handson \
  --query "[?name=='AzureSignalRConnectionString'].{Name:name, Value:value}" \
  --output table
```

<div class="mt-4 text-xs opacity-75">
💡 接続文字列が正しく設定されているか確認してください。
</div>

---

## STEP 2-6: ローカル開発環境のセットアップ

ローカルで Functions を開発するための環境を準備します。

### 必要なツールの確認

```bash
# Pythonのバージョン確認
python --version
# Python 3.12.x と表示されればOK

# Azure Functions Core Toolsのインストール確認
func --version
# 4.x.x と表示されればOK

# インストールされていない場合（macOS）
brew tap azure/functions
brew install azure-functions-core-tools@4

# インストールされていない場合（Windows）
# npm install -g azure-functions-core-tools@4 --unsafe-perm true
```

### プロジェクト用ディレクトリの作成

```bash
# プロジェクトディレクトリの作成
mkdir chat-app-functions
cd chat-app-functions
```

---

## STEP 2-7: Functions プロジェクトの初期化

```bash
# Functionsプロジェクトの初期化（Python v2 モデル）
func init . --python --model V2

# 仮想環境の作成と有効化
python -m venv .venv

# 仮想環境の有効化（macOS/Linux）
source .venv/bin/activate

# 仮想環境の有効化（Windows）
# .venv\Scripts\activate

# 必要なパッケージのインストール
pip install -r requirements.txt
```

**生成されるファイル:**

- `function_app.py` - Functions の実装ファイル
- `requirements.txt` - Python パッケージ依存関係
- `host.json` - Functions ホスト設定
- `.funcignore` - デプロイ時に除外するファイル
- `local.settings.json` - ローカル設定（接続文字列など）

---

## STEP 2-8: ローカル設定ファイルの編集

`local.settings.json` を編集して、SignalR 接続文字列を設定します。

```json
{
  "IsEncrypted": false,
  "Values": {
    "AzureWebJobsStorage": "",
    "FUNCTIONS_WORKER_RUNTIME": "python",
    "AzureSignalRConnectionString": "Endpoint=https://signalr-chat-taro123.service.signalr.net;AccessKey=...;Version=1.0;"
  },
  "Host": {
    "CORS": "*",
    "CORSCredentials": false
  }
}
```

<div class="mt-4">

**設定項目の説明:**

- `AzureWebJobsStorage`: ストレージ接続文字列（ローカル開発では空文字列で OK）
- `AzureSignalRConnectionString`: SignalR Service の接続文字列（ハンズオン ① で取得）
- `CORS`: ローカルテスト用に全オリジンを許可
- `CORSCredentials`: 認証情報の送信設定

</div>

<div class="bg-red-500/10 p-3 rounded text-sm">
⚠️ <strong>重要：</strong>`local.settings.json` はGitにコミットしないでください。`.gitignore` に含まれていることを確認しましょう。
</div>

---

## STEP 2-9: negotiate 関数の実装

クライアントが SignalR Service に接続するための negotiate 関数を作成します。

### function_app.py を編集

```python
import azure.functions as func
import logging
import json

app = func.FunctionApp()

@app.function_name(name="negotiate")
@app.route(route="negotiate", auth_level=func.AuthLevel.ANONYMOUS)
@app.generic_input_binding(
    arg_name="connectionInfo",
    type="signalRConnectionInfo",
    hubName="default",
    connectionStringSetting="AzureSignalRConnectionString",
    # localでテストする際はコメントアウトする
    userId="{headers.x-ms-client-principal-name}"
)
def negotiate(req: func.HttpRequest, connectionInfo) -> func.HttpResponse:
    """SignalR接続情報を返す関数"""
    logging.info('Python HTTP trigger function processed a negotiate request.')

    return func.HttpResponse(
        connectionInfo,
        mimetype="application/json",
        status_code=200
    )
```

---

## STEP 2-10: negotiate 関数の解説

1. **SignalR Input Binding**

   ```python
   @app.generic_input_binding(
       arg_name="connectionInfo",
       type="signalRConnectionInfo",
       hubName="default",
       userId="{headers.x-ms-client-principal-name}"
   )
   ```

   - SignalR の接続情報を自動的に生成
   - `hubName`: SignalR のハブ名（`default` を使用）
   - `userId`: 認証済みユーザー名を設定（認証設定後に有効）

2. **HTTP トリガー関数**

   ```python
   @app.route(route="negotiate", auth_level=func.AuthLevel.ANONYMOUS)
   ```

   - GET/POST リクエストを受け付ける
   - 認証レベルは `ANONYMOUS`（Static Web Apps 経由でアクセスされるため）

3. **接続情報を返す**
   - クライアントは取得した情報を使って SignalR に接続

---

## STEP 2-11: messages 関数の実装

チャットメッセージを SignalR Service に送信する関数を作成します。

### function_app.py に追加

```python
from datetime import datetime

@app.function_name(name="messages")
@app.route(route="messages", auth_level=func.AuthLevel.ANONYMOUS, methods=["POST"])
@app.generic_output_binding(
    arg_name="signalRMessages",
    type="signalR",
    hubName="default",
    connectionStringSetting="AzureSignalRConnectionString"
)
def messages(req: func.HttpRequest, signalRMessages: func.Out[str]) -> func.HttpResponse:
    """チャットメッセージをSignalRに送信する関数"""
    logging.info('Python HTTP trigger function processed a messages request.')

    try:
        # リクエストボディからメッセージを取得
        req_body = req.get_json()
        sender = req_body.get('sender', 'Anonymous')
        text = req_body.get('text', '')

        if not text:
            return func.HttpResponse(
                "Message text is required",
                status_code=400
            )

        # SignalRに送信するメッセージを作成
        message = {
            "target": "newMessage",
            "arguments": [{
                "sender": sender,
                "text": text,
                "timestamp": datetime.utcnow().isoformat() + "Z"
            }]
        }

        # SignalRにメッセージを送信
        signalRMessages.set(json.dumps(message))

        return func.HttpResponse(
            "Message sent",
            status_code=200
        )

    except Exception as e:
        logging.error(f"Error processing message: {str(e)}")
        return func.HttpResponse(
            f"Error: {str(e)}",
            status_code=500
        )
```

---

## STEP 2-12: messages 関数の解説

1. **SignalR Output Binding**

   ```python
   @app.generic_output_binding(
       arg_name="signalRMessages",
       type="signalR",
       hubName="default"
   )
   ```

   - SignalR にメッセージを送信するためのバインディング

2. **リクエストボディの解析**

   ```python
   req_body = req.get_json()
   sender = req_body.get('sender', 'Anonymous')
   text = req_body.get('text', '')
   ```

   - クライアントから送信された JSON を解析
   - 期待されるフォーマット: `{ "sender": "username", "text": "message" }`

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

3. **メッセージオブジェクトの作成**

   ```python
   message = {
       "target": "newMessage",  # クライアント側で受信するイベント名
       "arguments": [{"sender": sender, "text": text, "timestamp": ...}]
   }
   ```

</div>
<div>

4. **SignalR に送信**
   - 接続中のすべてのクライアントにブロードキャスト

</div>
</div>

---

## STEP 2-13: requirements.txt の更新

必要な Python パッケージを追加します。

```txt
# requirements.txt
azure-functions
```

<div class="mt-4 text-sm opacity-75">
💡 SignalR バインディングは `azure-functions` パッケージに含まれているため、追加のパッケージは不要です。
</div>

### インストール

```bash
pip install -r requirements.txt
```

---

## STEP 2-14: プロジェクト構成の確認

作成したプロジェクトの構成を確認します。

```
chat-app-functions/
├── function_app.py           # Functions実装（negotiate, messages）
├── requirements.txt          # Pythonパッケージ依存関係
├── host.json                 # Functionsホスト設定
├── local.settings.json       # ローカル設定（接続文字列）
├── .funcignore              # デプロイ除外ファイル
└── .venv/                   # Python仮想環境
```

<div class="mt-4 text-sm">

**各ファイルの役割:**

- **function_app.py**: negotiate と messages 関数の実装
- **requirements.txt**: 必要な Python パッケージのリスト
- **local.settings.json**: ローカル開発用の設定（接続文字列など）
- **host.json**: Functions 全体の設定

</div>

---

## STEP 2-15: ローカルでのテスト

Azure Functions Core Tools を使ってローカルでテストします。

```bash
# Functionsを起動
func start

# 期待される出力
Azure Functions Core Tools
Core Tools Version:       4.x.x
Function Runtime Version: 4.x.x

Functions:

  negotiate: [GET,POST] http://localhost:7071/api/negotiate

  messages: [POST] http://localhost:7071/api/messages

For detailed output, run func with --verbose flag.
```

<div class="mt-4 bg-yellow-500/10 p-3 rounded text-sm">
⚠️ <strong>警告メッセージについて：</strong>以下のような警告が表示される場合がありますが、Functions は正常に動作します。

- `google._upb` のモジュールキャッシュ警告 → 無視して OK
- `Blob Storage Secret Repository` への接続エラー → ローカル開発では影響なし
</div>

---

## STEP 2-16: negotiate 関数のテスト

ローカルで動作確認を行います。

### curl でテスト

```bash
# negotiate関数を呼び出し
curl http://localhost:7071/api/negotiate

# 期待されるレスポンス（例）:
# {
#   "url": "https://signalr-chat-taro123.service.signalr.net/...",
#   "accessToken": "eyJ..."
# }
```

### ブラウザでテスト

ブラウザで `http://localhost:7071/api/negotiate` にアクセスして、JSON が返ってくることを確認します。

<div class="mt-4 bg-blue-500/10 p-3 rounded text-sm">
💡 <strong>デバッグのコツ：</strong>VS Codeを使用している場合、Azure Functions拡張機能を活用してデバッグできます。
</div>

---

## STEP 2-17: messages 関数のテスト

メッセージ送信機能をテストします。

```bash
# messagesエンドポイントにPOSTリクエスト
curl -X POST http://localhost:7071/api/messages \
  -H "Content-Type: application/json" \
  -d '{
    "sender": "TestUser",
    "text": "Hello, World!"
  }'

# 期待されるレスポンス:
# Message sent
```

<div class="mt-4 text-sm">

**トラブルシューティング:**

**エラー: "Failed to send message to SignalR"**

- `local.settings.json` の接続文字列を確認
- SignalR Service がサーバーレスモードになっているか確認

**エラー: "Function not found"**

- Functions が正しく起動しているか確認
- `func start` を再実行

</div>

---

## STEP 2-18: Azure へのデプロイ

ローカルテストが成功したら、Azure にデプロイします。

```bash
# Azureにデプロイ
func azure functionapp publish func-chat-taro123

# または、設定も一緒に公開
func azure functionapp publish func-chat-taro123 --publish-local-settings
```

**デプロイの流れ:**

1. Python パッケージのインストール
2. 依存関係のパッケージング
3. Azure へのアップロード
4. Functions の起動

<div class="mt-4 bg-yellow-500/10 p-3 rounded text-sm">
⚠️ <strong>注意：</strong>`--publish-local-settings` オプションは、local.settings.jsonの設定をAzureにコピーします。PortalまたはCLIで設定済みの場合は不要です。
</div>

---

## STEP 2-19: デプロイの確認

デプロイが成功したか確認します。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">
<div>

### Portal での確認

1. **Function App を開く**

   - Azure Portal で Function App を開く

2. **関数一覧の確認**

   - 左メニューの「関数」をクリック
   - `negotiate` と `messages` が表示されることを確認

3. **関数の実行テスト**

   - `negotiate` をクリック
   - 「コードとテスト」→「テスト/実行」
   - 「実行」をクリックして、レスポンスを確認

</div>
<div>

### CLI での確認

```bash
# デプロイされた関数の一覧を取得
az functionapp function list \
  --name func-chat-taro123 \
  --resource-group rg-chat-app-handson \
  --output table
```

</div>
</div>
---

## STEP 2-20: 本番環境でのテスト

デプロイした Functions をテストします。

```bash
# Function AppのホストURLを取得
FUNCTION_URL=$(az functionapp show \
  --name func-chat-taro123 \
  --resource-group rg-chat-app-handson \
  --query defaultHostName \
  --output tsv)

# negotiate関数をテスト
curl https://$FUNCTION_URL/api/negotiate

# messages関数をテスト
curl -X POST https://$FUNCTION_URL/api/messages \
  -H "Content-Type: application/json" \
  -d '{
    "sender": "TestUser",
    "text": "Hello from Azure!"
  }'
```

<div class="mt-4 bg-green-500/10 p-3 rounded text-sm">
✅ 正常にレスポンスが返ってきたら、Functions のデプロイは成功です！
</div>

---

## STEP 2-21: Functions の監視

Functions の実行状況を監視します。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">

<div>

### Application Insights（推奨）

**有効化:**

1. Function App →「Application Insights」
2. 「有効にする」をクリック

**監視内容:**

- 関数の実行回数
- 応答時間
- エラー率
- 依存関係（SignalR への呼び出し）

</div>

<div>

### ログストリーム

**Portal での確認:**

1. Function App →「ログ ストリーム」
2. リアルタイムでログを確認

**CLI での確認:**

```bash
az webapp log tail \
  --name func-chat-taro123 \
  --resource-group rg-chat-app-handson
```

</div>

</div>

---

## ハンズオン ② のまとめ

Azure Functions（Python）の開発とデプロイが完了しました。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">

<div>

### ✅ 達成したこと

- ✅ Function App の作成
- ✅ SignalR 接続文字列の設定
- ✅ Python での negotiate 関数の実装
- ✅ Python での messages 関数の実装
- ✅ ローカルテスト
- ✅ Azure へのデプロイ

</div>

<div>

### 🔑 重要なポイント

- **Python v2 モデル**: デコレータベースで簡潔
- **SignalR バインディング**: Input/Output バインディングで簡単統合
- **negotiate パターン**: クライアントが接続情報を取得
- **ローカル開発**: Functions Core Tools で効率的に開発
- **監視**: Application Insights で実行状況を把握

</div>
</div>
