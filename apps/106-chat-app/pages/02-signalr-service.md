---
layout: center
---

# ⚡ ハンズオン ①

Azure SignalR Service の作成

---

## ハンズオン ① の概要

このハンズオンでは、Azure SignalR Service を作成し、リアルタイム通信の基盤を構築します。

<div class="pt-6">

### 🎯 学習目標

- Azure SignalR Service の作成方法を理解する
- サービスモード（サーバーレス）の設定を学ぶ
- 接続文字列の取得方法を習得する
- Portal と CLI の両方の作成方法を理解する

### 📋 実施内容

1. **リソースグループの作成** - すべてのリソースを格納するグループ
2. **SignalR Service の作成（Portal）** - Azure Portal で作成
3. **SignalR Service の作成（CLI）** - コマンドラインで作成
4. **接続文字列の確認** - Functions で使用する接続情報の取得

</div>

---

## STEP 1-1: リソースグループの作成（Portal）

すべてのリソースを格納するリソースグループを作成します。

1. **Azure Portal にアクセス**

   - [https://portal.azure.com](https://portal.azure.com) にアクセス

2. **リソースグループの作成**

   - ホーム画面で「リソース グループ」を検索
   - 「+ 作成」をクリック

3. **基本設定**

   - **サブスクリプション**: 使用するサブスクリプション
   - **リソース グループ**: `rg-chat-app-handson`
   - **リージョン**: `Japan East`

4. **確認と作成**
   - 「確認および作成」→「作成」をクリック

<div class="mt-4 bg-blue-500/10 p-3 rounded text-sm">
💡 <strong>ポイント：</strong>リソースグループ名は、プロジェクトや用途がわかりやすい名前にしましょう。ハンズオン終了後は、このリソースグループごと削除すれば、すべてのリソースを一括削除できます。
</div>

---

## STEP 1-2: リソースグループの作成（CLI）

Azure CLI でリソースグループを作成することもできます。

```bash
# Azure CLI でログイン（初回のみ）
az login

# リソースグループの作成
az group create \
  --name rg-chat-app-handson \
  --location japaneast

# 作成確認
az group show \
  --name rg-chat-app-handson \
  --query "{Name:name, Location:location, ProvisioningState:properties.provisioningState}" \
  --output table
```

**期待される出力:**

```
Name                   Location    ProvisioningState
---------------------  ----------  -------------------
rg-chat-app-handson   japaneast   Succeeded
```

<div class="mt-4 text-xs opacity-75">
💡 CLI版は、スクリプト化や自動化に便利です。Infrastructure as Code（IaC）の一部として活用できます。
</div>

---

## STEP 1-3: SignalR Service の作成（Portal）- 1/2

Azure Portal で SignalR Service を作成します。

1. **SignalR Service の検索**

   - Azure Portal のホーム画面で「SignalR」を検索
   - 「SignalR Service」を選択
   - 「+ 作成」をクリック

2. **基本タブの設定**
   - **サブスクリプション**: 使用するサブスクリプション
   - **リソース グループ**: `rg-chat-app-handson`
   - **リソース名**: `signalr-chat-<your-unique-name>`
     - 例: `signalr-chat-taro123`
     - グローバルに一意である必要があります
   - **リージョン**: `Japan East`
   - **価格レベル**: `Free`（20 同時接続まで無料）

<div class="mt-4 bg-yellow-500/10 p-3 rounded text-sm">
⚠️ <strong>注意：</strong>リソース名はグローバルに一意である必要があります。他のユーザーが使用している名前は使用できません。自分の名前や数字を組み合わせて、ユニークな名前にしてください。
</div>

---

## STEP 1-4: SignalR Service の作成（Portal）- 2/2

3. **サービス モードの設定**

   - **サービス モード**: `Serverless`（サーバーレス）を選択

   <div class="mt-2 text-sm">

   **サービスモードの種類:**

   - **Default**: 専用サーバーが必要（App Service など）
   - **Serverless**: Azure Functions で使用（今回はこれ）
   - **Classic**: 従来の接続モード

   </div>

4. **ネットワーク タブ**

   - デフォルト設定のまま（パブリック エンドポイント）

5. **確認および作成**
   - 設定を確認
   - 「作成」をクリック
   - デプロイ完了まで約 2〜3 分待機

<div class="mt-4 bg-green-500/10 p-3 rounded text-sm">
✅ デプロイが完了したら、「リソースに移動」をクリックして、作成したSignalR Serviceを確認しましょう。
</div>

---

## STEP 1-5: SignalR Service の作成（CLI）

Azure CLI で SignalR Service を作成します。

```bash
# SignalR Serviceの作成（Free tier、Serverlessモード）
az signalr create \
  --name signalr-chat-taro123 \
  --resource-group rg-chat-app-handson \
  --location japaneast \
  --sku Free_F1 \
  --service-mode Serverless \
  --output table

# 作成には2〜3分かかります
# 完了を待つ場合は --no-wait を外してください

# SignalR Serviceの詳細を確認
az signalr show \
  --name signalr-chat-taro123 \
  --resource-group rg-chat-app-handson \
  --query "{Name:name, Location:location, Sku:sku.name, ServiceMode:serviceMode, ProvisioningState:provisioningState}" \
  --output table

# 期待される出力
Name                  Location   Sku      ServiceMode  ProvisioningState
--------------------  ---------  -------  -----------  -------------------
signalr-chat-taro123  japaneast  Free_F1  Serverless   Succeeded
```

---

## STEP 1-6: 接続文字列の取得（Portal）

Azure Functions から SignalR Service に接続するための接続文字列を取得します。

1. **SignalR Service を開く**

   - Azure Portal で作成した SignalR Service を開く

2. **キー ページを開く**

   - 左メニューの「設定」セクション
   - 「キー」をクリック

3. **接続文字列をコピー**
   - **プライマリ接続文字列** をコピー
   - 安全な場所にメモしておく（後で使用します）

<div class="mt-4 bg-red-500/10 p-3 rounded text-sm">
⚠️ <strong>重要：</strong>接続文字列には、サービスにアクセスするための認証情報が含まれています。GitHub などの公開リポジトリにコミットしないように注意してください。本番環境では、Azure Key Vault を使用して安全に管理しましょう。
</div>

---

## STEP 1-7: 接続文字列の取得（CLI）

Azure CLI で接続文字列を取得します。

```bash
# プライマリ接続文字列の取得
az signalr key list \
  --name signalr-chat-taro123 \
  --resource-group rg-chat-app-handson \
  --query primaryConnectionString \
  --output tsv

# 出力例:
Endpoint=https://signalr-chat-taro123.service.signalr.net;AccessKey=abc...xyz;Version=1.0;
```

**環境変数に保存（任意）:**

```bash
# 後で使いやすいように環境変数に保存
export SIGNALR_CONNECTION_STRING=$(az signalr key list \
  --name signalr-chat-taro123 \
  --resource-group rg-chat-app-handson \
  --query primaryConnectionString \
  --output tsv)

# 確認
echo $SIGNALR_CONNECTION_STRING
```

<div class="mt-4 text-xs opacity-75">
💡 環境変数に保存しておくと、後の手順で使いやすくなります。
</div>

---

## STEP 1-8: SignalR Service の設定確認

作成した SignalR Service の設定を確認します。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">

<div>

### Portal での確認

1. **概要ページ**

   - リソース名、リージョン、SKU を確認
   - エンドポイント URL を確認
   - プロビジョニング状態が「成功」であることを確認

2. **設定の確認**

   - 「設定」→「サービス モード」
   - `Serverless` が選択されていることを確認

3. **メトリクス（任意）**
   - 「監視」→「メトリクス」
   - 接続数、メッセージ数などを確認できます

</div>

<div>

### 確認すべき項目

✅ **リソース名**

- グローバルに一意の名前
- 後の手順で使用

✅ **サービス モード**

- `Serverless` になっているか
- Azure Functions で使用するために必須

✅ **価格レベル**

- `Free` tier（20 同時接続まで）
- 必要に応じてスケールアップ可能

✅ **接続文字列**

- 安全に保管
- Functions の設定で使用

</div>

</div>

---

## STEP 1-9: SignalR Service の制限事項（Free tier）

Free tier の制限を理解しておきましょう。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">

<div>

### Free tier の制限

| 項目                | 制限   |
| ------------------- | ------ |
| **同時接続数**      | 20     |
| **メッセージ数/日** | 20,000 |
| **ユニット数**      | 1      |
| **可用性 SLA**      | なし   |

### Standard tier との比較

**Standard tier (S1) の場合:**

- 同時接続数: 1,000
- メッセージ数: 無制限
- 99.9% SLA
- 価格: 約 ¥5,000/月

</div>

<div>

### ハンズオンでの注意点

**Free tier で十分な場合**

- ✅ 開発・テスト環境
- ✅ 小規模なアプリケーション
- ✅ プロトタイプ開発

**Standard tier が必要な場合**

- ⚠️ 本番環境
- ⚠️ 20 接続以上必要
- ⚠️ SLA が必要

<div class="mt-4 bg-blue-500/10 p-3 rounded">
💡 <strong>ポイント：</strong>ハンズオンでは Free tier で十分です。本番環境に移行する際は、必要に応じて Standard tier にアップグレードしましょう。
</div>

</div>

</div>

---

## STEP 1-10: トラブルシューティング

SignalR Service 作成時によくある問題と対処法です。

<div class="text-sm">

**1. リソース名が既に使用されている**

```
エラー: リソース名 'signalr-chat-test' は既に使用されています
```

**解決策:**

- リソース名にユニークな文字列を追加（名前、数字など）
- 例: `signalr-chat-taro123`、`signalr-chat-20251020`

**2. サービスモードが変更できない**

**解決策:**

- 作成後は変更不可
- 削除して再作成する必要があります

**3. 接続文字列が見つからない**

**解決策:**

- プロビジョニングが完了しているか確認
- 「キー」ページを再読み込み
- CLI の場合: `az signalr key list` コマンドを再実行

</div>

---

## ハンズオン ① のまとめ

Azure SignalR Service の作成が完了しました。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">

<div>

### ✅ 達成したこと

- ✅ リソースグループの作成
- ✅ SignalR Service の作成
- ✅ サーバーレスモードの設定
- ✅ 接続文字列の取得
- ✅ Portal と CLI 両方の方法を学習

</div>

<div>

### 🔑 重要なポイント

- **リソース名**: グローバルに一意
- **サービスモード**: Serverless を選択
- **Free tier**: 20 同時接続まで無料
- **接続文字列**: 安全に管理
- **作成後の変更**: サービスモードは変更不可

</div>
</div>
