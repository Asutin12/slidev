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

  Web Apps、API Apps、Function Apps、Application Insightsを実践的に学び、
  Mobile Apps、Web App for Containersの概要を理解するハンズオン資料です。
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

### 実践ハンズオン（4 つ）

- 🚀 **① Web Apps**
  - Next.js アプリをデプロイ
- 🔌 **② API Apps**
  - REST API の構築とデプロイ
- ⚡ **③ Function Apps**
  - サーバーレスで画像処理
- 📊 **④ Application Insights**
  - アプリケーション監視

</div>
<div>

### 詳細説明（2 つ）

- 📲 **Mobile Apps** - モバイルバックエンド、認証・同期
- 🐳 **Web App for Containers** - Docker コンテナホスティング

</div>
</div>

---

## layout: center

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

<div class="bg-yellow-500/10 p-3 rounded">

#### ⚡ Function Apps（ハンズオン）

<div class="mt-2">
<strong>用途：</strong>イベント駆動・サーバーレス処理<br>
<strong>特徴：</strong>従量課金、トリガー豊富、スケールアウト自動
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

</div>

---

## 各サービスの詳細説明（1/5）

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

## 各サービスの詳細説明（2/5）

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

## 各サービスの詳細説明（3/5）

<div class="grid grid-cols-2 gap-8">
<div>

### ⚡ Function Apps

**どういうサービス？**

- サーバーレスコンピューティングプラットフォーム
- イベント駆動で関数を実行

**主な特徴：**

- 従量課金（実行回数・時間のみ課金）
- 豊富なトリガー（HTTP、Timer、Blob、Queue 等）
- 自動スケーリング

**何のため？**

- 定期バッチ処理、画像変換、データ処理
- Webhook 受信、非同期タスク実行

**比較：**

- **vs Web Apps**: 常時稼働不要、コスト効率的
- **vs AWS Lambda**: 同等のサーバーレス、Azure 統合が強み

</div>
<div>

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

</div>
</div>

---

## 各サービスの詳細説明（4/5）

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

## 各サービスの詳細説明（5/5）

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

## layout: center

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

<div class="flex items-center gap-x-4">

## リソースグループの作成

<div class="text-sm bg-blue-500/20 px-2 py-1 rounded mb-3">👥 共有可能</div>
</div>

**リソースグループ**は、関連する Azure リソースをまとめて管理するための論理的なコンテナ（フォルダのようなもの）です。

このハンズオンで使用するリソースグループを作成します。

```bash
# このハンズオン用のリソースグループを作成
az group create \
  --name appservice-hands-on-rg \
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

## layout: center

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
  --resource-group appservice-hands-on-rg \
  --location japaneast \
  --sku B1 \
  --is-linux

# 作成されたプランを確認
az appservice plan list --output table
```

<br>

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
  --name my-webapp-20251007 \
  --resource-group appservice-hands-on-rg \
  --plan webapp-plan \
  --runtime "NODE:22-lts"

# 作成された Web App を確認
az webapp list --output table

# ブラウザで開く
az webapp browse \
  --name my-webapp-20251007 \
  --resource-group appservice-hands-on-rg
```

**💡 Tip:** `--name` はグローバルで一意な名前が必要です（例: `my-webapp-20251007`）。

---

## ステップ 3-1: Next.js プロジェクト作成

Next.js プロジェクトを作成します。

```bash
# Next.jsプロジェクト作成（対話形式）
npx create-next-app@latest my-nextjs-app
```

**質問が出たら以下のように回答:**

- ✔ TypeScript? → **Yes**
- ✔ ESLint? → **Yes**
- ✔ Tailwind CSS? → **No**（任意）
- ✔ App Router? → **Yes**
- ✔ Turbopack? → **No**
- ✔ Import alias? → **@/\***

```bash
cd my-nextjs-app
```

---

## ステップ 3-2: Standalone 出力の設定

`next.config.js`（または`next.config.mjs`）を以下のように設定:

```javascript
/** @type {import('next').NextConfig} */
const nextConfig = {
  output: "standalone",
};

module.exports = nextConfig;
```

次に、`package.json`の`scripts`セクションの**build スクリプト**を修正:

```json
"scripts": {
  "dev": "next dev",
  "build": "next build && mkdir -p .next/standalone/Desktop/my-nextjs-app/application/.next && cp -r .next/static .next/standalone/Desktop/my-nextjs-app/application/.next/ && cp -r public .next/standalone/Desktop/my-nextjs-app/application/",
  "start": "next start",
  "lint": "next lint"
}
```

**💡 重要:** 静的ファイル（`.next/static`と`public`）を standalone フォルダにコピーしないと、**CSS や Tailwind のスタイルが適用されません**。

---

## ステップ 3-3: ページの編集

`app/page.tsx`を編集してテストページを作成します。

```typescript
// app/page.tsx
export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-24">
      <h1 className="text-4xl font-bold">Hello, Azure App Service!</h1>
      <p className="mt-4 text-xl">
        このサイトはApp Serviceでホストされています。
      </p>
    </main>
  );
}
```

---

## ステップ 4-1: ビルドとパス確認

本番用ビルドを実行し、server.js のパスを確認します。

```bash
# 本番用ビルド
bun run build

# standaloneフォルダの確認（server.jsのパスを確認）
ls .next/standalone
# 出力例: Desktop/  node_modules/  package.json
# ※プロジェクトのフルパスが含まれることがあります
```

**💡 重要:** `ls`コマンドの出力結果を確認してください。次のステップでこのパスを使用します。

<br />

`package.json`の`scripts`セクションを修正:

```json
"scripts": {
  "dev": "next dev",
  "build": "next build",
  "start": "node .next/standalone/Desktop/my-nextjs-app/server.js"
}
```

**💡 重要:** `ls .next/standalone`で確認したパスに合わせて、`server.js`のパスを修正してください。

---

## ステップ 4-2: ZIP デプロイ

ZIP ファイルを作成して App Service にデプロイします。

```bash
# デプロイ用のZIPファイル作成
zip -r ./my-nextjs-app.zip .next public package.json node_modules

# ZIPデプロイ
az webapp deploy \
  --name my-webapp-20251007 \
  --resource-group appservice-hands-on-rg \
  --src-path ./my-nextjs-app.zip \
  --type zip

# デプロイ完了後、ブラウザで開く
az webapp browse \
  --name my-webapp-20251007 \
  --resource-group appservice-hands-on-rg
```

**💡 ポイント:**

- ZIP には`.next`、`public`、`package.json`、`node_modules`を含めます
- App Service は`package.json`の`start`スクリプトを自動的に実行します

---

## ステップ 5: カスタムドメインと HTTPS（参考知識）

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
  --webapp-name my-webapp-20251007 \
  --resource-group appservice-hands-on-rg \
  --hostname www.example.com
```

</div>
<div>

### HTTPS 有効化

```bash
# マネージド証明書を作成
az webapp config ssl create \
  --name my-webapp-20251007 \
  --resource-group appservice-hands-on-rg \
  --hostname www.example.com

# HTTPS リダイレクトを有効化
az webapp update \
  --name my-webapp-20251007 \
  --resource-group appservice-hands-on-rg \
  --https-only true
```

</div>
</div>

---

## layout: center

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

## ステップ 1: Node.js Express API の作成

シンプルな REST API を作成します。

```javascript
// server.js
const express = require("express");
const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

// GET エンドポイント
app.get("/api/hello", (req, res) => {
  res.json({ message: "Hello from API Apps!" });
});

// POST エンドポイント
app.post("/api/data", (req, res) => {
  const { name } = req.body;
  res.json({ message: `Received: ${name}`, timestamp: new Date() });
});

app.listen(port, () => {
  console.log(`API server running on port ${port}`);
});
```

---

## ステップ 2: API Apps の作成とデプロイ

<div class="bg-orange-500/10 p-3 rounded mb-4 text-sm">
<strong>👤 複数人での実施:</strong> API Appも一意な名前が必要です（例: <code>my-api-app-tanaka-20251007</code>）
</div>

```bash
# API App作成
az webapp create \
  --name my-api-app-20251007 \
  --resource-group appservice-hands-on-rg \
  --plan webapp-plan \
  --runtime "NODE:22-lts"

# package.jsonの準備
npm init -y
npm install express

# デプロイ用のZIPファイル作成
zip -r api-app.zip server.js package.json node_modules/

# ZIPデプロイ（新しいコマンド）
az webapp deploy \
  --name my-api-app-20251007 \
  --resource-group appservice-hands-on-rg \
  --src-path api-app.zip \
  --type zip

# デプロイ完了後、動作確認
curl https://my-api-app-20251007.azurewebsites.net/api/hello
```

---

## ステップ 3: CORS 設定（参考知識）

<div class="bg-blue-500/10 p-3 rounded mb-4 text-sm">
<strong>💡 参考情報:</strong> このステップはハンズオンでは実施しません。フロントエンドアプリケーション（別のドメイン）からこのAPIを呼び出す場合に必要な設定です。
</div>

**CORS とは？**  
異なるオリジン（ドメイン）の Web アプリから JavaScript で API を呼び出す際に必要な設定です。

**CORS 設定例:**

```bash
# CORS設定（すべてのオリジンを許可）
az webapp cors add \
  --name my-api-app-20251007 \
  --resource-group appservice-hands-on-rg \
  --allowed-origins '*'

# 特定のドメインのみ許可する場合（本番環境推奨）
az webapp cors add \
  --name my-api-app-20251007 \
  --resource-group appservice-hands-on-rg \
  --allowed-origins 'https://example.com'
```

**💡 Tip:** curl/Postman からのリクエストや、ブラウザのアドレスバーに直接 URL を入力する場合は CORS 設定は不要です。

---

## ステップ 4: 環境変数の設定（参考知識）

<div class="bg-blue-500/10 p-3 rounded mb-4 text-sm">
<strong>💡 参考情報:</strong> このステップはハンズオンでは実施しません。APIキーやデータベース接続文字列などの機密情報を扱う場合の参考知識として確認してください。
</div>

API キーなどの機密情報を環境変数で管理する方法です。

```bash
# 環境変数の設定
az webapp config appsettings set \
  --name my-api-app-20251007 \
  --resource-group appservice-hands-on-rg \
  --settings API_KEY="your-secret-key" \
              DATABASE_URL="your-db-connection-string"

# 環境変数の確認
az webapp config appsettings list \
  --name my-api-app-20251007 \
  --resource-group appservice-hands-on-rg
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
curl https://my-api-app-20251007.azurewebsites.net/api/hello

# POST リクエスト
curl -X POST https://my-api-app-20251007.azurewebsites.net/api/data \
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

## layout: center

# ハンズオン ③ Function Apps

画像を Blob にアップしたら自動でサムネイル生成

---

## Function Apps ハンズオン概要

**目的:** サーバーレス関数を作成し、イベント駆動処理を実装する

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

1. **Function App の作成**
   - Python 3.12 のサーバーレス環境構築
2. **Blob Trigger 関数の実装**
   - 画像アップロード時の自動処理
3. **サムネイル生成ロジック**
   - Pillow ライブラリを使った画像変換
4. **HTTP Trigger 関数**（オプション）
   - API 形式での関数実行

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
  --name mystorageacct20251007 \
  --resource-group appservice-hands-on-rg \
  --location japaneast \
  --sku Standard_LRS

# コンテナ作成（元画像用）
az storage container create \
  --name images \
  --account-name mystorageacct20251007

# コンテナ作成（サムネイル用）
az storage container create \
  --name thumbnails \
  --account-name mystorageacct20251007

# 接続文字列取得（後で使用するのでメモしておく）
az storage account show-connection-string \
  --name mystorageacct20251007 \
  --resource-group appservice-hands-on-rg \
  --query "connectionString" -o tsv
```

**💡 Tip:** 取得した接続文字列は後のステップで使用します。安全な場所に保存してください。

---

## ステップ 2: Function App の作成

Function App リソースを作成します。

<div class="bg-orange-500/10 p-3 rounded mb-4 text-sm">
<strong>👤 複数人での実施:</strong> Function Appも一意な名前が必要です（例: <code>my-function-app-tanaka-20251007</code>）
</div>

```bash
# Function App作成（Python 3.12）
az functionapp create \
  --name my-function-app-20251007 \
  --resource-group appservice-hands-on-rg \
  --consumption-plan-location japaneast \
  --runtime python \
  --runtime-version 3.12 \
  --functions-version 4 \
  --storage-account mystorageacct20251007 \
  --os-type Linux

# 作成確認
az functionapp list --output table
```

**💡 Tip:** Consumption Plan は従量課金で、使った分だけ支払います。Python 3.12 は Linux OS でのみ動作します。

---

## ステップ 3: Blob Trigger 関数の作成

ローカルで Function App プロジェクトを作成します。

```bash
# Azure Functions Core Toolsのインストール
npm install -g azure-functions-core-tools@4

# Python仮想環境の作成と有効化
python3 -m venv .venv
source .venv/bin/activate  # macOS/Linux
# .venv\Scripts\activate  # Windows

# Pythonプロジェクト作成（v2プログラミングモデル）
func init MyFunctionApp --python --model V2
cd MyFunctionApp

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
  --name mystorageacct20251007 \
  --resource-group appservice-hands-on-rg \
  --query "connectionString" -o tsv
```

**⚠️ 重要:**

- `local.settings.json` はローカル開発専用で、Azure にはデプロイされません
- `.gitignore` に含まれているため、Git にコミットされません（セキュリティのため）
- 本番環境では、Function App の環境変数として自動設定されます

---

## ステップ 4-1: サムネイル生成ロジックの実装

まず、Pillow ライブラリを`requirements.txt`に追加します。

```txt
# requirements.txt
azure-functions
Pillow
```

```bash
# 依存関係をインストール
pip install -r requirements.txt
```

---

## ステップ 4-2: サムネイル生成ロジックの実装

次に、関数のコードを実装します（Python v2 プログラミングモデル）。

```python
# function_app.py
import azure.functions as func
import logging
from PIL import Image
from io import BytesIO

app = func.FunctionApp()

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

## ステップ 5: デプロイとテスト

Function App にデプロイして動作確認します。

```bash
# デプロイ（仮想環境が有効な状態で実行）
func azure functionapp publish my-function-app-20251007

# 画像をアップロードしてテスト
az storage blob upload \
  --account-name mystorageacct20251007 \
  --container-name images \
  --name test.jpg \
  --file ./test.jpg

# 数秒待ってからサムネイルを確認
az storage blob list \
  --account-name mystorageacct20251007 \
  --container-name thumbnails \
  --output table
```

---

## HTTP Trigger 関数の追加（オプション）

API として呼び出せる関数を追加します。

```bash
# HTTP Trigger関数を追加（対話形式）
func new --name HelloAPI --template "HTTP trigger"
# デプロイ後にテスト
curl "https://my-function-app-20251007.azurewebsites.net/api/HelloAPI?name=Azure"
```

---

## layout: center

# ハンズオン ④ Application Insights

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

<div class="flex items-center gap-x-4">

## ステップ 1: Application Insights の作成

<div class="text-sm bg-blue-500/20 px-2 py-1 rounded mb-3">👥 共有可能</div>
</div>

監視リソースを作成します。

```bash
# Application Insights作成
az monitor app-insights component create \
  --app appservice-insights \
  --location japaneast \
  --resource-group appservice-hands-on-rg \
  --application-type web

# Instrumentation Key取得
az monitor app-insights component show \
  --app appservice-insights \
  --resource-group appservice-hands-on-rg \
  --query "instrumentationKey" -o tsv

# Connection String取得
az monitor app-insights component show \
  --app appservice-insights \
  --resource-group appservice-hands-on-rg \
  --query "connectionString" -o tsv
```

---

## ステップ 2: App Service への統合

既存の Web App に Application Insights を連携します。

```bash
# 接続文字列を取得（先ほど取得した値を使用）
CONNECTION_STRING=$(az monitor app-insights component show \
  --app appservice-insights \
  --resource-group appservice-hands-on-rg \
  --query "connectionString" -o tsv)

# Web AppにConnection Stringを設定
az webapp config appsettings set \
  --name my-webapp-20251007 \
  --resource-group appservice-hands-on-rg \
  --settings APPLICATIONINSIGHTS_CONNECTION_STRING="$CONNECTION_STRING"

# Application Insightsを有効化（Web Appと紐付け）
az monitor app-insights component connect-webapp \
  --app appservice-insights \
  --resource-group appservice-hands-on-rg \
  --web-app my-webapp-20251007

# 再起動
az webapp restart \
  --name my-webapp-20251007 \
  --resource-group appservice-hands-on-rg
```

**💡 Tip:** 再起動後、数分でテレメトリデータが収集され始めます。

---

## ステップ 3-1: パッケージのインストール

Next.js アプリケーションからログを送信する準備をします。

```bash
cd my-nextjs-app
npm install @microsoft/applicationinsights-web
```

次に、Application Insights を統合するために**3 つのファイル**を編集していきます。

<div class="grid grid-cols-3 gap-4 mt-4">
<div class="bg-blue-500/10 p-3 rounded">
<h5 class="font-bold mb-2">📁 lib/appInsights.ts</h5>
<p class="text-sm">Application Insightsの初期化と設定を管理するユーティリティファイル</p>
</div>

<div class="bg-green-500/10 p-3 rounded">
<h5 class="font-bold mb-2">🎨 app/layout.tsx</h5>
<p class="text-sm">アプリ起動時にApplication Insightsを自動初期化するレイアウトファイル</p>
</div>

<div class="bg-yellow-500/10 p-3 rounded">
<h5 class="font-bold mb-2">📄 app/page.tsx</h5>
<p class="text-sm">実際にカスタムイベントを送信するメインページコンポーネント</p>
</div>
</div>

---

## ステップ 3-2: クライアント側の設定ファイル作成

`lib/appInsights.ts` を作成:

<div class="text-xs">

```typescript
// lib/appInsights.ts
import { ApplicationInsights } from "@microsoft/applicationinsights-web";

let appInsights: ApplicationInsights | null = null;

export function getAppInsights() {
  if (typeof window !== "undefined" && !appInsights) {
    const connectionString =
      process.env.NEXT_PUBLIC_APPINSIGHTS_CONNECTION_STRING;

    if (!connectionString) {
      console.error("❌ Connection Stringが設定されていません");
      return null;
    }

    try {
      appInsights = new ApplicationInsights({
        config: { connectionString, enableAutoRouteTracking: true },
      });
      appInsights.loadAppInsights();
      appInsights.trackPageView();
      console.log("✅ Application Insights初期化成功");
    } catch (error) {
      console.error("❌ 初期化エラー:", error);
      appInsights = null;
    }
  }
  return appInsights;
}
```

</div>

---

## ステップ 3-3: Layout での初期化

`app/layout.tsx` で Application Insights を初期化:

<div class="text-xs">

```typescript
// app/layout.tsx
"use client";
import { useEffect } from "react";
import { getAppInsights } from "@/lib/appInsights";

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  useEffect(() => {
    getAppInsights(); // 初期化
  }, []);

  return (
    <html lang="ja">
      <body>{children}</body>
    </html>
  );
}
```

</div>

---

## ステップ 3-4: カスタムイベントの送信

`app/page.tsx` でボタンクリックをトラッキング:

<div class="text-xs">

```typescript
// app/page.tsx
"use client";
import { getAppInsights } from "@/lib/appInsights";

export default function Home() {
  const handleClick = () => {
    const appInsights = getAppInsights();
    if (!appInsights) {
      console.error("❌ Application Insightsが初期化されていません");
      return;
    }

    appInsights.trackEvent({
      name: "ButtonClicked",
      properties: { page: "home" },
    });
    console.log("✅ イベント送信成功");
  };

  return (
    <main style={{ padding: "2rem" }}>
      <h1>Hello, Azure App Service!</h1>
      <button onClick={handleClick}>Click me (tracked)</button>
    </main>
  );
}
```

</div>

---

## ステップ 3-5: 環境変数の設定

#### ローカル開発用

`.env.local` に接続文字列を追加:

```bash
NEXT_PUBLIC_APPINSIGHTS_CONNECTION_STRING="<接続文字列>"
```

#### Azure App Service 用

```bash
# 接続文字列を取得
CONNECTION_STRING=$(az monitor app-insights \
  component show \
  --app appservice-insights \
  --resource-group appservice-hands-on-rg \
  --query "connectionString" -o tsv)

# 環境変数を設定
az webapp config appsettings set \
  --name my-webapp-20251007 \
  --resource-group appservice-hands-on-rg \
  --settings \
    NEXT_PUBLIC_APPINSIGHTS_CONNECTION_STRING="$CONNECTION_STRING"
```

**💡 注意:** `NEXT_PUBLIC_` プレフィックスでクライアント側からアクセス可能になります。

---

## サーバーサイドのログ送信（オプション）

API Route やサーバーコンポーネントからログを送信する場合の実装例です。

#### パッケージインストール

```bash
npm install applicationinsights
```

#### API Route 例

<div class="text-xs">

```typescript
// app/api/hello/route.ts
import { NextResponse } from "next/server";
const appInsights = require("applicationinsights");

if (!appInsights.defaultClient) {
  appInsights.setup(process.env.APPLICATIONINSIGHTS_CONNECTION_STRING).start();
}

export async function GET() {
  appInsights.defaultClient.trackEvent({
    name: "APICallReceived",
  });
  return NextResponse.json({
    message: "Hello!",
  });
}
```

</div>

---

## ステップ 4: ログとメトリクスの確認

Azure Portal でログとメトリクスを確認します。

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
  --app appservice-insights \
  --resource-group appservice-hands-on-rg \
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
  --resource-group appservice-hands-on-rg \
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
  --resource-group appservice-hands-on-rg \
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
  --app appservice-insights \
  --resource-group appservice-hands-on-rg \
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

## layout: center

# まとめ

Azure App Service 系サービス完全攻略

---

## 本日学んだこと

<div class="grid grid-cols-2 gap-8 pt-6">
<div>

### ✅ ハンズオンで実践したサービス

- **Web Apps:** Next.js アプリのデプロイ
- **API Apps:** Node.js Express API の構築
- **Function Apps:** Blob Trigger でサムネイル生成
- **Application Insights:** 監視と KQL クエリ分析

### ✅ 詳細を学んだサービス

- **Mobile Apps:** モバイルバックエンド、認証・同期
- **Web App for Containers:** Docker コンテナホスティング

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

| ユースケース          | 推奨サービス           | 理由                       |
| --------------------- | ---------------------- | -------------------------- |
| **Web サイト・SPA**   | Web Apps               | 常時稼働、簡単デプロイ     |
| **REST API**          | API Apps               | CORS 設定、API 管理が容易  |
| **モバイルアプリ BE** | Mobile Apps            | 認証、プッシュ通知の統合   |
| **定期バッチ処理**    | Function Apps          | サーバーレス、従量課金     |
| **マイクロサービス**  | Web App for Containers | コンテナベース、柔軟な構成 |
| **監視・分析**        | Application Insights   | すべてのサービスに適用可能 |

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

## layout: center

# ありがとうございました！

## 質疑応答
