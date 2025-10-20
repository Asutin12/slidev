---
theme: "default"
style: "./style.css"
title: "Azure App Service 系サービスハンズオン"
lang: "ja-JP"
drawings:
  enabled: true
highlighter: shiki
lineNumbers: false
info: |
  ## Azure App Service 系サービスハンズオン

  Web Apps、API Apps、Application Insightsを実践的に学び、
  Mobile Apps、Web App for Containers、Azure Functions / Function Appsの概要を理解するハンズオン資料です。
---

## Azure App Service 系サービス<br>ハンズオン

実践で学ぶ PaaS プラットフォーム

<div class="pt-12">
  <span @click="$slidev.nav.next" class="px-2 py-1 rounded cursor-pointer" hover="bg-white bg-opacity-10">
    Press Space for next page <carbon:arrow-right class="inline"/>
  </span>
</div>

---

## 本日のアジェンダ

Azure App Service 系サービスを実践的に学び、Azure でのアプリケーション運用の基礎を理解します。

<div class="grid grid-cols-2 gap-x-6 pt-6 text-sm">
<div>

### 基礎知識

- 🌐 **App Service の全体像**
- 📋 **前提条件**

### 実践ハンズオン（3 つ）

- 🚀 **① Web Apps**
  - Next.js アプリをデプロイ
- 🔌 **② API Apps**
  - REST API の構築とデプロイ
- 📊 **③ Application Insights**
  - アプリケーション監視

</div>
<div>

### 詳細説明（3 つ）

- 📲 **Mobile Apps** - モバイルバックエンド、認証・同期
- 🐳 **Web App for Containers** - Docker コンテナホスティング
- ⚡ **Azure Functions / Function Apps** - サーバーレス、イベント駆動

</div>
</div>

---
layout: center
---

# Azure App Service とは？

<br>

**Web アプリケーションを手軽に、そしてパワフルに公開するための<br>フルマネージド・ホスティングサービス**

---

## Azure App Service の魅力

Azure App Service は、Web アプリや API を迅速に構築、デプロイ、スケーリングできる **PaaS (Platform as a Service)** です。
インフラストラクチャの管理から解放され、開発者はアプリケーションの価値創造に集中できます。

<div class="grid grid-cols-2 gap-x-8 gap-y-4 pt-6">

<div class="bg-gray-500/10 p-4 rounded">

#### 🚀 簡単デプロイ

Git, GitHub, Azure DevOps など、多彩なソースからシームレスにデプロイ可能。CI/CD パイプラインも簡単に構築できます。

</div>

<div class="bg-gray-500/10 p-4 rounded">

#### 🔧 インフラ管理不要

サーバーのプロビジョニング、OS の更新、セキュリティパッチの適用など、面倒なインフラ管理は Azure が自動で行います。

</div>

<div class="bg-gray-500/10 p-4 rounded">

#### 📈 自動スケーリング

トラフィックの増減に応じて、インスタンス数を自動で調整。高いパフォーマンスとコスト効率を両立します。

</div>

<div class="bg-gray-500/10 p-4 rounded">

#### 💻 多言語対応

.NET, Java, Node.js, Python, PHP, Ruby など、使い慣れた言語やフレームワークを自由に選択できます。

</div>

</div>

---

## App Service 系サービス概要

Azure App Service ファミリーの主要サービスを理解し、用途に応じた使い分けを学びます。

<div class="grid grid-cols-3 gap-4 pt-6 text-xs">

<div class="bg-blue-500/10 p-3 rounded">

#### 🚀 Web Apps（ハンズオン）

<div class="mt-2">
<strong>用途：</strong>Webサイト・Webアプリケーションのホスティング<br>
<strong>特徴：</strong>簡単デプロイ、自動スケーリング、複数言語対応
</div>
</div>

<div class="bg-green-500/10 p-3 rounded">

#### 🔌 API Apps（ハンズオン）

<div class="mt-2">
<strong>用途：</strong>RESTful APIの構築と公開<br>
<strong>特徴：</strong>CORS設定、API Management連携、Swagger統合
</div>
</div>

<div class="bg-red-500/10 p-3 rounded">

#### 📊 Application Insights（ハンズオン）

<div class="mt-2">
<strong>用途：</strong>アプリケーション監視・パフォーマンス分析<br>
<strong>特徴：</strong>APM機能、KQLクエリ、リアルタイム監視
</div>
</div>

<div class="bg-purple-500/10 p-3 rounded">

#### 📲 Mobile Apps（概要）

<div class="mt-2">
<strong>用途：</strong>モバイルアプリ向けバックエンド<br>
<strong>特徴：</strong>認証統合、オフライン同期、プッシュ通知
</div>
</div>

<div class="bg-cyan-500/10 p-3 rounded">

#### 🐳 Web App for Containers（概要）

<div class="mt-2">
<strong>用途：</strong>Dockerコンテナのホスティング<br>
<strong>特徴：</strong>カスタムイメージ、ACR連携、CI/CD対応
</div>
</div>

<div class="bg-yellow-500/10 p-3 rounded">

#### ⚡ Azure Functions / Function Apps（概要）

<div class="mt-2">
<strong>用途：</strong>イベント駆動・サーバーレス処理<br>
<strong>特徴：</strong>従量課金、トリガー豊富、スケールアウト自動<br>
<strong>補足：</strong>Function App = 実行環境、Azure Functions = 個別の関数コード
</div>
</div>

</div>

---

## 各サービスの詳細説明（1/6）

### 🚀 Web Apps

**どういうサービス？**

- Web アプリケーションをホストするためのフルマネージドプラットフォーム
- インフラ管理不要でコードに集中できる PaaS

**主な特徴：**

- 多言語対応（.NET, Java, Node.js, Python, PHP, Ruby）
- Git/GitHub/Azure DevOps から直接デプロイ可能
- 自動スケーリング、カスタムドメイン、無料 SSL 証明書

**何のため？**

- Web サイトやダッシュボード、SaaS アプリケーションの公開
- サーバー運用負荷を減らし、開発スピードを向上

**比較：**

- **vs EC2/VMs**: インフラ管理不要、デプロイが簡単、運用コスト削減
- **vs Heroku**: 同様の PaaS だが、Azure エコシステムとの統合が強力
- **vs Static Web Apps**: 動的処理やサーバーサイドレンダリングが必要な場合に最適

---

## 各サービスの詳細説明（2/6）

### 🔌 API Apps

**どういうサービス？**

- RESTful API をホストするための特化型 Web Apps
- Web Apps の機能に加え、API 向けの機能を追加

**主な特徴：**

- CORS 設定が簡単（クロスオリジンリクエストの制御）
- Swagger/OpenAPI 統合で API 仕様の自動生成
- API Management との連携でゲートウェイ機能

**何のため？**

- マイクロサービスアーキテクチャのバックエンド API
- フロントエンドから呼び出されるデータ API
- 外部サービスとの統合ポイント

**比較：**

- **vs Web Apps**: API 特化の機能（CORS、Swagger）が標準装備
- **vs API Management**: API の実装・ホストは API Apps、管理・制御は API Management
- **vs AWS API Gateway + Lambda**: より統合されたホスティング、シンプルな構成

---

## 各サービスの詳細説明（3/6）

### 📊 Application Insights

**どういうサービス？**

- アプリケーションパフォーマンス監視（APM）ツール
- Azure Monitor の一部

**主な特徴：**

- リアルタイムメトリクス、分散トレース
- KQL クエリでログ分析
- アラート・通知機能

**何のため？**

- アプリケーションの健全性監視
- パフォーマンスボトルネック特定
- エラー・例外の追跡

**比較：**

- **vs DataDog/New Relic**: Azure 統合が深く、コスト優位
- **vs CloudWatch**: より高度な APM 機能

---

## 各サービスの詳細説明（4/6）

### 📲 Mobile Apps

**どういうサービス？**

- モバイルアプリケーション向けのバックエンドサービス
- iOS、Android、Windows、Xamarin などのマルチプラットフォーム対応

**主な特徴：**

- 認証プロバイダー統合（Azure AD、Google、Facebook、Twitter 等）
- オフラインデータ同期（ネットワーク断絶時も動作）
- プッシュ通知（Notification Hubs 連携）
- カスタム API 構築と Easy Tables

**何のため？**

- モバイルアプリの迅速な開発とバックエンド構築
- ユーザー認証とソーシャルログインの実装
- オフラインファースト対応のデータ管理

**比較：**

- **vs Firebase**: 同等の機能だが、Azure エコシステムとの統合が強力
- **vs AWS Amplify**: より統合されたモバイルバックエンド、認証が簡単
- **vs カスタム API**: 認証・同期などの機能が標準装備で開発速度が向上

---

## 各サービスの詳細説明（5/6）

### 🐳 Web App for Containers

**どういうサービス？**

- Docker コンテナをホストするためのサービス
- Web Apps の機能をコンテナ環境で利用可能

**主な特徴：**

- カスタム Docker イメージのデプロイ
- ACR（Azure Container Registry）または Docker Hub からプル
- 継続的デプロイ（CI/CD）対応
- 複数コンテナ構成（Docker Compose サポート）

**何のため？**

- 既存の Docker コンテナをそのままクラウドで実行
- カスタムランタイムや特殊な依存関係が必要な場合
- 開発環境と本番環境の一貫性を保つ

**比較：**

- **vs Web Apps**: より柔軟なカスタマイズが可能、コンテナ化のオーバーヘッドあり
- **vs AKS**: よりシンプルな構成、オーケストレーション不要な単一アプリ向け
- **vs AWS ECS/Fargate**: 同等のコンテナホスティング、Azure 統合が強み

---

## 各サービスの詳細説明（6/6）

### ⚡ Azure Functions / Function Apps

**どういうサービス？**

- **Azure Functions**: サーバーレスコンピューティングのランタイム/プログラミングモデル
  - 実際のコード（関数）を書く仕組み
- **Function App**: Azure Functions をホストする実行環境（管理単位）
  - Azure Functions を実行する「コンテナ」

**主な特徴：**

- **従量課金**: 実行回数・時間のみ課金、アイドル時は無料
- **豊富なトリガー**: HTTP、Timer、Blob、Queue、Event Grid など
- **自動スケーリング**: トラフィックに応じて自動的にスケール
- **イベント駆動**: 各種イベントに応じて関数を実行

**何のため？**

- 定期バッチ処理（毎日のレポート生成など）
- 画像変換・動画処理（アップロード時に自動処理）
- Webhook 受信（GitHub、Slack などのイベント処理）
- 非同期タスク実行（メール送信、データ処理）

**比較：**

- **vs Web Apps**: 常時稼働不要、コスト効率的、イベント駆動
- **vs AWS Lambda**: 同等のサーバーレス、Azure サービスとの統合が強み
- **vs Logic Apps**: コード記述が必要だが、より柔軟な処理が可能

**ホスティングプラン：**

- **Consumption Plan（従量課金）**: 実行時のみ課金、自動スケール（推奨）
- **Premium Plan**: 常時稼働、VNet 統合、より高性能
- **Dedicated Plan（App Service Plan）**: 予測可能な価格、既存の App Service Plan 利用

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
- 無料アカウント作成可能（クレジットカード登録が必要ですが、12 ヶ月の無料利用枠とクレジットが付与されます）
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

# Web appsの名前
export MY_WEB_NAME=

# API Appsの名前
export MY_API_NAME=

# Application Insightsの名前
export APP_INSIGHTS_NAME=

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
  --name $RESOURCE_GROUP \
  --location japaneast

# 作成されたことを確認
az group list --output table
```

**💡 重要:** リソースグループの`--location`は、メタデータの保存場所を指定します。<br>
その中に作成される各リソース（App Service、Storage 等）は、それぞれ個別に`--location`を指定する必要があります。<br>
このハンズオンでは、すべてのリソースを`japaneast`に統一します。

---

## リソースプロバイダーの登録

初めて App Service を使用する場合、リソースプロバイダーの登録が必要です。

```bash
# Microsoft.Webリソースプロバイダーを登録
az provider register --namespace Microsoft.Web

# 登録状況を確認（Registeredになれば完了）
az provider show --namespace Microsoft.Web --query "registrationState" -o tsv
```

**💡 Tip:** 登録には数分かかる場合があります。`Registered`と表示されるまで待ちましょう。

<div class="bg-blue-500/10 p-3 rounded mt-4 text-sm">
<strong>📝 補足:</strong> このハンズオンでは以下のリソースプロバイダーを使用します。初回利用時はそれぞれ登録が必要です。
<ul class="mt-2 mb-0">
<li><code>Microsoft.Web</code> - App Service, Function Apps</li>
<li><code>Microsoft.Storage</code> - Storage Account</li>
<li><code>Microsoft.Insights</code> - Application Insights</li>
</ul>
</div>

---

## その他の必要ツール

Web アプリケーションの開発とデプロイに必要なツールを準備します。

<div class="grid grid-cols-2 gap-8 pt-4">
<div>

### Node.js と パッケージマネージャー

サンプルアプリケーションの実行や依存関係の管理に使用します。
<br>

```bash
# Node.js バージョン確認（22 以上推奨）
node --version

# npm または bun のバージョン確認
npm --version
bun --version
```

<br>
<p class="text-xs">
※ このハンズオンでは Node.js を使用しますが、App Service は Python, Java, .NET など他の言語もサポートしています。
</p>
</div>
<div>

### Git & Docker

ソースコードのバージョン管理と、コンテナデプロイに使用します。
<br>

```bash
# Git のバージョン確認
git --version

# Docker のバージョン確認
docker --version

# Git の初期設定（未設定の場合）
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

</div>
</div>

---
layout: center
---

# ハンズオン ① Web Apps

Next.js アプリを App Service にデプロイして公開

---

## Web Apps ハンズオン概要

**目的:** App Service の基本的な使い方を学び、実践的な Web アプリケーションを公開する

<div class="grid grid-cols-2 gap-8 pt-6">
<div>

### 📚 学べるポイント

- **App Service Plan の理解**
  - リソースの仕様と価格レベル
- **Next.js アプリのデプロイ**
  - SSR アプリケーションの構築と公開
- **ZIP デプロイの実践**
  - ビルド成果物のデプロイ
- **基本設定と運用知識**
  - 環境変数の管理
  - カスタムドメイン（参考）
  - HTTPS/SSL 証明書（参考）

</div>
<div>

### 🎯 ハンズオン内容

1. **App Service Plan / Web App 作成**
2. **Next.js アプリの作成**
3. **Standalone 出力の設定**
4. **ビルドとデプロイ**
5. **カスタムドメイン・HTTPS**（参考知識）

</div>
</div>

---

<div class="flex items-center gap-x-4">

## ステップ 1: App Service Plan の作成

<div class="text-sm bg-blue-500/20 px-2 py-1 rounded mb-3">👥 共有可能</div>
</div>

まず、Web アプリの土台となる **App Service Plan** を作成します。

```bash
# App Service Plan 作成 (B1プラン)
az appservice plan create \
  --name webapp-plan \
  --resource-group $RESOURCE_GROUP \
  --location japaneast \
  --sku B1 \
  --is-linux

# 作成されたプランを確認
az appservice plan list --output table
```

**App Service Plan とは？**

- **コンピューティングリソースの仕様を定義**するもの
- リージョン、OS、価格レベル (Free, Basic, Standard, Premium) を決定
- 一つの Plan 上に複数の Web App を配置可能

---

## ステップ 2: Web App の作成

作成した Plan の上に Web アプリを作成します。

<div class="bg-orange-500/10 p-3 rounded mb-4 text-sm mt-3">
<strong>👤 複数人での実施:</strong> Web Appの名前は世界で一意である必要があります。各自、自分の名前や日付を含めた一意な名前を使用してください（例: <code>my-webapp-tanaka-20251007</code>）
</div>

```bash
# Node.js 22-lts ランタイムで Web アプリを作成
az webapp create \
  --name $MY_WEB_NAME \
  --resource-group $RESOURCE_GROUP \
  --plan webapp-plan \
  --runtime "NODE:22-lts"

# 作成された Web App を確認
az webapp list --output table

# ブラウザで開く
az webapp browse \
  --name $MY_WEB_NAME \
  --resource-group $RESOURCE_GROUP
```

**💡 Tip:** `--name` はグローバルで一意な名前が必要です。

---

## ステップ 3: Next.jsアプリのデプロイ

今回はNext.jsでアプリケーションをビルド結果をZIPにしたものがあるのでそれをダウンロードし、デプロイしていきます。
ダウンロードしたzipを解凍し、package.jsonをREADME.mdの通り修正してください。

```bash
# cdで該当のフォルダに移動後
npm install
npm run build

# デプロイ用のZIPファイル作成
zip -r ./my-nextjs-app.zip .next public package.json node_modules

# ZIPデプロイ（--src-pathはダウンロードした箇所と現在のカレントディレクトリによる）
az webapp deploy \
  --name $MY_WEB_NAME \
  --resource-group $RESOURCE_GROUP \
  --src-path ./my-nextjs-app.zip \
  --type zip

# デプロイ完了後、ブラウザで開く
az webapp browse \
  --name $MY_WEB_NAME \
  --resource-group $RESOURCE_GROUP
```

---

## ステップ 4: カスタムドメインと HTTPS（参考知識）

<div class="bg-blue-500/10 p-3 rounded mb-4 text-sm">
<strong>💡 参考情報:</strong> このステップはハンズオンでは実施しません。独自ドメインを持っている場合や、本番環境で使用する際の参考知識として確認してください。
</div>

カスタムドメインを追加し、HTTPS を有効化する方法です。

<div class="grid grid-cols-2 gap-8 pt-2">
<div>

### カスタムドメイン追加

```bash
# DNSにCNAMEレコードを追加
# www.example.com → my-webapp.azurewebsites.net

# ドメインを追加
az webapp config hostname add \
  --webapp-name $MY_WEB_NAME \
  --resource-group $RESOURCE_GROUP \
  --hostname www.example.com
```

</div>
<div>

### HTTPS 有効化

```bash
# マネージド証明書を作成
az webapp config ssl create \
  --name $MY_WEB_NAME \
  --resource-group $RESOURCE_GROUP \
  --hostname www.example.com

# HTTPS リダイレクトを有効化
az webapp update \
  --name $MY_WEB_NAME \
  --resource-group $RESOURCE_GROUP \
  --https-only true
```

</div>
</div>

---
layout: center
---

# ハンズオン ② API Apps

Node.js/Go の REST API をデプロイして GET/POST 実行

---

## API Apps ハンズオン概要

**目的:** RESTful API を構築し、App Service で公開する

<div class="grid grid-cols-2 gap-8 pt-6">
<div>

### 📚 学べるポイント

- **API の設計と実装**
  - RESTful エンドポイント設計
- **API のテスト**
  - Postman/cURL での動作確認
- **CORS の設定（参考）**
  - クロスオリジンリクエスト許可
- **環境変数の管理（参考）**
  - API キー、接続文字列の設定

</div>
<div>

### 🎯 ハンズオン内容

1. **Node.js Express API の作成**
   - GET/POST エンドポイント実装
2. **API Apps へのデプロイ**
   - App Service へのデプロイ
3. **CORS 設定**（参考知識）
   - フロントエンドからのアクセス許可
4. **環境変数の設定**（参考知識）
   - 機密情報の管理方法

</div>
</div>

---

## Local Git デプロイとは？

App Service へのデプロイ方法の一つで、Git を使ってソースコードを直接プッシュする方式です。

<div class="grid grid-cols-2 gap-8 pt-6">
<div>

### 🔄 仕組み

1. **App Service が Git リポジトリを提供**
   - 各 Web App に専用の Git URL が発行される
2. **ローカルから Git Push**
   - `git push azure main` でデプロイ
3. **自動ビルド・デプロイ**
   - App Service 側で自動的にビルドして起動

</div>
<div>

### 📊 他のデプロイ方法との比較

| 方式 | 特徴 |
|------|------|
| **Local Git** | Git でバージョン管理しながらデプロイ |
| **ZIP デプロイ** | ビルド済みファイルをアップロード |
| **GitHub Actions** | CI/CD パイプラインで自動化 |
| **Azure DevOps** | エンタープライズ向け CI/CD |

</div>
</div>

<div class="mt-3">

**💡 メリット:** Git の履歴管理とデプロイを統合でき、ロールバックも簡単
</div>

---

## ステップ 1: API Apps の作成とデプロイ

<div class="bg-orange-500/10 p-3 rounded mb-4 text-sm">
<strong>👤 複数人での実施:</strong> API Appも一意な名前が必要です（例: <code>my-api-app-tanaka-20251007</code>）
</div>

```bash
# まず、APIのZipをダウンロードする

# API App作成
az webapp create \
  --name $MY_API_NAME \
  --resource-group $RESOURCE_GROUP \
  --plan webapp-plan \
  --runtime "NODE:22-lts"

# Local Git デプロイを有効化
GIT_URL=$(az webapp deployment source config-local-git \
  --name $MY_API_NAME \
  --resource-group $RESOURCE_GROUP \
  --query url -o tsv)

# package install
npm install

# Git リモートを登録
git init
git remote add azure $GIT_URL

# コードをpushしてデプロイ
git add .
git commit -m "first deploy"
git push azure main

# デプロイ完了後、動作確認
curl https://$MY_API_NAME.azurewebsites.net/api/hello
```

---

## ステップ 2: CORS 設定（参考知識）

<div class="bg-blue-500/10 p-3 rounded text-sm">
<strong>💡 参考情報:</strong> フロントエンドアプリケーション（別のドメイン）からこのAPIを呼び出す場合に必要な設定です。
</div>

**CORS とは？**  
異なるオリジン（ドメイン）の Web アプリから JavaScript で API を呼び出す際に必要な設定です。

**CORS 設定例:**

```bash
# CORS設定（すべてのオリジンを許可）
az webapp cors add \
  --name $MY_API_NAME \
  --resource-group $RESOURCE_GROUP \
  --allowed-origins '*'

# 特定のドメインのみ許可する場合（本番環境推奨）
az webapp cors add \
  --name $MY_API_NAME \
  --resource-group $RESOURCE_GROUP \
  --allowed-origins 'https://example.com'
```

**💡 Tip:** curl/Postman からのリクエストや、ブラウザのアドレスバーに直接 URL を入力する場合は CORS 設定は不要です。

---

## ステップ 3: 環境変数の設定（参考知識）

<div class="bg-blue-500/10 p-3 rounded text-sm">
<strong>💡 参考情報:</strong> APIキーやデータベース接続文字列などの機密情報を扱う場合の参考知識として確認してください。
</div>

API キーなどの機密情報を環境変数で管理する方法です。

```bash
# 環境変数の設定
az webapp config appsettings set \
  --name $MY_API_NAME \
  --resource-group $RESOURCE_GROUP \
  --settings API_KEY="your-secret-key" \
              DATABASE_URL="your-db-connection-string"

# 環境変数の確認
az webapp config appsettings list \
  --name $MY_API_NAME \
  --resource-group $RESOURCE_GROUP
```

**Node.js から環境変数にアクセス:**

```javascript
const apiKey = process.env.API_KEY;
const dbUrl = process.env.DATABASE_URL;
```

---

## API のテスト

curl または Postman で API をテストします。

```bash
# GET リクエスト
curl https://$MY_API_NAME.azurewebsites.net/api/hello

# POST リクエスト
curl -X POST https://$MY_API_NAME.azurewebsites.net/api/data \
  -H "Content-Type: application/json" \
  -d '{"name":"Azure User"}'
```

**期待されるレスポンス:**

```json
{
  "message": "Received: Azure User",
  "timestamp": "2025-10-07T12:34:56.789Z"
}
```

---
layout: center
---

# ハンズオン ③ Application Insights

ログ監視を追加してアプリケーションを可視化

---

## Application Insights ハンズオン概要

**目的:** アプリケーションの監視とパフォーマンス分析を実装する

<div class="grid grid-cols-2 gap-8 pt-6">
<div>

### 📚 学べるポイント

- **Application Insights の統合**
  - APM (Application Performance Monitoring)
- **ログとトレースの収集**
  - リクエスト、例外、依存関係
- **Kusto クエリ言語 (KQL)**
  - ログ分析クエリの記述
- **アラート設定**
  - 異常検知と通知

</div>
<div>

### 🎯 ハンズオン内容

1. **Application Insights の作成**
   - 監視リソースの準備
2. **App Service への統合**
   - 自動計装の設定
3. **カスタムイベントの追加**
   - アプリケーションコードからのログ送信
4. **KQL クエリでのログ分析**
   - Request/Exception/Dependency 分析

</div>
</div>

---

## ステップ 1: Application Insights の作成

監視リソースを作成します。

```bash
# Application Insights作成
az monitor app-insights component create \
  --app $APP_INSIGHTS_NAME \
  --location japaneast \
  --resource-group $RESOURCE_GROUP \
  --application-type web

# Instrumentation Key取得
az monitor app-insights component show \
  --app $APP_INSIGHTS_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "instrumentationKey" -o tsv

# Connection String取得
az monitor app-insights component show \
  --app $APP_INSIGHTS_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "connectionString" -o tsv
```

---

## ステップ 2: App Service への統合

既存の Web App に Application Insights を連携します。

```bash
# 接続文字列を取得（先ほど取得した値を使用）
CONNECTION_STRING=$(az monitor app-insights component show \
  --app $APP_INSIGHTS_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "connectionString" -o tsv)

# Web AppにConnection Stringを設定
az webapp config appsettings set \
  --name $MY_WEB_NAME \
  --resource-group $RESOURCE_GROUP \
  --settings APPLICATIONINSIGHTS_CONNECTION_STRING="$CONNECTION_STRING"

# Application Insightsを有効化（Web Appと紐付け）
az monitor app-insights component connect-webapp \
  --app $APP_INSIGHTS_NAME \
  --resource-group $RESOURCE_GROUP \
  --web-app $MY_WEB_NAME

# 再起動
az webapp restart \
  --name $MY_WEB_NAME \
  --resource-group $RESOURCE_GROUP
```

**💡 Tip:** 再起動後、数分でテレメトリデータが収集され始めます。

---

## ステップ 3: App Service への環境変数追加

```bash
# 接続文字列を取得
CONNECTION_STRING=$(az monitor app-insights \
  component show \
  --app $APP_INSIGHTS_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "connectionString" -o tsv)

# 環境変数を設定
az webapp config appsettings set \
  --name $MY_WEB_NAME \
  --resource-group $RESOURCE_GROUP \
  --settings \
    NEXT_PUBLIC_APPINSIGHTS_CONNECTION_STRING="$CONNECTION_STRING"
```

**💡 注意:** `NEXT_PUBLIC_` プレフィックスでクライアント側からアクセス可能になります。

---

## ステップ 4: ログとメトリクスの確認

### Azure Portal での確認

1. **Application Insights** を開く
2. **Live Metrics** でリアルタイム監視
3. **Performance** で応答時間を確認
4. **Failures** でエラーを確認
5. **Application Map** で依存関係を可視化

<div class="mt-3">

### CLI でのメトリクス取得

```bash
# 過去1時間のリクエスト数
az monitor app-insights metrics show \
  --app $APP_INSIGHTS_NAME \
  --resource-group $RESOURCE_GROUP \
  --metric requests/count \
  --interval PT1H
```

</div>

---

## ステップ 5: KQL クエリでログ分析

Kusto Query Language (KQL) でログを分析します。

```kusto
// 過去24時間のリクエスト数
requests
| where timestamp > ago(24h)
| summarize count() by bin(timestamp, 1h)
| render timechart

// ボタンクリックイベントを集計
customEvents
| where timestamp > ago(2h)
| where name == "ButtonClicked"
| summarize count()
  by tostring(customDimensions.page)
```

**💡 Tip:** Azure Portal → Application Insights → Logs で実行できます。

---

## ステップ 6: アラートの設定（参考）

異常検知時に通知を受け取る設定です。

<div class="grid grid-cols-2 gap-6">
<div>

### アクショングループ作成

<div class="text-xs">

```bash
# メール通知グループを作成
az monitor action-group create \
  --name email-admins \
  --resource-group $RESOURCE_GROUP \
  --short-name emailadm \
  --email-receiver \
    name=AdminEmail \
    address=admin@example.com
```

</div>

</div>
<div>

### メトリックアラート作成

<div class="text-xs">

```bash
# 応答時間が3秒以上でアラート
az monitor metrics alert create \
  --name high-response-time \
  --resource-group $RESOURCE_GROUP \
  --scopes <INSIGHTS_RESOURCE_ID> \
  --condition "avg requests/duration > 3000" \
  --window-size 5m \
  --evaluation-frequency 1m \
  --action email-admins
```

</div>

**💡 Tip:** `<INSIGHTS_RESOURCE_ID>` は Application Insights のリソース ID です。

</div>
</div>

---

## トラッキングデータの確認方法

送信したイベントは Azure Portal で確認できます。

### Azure Portal での確認

1. **Application Insights** を開く
2. **Logs** → KQL クエリ実行

```kusto
customEvents
| where name == "ButtonClicked"
| project timestamp, name, customDimensions
| order by timestamp desc
| take 50
```

3. **Usage** → **Events**
   - カスタムイベントの一覧・集計

### CLI での確認

```bash
az monitor app-insights query \
  --app $APP_INSIGHTS_NAME \
  --resource-group $RESOURCE_GROUP \
  --analytics-query \
    "customEvents | where name == 'ButtonClicked'"
```

**💡 Tip:** データ反映には 1〜5 分かかることがあります（Live Metrics は即座）。

---

## App Map での可視化

Application Map で、アプリケーションの依存関係を可視化します。

**App Map で確認できる情報:**

- **コンポーネント間の呼び出し関係**
  - Web App → API → Database
- **各コンポーネントの健全性**
  - 成功率、応答時間、失敗数
- **ボトルネックの特定**
  - 遅いクエリや失敗している依存関係

<div class="mt-3">

**確認方法:**

Azure Portal → Application Insights → Application map

**活用シーン:**

- マイクロサービス間の依存関係把握
- パフォーマンスボトルネックの発見
- 障害発生時の影響範囲特定
- システム全体の健全性監視

</div>

---
layout: center
---

# まとめ

Azure App Service 系サービス完全攻略

---

## 本日学んだこと

<div class="grid grid-cols-2 gap-8 pt-6">
<div>

### ✅ ハンズオンで実践したサービス

- **Web Apps:** Next.js アプリのデプロイ
- **API Apps:** Node.js Express API の構築
- **Application Insights:** 監視と KQL クエリ分析

### ✅ 詳細を学んだサービス

- **Mobile Apps:** モバイルバックエンド、認証・同期
- **Web App for Containers:** Docker コンテナホスティング
- **Azure Functions / Function Apps:** サーバーレス、イベント駆動
  - Function App（実行環境）と Azure Functions（個別の関数コード）の関係性

</div>
<div>

### ✅ 共通の概念

- **App Service Plan:** コンピューティングリソースの管理
- **デプロイ方法:** Git, ZIP, Azure CLI
- **環境変数:** 機密情報の管理
- **スケーリング:** 負荷に応じたリソース調整
- **監視:** Application Insights での可視化
- **CORS 設定:** API 向けクロスオリジン制御

</div>
</div>

---

## ベストプラクティス

<div class="grid grid-cols-2 gap-8 pt-6">
<div>

### 🎯 開発フロー

1. **ローカルでビルド・テスト**
2. **ステージング環境にデプロイ**
3. **動作確認とパフォーマンステスト**
4. **本番環境へのリリース**

### 🔒 セキュリティ

- **環境変数で機密情報を管理**
- **HTTPS を強制**
- **Azure AD で認証**
- **マネージド ID の活用**

</div>
<div>

### 💰 コスト最適化

- **適切なプランを選択**
- **自動スケーリングで無駄を削減**
- **不要なリソースを削除**
- **コストアラートの設定**

### 📊 監視・運用

- **Application Insights を統合**
- **ログとメトリクスを定期確認**
- **アラートで異常を早期検知**
- **KQL クエリでログ分析**

</div>
</div>

---

## サービスの使い分け

用途に応じて最適なサービスを選択しましょう。

| ユースケース          | 推奨サービス                    | 理由                                 |
| --------------------- | ------------------------------- | ------------------------------------ |
| **Web サイト・SPA**   | Web Apps                        | 常時稼働、簡単デプロイ               |
| **REST API**          | API Apps                        | CORS 設定、API 管理が容易            |
| **モバイルアプリ BE** | Mobile Apps                     | 認証、プッシュ通知の統合             |
| **定期バッチ処理**    | Azure Functions / Function Apps | サーバーレス、従量課金、イベント駆動 |
| **マイクロサービス**  | Web App for Containers          | コンテナベース、柔軟な構成           |
| **監視・分析**        | Application Insights            | すべてのサービスに適用可能           |

---

## 次のステップ

さらに学習を深めるためのリソースとトピックです。

<div class="grid grid-cols-2 gap-8 pt-6">
<div>

### 🚀 さらに学ぶ

- **Azure API Management**
  - API ゲートウェイの導入
- **Azure Kubernetes Service (AKS)**
  - 本格的なコンテナオーケストレーション
- **Azure Static Web Apps**
  - Jamstack アプリのホスティング
- **Azure Cosmos DB / SQL Database**
  - データベースとの連携
- **Azure Monitor / Log Analytics**
  - 高度な監視とログ分析

</div>
<div>

### 📚 参考リンク

- [Azure App Service ドキュメント](https://learn.microsoft.com/ja-jp/azure/app-service/)
- [Azure Functions ドキュメント](https://learn.microsoft.com/ja-jp/azure/azure-functions/)
- [Application Insights ドキュメント](https://learn.microsoft.com/ja-jp/azure/azure-monitor/app/app-insights-overview)
- [Azure CLI リファレンス](https://learn.microsoft.com/ja-jp/cli/azure/)
- [Azure 料金計算ツール](https://azure.microsoft.com/ja-jp/pricing/calculator/)

</div>
</div>

---
layout: center
---

# ありがとうございました！

## 質疑応答
