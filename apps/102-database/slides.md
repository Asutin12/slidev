---
theme: "default"
style: "./style.css"
title: "Azure Database サービスハンズオン"
lang: "ja-JP"
drawings:
  enabled: true
highlighter: shiki
lineNumbers: false
info: |
  ## Azure Database サービスハンズオン

  Azure SQL Database、Azure Cosmos DB、Azure Database for PostgreSQLを実践的に学び、
  クラウドデータベースの活用方法を理解するハンズオン資料です。
---

## Azure Database サービス<br>ハンズオン

実践で学ぶクラウドデータベース

<div class="pt-12">
  <span @click="$slidev.nav.next" class="px-2 py-1 rounded cursor-pointer" hover="bg-white bg-opacity-10">
    Press Space for next page <carbon:arrow-right class="inline"/>
  </span>
</div>

---

## 本日のアジェンダ

Azure Database サービスを実践的に学び、クラウドでのデータ管理の基礎を理解します。

### 基礎知識

- 🗄️ **Azure Database サービスの全体像**
- 📋 **前提条件**

### 実践ハンズオン（3つ）

- 🔷 **① Azure SQL Database**
  - マネージドRDBMSの構築
  - データベースの操作と管理

- 🌐 **② Azure Cosmos DB**
  - NoSQLデータベースの構築
  - グローバル分散とスケーラビリティ

- 🐘 **③ Azure Database for PostgreSQL**
  - オープンソースDBのマネージドサービス
  - 高可用性構成

---
layout: center
---

# Azure Database サービス とは？

**データベースを手軽に、そして安全に運用するための<br>フルマネージド・データベースサービス**

---

## Azure Database サービスの魅力

Azure Database サービスは、さまざまなデータベースをマネージドサービスとして提供する **PaaS (Platform as a Service)** です。
インフラストラクチャの管理から解放され、開発者はデータモデリングとアプリケーション開発に集中できます。

<div class="grid grid-cols-2 gap-x-8 gap-y-4 pt-6">

<div class="bg-gray-500/10 p-4 rounded">

#### 🚀 簡単セットアップ

数分でデータベースをプロビジョニング。複雑な設定や構成は不要で、すぐに使い始められます。

</div>

<div class="bg-gray-500/10 p-4 rounded">

#### 🔧 自動管理

バックアップ、パッチ適用、高可用性設定など、面倒な運用タスクはAzureが自動で実施します。

</div>

<div class="bg-gray-500/10 p-4 rounded">

#### 📈 柔軟なスケーリング

ワークロードに応じて、コンピューティングとストレージを独立してスケール可能。コストを最適化できます。

</div>

<div class="bg-gray-500/10 p-4 rounded">

#### 🔒 高いセキュリティ

組み込みのセキュリティ機能、暗号化、脅威検出、コンプライアンス対応で安心してデータを保管できます。

</div>

</div>

---

## Azure Database サービス概要

Azure が提供する主要なデータベースサービスを理解し、用途に応じた使い分けを学びます。

<div class="grid grid-cols-3 gap-4 pt-6 text-xs">

<div class="bg-blue-500/10 p-3 rounded">

#### 🔷 Azure SQL Database（ハンズオン）

<div class="mt-2">
<strong>用途：</strong>リレーショナルデータベース（RDBMS）<br>
<strong>特徴：</strong>SQL Server互換、自動チューニング、高可用性
</div>
</div>

<div class="bg-green-500/10 p-3 rounded">

#### 🌐 Azure Cosmos DB（ハンズオン）

<div class="mt-2">
<strong>用途：</strong>グローバル分散型NoSQLデータベース<br>
<strong>特徴：</strong>マルチモデル対応、低レイテンシ、自動スケール
</div>
</div>

<div class="bg-purple-500/10 p-3 rounded">

#### 🐘 Azure Database for PostgreSQL（ハンズオン）

<div class="mt-2">
<strong>用途：</strong>オープンソースPostgreSQLのマネージドサービス<br>
<strong>特徴：</strong>完全互換、拡張機能サポート、高可用性
</div>
</div>

<div class="bg-orange-500/10 p-3 rounded">

#### 🐬 Azure Database for MySQL（参考）

<div class="mt-2">
<strong>用途：</strong>オープンソースMySQLのマネージドサービス<br>
<strong>特徴：</strong>完全互換、自動バックアップ、スケーラブル
</div>
</div>

<div class="bg-red-500/10 p-3 rounded">

#### ⚡ Azure Cache for Redis（参考）

<div class="mt-2">
<strong>用途：</strong>インメモリキャッシュ、セッションストア<br>
<strong>特徴：</strong>高速アクセス、永続化オプション、クラスタリング
</div>
</div>

<div class="bg-cyan-500/10 p-3 rounded">

#### 📊 Azure Synapse Analytics（参考）

<div class="mt-2">
<strong>用途：</strong>データウェアハウス、ビッグデータ分析<br>
<strong>特徴：</strong>統合分析、無制限スケール、Apache Spark統合
</div>
</div>

</div>

---

## 各サービスの詳細説明（1/3）

### 🔷 Azure SQL Database

**どういうサービス？**

- Microsoft SQL Server をベースとしたフルマネージドRDBMS
- 高可用性、自動バックアップ、自動チューニングを標準装備

**主な特徴：**

- SQL Server互換（T-SQL、ストアドプロシージャ、トリガー）
- 自動チューニングとパフォーマンス推奨機能
- 組み込みの高可用性（99.99% SLA）
- サーバーレスオプションで使用量に応じた課金

**何のため？**

- トランザクション処理（OLTP）アプリケーション
- 既存のSQL Serverアプリケーションのクラウド移行
- ミッションクリティカルなビジネスアプリケーション

**比較：**

- **vs オンプレミスSQL Server**: 管理不要、自動スケール、高可用性が標準
- **vs RDS for SQL Server**: より深いAzure統合、高度な管理機能
- **vs PostgreSQL/MySQL**: SQL Server固有機能（T-SQL）が必要な場合に最適

---

## 各サービスの詳細説明（2/3）

### 🌐 Azure Cosmos DB

**どういうサービス？**

- グローバルに分散されたマルチモデルNoSQLデータベース
- 複数のAPIモデル（SQL、MongoDB、Cassandra、Gremlin、Table）をサポート

**主な特徴：**

- ターンキーのグローバル分散（複数リージョンへの自動レプリケーション）
- 一桁ミリ秒のレイテンシ保証
- 5つの一貫性レベルから選択可能
- 自動インデックス作成とスキーマレス設計

**何のため？**

- グローバルに展開されるWebアプリケーション
- リアルタイムアプリケーション（IoT、ゲーム、モバイル）
- 柔軟なスキーマが必要なアプリケーション

**比較：**

- **vs DynamoDB**: より柔軟な一貫性モデル、マルチモデル対応
- **vs MongoDB Atlas**: Azure統合が深く、グローバル分散が簡単
- **vs Azure SQL Database**: スキーマレス、水平スケーラビリティが優位

---

## 各サービスの詳細説明（3/3）

### 🐘 Azure Database for PostgreSQL

**どういうサービス？**

- オープンソースPostgreSQLのフルマネージドサービス
- コミュニティ版PostgreSQLとの完全互換性

**主な特徴：**

- PostgreSQL拡張機能のサポート（PostGIS、pgvector等）
- 自動バックアップと99.99%の可用性SLA
- 読み取りレプリカによるスケールアウト
- Flexible ServerとSingle Serverの2つのデプロイオプション

**何のため？**

- PostgreSQLを使用した既存アプリケーションの移行
- 地理空間データの処理（PostGIS）
- 高度なデータ型や機能が必要なアプリケーション

**比較：**

- **vs オンプレミスPostgreSQL**: 管理不要、自動バックアップ、スケーラビリティ
- **vs RDS for PostgreSQL**: Azureエコシステムとの統合が強力
- **vs Azure SQL Database**: オープンソース、PostgreSQL固有機能が必要な場合

---
layout: center
---

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
- 無料アカウント作成可能（12ヶ月の無料利用枠とクレジットが付与されます）
- 学生の方は [Azure for Students](https://azure.microsoft.com/ja-jp/free/students/) が利用できます

</div>
<div>

### 2. Azure CLI

コマンドラインから Azure リソースを操作するためのツールです。
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
  --name database-hands-on-rg \
  --location japaneast

# 作成されたことを確認
az group list --output table
```

**💡 重要:** リソースグループの`--location`は、メタデータの保存場所を指定します。<br>
その中に作成される各リソース（SQL Database、Cosmos DB等）は、それぞれ個別に`--location`を指定する必要があります。<br>
このハンズオンでは、すべてのリソースを`japaneast`に統一します。

---

## リソースプロバイダーの登録

初めてApp Serviceを使用する場合、リソースプロバイダーの登録が必要です。

```bash
# Microsoft.Sql
az provider register --namespace Microsoft.Sql

# 登録状況を確認（Registeredになれば完了）
az provider show --namespace Microsoft.Sql --query "registrationState" -o tsv
```

**💡 Tip:** 登録には数分かかる場合があります。`Registered`と表示されるまで待ちましょう。

<div class="bg-blue-500/10 p-3 rounded mt-4 text-sm">
<strong>📝 補足:</strong> このハンズオンでは以下のリソースプロバイダーを使用します。初回利用時はそれぞれ登録が必要です。
<ul class="mt-2 mb-0">
<li><code>Microsoft.Sql</code></li>
<li><code>Microsoft.DocumentDB</code></li>
<li><code>Microsoft.DBforPostgreSQL</code></li>
</ul>
</div>

---

## その他の必要ツール

データベース操作とアプリケーション開発に必要なツールを準備します。

<div class="grid grid-cols-2 gap-8 pt-4">
<div>

### Azure Data Studio / SQL Client

データベースへの接続と管理に使用します。
<br>

- [Azure Data Studio](https://azure.microsoft.com/ja-jp/products/data-studio) - SQL Server, PostgreSQL対応
- [pgAdmin](https://www.pgadmin.org/) - PostgreSQL専用GUIツール
- または psql コマンドラインツール

</div>
<div>

### Node.js と パッケージマネージャー

アプリケーションからデータベースに接続するために使用します。
<br>

```bash
# Node.js バージョン確認（18以上推奨）
node --version

# npm または bun のバージョン確認
npm --version
bun --version
```

<br>
<p class="text-xs">
※ このハンズオンでは Python と Node.js を使用しますが、Azure Database サービスは Java, .NET など他の言語もサポートしています。
</p>
</div>
</div>

---
layout: center
---

# ハンズオン① Azure SQL Database

マネージドRDBMSでトランザクション処理を実装

---

## Azure SQL Database ハンズオン概要

**目的:** Azure SQL Databaseの基本的な使い方を学び、リレーショナルデータベースを構築・運用する

<div class="grid grid-cols-2 gap-8 pt-6">
<div>

### 📚 学べるポイント

- **SQL Databaseの作成**
  - 論理サーバーとデータベースの構成
- **ファイアウォール設定**
  - セキュアなアクセス制御
- **データベース操作**
  - テーブル作成、CRUD操作
- **接続文字列の取得**
  - アプリケーションからの接続
- **パフォーマンス監視**
  - Query Performance Insightの活用

</div>
<div>

### 🎯 ハンズオン内容

1. **SQL Serverの作成**
   - 論理サーバーのプロビジョニング
2. **SQL Databaseの作成**
   - データベースインスタンスの構築
3. **ファイアウォール設定**
   - アクセス許可の設定
4. **データベースへの接続とデータ操作**
   - テーブル作成とクエリ実行
5. **アプリケーションからの接続**
   - Node.jsからの接続例

</div>
</div>

---

## ステップ1: SQL Serverの作成

まず、SQL Database を配置するための論理サーバーを作成します。

<div class="bg-orange-500/10 p-3 rounded mb-4 text-sm">
<strong>👤 複数人での実施:</strong> SQL Serverの名前は世界で一意である必要があります。（例: <code>mydbserver-tanaka-20251015</code>）
</div>

```bash
# SQL Server（論理サーバー）を作成
az sql server create \
  --name mydbserver20251009 \
  --resource-group database-hands-on-rg \
  --location japaneast \
  --admin-user sqladmin \
  --admin-password 'YourPassword123!'

# 作成されたサーバーを確認
az sql server list --output table
```

<br>

**SQL Server とは？**

- 複数のSQL Databaseを配置できる**論理的なコンテナ**
- 認証情報、ファイアウォールルール、監査設定を管理
- グローバルで一意な名前が必要（例: `mydbserver20251009`）

**💡 Tip:** パスワードは大文字、小文字、数字、記号を含む複雑なものを設定してください。

---

## ステップ2: SQL Databaseの作成

SQL Server上にデータベースを作成します。

```bash
# SQL Database を作成（Basic プラン）
az sql db create \
  --resource-group database-hands-on-rg \
  --server mydbserver20251009 \
  --name ProductsDB \
  --service-objective Basic

# 作成されたデータベースを確認
az sql db list \
  --resource-group database-hands-on-rg \
  --server mydbserver20251009 \
  --output table
```

<br>

**サービスレベルについて:**

- **Basic**: 開発・テスト向け（最大2GB）
- **Standard**: 本番環境向け（最大1TB）
- **Premium**: ミッションクリティカル向け（高IOPS、低レイテンシ）
- **Serverless**: 使用量に応じた自動スケール・課金

---

## ステップ3: ファイアウォール設定

自分のIPアドレスからのアクセスを許可します。

```bash
# 現在のIPアドレスを取得
MY_IP=$(curl -s ifconfig.me)

# ファイアウォールルールを追加
az sql server firewall-rule create \
  --resource-group database-hands-on-rg \
  --server mydbserver20251009 \
  --name AllowMyIP \
  --start-ip-address $MY_IP \
  --end-ip-address $MY_IP

# ルールを確認
az sql server firewall-rule list \
  --resource-group database-hands-on-rg \
  --server mydbserver20251009 \
  --output table
```

<br>

**💡 Tip:** Azureサービスからのアクセスを許可する場合は、`--start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0` で設定できます。

---

## ステップ4: データベースへの接続

Azure Data StudioまたはAzure Portalからデータベースに接続します。

<div class="grid grid-cols-2 gap-8">
<div>

### 接続情報の取得

```bash
# 接続文字列を取得
az sql db show-connection-string \
  --client ado.net \
  --name ProductsDB \
  --server mydbserver20251009
```

**接続情報:**

- **Server**: `mydbserver20251009.database.windows.net`
- **Database**: `ProductsDB`
- **User**: `sqladmin`
- **Password**: `YourPassword123!`

</div>
<div>

### Azure Portalからの接続

1. Azure Portal → SQL databases → ProductsDB
2. 「クエリエディター」を選択
3. 認証情報を入力してログイン
4. SQLクエリを実行可能

<br>

または、Azure Data Studioで接続：

- 新しい接続を作成
- サーバー名とクレデンシャルを入力
- 接続をテスト

</div>
</div>

---

## ステップ5: テーブル作成とデータ操作

SQLクエリでテーブルを作成し、データを挿入します。

```sql
-- Productsテーブルを作成
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(100) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Stock INT NOT NULL,
    CreatedAt DATETIME2 DEFAULT GETDATE()
);

-- サンプルデータを挿入
INSERT INTO Products (ProductName, Price, Stock)
VALUES
    ('Laptop', 89999.00, 10),
    ('Mouse', 2999.00, 50),
    ('Keyboard', 7999.00, 30),
    ('Monitor', 34999.00, 15);

-- データを確認
SELECT * FROM Products;
```

---

## ステップ6: パフォーマンス監視

Azure PortalでQuery Performance Insightを確認します。

**Query Performance Insight の活用:**

1. Azure Portal → SQL databases → ProductsDB
2. 「Query Performance Insight」を選択
3. 実行されたクエリのパフォーマンスを確認
   - 実行時間が長いクエリ
   - リソース消費が多いクエリ
   - 頻繁に実行されるクエリ

**自動チューニング:**

- Azure SQL Databaseは自動でインデックスを推奨・作成
- 「自動チューニング」セクションで推奨事項を確認
- パフォーマンスの自動最適化を有効化可能

---

## ステップ7: サーバーレスオプション（参考知識）

<div class="bg-blue-500/10 p-3 rounded mb-4 text-sm">
<strong>💡 参考情報:</strong> サーバーレスコンピューティング層は、間欠的な使用パターンに最適です。使用量に応じて自動的にスケーリングし、使用した分だけ課金されます。
</div>

**サーバーレスデータベースの作成:**

```bash
# サーバーレスオプションでデータベースを作成
az sql db create \
  --resource-group database-hands-on-rg \
  --server mydbserver20251009 \
  --name ServerlessDB \
  --compute-model Serverless \
  --edition GeneralPurpose \
  --family Gen5 \
  --min-capacity 0.5 \
  --max-capacity 4 \
  --auto-pause-delay 60
```

**メリット:**

- 使用していない時間は自動的に一時停止（課金停止）
- 必要に応じて自動再開とスケール
- コスト効率的（開発・テスト環境に最適）

---
layout: center
---

# ハンズオン② Azure Cosmos DB

グローバル分散NoSQLデータベースを構築

---

## Azure Cosmos DB ハンズオン概要

**目的:** Azure Cosmos DBの基本的な使い方を学び、スケーラブルなNoSQLデータベースを構築する

<div class="grid grid-cols-2 gap-8 pt-6">
<div>

### 📚 学べるポイント

- **NoSQLデータベースの基礎**
  - パーティションキーの設計
  - ドキュメント型データベースの特徴
- **FastAPIでのREST API構築**
  - Pydanticモデルの定義
  - エンドポイント設計
- **実践的なCRUD操作**
  - curlコマンドでのAPI操作
  - Swagger UIでのテスト
- **一貫性レベルとグローバル分散**
  - CAP定理の理解

</div>
<div>

### 🎯 ハンズオン内容

1. **Cosmos DBアカウントとコンテナの作成**
2. **Azure Portalでのデータ操作**
3. **Azure CLIでのクエリ実行**
4. **FastAPI REST APIの作成**
5. **curlでエンドポイントを叩いてCRUD操作**
6. **Swagger UIでのインタラクティブテスト**
7. **グローバル分散の設定（参考）**

</div>
</div>

---

## ステップ1: Cosmos DBアカウントの作成

Cosmos DBアカウントを作成します。

<div class="bg-orange-500/10 p-3 rounded mb-4 text-sm">
<strong>👤 複数人での実施:</strong> Cosmos DBアカウントの名前は世界で一意である必要があります。例: <code>mycosmosdb-tanaka-20251015</code>）
</div>

```bash
# Cosmos DBアカウントを作成（SQL API）
az cosmosdb create \
  --name mycosmosdb20251009 \
  --resource-group database-hands-on-rg \
  --locations regionName=japaneast failoverPriority=0 \
  --default-consistency-level Session

# 作成されたアカウントを確認
az cosmosdb list --output table
```

**API の選択:**

- **SQL API**: 最も一般的、SQL風のクエリ言語
- **MongoDB API**: MongoDBアプリケーションとの互換性
- **Cassandra API**: Apache Cassandraとの互換性
- **Gremlin API**: グラフデータベース
- **Table API**: Azure Table Storageとの互換性

**💡 Tip:** このハンズオンではSQL APIを使用します。

---

## ステップ2: データベースとコンテナの作成

データベースとコンテナ（テーブルに相当）を作成します。

```bash
# データベースを作成
az cosmosdb sql database create \
  --account-name mycosmosdb20251009 \
  --resource-group database-hands-on-rg \
  --name ProductsDB

# コンテナを作成（パーティションキー: /category）
az cosmosdb sql container create \
  --account-name mycosmosdb20251009 \
  --resource-group database-hands-on-rg \
  --database-name ProductsDB \
  --name Products \
  --partition-key-path "/category" \
  --throughput 400
```

<br>

**パーティションキーの重要性:**

- データの分散方法を決定する重要な設計要素
- 適切なパーティションキーで性能と拡張性が向上
- 変更不可のため、慎重に設計する必要がある

---

## ステップ3: 接続情報の取得

Cosmos DBへの接続に必要な情報を取得します。

```bash
# 接続文字列を取得
az cosmosdb keys list \
  --name mycosmosdb20251009 \
  --resource-group database-hands-on-rg \
  --type connection-strings

# プライマリキーを取得
az cosmosdb keys list \
  --name mycosmosdb20251009 \
  --resource-group database-hands-on-rg \
  --type keys
```

**接続情報:**

- **Endpoint**: `https://mycosmosdb20251009.documents.azure.com:443/`
- **Primary Key**: `<取得したキー>`

<br>

**💡 Tip:** 接続文字列とキーは機密情報です。環境変数やKey Vaultで管理してください。

---

## ステップ4-1: Azure Portalからのデータ操作

Azure PortalのData Explorerでデータを操作します。

**ドキュメントの作成:**

1. Azure Portal → Cosmos DB accounts → mycosmosdb20251009
2. 「Data Explorer」を選択
3. ProductsDB → Products → 「New Item」

```json
{
  "id": "1",
  "productName": "Laptop",
  "category": "Electronics",
  "price": 89999,
  "stock": 10,
  "tags": ["computer", "portable", "work"]
}
```

---

## ステップ4-2: Azure Portalからのクエリ実行

**クエリの実行:**

```sql
-- すべてのドキュメントを取得
SELECT * FROM c

-- 特定のカテゴリでフィルタ
SELECT * FROM c WHERE c.category = "Electronics"

-- 価格でソート
SELECT c.productName, c.price
FROM c
ORDER BY c.price DESC
```

---

## ステップ5-1: プログラムからのデータ操作と検証

Azure Portal以外からもデータ操作できることを確認します。

**方法1: Azure Cloud Shell でのクエリ実行**

```bash
# Cloud Shellを起動し、Azure CLIでクエリを実行
az cosmosdb sql container query \
  --account-name mycosmosdb20251009 \
  --resource-group database-hands-on-rg \
  --database-name ProductsDB \
  --name Products \
  --query-text "SELECT * FROM c"
```

**方法2: FastAPIでREST APIを作成して実際に叩く**

まず、接続情報を取得します：

```bash
# エンドポイントとキーを取得して環境変数に設定
export COSMOS_ENDPOINT=$(az cosmosdb show --name mycosmosdb20251009 \
  --resource-group database-hands-on-rg --query documentEndpoint -o tsv)

export COSMOS_KEY=$(az cosmosdb keys list --name mycosmosdb20251009 \
  --resource-group database-hands-on-rg --query primaryMasterKey -o tsv)
```

---

## ステップ5-2: プログラムからのデータ操作と検証

FastAPIアプリケーションを作成します：

```python
# app.py
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from azure.cosmos import CosmosClient
import os
from typing import List, Optional

app = FastAPI(title="Cosmos DB Products API")

# 環境変数の確認
COSMOS_ENDPOINT = os.getenv("COSMOS_ENDPOINT")
COSMOS_KEY = os.getenv("COSMOS_KEY")

# Cosmos DB接続
client = CosmosClient(COSMOS_ENDPOINT, COSMOS_KEY)
database = client.get_database_client("ProductsDB")
container = database.get_container_client("Products")

class Product(BaseModel):
    id: str
    productName: str
    category: str
    price: int
    stock: int
    tags: Optional[List[str]] = []

@app.get("/")
def read_root():
    return {"message": "Cosmos DB Products API", "status": "running"}

@app.post("/products", status_code=201)
def create_product(product: Product):
    """商品を作成"""
    container.create_item(body=product.dict())
    return {"message": "Product created", "product": product}

@app.get("/products/{product_id}")
def get_product(product_id: str, category: str):
    """商品を取得"""
    try:
        item = container.read_item(item=product_id, partition_key=category)
        return item
    except:
        raise HTTPException(status_code=404, detail="Product not found")

@app.get("/products")
def list_products(category: Optional[str] = None):
    """商品一覧を取得（カテゴリでフィルタ可能）"""
    if category:
        query = "SELECT * FROM c WHERE c.category = @category"
        items = container.query_items(
            query=query,
            parameters=[{"name": "@category", "value": category}],
            enable_cross_partition_query=False
        )
    else:
        items = container.query_items(
            query="SELECT * FROM c",
            enable_cross_partition_query=True
        )
    return {"products": list(items)}

@app.put("/products/{product_id}")
def update_product(product_id: str, category: str, product: Product):
    """商品を更新"""
    try:
        container.replace_item(item=product_id, body=product.dict())
        return {"message": "Product updated", "product": product}
    except:
        raise HTTPException(status_code=404, detail="Product not found")

@app.delete("/products/{product_id}")
def delete_product(product_id: str, category: str):
    """商品を削除"""
    try:
        container.delete_item(item=product_id, partition_key=category)
        return {"message": "Product deleted"}
    except:
        raise HTTPException(status_code=404, detail="Product not found")
```

---

## ステップ5-3: エンドポイントを実際に叩く

**セットアップと起動:**

```bash
# 仮想環境
python3 -m venv .venv
source .venv/bin/activate

# 依存関係をインストール
pip install fastapi uvicorn azure-cosmos

# サーバーを起動
uvicorn app:app --reload --port 8000
```

**💡 Note:** サーバー起動前に環境変数 `COSMOS_ENDPOINT` と `COSMOS_KEY` を設定してください（前のステップで設定済み）

サーバー起動後、別のターミナルでcurlコマンドを実行します。

**サーバーの動作確認:**

```bash
curl http://localhost:8000/
# 出力: {"message":"Cosmos DB Products API","status":"running"}
```

---

## ステップ5-4: エンドポイントを実際に叩く

**1. 商品の作成（POST）:**

```bash
curl -X POST http://localhost:8000/products \
  -H "Content-Type: application/json" \
  -d '{
    "id": "prod-001",
    "productName": "Wireless Keyboard",
    "category": "Electronics",
    "price": 4999,
    "stock": 30,
    "tags": ["keyboard", "wireless"]
  }'
```

**2. 商品一覧の取得（GET）:**

```bash
# すべての商品を取得
curl http://localhost:8000/products

# Electronicsカテゴリのみ
curl http://localhost:8000/products?category=Electronics
```

**3. 特定の商品を取得（GET）:**

```bash
curl "http://localhost:8000/products/prod-001?category=Electronics"
```

---

## ステップ5-5: CRUD操作の続き

**4. 商品の更新（PUT）:**

```bash
curl -X PUT "http://localhost:8000/products/prod-001?category=Electronics" \
  -H "Content-Type: application/json" \
  -d '{
    "id": "prod-001",
    "productName": "Wireless Keyboard Pro",
    "category": "Electronics",
    "price": 3999,
    "stock": 25,
    "tags": ["keyboard", "wireless", "premium"]
  }'
```

**5. 商品の削除（DELETE）:**

```bash
curl -X DELETE "http://localhost:8000/products/prod-001?category=Electronics"
```

**6. Swagger UIでインタラクティブテスト:**

ブラウザで `http://localhost:8000/docs` を開くと、Swagger UIが表示されます。
ここから直接APIをテストできます！

---

## ステップ5-6: Azure Portalでの検証

API操作後、Azure Portalで変更を確認します。

**検証手順:**

1. **Azure Portal → Cosmos DB → Data Explorer**
2. **ProductsDB → Products → Items**
3. 「Refresh」で最新データを表示

**確認ポイント:**

- POST で作成した `prod-001` が表示される
- PUT で更新された価格と商品名
- DELETE で削除されたことを確認

**💡 Tip:** Swagger UI (`/docs`) を使えば、ブラウザから簡単にCRUD操作をテストできます！

---

## ステップ6: グローバル分散の設定（参考知識）

<div class="bg-blue-500/10 p-3 rounded mb-4 text-sm">
<strong>💡 参考情報:</strong> Cosmos DBの強力な機能の1つは、ワンクリックでのグローバル分散です。複数のリージョンにデータを自動レプリケートできます。
</div>

```bash
# 複数リージョンへのレプリケーション追加
az cosmosdb update \
  --name mycosmosdb20251009 \
  --resource-group database-hands-on-rg \
  --locations regionName=japaneast failoverPriority=0 \
              regionName=westus2 failoverPriority=1

# レプリケーション状況の確認
az cosmosdb show \
  --name mycosmosdb20251009 \
  --resource-group database-hands-on-rg \
  --query "locations"
```

**メリット:**

- ユーザーに近いリージョンから低レイテンシでアクセス
- 自動フェイルオーバーによる高可用性
- マルチリージョン書き込みも可能

---

## ステップ7: 一貫性レベルの理解

Cosmos DBの5つの一貫性レベルを理解します。

**一貫性レベル（強→弱）:**

1. **Strong（強固）**: すべてのレプリカで同期、最新データを保証
2. **Bounded Staleness（境界付き陳腐化）**: 最大遅延時間/バージョン数を指定
3. **Session（セッション）**: 同一セッション内で一貫性保証（デフォルト）
4. **Consistent Prefix（一貫性のあるプレフィックス）**: 順序を保証、最新とは限らない
5. **Eventual（結果整合性）**: 最終的に一貫、最も弱い一貫性

<br>

**選択の指針:**

- **Strong**: 金融取引など厳密な一貫性が必要
- **Session**: 多くのアプリケーションに最適（パフォーマンスと一貫性のバランス）
- **Eventual**: 読み取り性能を最優先する場合

---
layout: center
---

# ハンズオン③ Azure Database for PostgreSQL

オープンソースPostgreSQLのマネージドサービスを活用

---

## Azure Database for PostgreSQL ハンズオン概要

**目的:** PostgreSQLのマネージドサービスの使い方を学び、オープンソースRDBMSを運用する

<div class="grid grid-cols-2 gap-8 pt-6">
<div>

### 📚 学べるポイント

- **Flexible Serverの作成**
  - マネージドPostgreSQLの構築
- **拡張機能の利用**
  - PostGIS、pgvectorなど
- **高可用性設定**
  - ゾーン冗長の構成
- **接続とデータ操作**
  - psqlとGUIツールの使用
- **バックアップとリストア**
  - 自動バックアップの活用
</div>
<div>

### 🎯 ハンズオン内容

1. **PostgreSQL Flexible Serverの作成**
2. **ファイアウォール設定とデータベース作成**
3. **データベースへの接続（psql/pgAdmin）**
4. **テーブル作成とデータ操作**
5. **データの検証とクエリ実行**
6. **PostGIS拡張機能の活用**
7. **パフォーマンス監視**

</div>
</div>

---

## ステップ1: PostgreSQL Flexible Serverの作成

Flexible Serverを作成します。

<div class="bg-orange-500/10 p-3 rounded mb-4 text-sm">
<strong>👤 複数人での実施:</strong> PostgreSQL Serverの名前は世界で一意である必要があります。（例: <code>mypgserver-tanaka-20251015</code>）
</div>

```bash
# PostgreSQL Flexible Server を作成
az postgres flexible-server create \
  --name mypgserver20251009 \
  --resource-group database-hands-on-rg \
  --location japaneast \
  --admin-user pgadmin \
  --admin-password 'YourPassword123!' \
  --sku-name Standard_B1ms \
  --tier Burstable \
  --storage-size 32 \
  --version 15

# 作成されたサーバーを確認
az postgres flexible-server list --output table
```

**Flexible Server vs Single Server:**

- **Flexible Server**: 新世代、より柔軟な構成、ゾーン冗長対応（推奨）
- **Single Server**: レガシー、2025年3月に廃止予定

---

## ステップ2: ファイアウォール設定

自分のIPアドレスからのアクセスを許可します。

```bash
# 現在のIPアドレスを取得
MY_IP=$(curl -s ifconfig.me)

# ファイアウォールルールを追加
az postgres flexible-server firewall-rule create \
  --resource-group database-hands-on-rg \
  --name mypgserver20251009 \
  --rule-name AllowMyIP \
  --start-ip-address $MY_IP \
  --end-ip-address $MY_IP

# ルールを確認
az postgres flexible-server firewall-rule list \
  --resource-group database-hands-on-rg \
  --name mypgserver20251009 \
  --output table
```

<br>

**💡 Tip:** Azureサービスからのアクセスを許可する場合は、Portalの設定で「Azureサービスへのアクセスを許可」を有効にします。

---

## ステップ3: データベースの作成

PostgreSQLデータベースを作成します。

```bash
# データベースを作成
az postgres flexible-server db create \
  --resource-group database-hands-on-rg \
  --server-name mypgserver20251009 \
  --database-name productsdb

# データベース一覧を確認
az postgres flexible-server db list \
  --resource-group database-hands-on-rg \
  --server-name mypgserver20251009 \
  --output table
```

---

## ステップ4: データベースへの接続

psqlコマンドラインツールまたはpgAdminで接続します。

<div class="grid grid-cols-2 gap-8">
<div>

### psqlでの接続

```bash
# 接続文字列を取得
az postgres flexible-server show-connection-string \
  --server-name mypgserver20251009

# psqlで接続
psql "host=mypgserver20251009.postgres.database.azure.com \
      port=5432 \
      dbname=productsdb \
      user=pgadmin \
      password=YourPassword123! \
      sslmode=require"

# データベース一覧を確認
\l

# テーブル一覧を確認
\dt
```

</div>
<div>

### pgAdminでの接続

1. pgAdminを起動
2. サーバーを追加
   - **Name**: Azure PostgreSQL
   - **Host**: `mypgserver20251009.postgres.database.azure.com`
   - **Port**: `5432`
   - **Username**: `pgadmin`
   - **Password**: `YourPassword123!`
3. 接続をテスト

</div>
</div>

---

## ステップ5: テーブル作成とデータ操作

SQLクエリでテーブルを作成し、データを挿入します。

```sql
-- Productsテーブルを作成
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- サンプルデータを挿入
INSERT INTO products (product_name, category, price, stock)
VALUES
    ('Laptop', 'Electronics', 89999.00, 10),
    ('Desk Chair', 'Furniture', 15999.00, 25),
    ('Coffee Maker', 'Appliances', 7999.00, 40),
    ('Notebook', 'Stationery', 299.00, 100);

-- データを確認
SELECT * FROM products;

-- カテゴリ別の集計
SELECT category, COUNT(*), AVG(price)
FROM products
GROUP BY category;
```

---

## ステップ6-1: データの検証とクエリ実行

**高度なクエリの実行:**

```sql
-- トランザクション処理のテスト
BEGIN;
UPDATE products SET stock = stock - 1 WHERE product_name = 'Laptop';
SELECT * FROM products WHERE product_name = 'Laptop';
COMMIT;

-- インデックスの作成と確認
CREATE INDEX idx_category ON products(category);
CREATE INDEX idx_price ON products(price);

-- インデックスの一覧表示
\di

-- Explainで実行計画を確認
EXPLAIN ANALYZE SELECT * FROM products WHERE category = 'Electronics';
```

**接続状態の確認:**

```sql
-- 現在の接続情報を確認
SELECT current_database(), current_user, inet_server_addr(), inet_server_port();

-- データベースのサイズを確認
SELECT pg_size_pretty(pg_database_size('productsdb'));
```

---

## ステップ7: 拡張機能の有効化（PostGIS）

地理空間データを扱うためにPostGIS拡張機能を有効にします。

```sql
-- PostGIS拡張機能を有効化
CREATE EXTENSION IF NOT EXISTS postgis;

-- 有効な拡張機能を確認
\dx

-- 地理空間データテーブルを作成
CREATE TABLE stores (
    store_id SERIAL PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL,
    location GEOGRAPHY(POINT, 4326)
);

-- サンプルデータを挿入（経度、緯度）
INSERT INTO stores (store_name, location)
VALUES
    ('Tokyo Store', ST_MakePoint(139.6917, 35.6895)),
    ('Osaka Store', ST_MakePoint(135.5023, 34.6937)),
    ('Fukuoka Store', ST_MakePoint(130.4017, 33.5904));

-- 東京から100km以内の店舗を検索
SELECT store_name,
       ST_Distance(location, ST_MakePoint(139.6917, 35.6895)::geography) / 1000 AS distance_km
FROM stores
WHERE ST_DWithin(location, ST_MakePoint(139.6917, 35.6895)::geography, 100000)
ORDER BY distance_km;
```

---

## ステップ8: パフォーマンス監視

Azure PortalでPostgreSQLのパフォーマンスを監視します。

**監視項目:**

1. **Azure Portal → PostgreSQL flexible server → Monitoring**
2. 「メトリック」で以下を確認：
   - CPU使用率
   - メモリ使用率
   - 接続数
   - ストレージ使用量
   - レプリケーション遅延（レプリカがある場合）

**クエリパフォーマンスの確認:**

```sql
-- 実行中のクエリを確認
SELECT pid, usename, application_name, client_addr, state, query
FROM pg_stat_activity
WHERE state = 'active';

-- テーブルの統計情報を確認
SELECT schemaname, tablename, n_live_tup, n_dead_tup
FROM pg_stat_user_tables;
```

---

## ステップ9: 高可用性設定（参考知識）

<div class="bg-blue-500/10 p-3 rounded mb-4 text-sm">
<strong>💡 参考情報:</strong> Flexible Serverはゾーン冗長構成で高可用性を実現できます。自動フェイルオーバーにより、障害時のダウンタイムを最小化します。
  </div>

```bash
# 高可用性を有効化したサーバーの作成
az postgres flexible-server create \
  --name mypgserver-ha-20251009 \
  --resource-group database-hands-on-rg \
  --location japaneast \
  --admin-user pgadmin \
  --admin-password 'YourPassword123!' \
  --sku-name Standard_D2s_v3 \
  --tier GeneralPurpose \
  --high-availability ZoneRedundant \
  --version 15
```

**高可用性のメリット:**

- 99.99%の可用性SLA
- 自動フェイルオーバー（数秒〜数十秒）
- ゾーン障害からの保護

---

## ステップ10: バックアップとリストア

自動バックアップとポイントインタイムリストアを活用します。

**自動バックアップ:**

- Flexible Serverは自動的に毎日バックアップを実施
- 保持期間はデフォルトで7日間（最大35日間まで設定可能）
- トランザクションログで任意の時点への復元が可能

```bash
# バックアップ保持期間の確認
az postgres flexible-server show \
  --name mypgserver20251009 \
  --resource-group database-hands-on-rg \
  --query "backup.backupRetentionDays"

# ポイントインタイムリストア
az postgres flexible-server restore \
  --resource-group database-hands-on-rg \
  --name mypgserver-restored \
  --source-server mypgserver20251009 \
  --restore-time "2025-10-09T12:00:00Z"
```

**💡 Tip:** 本番環境では、定期的にリストアのテストを実施して復旧手順を確認してください。

---
layout: center
---

# まとめ

Azure Database サービス完全攻略

---

## 本日学んだこと

<div class="grid grid-cols-2 gap-8 pt-6">
<div>

### ✅ ハンズオンで実践したサービス

- **Azure SQL Database:** マネージドRDBMSの構築と運用
- **Azure Cosmos DB:** グローバル分散NoSQLデータベース
- **Azure Database for PostgreSQL:** オープンソースDBのマネージドサービス

### ✅ 共通の概念

- **マネージドサービスの利点:** インフラ管理不要、自動バックアップ、高可用性
- **セキュリティ:** ファイアウォールルール、SSL/TLS接続、アクセス制御
- **スケーラビリティ:** 柔軟なリソース調整、グローバル分散

</div>
<div>

### ✅ 各サービスの特徴

- **SQL Database**: トランザクション処理、自動チューニング
- **Cosmos DB**: マルチモデル、低レイテンシ、グローバル分散
- **PostgreSQL**: オープンソース、拡張機能豊富、高可用性

### ✅ 実践的なスキル

- Azure CLIでのリソース管理
- 接続文字列の取得と使用
- アプリケーションからの接続
- パフォーマンス監視とチューニング

</div>
</div>

---

## ベストプラクティス

<div class="grid grid-cols-2 gap-8 pt-6">
<div>

### 🔒 セキュリティ

- **最小権限の原則**: 必要最小限のアクセス権限のみ付与
- **ファイアウォール設定**: IPアドレス制限で不正アクセス防止
- **暗号化**: 転送中・保存時の暗号化を有効化
- **認証情報の管理**: Azure Key Vaultで機密情報を保管

### 💰 コスト最適化

- **適切なサービスレベル選択**: ワークロードに応じた構成
- **サーバーレスオプション**: 間欠的な使用にはサーバーレスを検討
- **リソースの定期的な見直し**: 不要なリソースの削除
- **予約インスタンス**: 長期利用なら予約購入でコスト削減

</div>
<div>

### 📊 運用・監視

- **自動バックアップの確認**: 定期的にバックアップの実施確認
- **リストアテスト**: 復旧手順の定期的なテスト
- **パフォーマンス監視**: Azure Monitorでメトリクス監視
- **アラート設定**: 異常検知と自動通知

### 🏗️ 設計

- **適切なパーティション設計**: Cosmos DBのパーティションキー選択
- **インデックス戦略**: クエリパターンに応じたインデックス設計
- **高可用性構成**: ミッションクリティカルなシステムはHA構成
- **災害対策**: マルチリージョン構成とフェイルオーバー計画

</div>
</div>

---

## サービスの使い分け

用途に応じて最適なデータベースサービスを選択しましょう。

| ユースケース                   | 推奨サービス                  | 理由                               |
| ------------------------------ | ----------------------------- | ---------------------------------- |
| **トランザクション処理**       | Azure SQL Database            | ACID保証、高性能、自動チューニング |
| **既存SQL Serverの移行**       | Azure SQL Database            | 完全互換性、移行が容易             |
| **グローバルアプリ**           | Azure Cosmos DB               | 低レイテンシ、グローバル分散       |
| **スキーマレスデータ**         | Azure Cosmos DB               | 柔軟なスキーマ、JSON形式           |
| **オープンソースDB利用**       | Azure Database for PostgreSQL | 完全互換、豊富な拡張機能           |
| **地理空間データ**             | Azure Database for PostgreSQL | PostGIS拡張によるGIS機能           |
| **MongoDBアプリケーション**    | Cosmos DB (MongoDB API)       | MongoDB互換API、マネージドサービス |
| **データウェアハウス**         | Azure Synapse Analytics       | 大規模分析、BI統合                 |
| **キャッシュ・セッション管理** | Azure Cache for Redis         | 高速インメモリアクセス             |

---

## 次のステップ

さらに学習を深めるためのリソースとトピックです。

<div class="grid grid-cols-2 gap-8 pt-6">
<div>

### 🚀 さらに学ぶ

- **Azure Synapse Analytics**
  - データウェアハウスとビッグデータ分析
- **Azure Database Migration Service**
  - オンプレミスからの移行支援
- **Azure Private Link**
  - プライベートエンドポイントでのセキュア接続
- **Azure Monitor と Log Analytics**
  - 高度な監視とログ分析
- **Read Replica と Geo-Replication**
  - 読み取りスケールアウトと災害対策

</div>
<div>

### 📚 参考リンク

- [Azure SQL Database ドキュメント](https://learn.microsoft.com/ja-jp/azure/azure-sql/database/)
- [Azure Cosmos DB ドキュメント](https://learn.microsoft.com/ja-jp/azure/cosmos-db/)
- [Azure Database for PostgreSQL ドキュメント](https://learn.microsoft.com/ja-jp/azure/postgresql/)
- [Azure CLI リファレンス](https://learn.microsoft.com/ja-jp/cli/azure/)
- [Azure 料金計算ツール](https://azure.microsoft.com/ja-jp/pricing/calculator/)

</div>
</div>

---

## リソースのクリーンアップ

ハンズオン終了後、リソースグループを削除してコストを抑えましょう。

```bash
# リソースグループの削除（すべてのリソースが削除されます）
az group delete \
  --name database-hands-on-rg \
  --yes \
  --no-wait

# 削除の確認
az group list --output table
```

<br>

**💡 重要:**

- リソースグループを削除すると、含まれるすべてのリソースが削除されます
- データベースのバックアップも削除されるため、必要なデータは事前にエクスポートしてください
- 削除は元に戻せません。本番環境では特に注意してください

<br>

**代替案:**

- 特定のリソースのみを削除したい場合は、個別にリソースを削除
- 一時的に停止したい場合は、サーバーを停止（課金停止）

---
layout: center
---

# ありがとうございました！
