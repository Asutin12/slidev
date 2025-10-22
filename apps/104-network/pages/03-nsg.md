---
layout: center
---

# 🛡️ ハンズオン ③

ネットワークセキュリティの設定と制御

---

## ハンズオン ③ の概要

このハンズオンでは、NSG（Network Security Group）を使ってネットワークトラフィックを細かく制御します。

### 🎯 学習目標

- NSG の仕組みとルール評価順序を理解する
- サブネットレベルと NIC レベルの NSG 適用を習得する
- Inbound/Outbound ルールの作成と優先順位設定を学ぶ
- サービスタグとアプリケーションセキュリティグループの活用法を理解する
- NSG フローログによるトラフィック分析を実践する

### 📋 実施内容

1. **NSG の作成と基本ルール** - SSH、HTTP/HTTPS の制御
2. **サブネットへの NSG 適用** - サブネット全体のトラフィック制御
3. **優先順位とルール評価** - ルールの適用順序を理解
4. **サービスタグの活用** - Azure サービスへのアクセス制御
5. **NSG フローログ** - トラフィックの可視化と分析

---

## STEP 3-1: NSG の基礎知識

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

#### NSG とは

- **ステートフルファイアウォール**
- サブネットまたは NIC に適用

#### ルールの構成要素

- 優先順位: 100〜4096（小さいほど先に評価）
- 名前: ルールの識別名
- ソース: 送信元（IP、サービスタグ、ASG）
- 送信元ポート: ポート番号または範囲
- 宛先: 送信先（IP、サービスタグ、ASG）
- 宛先ポート: ポート番号または範囲
- プロトコル: TCP、UDP、ICMP、Any
- アクション: 許可 or 拒否
</div>
<div>

#### ルール評価の流れ

```
1. 優先順位の小さい順に評価
   ↓
2. 条件に一致？
   Yes → アクションを実行（終了）
   No → 次のルールへ
   ↓
3. すべてのルールに不一致
   ↓
4. デフォルトルール適用
```

#### デフォルトルール

**Inbound:**

- ✅ VNet 内通信: 許可
- ✅ Load Balancer: 許可
- ❌ その他すべて: 拒否

**Outbound:**

- ✅ VNet 内通信: 許可
- ✅ インターネット: 許可
- ❌ その他すべて: 拒否
</div>
</div>

---

## STEP 3-1A: NIC と NSG の違い

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

### NIC（Network Interface Card）とは

**ネットワークインターフェイスカード**

- VM とネットワークを**物理的に接続**するリソース
- VM ごとに 1 つ以上の NIC が必要
- IP アドレスを持つ
- ネットワークトラフィックの送受信を担当

**NIC が持つ情報**

- プライベート IP アドレス
- パブリック IP アドレス（オプション）
- 所属するサブネット
- 関連付けられた NSG（オプション）

**例** `vm-frontend-nic`、`vm-backend-nic`

</div>

<div>

### NSG（Network Security Group）とは

**ネットワークセキュリティグループ**

- ネットワークトラフィックを**制御するルール集**
- ファイアウォールのような役割
- 許可/拒否のルールを定義
- NIC またはサブネットに適用

**NSG が持つ情報**

- セキュリティルール（許可/拒否）
- 優先順位
- ポート番号
- プロトコル

**例** `nsg-subnet-frontend`、`vm-frontend-nsg`

</div>
</div>

---

## STEP 3-1A: NIC と NSG の違い

### 🔗 NIC と NSG の関係性

<div class="grid grid-cols-2 gap-6">
<div>

**比喩で理解する**

- **NIC** = 建物の入り口（ドア）
- **NSG** = 入り口に配置された警備員（セキュリティルール）

建物（VM）に入るには、入り口（NIC）を通る必要があり、警備員（NSG）がルールに基づいて通過を許可または拒否します。

</div>
<div>

**適用方法**

1. **NIC に NSG を適用**

   - 特定の VM だけを保護
   - `vm-frontend-nic` → `nsg-vm-frontend`

2. **サブネットに NSG を適用**
   - サブネット内のすべての VM を保護
   - `subnet-frontend` → `nsg-subnet-frontend`

</div>
</div>
<div class="bg-purple-500/10 p-4 rounded text-sm">

**重要:** NIC は「接続」、NSG は「制御」を担当する別々のリソースです。

</div>

---

## STEP 3-2: 現在の NSG 状態確認 - Portal

1. **vm-frontend の NSG 確認**

   - `vm-frontend` を開く
   - 左メニュー「ネットワーク」をクリック
   - 「ネットワーク設定」セクションで NSG を確認

2. **NSG 詳細を開く**
   - NSG 名（例: `vm-frontend-nsg`）をクリック
   - 「受信セキュリティ規則」を確認

### 既存のルール

VM 作成時に SSH を許可したため、以下のルールがあるはずです：

| 優先度 | 名前                          | ポート | ソース            | アクション |
| ------ | ----------------------------- | ------ | ----------------- | ---------- |
| 300    | SSH                           | 22     | Any               | 許可       |
| 65000  | AllowVnetInBound              | Any    | VirtualNetwork    | 許可       |
| 65001  | AllowAzureLoadBalancerInBound | Any    | AzureLoadBalancer | 許可       |
| 65500  | DenyAllInBound                | Any    | Any               | 拒否       |

---

## STEP 3-3: 新しい NSG の作成 - Portal

独自の NSG を作成してルールを管理します。

1. **NSG 作成開始**

   - Azure Portal で「ネットワーク セキュリティ グループ」を検索
   - 「+ 作成」をクリック

2. **基本設定**

   - **サブスクリプション**: 使用中のサブスクリプション
   - **リソース グループ**: `rg-network-handson`
   - **名前**: `nsg-subnet-frontend`
   - **地域**: `Japan East`

3. **作成**

   - 「確認および作成」→「作成」をクリック

---

## STEP 3-4: NSG の作成（CLI 版）

コマンドラインで NSG を作成します。

```bash
# Frontend用NSG作成
az network nsg create \
  --resource-group $RESOURCE_GROUP \
  --name $FE_NSG_NAME \
  --location japaneast

# App用NSG作成
az network nsg create \
  --resource-group $RESOURCE_GROUP \
  --name $APP_NSG_NAME \
  --location japaneast

# 作成確認
az network nsg list \
  --resource-group $RESOURCE_GROUP \
  --query "[].{Name:name, Location:location}" \
  --output table
```

---

## STEP 3-5: Inbound ルールの追加（HTTP/HTTPS） - Portal

frontend サブネット用に Web トラフィックを許可するルールを追加します。

1. **NSG を開く**

   - `nsg-subnet-frontend` を開く

2. **受信セキュリティ規則を追加**

   - 左メニュー「受信セキュリティ規則」をクリック
   - 「+ 追加」をクリック

3. **HTTP ルール設定**
   - **ソース**: Any
   - **ソースポート範囲**: \*
   - **宛先**: Any
   - **サービス**: HTTP
   - **宛先ポート範囲**: 80（自動入力）
   - **プロトコル**: TCP
   - **アクション**: 許可
   - **優先度**: 100
   - **名前**: `AllowHTTP`
   - 「追加」をクリック

---

## STEP 3-6: 複数ポートの許可（HTTPS 追加） - Portal

HTTPS トラフィックも許可します。

1. **再度「+ 追加」をクリック**

2. **HTTPS ルール設定**
   - **ソース**: Any
   - **ソースポート範囲**: \*
   - **宛先**: Any
   - **サービス**: HTTPS
   - **宛先ポート範囲**: 443（自動入力）
   - **プロトコル**: TCP
   - **アクション**: 許可
   - **優先度**: 110
   - **名前**: `AllowHTTPS`
   - 「追加」をクリック

<div class="mt-4 bg-blue-500/10 p-3 rounded text-sm">
💡 優先度は100, 110のように間隔を空けると、後から間に挿入しやすくなります。
</div>

---

## STEP 3-7: ルール追加（CLI 版）

コマンドラインでルールを追加します。

```bash
# HTTPルール追加
az network nsg rule create \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $FE_NSG_NAME \
  --name AllowHTTP \
  --priority 100 \
  --source-address-prefixes '*' \
  --source-port-ranges '*' \
  --destination-address-prefixes '*' \
  --destination-port-ranges 80 \
  --access Allow \
  --protocol Tcp

# HTTPSルール追加
az network nsg rule create \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $FE_NSG_NAME \
  --name AllowHTTPS \
  --priority 110 \
  --source-address-prefixes '*' \
  --source-port-ranges '*' \
  --destination-address-prefixes '*' \
  --destination-port-ranges 80 \
  --access Allow \
  --protocol Tcp

# ルール確認
az network nsg rule list \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $FE_NSG_NAME \
  --query "[].{Name:name, Priority:priority, Port:destinationPortRange, Access:access}" \
  --output table
```

---

## STEP 3-8: サブネットへの NSG 適用 - Portal

作成した NSG をサブネットに適用します。

1. **VNet を開く**

   - `vnet-handson-01` を開く

2. **サブネットを開く**

   - 左メニュー「サブネット」をクリック
   - `subnet-frontend` をクリック

3. **NSG を関連付け**

   - **ネットワーク セキュリティ グループ**: `nsg-subnet-frontend` を選択
   - 「保存」をクリック

4. **他のサブネットにも適用**
   - `subnet-backend` に `nsg-subnet-backend`
   - VNet-02 の `subnet-app` に `nsg-subnet-app`

<div class="mt-4 bg-yellow-500/10 p-3 rounded text-sm">
⚠️ サブネットにNSGを適用すると、そのサブネット内のすべてのVMに影響します。
</div>

---

## STEP 3-9: サブネットへの NSG 適用（CLI 版）

コマンドラインで NSG をサブネットに関連付けます。

```bash
# Frontend サブネットにNSG適用
az network vnet subnet update \
  --resource-group $RESOURCE_GROUP \
  --vnet-name vnet-handson-01 \
  --name subnet-frontend \
  --network-security-group $FE_NSG_NAME

# Backend サブネットにNSG適用
az network vnet subnet update \
  --resource-group $RESOURCE_GROUP \
  --vnet-name vnet-handson-01 \
  --name subnet-backend \
  --network-security-group $BE_NSG_NAME

# App サブネットにNSG適用
az network vnet subnet update \
  --resource-group $RESOURCE_GROUP \
  --vnet-name vnet-handson-02 \
  --name subnet-app \
  --network-security-group $APP_NSG_NAME

# 適用確認
az network vnet subnet show \
  --resource-group $RESOURCE_GROUP \
  --vnet-name vnet-handson-01 \
  --name subnet-frontend \
  --query "{Name:name, NSG:networkSecurityGroup.id}" \
  --output table
```

---

<!-- TODO:backendとappにも変化があるなら確認したい -->

## STEP 3-9A: NSG 適用後の接続確認

NSG をサブネットに適用した後、基本的な接続を確認します。

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

### HTTP/HTTPS 接続の確認

```bash
# パブリックサブネットVMにSSH接続
ssh azureuser@<frontend-public-ip>

# 簡易Webサーバーを起動（テスト用）
sudo apt update
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# ローカルでの確認
curl http://localhost
```

</div>
<div>

### 外部からの HTTP 接続確認

```bash
# 別のターミナルから（ローカルマシン）
curl http://<frontend-public-ip>

# 期待される結果: Nginxのデフォルトページが表示される
```

<div class="mt-4 bg-green-500/10 p-3 rounded text-sm">
✅ HTTPポート（80）が許可されているため、外部からWebサーバーにアクセスできます。
</div>

### HTTPS 接続の確認

```bash
# HTTPS接続テスト
curl -k https://<frontend-public-ip>

# 期待される結果: HTTPSポート（443）も許可されているため接続可能
```

</div>
</div>

---

## STEP 3-10: 特定 IP からの SSH 許可

管理用に特定の IP アドレスからのみ SSH を許可するルールを作成します。

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

#### 自分のパブリック IP を確認

```bash
# 自分のパブリックIPを確認
curl ifconfig.me

# または
curl https://api.ipify.org
```

#### ルール作成（Portal）

1. `nsg-subnet-frontend` を開く
2. 「受信セキュリティ規則」→「+ 追加」
3. 設定：
   - **ソース**: IP Addresses
   - **ソース IP アドレス/CIDR 範囲**: `<your-ip>/32`
   - **宛先ポート範囲**: 22
   - **プロトコル**: TCP
   - **優先度**: 120
   - **名前**: `AllowSSH-MyIP`

</div>
<div>

#### ルール作成（CLI）

```bash
# 自分のIPを変数に格納
MY_IP=$(curl -s ifconfig.me)

# SSHルール追加
az network nsg rule create \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $FE_NSG_NAME \
  --name AllowSSH-MyIP \
  --priority 120 \
  --source-address-prefixes "${MY_IP}/32" \
  --source-port-ranges '*' \
  --destination-address-prefixes '*' \
  --destination-port-ranges 22 \
  --access Allow \
  --protocol Tcp
```

<div class="mt-4 bg-green-500/10 p-3 rounded text-sm">
✅ `/32` は単一のIPアドレスを指定する際のCIDR表記です。
</div>
</div>
</div>

---

## STEP 3-10A: SSH 接続制限の確認

特定 IP からの SSH 許可設定が正しく動作するかを確認します。

### 許可された IP からの SSH 接続確認

```bash
# 自分のパブリックIPから接続テスト
ssh azureuser@<frontend-public-ip>

# 期待される結果: 接続成功
```

### 他の IP からの SSH 接続テスト（参考）

<div class="text-sm">

**注意**: 実際のテストは困難ですが、理論的には以下のようになります：

```bash
# 異なるIPアドレスからの接続（VPNやプロキシ経由など）
# 期待される結果: 接続拒否またはタイムアウト
```

**確認方法:**

- NSG フローログで拒否されたトラフィックを確認
- 異なるネットワークからの接続テスト（可能な場合）
</div>

<div class="mt-4 bg-blue-500/10 p-3 rounded text-sm">
💡 本番環境では、管理者のIPアドレスのみを許可し、定期的にルールを見直すことが重要です。
</div>

---

## STEP 3-12: 拒否ルールの作成（参考）

明示的に特定のトラフィックを拒否するルールを作成します。

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

### ユースケース

**特定ポートの拒否**

- 管理ポート（RDP、SMB など）
- 不要なプロトコル

**特定 IP の拒否**

- ブロックリスト管理
- 攻撃元 IP の遮断

### 例：RDP ポートの明示的拒否

```bash
az network nsg rule create \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $FE_NSG_NAME \
  --name DenyRDP \
  --priority 4000 \
  --source-address-prefixes '*' \
  --destination-port-ranges 3389 \
  --access Deny \
  --protocol Tcp
```

</div>
<div>

### ⚠️ 注意点

**優先順位の重要性**

- 拒否ルールより**前**に許可ルールがあると拒否が効かない
- 例：優先度 100 で許可、優先度 4000 で拒否 → 許可が優先

**正しい配置例:**

```
100: 特定IPからSSH許可
4000: すべてのRDP拒否
65000: デフォルトルール
```

**デフォルトルールとの関係**

- デフォルト拒否ルールは優先度 65500
- それより前（小さい数値）で評価される
</div>
</div>

---

## STEP 3-12A: 拒否ルールの動作確認（参考）

作成した拒否ルールが正しく動作するかを確認します。

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

### RDP 接続テスト（拒否の確認）

```bash
# ローカルマシンからRDP接続テスト（Windows）
# mstsc /v:<frontend-public-ip>:3389

# 期待される結果: 接続拒否またはタイムアウト
```

### nc コマンドでの確認

```bash
# ローカルマシンから（Linux/macOS）
nc -zv <frontend-public-ip> 3389

# 期待される結果: 接続失敗
# "nc: connect to <ip> port 3389 (tcp) failed: Connection refused"
```

<div class="mt-4 bg-green-500/10 p-3 rounded text-sm">
✅ 拒否ルールにより、RDPポート（3389）への接続が正しくブロックされています。
</div>
</div>
<div>

### Telnet でポート確認

```bash
# ローカルマシンから
telnet <frontend-public-ip> 3389

# 期待される結果: 接続失敗
# "Could not open connection to the host, on port 3389: Connect failed"
```

### 許可されているポートの確認

```bash
# SSH（22）は許可されているため接続可能
ssh azureuser@<frontend-public-ip>

# HTTP（80）も許可されているため接続可能
curl http://<frontend-public-ip>

# 期待される結果: 両方とも接続成功
```

<div class="mt-4 bg-blue-500/10 p-3 rounded text-sm">
💡 NSGは「デフォルト拒否」の原則で動作します。明示的に許可されていないポートはすべてブロックされます。
</div>
</div>
</div>

---

## STEP 3-13: ルール優先順位の実験

優先順位によるルール評価を実際に確認します。

### 実験 1: 許可ルールと拒否ルールの順序

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

**シナリオ:** 同じ条件で許可と拒否のルールを作成

```bash
# 優先度200: ICMP（ping）許可
az network nsg rule create \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $FE_NSG_NAME \
  --name AllowICMP \
  --priority 200 \
  --protocol Icmp \
  --access Allow

# 優先度300: ICMP（ping）拒否
az network nsg rule create \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $FE_NSG_NAME \
  --name DenyICMP \
  --priority 300 \
  --protocol Icmp \
  --access Deny
```

**結果:** ping は**成功**します（優先度 200 の許可ルールが先に評価される）

</div>
<div>

**逆の実験:**

```bash
# ルールを削除して逆順で作成
# 優先度200: 拒否、優先度300: 許可
```

**結果:** ping は**失敗**します（優先度 200 の拒否ルールが先に評価される）

</div>
</div>

---

## STEP 3-13A-1: 優先順位実験の動作確認

作成したルールの優先順位が正しく動作するかを実際に確認します。

### ICMP（ping）の動作確認

```bash
# ローカルマシンから ping テスト
ping -c 4 <frontend-public-ip>

# 期待される結果（優先度200許可、300拒否の場合）:
# 64 bytes from <ip>: icmp_seq=1 ttl=64 time=1.23 ms
# → ping成功（許可ルールが優先）
```

---

## STEP 3-13A-2: 優先順位実験の動作確認

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

#### ルール順序の変更テスト

```bash
# 既存のICMPルールを削除
az network nsg rule delete \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $FE_NSG_NAME \
  --name AllowICMP

az network nsg rule delete \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $FE_NSG_NAME \
  --name DenyICMP

# 逆順で作成（拒否を先に）
# 優先度200: 拒否
az network nsg rule create \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $FE_NSG_NAME \
  --name DenyICMP \
  --priority 200 \
  --protocol Icmp \
  --access Deny

# 優先度300: 許可
az network nsg rule create \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $FE_NSG_NAME \
  --name AllowICMP \
  --priority 300 \
  --protocol Icmp \
  --access Allow
```

</div>
<div>

#### 変更後の動作確認

```bash
# 再度 ping テスト
ping -c 4 <frontend-public-ip>
# 期待される結果（優先度200拒否、300許可の場合）:
# Request timeout for icmp_seq 1
# → ping失敗（拒否ルールが優先）
```

<div class="mt-4 bg-green-500/10 p-3 rounded text-sm">
✅ 優先順位の小さいルールが先に評価され、マッチした時点で処理が決定されることが確認できました。
</div>

#### 実験後のクリーンアップ

```bash
# テスト用ICMPルールを削除
az network nsg rule delete \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $FE_NSG_NAME \
  --name DenyICMP

az network nsg rule delete \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $FE_NSG_NAME \
  --name AllowICMP
```

</div>
</div>

---

## STEP 3-14-1: サービスタグの活用（参考）

Azure サービスへのアクセスを簡単に制御できるサービスタグを使います。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">

<div>

### 主要なサービスタグ

| サービスタグ         | 説明                                          |
| -------------------- | --------------------------------------------- |
| VirtualNetwork       | VNet 内のすべてのアドレス                     |
| AzureLoadBalancer    | Azure Load Balancer のプローブ                |
| Internet             | VNet 外のパブリック IP アドレス               |
| Storage              | Azure Storage のパブリックエンドポイント      |
| Sql                  | Azure SQL Database のパブリックエンドポイント |
| AzureCloud           | すべての Azure パブリック IP                  |
| AzureCloud.JapanEast | 東日本リージョンの IP                         |

</div>
<div>

### 利点

- ✅ IP アドレスの管理不要
- ✅ Azure が自動更新
- ✅ リージョン指定可能
</div>
</div>

---

## STEP 3-14-2: サービスタグの活用（参考）

### 使用例

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

**Azure Storage へのアクセス許可:**

```bash
az network nsg rule create \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $BE_NSG_NAME \
  --name AllowStorage \
  --priority 150 \
  --source-address-prefixes 'VirtualNetwork' \
  --destination-address-prefixes 'Storage' \
  --destination-port-ranges 443 \
  --access Allow \
  --protocol Tcp
```

</div>
<div>

**Azure SQL Database へのアクセス許可:**

```bash
az network nsg rule create \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $BE_NSG_NAME \
  --name AllowSql \
  --priority 160 \
  --source-address-prefixes 'VirtualNetwork' \
  --destination-address-prefixes 'Sql.JapanEast' \
  --destination-port-ranges 1433 \
  --access Allow \
  --protocol Tcp
```

</div>
</div>

---

## STEP 3-15-1: アプリケーション セキュリティ グループ（ASG）

ASG を使うと、IP アドレスではなく論理的なグループでルールを管理できます。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">

<div>

### ASG とは

- **論理的なグループ化**
- VM の役割別にグループを作成
- IP アドレスを意識せずルール作成
</div>
<div>

### ASG 作成

```bash
# WebサーバーグループASG
az network asg create \
  --resource-group $RESOURCE_GROUP \
  --name asg-web \
  --location japaneast

# アプリサーバーグループASG
az network asg create \
  --resource-group $RESOURCE_GROUP \
  --name asg-app \
  --location japaneast

# DBサーバーグループASG
az network asg create \
  --resource-group $RESOURCE_GROUP \
  --name asg-db \
  --location japaneast
```

</div>
</div>

---

## STEP 3-15-2: アプリケーション セキュリティ グループ（ASG）

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

### VM の NIC を ASG に関連付け

```bash
# vm-frontend のNICをasg-webに関連付け
az network nic ip-config update \
  --resource-group $RESOURCE_GROUP \
  --nic-name vm-frontend-nic \
  --name ipconfig1 \
  --application-security-groups asg-web

# vm-backend のNICをasg-appに関連付け
az network nic ip-config update \
  --resource-group $RESOURCE_GROUP \
  --nic-name vm-backend-nic \
  --name ipconfig1 \
  --application-security-groups asg-app
```

</div>
<div>

### ASG を使ったルール作成

```bash
# Web→App への通信許可
az network nsg rule create \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $BE_NSG_NAME \
  --name AllowWeb-to-App \
  --priority 200 \
  --source-asgs asg-web \
  --destination-asgs asg-app \
  --destination-port-ranges 3000 \
  --access Allow \
  --protocol Tcp
```

</div>
</div>

---

## STEP 3-16: NSG の優先順位戦略

### 推奨される優先順位範囲

| 範囲      | 用途                       | 例                                 |
| --------- | -------------------------- | ---------------------------------- |
| 100-500   | 明示的な許可ルール         | 特定 IP から SSH、HTTP/HTTPS 許可  |
| 500-1000  | アプリケーション間通信     | サブネット間、ASG 間の通信         |
| 1000-2000 | Azure サービスへのアクセス | Storage、SQL、AzureCloud           |
| 3000-4000 | 明示的な拒否ルール         | 危険なポート、攻撃元 IP ブロック   |
| 4096      | 緊急用の拒否ルール         | すべてをブロック（メンテナンス時） |
| 65000+    | デフォルトルール           | Azure が管理（変更不可）           |

### 管理のコツ

- 100 刻みで優先度を設定（後から挿入しやすい）
- コメント機能を活用（Portal、説明フィールド）
- 定期的に不要なルールを削除
- Infrastructure as Code（ARM、Terraform）で管理

---

## STEP 3-17: NIC レベルとサブネットレベルの NSG

NSG の適用レベルによる違いを理解します。

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

#### サブネットレベル NSG

**適用対象:**

- サブネット内のすべての VM
- サブネットに入る/出るトラフィック

**メリット:**

- ✅ 一元管理しやすい
- ✅ サブネット全体のポリシー適用
- ✅ 管理対象の NSG 数が少ない

**ユースケース:**

- Web サーバー層への 80/443 許可
- 管理サブネットへのアクセス制限
- マイクロセグメンテーション
</div>
<div>

#### NIC レベル NSG

**適用対象:**

- 特定の VM のネットワークインターフェイス
- その VM 宛のトラフィックのみ

**メリット:**

- ✅ VM ごとに細かい制御
- ✅ 例外的な設定が可能

**ユースケース:**

- 特定 VM のみ追加ポート開放
- 管理 VM（踏み台）の厳格な制御
- コンプライアンス要件

#### 両方適用した場合

**評価順序:**

1. サブネット NSG（Inbound）
2. NIC NSG（Inbound）
3. 通信実施
4. NIC NSG（Outbound）
5. サブネット NSG（Outbound）

**両方で許可されて初めて通信可能**

</div>
</div>

---

## STEP 3-18: NSG フローログの有効化

NSG フローログでトラフィックを可視化します。

### 前提条件

Storage Account が必要です：

```bash
# Storage Account作成
az storage account create \
  --resource-group $RESOURCE_GROUP \
  --name stnsgflowlogs$(date +%s) \
  --location japaneast \
  --sku Standard_LRS

# Storage Account名を変数に保存
STORAGE_ACCOUNT=$(az storage account list \
  --resource-group $RESOURCE_GROUP \
  --query "[0].name" -o tsv)
```

### Network Watcher の有効化

```bash
# Network Watcher作成（まだない場合）
az network watcher configure \
  --resource-group NetworkWatcherRG \
  --locations japaneast \
  --enabled true
```

---

## STEP 3-19: NSG フローログの設定

フローログを設定して、トラフィックを記録します。

```bash
# NSG IDを取得
NSG_ID=$(az network nsg show \
  --resource-group $RESOURCE_GROUP \
  --name $FE_NSG_NAME \
  --query id -o tsv)

# Storage Account IDを取得
STORAGE_ID=$(az storage account show \
  --resource-group $RESOURCE_GROUP \
  --name $STORAGE_ACCOUNT \
  --query id -o tsv)

# フローログ作成
az network watcher flow-log create \
  --resource-group NetworkWatcherRG \
  --name flowlog-frontend \
  --nsg $NSG_ID \
  --storage-account $STORAGE_ID \
  --location japaneast \
  --enabled true \
  --retention 7 \
  --format JSON \
  --log-version 2
```

---

## STEP 3-20: NSG フローログの確認 - Portal

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

1. **Network Watcher を開く**

   - 「Network Watcher」を検索

2. **NSG フロー ログ を開く**

   - 左メニュー「NSG フロー ログ」をクリック
   - 作成したフローログを確認

3. **Storage Account で確認**
   - Storage Account を開く
   - 「コンテナー」→ `insights-logs-networksecuritygroupflowevent` を開く
   - JSON 形式のログファイルをダウンロード
   
</div>
<div>

### ログの内容例

```json
{
  "time": "2025-10-17T10:30:00.0000000Z",
  "systemId": "...",
  "category": "NetworkSecurityGroupFlowEvent",
  "resourceId": "/subscriptions/.../nsg-subnet-frontend",
  "operationName": "NetworkSecurityGroupFlowEvents",
  "properties": {
    "flows": [
      {
        "rule": "AllowHTTP",
        "flows": [
          {
            "sourceAddress": "203.0.113.10",
            "destinationAddress": "10.1.1.4",
            "destinationPort": "80",
            "protocol": "T",
            "decision": "A",
            "flowState": "B"
          }
        ]
      }
    ]
  }
}
```

</div>
</div>

---

## STEP 3-21: Traffic Analytics（参考）

NSG フローログをさらに分析しやすくする Traffic Analytics について。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">
<div>

### Traffic Analytics とは

- NSG フローログを視覚化・分析
- Log Analytics Workspace と統合
- リアルタイムに近い分析（約 10 分遅延）

### 機能

- 📊 **トップトーカー分析**
  - 最も通信量が多い VM
- 🌍 **地理的分散**
  - 通信元の国/地域を可視化
- 🚨 **異常検知**
  - 通常と異なるトラフィックパターン
- 🔒 **セキュリティ分析**
  - 許可/拒否されたフローの分析
  
</div>
<div>

### 有効化の流れ

1. **Log Analytics Workspace の作成**

```bash
az monitor log-analytics workspace create \
  --resource-group $RESOURCE_GROUP \
  --workspace-name law-network-handson \
  --location japaneast
```

2. **フローログに Traffic Analytics 追加**

Portal で：
- Network Watcher → NSG フロー ログ
- フローログを選択 → 「編集」
- Traffic Analytics を「有効」に設定
- Log Analytics Workspace を選択

3. **Azure Portal で確認**

- Network Watcher → Traffic Analytics
- ダッシュボードでトラフィックを可視化

</div>
</div>

---

## STEP 3-22: 実効セキュリティ規則の確認 - Portal

VM に実際に適用されているルールを確認します。

1. **VM のネットワークを開く**
   - `vm-frontend` → 「ネットワーク」

2. **実効セキュリティ規則を表示**
   - 「ネットワーク設定」セクション
   - 「実効セキュリティ規則」タブをクリック

### 表示内容

- サブネット NSG と NIC NSG の**統合されたルール**
- 実際にトラフィックに適用される順序で表示
- デフォルトルールも含めてすべて表示

### CLI での確認

```bash
# 実効セキュリティ規則を表示
az network nic list-effective-nsg \
  --resource-group $RESOURCE_GROUP \
  --name vm-frontend-nic \
  --output table
```

---

## STEP 3-23: NSG のトラブルシューティング

NSG で問題が発生した場合の確認手順です。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">
<div>

**1. ルールの確認**

```bash
# NSGルール一覧
az network nsg rule list \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $FE_NSG_NAME \
  --include-default \
  --output table
```

**2. 実効セキュリティ規則の確認**

- サブネット NSG と NIC NSG の両方を確認
- 統合されたルールで評価

**3. NSG フローログの確認**

- 実際にトラフィックが拒否されているか確認
- どのルールで拒否されたか特定

</div>
<div>

**4. IP Flow の検証（Network Watcher）**

```bash
# 特定の通信が許可されるか確認
az network watcher test-ip-flow \
  --resource-group $RESOURCE_GROUP \
  --vm vm-frontend \
  --direction Inbound \
  --protocol TCP \
  --local 10.1.1.4:80 \
  --remote 203.0.113.10:12345
```

**5. 優先順位の確認**

- 許可ルールより前に拒否ルールがないか
- 意図しないデフォルトルールの影響

</div>
</div>

---

## STEP 3-24: NSG のベストプラクティス

<div class="grid grid-cols-2 gap-6 text-xs">
<div>

### 設計原則

**1. 最小権限の原則**

- 必要最小限のポートのみ開放
- ソース IP を可能な限り絞る
- デフォルト拒否、明示的許可

**2. 階層的な適用**

- サブネット NSG：共通ポリシー
- NIC NSG：例外的な設定

**3. サービスタグの活用**

- IP アドレス管理の負担軽減
- Azure サービスへのアクセス

**4. ASG の活用**

- 論理的なグループ化
- IP アドレス変更に強い設計
</div>
<div>

### 運用ルール

**1. 命名規則の統一**

- `<Action><Protocol><Source>-<Destination>`
- チーム内で統一した規則

**2. ドキュメント化**

- ルールの目的をコメントに記載
- 変更履歴の管理

**3. 定期的なレビュー**

- 不要なルールの削除
- セキュリティ要件の見直し

**4. 監視とアラート**

- NSG フローログの有効化
- Traffic Analytics での分析
- 異常なトラフィックの検知

**5. Infrastructure as Code**

- ARM Template、Terraform 等で管理
- バージョン管理とレビュープロセス
</div>
</div>

---

## ハンズオン ③ のまとめ

NSG（Network Security Group）の設定と運用を学びました。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">

<div>

### ✅ 達成したこと

- ✅ NSG の作成とルール設定
- ✅ サブネット/NIC への NSG 適用
- ✅ 優先順位とルール評価の理解
- ✅ サービスタグの活用
- ✅ ASG（Application Security Group）の使用
- ✅ NSG フローログの設定
- ✅ 実効セキュリティ規則の確認
</div>
<div>

### 🔑 重要なポイント

- **ステートフル**: 戻りトラフィックは自動許可
- **優先順位**: 小さい数値が先に評価される
- **最初の一致**: マッチしたルールで評価終了
- **サブネットと NIC**: 両方で許可が必要
- **サービスタグ**: IP 管理が不要
- **ASG**: 論理的なグループ化
- **フローログ**: トラフィックの可視化
- **最小権限**: 必要最小限のアクセスのみ
</div>
</div>

---

## 🧠 理解度チェック ③ - 質問

ハンズオン ③ の内容を理解できたか確認しましょう。

<div class="pt-4">

1. **NSG ルールの優先順位で、100 と 200 ではどちらが先に評価されますか？**

2. **サブネット NSG と NIC NSG の両方が適用されている場合、どちらで許可されれば通信できますか？**

3. **NSG の「ステートフル」とはどういう意味ですか？**

4. **サービスタグ「Storage」を使うメリットは何ですか？**

5. **ASG（Application Security Group）を使うメリットは何ですか？**

</div>

---

## 🧠 理解度チェック ③ - 回答

1. **NSG ルールの優先順位で、100 と 200 ではどちらが先に評価されますか？**

   - **100 が先に評価されます。** 優先順位は小さい数値ほど先に評価されます。
   - 最初にマッチしたルールが適用され、それ以降のルールは評価されません。

2. **サブネット NSG と NIC NSG の両方が適用されている場合、どちらで許可されれば通信できますか？**

   - **両方で許可される必要があります。** どちらか一方でも拒否されると通信できません。
   - 評価順序: サブネット NSG → NIC NSG → 通信 → NIC NSG → サブネット NSG

3. **NSG の「ステートフル」とはどういう意味ですか？**

   - **戻りトラフィックは自動的に許可される**という意味です。
   - 例：Inbound で許可された SSH 接続の応答（Outbound）は、明示的なルールなしで許可されます。

4. **サービスタグ「Storage」を使うメリットは何ですか？**

   - ✅ Azure Storage のパブリック IP アドレスを個別に管理する必要がない
   - ✅ Azure が IP アドレスを自動更新してくれる
   - ✅ リージョン指定も可能（例：Storage.JapanEast）

5. **ASG（Application Security Group）を使うメリットは何ですか？**
   - ✅ IP アドレスではなく、論理的なグループ（役割）でルールを管理できる
   - ✅ VM の IP アドレスが変わっても、ルールの変更が不要
   - ✅ 複数の VM をまとめて制御しやすい
