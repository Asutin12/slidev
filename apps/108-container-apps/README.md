# Azure Container Apps ハンズオン

Azure Container Apps を使ったマイクロサービスアプリケーションの構築を学ぶハンズオン資料です。

## 📚 内容

このハンズオンでは、以下を学びます：

- **Container Apps の基本概念** - Environment、Revision、Dapr の理解
- **デプロイと運用** - コンテナのデプロイ、環境変数、シークレット管理
- **スケーリング** - HTTP/Queue/CPU ベースの自動スケール、KEDA
- **サービス連携** - 内部通信、Dapr Pub/Sub、マイクロサービス構成
- **セキュリティ** - VNet 統合、Private Endpoint、Managed Identity
- **監視とログ** - Log Analytics、Application Insights
- **実践演習** - 本番環境に近いマイクロサービスシステムの構築

## 🎯 対象者

- Docker とコンテナの基本知識がある方
- Azure の基礎知識がある方
- マイクロサービスアーキテクチャに興味がある方

## 🚀 スライドの表示

プレゼンテーションを開始するには：

```bash
# 依存関係のインストール
pnpm install

# 開発サーバーの起動
pnpm dev

# ブラウザで http://localhost:3030 を開く
```

## 📖 ハンズオン資料の構成

- `slides.md` - メインのスライド（概要と全体構成）
- `pages/` - 詳細なハンズオン手順
  - `01-preparation.md` - 環境準備
  - `02-basic-concepts.md` - 基本概念と他サービスとの比較
  - `03-simple-deployment.md` - シンプル Web アプリのデプロイ
  - `04-env-and-secrets.md` - 環境変数とシークレット管理
  - `05-scaling.md` - スケーリングとオートスケール
  - `06-service-connectivity.md` - Container Apps 同士の連携
  - `07-vnet-security.md` - VNet 連携とセキュリティ
  - `08-monitoring.md` - モニタリングとログ管理
  - `09-microservices.md` - 実践演習（マイクロサービス構成）
  - `99-summary.md` - まとめ

## 📝 参考資料

- [Azure Container Apps 公式ドキュメント](https://learn.microsoft.com/azure/container-apps/)
- [Dapr 公式ドキュメント](https://docs.dapr.io/)
- [KEDA 公式ドキュメント](https://keda.sh/)

## 🔗 関連ハンズオン

- `apps/107-app-service-for-container/` - App Service for Containers ハンズオン

---

Learn more about Slidev at the [documentation](https://sli.dev/).
