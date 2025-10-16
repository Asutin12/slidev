---
theme: seriph
background: https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=1920&h=1080&fit=crop
title: Microsoft Azure サービス解説
info: |
  ## Microsoft Azure サービス解説
  Azureでよく使われるサービスの概要と特徴
class: text-center
drawings:
  persist: false
transition: slide-left
mdc: true
---

<style src="./style.css"></style>

# Microsoft Azure サービス解説

クラウドで実現する、次世代のインフラストラクチャ

<div class="pt-12">
  <span @click="$slidev.nav.next" class="px-2 py-1 rounded cursor-pointer" hover="bg-white bg-opacity-10">
    Press Space to start <carbon:arrow-right class="inline"/>
  </span>
</div>

---

## layout: center

# 目次

<Toc maxDepth="1" />

---

## layout: section

# コンピューティングサービス

アプリケーションの実行環境

---

# Azure Virtual Machines ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/virtual-machines/))

仮想マシンでフルコントロールを実現

Azure Virtual Machines は、クラウド上で動作する仮想サーバーです。Windows Server や Linux など、様々な OS を選択でき、オンプレミスのサーバーをそのままクラウドに移行することができます。

<v-clicks>

**VM シリーズ**

- **汎用**: B、D シリーズ（バランス型）
- **コンピューティング最適化**: F シリーズ（高 CPU）
- **メモリ最適化**: E、M シリーズ（大容量メモリ）
- **ストレージ最適化**: L シリーズ（高スループット I/O）
- **GPU**: N シリーズ（機械学習、レンダリング）
- **HPC**: H シリーズ（ハイパフォーマンスコンピューティング）

**主な特徴**

- 柔軟なスケーリング、高可用性（可用性セット・ゾーン）
- スポット VM で大幅なコスト削減

</v-clicks>

---

# Azure App Service ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/app-service/))

Web アプリを手軽にホスティング

Azure App Service は、Web アプリケーションやモバイルバックエンドを簡単にデプロイできる PaaS（Platform as a Service）です。インフラの管理が不要で、開発者はコードに集中することができます。

<v-clicks>

**サービス構成**

- **Web Apps**: Web アプリケーションのホスティング
- **API Apps**: RESTful API の構築とホスティング
- **Mobile Apps**: モバイルバックエンドの構築
- **WebJobs**: バックグラウンドタスクの実行

**主な特徴**

- 多言語対応: .NET、Java、Node.js、Python、PHP などをサポート
- 自動スケーリング: アクセス増加に応じて自動でスケールアウト
- CI/CD 統合: GitHub Actions や Azure DevOps と簡単に連携

</v-clicks>

---

# Azure Static Web Apps ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/static-web-apps/))

静的サイトのホスティングとデプロイ

Azure Static Web Apps は、静的 Web アプリケーションを簡単にビルド・デプロイ・ホストできるサービスです。Angular、React、Vue などの最新フレームワークや、Gatsby、Hugo などの静的サイトジェネレーターに対応しています。

<v-clicks>

**主な特徴**

- 自動ビルド: GitHub や Azure DevOps との連携で自動デプロイ
- グローバル配信: CDN による高速コンテンツ配信
- API 統合: Azure Functions による API エンドポイント

**利用シーン**

- 企業サイトやブログの公開
- SPA（Single Page Application）のホスティング
- ドキュメントサイトやポートフォリオ

</v-clicks>

---

# Azure Functions ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/azure-functions/))

イベント駆動のサーバーレスコンピューティング

Azure Functions は、サーバーの管理が一切不要なサーバーレス環境です。特定のイベントが発生したときにだけコードが実行され、使った分だけ課金されるため、非常にコスト効率の良いサービスです。

<v-clicks>

**サポートトリガー**

- **HTTP Trigger**: REST API エンドポイント
- **Timer Trigger**: スケジュール実行（Cron 式）
- **Queue Trigger**: Azure Queue Storage、Service Bus
- **Blob Trigger**: Blob Storage へのファイルアップロード
- **Event Hub / Event Grid Trigger**: イベントストリーム処理
- **Cosmos DB Trigger**: データベース変更の検知

**主な特徴**

- 従量課金、多言語対応（C#、JavaScript、Python、Java など）
- Visual Studio / VS Code から直接デプロイ可能

</v-clicks>

---

# Azure Container Apps ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/container-apps/))

サーバーレスコンテナプラットフォーム

Azure Container Apps は、Kubernetes の複雑さを隠蔽しながら、コンテナ化されたアプリケーションをサーバーレスで実行できるサービスです。オーケストレーションやインフラ管理が不要で、マイクロサービスの実行に最適です。

<v-clicks>

**主な特徴**

- 自動スケーリング: ゼロスケールを含む柔軟なスケーリング
- 組み込み機能: ロードバランシング、トラフィック分割、リビジョン管理
- Dapr 統合: マイクロサービス開発を簡素化

**利用シーン**

- マイクロサービスアーキテクチャ
- イベント駆動型アプリケーション
- バックグラウンドジョブの実行

</v-clicks>

---

# Azure Container Instances ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/container-instances/)) & AKS ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/aks/))

コンテナで柔軟なアプリケーション実行

Azure Container Instances（ACI）は、コンテナを数秒で起動できるサービスです。一方、Azure Kubernetes Service（AKS）は、コンテナオーケストレーションツールである Kubernetes のマネージドサービスで、大規模なコンテナアプリケーションの運用に最適です。

<v-clicks>

**Azure Container Instances**

- 軽量で高速な起動
- Kubernetes の知識不要
- 一時的なワークロードに最適

**Azure Kubernetes Service**

- フルマネージドの Kubernetes
- 自動スケーリングと自己修復機能
- マイクロサービスの本番運用に最適

</v-clicks>

---

# Azure Spring Apps ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/spring-apps/))

Spring Boot アプリの実行環境

Azure Spring Apps は、Spring Boot マイクロサービスをコード変更なしで Azure にデプロイできるフルマネージドサービスです。インフラ管理が不要で、Java 開発者にとって最適なプラットフォームです。

<v-clicks>

**主な特徴**

- Spring 統合: Spring Cloud、Spring Boot との完全な互換性
- 運用管理: 監視、ログ、構成管理が組み込み
- CI/CD サポート: Jenkins、Azure DevOps、GitHub Actions との連携

**利用シーン**

- エンタープライズ Java アプリケーション
- Spring Boot マイクロサービス
- レガシー Java アプリのモダナイゼーション

</v-clicks>

---

## layout: section

# ストレージサービス

データを安全に保存・管理する

---

# [Azure Blob Storage](https://learn.microsoft.com/ja-jp/azure/storage/blobs/)

大容量のオブジェクトストレージ

Azure Blob Storage は、画像、動画、ドキュメントなど、あらゆる種類の非構造化データを保存できるオブジェクトストレージです。高い耐久性と可用性を持ち、世界中のどこからでもアクセス可能です。

<v-clicks>

**主な特徴**

- 3 つのアクセス層: Hot（頻繁アクセス）、Cool（低頻度）、Archive（長期保存）
- 大規模スケール: エクサバイト規模のデータにも対応
- セキュリティ: 暗号化、アクセス制御、バージョニング機能

**利用シーン**

- 静的コンテンツの配信（画像、CSS、JavaScript）
- バックアップやアーカイブ
- ビッグデータ分析のデータレイク

</v-clicks>

---

# Azure Files ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/storage/files/))

クラウド上の共有ファイルストレージ

Azure Files は、SMB プロトコルを使用したフルマネージドのファイル共有サービスです。オンプレミスのファイルサーバーをクラウドに移行したり、複数の VM で共有ストレージとして利用できます。

<v-clicks>

**主な特徴**

- 標準プロトコル: SMB 3.0/2.1、NFS に対応
- Azure File Sync: オンプレミスとクラウドのハイブリッド構成
- スナップショット: ポイントインタイムリカバリが可能

**利用シーン**

- アプリケーション設定ファイルの共有
- オンプレミスファイルサーバーの置き換え
- 開発環境での共有ストレージ

</v-clicks>

---

# Azure Data Lake Storage ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/storage/blobs/data-lake-storage-introduction))

ビッグデータ分析のためのストレージ

Azure Data Lake Storage は、Azure Blob Storage をベースに構築された、ビッグデータ分析に最適化されたストレージサービスです。構造化、半構造化、非構造化データを大規模に保存し、分析できます。

<v-clicks>

**主な特徴**

- 階層型名前空間: ファイルシステムのようなディレクトリ構造
- Hadoop 互換: Apache Spark、Hive などとシームレスに連携
- エンタープライズセキュリティ: きめ細かいアクセス制御と暗号化

**利用シーン**

- データレイクの構築
- 機械学習やビッグデータ分析
- ログやセンサーデータの大規模保存

</v-clicks>

---

# Azure Storage のその他サービス ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/storage/))

用途に応じた多様なストレージ

Azure Storage は、Blob と Files 以外にも複数のストレージサービスを提供しています。それぞれが特定のユースケースに最適化されています。

<v-clicks>

**サービス構成**

- **Disk Storage**: VM 用の高性能ブロックストレージ（SSD/HDD）
- **Queue Storage**: メッセージキューイング（非同期通信）
- **Table Storage**: NoSQL キーバリューストア（構造化データ）

**利用シーン**

- Disk: データベースや高 I/O アプリケーション
- Queue: マイクロサービス間の疎結合通信
- Table: IoT データやログデータの大規模保存

</v-clicks>

---

## layout: section

# データベースサービス

アプリケーションデータの管理

---

# Azure SQL Database ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/azure-sql/database/))

フルマネージドのリレーショナルデータベース

Azure SQL Database は、Microsoft SQL Server をベースとしたフルマネージドのデータベースサービスです。パッチ適用やバックアップなどの運用作業が自動化され、開発者はアプリケーション開発に集中できます。

<v-clicks>

**デプロイメントオプション**

- **Single Database**: 単一データベース（独立したリソース）
- **Elastic Pool**: 複数データベースでリソース共有
- **Managed Instance**: SQL Server との高い互換性

**主な特徴**

- 自動チューニング: AI によるパフォーマンス最適化
- 高可用性: 99.99%の SLA、自動フェイルオーバー
- スケーラビリティ: vCore モデルと DTU モデルから選択可能

</v-clicks>

---

# Azure Cosmos DB ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/cosmos-db/))

グローバル分散型のマルチモデルデータベース

Azure Cosmos DB は、世界中のどこでも低レイテンシでアクセスできるグローバル分散データベースです。複数のデータモデル（ドキュメント、キーバリュー、グラフ、列ファミリー）をサポートし、高い柔軟性を持ちます。

<v-clicks>

**サポート API**

- **NoSQL**: ネイティブ JSON ドキュメントストア
- **MongoDB**: MongoDB 互換 API
- **PostgreSQL**: 分散型 PostgreSQL
- **Cassandra**: Apache Cassandra 互換 API
- **Gremlin**: グラフデータベース API
- **Table**: Azure Table Storage 互換 API

**主な特徴**

- マルチリージョン対応: ワンクリックで世界中にデータを複製
- 複数の整合性レベル: Strong、Bounded Staleness、Session など 5 種類から選択
- 包括的な SLA: 可用性、レイテンシ、スループット、整合性を保証

</v-clicks>

---

# Azure Database for PostgreSQL ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/postgresql/)) & MySQL ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/mysql/))

オープンソースデータベースのマネージドサービス

Azure Database for PostgreSQL と Azure Database for MySQL は、人気のオープンソースデータベースのフルマネージドサービスです。バックアップ、パッチ適用、監視などが自動化され、運用負荷を大幅に削減できます。

<v-clicks>

**Azure Database for PostgreSQL**

- PostgreSQL の最新機能をサポート
- 単一サーバーとフレキシブルサーバーの 2 つの展開オプション
- 高度な拡張機能（PostGIS、pg_cron など）に対応

**Azure Database for MySQL**

- MySQL コミュニティエディションとの完全な互換性
- 自動バックアップとポイントインタイムリストア
- 読み取りレプリカによるスケールアウト

</v-clicks>

---

# Azure Cache for Redis ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/azure-cache-for-redis/))

高速インメモリキャッシュ

Azure Cache for Redis は、オープンソースの Redis をベースにしたフルマネージドのインメモリキャッシュサービスです。アプリケーションのパフォーマンスを劇的に向上させ、スケーラビリティを実現します。

<v-clicks>

**サービスティア**

- **Basic**: 開発・テスト用（単一ノード、SLA なし）
- **Standard**: 本番環境用（レプリケーション、99.9% SLA）
- **Premium**: エンタープライズ（クラスタリング、永続化、VNet）
- **Enterprise**: Redis Enterprise（Active-Active geo レプリケーション）

**主な特徴**

- ミリ秒未満のレスポンスタイム、多様なデータ構造
- Redis Modules サポート（RediSearch、RedisJSON など）

</v-clicks>

---

## layout: section

# ネットワーキングサービス

安全で高速な通信環境を構築

---

# Azure Virtual Network ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/virtual-network/))

プライベートなネットワーク環境

Azure Virtual Network（VNet）は、Azure リソース間の通信を可能にするプライベートネットワークです。オンプレミスのネットワークと同様に、IP アドレス範囲、サブネット、ルーティングテーブル、ネットワークゲートウェイを定義できます。

<v-clicks>

**サービス構成**

- **Subnets**: ネットワークのセグメント分割
- **Network Security Groups (NSG)**: トラフィックフィルタリング
- **Route Tables**: カスタムルーティング設定
- **NAT Gateway**: アウトバウンド接続の管理
- **VNet Peering**: VNet 間の直接接続
- **Private Endpoints**: Azure サービスへのプライベート接続

**主な特徴**

- 分離とセグメンテーション、ハイブリッド接続、高セキュリティ

</v-clicks>

---

# Azure Load Balancer ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/load-balancer/)) & Application Gateway ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/application-gateway/))

トラフィックの分散と制御

Azure Load Balancer は、レイヤー 4（TCP/UDP）の負荷分散を提供し、高可用性を実現します。一方、Application Gateway は、レイヤー 7（HTTP/HTTPS）のロードバランサーで、URL ベースのルーティングや SSL 終端などの高度な機能を備えています。

<v-clicks>

**Azure Load Balancer**

- 高スループット: 数百万の接続をサポート
- ゾーン冗長: 可用性ゾーンをまたいだ負荷分散
- アウトバウンド接続: NAT ゲートウェイとして機能

**Application Gateway**

- WAF（Web Application Firewall）統合
- Cookie-based セッションアフィニティ
- 自動スケーリング機能

</v-clicks>

---

# VPN Gateway ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/vpn-gateway/)) & Azure DNS ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/dns/))

セキュアな接続とドメイン管理

VPN Gateway は、オンプレミスのネットワークと Azure VNet をセキュアに接続するサービスです。サイト間 VPN、ポイント対サイト VPN、VNet 間 VPN をサポートします。

Azure DNS は、Microsoft Azure のインフラストラクチャを使用した DNS ホスティングサービスです。高速な名前解決と高可用性を提供し、Azure リソースと統合された管理が可能です。

<v-clicks>

**VPN Gateway**

- 高セキュリティ: IPsec と IKEv2 プロトコル
- 高可用性: アクティブ-アクティブ構成をサポート
- ExpressRoute 接続も可能

**Azure DNS**

- 高速な応答時間: エニーキャストネットワーク
- Azure ポータルからの統合管理
- プライベート DNS ゾーンにも対応

</v-clicks>

---

## layout: section

# メッセージングサービス

システム間の通信を実現

---

# Azure Event Hubs ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/event-hubs/))

大規模イベントストリーミング

Azure Event Hubs は、毎秒数百万のイベントを取り込み、処理できるビッグデータストリーミングプラットフォームです。IoT デバイスやアプリケーションからのテレメトリデータをリアルタイムで収集・分析できます。

<v-clicks>

**主な特徴**

- 大規模スループット: 毎秒数百万イベントを処理
- 低レイテンシ: リアルタイムデータ取り込み
- Kafka 互換: Apache Kafka プロトコルをサポート

**利用シーン**

- IoT テレメトリデータの収集
- アプリケーションログの集約
- リアルタイム分析パイプライン

</v-clicks>

---

## layout: section

# セキュリティと ID サービス

安全なクラウド環境を実現

---

# Microsoft Entra ID ([ドキュメント](https://learn.microsoft.com/ja-jp/entra/identity/))（旧 Azure AD）

クラウド時代の ID 管理

Microsoft Entra ID は、クラウドベースの ID・アクセス管理サービスです。従業員やパートナーがアプリケーションやリソースに安全にアクセスできるよう、シングルサインオン（SSO）や多要素認証（MFA）を提供します。

<v-clicks>

**主な特徴**

- シングルサインオン: 数千の SaaS アプリケーションと連携
- 条件付きアクセス: コンテキストに基づいたアクセス制御
- ID 保護: リスクベースの自動対応

**利用シーン**

- 従業員の認証基盤
- B2C アプリケーションの顧客認証
- Microsoft 365 や Dynamics 365 との統合

</v-clicks>

---

# Azure Key Vault ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/key-vault/))

機密情報の安全な保管

Azure Key Vault は、暗号化キー、パスワード、証明書、API キーなどの機密情報を安全に保管・管理するサービスです。アプリケーションコードにシークレットを埋め込む必要がなくなり、セキュリティが大幅に向上します。

<v-clicks>

**主な特徴**

- ハードウェアセキュリティモジュール（HSM）対応
- アクセス制御: Azure RBAC とアクセスポリシー
- 監査ログ: すべてのアクセスを記録

**利用シーン**

- データベース接続文字列の管理
- SSL/TLS 証明書の保管と自動更新
- 暗号化キーの一元管理

</v-clicks>

---

# Microsoft Defender for Cloud ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/defender-for-cloud/))

統合セキュリティ管理

Microsoft Defender for Cloud（旧 Azure Security Center）は、Azure、オンプレミス、マルチクラウド環境全体のセキュリティ態勢を管理し、脅威から保護するサービスです。

<v-clicks>

**主な機能**

- セキュアスコア: セキュリティ態勢の可視化と改善提案
- 脅威の検出: 機械学習による異常検知
- コンプライアンス管理: 規制要件への準拠状況を確認

**利用シーン**

- クラウドワークロードの保護
- セキュリティインシデントの早期検知
- コンプライアンス監査への対応

</v-clicks>

---

# App Configuration ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/azure-app-configuration/))

アプリケーション設定の一元管理

App Configuration は、アプリケーション設定と機能フラグを一元管理するためのサービスです。設定変更をコードデプロイなしに行え、複数環境での構成管理を簡素化します。

<v-clicks>

**主な特徴**

- 動的構成: アプリ再起動なしで設定を更新
- 機能フラグ: A/B テストや段階的ロールアウトに対応
- Key Vault 統合: シークレットを安全に参照

**利用シーン**

- マイクロサービスの構成管理
- 機能の段階的リリース
- 環境ごとの設定切り替え

</v-clicks>

---

## layout: section

# 監視と管理サービス

システムの健全性を維持する

---

# Azure Monitor ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/azure-monitor/))

包括的な監視ソリューション

Azure Monitor は、Azure リソースやアプリケーションのパフォーマンスと可用性を監視する統合サービスです。メトリクス、ログ、トレースを収集・分析し、問題の早期発見と解決を支援します。

<v-clicks>

**サービス構成**

- **Metrics**: リアルタイムのパフォーマンスデータ収集
- **Logs (Log Analytics)**: ログデータの収集・分析・クエリ
- **Application Insights**: アプリケーションパフォーマンス監視（APM）
- **Alerts**: 閾値超過時の自動通知やアクション実行
- **Workbooks**: カスタマイズ可能な視覚化とレポート
- **Network Watcher**: ネットワーク診断とトラブルシューティング

**主な機能**

- 統合ダッシュボード、スマートアラート、自動スケーリング連携

</v-clicks>

---

# Log Analytics ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/azure-monitor/logs/)) & Application Insights ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/azure-monitor/app/app-insights-overview))

詳細な分析と診断

Log Analytics は、ログデータを収集・分析するサービスで、Kusto Query Language（KQL）を使用して柔軟なクエリが可能です。Application Insights は、Web アプリケーションのパフォーマンス監視とユーザー行動分析に特化しています。

<v-clicks>

**Log Analytics**

- 集中ログ管理: 複数のソースからログを収集
- カスタムクエリ: KQL で強力なデータ分析
- 長期保存: コスト効率の良いデータ保持

**Application Insights**

- パフォーマンス追跡: レスポンスタイムや依存関係の可視化
- エラー診断: スタックトレースと詳細なコンテキスト
- 使用状況分析: ユーザー行動やセッション情報

</v-clicks>

---

## layout: section

# AI・機械学習サービス

インテリジェントなアプリケーションを構築

---

# Azure AI Search ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/search/))

高度な検索エクスペリエンス

Azure AI Search（旧 Azure Cognitive Search）は、AI を活用した検索サービスです。セマンティック検索、ベクトル検索、全文検索を組み合わせ、高度な検索体験を提供します。

<v-clicks>

**主な特徴**

- AI 統合: OCR、エンティティ抽出、キーフレーズ抽出
- ベクトル検索: 埋め込みベースの類似度検索
- 多言語対応: 56 言語のテキスト分析

**利用シーン**

- e コマースサイトの商品検索
- ドキュメント管理システム
- ナレッジベースの構築

</v-clicks>

---

# Azure AI Services ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/ai-services/))

すぐに使える AI 機能

Azure AI Services（旧 Cognitive Services）は、視覚、音声、言語、意思決定などの AI 機能を簡単に組み込める API サービス群です。機械学習の専門知識がなくても、高度な AI 機能をアプリケーションに追加できます。

<v-clicks>

**サービスカテゴリ**

- **Vision**: Computer Vision（画像分析）、Face（顔認識）、Custom Vision
- **Speech**: 音声認識、音声合成、音声翻訳、話者認識
- **Language**: テキスト分析、質問応答、翻訳、LUIS（言語理解）
- **Decision**: Anomaly Detector（異常検知）、Personalizer（パーソナライズ）
- **Document Intelligence**: OCR、フォーム認識、レイアウト分析
- **Content Safety**: 有害コンテンツの検出とフィルタリング

**利用シーン**

- カスタマーサポートの自動化、ドキュメントの自動処理
- アクセシビリティ機能の強化

</v-clicks>

---

# Azure Machine Learning ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/machine-learning/))

本格的な機械学習開発環境

Azure Machine Learning は、機械学習モデルの開発、トレーニング、デプロイを行うためのクラウドベースのプラットフォームです。データサイエンティストや ML エンジニアがエンドツーエンドで ML ライフサイクルを管理できます。

<v-clicks>

**サービス構成**

- **Designer**: ドラッグ&ドロップでモデル構築（ノーコード）
- **AutoML**: 自動機械学習（最適なモデルを自動選択）
- **Notebooks**: Jupyter ノートブック統合開発環境
- **Pipelines**: ML ワークフローの自動化
- **Model Registry**: モデルのバージョン管理と展開
- **Endpoints**: リアルタイム/バッチ推論エンドポイント

**主な機能**

- MLOps 対応、分散トレーニング、GPU/CPU クラスター

</v-clicks>

---

# Document Intelligence ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/ai-services/document-intelligence/))

ドキュメントからのデータ抽出

Document Intelligence（旧 Form Recognizer）は、AI を使用してドキュメントからテキスト、キーと値のペア、テーブル、構造を自動抽出するサービスです。請求書、領収書、ID カードなどの処理を自動化できます。

<v-clicks>

**事前構築済みモデル**

- **Invoice**: 請求書（ベンダー、金額、税金など）
- **Receipt**: レシート（店舗名、合計金額、品目など）
- **ID Document**: パスポート、運転免許証、ID カード
- **Business Card**: 名刺（名前、役職、連絡先など）
- **W-2**: 米国税務フォーム（給与所得証明書）
- **Health Insurance Card**: 健康保険証

**主な特徴**

- カスタムモデル対応、手書き・印刷テキストの高精度認識

</v-clicks>

---

# Content Safety ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/ai-services/content-safety/))

安全なコンテンツ管理

Content Safety は、テキストや画像内の有害なコンテンツを検出し、フィルタリングするサービスです。暴力、ヘイトスピーチ、性的コンテンツなどを AI で識別します。

<v-clicks>

**検出カテゴリ**

- **Hate**: ヘイトスピーチ、差別的表現
- **Violence**: 暴力的なコンテンツ、グロテスクな表現
- **Sexual**: 性的に露骨なコンテンツ
- **Self-Harm**: 自傷行為に関するコンテンツ

**主な特徴**

- マルチモーダル（テキスト・画像）、カスタマイズ可能な閾値
- リアルタイム処理、複数言語対応

</v-clicks>

---

# Azure OpenAI Service ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/ai-services/openai/))

最先端の生成 AI をビジネスに

Azure OpenAI Service は、OpenAI の強力な言語モデル（GPT-4、ChatGPT、Codex など）を Azure のエンタープライズグレードのセキュリティとコンプライアンスで提供します。

<v-clicks>

**利用可能なモデル**

- **GPT-4 / GPT-4 Turbo**: 最新の大規模言語モデル（128k トークン）
- **GPT-3.5 Turbo**: 高速で低コストなチャット完成
- **DALL-E 3**: テキストから画像生成
- **Embeddings**: テキストのベクトル化（ada-002）
- **Whisper**: 音声認識とテキスト変換

**主な特徴**

- エンタープライズセキュリティ、Content Filter 統合
- プライベートネットワーク、RBAC、監査ログ

</v-clicks>

---

## layout: section

# 統合サービス

システム間を連携する

---

# Azure Logic Apps ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/logic-apps/))

コードなしでワークフロー自動化

Azure Logic Apps は、ビジュアルデザイナーを使用してワークフローを構築できるサービスです。数百のコネクタが用意されており、SaaS、API、オンプレミスシステムを簡単に連携できます。

<v-clicks>

**主な特徴**

- 豊富なコネクタ: Office 365、Salesforce、SAP、Twitter など
- 条件分岐とループ: 複雑なビジネスロジックを実装
- スケーラビリティ: 負荷に応じた自動スケーリング

**利用シーン**

- ビジネスプロセスの自動化
- データ同期と統合
- イベント駆動型ワークフロー

</v-clicks>

---

# Azure Service Bus ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/service-bus-messaging/)) & Event Grid ([ドキュメント](https://learn.microsoft.com/ja-jp/azure/event-grid/))

メッセージングとイベント処理

Azure Service Bus は、エンタープライズメッセージングサービスで、アプリケーション間の信頼性の高い非同期通信を実現します。Event Grid は、イベント駆動型アーキテクチャのための軽量なイベントルーティングサービスです。

<v-clicks>

**Azure Service Bus**

- 高信頼性: メッセージの順序保証と重複検出
- 複雑なルーティング: トピックとサブスクリプション
- トランザクションサポート

**Azure Event Grid**

- リアルタイム配信: ミリ秒単位のイベントルーティング
- 大規模スケール: 毎秒数百万イベントに対応
- 柔軟なフィルタリング

</v-clicks>

---

layout: center
class: text-center

---

# まとめ

Microsoft Azure は 200 以上のサービスを提供し、<br>
あらゆるビジネスニーズに対応できるクラウドプラットフォームです。

<div class="mt-8 grid grid-cols-2 gap-4 text-left text-sm">
<div>

**コンピューティング**

- VM、App Service、Static Web Apps
- Functions、Container Apps、AKS、Spring Apps

**ストレージとデータベース**

- Blob、Files、Data Lake Storage
- SQL、Cosmos DB、PostgreSQL、MySQL、Redis

**ネットワーキング**

- VNet、Load Balancer、Application Gateway
- VPN Gateway、DNS

</div>
<div>

**メッセージング**

- Service Bus、Event Hubs、Event Grid

**セキュリティと ID**

- Entra ID、Key Vault、Defender、App Configuration

**監視と AI**

- Monitor、Application Insights
- AI Search、Cognitive Services、OpenAI
- Document Intelligence、Content Safety

</div>
</div>

<div class="mt-6 text-sm">
適切なサービスを組み合わせることで、<br>
スケーラブルで安全なクラウドソリューションを構築できます。
</div>

<div class="mt-4 text-xs opacity-70">
参考: [Microsoft Learn - 開発者向けの主要な Azure サービス](https://learn.microsoft.com/ja-jp/azure/developer/intro/azure-developer-key-services)
</div>
