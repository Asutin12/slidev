---
layout: center
---

# ⚖️ ハンズオン ②

Azure Traffic Manager - グローバルトラフィック分散

---

## ハンズオン ② の概要

このハンズオンでは、Azure Traffic Manager を使って、複数リージョン間でのトラフィック分散とフェイルオーバーを実現します。

<div class="pt-6">

### 🎯 学習目標

- Traffic Manager の仕組みと動作原理を理解する
- 4 つのルーティング方式の使い分けを学ぶ
- プロファイルとエンドポイントの設定を習得する
- ヘルスチェックとフェイルオーバーの動作を確認する
- カスタムドメインとの統合方法を理解する（オプション）

### 📋 実施内容

1. **Traffic Manager プロファイルの作成** - ルーティング方式の選択
2. **エンドポイントの追加** - 複数 VM の登録
3. **ヘルスチェック設定** - 監視とフェイルオーバー
4. **DNS 統合**（オプション） - カスタムドメインでのアクセス
5. **動作確認** - 各ルーティング方式のテスト
</div>

---

## STEP 2-1: Traffic Manager の基礎知識

Traffic Manager の仕組みを理解します。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">
<div>

### Traffic Manager とは

- **DNS ベース**のグローバル負荷分散サービス
- Layer 7（アプリケーション層）で動作
- プロキシではなく、DNS クエリに応答

### 動作の流れ

```
1. クライアントがDNSクエリ
   ↓
2. Traffic ManagerがDNS応答
   ↓
3. クライアントが直接エンドポイントに接続
   ↓
4. トラフィックはエンドポイント直行
```

**重要:** Traffic Manager は**経由しない**

</div>
<div>

### 主な機能

✅ **グローバルトラフィック分散**

- 複数リージョンへの負荷分散

✅ **ヘルスチェック**

- エンドポイントの自動監視

✅ **自動フェイルオーバー**

- 障害時の自動切り替え

✅ **柔軟なルーティング**

- 4 つのルーティング方式

### ユースケース

- グローバルな Web アプリケーション
- ディザスタリカバリ
- マルチリージョン展開
- A/B テスト

</div>
</div>

---

## STEP 2-2: 4 つのルーティング方式 ①

<div class="grid grid-cols-2 gap-4 text-xs">
<div>

### Performance（パフォーマンス）

**動作**

- クライアントに最も近いエンドポイントを返す
- ネットワークレイテンシに基づく

**用途**

- グローバル Web アプリケーション
- 最高のユーザー体験を提供

**例**

- 日本のユーザー → Japan East
- 米国のユーザー → East US

</div>
<div>

### Priority（優先順位）

**動作**

- 優先順位の高いエンドポイントを返す
- プライマリが停止時にセカンダリへ

**用途**

- アクティブ-スタンバイ構成
- ディザスタリカバリ

**例**

- プライマリ（優先 1）：Japan East
- セカンダリ（優先 2）：East US

</div>
</div>

---

## STEP 2-2: 4 つのルーティング方式 ②

<div class="grid grid-cols-2 gap-4 text-xs">
<div>

### Weighted（加重）

**動作**

- 重み付けに基づいて分散
- 数値が大きいほど多くのトラフィック

**用途**

- 段階的なロールアウト
- A/B テスト

**例**

- 新バージョン（重み 10）→ 10%
- 旧バージョン（重み 90）→ 90%

</div>
<div>

### Geographic（地理的）

**動作**

- クライアントの地理的位置で決定
- 特定の地域を特定のエンドポイントに

**用途**

- データ主権の要件
- 地域別コンテンツ配信

**例**

- 日本 → Japan East
- 欧州 → West Europe
- その他 → East US（デフォルト）

</div>
</div>

---

## STEP 2-3: Traffic Manager プロファイルの作成 - Portal

Performance 方式のプロファイルを作成します。

1. **Traffic Manager プロファイルの作成開始**

   - Azure Portal で「Traffic Manager プロファイル」を検索
   - 「+ 作成」をクリック

2. **基本設定**

   - **名前**: `tm-dns-handson`（グローバルで一意な名前）
   - **ルーティング方法**: `パフォーマンス`
   - **サブスクリプション**: 使用中のサブスクリプション
   - **リソース グループ**: `rg-dns-handson`（ハンズオン ① で作成したもの、または新規作成）

3. **作成**
   - 「作成」をクリック
   - 作成完了まで約 1 分

<div class="mt-4 bg-blue-500/10 p-3 rounded text-sm">
💡 Traffic Managerの名前は `name.trafficmanager.net` という形式のFQDNになります。
</div>

---

## STEP 2-4: プロファイル作成（CLI 版）

コマンドラインで Traffic Manager プロファイルを作成します。

```bash
# リソースグループの変数設定（ハンズオン①と共有）
RESOURCE_GROUP="rg-dns-handson"
TM_NAME="tm-dns-handson"

# Traffic Managerプロファイル作成
az network traffic-manager profile create \
  --resource-group $RESOURCE_GROUP \
  --name $TM_NAME \
  --routing-method Performance \
  --unique-dns-name $TM_NAME \
  --ttl 30 \
  --protocol HTTP \
  --port 80 \
  --path "/"

# 作成確認
az network traffic-manager profile show \
  --resource-group $RESOURCE_GROUP \
  --name $TM_NAME \
  --query "{Name:name, DNS:dnsConfig.fqdn, Method:trafficRoutingMethod}" \
  --output table
```

### 作成された FQDN

```
tm-dns-handson.trafficmanager.net
```

この FQDN が Traffic Manager のエントリーポイントになり DNS 応答を返します。

---

## STEP 2-5: エンドポイントの追加

外部エンドポイントまたは Azure リソースをエンドポイントとして追加します。

<div class="grid grid-cols-2 gap-4 pt-4 text-xs">
<div>

### 外部エンドポイント ① の追加（例：東日本）

```bash
# 外部エンドポイントとして追加
# 実際のWebサイトやサービスのFQDNを使用
ENDPOINT1_FQDN="example-east.azurewebsites.net"

az network traffic-manager endpoint create \
  --resource-group $RESOURCE_GROUP \
  --profile-name $TM_NAME \
  --name endpoint-east \
  --type externalEndpoints \
  --target $ENDPOINT1_FQDN \
  --endpoint-location "Japan East" \
  --endpoint-status Enabled
```

<div class="mt-2 bg-blue-500/10 p-2 rounded text-xs">
💡 App Service、Storage、CDNなどの既存リソースを使用できます。
</div>

</div>
<div>

### 外部エンドポイント ② の追加（例：西日本）

```bash
# 2つ目の外部エンドポイント
ENDPOINT2_FQDN="example-west.azurewebsites.net"

az network traffic-manager endpoint create \
  --resource-group $RESOURCE_GROUP \
  --profile-name $TM_NAME \
  --name endpoint-west \
  --type externalEndpoints \
  --target $ENDPOINT2_FQDN \
  --endpoint-location "Japan West" \
  --endpoint-status Enabled
```

<div class="mt-2 bg-yellow-500/10 p-2 rounded text-xs">
⚠️ 実際に稼働しているエンドポイントを使用してください。
</div>

</div>
</div>

---

## STEP 2-6: エンドポイントの種類

Traffic Manager がサポートする 3 種類のエンドポイントを理解します。

<div class="grid grid-cols-3 gap-4 pt-4 text-xs">

<div class="bg-blue-500/10 p-3 rounded">

### Azure Endpoints

**説明:**

- Azure 内のリソース
- パブリック IP アドレス
- App Service
- Cloud Service

**用途:**

- Azure VM
- App Service
- Azure 内のサービス

**設定:**

```bash
--type azureEndpoints
--target-resource-id <resource-id>
```

</div>

<div class="bg-green-500/10 p-3 rounded">

### External Endpoints

**説明:**

- Azure 外のエンドポイント
- FQDN または IP アドレス
- オンプレミスサーバー

**用途:**

- オンプレミス統合
- 他クラウドサービス
- 外部 CDN

**設定:**

```bash
--type externalEndpoints
--target <fqdn-or-ip>
```

</div>

<div class="bg-purple-500/10 p-3 rounded">

### Nested Endpoints

**説明:**

- 他の Traffic Manager プロファイル
- 階層的な構成

**用途:**

- 複雑なルーティング
- リージョン内とリージョン間の組み合わせ

**設定:**

```bash
--type nestedEndpoints
--target-resource-id <tm-profile-id>
```

</div>

</div>

---

## STEP 2-7: ヘルスチェックの設定

エンドポイントの健全性を監視するヘルスチェックを設定します。

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

### ヘルスチェックの仕組み

1. **定期的なプローブ**

   - 各エンドポイントに定期的にリクエスト
   - デフォルト: 30 秒間隔

2. **応答の評価**

   - HTTP 200 OK を期待
   - タイムアウト: 10 秒

3. **障害の判定**

   - 連続 3 回失敗で「劣化」
   - 「劣化」状態のエンドポイントは返さない

4. **復旧の検知**
   - 正常応答で「オンライン」に復帰

</div>
<div>

### ヘルスチェック設定

```bash
# プロファイルの更新
az network traffic-manager profile update \
  --resource-group $RESOURCE_GROUP\
  --name $TM_NAME \
  --protocol HTTP \
  --port 80 \
  --path "/" \
  --interval 30 \
  --timeout 10 \
  --max-failures 3
```

### カスタムパスの設定

```bash
# ヘルスチェック専用エンドポイント
az network traffic-manager profile update \
  --resource-group $RESOURCE_GROUP\
  --name $TM_NAME \
  --path "/health"
```

</div>
</div>

---

## STEP 2-8: エンドポイントの状態確認

エンドポイントの状態を確認します。

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

### Portal での確認

1. **Traffic Manager プロファイルを開く**

   - `tm-network-handson` を開く

2. **エンドポイントの確認**
   - 左メニュー「エンドポイント」をクリック
   - 各エンドポイントの状態を確認

</div>
<div>

### CLI での確認

```bash
# エンドポイント一覧と状態
az network traffic-manager endpoint list \
  --resource-group $RESOURCE_GROUP\
  --profile-name $TM_NAME \
  --query "[].{Name:name, Status:endpointStatus, Monitor:endpointMonitorStatus}" \
  --output table
```

</div>
</div>

### 状態の種類

| 状態          | 説明                     |
| ------------- | ------------------------ |
| ✅ オンライン | 正常稼働中               |
| ⚠️ 劣化       | ヘルスチェック失敗       |
| 🔴 停止       | 手動で無効化             |
| ⏸️ 無効       | エンドポイント自体が停止 |

---

## STEP 2-9: DNS クエリの動作確認

Traffic Manager の DNS 応答を確認します。

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

### nslookup での確認

```bash
# Traffic ManagerのFQDNをクエリ
nslookup $TM_NAME.trafficmanager.net

# 結果例:
# Server:    8.8.8.8
# Address:   8.8.8.8#53
#
# Non-authoritative answer:
# Name:      tm-network-handson.trafficmanager.net
# Address:   20.xxx.xxx.xxx  ← エンドポイントのパブリックIP
```

</div>
<div>

### dig での詳細確認

```bash
# 詳細なDNS情報
dig $TM_NAME.trafficmanager.net

# TTL確認
dig $TM_NAME.trafficmanager.net +noall +answer

# 結果例:
# tm-network-handson.trafficmanager.net. 30 IN A 20.xxx.xxx.xxx
#                                         ↑
#                                      TTL: 30秒
```

</div>
</div>

<div class="mt-4 bg-blue-500/10 p-3 rounded text-sm">
💡 Performance方式の場合、クエリ元の位置により異なるエンドポイントが返されます。
</div>

---

## STEP 2-10: カスタムドメインとの統合（オプション）

📌 <strong>参考:</strong> このステップは<strong>ハンズオン ①（Azure DNS）を完了している場合のみ</strong>実施可能です。<br/>
Traffic Manager の動作確認は <code>tm-dns-handson.trafficmanager.net</code> で直接行えます。

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

### Azure DNS で CNAME レコード作成

前のハンズオンで作成した DNS ゾーンを使用：

```bash
# CNAMEレコード作成
az network dns record-set cname set-record \
  --resource-group $RESOURCE_GROUP\
  --zone-name example-handson.com \
  --record-set-name www \
  --cname $TM_NAME.trafficmanager.net

# レコード確認
az network dns record-set cname show \
  --resource-group $RESOURCE_GROUP\
  --zone-name example-handson.com \
  --name www \
  --query "{Name:name, CNAME:cnameRecord.cname}" \
  --output table
```

</div>
<div>

### 動作確認

```bash
# カスタムドメインでアクセス
nslookup www.example-handson.com

# 結果の流れ:
# www.example-handson.com
#   ↓ (CNAME)
# tm-network-handson.trafficmanager.net
#   ↓ (A)
# 20.xxx.xxx.xxx (エンドポイントIP)
```

### ブラウザでの確認

```
http://www.example-handson.com
```

Traffic Manager を経由してエンドポイントに到達します。

</div>
</div>

<div class="mt-4 bg-yellow-500/10 p-3 rounded text-sm">
⚠️ ゾーンAPEX（@）にはCNAMEを設定できないため、Azure DNSのAliasレコードを使用します。
</div>

---

## STEP 2-11: フェイルオーバーのテスト

エンドポイントの障害時の動作を確認します。

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

**1. 現在のエンドポイント確認**

```bash
# 現在返されているIP確認
dig $TM_NAME.trafficmanager.net +short
```

**2. エンドポイントを手動で停止**

```bash
# frontend エンドポイントを無効化
az network traffic-manager endpoint update \
  --resource-group $RESOURCE_GROUP\
  --profile-name $TM_NAME \
  --name endpoint-japan-east \
  --type azureEndpoints \
  --endpoint-status Disabled
```

</div>
<div>

**3. DNS 応答の変化を確認**

```bash
# 30秒（TTL）待機後、再度クエリ
sleep 30
dig $TM_NAME.trafficmanager.net +short

# 別のエンドポイントのIPが返ってくるはず
```

**4. エンドポイントを再度有効化**

```bash
az network traffic-manager endpoint update \
  --resource-group $RESOURCE_GROUP\
  --profile-name $TM_NAME \
  --name endpoint-japan-east \
  --type azureEndpoints \
  --endpoint-status Enabled
```

</div>
</div>

---

## STEP 2-12: Priority ルーティング方式のテスト

Priority 方式でアクティブ-スタンバイ構成を作ります。

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

### 新しいプロファイル作成

```bash
# Priority方式のプロファイル作成
az network traffic-manager profile create \
  --resource-group $RESOURCE_GROUP\
  --name tm-priority-handson \
  --routing-method Priority \
  --unique-dns-name tm-priority-handson \
  --ttl 30 \
  --protocol HTTP \
  --port 80 \
  --path "/"
```

</div>
<div>

### エンドポイント追加（優先順位付き）

```bash
# プライマリエンドポイント（優先順位1）
az network traffic-manager endpoint create \
  --resource-group $RESOURCE_GROUP \
  --profile-name tm-priority-handson \
  --name primary \
  --type externalEndpoints \
  --target $ENDPOINT1_FQDN \
  --endpoint-location "Japan East" \
  --priority 1 \
  --endpoint-status Enabled

# セカンダリエンドポイント（優先順位2）
az network traffic-manager endpoint create \
  --resource-group $RESOURCE_GROUP \
  --profile-name tm-priority-handson \
  --name secondary \
  --type externalEndpoints \
  --target $ENDPOINT2_FQDN \
  --endpoint-location "Japan West" \
  --priority 2 \
  --endpoint-status Enabled
```

</div>
</div>

---

## STEP 2-13: Priority ルーティングの動作確認

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

#### 正常時の動作

```bash
# DNSクエリ
dig tm-priority-handson.trafficmanager.net +short

# 結果: プライマリ（優先順位1）のIPが返される
# 20.xxx.xxx.xxx (frontend VM)
```

#### プライマリ停止時の動作

```bash
# プライマリを無効化
az network traffic-manager endpoint update \
  --resource-group $RESOURCE_GROUP\
  --profile-name tm-priority-handson \
  --name primary \
  --type azureEndpoints \
  --endpoint-status Disabled

# TTL経過後、再度クエリ
sleep 30
dig tm-priority-handson.trafficmanager.net +short

# 結果: セカンダリ（優先順位2）のIPが返される
# 20.yyy.yyy.yyy (app VM)
```

</div>
<div>

#### プライマリ復旧時の動作

```bash
# プライマリを再度有効化
az network traffic-manager endpoint update \
  --resource-group $RESOURCE_GROUP\
  --profile-name tm-priority-handson \
  --name primary \
  --type azureEndpoints \
  --endpoint-status Enabled

# TTL経過後、再度クエリ
sleep 30
dig tm-priority-handson.trafficmanager.net +short

# 結果: 再びプライマリのIPが返される
```

</div>
</div>

---

## STEP 2-14: Weighted ルーティング方式のテスト

Weighted 方式でトラフィック分散の割合を制御します。

#### プロファイル作成とエンドポイント追加

```bash
# Weighted方式のプロファイル作成
az network traffic-manager profile create \
  --resource-group $RESOURCE_GROUP\
  --name tm-weighted-handson \
  --routing-method Weighted \
  --unique-dns-name tm-weighted-handson \
  --ttl 30 \
  --protocol HTTP \
  --port 80 \
  --path "/"

# エンドポイント1（重み: 70）
az network traffic-manager endpoint create \
  --resource-group $RESOURCE_GROUP \
  --profile-name tm-weighted-handson \
  --name endpoint-70 \
  --type externalEndpoints \
  --target $ENDPOINT1_FQDN \
  --endpoint-location "Japan East" \
  --weight 70 \
  --endpoint-status Enabled

# エンドポイント2（重み: 30）
az network traffic-manager endpoint create \
  --resource-group $RESOURCE_GROUP \
  --profile-name tm-weighted-handson \
  --name endpoint-30 \
  --type externalEndpoints \
  --target $ENDPOINT2_FQDN \
  --endpoint-location "Japan West" \
  --weight 30 \
  --endpoint-status Enabled
```

---

## STEP 2-15: Weighted ルーティングの動作確認

重み付けによる分散を確認します。

```bash
# 10回クエリして結果を確認
for i in {1..10}; do
  dig tm-weighted-handson.trafficmanager.net +short
  sleep 1
done

# 期待される結果:
# 約70%が frontend VM のIP
# 約30%が app VM のIP
```

<div class="grid grid-cols-2 gap-4 text-xs">
<div>

**段階的ロールアウト**

- 新バージョン: 重み 10（10%）
- 旧バージョン: 重み 90（90%）

徐々に新バージョンの重みを増やす

- ステップ 1: 10% → 90%
- ステップ 2: 30% → 70%
- ステップ 3: 50% → 50%
- ステップ 4: 100% → 0%

</div>

<div>

**A/B テスト**

- バージョン A: 重み 50（50%）
- バージョン B: 重み 50（50%）

両方のバージョンに均等に分散し、効果を比較。

**Blue-Green デプロイ**

- Blue（現行）: 重み 100
- Green（新版）: 重み 0

切り替え時に重みを入れ替え：

- Blue: 0、Green: 100

</div>

</div>

---

## STEP 2-16: Geographic ルーティング方式

地理的位置に基づくルーティングを理解します。

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

### Geographic 方式の特徴

- **地理的マッピング**に基づく
- 国、地域、州レベルで指定可能
- データ主権の要件に対応

### サポートされる地域

- 世界（World）
- 大陸（Asia、Europe、Americas 等）
- 国（Japan、United States 等）
- 州/都道府県（米国の州など）

### 設定例

```bash
# Geographic方式プロファイル作成
az network traffic-manager profile create \
  --resource-group $RESOURCE_GROUP\
  --name tm-geographic-handson \
  --routing-method Geographic \
  --unique-dns-name tm-geographic-handson
```

</div>
<div>

### エンドポイントと地域のマッピング

```bash
# 日本向けエンドポイント
az network traffic-manager endpoint create \
  --resource-group $RESOURCE_GROUP \
  --profile-name tm-geographic-handson \
  --name japan-endpoint \
  --type externalEndpoints \
  --target $ENDPOINT1_FQDN \
  --endpoint-location "Japan East" \
  --geo-mapping "JP"

# その他の地域向けエンドポイント
az network traffic-manager endpoint create \
  --resource-group $RESOURCE_GROUP \
  --profile-name tm-geographic-handson \
  --name default-endpoint \
  --type externalEndpoints \
  --target $ENDPOINT2_FQDN \
  --endpoint-location "West US" \
  --geo-mapping "WORLD"
```

**注意:** より具体的なマッピングが優先されます（JP > WORLD）

</div>

</div>

---

## STEP 2-17: Nested Endpoints の活用

階層的な Traffic Manager 構成を理解します。

<div class="grid grid-cols-2 gap-6 text-sm">

<div>

### Nested Endpoints とは

- **Traffic Manager プロファイルをエンドポイントとして追加**
- 複雑なルーティングポリシーを実現

### ユースケース

**リージョン内とリージョン間の組み合わせ**

```
親プロファイル（Geographic）
├── 日本（Japan）
│   └── 子プロファイル（Weighted）
│       ├── Japan East（重み70%）
│       └── Japan West（重み30%）
└── 米国（US）
    └── 子プロファイル（Priority）
        ├── East US（優先1）
        └── West US（優先2）
```

</div>

<div>

### 設定例

```bash
# 子プロファイル（日本リージョン内）
az network traffic-manager profile create \
  --resource-group $RESOURCE_GROUP\
  --name tm-japan-region \
  --routing-method Weighted \
  --unique-dns-name tm-japan-region

# 親プロファイルに子プロファイルを追加
CHILD_PROFILE_ID=$(az network traffic-manager profile show \
  --resource-group $RESOURCE_GROUP\
  --name tm-japan-region \
  --query id -o tsv)

az network traffic-manager endpoint create \
  --resource-group $RESOURCE_GROUP\
  --profile-name tm-geographic-handson \
  --name nested-japan \
  --type nestedEndpoints \
  --target-resource-id $CHILD_PROFILE_ID \
  --min-child-endpoints 1 \
  --geo-mapping "JP"
```

</div>

</div>

---

## STEP 2-18: Traffic Manager の監視

プロファイルとエンドポイントの監視を設定します。

<div class="grid grid-cols-2 gap-6 text-sm">

<div>

### Azure Monitor との統合

**メトリクス監視:**

```bash
# メトリクス確認（CLI）
az monitor metrics list \
  --resource $TM_PROFILE_ID \
  --metric "QpsByEndpoint" \
  --start-time 2025-10-17T00:00:00Z \
  --end-time 2025-10-17T23:59:59Z
```

**主要なメトリクス:**

- **QpsByEndpoint**: エンドポイントごとのクエリ数
- **ProbeAgentCurrentEndpointStateBy
  ProfileResourceId**: エンドポイントの状態
- **BytesByEndpoint**: エンドポイントごとのバイト数

</div>

<div>

### アラートの設定 - Portal

1. **Traffic Manager プロファイルを開く**
2. **左メニュー「アラート」をクリック**
3. **「+ 新しいアラート ルール」をクリック**

**アラート条件例:**

- エンドポイント劣化
- クエリ数の急増
- すべてのエンドポイントがダウン

**アクション:**

- メール通知
- Webhook
- Logic Apps 連携

</div>

</div>

---

## STEP 2-19: TTL の最適化

Traffic Manager の TTL 設定を最適化します。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">

<div>

### TTL の影響

**短い TTL（例: 30 秒）**

✅ **メリット:**

- 障害時の切り替えが早い
- エンドポイント変更が早く反映

❌ **デメリット:**

- DNS クエリ数が増加
- Traffic Manager への負荷増加

**長い TTL（例: 3600 秒）**

✅ **メリット:**

- DNS クエリ数が減少
- キャッシュ効率が良い

❌ **デメリット:**

- 障害時の切り替えに時間がかかる
- エンドポイント変更の反映が遅い

</div>

<div>

### 推奨設定

| ユースケース             | TTL        | 理由                   |
| ------------------------ | ---------- | ---------------------- |
| 本番環境（高可用性重視） | 30-60 秒   | 素早いフェイルオーバー |
| 本番環境（コスト重視）   | 300-600 秒 | クエリ数削減           |
| 開発環境                 | 30 秒      | 変更を素早く反映       |
| メンテナンス前           | 30 秒      | 切り替えを迅速に       |

### TTL 変更

```bash
# TTLを60秒に設定
az network traffic-manager profile update \
  --resource-group $RESOURCE_GROUP\
  --name $TM_NAME \
  --ttl 60
```

</div>

</div>

---

## STEP 2-20: Traffic Manager のベストプラクティス

<div class="grid grid-cols-2 gap-6 text-xs">
<div>

### 設計原則

**1. ルーティング方式の選択**

- グローバル展開 → Performance
- DR 構成 → Priority
- 段階的ロールアウト → Weighted
- 地域要件 → Geographic

**2. ヘルスチェックの設計**

- 専用の `/health` エンドポイント実装
- アプリケーションの健全性を正しく反映
- タイムアウト値の適切な設定

**3. TTL の最適化**

- 可用性要件に応じた設定
- コストとパフォーマンスのバランス

**4. エンドポイントの冗長性**

- 最低 2 つ以上のエンドポイント
- 異なるリージョンに配置

</div>

<div>

### 運用ルール

**1. 監視とアラート**

- エンドポイント状態の監視
- クエリ数の異常検知
- 自動アラート設定

**2. ディザスタリカバリ**

- Priority 方式で DR 構成
- 定期的なフェイルオーバーテスト
- 復旧手順のドキュメント化

**3. テスト**

- 本番環境への影響を避けたテスト
- カナリアリリースの活用
- 段階的なロールアウト

**4. ドキュメント化**

- ルーティングポリシーの記録
- エンドポイント構成の管理

**5. Infrastructure as Code**

- ARM、Terraform で管理

</div>
</div>

---

## STEP 2-21: Traffic Manager のトラブルシューティング

問題発生時の診断手順です。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">
<div>

**1. エンドポイントの状態確認**

```bash
# エンドポイント状態確認
az network traffic-manager endpoint list \
  --resource-group $RESOURCE_GROUP\
  --profile-name $TM_NAME \
  --query "[].{Name:name, Status:endpointStatus, Monitor:endpointMonitorStatus}" \
  --output table
```

**2. ヘルスチェックの確認**

- エンドポイントが HTTP 200 を返しているか
- ヘルスチェックパスが正しいか
- ファイアウォール・NSG で許可されているか

</div>
<div>

**3. DNS 解決の確認**

```bash
# Traffic ManagerのDNS応答確認
dig $TM_NAME.trafficmanager.net

# TTL確認
dig $TM_NAME.trafficmanager.net +noall +answer
```

**4. クライアント側のキャッシュ**

- クライアント側の DNS キャッシュクリア
- ブラウザの DNS キャッシュクリア

**5. ルーティングポリシーの確認**

- 期待通りのエンドポイントが返されているか
- ルーティング方式が正しく設定されているか

</div>
</div>

---

## ハンズオン ② のまとめ

Traffic Manager の設定と運用を学びました。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">
<div>

### ✅ 達成したこと

- ✅ Traffic Manager プロファイルの作成
- ✅ 複数エンドポイントの追加
- ✅ 4 つのルーティング方式の理解
- ✅ ヘルスチェックの設定
- ✅ フェイルオーバーの動作確認
- ✅ カスタムドメインとの統合（オプション）
- ✅ 監視とアラートの設定

</div>

<div>

### 🔑 重要なポイント

- **DNS ベース**: プロキシではなく DNS 応答
- **4 つの方式**: Performance、Priority、Weighted、Geographic
- **ヘルスチェック**: 自動障害検知
- **TTL**: フェイルオーバー速度に影響
- **グローバル**: 複数リージョン対応
- **Nested**: 階層的な構成が可能
- **コスト効率**: DNS クエリベースの課金

</div>

</div>

---

## 🧠 理解度チェック ⑤ - 質問

ハンズオン ② の内容を理解できたか確認しましょう。

<div class="pt-4">

### 質問

1. **Traffic Manager は何レイヤーで動作し、どのような仕組みでトラフィックを分散しますか？**

2. **Performance、Priority、Weighted、Geographic の 4 つのルーティング方式のうち、ディザスタリカバリに最適なのはどれですか？**

3. **Traffic Manager のヘルスチェックがエンドポイントを OFFLINE と判定する条件は？**

4. **Traffic Manager の TTL を短くすることのメリットとデメリットは何ですか？**

5. **Nested Endpoints を使うメリットは何ですか？**

</div>

---

## 🧠 理解度チェック ⑤ - 回答

1. **Traffic Manager は何レイヤーで動作し、どのような仕組みでトラフィックを分散しますか？**

   - **Layer 7（アプリケーション層）で動作**する DNS ベースの負荷分散サービス。
   - プロキシではなく、DNS クエリに対してエンドポイントの IP アドレスを返す。
   - クライアントは返された IP アドレスに直接接続する。

2. **Performance、Priority、Weighted、Geographic の 4 つのルーティング方式のうち、ディザスタリカバリに最適なのはどれですか？**

   - **Priority（優先順位）方式**が最適。
   - プライマリ（優先順位 1）とセカンダリ（優先順位 2）を設定し、プライマリ障害時に自動的にセカンダリにフェイルオーバー。

3. **Traffic Manager のヘルスチェックがエンドポイントを OFFLINE と判定する条件は？**

   - **連続して 3 回**ヘルスチェックに失敗した場合（デフォルト設定）。
   - HTTP 200 OK 以外の応答、またはタイムアウト（デフォルト 10 秒）が続くと OFFLINE 判定。

4. **Traffic Manager の TTL を短くすることのメリットとデメリットは何ですか？**

   - **メリット**: 障害時の切り替えが早い、エンドポイント変更が早く反映される。
   - **デメリット**: DNS クエリ数が増加し、Traffic Manager への負荷とコストが増える。

5. **Nested Endpoints を使うメリットは何ですか？**
   - **階層的な構成**により、複雑なルーティングポリシーを実現できる。
   - 例：外側で Geographic 方式、内側で Weighted 方式を組み合わせることで、地域ごとに異なる負荷分散戦略を適用可能。

---

## 全体の振り返り

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

**ハンズオン ①：VNet と VM**

- VNet の設計と CIDR 範囲の理解
- サブネット分割の実践
- VM のネットワーク設定
- パブリック IP とプライベート IP の使い分け

**ハンズオン ②：VNet Peering**

- VNet 間の接続設定
- Peering の非推移性の理解
- ハブ&スポーク トポロジ
- Global VNet Peering

**ハンズオン ③：NSG**

- セキュリティルールの設計と実装
- 優先順位とルール評価の理解
- サービスタグと ASG の活用
- NSG フローログと監視

</div>

<div>

**ハンズオン ④：Azure DNS**

- パブリック/プライベート DNS ゾーン
- 各種 DNS レコードの管理
- Alias レコードの活用
- Split-horizon DNS

**ハンズオン ②：Traffic Manager**

- グローバルトラフィック分散
- 4 つのルーティング方式
- ヘルスチェックとフェイルオーバー
- カスタムドメイン統合（オプション）

**共通スキル**

- Azure Portal と Azure CLI の両方での操作
- Infrastructure as Code の考え方
- トラブルシューティング手法
- ベストプラクティスの理解

</div>
</div>

---

## Azure Network サービスの全体像

学んだサービスがどう連携するかを理解しましょう。

<div class="text-sm">

```markdown
                    [インターネット]
                           ↓
                  [Traffic Manager]
                   (グローバル負荷分散)
                           ↓
                    [Azure DNS]
                 (名前解決・カスタムドメイン)
                           ↓
              [Application Gateway / Load Balancer]
                    (リージョン内負荷分散)
                           ↓
         ┌─────────────────┴─────────────────┐
         ↓                                   ↓
    [VNet-01]                            [VNet-02]

Hub Network Spoke Network
↓ ↓
[Azure Firewall] [VNet Peering]
(集中セキュリティ) ↓
↓ [Subnet + NSG]
[VPN Gateway] (セグメンテーション)
(オンプレ接続) ↓
[VM / App]
(アプリケーション)
```

</div>

---

## 重要な概念の復習 ①

<div class="grid grid-cols-2 gap-6 text-xs">
<div>

### ネットワーク設計

**CIDR と IP アドレス範囲**

- `/16` = 65,536 IP
- `/24` = 256 IP
- VNet 間で重複しないように設計

**サブネット分割**

- 用途別にセグメント化
- パブリック、プライベート層
- 将来の拡張を考慮

**VNet Peering**

- 低レイテンシ、高帯域幅
- 非推移性の理解が重要
- ハブ&スポークトポロジの活用

</div>

<div>

### セキュリティ

**NSG（Network Security Group）**

- ステートフルファイアウォール
- サブネットレベル、NIC レベル
- 優先順位とルール評価
- サービスタグと ASG の活用

**最小権限の原則**

- 必要最小限のポートのみ開放
- ソース IP の絞り込み
- デフォルト拒否、明示的許可

**多層防御**

- NSG + Azure Firewall
- Application Gateway (WAF)
- DDoS Protection

</div>
</div>

---

## 重要な概念の復習 ②

<div class="grid grid-cols-2 gap-6 pt-4 text-xs">

<div>

### DNS とトラフィック管理

**Azure DNS**

- パブリック：インターネット公開
- プライベート：VNet 内のみ
- 168.63.129.16: Azure DNS リゾルバー

**Traffic Manager**

- DNS ベースの負荷分散
- 4 つのルーティング方式
- ヘルスチェックと自動フェイルオーバー

**TTL の重要性**

- 短い: 変更が早く反映、クエリ増加
- 長い: キャッシュ効率、変更遅延

</div>

<div>

### 運用とベストプラクティス

**Infrastructure as Code**

- ARM Template、Terraform、Bicep
- バージョン管理とレビュー
- 再現可能な環境構築

**監視とトラブルシューティング**

- NSG フローログ
- Traffic Analytics
- Azure Monitor と Log Analytics

**コスト最適化**

- 不要なリソースの削除
- 適切な SKU 選択
- リザーブドインスタンスの活用

**命名規則とタグ**

- 一貫した命名体系
- 環境、所有者、コストセンターのタグ

</div>
</div>
