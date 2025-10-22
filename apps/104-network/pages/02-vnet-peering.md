---
layout: center
---

# 🔗 ハンズオン ②

異なる VNet 間の接続とルーティング

---

## ハンズオン ② の概要

このハンズオンでは、VNet Peering を使って異なる VNet 間を接続し、ネットワーク通信を実現します。

<div class="pt-6">

### 🎯 学習目標

- VNet Peering の仕組みと利点を理解する
- 同一リージョン内の VNet 間接続を構築する
- 双方向 Peering の設定方法を習得する
- Peering 経由の通信確認と帯域特性を理解する
- IP アドレス範囲の重複がない設計の重要性を学ぶ

### 📋 実施内容

1. **2 つ目の VNet 作成** - 異なるアドレス範囲で新規 VNet 構築
2. **VNet Peering 設定** - 双方向の Peering 接続を確立
3. **VM 配置と接続確認** - Peering 経由の通信をテスト
4. **非推移性の確認** - Peering の制約を理解する

</div>

---

## STEP 2-1: 2 つ目の VNet 設計

Peering で接続する 2 つ目の VNet を設計します。

<div class="grid grid-cols-2 gap-6 pt-4">
<div>

### 設計内容

**VNet 名：** `vnet-handson-02`
**アドレス空間：** `10.2.0.0/16`

### サブネット構成

| サブネット名 | CIDR        | 用途               |
| ------------ | ----------- | ------------------ |
| subnet-app   | 10.2.1.0/24 | アプリケーション層 |

### 配置する VM

**VM 名：** `vm-app`

- サブネット: subnet-app
- パブリック IP: あり（管理用）

</div>

<div>

### 🧠 設計のポイント

**IP アドレス範囲の重複回避**

- VNet-01: `10.1.0.0/16`
- VNet-02: `10.2.0.0/16`
- 範囲が重複しないように設計

**Peering 可能な条件**

- ✅ IP アドレス範囲が重複しない
- ✅ 同じ Azure サブスクリプション内
- ✅ 異なるリージョンでも可能（Global Peering）

**コスト考慮**

- 同一リージョン内: データ転送は安価
- 異なるリージョン間: データ転送コストが高い

</div>

</div>

---

## STEP 2-2: 2 つ目の VNet 作成（Portal）

Azure Portal で VNet-02 を作成します。

### 手順

1. **仮想ネットワークの作成**

   - Azure Portal で「仮想ネットワーク」を検索
   - 「+ 作成」をクリック

2. **基本タブ**

   - **リソース グループ**: `rg-network-handson`（既存を選択）
   - **名前**: `vnet-handson-02`
   - **地域**: `Japan East`

3. **IP アドレスタブ**

   - デフォルトのアドレス空間を削除
   - IPv4 アドレス空間: `10.2.0.0/16`
   - サブネット追加:
     - サブネット名: `subnet-app`
     - アドレス範囲: `10.2.1.0/24`

4. **確認および作成**
   - 「作成」をクリック

---

## STEP 2-3: 2 つ目の VNet 作成（CLI 版）

コマンドラインで同じ VNet を作成します。

```bash
# VNet-02 の作成
az network vnet create \
  --resource-group $RESOURCE_GROUP \
  --name $VNET_02 \
  --address-prefix 10.2.0.0/16 \
  --subnet-name subnet-app \
  --subnet-prefix 10.2.1.0/24 \
  --location japaneast

# 作成確認
az network vnet show \
  --resource-group $RESOURCE_GROUP \
  --name $VNET_02 \
  --query "{Name:name, AddressSpace:addressSpace.addressPrefixes}" \
  --output table
```

<div class="text-xs opacity-75 mt-4">
💡 `--query` オプションでJMESPath式を使い、必要な情報だけを表示できます
</div>

---

## STEP 2-4: VNet-02 に VM を作成 - Portal

2 つ目の VNet に VM を配置します。

1. **仮想マシンの作成**

   - 「+ 作成」→「Azure 仮想マシン」

2. **基本タブ**

   - **リソース グループ**: `rg-network-handson`
   - **仮想マシン名**: `vm-app`
   - **地域**: `Japan East`
   - **イメージ**: `Ubuntu Server 24.04 LTS - x64 Gen2`
   - **サイズ**: `Standard_B2s`
   - **ユーザー名**: `azureuser`
   - **パスワード**: 他の VM と同じパスワード

3. **ネットワークタブ**

   - **仮想ネットワーク**: `vnet-handson-02`
   - **サブネット**: `subnet-app (10.2.1.0/24)`
   - **パブリック IP**: (新規) `vm-app-ip`
   - **パブリック受信ポート**: SSH (22)

4. **作成**

---

## STEP 2-5: VNet-02 の VM 作成（CLI 版）

コマンドラインで VM を作成します。

```bash
# VM-app の作成
az vm create \
  --resource-group $RESOURCE_GROUP \
  --name vm-app \
  --location japaneast \
  --vnet-name $VNET_02 \
  --subnet subnet-app \
  --image Ubuntu2404 \
  --size Standard_B2s \
  --admin-username azureuser \
  --admin-password 'YourSecurePassword123!' \
  --public-ip-address vm-app-ip \
  --public-ip-sku Standard

# 作成したVMのIP確認
az vm show -d \
  --resource-group $RESOURCE_GROUP \
  --name vm-app \
  --query "{Name:name, PrivateIP:privateIps, PublicIP:publicIps}" \
  --output table
```

---

## STEP 2-6: Peering 前の通信確認

Peering 設定前に、VNet 間の通信を確認します。

<div class="grid grid-cols-2 gap-6 pt-4">
<div>

### 現在のネットワーク構成

- **VNet-01**: `10.1.0.0/16`
  - vm-frontend: `10.1.1.4`
  - vm-backend: `10.1.2.4`
- **VNet-02**: `10.2.0.0/16`
  - vm-app: `10.2.1.4`

</div>
<div>

### 通信テスト（失敗するはず）

```bash
# vm-frontend にSSH接続
ssh azureuser@<frontend-public-ip>

# vm-app へのping（タイムアウトするはず）
ping -c 4 10.2.1.4
```

**期待される結果:**

- ❌ タイムアウト（100% packet loss）
- 理由: 異なる VNet 間は、Peering なしでは通信不可

</div>
</div>

<div class="mt-4 bg-red-500/10 p-3 rounded text-sm">
⚠️ 現時点では、VNet間の通信はできません。次のステップでPeering設定を行います。
</div>

---

## STEP 2-7: VNet Peering の作成（Portal） - 1/2

VNet-01 から VNet-02 への Peering を設定します。

### 手順（VNet-01 → VNet-02）

1. **VNet-01 を開く**

   - Azure Portal で `vnet-handson-01` を検索して開く

2. **Peering メニューを開く**

   - 左メニュー「ピアリング」をクリック

3. **Peering 追加**

   - 「+ 追加」をクリック

4. **設定（This virtual network）**
   - **ピアリング リンク名**: `peer-vnet01-to-vnet02`
   - **リモート仮想ネットワークへのトラフィック**: 許可
   - **リモート仮想ネットワークから転送されたトラフィック**: 許可
   - **仮想ネットワーク ゲートウェイまたは Route Server**: なし

---

## STEP 2-8: VNet Peering の作成（Portal） - 2/2

続けてリモート側の設定を行います。

### 設定（Remote virtual network）

5. **リモート VNet の設定**

   - **ピアリング リンク名**: `peer-vnet02-to-vnet01`
   - **仮想ネットワークのデプロイ モデル**: Resource Manager
   - **サブスクリプション**: 使用中のサブスクリプション
   - **仮想ネットワーク**: `vnet-handson-02` を選択

6. **トラフィック設定（リモート側）**

   - **リモート仮想ネットワークへのトラフィック**: 許可
   - **リモート仮想ネットワークから転送されたトラフィック**: 許可
   - **仮想ネットワーク ゲートウェイまたは Route Server**: なし

7. **追加**
   - 「追加」をクリック
   - Peering 状態が「接続済み」になることを確認（約 1 分）

<div class="mt-4 bg-blue-500/10 p-3 rounded text-sm">
💡 Portalから作成すると、双方向のPeeringが自動的に作成されます。
</div>

---

## STEP 2-9: VNet Peering の作成（CLI 版）

コマンドラインで Peering を作成します。

```bash
# VNet-01 と VNet-02 のリソースIDを取得
VNET01_ID=$(az network vnet show \
  --resource-group $RESOURCE_GROUP \
  --name $VNET_01 \
  --query id --output tsv)

VNET02_ID=$(az network vnet show \
  --resource-group $RESOURCE_GROUP \
  --name $VNET_02 \
  --query id --output tsv)

# VNet-01 → VNet-02 の Peering
az network vnet peering create \
  --resource-group $RESOURCE_GROUP \
  --name peer-vnet01-to-vnet02 \
  --vnet-name $VNET_01 \
  --remote-vnet $VNET02_ID \
  --allow-vnet-access

# VNet-02 → VNet-01 の Peering
az network vnet peering create \
  --resource-group $RESOURCE_GROUP \
  --name peer-vnet02-to-vnet01 \
  --vnet-name $VNET_02 \
  --remote-vnet $VNET01_ID \
  --allow-vnet-access
```

---

## STEP 2-10: Peering 状態の確認

Peering が正しく設定されたか確認します。

<div class="grid grid-cols-2 gap-6 pt-4">
<div>

### Portal での確認

1. **VNet-01 の Peering 確認**

   - `vnet-handson-01` を開く
   - 左メニュー「ピアリング」をクリック
   - 状態が「接続済み」であることを確認

2. **VNet-02 の Peering 確認**
   - `vnet-handson-02` を開く
   - 左メニュー「ピアリング」をクリック
   - 状態が「接続済み」であることを確認

</div>
<div>

### CLI での確認

```bash
# Peering 状態確認
az network vnet peering list \
  --resource-group $RESOURCE_GROUP \
  --vnet-name $VNET_01 \
  --query "[].{Name:name, Status:peeringState, RemoteVNet:remoteVirtualNetwork.id}" \
  --output table

az network vnet peering list \
  --resource-group $RESOURCE_GROUP \
  --vnet-name $VNET_02 \
  --query "[].{Name:name, Status:peeringState, RemoteVNet:remoteVirtualNetwork.id}" \
  --output table
```

</div>
</div>

---

## STEP 2-11: Peering 後の通信確認

Peering 設定後の通信を確認します。

<div class="grid grid-cols-2 gap-6 pt-4">
<div>

### VNet-01 → VNet-02 の通信

```bash
# vm-frontend にSSH接続
ssh azureuser@<frontend-public-ip>

# vm-app への ping（成功するはず）
ping -c 4 10.2.1.4

# SSH接続確認
ssh azureuser@10.2.1.4
# パスワード入力後、接続できることを確認
```

</div>
<div>

### VNet-02 → VNet-01 の通信

```bash
# vm-app にSSH接続
ssh azureuser@<vm-app-public-ip>

# vm-frontend への ping
ping -c 4 10.1.1.4

# vm-backend への ping
ping -c 4 10.1.2.4
```

</div>
</div>

<div class="mt-4 bg-green-500/10 p-3 rounded text-sm">
✅ Peering設定後は、異なるVNet間でもプライベートIPで通信できます！
</div>

---

## STEP 2-12: Peering の帯域とレイテンシ確認

Peering 接続のパフォーマンス特性を確認します。

<div class="grid grid-cols-2 gap-6 pt-4">
<div>

### レイテンシ測定

```bash
# vm-frontend から vm-app へのレイテンシ
ping -c 10 10.2.1.4

# 結果例:
# 10 packets transmitted, 10 received, 0% packet loss
# rtt min/avg/max/mdev = 0.5/0.6/0.8/0.1 ms
```

</div>
<div>

### 帯域幅測定（iperf3 を使用）

```bash
# vm-app 側でサーバーモード起動
# （vm-appにSSH接続して実行）
sudo apt update && sudo apt install -y iperf3
iperf3 -s

# vm-frontend 側でクライアントモード実行
# （vm-frontendにSSH接続して実行）
sudo apt install -y iperf3
iperf3 -c 10.2.1.4 -t 10
```

**期待される結果:**

- レイテンシ: 1ms 未満（同一リージョン内）
- 帯域幅: VM サイズに応じた帯域（B2s で約 1Gbps 程度）

</div>
</div>

---

## STEP 2-13: Peering の非推移性を理解する

Peering は**非推移的**です。この重要な特性を理解します。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">

<div>

### 非推移的とは？

**シナリオ:**

- VNet-A と VNet-B が Peering
- VNet-B と VNet-C が Peering

**結果:**

- ❌ VNet-A と VNet-C は通信**できない**

これが Peering の**非推移性**です。

### 図解

```
VNet-A ←→ VNet-B ←→ VNet-C
  ↑                      ↑
  └──────────✗───────────┘
       直接通信不可
```

</div>

<div>

### 解決方法

**1. 直接 Peering**

- VNet-A と VNet-C を直接 Peering で接続

**2. ハブ&スポーク + NVA**

- VNet-B をハブとして、NVA（Network Virtual Appliance）でルーティング
- Azure Firewall や サードパーティ製品を使用

**3. VPN Gateway**

- VNet-B に VPN Gateway を配置
- ゲートウェイ転送を有効化

</div>

</div>

<div class="mt-4 bg-blue-500/10 p-3 rounded text-sm">
💡 ハブ&スポークトポロジは、大規模ネットワークで一般的な設計パターンです。
</div>

---

## STEP 2-14: ハブ&スポークトポロジ（参考）

エンタープライズでよく使われるハブ&スポーク構成を理解します。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">

<div>

### 構成図

```
     ┌─────────────┐
     │   Hub VNet  │
     │ (10.0.0.0/16)│
     │             │
     │ - Firewall  │
     │ - VPN GW    │
     │ - DNS       │
     └──────┬──────┘
            │
     ┌──────┴──────┐
     │             │
┌────▼────┐   ┌────▼────┐
│Spoke-01 │   │Spoke-02 │
│  VNet   │   │  VNet   │
│(Prod)   │   │(Dev)    │
└─────────┘   └─────────┘
```

</div>

<div>

### メリット

✅ **集中管理**

- ファイアウォール、VPN を集約
- セキュリティポリシーの一元管理

✅ **コスト効率**

- 共有サービスの効率的な利用
- ゲートウェイの重複配置が不要

✅ **スケーラビリティ**

- 新しい Spoke を簡単に追加

### デメリット

⚠️ **単一障害点**

- Hub が停止するとすべて影響

⚠️ **レイテンシ増加**

- Spoke 間通信が Hub 経由

</div>

</div>

---

## STEP 2-15: Global VNet Peering（参考）

異なるリージョン間の Peering について理解します。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">

<div>

### Global VNet Peering とは

- **異なるリージョン**間の VNet を接続
- Azure のグローバルバックボーンネットワークを使用
- 設定方法は同一リージョン Peering と同じ

### 特徴

- ✅ 低レイテンシ（Azure バックボーン使用）
- ✅ 高セキュリティ（プライベート接続）
- ✅ 高帯域幅
- ⚠️ データ転送コストが高い

</div>

<div>

### ユースケース

**グローバル展開**

- 複数リージョンでのアプリケーション配置
- 地理的冗長性の確保

**ディザスタリカバリ**

- プライマリリージョンと DR リージョンの接続
- データレプリケーション

**コンプライアンス**

- データ主権の要件に対応
- リージョンを跨いだデータアクセス

### コスト考慮

- 同一リージョン: 約 ¥1/GB
- Global Peering: 約 ¥8〜10/GB
- トラフィック量を事前に見積もる

</div>

</div>

---

## STEP 2-16: Peering のトラフィック制御オプション（1/2）

Peering の詳細設定オプションを理解します。

<div class="text-sm">

### 主要なオプション

| オプション                             | 説明                                     | デフォルト |
| -------------------------------------- | ---------------------------------------- | ---------- |
| **仮想ネットワークアクセスを許可する** | Peering 経由の通信を許可                 | 有効       |
| **転送されたトラフィックを許可する**   | 他 VNet から転送されたトラフィックを受信 | 無効       |
| **ゲートウェイ転送を許可する**         | 自分の VPN/ER Gateway を相手に使わせる   | 無効       |
| **リモートゲートウェイを使用する**     | 相手の VPN/ER Gateway を利用する         | 無効       |

</div>

---

## STEP 2-16: Peering のトラフィック制御オプション（2/2）

<div class="text-sm">

### 詳細説明

**転送されたトラフィックを許可する**

- ハブ&スポーク構成で必要
- Hub 側で有効化すると、Spoke 間通信が可能（NVA 経由）

**ゲートウェイ転送**

- Hub VNet に VPN Gateway がある場合
- Spoke VNet からオンプレミスへの接続を共有

</div>

---

## STEP 2-17: Peering の制限事項

VNet Peering の制限と注意点を理解します。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">

<div>

### 制限事項

**IP アドレス範囲**

- ❌ 重複するアドレス範囲は不可
- ❌ Peering 後のアドレス範囲変更は不可
- ✅ 事前の設計が重要

**Peering 数の上限**

- デフォルト: VNet あたり 500 Peering
- 上限緩和申請で最大 1,000 まで可能

**非推移性**

- ❌ A-B、B-C の Peering で A-C 通信不可
- ✅ 直接 Peering またはルーティング設定が必要

</div>

<div>

### 注意点

**帯域幅**

- Peering 自体に帯域制限なし
- VM サイズによる制限が適用

**レイテンシ**

- 同一リージョン: 1ms 未満
- Global Peering: リージョン間の距離に依存

**コスト**

- Ingress（受信）トラフィック: 無料
- Egress（送信）トラフィック: 課金対象
- Global Peering は高コスト

**削除**

- Peering は双方向で削除が必要
- 一方を削除しても、もう一方は残る

</div>

</div>

---

## STEP 2-18: VNet Peering のトラブルシューティング

Peering で問題が発生した場合の確認ポイントです。

**1. Peering 状態の確認**

```bash
az network vnet peering show \
  --resource-group $RESOURCE_GROUP \
  --vnet-name $VNET_01 \
  --name peer-vnet01-to-vnet02 \
  --query peeringState
```

期待値: `"Connected"`

**2. IP アドレス範囲の重複確認**

- VNet 間でアドレス範囲が重複していないか確認

**3. NSG のルール確認**

- NSG がトラフィックをブロックしていないか確認

**4. ルートテーブルの確認**

- カスタムルートが設定されている場合、正しくルーティングされているか確認

**5. 双方向の Peering 確認**

- 両方の VNet で Peering が設定されているか確認

---

## STEP 2-19: Effective Routes の確認

### Effective Routes（有効なルート）とは

<div class="grid grid-cols-2 gap-6 text-sm">

<div>

**概要**

- **Effective Routes** は、VM のネットワークインターフェイスに実際に適用されているすべてのルーティング情報
- Azure が自動的に作成するシステムルートと、ユーザーが定義するカスタムルートの組み合わせ
- トラフィックがどのように転送されるかを決定する

**確認できる情報:**

- 宛先アドレス範囲
- 次ホップの種類（VNet、VNet Peering、インターネット等）
- ルートの優先順位

</div>

<div>

**次ホップの種類**

| 種類                   | 説明                                 |
| ---------------------- | ------------------------------------ |
| **VNet ローカル**      | 同じ VNet 内への通信                 |
| **VNet peering**       | Peering 接続された VNet への通信     |
| **インターネット**     | インターネットへの通信               |
| **仮想アプライアンス** | NVA（Network Virtual Appliance）経由 |
| **None**               | トラフィックを破棄（ブラックホール） |

</div>

</div>

<div class="mt-4 bg-purple-500/10 p-3 rounded text-sm">
💡 <strong>トラブルシューティングのポイント:</strong> 
通信ができない場合、Effective Routes を確認することで、トラフィックが意図した経路を通っているか判断できます。
</div>

---

### Effective Routes の確認手順

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">

<div>

### Portal での確認

1. **ネットワークインターフェイスを開く**

   - `vm-frontend-nic` を検索して開く

2. **有効なルートを表示**
   - 左メニュー「ヘルプ」
   - 「有効なルート」をクリック

</div>

<div>

### 確認内容

Peering 設定後、以下のようなルートが追加されているはずです：

| アドレス    | 次ホップ種類   |
| ----------- | -------------- |
| 10.1.0.0/16 | VNet ローカル  |
| 10.2.0.0/16 | VNet peering   |
| 0.0.0.0/0   | インターネット |

</div>

</div>

<div class="mt-4 bg-blue-500/10 p-3 rounded text-sm">
💡 「VNet peering」タイプのルートが、Peering経由の通信を可能にしています。
</div>

---

## STEP 2-20: CLI での Effective Routes 確認

コマンドラインで Effective Routes を確認します。

```bash
# ネットワークインターフェイスのIDを取得
NIC_ID=$(az vm show \
  --resource-group $RESOURCE_GROUP \
  --name vm-frontend \
  --query "networkProfile.networkInterfaces[0].id" \
  --output tsv)

# Effective Routes を表示
az network nic show-effective-route-table \
  --ids $NIC_ID \
  --output table

# 特定のアドレスプレフィックスをフィルタ
az network nic show-effective-route-table \
  --ids $NIC_ID \
  --query "[?addressPrefix[?contains(@, '10.2')]]" \
  --output table
```

**期待される出力:**

```
Source    State    Address Prefix    Next Hop Type    Next Hop IP
--------  -------  ----------------  ---------------  -------------
Default   Active   10.2.0.0/16       VNetPeering
```

---

## ハンズオン ② のまとめ

VNet Peering の設定と動作を学びました。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">

<div>

### ✅ 達成したこと

- ✅ 2 つ目の VNet の設計・作成
- ✅ VNet Peering の双方向設定
- ✅ 異なる VNet 間の通信確認
- ✅ Peering のパフォーマンス測定
- ✅ 非推移性の理解
- ✅ Effective Routes の確認

</div>

<div>

### 🔑 重要なポイント

- **IP アドレス重複回避**: Peering 前の設計が重要
- **双方向設定**: 両方の VNet で Peering が必要
- **低レイテンシ**: Azure バックボーン使用
- **非推移性**: A-B、B-C でも A-C は不可
- **帯域幅**: VNet レベルの制限なし（VM サイズに依存）
- **コスト**: Egress トラフィックに課金

</div>

</div>

---

## 🧠 理解度チェック ② - 質問

ハンズオン ② の内容を理解できたか確認しましょう。

<div class="pt-4">

1. **VNet Peering を設定する際、IP アドレス範囲が重複していてもいいですか？**

2. **VNet Peering は片方向の設定だけで通信できますか？**

3. **Peering の「非推移性」とは何ですか？具体例を挙げて説明してください。**

4. **同一リージョン内の Peering と異なるリージョン間の Peering（Global Peering）の違いは何ですか？**

5. **Peering 後、VM に適用される有効なルート（Effective Routes）はどのように確認できますか？**

</div>

---

## 🧠 理解度チェック ② - 回答

1. **VNet Peering を設定する際、IP アドレス範囲が重複していてもいいですか？**

   - **いいえ。** IP アドレス範囲が重複していると、Peering 設定はできません。
   - 事前の設計でアドレス範囲の重複を避ける必要があります。

2. **VNet Peering は片方向の設定だけで通信できますか？**

   - **いいえ。** Peering は**双方向**で設定する必要があります。
   - A→B と B→A の両方の Peering を作成して初めて通信可能になります。
   - Azure Portal から作成すると、自動的に双方向の Peering が作成されます。

3. **Peering の「非推移性」とは何ですか？具体例を挙げて説明してください。**
   - VNet-A と VNet-B が Peering、VNet-B と VNet-C が Peering されていても、**VNet-A と VNet-C は直接通信できません**。
   - これを解決するには、A-C 間を直接 Peering するか、ハブ&スポークトポロジで NVA を使用します。

4. **同一リージョン内の Peering と異なるリージョン間の Peering（Global Peering）の違いは何ですか？**

   - **技術的には同じ設定方法**。ただし、Global Peering は**データ転送コストが高い**（約 8〜10 倍）。
   - レイテンシもリージョン間の距離に依存して増加します。

5. **Peering 後、VM に適用される有効なルート（Effective Routes）はどのように確認できますか？**
   - Azure Portal: ネットワークインターフェイス → 「サポート + トラブルシューティング」→「有効なルート」
   - CLI: `az network nic show-effective-route-table` コマンド
