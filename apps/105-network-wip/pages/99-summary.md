---
layout: center
---

# 全体の振り返り

<div class="grid grid-cols-2 gap-6 text-sm pt-4">
<div>

**ハンズオン ①：Azure DNS**

- パブリック・プライベート DNS ゾーン
- 各種 DNS レコード（A、CNAME、TXT、Alias）
- VNet との統合
- Split-horizon DNS
- 168.63.129.16: Azure DNS リゾルバー

**ハンズオン ②：Traffic Manager**

- グローバルトラフィック分散
- 4 つのルーティング方式
  - Performance、Priority、Weighted、Geographic
- ヘルスチェックと自動フェイルオーバー
- カスタムドメイン統合（オプション）
- DNS ベースの負荷分散

</div>

<div>

**共通スキル**

- Azure Portal と Azure CLI の両方での操作
- Infrastructure as Code の考え方
- トラブルシューティング手法
- ベストプラクティスの理解

**重要な概念**

- **DNS**: 名前解決の基盤
- **TTL**: キャッシュ期間の重要性
- **Alias**: Azure リソースとの自動連携
- **ヘルスチェック**: 自動障害検知
- **グローバル分散**: 高可用性の実現

</div>
</div>

---

## DNS と Traffic Manager の連携

学んだサービスがどう連携するかを理解しましょう。

<div class="text-sm pt-4">

```markdown
                    [ユーザー]
                        ↓
                 DNS クエリ
                        ↓
              [ドメインレジストラ]
                        ↓
                 NSレコード参照
                        ↓
                 [Azure DNS]
                  (example.com)
                        ↓
                 CNAMEレコード
                        ↓
            [Traffic Manager]
         (tm-dns-handson.trafficmanager.net)
                        ↓
         ルーティング方式に基づく判定
         (Performance/Priority/Weighted/Geographic)
                        ↓
         ヘルスチェックで正常なエンドポイントを選択
                        ↓
              IPアドレスを返却
                        ↓
         [エンドポイント①] or [エンドポイント②]
          (Japan East)      (Japan West)
```

</div>

---

## 重要な概念の復習 ①

<div class="grid grid-cols-2 gap-6 text-xs pt-4">
<div>

### DNS の基礎

**パブリック DNS ゾーン**

- インターネットからアクセス可能
- カスタムドメインのホスティング
- ドメインレジストラで NS レコード設定

**プライベート DNS ゾーン**

- VNet 内でのみ解決可能
- 内部サービスの名前解決
- 自動登録機能

**Alias レコード**

- Azure リソースの IP に自動追従
- ゾーン APEX（@）で使用可能
- IP アドレス管理の負担軽減

**TTL（Time To Live）**

- DNS キャッシュの有効期限
- 短い: 変更が早く反映、クエリ増加
- 長い: クエリ削減、変更反映遅延

</div>

<div>

### Traffic Manager の基礎

**4 つのルーティング方式**

1. **Performance**: 最も近いエンドポイント
2. **Priority**: 優先順位ベースのフェイルオーバー
3. **Weighted**: 重み付けによる分散
4. **Geographic**: 地理的位置ベースのルーティング

**ヘルスチェック**

- 定期的なエンドポイント監視
- HTTP 200 OK を期待
- 連続 3 回失敗で劣化判定
- 自動フェイルオーバー

**エンドポイントタイプ**

- **Azure**: Azure 内のリソース
- **External**: Azure 外の FQDN/IP
- **Nested**: 他の Traffic Manager プロファイル

</div>
</div>

---

## 重要な概念の復習 ②

<div class="grid grid-cols-2 gap-6 pt-4 text-xs">

<div>

### ベストプラクティス

**DNS 設計**

1. **ゾーンの分離**

   - 環境ごとにゾーン分割（prod、dev）
   - セキュリティドメインごとに分割

2. **命名規則**

   - 一貫性のある命名体系
   - 環境識別子の使用

3. **TTL 設定**

   - 本番環境: 長い TTL（3600-86400 秒）
   - 開発環境: 短い TTL（300-600 秒）
   - 変更前: TTL を短く設定

4. **Alias レコードの活用**
   - 可能な限り Alias レコードを使用
   - IP アドレス管理の自動化

</div>

<div>

### Traffic Manager 設計

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

</div>

---

## トラブルシューティング

<div class="grid grid-cols-2 gap-6 text-xs pt-4">
<div>

### DNS のトラブルシューティング

**1. ネームサーバーの確認**

```bash
dig example.com NS +short
# Azure DNSのNSが返ってくるか確認
```

**2. レコードの存在確認**

```bash
dig @ns1-xx.azure-dns.com www.example.com
# Azure DNSに直接クエリ
```

**3. TTL とキャッシュ**

```bash
dig www.example.com +noall +answer
# TTL確認

# キャッシュクリア（macOS/Linux）
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
```

**4. VNet リンクの確認**

```bash
az network private-dns link vnet list \
  --resource-group $RESOURCE_GROUP \
  --zone-name internal.contoso.com
```

</div>

<div>

### Traffic Manager のトラブルシューティング

**1. エンドポイント状態確認**

```bash
az network traffic-manager endpoint list \
  --resource-group $RESOURCE_GROUP \
  --profile-name $TM_NAME \
  --query "[].{Name:name, Status:endpointStatus, Monitor:endpointMonitorStatus}"
```

**2. ヘルスチェックの確認**

- エンドポイントが HTTP 200 を返しているか
- ヘルスチェックパスが正しいか
- ファイアウォール・NSG で許可されているか

**3. DNS 解決の確認**

```bash
dig $TM_NAME.trafficmanager.net

# TTL確認
dig $TM_NAME.trafficmanager.net +noall +answer
```

**4. ルーティングポリシーの確認**

- 期待通りのエンドポイントが返されているか
- ルーティング方式が正しく設定されているか

</div>
</div>

---

## layout: center

## 次のステップ：さらなる学習

---

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">
<div>

### より高度なネットワーク機能

**1. Azure Firewall**

- 集中管理型ファイアウォール
- FQDN フィルタリング
- 脅威インテリジェンス

**2. Application Gateway**

- Layer 7 ロードバランサー
- Web Application Firewall (WAF)
- SSL/TLS オフロード

**3. Azure Load Balancer**

- Layer 4 ロードバランサー
- 内部/外部負荷分散
- HA ポート

**4. VPN Gateway / ExpressRoute**

- オンプレミス接続
- サイト間 VPN
- 専用線接続

</div>

<div>

### 高度なアーキテクチャパターン

**5. Azure Front Door**

- グローバル HTTPS ロードバランサー
- CDN 統合
- WAF 機能

**6. Azure CDN**

- コンテンツ配信ネットワーク
- エッジキャッシング
- カスタムドメイン対応

**7. Private Endpoint / Private Link**

- PaaS サービスへのプライベート接続
- データ流出の防止

**8. Azure DNS Private Resolver**

- ハイブリッド DNS 解決
- オンプレミス統合

**9. Azure Bastion**

- セキュアな RDP/SSH 接続
- パブリック IP なしでのアクセス

</div>

</div>

---

## layout: center

# ありがとうございました！

Azure DNS & Traffic Manager ハンズオン完了
