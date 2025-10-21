---
theme: "default"
style: "./style.css"
title: "Azure Network サービスハンズオン"
lang: "ja-JP"
drawings:
  enabled: true
highlighter: shiki
lineNumbers: false
info: |
  ## Azure Network サービスハンズオン

  VNet、VNet Peering、NSGを実践的に学び、
  Azureネットワーキングの基礎を理解するハンズオン資料です。
---

## Azure Network サービス<br>ハンズオン

実践で学ぶクラウドネットワーキング

<div class="pt-12">
  <span @click="$slidev.nav.next" class="px-2 py-1 rounded cursor-pointer" hover="bg-white bg-opacity-10">
    Press Space for next page <carbon:arrow-right class="inline"/>
  </span>
</div>

---

## 本日のアジェンダ

Azure Networkサービスを実践的に学び、クラウドでのネットワーク設計と運用の基礎を理解します。

<div class="pt-4">

### 基礎知識

- 🌐 **Azure Networkの全体像**
- 📋 **前提条件**

### 実践ハンズオン（3つ）

- 🏗️ **① VNet と VM**
  - 仮想ネットワークの構築とVM配置
- 🔗 **② VNet Peering**
  - VNet間接続とルーティング
- 🛡️ **③ NSG（Network Security Group）**
  - ネットワークセキュリティの設定

</div>

---
layout: center
---

# Azure Network サービス とは？

**仮想ネットワークを安全に、そして柔軟に構築するための<br>包括的なネットワーキングサービス**

---

## Azure Network サービスの魅力

Azure Network サービスは、仮想ネットワーク（VNet）を中心に、セキュリティ、DNS、負荷分散などを提供する**ネットワーキングプラットフォーム**です。
オンプレミスと同等以上のネットワーク機能を、クラウドの柔軟性とスケーラビリティで実現します。

<div class="grid grid-cols-2 gap-x-8 gap-y-4 pt-6">
<div class="bg-gray-500/10 p-4 rounded">

#### 🏗️ 柔軟な設計

IPアドレス範囲（CIDR）を自由に設計し、サブネット分割により用途別のネットワークセグメントを構築できます。

</div>
<div class="bg-gray-500/10 p-4 rounded">

#### 🔒 高度なセキュリティ

NSG（Network Security Group）により、サブネット・VM単位できめ細かいアクセス制御が可能。ファイアウォール機能も充実しています。

</div>
<div class="bg-gray-500/10 p-4 rounded">

#### 🌍 グローバル接続

VNet Peeringにより異なるVNet間を低レイテンシで接続。VPNやExpressRouteでオンプレミスとも統合できます。

</div>
<div class="bg-gray-500/10 p-4 rounded">

#### ⚖️ インテリジェントな負荷分散

Traffic Manager、Load Balancer、Application Gatewayなど、用途に応じた負荷分散ソリューションを提供します。

</div>
</div>

---

## Azure Network サービス概要

Azure が提供する主要なネットワークサービスを理解し、用途に応じた使い分けを学びます。

<div class="grid grid-cols-3 gap-4 pt-6 text-xs">
<div class="bg-blue-500/10 p-3 rounded">

#### 🏗️ Virtual Network（VNet）（ハンズオン）

<div class="mt-2">
<strong>用途：</strong>Azure上の仮想プライベートネットワーク<br>
<strong>特徴：</strong>IP範囲設計、サブネット分割、完全な分離環境
</div>
</div>
<div class="bg-green-500/10 p-3 rounded">

#### 🔗 VNet Peering（ハンズオン）

<div class="mt-2">
<strong>用途：</strong>VNet間の直接接続<br>
<strong>特徴：</strong>低レイテンシ、高帯域、リージョン間接続対応
</div>
</div>
<div class="bg-red-500/10 p-3 rounded">

#### 🛡️ NSG（Network Security Group）（ハンズオン）

<div class="mt-2">
<strong>用途：</strong>ネットワークレベルのアクセス制御<br>
<strong>特徴：</strong>ステートフルファイアウォール、優先順位ルール
</div>
</div>
<div class="bg-orange-500/10 p-3 rounded">

#### 🔄 Load Balancer（参考）

<div class="mt-2">
<strong>用途：</strong>Layer 4（TCP/UDP）負荷分散<br>
<strong>特徴：</strong>高スループット、低レイテンシ、内部/外部LB
</div>
</div>
<div class="bg-yellow-500/10 p-3 rounded">

#### 🌐 Application Gateway（参考）

<div class="mt-2">
<strong>用途：</strong>Layer 7（HTTP/HTTPS）負荷分散<br>
<strong>特徴：</strong>WAF統合、SSL終端、URLベースルーティング
</div>
</div>
<div class="bg-pink-500/10 p-3 rounded">

#### 🔐 Azure Firewall（参考）

<div class="mt-2">
<strong>用途：</strong>マネージド次世代ファイアウォール<br>
<strong>特徴：</strong>脅威インテリジェンス、FQDN filtering、集中管理
</div>
</div>
<div class="bg-indigo-500/10 p-3 rounded">

#### 🚪 VPN Gateway（参考）

<div class="mt-2">
<strong>用途：</strong>暗号化されたVPN接続<br>
<strong>特徴：</strong>Site-to-Site、Point-to-Site、VNet-to-VNet
</div>
</div>
</div>

---

## 各サービスの詳細説明（1/3）

### 🏗️ Virtual Network（VNet）

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

**どういうサービス？**

- Azure上に構築する論理的に分離されたプライベートネットワーク
- オンプレミスのネットワークと同様の設計思想で構築可能

**主な特徴：**

- 自由なIPアドレス範囲設計（RFC 1918準拠）
- サブネット分割による論理的なセグメント化
- Azure リソース（VM、App Service など）を配置する基盤
- インターネット、オンプレミス、他VNetとの接続制御

</div>
<div>

**何のため？**

- Azureリソースを安全に配置する基盤
- アプリケーション層、データ層など、用途別のネットワーク分離
- オンプレミスネットワークとのハイブリッド構成

**重要なポイント：**

- CIDR表記（例：10.0.0.0/16）でアドレス範囲を指定
- サブネットは必ず/29以上（最小5つのIPアドレス）
- Azureが予約する5つのIPアドレス（.0, .1, .2, .3, .255）

</div>
</div>

---

## 各サービスの詳細説明（2/3）

### 🔗 VNet Peering

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

**どういうサービス？**

- 2つのVNet間をAzureのバックボーンネットワークで直接接続
- VPNゲートウェイを使わずに低レイテンシで通信可能

**主な特徴：**

- 同一リージョン内のPeering（VNet Peering）
- 異なるリージョン間のPeering（Global VNet Peering）
- プライベートIPアドレスでの通信
- 帯域幅制限なし（VNetの帯域に依存）

</div>
<div>

**何のため？**

- マイクロサービス間の通信
- 開発環境と本番環境の分離と連携
- ハブ&スポークトポロジの構築

**重要なポイント：**

- 非推移的（A-B、B-CのPeeringがあってもA-Cは通信不可）
- IPアドレス範囲の重複は不可
- Peering接続は双方向で設定が必要

</div>
</div>

---

## 各サービスの詳細説明（3/3）

### 🛡️ NSG（Network Security Group）

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

**どういうサービス？**

- ネットワークトラフィックを制御するステートフルファイアウォール
- サブネットまたはネットワークインターフェース（NIC）に関連付け

**主な特徴：**

- Inbound/Outboundルールを個別に定義
- 5-tuple（送信元IP、送信先IP、プロトコル、送信元ポート、送信先ポート）で制御
- 優先度（100〜4096）でルール評価順序を制御
- デフォルトルール（削除不可、優先度65000以降）

</div>
<div>

**何のため？**

- 特定ポート（SSH、RDP、HTTPSなど）へのアクセス制限
- サブネット間の通信制御
- セキュリティ要件に基づくトラフィック制御

**重要なポイント：**

- ステートフル（戻りトラフィックは自動許可）
- 小さい優先度番号が先に評価される
- 最初にマッチしたルールが適用される

</div>
</div>

---

## 前提条件

このハンズオンを進めるために必要な環境とツールを確認します。

<div class="grid grid-cols-2 gap-6 pt-4">
<div>

### Azure アカウント

- ✅ **Azureサブスクリプション**
  - 無料試用版またはPay-As-You-Go
  - 管理者権限が必要
- ✅ **リソースグループ作成権限**

### 必要なツール

- ✅ **Azure Portal アクセス**
  - [https://portal.azure.com](https://portal.azure.com)
- ✅ **Azure CLI（推奨）**
  - バージョン 2.40以降
  - インストール：[Azure CLI ドキュメント](https://docs.microsoft.com/cli/azure/install-azure-cli)

</div>
<div>

### 知識要件

- ✅ **基本的なネットワーク知識**
  - IPアドレス、サブネット、CIDR表記
  - TCP/IPの基礎
  - DNSの仕組み
- ✅ **Azureの基礎**
  - リソースグループの概念
  - 基本的なポータル操作

</div>
</div>

---

## 料金について

このハンズオンで発生する料金の概算です。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">
<div class="bg-blue-500/10 p-4 rounded">

### 💰 推定料金

**ハンズオン全体：約 ¥300〜500 / 日**

- VM（B2s）× 3台：約¥300/日
- パブリックIP × 3個：約¥30/日
- VNet Peering（データ転送）：約¥50/日

<div class="mt-4 text-xs opacity-75">
※ 料金は2025年10月時点の東日本リージョン価格
</div>
</div>
<div class="bg-yellow-500/10 p-4 rounded">

### 💡 コスト削減のヒント

1. **使わない時はVMを停止**
   - 停止（割り当て解除）で課金停止
2. **ハンズオン終了後は必ず削除**
   - リソースグループごと削除が簡単
3. **小さいVMサイズを選択**
   - B1s/B2sで十分
4. **Public IPは必要最小限に**
   - Bastionを使えばVM用Public IPは不要

<div class="mt-4 text-xs opacity-75">
※ すべてのリソースを24時間稼働した場合の概算
</div>
</div>
</div>

---
src: ./pages/01-vnet-vm.md
---
---
src: ./pages/02-vnet-peering.md
---
---
src: ./pages/03-nsg.md
---
---
src: ./pages/99-summary.md
---
