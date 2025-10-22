# Azure App Service for Containers ハンズオン

Azure App Service for Containers を使用して、Docker コンテナを PaaS 環境で運用する実践的なハンズオン資料です。

## 📋 内容

このハンズオンでは、以下のトピックをカバーします：

1. **App Service for Containers の概要** - PaaS でのコンテナ運用の基礎
2. **環境準備** - ACR、サンプルアプリのビルド・プッシュ
3. **App Service デプロイ** - コンテナのデプロイと初期設定
4. **コンテナ詳細設定** - 環境変数、ポート、スタートアップコマンド
5. **スケーリング設定** - スケールアップ/アウト、Always On
6. **セキュリティ構成** - HTTPS、Managed Identity、VNet 統合
7. **運用・監視** - ログストリーム、Application Insights
8. **CI/CD 自動化** - GitHub Actions による自動デプロイ
9. **実務シナリオ** - よくある構成パターン
10. **まとめ** - 学んだことと次のステップ

## 🎯 学習目標

- Docker コンテナを App Service にデプロイする方法
- App Service Plan のスケーリングと構成最適化
- セキュリティ・運用のベストプラクティス
- CI/CD パイプラインの構築方法

## 📦 必要な環境

- Azure アカウント（無料試用版可）
- Azure CLI（v2.40 以降）
- Docker Desktop
- テキストエディタ（VS Code 推奨）
- 基本的な Docker の知識

## 🚀 スライドの起動方法

```bash
# 依存関係のインストール（プロジェクトルートで実行）
pnpm install

# このハンズオンディレクトリに移動
cd apps/107-app-service-for-container

# 開発サーバーの起動
pnpm dev

# ブラウザで http://localhost:3030 にアクセス
```

## 📚 構成

```
107-app-service-for-container/
├── slides.md                     # メインスライド
├── style.css                     # カスタムスタイル
├── pages/
│   ├── 01-overview.md            # 概要とアーキテクチャ
│   ├── 02-preparation.md         # 環境準備
│   ├── 03-deployment.md          # デプロイ手順
│   ├── 04-container-config.md    # コンテナ詳細設定
│   ├── 05-scaling.md             # スケーリング
│   ├── 06-security.md            # セキュリティ
│   ├── 07-monitoring.md          # 運用・監視
│   ├── 08-cicd.md                # CI/CD
│   ├── 09-scenarios.md           # 実務シナリオ
│   └── 99-summary.md             # まとめ
└── components/
    └── Counter.vue               # Vueコンポーネント例
```

## 🏗️ アーキテクチャ

このハンズオンで構築するシステムは、以下のコンポーネントで構成されます：

- **Azure Container Registry (ACR)**: Docker イメージの保管
- **App Service Plan**: コンピューティングリソース
- **App Service for Containers**: コンテナの実行環境
- **Managed Identity**: セキュアな認証
- **Application Insights**: 監視・診断
- **GitHub Actions**: CI/CD パイプライン

## ⏱️ 所要時間

約 3〜4 時間

- 環境準備・ACR 設定：40 分
- App Service デプロイ：30 分
- コンテナ詳細設定：30 分
- スケーリング・セキュリティ：40 分
- 運用・監視設定：30 分
- CI/CD 構築：40 分
- 実務シナリオ・まとめ：30 分

## 💰 料金について

このハンズオンで使用するサービスの料金目安：

- Azure Container Registry（Basic）: 約 ¥500/月
- App Service Plan（B1）: 約 ¥1,400/月
- Application Insights: 約 ¥100/月

**合計**: 約 ¥2,000 / 月

> 💡 ハンズオン終了後は、リソースグループごと削除すれば課金が停止します。

## ⚠️ 注意事項

### グローバルに一意な名前が必要なリソース

以下のリソースは、Azure 全体で一意の名前である必要があります：

- **App Service**: `https://<app-name>.azurewebsites.net`
- **Container Registry**: `<registry-name>.azurecr.io`

既に使用されている名前は使えないため、日付や数字を組み合わせてユニークな名前にしてください（例: `app-container-handson-20251022`）。

## 🔗 参考リンク

### 公式ドキュメント

- [App Service ドキュメント](https://learn.microsoft.com/ja-jp/azure/app-service/)
- [App Service でのカスタムコンテナの実行](https://learn.microsoft.com/ja-jp/azure/app-service/quickstart-custom-container)
- [Azure Container Registry](https://learn.microsoft.com/ja-jp/azure/container-registry/)

### チュートリアル

- [カスタム Linux コンテナを Azure App Service にデプロイする](https://learn.microsoft.com/ja-jp/azure/app-service/tutorial-custom-container)
- [App Service での CI/CD](https://learn.microsoft.com/ja-jp/azure/app-service/deploy-ci-cd-custom-container)

### ツール

- [Slidev](https://sli.dev/) - このスライドで使用しているプレゼンテーションフレームワーク
- [Docker](https://www.docker.com/) - コンテナ化プラットフォーム

## 📝 ライセンス

このハンズオン資料は学習目的で作成されています。

## 🤝 貢献

改善の提案やバグ報告は歓迎します。

---

Made with ❤️ for Azure learners
