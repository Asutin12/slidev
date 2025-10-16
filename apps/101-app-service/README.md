# Azure App Service 系サービスハンズオン

Azure App Service ファミリーの主要サービスを実践的に学ぶハンズオン資料です。

## 対象者

- Azure の基礎知識がある方
- Web アプリケーション開発の経験がある方
- サーバーレスやコンテナ技術に興味がある方
- クラウドネイティブな開発を学びたい方

## 内容

このハンズオンでは、以下の4つのサービスを実践的に学び、2つのサービスの概要を理解します。

### 🎯 実践ハンズオン

#### ① Web Apps

- Next.jsアプリのデプロイ
- App Service Planの理解
- カスタムドメインとHTTPS設定
- ZIPデプロイの実践

#### ② API Apps

- Node.js ExpressでのREST API構築
- CORS設定とAPI保護
- 環境変数の管理
- GET/POSTエンドポイントの実装

#### ③ Function Apps

- Blob Triggerでサムネイル生成
- サーバーレスアーキテクチャの理解
- Storage Account連携
- HTTP Trigger関数（オプション）

#### ④ Application Insights

- アプリケーション監視の統合
- カスタムイベントとメトリクスの送信
- KQLクエリでのログ分析
- アラート設定とApp Map

### 📚 概要説明のみ

#### Mobile Apps

- モバイルアプリ向けバックエンド
- 認証プロバイダー統合
- オフラインデータ同期
- プッシュ通知

#### Web App for Containers

- Dockerコンテナのホスティング
- Azure Container Registry (ACR) 連携
- 継続的デプロイ

## スライドの実行

```bash
# 依存関係のインストール
bun install

# 開発サーバーの起動
bun dev

# ブラウザで http://localhost:3030 にアクセス
```

## エクスポート

```bash
# PDF としてエクスポート
bun export

# SPA としてビルド
bun build
```
