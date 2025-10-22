---
layout: center
---

# 📛 ハンズオン ①

Azure DNS - DNS ゾーンとレコード管理

---

## ハンズオン ① の概要

このハンズオンでは、Azure DNS を使って DNS ゾーンを作成し、各種レコードを管理します。

<div class="pt-6">

### 🎯 学習目標

- Azure DNS の仕組みとゾーンタイプを理解する
- パブリック DNS ゾーンの作成と管理を習得する
- A、CNAME、Alias レコードの使い分けを学ぶ
- プライベート DNS ゾーンで VNet 内名前解決を実践する
- DNS レコードの TTL と伝搬を理解する

### 📋 実施内容

1. **パブリック DNS ゾーンの作成** - ドメインの DNS ホスティング
2. **各種レコードの追加** - A、CNAME、TXT、MX レコード
3. **Alias レコードの活用** - Azure リソースとの DNS 統合
4. **プライベート DNS ゾーン** - VNet 内のプライベート名前解決
5. **DNS 解決の確認** - nslookup、dig での動作確認

</div>

---

## STEP 1-1: Azure DNS の基礎知識

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">
<div>

### Azure DNS とは

- **Azure インフラを使用した DNS ホスティング**
- Microsoft Azure のネームサーバーで動作
- 高可用性（99.99% SLA）

### 2 つの DNS ゾーンタイプ

**パブリック DNS ゾーン**

- インターネットからアクセス可能
- ドメインレジストラと統合
- カスタムドメインのホスティング

**プライベート DNS ゾーン**

- VNet 内でのみ解決可能
- 内部サービスの名前解決
- Split-horizon DNS 対応

</div>

<div>

### 主要なレコードタイプ

| タイプ    | 用途                   |
| --------- | ---------------------- |
| A         | IPv4 アドレス          |
| AAAA      | IPv6 アドレス          |
| CNAME     | 別名（エイリアス）     |
| MX        | メールサーバー         |
| TXT       | テキスト情報           |
| SRV       | サービスロケーション   |
| NS        | ネームサーバー         |
| **Alias** | Azure リソースへの参照 |

### Alias レコードの特徴

- ✅ IP アドレス変更に自動追従
- ✅ ゾーン APEX（@）で使用可能
- ✅ パブリック IP や Traffic Manager に対応

</div>

</div>

---

## STEP 1-2: パブリック DNS ゾーンの作成 - Portal

パブリック DNS ゾーンを作成します。

1. **DNS ゾーンの作成開始**

   - Azure Portal で「DNS ゾーン」を検索
   - 「+ 作成」をクリック

2. **基本設定**

   - **サブスクリプション**: 使用中のサブスクリプション
   - **リソース グループ**: `rg-dns-handson`（新規作成）
   - **名前**: `example-handson.com`（仮のドメイン名）
   - **リソース グループの場所**: `Japan East`

3. **作成**
   - 「確認および作成」→「作成」をクリック

<div class="mt-4 bg-yellow-500/10 p-3 rounded text-sm">
⚠️ 実際に所有しているドメインがある場合はそのドメイン名を使用してください。このハンズオンでは仮のドメインで演習します。
</div>

---

## STEP 1-3: DNS ゾーン作成（CLI 版）

コマンドラインで DNS ゾーンを作成します。

```bash
# リソースグループ作成
RESOURCE_GROUP="rg-dns-handson"
LOCATION="japaneast"

az group create \
  --name $RESOURCE_GROUP \
  --location $LOCATION

# パブリックDNSゾーンの作成
az network dns zone create \
  --resource-group $RESOURCE_GROUP \
  --name example-handson.com

# 作成確認
az network dns zone show \
  --resource-group $RESOURCE_GROUP \
  --name example-handson.com \
  --query "{Name:name, NameServers:nameServers}" \
  --output json
```

#### ネームサーバーの確認

作成後、4 つの Azure DNS ネームサーバーが割り当てられます：

```
ns1-xx.azure-dns.com
ns2-xx.azure-dns.net
ns3-xx.azure-dns.org
ns4-xx.azure-dns.info
```

<div class="mt-4 bg-blue-500/10 p-3 rounded text-sm">
💡 実際のドメインを使用する場合、ドメインレジストラでこれらのネームサーバーを設定します。
</div>

---

## STEP 1-4: A レコードの追加 - Portal

VM のパブリック IP に対する A レコードを作成します。

#### サンプル IP アドレスの準備

```bash
# 実際のVMやApp ServiceのパブリックIPを使用
# ここではサンプルIPを使用
FRONTEND_IP="20.210.123.45"  # 実際のIPアドレスに置き換えてください

echo "Frontend IP: $FRONTEND_IP"
```

<div class="mt-2 bg-blue-500/10 p-3 rounded text-sm">
💡 実際のAzureリソース（VM、App Service、Storageなど）のパブリックIPアドレスを使用してください。
</div>

#### A レコード作成

1. **DNS ゾーンを開く**

   - `example-handson.com` を開く

2. **レコードセットの追加**
   - 「+ レコード セット」をクリック
   - **名前**: `www`
   - **種類**: A
   - **TTL**: 3600
   - **IP アドレス**: `<frontend-vm-public-ip>`
   - 「OK」をクリック

---

## STEP 1-5: A レコード作成（CLI 版）

コマンドラインで A レコードを作成します。

```bash
# サンプルIPアドレス（実際のリソースのIPに置き換えてください）
FRONTEND_IP="20.210.123.45"

# Aレコード作成（www）
az network dns record-set a add-record \
  --resource-group $RESOURCE_GROUP \
  --zone-name example-handson.com \
  --record-set-name www \
  --ipv4-address $FRONTEND_IP

# Aレコード作成（@: ゾーンAPEX）
az network dns record-set a add-record \
  --resource-group $RESOURCE_GROUP \
  --zone-name example-handson.com \
  --record-set-name @ \
  --ipv4-address $FRONTEND_IP

# レコード確認
az network dns record-set a list \
  --resource-group $RESOURCE_GROUP \
  --zone-name example-handson.com \
  --output table
```

---

## STEP 1-6: CNAME レコードの追加

別名（エイリアス）を設定します。

```bash
# CNAMEレコード作成（blog → www）
az network dns record-set cname set-record \
  --resource-group $RESOURCE_GROUP \
  --zone-name example-handson.com \
  --record-set-name blog \
  --cname www.example-handson.com

# CNAMEレコード作成（shop → www）
az network dns record-set cname set-record \
  --resource-group $RESOURCE_GROUP \
  --zone-name example-handson.com \
  --record-set-name shop \
  --cname www.example-handson.com

# CNAMEレコード確認
az network dns record-set cname list \
  --resource-group $RESOURCE_GROUP \
  --zone-name example-handson.com \
  --output table
```

<div class="mt-4 bg-blue-500/10 p-3 rounded text-sm">
💡 CNAMEはゾーンAPEX（@）には設定できません。APEXにはAレコードまたはAliasレコードを使用します。
</div>

---

## STEP 1-7: TXT レコードの追加

テキスト情報を格納する TXT レコードを作成します。

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

### TXT レコードのユースケース

- **ドメイン所有権の証明**（Google Search Console、Microsoft 365 等）
- **SPF レコード**（メール送信元認証）
- **DKIM レコード**（メール署名検証）
- **サイト検証**（各種サービス連携）
</div>
<div>

### TXT レコード作成

```bash
# TXTレコード作成（ドメイン検証用）
az network dns record-set txt add-record \
  --resource-group $RESOURCE_GROUP \
  --zone-name example-handson.com \
  --record-set-name @ \
  --value "v=spf1 include:_spf.google.com ~all"

# TXTレコード作成（サブドメイン検証用）
az network dns record-set txt add-record \
  --resource-group $RESOURCE_GROUP \
  --zone-name example-handson.com \
  --record-set-name _verification \
  --value "verification-token-12345"

# TXTレコード確認
az network dns record-set txt list \
  --resource-group $RESOURCE_GROUP \
  --zone-name example-handson.com \
  --output table
```

</div>
</div>

---

## STEP 1-8: Alias レコードの作成

Azure リソースへの Alias レコードを作成します。

<div class="grid grid-cols-2 gap-6 text-sm">

<div>

### Alias レコードとは

- Azure リソースの IP アドレスに**自動追従**
- リソース削除時に自動でレコード削除
- ゾーン APEX（@）でも使用可能

### サポートされるリソース

- パブリック IP アドレス
- Traffic Manager プロファイル
- Azure CDN エンドポイント

### 従来の A レコードとの違い

**A レコード**

- 固定 IP アドレスを指定
- IP 変更時に手動更新が必要

**Alias レコード**

- リソース ID を指定
- IP 変更に自動追従

</div>

<div>

### Alias 作成（CLI）

```bash
# パブリックIPリソースのIDを取得
# （事前に作成したパブリックIPリソースを使用）
PUBLIC_IP_NAME="my-public-ip"  # 実際のパブリックIP名に置き換え

PUBLIC_IP_ID=$(az network public-ip show \
  --resource-group $RESOURCE_GROUP \
  --name $PUBLIC_IP_NAME \
  --query id -o tsv)

# Aliasレコード作成
az network dns record-set a create \
  --resource-group $RESOURCE_GROUP \
  --zone-name example-handson.com \
  --name app \
  --target-resource $PUBLIC_IP_ID

# Aliasレコード確認
az network dns record-set a show \
  --resource-group $RESOURCE_GROUP \
  --zone-name example-handson.com \
  --name app \
  --query "{Name:name, Target:targetResource.id}" \
  --output table
```

<div class="mt-2 bg-yellow-500/10 p-3 rounded text-sm">
⚠️ Aliasレコードを使用するには、事前にパブリックIPリソースが必要です。既存のリソースを使用するか、新規作成してください。
</div>

</div>

</div>

---

## STEP 1-9: TTL（Time To Live）の理解

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

### TTL とは

- **キャッシュの有効期限**（秒単位）
- DNS リゾルバーがレコードをキャッシュする時間
- 短い TTL = 頻繁な問い合わせ = 変更が早く反映
- 長い TTL = 問い合わせ減少 = コスト削減

### 推奨値

| 用途             | TTL              | 理由             |
| ---------------- | ---------------- | ---------------- |
| 本番環境（安定） | 86400（24 時間） | キャッシュ効率   |
| 開発環境         | 300（5 分）      | 変更を素早く反映 |
| メンテナンス前   | 60（1 分）       | 切り替えを迅速に |
| CDN              | 3600（1 時間）   | バランス型       |

</div>
<div>

### TTL 変更

```bash
# 既存レコードのTTL変更
az network dns record-set a update \
  --resource-group $RESOURCE_GROUP \
  --zone-name example-handson.com \
  --name www \
  --set ttl=300

# TTL確認
az network dns record-set a show \
  --resource-group $RESOURCE_GROUP \
  --zone-name example-handson.com \
  --name www \
  --query "{Name:name, TTL:ttl}" \
  --output table
```

</div>
</div>

### 変更時の注意点

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

⚠️ **TTL 変更の反映タイミング**

- 短くする: 次回キャッシュ更新時（既存 TTL 経過後）
- 長くする: すぐに反映
</div>
<div>

💡 **ベストプラクティス:**

1. 変更 24 時間前に TTL を短く設定（例: 300 秒）
2. 変更を実施
3. 変更確認後、TTL を元に戻す
</div>
</div>

---

## STEP 1-10: DNS 解決の確認

作成した DNS レコードを確認します。

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

#### nslookup での確認

```bash
# Aレコードの確認
nslookup www.example-handson.com ns1-xx.azure-dns.com

# CNAMEレコードの確認
nslookup blog.example-handson.com ns1-xx.azure-dns.com

# TXTレコードの確認
nslookup -type=TXT example-handson.com ns1-xx.azure-dns.com
```

</div>
<div>

#### dig での確認（詳細）

```bash
# Aレコードの確認（詳細）
dig @ns1-xx.azure-dns.com www.example-handson.com A

# すべてのレコードタイプ確認
dig @ns1-xx.azure-dns.com example-handson.com ANY

# TTL確認
dig @ns1-xx.azure-dns.com www.example-handson.com +noall +answer
```

</div>
</div>

<div class="mt-4 bg-yellow-500/10 p-3 rounded text-sm">
⚠️ 実際のドメインを使用していない場合、Azureのネームサーバーを明示的に指定する必要があります。
</div>

---

## STEP 1-11: プライベート DNS ゾーンの作成

VNet 内でのみ解決可能なプライベート DNS ゾーンを作成します。

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

### プライベート DNS ゾーン作成

```bash
# プライベートDNSゾーン作成
az network private-dns zone create \
  --resource-group $RESOURCE_GROUP \
  --name internal.contoso.com

# 作成確認
az network private-dns zone show \
  --resource-group $RESOURCE_GROUP \
  --name internal.contoso.com \
  --query "{Name:name, NumberOfRecordSets:numberOfRecordSets}" \
  --output table
```

</div>
<div>

### VNet とのリンク作成

```bash
# 既存のVNetとリンク（実際のVNet名に置き換えてください）
VNET_NAME="my-vnet"  # 実際のVNet名

az network private-dns link vnet create \
  --resource-group $RESOURCE_GROUP \
  --zone-name internal.contoso.com \
  --name link-myvnet \
  --virtual-network $VNET_NAME \
  --registration-enabled true
```

<div class="mt-2 bg-blue-500/10 p-3 rounded text-sm">
💡 プライベートDNSゾーンを使用するには、VNetが必要です。既存のVNetを使用するか、新規作成してください。
</div>

</div>
</div>

---

## STEP 1-12: プライベート DNS レコードの追加

プライベートゾーンにレコードを追加します。

### A レコード作成（内部 IP）

```bash
# サンプルのプライベートIPアドレス（実際のVMやリソースのIPに置き換えてください）
FRONTEND_PRIVATE_IP="10.0.1.4"
BACKEND_PRIVATE_IP="10.0.2.4"

# プライベートAレコード作成
az network private-dns record-set a add-record \
  --resource-group $RESOURCE_GROUP \
  --zone-name internal.contoso.com \
  --record-set-name frontend \
  --ipv4-address $FRONTEND_PRIVATE_IP

az network private-dns record-set a add-record \
  --resource-group $RESOURCE_GROUP \
  --zone-name internal.contoso.com \
  --record-set-name backend \
  --ipv4-address $BACKEND_PRIVATE_IP

# レコード確認
az network private-dns record-set a list \
  --resource-group $RESOURCE_GROUP \
  --zone-name internal.contoso.com \
  --output table
```

<div class="mt-2 bg-blue-500/10 p-3 rounded text-sm">
💡 実際のVMやリソースのプライベートIPアドレスを使用してください。
</div>

---

## STEP 1-13: プライベート DNS の動作確認

VNet 内の VM からプライベート DNS を確認します。

```bash
# VNet内のVMにSSH接続
ssh <username>@<vm-public-ip>

# プライベートDNSの解決確認
nslookup frontend.internal.contoso.com
nslookup backend.internal.contoso.com

# 期待される結果:
# Server:    168.63.129.16
# Address:   168.63.129.16#53
#
# Name:      frontend.internal.contoso.com
# Address:   10.0.1.4

# digでの確認
dig frontend.internal.contoso.com

# pingでの確認
ping -c 4 backend.internal.contoso.com
```

<div class="mt-2 bg-yellow-500/10 p-3 rounded text-sm">
⚠️ プライベートDNSの動作確認には、リンクされたVNet内にVMが必要です。
</div>

<div class="mt-4 bg-green-500/10 p-3 rounded text-sm">
✅ プライベートDNSにより、IPアドレスではなくホスト名で通信できます！
</div>

---

## STEP 1-14: 自動登録機能

VNet リンクの自動登録機能を確認します。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">

<div>

### 自動登録とは

- `--registration-enabled true` で有効化
- VNet 内の VM が自動的に DNS レコード登録
- VM 削除時に自動でレコード削除

### 確認方法

```bash
# 自動登録されたレコード確認
az network private-dns record-set a list \
  --resource-group $RESOURCE_GROUP \
  --zone-name internal.contoso.com \
  --output table
```

VM 名がレコードとして自動登録されています：

- `vm-frontend.internal.contoso.com`
- `vm-backend.internal.contoso.com`

</div>

<div>

### CNAME レコードの追加

プライベートゾーンでも CNAME が使えます：

```bash
# プライベートCNAME作成
az network private-dns record-set cname set-record \
  --resource-group $RESOURCE_GROUP \
  --zone-name internal.contoso.com \
  --record-set-name web \
  --cname frontend.internal.contoso.com

# 確認
nslookup web.internal.contoso.com
```

### ユースケース

- サービスの論理名と物理 VM の分離
- ロードバランサーへのエイリアス
- アプリケーション層の抽象化

</div>

</div>

---

## STEP 1-15: Split-horizon DNS

パブリックとプライベートで異なる IP を返す Split-horizon DNS について。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">

<div>

### Split-horizon DNS とは

同じドメイン名に対して：

- **外部からのアクセス**: パブリック IP を返す
- **VNet 内からのアクセス**: プライベート IP を返す

### メリット

✅ 外部/内部で同じ URL を使用可能
✅ 内部通信はプライベート IP で高速
✅ セキュリティの向上

### 実装方法

1. パブリック DNS ゾーン作成

   - 外部向けレコード（パブリック IP）

2. プライベート DNS ゾーン作成

   - 同じドメイン名
   - 内部向けレコード（プライベート IP）

3. VNet とリンク
   - プライベートゾーンが優先される

</div>

<div>

### 設定例

**パブリックゾーン（example.com）:**

```
www.example.com → 20.xxx.xxx.xxx (パブリックIP)
```

**プライベートゾーン（example.com）:**

```
www.example.com → 10.1.1.4 (プライベートIP)
```

### 動作

**インターネットから:**

```bash
# パブリックIPを解決
nslookup www.example.com
# → 20.xxx.xxx.xxx
```

**VNet 内の VM から:**

```bash
# プライベートIPを解決
nslookup www.example.com
# → 10.1.1.4
```

</div>

</div>

---

## STEP 1-16: DNS フォワーディング（参考）

<div class="text-sm">

#### シナリオ

- オンプレミスから Azure VNet 内のリソースを名前解決したい
- Azure VNet からオンプレミスのリソースを名前解決したい

#### 構成

```
オンプレミス DNS ←→ Azure DNS Private Resolver ←→ Azure Private DNS
                      (フォワーダーVM)
```

**1. Azure 側に DNS フォワーダー VM を配置**

```bash
# Unboundなどの軽量DNSサーバーをインストール
sudo apt install -y unbound
```

**2. 条件付きフォワーディング設定**

- Azure 側: `internal.contoso.com` → 168.63.129.16
- オンプレ側: `corp.local` → オンプレ DNS サーバー

**3. NSG で DNS ポート（53）を許可**

</div>

<div class="mt-4 bg-blue-500/10 p-3 rounded text-sm">
💡 2022年以降、**Azure DNS Private Resolver** というマネージドサービスが利用可能です。DNSフォワーダーVMの代替として推奨されます。
</div>

---

## STEP 1-17: DNS 診断ツールの活用

DNS の問題をトラブルシューティングするツールです。

<div class="grid grid-cols-2 gap-6 text-sm">

<div>

### nslookup

基本的な DNS クエリツール

```bash
# 標準クエリ
nslookup www.example.com

# 特定のネームサーバー指定
nslookup www.example.com 8.8.8.8

# レコードタイプ指定
nslookup -type=MX example.com
nslookup -type=TXT example.com
nslookup -type=NS example.com
```

### dig

より詳細な情報を取得

```bash
# 詳細クエリ
dig www.example.com

# ショート出力
dig www.example.com +short

# トレース（権威サーバーまで追跡）
dig www.example.com +trace

# 逆引き
dig -x 20.89.123.456
```

</div>

<div>

### host

シンプルな DNS 照会

```bash
# Aレコード
host www.example.com

# すべてのレコード
host -a www.example.com

# 逆引き
host 20.89.123.456
```

### Azure CLI

```bash
# DNSゾーン一覧
az network dns zone list \
  --output table

# レコード一覧
az network dns record-set list \
  --resource-group $RESOURCE_GROUP \
  --zone-name example-handson.com \
  --output table

# 特定レコードの詳細
az network dns record-set a show \
  --resource-group $RESOURCE_GROUP \
  --zone-name example-handson.com \
  --name www
```

</div>

</div>

---

## STEP 1-18: DNS トラブルシューティング

<div class="grid grid-cols-2 gap-6 text-xs">
<div>

**ネームサーバーの確認**

```bash
# ドメインのNSレコード確認
dig example-handson.com NS +short

# Azure DNSのネームサーバーが返ってくるか確認
```

**2. レコードの存在確認**

```bash
# Azure DNSに直接クエリ
dig @ns1-xx.azure-dns.com www.example-handson.com

# レコードが存在するか確認
```

**3. TTL とキャッシュの確認**

```bash
# TTL確認
dig www.example-handson.com +noall +answer

# キャッシュクリア（ローカル）
# macOS/Linux
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder

# Windows
ipconfig /flushdns
```

</div>
<div>

**4. VNet リンクの確認（プライベート DNS）**

```bash
# VNetリンク確認
az network private-dns link vnet list \
  --resource-group $RESOURCE_GROUP \
  --zone-name internal.contoso.com \
  --output table
```

**5. VM 内の DNS 設定確認**

```bash
# DNS設定確認
cat /etc/resolv.conf

# 168.63.129.16 が設定されているか確認
```

</div>
</div>

---

## STEP 1-19: Azure DNS のベストプラクティス

<div class="grid grid-cols-2 gap-6 text-xs">

<div>

### 設計原則

**1. ゾーンの分離**

- 環境ごとにゾーン分割（prod、dev）
- セキュリティドメインごとに分割

**2. 命名規則**

- 一貫性のある命名体系
- 環境識別子の使用（例：`prod-`, `dev-`）

**3. TTL 設定**

- 本番環境: 長い TTL（3600-86400）
- 開発環境: 短い TTL（300-600）
- 変更前: TTL を短く設定

**4. Alias レコードの活用**

- 可能な限り Alias レコードを使用
- IP アドレス管理の負担軽減

</div>

<div>

### 運用ルール

**1. 監視とアラート**

- DNS クエリの監視
- レコード変更の監視
- 異常なクエリパターンの検知

**2. バックアップと履歴**

- レコード変更前にエクスポート
- Infrastructure as Code で管理

**3. セキュリティ**

- プライベート DNS で内部リソース保護
- 不要なレコードは削除
- DNSSEC 対応（将来）

**4. ドキュメント化**

- レコードの用途を記録
- 変更履歴の管理
- 責任者の明確化

**5. テスト**

- レコード変更前にテスト環境で検証
- 複数 DNS リゾルバーで確認

</div>

</div>

---

## ハンズオン ④ のまとめ

Azure DNS の設定と運用を学びました。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">

<div>

### ✅ 達成したこと

- ✅ パブリック DNS ゾーンの作成
- ✅ 各種レコード（A、CNAME、TXT）の追加
- ✅ Alias レコードの活用
- ✅ プライベート DNS ゾーンの作成
- ✅ VNet とのリンク設定
- ✅ 自動登録機能の確認
- ✅ DNS 解決の動作確認

</div>

<div>

### 🔑 重要なポイント

- **2 つのゾーンタイプ**: パブリックとプライベート
- **Alias レコード**: Azure リソースに自動追従
- **TTL**: キャッシュ期間の適切な設定
- **自動登録**: VM の自動 DNS 登録
- **Split-horizon**: 内外で異なる IP を返す
- **168.63.129.16**: Azure の DNS リゾルバー
- **プライベート DNS**: VNet 内のみで解決

</div>
</div>

---

## 🧠 理解度チェック ④ - 質問

ハンズオン ④ の内容を理解できたか確認しましょう。

<div class="pt-4">

1. **パブリック DNS ゾーンとプライベート DNS ゾーンの違いは何ですか？**

2. **Alias レコードと通常の A レコードの違いは何ですか？**

3. **TTL（Time To Live）とは何ですか？なぜ重要ですか？**

4. **CNAME レコードをゾーン APEX（@）に設定できない理由は何ですか？**

5. **プライベート DNS ゾーンの自動登録機能とは何ですか？**

</div>

---

## 🧠 理解度チェック ④ - 回答

<div class="text-sm">

1. **パブリック DNS ゾーンとプライベート DNS ゾーンの違いは何ですか？**

   - **パブリック DNS ゾーン**: インターネットからアクセス可能。ドメインレジストラと統合してカスタムドメインをホスティング。
   - **プライベート DNS ゾーン**: VNet 内でのみ解決可能。内部サービスの名前解決に使用。外部からはアクセス不可。

2. **Alias レコードと通常の A レコードの違いは何ですか？**

   - **A レコード**: 固定の IP アドレスを指定。IP 変更時に手動更新が必要。
   - **Alias レコード**: Azure リソースの ID を指定。リソースの IP 変更に自動追従。ゾーン APEX でも使用可能。

3. **TTL（Time To Live）とは何ですか？なぜ重要ですか？**

   - DNS キャッシュの有効期限（秒単位）。DNS リゾルバーがレコードをキャッシュする時間。
   - **短い TTL**: 変更が早く反映されるが、DNS クエリが増加。
   - **長い TTL**: クエリ削減でコスト効率が良いが、変更反映に時間がかかる。

4. **CNAME レコードをゾーン APEX（@）に設定できない理由は何ですか？**

   - DNS 仕様（RFC）により、ゾーン APEX には NS レコードと SOA レコードが必須。
   - CNAME はそのドメインの他のレコードと共存できないため、A レコードまたは Alias レコードを使用。

5. **プライベート DNS ゾーンの自動登録機能とは何ですか？**
   - VNet リンク作成時に `--registration-enabled true` で有効化。
   - VNet 内の VM が自動的に DNS レコードとして登録される。
   - VM 削除時に自動でレコードも削除される。

</div>
