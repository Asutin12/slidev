# Azure サーバーレス & イベント駆動ハンズオン

Azure のサーバーレスサービス（Functions、Event Grid、Logic Apps）を実践的に学ぶハンズオン資料です。

## 対象者

- Azure の基礎知識がある方
- サーバーレスアーキテクチャに興味がある方
- イベント駆動設計を学びたい方
- ワークフロー自動化を実装したい方

## 内容

このハンズオンでは、以下の3つのサービスを実践的に学びます。

### 🎯 実践ハンズオン

#### ① Azure Functions

- HTTP Trigger で REST API 構築
- Timer Trigger で定期実行
- Blob/Queue Trigger でイベント処理
- Application Insights でのモニタリング

#### ② Event Grid

- カスタムトピックの作成
- イベントサブスクリプション
- イベントフィルタリング
- システムトピックの活用
- デッドレター処理

#### ③ Logic Apps

- HTTP トリガーでのワークフロー起動
- Event Grid トリガーでの自動実行
- 条件分岐と並列処理
- 外部サービス連携（メール送信など）
- エラーハンドリング

### 🌐 エンドツーエンドシナリオ

- 注文処理システムの構築
- 複数サービスの連携
- イベント駆動アーキテクチャの実装

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

## 前提条件

- Azure アカウント
- Azure CLI
- Azure Functions Core Tools
- Python 3.9 以上（3.11 推奨）
- pip（Python パッケージマネージャー）
