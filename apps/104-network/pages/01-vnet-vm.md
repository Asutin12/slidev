---
layout: center
---

# 🏗️ ハンズオン ①

仮想ネットワークの設計と VM 配置

---

## ハンズオン ① の概要

このハンズオンでは、Azure Virtual Network（VNet）の基礎を学び、実際に VNet を作成して VM を配置します。

<div class="pt-6">

### 🎯 学習目標

- VNet の作成と IP アドレス範囲（CIDR）の設計方法を理解する
- サブネットの分割と用途別配置を実践する
- VM にプライベート IP とパブリック IP を割り当てる
- ネットワーク接続性の確認方法を習得する

### 📋 実施内容

1. **VNet の設計** - IP アドレス範囲とサブネット構成を計画
2. **VNet の作成** - Azure Portal で仮想ネットワークを構築
3. **VM の作成** - 異なるサブネットに複数の VM を配置
4. **接続確認** - ping、SSH、RDP による疎通確認

</div>

---

## 環境変数の設定

```bash
# resource groupの設定
export RESOURCE_GROUP=

# VNet 01の名前
export VNET_01=

# VNet 02の名前
export VNET_02=

# Frontend用NSGの名前
export FE_NSG_NAME=

# Backend用NSGの名前
export BE_NSG_NAME=

# App用NSGの名前
export APP_NSG_NAME=
```

---

## STEP 1-1: VNet の設計

まず、VNet の IP アドレス範囲とサブネット構成を設計します。今回は 2 層構成（パブリックサブネット・プライベートサブネット）で設計します。

<div class="grid grid-cols-2 gap-6 pt-4">

<div>

#### 設計内容

- **VNet 名：** `vnet-handson-01`
- **アドレス空間：** `10.1.0.0/16`（65,536 個の IP アドレス）

<br/>

#### サブネット構成

| サブネット名    | CIDR        | 用途                               |
| --------------- | ----------- | ---------------------------------- |
| subnet-frontend | 10.1.1.0/24 | パブリックサブネット（Web 層）     |
| subnet-backend  | 10.1.2.0/24 | プライベートサブネット（アプリ層） |

</div>
<div>

#### 🧠 設計のポイント

**CIDR 表記の理解**

- `/16` = 65,536 個の IP（256 × 256）
- `/24` = 256 個の IP
- `/28` = 16 個の IP（最小推奨サイズ）

<br/>

**Azure の予約 IP**

各サブネットで 5 つの IP が予約されます：

- `.0` - ネットワークアドレス
- `.1` - デフォルトゲートウェイ
- `.2`, `.3` - Azure DNS サーバー
- `.255` - ブロードキャストアドレス

<br/>

つまり、`10.1.1.0/24`では`.4`〜`.254`が利用可能です。

</div>

</div>

---

## STEP 1-2: VNet の作成（Portal）

Azure Portal を使って VNet を作成します。

### 手順

1. **Azure Portal にアクセス**

   - [https://portal.azure.com](https://portal.azure.com) にアクセス

2. **リソースグループの作成**

   - 「リソース グループ」を検索
   - 「+ 作成」をクリック
   - 名前: `rg-hands-on`
   - リージョン: `Japan East`
   - 「確認および作成」→「作成」

3. **仮想ネットワークの作成**
   - 「仮想ネットワーク」を検索
   - 「+ 作成」をクリック

---

## STEP 1-3: VNet 作成の詳細設定（1/2）

<div class="grid grid-cols-2 gap-6">
<div>

VNet の基本設定を入力します。

### 基本タブ

- **サブスクリプション**: 使用するサブスクリプションを選択
- **リソース グループ**: `rg-hands-on`
- **名前**: `vnet-handson-01`
- **地域**: `Japan East`

「次: IP アドレス >」をクリック

### 💡 ポイント

**リージョンの選択**

- VNet 作成後は変更不可
- 低レイテンシを重視する場合は近いリージョンを選択
- コスト面では地域差がある場合も

**命名規則**

- `vnet-{purpose}-{number}` の形式を推奨
- チーム内で統一した命名規則を使用

</div>
<div>

IP アドレス空間とサブネットを設定します。

### IP アドレスタブ

1. **IPv4 アドレス空間の設定**

   - デフォルトのアドレス空間を削除
   - 「+ IPv4 アドレス空間の追加」をクリック
   - アドレス空間: `10.1.0.0/16` を入力

2. **サブネットの追加（1 つ目）**

   - 「+ サブネットの追加」をクリック
   - サブネット名: `subnet-frontend`
   - アドレス範囲: `10.1.1.0/24`
   - 「追加」をクリック

3. **サブネットの追加（2 つ目）**

   - 同様に以下を追加：
     - `subnet-backend`: `10.1.2.0/24`

4. **確認と作成**
   - 「確認および作成」→「作成」をクリック
   - デプロイ完了まで約 1 分待機

</div>
</div>

---

## STEP 1-5: VNet 作成（Azure CLI 版）

コマンドラインで同じ構成を作成することもできます。

```bash
# リソースグループの作成
az group create \
  --name $RESOURCE_GROUP \
  --location japaneast

# VNetの作成
az network vnet create \
  --resource-group $RESOURCE_GROUP \
  --name $VNET_01 \
  --address-prefix 10.1.0.0/16 \
  --subnet-name subnet-frontend \
  --subnet-prefix 10.1.1.0/24 \
  --location japaneast

# 追加のサブネット作成
az network vnet subnet create \
  --resource-group $RESOURCE_GROUP \
  --vnet-name $VNET_01 \
  --name subnet-backend \
  --address-prefix 10.1.2.0/24
```

<div class="text-xs opacity-75 mt-4">
💡 CLI版は自動化スクリプトやInfrastructure as Code（IaC）に活用できます
</div>

---

## STEP 1-6: VM 作成の準備

VNet の次は、各サブネットに VM を配置します。

| VM 名       | サブネット      | OS           | パブリック IP |
| ----------- | --------------- | ------------ | ------------- |
| vm-frontend | subnet-frontend | Ubuntu 24.04 | あり          |
| vm-backend  | subnet-backend  | Ubuntu 24.04 | なし          |

#### 💡 設計のポイント

**パブリック IP の使い分け**

- **vm-frontend**: インターネットからのアクセスを想定（Web サーバー）
- **vm-backend**: 内部通信のみ（アプリサーバー）

<br/>

**セキュリティの観点**

- 必要最小限の VM のみパブリック IP を付与
- 本番環境では Bastion 経由での管理を推奨

---

## STEP 1-7: VM 作成（パブリックサブネット用）- Portal（1/2）

パブリックサブネット用の VM を作成します。

### 手順

1. **仮想マシンの作成開始**

   - Azure Portal で「仮想マシン」を検索
   - 「+ 作成」→「Azure 仮想マシン」をクリック

2. **基本タブの設定**
   - **サブスクリプション**: 使用中のサブスクリプション
   - **リソース グループ**: 最初に作成したもの
   - **仮想マシン名**: `vm-frontend`
   - **地域**: `Japan East`
   - **可用性オプション**: インフラストラクチャ冗長は必要ありません
   - **セキュリティの種類**: Standard
   - **イメージ**: `Ubuntu Server 24.04 LTS - x64 Gen2`
   - **サイズ**: `Standard_B2s`（2 vCPU、4 GiB メモリ）

---

## STEP 1-8: VM 作成（パブリックサブネット用）- Portal（2/2）

認証とネットワーク設定を行います。

<div class="grid grid-cols-2 gap-6 text-sm">

<div>

### 管理者アカウント

- **認証の種類**: パスワード
- **ユーザー名**: `azureuser`
- **パスワード**: 複雑なパスワードを設定
  - 12 文字以上
  - 大文字、小文字、数字、記号を含む

### 受信ポートの規則

- **パブリック受信ポート**: 選択したポートを許可
- **受信ポートを選択**: `SSH (22)`

「次: ディスク >」をクリック

</div>

<div>

### ディスクタブ

- **OS ディスクの種類**: `Standard SSD` (デフォルト)
- その他はデフォルトのまま

### ネットワークタブ

- **仮想ネットワーク**: `vnet-handson-01`
- **サブネット**: `subnet-frontend (10.1.1.0/24)`
- **パブリック IP**: (新規) `vm-frontend-ip`
- **NIC ネットワーク セキュリティ グループ**: Basic
- **パブリック受信ポート**: 選択したポートを許可
- **受信ポートを選択**: SSH (22)

「確認および作成」→「作成」

</div>

</div>

---

## STEP 1-9: VM 作成（プライベートサブネット用）- Portal

プライベートサブネット用の VM を作成します（パブリック IP なし）。

### 手順

同様の手順で VM を作成しますが、以下の点が異なります：

<div class="grid grid-cols-2 gap-6 text-sm">

<div>

### 基本タブ

- **仮想マシン名**: `vm-backend`
- **イメージ**: `Ubuntu Server 24.04 LTS - x64 Gen2`
- **サイズ**: `Standard_B2s`
- **ユーザー名**: `azureuser`
- **パスワード**: パブリックサブネット VM と同じパスワード推奨

</div>

<div>

### ネットワークタブ（重要な違い）

- **仮想ネットワーク**: `vnet-handson-01`
- **サブネット**: `subnet-backend (10.1.2.0/24)`
- **パブリック IP**: **なし**に設定
  - ドロップダウンで「なし」を選択
- **NIC ネットワーク セキュリティ グループ**: Basic
- **パブリック受信ポート**: なし

</div>

</div>

<div class="mt-4 bg-yellow-500/10 p-3 rounded text-sm">
⚠️ <strong>注意:</strong> プライベートサブネットのVMはパブリックIPがないため、インターネットから直接アクセスできません。パブリックサブネットのVM経由でアクセスします。
</div>

---

## STEP 1-10: VM 作成（Azure CLI 版）

コマンドラインで VM を作成することもできます。

```bash
# パブリックサブネット用VM の作成（パブリックIPあり）
az vm create \
  --resource-group $RESOURCE_GROUP \
  --name vm-frontend \
  --location japaneast \
  --vnet-name $VNET_01 \
  --subnet subnet-frontend \
  --image Ubuntu2404 \
  --size Standard_B2s \
  --admin-username azureuser \
  --admin-password 'YourSecurePassword123!' \
  --public-ip-address vm-frontend-ip \
  --public-ip-sku Standard

# プライベートサブネット用VM の作成（パブリックIPなし）
az vm create \
  --resource-group $RESOURCE_GROUP \
  --name vm-backend \
  --location japaneast \
  --vnet-name $VNET_01 \
  --subnet subnet-backend \
  --image Ubuntu2404 \
  --size Standard_B2s \
  --admin-username azureuser \
  --admin-password 'YourSecurePassword123!' \
  --public-ip-address ""
```

<div class="text-xs opacity-75 mt-4">
💡 `--public-ip-address ""` でパブリックIPなしで作成できます
</div>

---

## STEP 1-11: 作成したリソースの確認

Azure Portal で作成したリソースを確認します。

1. **リソースグループを開く**

   - Azure Portal で「リソース グループ」を検索
   - 作成したリソースグループをクリック

2. **リソース一覧の確認**

以下のリソースが作成されているはずです：

| リソースタイプ                     | 名前                                          | 数  |
| ---------------------------------- | --------------------------------------------- | --- |
| 仮想ネットワーク                   | vnet-handson-01                               | 1   |
| 仮想マシン                         | vm-frontend, vm-backend                       | 2   |
| ネットワーク インターフェイス      | vm-frontend-nic, vm-backend-nic               | 2   |
| パブリック IP アドレス             | vm-frontend-ip                                | 1   |
| ネットワーク セキュリティ グループ | vm-frontend-nsg, vm-backend-nsg               | 2   |
| ディスク                           | vm-frontend*OsDisk*..., vm-backend*OsDisk*... | 2   |

---

## STEP 1-12: IP アドレスの確認

各 VM に割り当てられた IP アドレスを確認します。

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

### Portal での確認

1. **Frontend VM の IP アドレス確認**

   - `vm-frontend` を開く
   - 「ネットワーク」をクリック
   - **プライベート IP**: `10.1.1.4` のような値
   - **パブリック IP**: `20.xxx.xxx.xxx` のような値をメモ

2. **Backend VM の IP アドレス確認**
   - `vm-backend` を開く
   - 「ネットワーク」をクリック
   - **プライベート IP**: `10.1.2.4` のような値
   - **パブリック IP**: なし

</div>
<div>

### CLI での確認

```bash
# Frontend VM の IP 確認
az vm show -d \
  --resource-group $RESOURCE_GROUP \
  --name vm-frontend \
  --query "[privateIps, publicIps]" \
  --output table

# Backend VM の IP 確認
az vm show -d \
  --resource-group $RESOURCE_GROUP \
  --name vm-backend \
  --query "[privateIps, publicIps]" \
  --output table
```

</div>
</div>

---

## STEP 1-13: パブリックサブネット VM への接続確認

パブリック IP を使ってパブリックサブネットの VM に接続します。

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

### SSH 接続

```bash
# Frontend VMに接続
ssh azureuser@<frontend-vm-public-ip>

# 例：
# ssh azureuser@20.89.123.456
```

</div>
<div>

接続できたら、以下のコマンドで確認：

```bash
# ホスト名確認
hostname

# IPアドレス確認
ip addr show

# プライベートIPアドレスの確認
ip addr show eth0 | grep inet

# インターネット接続確認
ping -c 4 8.8.8.8

# DNS確認
nslookup www.microsoft.com
```

</div>
</div>
<div class="mt-4 bg-green-500/10 p-3 rounded text-sm">
✅ これらのコマンドが正常に実行できれば、パブリックサブネットのVMは正しく設定されています。
</div>
---

## STEP 1-14: プライベートサブネット VM への接続（踏み台経由）

プライベートサブネットの VM はパブリック IP がないため、パブリックサブネットの VM 経由で接続します。

<div class="grid grid-cols-2 gap-6 mt-3">
<div>

1. **パブリックサブネット VM に SSH 接続**（前のステップで接続済み）

2. **プライベートサブネット VM のプライベート IP を使って接続**

```bash
# backend VMに接続（frontend VMから）
ssh azureuser@10.1.2.4

# 初回接続時の確認メッセージで "yes" を入力
# パスワードを入力
```

</div>
<div>

3. **プライベートサブネット VM での確認**

```bash
# ホスト名確認
hostname

# IPアドレス確認
ip addr show

# インターネット接続確認（デフォルトでは可能）
ping -c 4 8.8.8.8

# frontend VMへの疎通確認
ping -c 4 10.1.1.4
```

</div>
</div>

<div class="mt-4 bg-blue-500/10 p-3 rounded text-sm">
💡 <strong>ポイント:</strong> プライベートサブネットのVMはパブリックIPがなくてもインターネットにアクセスできます。これはAzureの「デフォルトアウトバウンドアクセス」機能によるものです。
</div>

---

## STEP 1-15: ネットワーク疎通確認

VNet 内の通信を確認します。

<div class="grid grid-cols-2 gap-6 text-sm mt-3">
<div>

### ① パブリック → プライベート

パブリックサブネットの VM から実行：

```bash
# ping確認
ping -c 4 10.1.2.4

# TCPポート確認（SSH）
nc -zv 10.1.2.4 22
```

**期待結果:**

- ✅ ping が成功
- ✅ SSH ポート（22）が開いている

</div>

<div>

### ② プライベート → パブリック

プライベートサブネットの VM から実行：

```bash
# ping確認
ping -c 4 10.1.1.4

# TCPポート確認（SSH）
nc -zv 10.1.1.4 22
```

**期待結果:**

- ✅ ping が成功
- ✅ SSH ポート（22）が開いている

</div>

</div>

<div class="mt-4 bg-green-500/10 p-3 rounded text-sm">
✅ <strong>確認:</strong> 同じVNet内のサブネット間は、デフォルトで相互に通信可能です。これは次のハンズオンで学ぶNSGで制御できます。
</div>

---

## STEP 1-16: VNet 設定の詳細確認 - Portal

1. **VNet を開く**

   - `vnet-handson-01` を検索して開く

2. **アドレス空間の確認**

   - 左メニュー「アドレス空間」をクリック
   - `10.1.0.0/16` が設定されていることを確認

3. **サブネットの確認**

   - 左メニュー「サブネット」をクリック
   - 2 つのサブネットが表示される
   - 各サブネットをクリックして詳細を確認

4. **接続されたデバイスの確認**
   - 左メニュー「接続されているデバイス」をクリック
   - 各 VM のネットワークインターフェイスが表示される

---

## STEP 1-17: プライベート IP アドレスの静的割り当て

### ネットワークインターフェイス (NIC) とは

<div class="grid grid-cols-2 gap-6 text-sm">

<div>

**概要**

- ネットワークインターフェイスカード (NIC) は、VM とネットワーク間の接続を提供する Azure リソース
- 各 VM には 1 つ以上の NIC を接続可能
- NIC には以下が関連付けられる
  - プライベート IP アドレス
  - パブリック IP アドレス（オプション）
  - ネットワークセキュリティグループ（オプション）
  - サブネット

</div>

<div>

**NIC の特徴**

- **独立したリソース**: VM とは別に存在し、管理可能
- **再利用可能**: VM から切り離して、別の VM に接続可能
- **複数 IP 構成**: 1 つの NIC に複数の IP アドレスを設定可能
- **VM 作成時に自動生成**: VM を作成すると、デフォルトで NIC が作成される（名前: `vm名-nic`）

</div>

</div>

<div class="mt-4 bg-purple-500/10 p-3 rounded text-sm">
💡 <strong>確認ポイント:</strong> 
前のステップで確認した「接続されているデバイス」に表示されていたのが、各 VM のネットワークインターフェイスです。
</div>

---

### 静的 IP への変更手順

1. **ネットワークインターフェイスを開く**

   - `vm-frontend-nic` を検索して開く

2. **IP 構成を開く**

   - 左メニュー「IP 構成」をクリック
   - `ipconfig1` をクリック

3. **静的 IP に変更**
   - **割り当て**: 「静的」を選択
   - **IP アドレス**: 現在の IP（例: `10.1.1.4`）を確認
   - 「保存」をクリック

<div class="mt-4 bg-blue-500/10 p-3 rounded text-sm">
💡 <strong>静的IPの使いどころ:</strong>
<ul class="mt-2 ml-4">
<li>DNSサーバー、ドメインコントローラー</li>
<li>固定IPが必要なアプリケーション</li>
<li>ファイアウォールルールで特定のIPを許可する場合</li>
</ul>
</div>

---

## STEP 1-18: パブリック IP アドレスの詳細

<div class="grid grid-cols-2 gap-6 text-sm">

<div>

### パブリック IP の種類

**Basic SKU**

- 動的または静的割り当て
- 可用性ゾーン非対応
- NSG は必須ではない
- 無料（割り当て数に応じた課金）

**Standard SKU**

- 静的割り当てのみ
- 可用性ゾーン対応
- デフォルトでセキュア（NSG 必須）
- わずかに高コスト

</div>

<div>

### 割り当て方法

**動的（Dynamic）**

- VM 起動時に IP が割り当てられる
- VM 停止時に IP が解放される
- IP アドレスが変わる可能性がある

**静的（Static）**

- 固定 IP アドレス
- VM 停止中も保持される
- DNS レコードで使用する場合に推奨

</div>

</div>

<div class="mt-4 bg-yellow-500/10 p-3 rounded text-sm">
⚠️ <strong>注意:</strong> 静的パブリックIPは、使用していなくても課金されます。不要になったら必ず削除しましょう。
</div>

---

## STEP 1-19: DNS 設定とホスト名

### Azure 提供の DNS

デフォルトでは、Azure 提供の DNS サーバー（168.63.129.16）が使用されます。

**確認方法:**

VM 上で以下を実行：

```bash
# DNS設定確認
cat /etc/resolv.conf

# 出力例：
# nameserver 168.63.129.16
```

### カスタム DNS 設定

VNet レベルでカスタム DNS を設定できます：

1. **VNet を開く**
2. **左メニュー「DNS サーバー」をクリック**
3. **「カスタム」を選択して、DNS サーバーの IP アドレスを入力**

<div class="mt-4 bg-blue-500/10 p-3 rounded text-sm">
💡 ハンズオン④でAzure DNSを使ったプライベートDNSゾーンを学びます。
</div>

---

## ハンズオン ① のまとめ

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">
<div>

### ✅ 達成したこと

- ✅ VNet とサブネットの設計・作成
- ✅ CIDR 表記と IP アドレス範囲の理解
- ✅ 複数サブネットへの VM 配置
- ✅ プライベート IP とパブリック IP の使い分け
- ✅ VNet 内のネットワーク疎通確認
- ✅ SSH による VM アクセス

</div>

<div>

### 🔑 重要なポイント

- **CIDR 設計**: IP アドレス範囲の重複を避ける
- **サブネット分割**: 用途別に論理的に分離
- **Azure の予約 IP**: 各サブネットで 5 つの IP が予約
- **パブリック IP**: 必要最小限に抑える
- **デフォルト通信**: 同一 VNet 内は自由に通信可能
- **セキュリティ**: 次のハンズオンで NSG を学ぶ

</div>
</div>

---

## 🧠 理解度チェック ① - 質問

ハンズオン ① の内容を理解できたか確認しましょう。

<div class="pt-4">

1. **CIDR `/24` のサブネットには何個の IP アドレスがありますか？**

2. **Azure が各サブネットで予約する 5 つの IP アドレスは何ですか？**

3. **静的プライベート IP アドレスを使うべきなのはどんな場合ですか？**

4. **同じ VNet 内の異なるサブネット間で通信できますか？デフォルト設定では？**

</div>

---

## 🧠 理解度チェック ① - 回答

1. **CIDR `/24` のサブネットには何個の IP アドレスがありますか？**

   - **256 個** の IP アドレス（2^8 = 256）
   - 利用可能なのは **251 個**（Azure が 5 つを予約）

2. **Azure が各サブネットで予約する 5 つの IP アドレスは何ですか？**

   - `.0` ネットワークアドレス
   - `.1` デフォルトゲートウェイ
   - `.2, .3` Azure DNS サーバー
   - `.255` ブロードキャストアドレス

3. **静的プライベート IP アドレスを使うべきなのはどんな場合ですか？**

   - DNS サーバー、ドメインコントローラー
   - 固定 IP が必要なアプリケーション
   - ファイアウォールルールで特定の IP を許可する場合

4. **同じ VNet 内の異なるサブネット間で通信できますか？デフォルト設定では？**
   - **はい、通信できます**。同じ VNet 内のサブネット間はデフォルトで相互通信可能
   - NSG（Network Security Group）で制御可能
