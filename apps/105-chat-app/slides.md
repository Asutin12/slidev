---
theme: "default"
style: "./style.css"
title: "Azure SignalR Service チャットアプリハンズオン"
lang: "ja-JP"
drawings:
  enabled: true
highlighter: shiki
lineNumbers: false
info: |
  ## Azure SignalR Service チャットアプリハンズオン

  Azure SignalR Service、Azure Functions、Static Web Appsを使用して、
  認証機能付きリアルタイムチャットアプリケーションを構築します。
---

## Azure SignalR Service<br>チャットアプリハンズオン

リアルタイム通信とサーバーレスアーキテクチャを学ぶ

<div class="pt-12">
  <span @click="$slidev.nav.next" class="px-2 py-1 rounded cursor-pointer" hover="bg-white bg-opacity-10">
    Press Space for next page <carbon:arrow-right class="inline"/>
  </span>
</div>

---

## 本日のアジェンダ

Azure のサーバーレスサービスを使用して、認証機能付きリアルタイムチャットアプリを構築します。

<div class="grid grid-cols-2 gap-x-6 pt-4 text-sm">
<div>

### 基礎知識

- 💬 **Azure SignalR Service とは**
- 📋 **前提条件**
- 🏗️ **アーキテクチャ概要**

</div>
<div>

### 実践ハンズオン

- ⚡ **① Azure SignalR Service**
  - サービスの作成と設定
- 🔧 **② Azure Functions（Python）**
  - Python でのバックエンド API 開発とデプロイ
- 🌐 **③ Static Web Apps（Next.js）**
  - Next.js + TypeScript でフロントエンド開発
  - Microsoft 認証の有効化
  - プロフィールページの作成
  - Static Web Apps へのデプロイ
- ✅ **④ 動作確認**
  - チャット機能のテスト

### まとめ

- 📚 学んだこと・次のステップ

</div>
</div>

---

## layout: center

# Azure SignalR Service とは？

<br>

**リアルタイム Web 機能を簡単に追加できる<br>フルマネージドサービス**

---

## Azure SignalR Service の魅力

Azure SignalR Service は、アプリケーションにリアルタイム通信機能を追加するためのフルマネージドサービスです。
WebSocket や Server-Sent Events などの複雑な技術を抽象化し、簡単にリアルタイム機能を実装できます。

<div class="grid grid-cols-2 gap-x-8 gap-y-4 pt-6">

<div class="bg-gray-500/10 p-4 rounded">

#### 💬 リアルタイム通信

WebSocket ベースの双方向通信により、チャット、通知、ライブダッシュボードなどを実現できます。

</div>

<div class="bg-gray-500/10 p-4 rounded">

#### 🚀 スケーラブル

自動スケーリングにより、数千〜数百万の同時接続を処理できます。インフラ管理は不要です。

</div>

<div class="bg-gray-500/10 p-4 rounded">

#### 🔌 簡単な統合

Azure Functions、App Service、ASP.NET Core などと簡単に統合できます。

</div>

<div class="bg-gray-500/10 p-4 rounded">

#### 🛡️ セキュア

認証・認可機能を統合し、Azure AD、OAuth プロバイダーとシームレスに連携できます。

</div>

</div>

---

## Azure SignalR Service の主要な機能

<div class="grid grid-cols-3 gap-4 pt-6 text-xs">

<div class="bg-blue-500/10 p-3 rounded">

#### 💬 リアルタイムメッセージング

<div class="mt-2">
<strong>用途：</strong>チャット、通知、協調作業<br>
<strong>特徴：</strong>双方向通信、ブロードキャスト、グループ管理
</div>
</div>

<div class="bg-green-500/10 p-3 rounded">

#### 🔄 自動スケーリング

<div class="mt-2">
<strong>用途：</strong>トラフィック変動に対応<br>
<strong>特徴：</strong>動的スケーリング、高可用性、負荷分散
</div>
</div>

<div class="bg-purple-500/10 p-3 rounded">

#### 🌐 複数プロトコル対応

<div class="mt-2">
<strong>用途：</strong>様々なクライアント対応<br>
<strong>特徴：</strong>WebSocket、SSE、Long Polling
</div>
</div>

<div class="bg-orange-500/10 p-3 rounded">

#### 🔐 認証・認可

<div class="mt-2">
<strong>用途：</strong>セキュアな通信<br>
<strong>特徴：</strong>Azure AD 統合、JWT トークン、ユーザー認証
</div>
  </div>

<div class="bg-cyan-500/10 p-3 rounded">

#### ⚡ サーバーレスモード

<div class="mt-2">
<strong>用途：</strong>Azure Functions との統合<br>
<strong>特徴：</strong>イベント駆動、従量課金、インフラ不要
  </div>
</div>

<div class="bg-pink-500/10 p-3 rounded">

#### 📊 監視・診断

<div class="mt-2">
<strong>用途：</strong>パフォーマンス監視<br>
<strong>特徴：</strong>Azure Monitor 統合、メトリクス、ログ
</div>
</div>

</div>

---

## 今回構築するアーキテクチャ

リアルタイムチャットアプリケーションの全体構成を理解します。

<div class="pt-6">

```mermaid
graph LR
    A[ユーザー<br>ブラウザ] -->|HTTPS| B[Static Web Apps<br>フロントエンド]
    B -->|API呼び出し| C[Azure Functions<br>バックエンド]
    C -->|接続情報取得| D[Azure SignalR<br>Service]
    B -.->|WebSocket接続| D
    C -->|メッセージ送信| D
    D -.->|メッセージ配信| B
    E[Microsoft<br>認証] -->|認証| B

    style A fill:#e1f5ff
    style B fill:#ffe1e1
    style C fill:#e1ffe1
    style D fill:#fff4e1
    style E fill:#f0e1ff
```

</div>

<div class="mt-4 text-sm">

**フロー:**

1. ユーザーが Static Web Apps でホストされたフロントエンドにアクセス
2. Microsoft 認証でサインイン
3. Azure Functions から SignalR の接続情報を取得
4. ブラウザと SignalR Service が WebSocket で接続
5. メッセージは Functions 経由で SignalR に送信され、全クライアントに配信

</div>

---

## 前提条件

このハンズオンを進めるために必要な環境とツールを確認します。

<div class="grid grid-cols-2 gap-6 pt-4">

<div>

### Azure アカウント

- ✅ **Azure サブスクリプション**
- ✅ **リソースグループ作成権限**

### 必要なツール

- ✅ **Azure Portal アクセス**
  - [https://portal.azure.com](https://portal.azure.com)
- ✅ **Azure CLI（推奨）**
  - バージョン 2.40 以降
- ✅ **Python**
  - バージョン 3.11
- ✅ **Node.js**
  - バージョン 20.x（Next.js 用）
- ✅ **Azure Functions Core Tools**
  - バージョン 4

</div>

<div>

### 開発環境

- ✅ **テキストエディタ**
  - VS Code 推奨
  - Azure Functions 拡張機能
  - Python 拡張機能
- ✅ **Git（任意）**
  - バージョン管理用

### 知識要件

- ✅ **Azure の基礎**
  - リソースグループの概念
  - 基本的なポータル操作

</div>

</div>

---

## 料金について

このハンズオンで発生する料金の概算です。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">

<div class="bg-blue-500/10 p-4 rounded">

### 💰 推定料金

**ハンズオン全体：約 ¥100〜300 / 月**

- Azure SignalR Service（Free tier）：無料（20 同時接続まで）
- Azure Functions（従量課金プラン）：約 ¥50/月
  - Python Functions でも同じ料金体系
- Static Web Apps（Free tier）：無料（100GB 帯域まで）
- Storage Account：約 ¥50/月

<div class="mt-4 text-xs opacity-75">
※ 料金は 2025 年 10 月時点の東日本リージョン価格
</div>

  </div>

<div class="bg-yellow-500/10 p-4 rounded">

### 💡 コスト削減のヒント

1. **Free tier を活用**
   - SignalR Service の Free tier で開始
   - Static Web Apps の Free プランで十分
2. **ハンズオン終了後は削除**
   - リソースグループごと削除が簡単
3. **従量課金を理解**
   - Functions は実行時のみ課金
4. **モニタリング**
   - コストアラートを設定

<div class="mt-4 text-xs opacity-75">
※ Free tier の制限を超えると課金が発生します
</div>
</div>
</div>

---
src: ./pages/01-intro.md
---
---
src: ./pages/02-signalr-service.md
---
---
src: ./pages/03-function-app.md
---
---
src: ./pages/04-static-web-app.md
---
---
src: ./pages/06-test.md
---
---
src: ./pages/99-summary.md
---
