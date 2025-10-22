---
layout: center
---

# 📚 まとめと次のステップ

App Service for Containers ハンズオンを完了しました

---

## ハンズオンの振り返り

このハンズオンで学んだことを確認します。

<div class="grid grid-cols-2 gap-6 pt-6 text-sm">

<div>

### 📦 基礎知識

- **App Service for Containers とは**

  - PaaS でのコンテナ運用
  - Docker イメージをそのまま実行
  - インフラ管理不要

- **アーキテクチャ理解**
  - App Service Plan とは
  - コンテナ実行環境の仕組み
  - 他サービスとの比較

</div>

<div>

### ⚡ 環境準備

- **ACR の作成と管理**

  - コンテナレジストリの役割
  - イメージのビルド・プッシュ
  - 複数人での共有戦略

- **サンプルアプリの準備**
  - Dockerfile の作成
  - ローカルテスト
  - イメージの最適化

</div>

</div>

---

## 学んだ内容（続き）

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">

<div>

### 🚀 デプロイと設定

- **App Service のデプロイ**

  - App Service Plan の作成
  - コンテナイメージの設定
  - ACR 認証（パスワード / Managed Identity）

- **コンテナ詳細設定**
  - 環境変数の管理
  - ポート設定（WEBSITES_PORT）
  - スタートアップコマンド
  - Docker Compose による複数コンテナ

</div>

<div>

### 📈 スケーリング

- **スケールアップ / アウト**

  - App Service Plan の性能向上
  - インスタンス数の増加
  - オートスケールの設定

- **パフォーマンス最適化**
  - Always On の設定
  - デプロイスロットの活用
  - スロットスワップでのゼロダウンタイム

</div>

</div>

---

## 学んだ内容（続き）

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">

<div>

### 🔐 セキュリティ

- **HTTPS 設定**

  - TLS/SSL の強制
  - 最小 TLS バージョン設定
  - カスタムドメインの追加

- **アクセス制御**
  - IP 制限
  - Managed Identity
  - Key Vault 統合
  - VNet 統合

</div>

<div>

### 📊 運用・監視

- **ログ管理**

  - Application / Container / Web Server Logs
  - Log Stream でのリアルタイム監視
  - ログのダウンロードと分析

- **Application Insights**
  - 詳細な監視と診断
  - KQL でのログ分析
  - アラート設定
  - Availability Test

</div>

</div>

---

## 学んだ内容（続き）

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">

<div>

### 🔄 CI/CD

- **GitHub Actions**

  - ワークフローの作成
  - ACR への自動ビルド
  - App Service への自動デプロイ

- **Blue/Green デプロイ**
  - ステージングスロットでの検証
  - 本番環境へのスワップ
  - ロールバック戦略

</div>
</div>

---

## App Service for Containers の強みと限界

<div class="grid grid-cols-2 gap-6">
<div class="bg-green-500/10 p-4 rounded">

### ✅ 強み

- **シンプルさ**

  - 学習コストが低い
  - インフラ管理不要
  - すぐに始められる

- **PaaS の恩恵**

  - 自動スケーリング
  - 組み込み監視
  - SSL 証明書管理
  - デプロイスロット

- **柔軟性**

  - 任意の Docker イメージ
  - カスタムランタイム

- **コスト効率**
  - Plan 共有可能
  - 予測可能な料金

</div>

<div class="bg-red-500/10 p-4 rounded">

### ⚠️ 限界

- **単一コンテナ向け**

  - 複雑なマイクロサービスには不向き
  - Docker Compose は基本的

- **Kubernetes 非互換**

  - K8s マニフェスト使用不可
  - Helm チャート使用不可

- **永続化制限**

  - `/home` のみ永続化
  - ステートフルアプリは工夫が必要

- **起動時間制限**

  - 230 秒以内に起動必要
  - 重いアプリは注意

- **ポート制約**
  - 明示的な設定が必要

</div>

</div>

---

## ベストプラクティスのチェックリスト

本番環境で App Service for Containers を使う際の確認事項です。

<div class="grid grid-cols-2 gap-4 pt-4 text-xs">

<div>

### ✅ デプロイ前チェックリスト

- [ ] **HTTPS のみを有効化**
- [ ] **TLS 1.2 以上を設定**
- [ ] **Always On を有効化**（B1 以上）
- [ ] **Managed Identity を有効化**
- [ ] **Key Vault で機密情報を管理**
- [ ] **Application Insights を統合**
- [ ] **ログを有効化**（Application/Container/Web Server）
- [ ] **ヘルスチェックエンドポイントを実装**
- [ ] **環境変数で設定を管理**（ハードコードしない）
- [ ] **WEBSITES_PORT を設定**
- [ ] **デプロイスロットを作成**（S1 以上）
- [ ] **CI/CD パイプラインを構築**

</div>

<div>

### ✅ 運用中チェックリスト

- [ ] **Availability Test を設定**
- [ ] **アラートルールを作成**
  - HTTP 5xx エラー
  - 高 CPU/メモリ使用率
  - 応答時間の遅延
- [ ] **オートスケールを設定**（必要に応じて）
- [ ] **定期的なログ確認**
- [ ] **パフォーマンスメトリクスの監視**
- [ ] **セキュリティアップデートの適用**
- [ ] **バックアップ戦略の確立**
- [ ] **ディザスタリカバリ計画**
- [ ] **コスト最適化の定期レビュー**
- [ ] **不要なリソースの削除**

</div>

</div>

---

## リソースのクリーンアップ

ハンズオン終了後、リソースを削除してコストを削減します。

```bash
# 方法 1: リソースグループごと削除（推奨）
az group delete \
  --name $RESOURCE_GROUP \
  --yes \
  --no-wait

# すべてのリソースが一括削除される
# - App Service
# - App Service Plan
# - Container Registry（個別作成の場合）
# - Application Insights
# - Key Vault
# - Log Analytics Workspace
# など

# 方法 2: 個別リソースの削除
az webapp delete --name $APP_NAME --resource-group $RESOURCE_GROUP
az appservice plan delete --name $PLAN_NAME --resource-group $RESOURCE_GROUP
az acr delete --name $ACR_NAME --resource-group $RESOURCE_GROUP

# 削除確認
az group show --name $RESOURCE_GROUP
# エラーが出れば削除完了
```

<div class="mt-4 bg-yellow-500/10 p-3 rounded text-xs">
⚠️ <strong>注意:</strong> 複数人で ACR を共有している場合、他のメンバーが使用中でないことを確認してから削除してください。
</div>

---

## 参考リソース

さらに学習を深めるための公式ドキュメントとリソースです。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">

<div>

### 📘 公式ドキュメント

- [App Service ドキュメント](https://learn.microsoft.com/ja-jp/azure/app-service/)
- [カスタムコンテナの実行](https://learn.microsoft.com/ja-jp/azure/app-service/quickstart-custom-container)
- [Azure Container Registry](https://learn.microsoft.com/ja-jp/azure/container-registry/)
- [Application Insights](https://learn.microsoft.com/ja-jp/azure/azure-monitor/app/app-insights-overview)

### 🎓 学習パス

- [Microsoft Learn - App Service](https://learn.microsoft.com/ja-jp/training/paths/deploy-a-website-with-azure-app-service/)
- [Microsoft Learn - コンテナ](https://learn.microsoft.com/ja-jp/training/paths/administer-containers-in-azure/)

</div>

<div>

### 🛠️ ツール

- [Azure CLI](https://learn.microsoft.com/ja-jp/cli/azure/)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Visual Studio Code - Azure 拡張機能](https://marketplace.visualstudio.com/items?itemName=ms-vscode.vscode-node-azure-pack)

### 💬 コミュニティ

- [Azure Tech Community](https://techcommunity.microsoft.com/t5/azure/ct-p/Azure)
- [Stack Overflow - azure-app-service](https://stackoverflow.com/questions/tagged/azure-app-service)
- [GitHub - Azure Samples](https://github.com/Azure-Samples)

</div>

</div>

---

## よくある質問（FAQ）

ハンズオン中によくある質問と回答です。

<div class="text-xs">

**Q1: 無料で App Service for Containers を使えますか？**

A: F1（Free）tier がありますが、Always On が使えず、カスタムドメインも設定できません。本格的な利用には B1 以上を推奨します。

**Q2: App Service Plan は必ず各自で作成する必要がありますか？**

A: 学習目的では個別作成を推奨します。共有すると CPU・メモリも共有され、パフォーマンスに影響します。

**Q3: ACR の代わりに Docker Hub を使えますか？**

A: 可能です。ただし、プライベートイメージの場合は Docker Hub の認証情報を App Service に設定する必要があります。

**Q4: 複数コンテナ（Docker Compose）は本番環境で使えますか？**

A: 使えますが、シンプルな構成のみ推奨。複雑な場合は Container Apps や AKS を検討してください。

**Q5: 既存の VM アプリを App Service に移行できますか？**

A: Dockerfile を作成してコンテナ化すれば可能です。ただし、ファイル永続化やポート設定などの制約に注意してください。

</div>

---
layout: center
---

<div class="pt-12 text-center">

# 🎉 ありがとうございました

</div>
