---
layout: center
---

# まとめ

Azure サーバーレス & イベント駆動アーキテクチャ完全攻略

---

## 本日学んだこと

<div class="grid grid-cols-2 gap-8 pt-6">
<div>

### ✅ ハンズオンで実践したサービス

- **Azure Functions:** さまざまなトリガーでサーバーレス処理
- **Event Grid:** イベント駆動アーキテクチャの基盤
- **Logic Apps:** ノーコードワークフロー自動化

### ✅ 共通の概念

- **サーバーレスのメリット:** 従量課金、自動スケール、管理不要
- **イベント駆動:** 疎結合、非同期処理、スケーラビリティ
- **統合:** 複数サービスの連携で強力なシステム構築

</div>
<div>

### ✅ 実践的なスキル

- HTTP、Timer、Blob、Queue、Event Grid トリガー
- イベントの発行とサブスクリプション
- フィルタリングとルーティング
- 条件分岐、ループ、並列処理
- エラーハンドリングとリトライ
- モニタリングとデバッグ

### ✅ エンドツーエンドシナリオ

- 注文処理システムの構築
- 複数サービスの連携
- 実践的なアーキテクチャ設計

</div>
</div>

---

## ベストプラクティス

<div class="grid grid-cols-2 gap-8 pt-6">
<div>

### 🎯 設計

**アーキテクチャ:**

- イベント駆動で疎結合に設計
- 単一責任の原則に従う
- べき等性を確保

**パフォーマンス:**

- 適切なトリガーの選択
- 並列処理の活用
- コールドスタートの考慮

**スケーラビリティ:**

- ステートレスな設計
- 適切なパーティショニング
- リトライとデッドレター処理

</div>
<div>

### 🔒 セキュリティと運用

**セキュリティ:**

- Managed Identity の使用
- 最小権限の原則
- シークレットの適切な管理

**監視:**

- Application Insights 統合
- メトリクスとログの収集
- アラート設定

**コスト管理:**

- 適切なプランの選択
- 実行回数の最適化
- 定期的なコストレビュー

</div>
</div>

---

## サービスの使い分け

用途に応じて最適なサービスを選択しましょう。

| ユースケース                       | 推奨サービス      | 理由                                         |
| ---------------------------------- | ----------------- | -------------------------------------------- |
| **REST API 構築**                  | Azure Functions   | HTTP トリガー、柔軟な実装、低コスト          |
| **定期バッチ処理**                 | Azure Functions   | Timer トリガー、Cron 式、従量課金            |
| **イベントルーティング**           | Event Grid        | 大規模スケール、フィルタリング、低レイテンシ |
| **ビジネスプロセス自動化**         | Logic Apps        | ノーコード、400+コネクター、視覚的設計       |
| **複数サービス統合**               | Logic Apps        | 簡単な統合、エラーハンドリング、リトライ     |
| **大量ストリーミングデータ**       | Event Hubs        | 毎秒数百万イベント、Kafka 互換               |
| **エンタープライズメッセージング** | Service Bus       | トランザクション、メッセージセッション       |
| **長時間ワークフロー**             | Durable Functions | ステートフル、オーケストレーション           |

---

## アーキテクチャパターン

実践的なアーキテクチャパターンを紹介します。

<div class="grid grid-cols-2 gap-6 text-xs">
<div>

### 📊 パターン1: イベントソーシング

**構成:**

- Event Grid でイベントを発行
- Functions でイベントを処理
- Cosmos DB に状態を保存

**メリット:**

- 完全な監査ログ
- イベントの再生が可能
- 時系列データの分析

**ユースケース:**

- 金融取引システム
- 注文処理システム
- ユーザー行動分析

</div>
<div>

### 🔄 パターン2: ファンアウト/ファンイン

**構成:**

- 1つのイベントを複数の Functions で処理
- 結果を集約して次の処理へ

**メリット:**

- 並列処理でスループット向上
- 各処理が独立
- スケーラビリティ

**ユースケース:**

- 大量データの並列処理
- マルチステップワークフロー
- データ変換パイプライン

</div>

<div>

### ⚡ パターン3: CQRS

**構成:**

- コマンド用 Function（書き込み）
- クエリ用 Function（読み取り）
- Event Grid でデータ同期

**メリット:**

- 読み書きの最適化
- 独立したスケーリング
- パフォーマンス向上

**ユースケース:**

- 高トラフィックアプリ
- 複雑な検索要件
- レポーティングシステム

</div>
<div>

### 🌐 パターン4: API Gateway

**構成:**

- API Management
- Functions によるバックエンド
- Event Grid でイベント通知

**メリット:**

- 統一されたAPI
- 認証・認可の集中管理
- レート制限とキャッシング

**ユースケース:**

- マイクロサービスAPI
- パートナー向けAPI
- モバイルアプリバックエンド

</div>
</div>

---

## 次のステップ

さらに学習を深めるためのリソースとトピックです。

<div class="grid grid-cols-2 gap-8 pt-6">
<div>

### 🚀 さらに学ぶ

- **Durable Functions**
  - ステートフルなオーケストレーション
  - 長時間実行ワークフロー
- **Azure API Management**
  - API ゲートウェイ、ポリシー
- **Azure Service Bus**
  - エンタープライズメッセージング
- **Azure Event Hubs**
  - 大規模ストリーミングデータ
- **Azure Monitor と Application Insights**
  - 高度な監視とログ分析

</div>
<div>

### 📚 参考リンク

- [Azure Functions ドキュメント](https://learn.microsoft.com/ja-jp/azure/azure-functions/)
- [Azure Event Grid ドキュメント](https://learn.microsoft.com/ja-jp/azure/event-grid/)
- [Azure Logic Apps ドキュメント](https://learn.microsoft.com/ja-jp/azure/logic-apps/)
- [サーバーレスアーキテクチャガイド](https://learn.microsoft.com/ja-jp/azure/architecture/serverless/)
- [Azure 料金計算ツール](https://azure.microsoft.com/ja-jp/pricing/calculator/)

</div>
</div>

---

## リソースのクリーンアップ

ハンズオン終了後、リソースグループを削除してコストを抑えましょう。

```bash
# リソースグループの削除（すべてのリソースが削除されます）
az group delete \
  --name serverless-hands-on-rg \
  --yes \
  --no-wait

# 削除の確認
az group list --output table
```

<br>

**💡 重要:**

- リソースグループを削除すると、含まれるすべてのリソースが削除されます
- 削除は元に戻せません。本番環境では特に注意してください
- 継続して使用する場合は、不要なリソースのみを個別に削除

<br>

**個別リソースの削除:**

```bash
# Function Appのみ削除
az functionapp delete --name func-app-20251016 --resource-group serverless-hands-on-rg

# Event Gridトピックのみ削除
az eventgrid topic delete --name order-events-topic --resource-group serverless-hands-on-rg

# Logic Appのみ削除
az logic workflow delete --name order-processing-workflow --resource-group serverless-hands-on-rg
```

---
layout: center
---

# ありがとうございました！

## 質疑応答
