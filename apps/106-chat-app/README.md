# Azure SignalR Service チャットアプリハンズオン

Azure SignalR Service、Azure Functions、Static Web Apps を使用した、認証機能付きリアルタイムチャットアプリケーションを構築するハンズオン資料です。

## 📋 内容

このハンズオンでは、以下のトピックをカバーします：

1. **Azure SignalR Service の作成** - サーバーレスモードでの設定
2. **Azure Functions の開発** - negotiate / messages 関数の実装
3. **Static Web Apps の構築** - フロントエンドアプリの開発とデプロイ
4. **Microsoft 認証の統合** - 認証機能の有効化
5. **動作確認とテスト** - エンドツーエンドのテスト

## 🎯 学習目標

- Azure のサーバーレスサービスを組み合わせたアプリケーション開発
- リアルタイム通信の実装方法
- 認証・認可の実装
- Portal と CLI の両方での操作方法

## 📦 必要な環境

- Azure アカウント（無料試用版可）
- Node.js 20.x
- Azure Functions Core Tools v4
- Azure CLI（推奨）
- テキストエディタ（VS Code 推奨）

## 🚀 スライドの起動方法

```bash
# 依存関係のインストール
pnpm install

# 開発サーバーの起動
pnpm dev

# ブラウザで http://localhost:3030 にアクセス
```

## 📚 構成

```
105-chat-app/
├── slides.md                  # メインスライド
├── style.css                  # カスタムスタイル
├── pages/
│   ├── 01-intro.md           # 導入
│   ├── 02-signalr-service.md # SignalR Service作成
│   ├── 03-function-app.md    # Functions開発
│   ├── 04-static-web-app.md  # Static Web Apps
│   ├── 05-authentication.md  # 認証設定
│   ├── 06-test.md            # 動作確認
│   └── 99-summary.md         # まとめ
└── components/
    └── Counter.vue           # Vueコンポーネント例
```

## 🏗️ アーキテクチャ

このハンズオンで構築するシステムは、以下のコンポーネントで構成されます：

- **Static Web Apps**: フロントエンドのホスティングと認証
- **Azure Functions**: バックエンド API（negotiate / messages）
- **Azure SignalR Service**: リアルタイム通信の管理
- **Microsoft 認証**: ユーザー認証と ID 管理

## ⏱️ 所要時間

約 2〜3 時間

- Azure リソース作成：30 分
- Functions 開発：40 分
- Static Web Apps 開発：40 分
- 認証設定・テスト：30 分

## 💰 料金について

このハンズオンで使用するサービスは、Free tier を活用することで、ほぼ無料で実施できます：

- Azure SignalR Service（Free tier）: 無料（20 同時接続まで）
- Azure Functions（従量課金）: 約 ¥50/月
- Static Web Apps（Free tier）: 無料（100GB 帯域まで）
- Storage Account: 約 ¥50/月

**合計**: 約 ¥100〜300 / 月

## 🔗 参考リンク

### 公式ドキュメント

- [Azure SignalR Service ドキュメント](https://learn.microsoft.com/ja-jp/azure/azure-signalr/)
- [Azure Functions ドキュメント](https://learn.microsoft.com/ja-jp/azure/azure-functions/)
- [Static Web Apps ドキュメント](https://learn.microsoft.com/ja-jp/azure/static-web-apps/)

### チュートリアル

- [Azure SignalR Service と Azure Functions を使用した認証付きチャット](https://learn.microsoft.com/ja-jp/azure/azure-signalr/signalr-tutorial-authenticate-azure-functions)

### ツール

- [Slidev](https://sli.dev/) - このスライドで使用しているプレゼンテーションフレームワーク

## 📝 ライセンス

このハンズオン資料は学習目的で作成されています。

## 🤝 貢献

改善の提案やバグ報告は歓迎します。

---

Made with ❤️ for Azure learners
