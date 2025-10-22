---
theme: "default"
style: "./style.css"
title: "Azure サーバーレス & イベント駆動ハンズオン"
lang: "ja-JP"
drawings:
  enabled: true
highlighter: shiki
lineNumbers: false
info: |
  ## Azure サーバーレス & イベント駆動ハンズオン

  Azure Functions、Event Grid、Logic Appsを実践的に学び、
  サーバーレスとイベント駆動アーキテクチャの設計方法を理解するハンズオン資料です。
---

## Azure サーバーレス &<br>イベント駆動ハンズオン

実践で学ぶモダンアーキテクチャ

<div class="pt-12">
  <span @click="$slidev.nav.next" class="px-2 py-1 rounded cursor-pointer" hover="bg-white bg-opacity-10">
    Press Space for next page <carbon:arrow-right class="inline"/>
  </span>
</div>

---

## 本日のアジェンダ

サーバーレスとイベント駆動アーキテクチャを実践的に学び、モダンなクラウドアプリケーション開発の基礎を理解します。
<div class="pt-6">

### 基礎知識

- 📋 **前提条件**


### 実践ハンズオン

- ⚡ **① Azure Functions**
  - HTTPトリガーでREST API構築
  - Timerトリガーで定期実行
  - Blob/Queueトリガーでイベント処理

- 🔄 **② Event Grid**
  - イベント発行とサブスクリプション
  - カスタムトピックの作成
  - 複数サービスの連携

</div>

---
layout: center
---

## Azure サーバーレス サービス概要

Azure が提供する主要なサーバーレスサービスを理解し、用途に応じた使い分けを学びます。

<div class="grid grid-cols-3 gap-4 pt-6 text-xs">

<div class="bg-blue-500/10 p-3 rounded">

#### ⚡ Azure Functions（ハンズオン）

<div class="mt-2">
<strong>用途：</strong>イベント駆動のコード実行<br>
<strong>特徴：</strong>複数言語対応、豊富なトリガー、従量課金
</div>
</div>

<div class="bg-green-500/10 p-3 rounded">

#### 🔄 Event Grid（ハンズオン）

<div class="mt-2">
<strong>用途：</strong>イベントルーティングとメッセージング<br>
<strong>特徴：</strong>99.99%配信保証、フィルタリング、大規模スケール
</div>
</div>

<div class="bg-purple-500/10 p-3 rounded">

#### 🔧 Logic Apps（参考）

<div class="mt-2">
<strong>用途：</strong>ノーコードワークフロー自動化<br>
<strong>特徴：</strong>GUIデザイナー、400+コネクター、エンタープライズ統合
</div>
</div>

<div class="bg-yellow-500/10 p-3 rounded">

#### 📨 Event Hubs（参考）

<div class="mt-2">
<strong>用途：</strong>大規模ストリーミングデータ取り込み<br>
<strong>特徴：</strong>毎秒数百万イベント、Kafka互換
</div>
</div>

<div class="bg-orange-500/10 p-3 rounded">

#### 📦 Service Bus（参考）

<div class="mt-2">
<strong>用途：</strong>エンタープライズメッセージング<br>
<strong>特徴：</strong>トランザクション対応、メッセージセッション
</div>
</div>

<div class="bg-red-500/10 p-3 rounded">

#### ⏱️ Durable Functions（参考）

<div class="mt-2">
<strong>用途：</strong>ステートフルなオーケストレーション<br>
<strong>特徴：</strong>長時間実行ワークフロー、状態管理
</div>
</div>

</div>

---

## 各サービスの詳細説明（1/6）

### ⚡ Azure Functions

**どういうサービス？**

- サーバーレスで関数（コード）を実行するコンピューティングサービス
- イベントドリブンで自動的にスケールする

**主な特徴：**

- 複数言語サポート（C#, Java, JavaScript, Python, PowerShell）
- 豊富なトリガー（HTTP, Timer, Blob, Queue, Event Grid等）
- 従量課金プランと専有プラン（Premium/App Service Plan）

**何のため？**

- REST APIの構築
- 定期バッチ処理（毎時・毎日の集計など）
- ファイルアップロード時の自動処理（画像リサイズ、ウイルススキャン）
- IoTデバイスからのデータ処理

**比較：**

- **vs AWS Lambda**: 同等の機能だが、Azure統合が強力
- **vs App Service**: 常時稼働不要な処理に最適、コスト効率的
- **vs Logic Apps**: コードベース、より柔軟な制御

---

## 各サービスの詳細説明（2/6）

### 🔄 Event Grid

**どういうサービス？**

- イベントベースのメッセージングサービス
- パブリッシュ-サブスクライブモデルでイベントを配信

**主な特徴：**

- 99.99%の配信保証とat-least-once配信
- イベントフィルタリング（サブジェクト、データフィールド）
- カスタムトピックとシステムトピック
- デッドレター処理と再試行ポリシー

**何のため？**

- サービス間の疎結合な連携
- マイクロサービスアーキテクチャのイベント基盤
- リアクティブなアプリケーション構築
- システム全体のイベント監視と通知

**比較：**

- **vs Service Bus**: よりシンプル、イベントルーティングに特化
- **vs Event Hubs**: 大量ストリーミングデータには Event Hubs
- **vs Azure Relay**: リアルタイム双方向通信には Relay

---

## 各サービスの詳細説明（3/6）

### 🔧 Logic Apps

**どういうサービス？**

- ノーコード/ローコードでワークフローを自動化するサービス
- GUIデザイナーでビジネスプロセスを視覚的に構築

**主な特徴：**

- 400以上のコネクター（Office 365, Salesforce, SAP, Twitter等）
- 条件分岐、ループ、並列処理などの制御構造
- エンタープライズ統合パック（XML変換、AS2等）

**何のため？**

- ビジネスプロセスの自動化（承認フロー、通知など）
- 複数システムの統合（SaaS連携、オンプレミス連携）
- データ変換とマッピング
- スケジュール実行（定期レポート作成など）

**比較：**

- **vs Power Automate**: Logic Appsは開発者向け、より高度な制御
- **vs Azure Functions**: コード不要、GUIで直感的に構築
- **vs Durable Functions**: 複雑な状態管理にはDurable Functions

---

## 各サービスの詳細説明（4/6）

### 📨 Event Hubs

**どういうサービス？**

- 大規模なストリーミングデータの取り込みと処理を行うサービス
- Apache Kafka互換のイベントストリーミングプラットフォーム

**主な特徴：**

- 毎秒数百万〜数十億のイベントを処理可能
- パーティション機能による並列処理とスケーラビリティ
- イベントの保持期間設定（1〜90日間）
- Kafka APIとの互換性

**何のため？**

- IoTデバイスからのテレメトリデータ収集
- ログとメトリクスの集約
- リアルタイムストリーム処理（異常検知、データ分析）
- ビッグデータパイプラインの構築

**比較：**

- **vs Event Grid**: 大量ストリーミングデータにはEvent Hubs
- **vs Service Bus**: メッセージングよりもストリーム処理に特化
- **vs Kafka**: マネージドサービス、Azureとの統合が容易

---

## 各サービスの詳細説明（5/6）

### 📦 Service Bus

**どういうサービス？**

- エンタープライズグレードのメッセージングサービス
- 信頼性の高い非同期メッセージ配信を提供

**主な特徴：**

- トランザクションサポート（ACID保証）
- メッセージセッション（順序保証、状態管理）
- デッドレターキューとスケジューリング
- キューとトピック/サブスクリプションの2つのモデル

**何のため？**

- マイクロサービス間の確実なメッセージング
- 注文処理などのトランザクション処理
- バッチ処理の依頼とジョブキュー
- システム間の疎結合な連携

**比較：**

- **vs Event Grid**: メッセージングに特化、より高い信頼性保証
- **vs Azure Queue Storage**: エンタープライズ機能が豊富
- **vs RabbitMQ/ActiveMQ**: マネージドサービス、スケールが容易

---

## 各サービスの詳細説明（6/6）

### ⏱️ Durable Functions

**どういうサービス？**

- Azure Functionsの拡張機能
- ステートフルな関数のオーケストレーションを提供

**主な特徴：**

- 長時間実行ワークフローのサポート（数日〜数週間）
- 自動的な状態管理とチェックポイント
- 関数チェーン、ファンアウト/ファンイン、人間の承認待ち
- 永続的タイマーと外部イベント処理

**何のため？**

- 複数ステップのビジネスプロセス自動化
- 承認ワークフロー（人間の介入が必要な処理）
- 長時間実行するデータ処理パイプライン
- サーガパターンによる分散トランザクション

**比較：**

- **vs Logic Apps**: コードベース、より柔軟な制御と複雑なロジック
- **vs Azure Functions**: ステートフル、長時間実行に対応
- **vs Step Functions (AWS)**: 同等の機能、Azure統合が強力

---
layout: center
---

# 前提条件

ハンズオンを始める前に必要なものを準備しましょう

---

## 必要なアカウントとツール

ハンズオンをスムーズに進めるために、以下の準備をお願いします。

<div class="grid grid-cols-2 gap-8 pt-8">
<div>

### 1. Azure アカウント

Azure の各種サービスを利用するためのアカウントです。
<br>

- [Azure Portal](https://portal.azure.com) からサインアップ
- 無料アカウント作成可能（クレジットカード登録が必要ですが、12ヶ月の無料利用枠とクレジットが付与されます）
- 学生の方は [Azure for Students](https://azure.microsoft.com/ja-jp/free/students/) が利用できます

</div>
<div>

### 2. Azure CLI

コマンドラインから Azure リソースを操作するためのツールです。
GUI 操作よりも効率的で、スクリプトによる自動化も可能です。
<br>

```bash
# macOS (Homebrew)
brew update && brew install azure-cli

# Windows (Winget)
winget install -e --id Microsoft.AzureCLI

# インストール確認
az --version
```

</div>
</div>

---

## Azure へのログイン

Azure CLI を使って、Azure アカウントへログインします。

### CLI からのログイン

```bash
# ブラウザが起動し、ログインが求められます
az login

# 複数のサブスクリプションがある場合、一覧を確認
az account list --output table

# 使用するサブスクリプションを設定
az account set --subscription "YOUR_SUBSCRIPTION_ID"
```

---

## 環境変数の設定

```bash
# resource groupの設定
export RESOURCE_GROUP=

# Storage Accountの名前
export MY_STORAGE_NAME=

# Function Appsの名前
export MY_FUNC_NAME=

# Application Insightsの名前
export APP_INSIGHTS_NAME=

# Event Grid Topicの名前
export TOPIC_NAME=

# Event Grid Subscriptionの名前
export SUBSCRIPTION_NAME=

```

---

<div class="flex items-center gap-x-4">

## リソースグループの作成

<div class="text-sm bg-blue-500/20 px-2 py-1 rounded mb-3">👥 共有可能</div>
</div>

**リソースグループ**は、関連する Azure リソースをまとめて管理するための論理的なコンテナ（フォルダのようなもの）です。

このハンズオンで使用するリソースグループを作成します。

```bash
# このハンズオン用のリソースグループを作成
az group create \
  --name serverless-hands-on-rg \
  --location japaneast

# 作成されたことを確認
az group list --output table
```

**💡 重要:** リソースグループの`--location`は、メタデータの保存場所を指定します。<br>
その中に作成される各リソース（Functions、Event Grid等）は、それぞれ個別に`--location`を指定する必要があります。<br>
このハンズオンでは、すべてのリソースを`japaneast`に統一します。

---

## リソースプロバイダーの登録

初めて Azure Functions や Event Grid を使用する場合、リソースプロバイダーの登録が必要です。

```bash
# Microsoft.Webリソースプロバイダーを登録（Azure Functions用）
az provider register --namespace Microsoft.Web

# Microsoft.EventGridリソースプロバイダーを登録
az provider register --namespace Microsoft.EventGrid

# Microsoft.Logicリソースプロバイダーを登録（Logic Apps用）
az provider register --namespace Microsoft.Logic

# 登録状況を確認（Registeredになれば完了）
az provider show --namespace Microsoft.Web --query "registrationState" -o tsv
az provider show --namespace Microsoft.EventGrid --query "registrationState" -o tsv
az provider show --namespace Microsoft.Logic --query "registrationState" -o tsv
```

**💡 Tip:** 登録には数分かかる場合があります。`Registered`と表示されるまで待ちましょう。

---

## その他の必要ツール

サーバーレスアプリケーションの開発とデプロイに必要なツールを準備します。

<div class="grid grid-cols-2 gap-8 pt-4">
<div>

### Azure Functions Core Tools

ローカルでFunctionsを開発・テストするためのツールです。
<br>

```bash
# macOS (Homebrew)
brew tap azure/functions
brew install azure-functions-core-tools@4

# Windows (Winget)
winget install Microsoft.Azure.FunctionsCoreTools

# インストール確認
func --version
```

</div>
<div>

### Python

サンプルアプリケーションの実行や依存関係の管理に使用します。
<br>

```bash
# Python バージョン確認（3.9以上推奨、3.11推奨）
python3 --version

# pipバージョン確認
pip3 --version

# 仮想環境の作成（推奨）
python3 -m venv venv
source venv/bin/activate  # macOS/Linux
# または
venv\Scripts\activate  # Windows
```

<p class="text-xs">
※ このハンズオンでは Python を使用しますが、Azure Functions は C#, Java, Node.js, PowerShell など他の言語もサポートしています。
</p>
</div>
</div>

---
src: ./pages/01-function.md
---
---
src: ./pages/02-eventgrid.md
---
---
src: ./pages/99-summary.md
---