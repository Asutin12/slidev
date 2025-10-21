---
theme: "default"
style: "./style.css"
title: "Azure DNS & Traffic Manager ハンズオン"
lang: "ja-JP"
drawings:
  enabled: true
highlighter: shiki
lineNumbers: false
info: |
  ## Azure DNS & Traffic Manager ハンズオン

  Azure DNS と Traffic Manager を実践的に学び、
  DNS管理とグローバルトラフィック分散の基礎を理解するハンズオン資料です。
---

## Azure DNS & Traffic Manager<br>ハンズオン

実践で学ぶ DNS とグローバルトラフィック分散

<div class="pt-12">
  <span @click="$slidev.nav.next" class="px-2 py-1 rounded cursor-pointer" hover="bg-white bg-opacity-10">
    Press Space for next page <carbon:arrow-right class="inline"/>
  </span>
</div>

---

## 本日のアジェンダ

Azure DNS と Traffic Manager を実践的に学び、DNS 管理とグローバルトラフィック分散の基礎を理解します。

<div class="pt-4">

### 基礎知識

- 🌐 **Azure DNS & Traffic Manager の全体像**
- 📋 **前提条件**

### 実践ハンズオン（2 つ）

- 📛 **① Azure DNS**
  - DNS ゾーンとレコード管理
- ⚖️ **② Traffic Manager**
  - グローバルトラフィック分散

</div>

---

## layout: center

# Azure DNS & Traffic Manager とは？

**DNS ホスティングとグローバルトラフィック分散を実現する<br>Azure のネットワーキングサービス**

---

## Azure DNS & Traffic Manager の魅力

Azure DNS は DNS ホスティングを、Traffic Manager はグローバルトラフィック分散を提供します。
両サービスを組み合わせることで、高可用性とパフォーマンスを実現できます。

<div class="grid grid-cols-2 gap-x-8 gap-y-4 pt-6">
<div class="bg-gray-500/10 p-4 rounded">

#### 📛 Azure DNS

高可用性な DNS ホスティングサービス。パブリック・プライベート両方の DNS ゾーンをサポート。

</div>
<div class="bg-gray-500/10 p-4 rounded">

#### ⚖️ Traffic Manager

DNS ベースのグローバルトラフィック分散。4 つのルーティング方式で柔軟なトラフィック制御。

</div>
<div class="bg-gray-500/10 p-4 rounded">

#### 🔗 シームレスな統合

Azure DNS と Traffic Manager を組み合わせて、カスタムドメインでグローバル負荷分散を実現。

</div>
<div class="bg-gray-500/10 p-4 rounded">

#### 🌍 高可用性

複数リージョンへの負荷分散と自動フェイルオーバーで、グローバルな高可用性を実現。

</div>
</div>

---

## サービス概要

Azure DNS と Traffic Manager の特徴を理解し、用途に応じた使い分けを学びます。

<div class="grid grid-cols-2 gap-4 pt-6 text-xs">
<div class="bg-purple-500/10 p-3 rounded">

#### 📛 Azure DNS

<div class="mt-2">
<strong>用途：</strong>DNSホスティングと名前解決<br>
<strong>特徴：</strong>高可用性、Azureインフラ統合、パブリック/プライベートゾーン
</div>

**主な機能：**

- パブリック・プライベート DNS ゾーン
- Alias レコード（Azure リソースと自動連携）
- DNSSEC 対応準備中
- VNet との統合

</div>
<div class="bg-cyan-500/10 p-3 rounded">

#### ⚖️ Traffic Manager

<div class="mt-2">
<strong>用途：</strong>DNSベースのグローバル負荷分散<br>
<strong>特徴：</strong>複数ルーティング方式、ヘルスチェック、自動フェイルオーバー
</div>

**主な機能：**

- 4 つのルーティング方式
- ヘルスチェックと自動フェイルオーバー
- Azure/外部/Nested エンドポイント
- カスタムドメイン対応

</div>
</div>

---

## Azure DNS の詳細

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

**どういうサービス？**

- Azure で提供される DNS ホスティングサービス
- Azure のインフラストラクチャを使用した高可用性 DNS

**主な特徴：**

- パブリック DNS ゾーンとプライベート DNS ゾーンの両方をサポート
- A、AAAA、CNAME、MX、TXT、SRV、PTR など主要レコードタイプ対応
- Azure リソースへのエイリアスレコード
- RBAC（Role-Based Access Control）による管理

</div>
<div>

**何のため？**

- カスタムドメインの DNS 管理
- Azure リソースへの名前解決
- VNet 内のプライベート DNS 解決

**重要なポイント：**

- ゾーン作成後、ドメインレジストラでネームサーバーを変更
- TTL（Time To Live）の適切な設定
- エイリアスレコードで IP アドレス変更に自動対応
- 168.63.129.16: Azure DNS リゾルバー

</div>
</div>

---

## Traffic Manager の詳細

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

**どういうサービス？**

- DNS ベースのグローバルトラフィック分散サービス
- 複数のエンドポイント間でトラフィックを最適に分散

**主な特徴：**

- 4 つのルーティング方式（Performance、Priority、Weighted、Geographic）
- ヘルスチェック機能による自動フェイルオーバー
- エンドポイントタイプ：Azure、External、Nested
- カスタムドメインを CNAME で設定可能

</div>
<div>

**何のため？**

- グローバルな高可用性の実現
- ユーザーに最も近いリージョンへのルーティング
- ディザスタリカバリ戦略の実装

**重要なポイント：**

- DNS 応答を返すだけ（プロキシではない）
- TTL が短いと頻繁な DNS クエリが発生
- ヘルスチェックの設定がフェイルオーバーの鍵
- Traffic Manager はトラフィックを経由しない

</div>
</div>

---

## 前提条件

このハンズオンを進めるために必要な環境とツールを確認します。

<div class="grid grid-cols-2 gap-6 pt-4">
<div>

### Azure アカウント

- ✅ **Azure サブスクリプション**
  - 無料試用版または Pay-As-You-Go
  - 管理者権限が必要
- ✅ **リソースグループ作成権限**

### 必要なツール

- ✅ **Azure Portal アクセス**
  - [https://portal.azure.com](https://portal.azure.com)
- ✅ **Azure CLI（推奨）**
  - バージョン 2.40 以降
  - インストール：[Azure CLI ドキュメント](https://docs.microsoft.com/cli/azure/install-azure-cli)

</div>
<div>

### 知識要件

- ✅ **基本的なネットワーク知識**
  - DNS の仕組み
  - IP アドレスの基礎
  - HTTP プロトコルの基礎
- ✅ **Azure の基礎**
  - リソースグループの概念
  - 基本的なポータル操作

### 推奨（必須ではない）

- 📝 所有ドメイン（テスト用）
- 🖥️ 既存の Azure リソース（VM、App Service など）

</div>
</div>

---

## 料金について

このハンズオンで発生する料金の概算です。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">
<div class="bg-blue-500/10 p-4 rounded">

### 💰 推定料金

**ハンズオン全体：約 ¥200〜300 / 日**

- Azure DNS：ほぼ無料（最初の 25 ゾーンまで）
- DNS クエリ：100 万クエリあたり約 ¥50
- Traffic Manager：約 ¥200/日（基本プロファイル）
- ヘルスチェック：含まれる

<div class="mt-4 text-xs opacity-75">
※ 料金は2025年10月時点の価格
</div>
</div>
<div class="bg-yellow-500/10 p-4 rounded">

### 💡 コスト削減のヒント

1. **ハンズオン終了後は必ず削除**
   - リソースグループごと削除が簡単
2. **DNS クエリを最小限に**
   - TTL を適切に設定
3. **Traffic Manager プロファイルの削除**
   - 使用しない場合は即座に削除
4. **無料枠の活用**
   - 最初の 25DNS ゾーンは無料

<div class="mt-4 text-xs opacity-75">
※ すべてのリソースを24時間稼働した場合の概算
</div>
</div>
</div>

---
src: ./pages/01-azure-dns.md
---
---
src: ./pages/02-traffic-manager.md
---
---
src: ./pages/99-summary.md
---
