---
layout: center
---

# 📈 ハンズオン ④

スケーリングとパフォーマンス

---

## ハンズオン ④ の概要

App Service のスケーリング機能とパフォーマンス最適化を学びます。

<div class="pt-6">

### 🎯 学習目標

- スケールアップとスケールアウトの違いを理解する
- Always On 設定の重要性を学ぶ
- デプロイスロットの活用方法を習得する
- オートスケールの設定を理解する

### 📋 実施内容

1. **スケールアップ** - App Service Plan の性能向上
2. **スケールアウト** - インスタンス数の増加
3. **Always On 設定** - アイドルタイムアウト対策
4. **デプロイスロット** - ステージング環境の活用
5. **オートスケール** - 自動スケーリングの設定

</div>

---

## スケールアップ vs スケールアウト

2 つのスケーリング方法の違いを理解します。

<div class="grid grid-cols-2 gap-6">
<div class="bg-blue-500/10 p-4 rounded">

### スケールアップ（Vertical Scaling）

**概要:**

- App Service Plan の SKU を変更
- より強力なインスタンスに変更

**例:**

- B1 → B2（メモリ 1.75GB → 3.5GB）
- B2 → S1（機能追加）

**効果:**

- CPU・メモリ性能向上
- 単一リクエストの処理速度向上

**用途:**

- メモリ不足の解消
- CPU intensive な処理

</div>
<div class="bg-green-500/10 p-4 rounded">

### スケールアウト（Horizontal Scaling）

**概要:**

- インスタンス数を増やす
- 負荷を複数インスタンスに分散

**例:**

- 1 インスタンス → 3 インスタンス
- 3 インスタンス → 10 インスタンス

**効果:**

- 同時リクエスト処理数の向上
- 可用性の向上（1 台障害でも稼働）

**用途:**

- トラフィック増加対応
- 高可用性の実現

</div>
</div>
<div class="mt-4 bg-blue-500/10 p-3 rounded text-xs">
💡 <strong>選択基準:</strong> 単一リクエストが遅い → スケールアップ、同時リクエスト数が多い → スケールアウト
</div>

---

## STEP 4-1: スケールアップ（Portal）

App Service Plan の SKU を変更します。

1. **App Service Plan を開く**

   - 作成した App Service Plan リソースを開く

2. **スケール アップを選択**

   - 左メニューの「設定」→「スケール アップ (App Service プラン)」

3. **価格レベルを選択**

   - **開発/テスト**: B1, B2, B3
   - **本番**: S1, S2, S3
   - **高性能**: P1v3, P2v3, P3v3

4. **例: B1 → B2 に変更**

   - B2 を選択
   - 「適用」をクリック

5. **確認**
   - 数分で変更が完了
   - アプリは継続して動作（ダウンタイムなし）

---

## STEP 4-2: スケールアップ（CLI）

CLI で App Service Plan をスケールアップします。

```bash
# 現在の SKU を確認
az appservice plan show \
  --name $PLAN_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "{Name:name, Sku:sku.name, Capacity:sku.capacity}" \
  --output table

# B1 → B2 にスケールアップ
az appservice plan update \
  --name $PLAN_NAME \
  --resource-group $RESOURCE_GROUP \
  --sku B2

# 変更確認
az appservice plan show \
  --name $PLAN_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "{Name:name, Sku:sku.name}" \
  --output table
# **期待される出力:**
# Name                  Sku
# --------------------  ----
# plan-container-taro   B2
```

---

## STEP 4-3: スケールアウト（Portal）

インスタンス数を増やします。

1. **App Service Plan を開く**

2. **スケール アウトを選択**

   - 左メニューの「設定」→「スケール アウト (App Service プラン)」

3. **手動スケールの設定**

   - 「手動スケール」を選択
   - **インスタンス数**: `2`
   - 「保存」をクリック

4. **確認**
   - 数分で追加インスタンスが起動
   - ロードバランサーが自動的にトラフィックを分散

<div class="mt-4 bg-yellow-500/10 p-3 rounded text-xs">
⚠️ <strong>料金注意:</strong> インスタンス数 × 料金が課金されます。B1プラン × 3インスタンス = ¥1,400 × 3 = ¥4,200/月
</div>

---

## STEP 4-4: スケールアウト（CLI）

CLI でインスタンス数を変更します。

```bash
# 現在のインスタンス数を確認
az appservice plan show \
  --name $PLAN_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "sku.capacity" \
  --output tsv

# インスタンス数を3に変更
az appservice plan update \
  --name $PLAN_NAME \
  --resource-group $RESOURCE_GROUP \
  --number-of-workers 2

# 変更確認
az appservice plan show \
  --name $PLAN_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "{Name:name, Sku:sku.name, Instances:sku.capacity}" \
  --output table

# App Service のインスタンス確認
az webapp list-instances \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --output table
```

---

## STEP 4-5: Always On の設定

アイドル状態でもアプリを起動し続ける設定です。

<div class="grid grid-cols-2 gap-6">
<div>

### Always On とは

**デフォルトの動作（Always On = Off）**

- 20 分間リクエストがないと停止
- 次のリクエストでコールドスタート
- 初回リクエストが遅い（数秒〜数十秒）

**Always On = On の場合**

- 常にアプリが起動状態
- コールドスタートなし
- 常に高速なレスポンス

**利用可能な Tier**

- Basic 以上（F1/D1 では使用不可）

</div>

<div>

### CLI での設定

```bash
# Always On を有効化
az webapp config set \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --always-on true

# 設定確認
az webapp config show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "alwaysOn" \
  --output tsv
# 期待される出力
# True
```

**Portal での設定:**

- 構成 → 全般設定 → Always On: `オン`

</div>

</div>

<div class="mt-4 bg-green-500/10 p-3 rounded text-xs">
✅ <strong>本番環境推奨:</strong> Always On は本番環境で必須です。ユーザーに快適な体験を提供できます。
</div>

---

## STEP 4-6: デプロイスロットの作成

ステージング環境を作成します。

<div class="text-sm">

```bash
# instanceを1つに戻す
az appservice plan update \
  --name $PLAN_NAME \
  --resource-group $RESOURCE_GROUP \
  --number-of-workers 1

# 確認
az appservice plan show \
  --name $PLAN_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "{Name:name, Sku:sku.name, Instances:sku.capacity}" \
  --output table

# デプロイスロットの作成（S1以上で利用可能）
# まずS1にスケールアップ
az appservice plan update \
  --name $PLAN_NAME \
  --resource-group $RESOURCE_GROUP \
  --sku S1

# ステージングスロットを作成
az webapp deployment slot create \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --slot staging

# スロット一覧を確認
az webapp deployment slot list \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --output table

# 期待される出力
# Name                            State    DefaultHostName
# ------------------------------  -------  -------------------------------------------
# app-container-taro-staging      Running  app-container-taro-staging.azurewebsites.net

# スロットに Managed Identity を割り当て
az webapp identity assign \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --slot staging

# Principal ID を取得
PRINCIPAL_ID=$(az webapp identity show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --slot staging \
  --query principalId -o tsv)

# ACR へのアクセス権限を付与
az role assignment create \
  --assignee $PRINCIPAL_ID \
  --role "AcrPull" \
  --scope $(az acr show --name $ACR_NAME --query id --output tsv)

# App Service の設定を更新
az webapp config set \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --slot staging \
  --generic-configurations '{"acrUseManagedIdentityCreds": true}'
```

</div>

---

## STEP 4-7: スロットへのデプロイとスワップ

ステージング環境で検証後、本番環境にスワップします。

```bash
# 新しいバージョンをビルド（ステージング用）
export IMAGE_TAG="v1.3"
docker buildx build --platform linux/amd64 -t $IMAGE_NAME:$IMAGE_TAG .
docker tag $IMAGE_NAME:$IMAGE_TAG $ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG
docker push $ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG

# 環境変数設定
az webapp config appsettings set \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --slot staging \
  --settings \
    NODE_ENV=production \
    LOG_LEVEL=info \
    API_BASE_URL=https://api.example.com \
    MAX_CONNECTIONS=100 \
    WEBSITES_PORT=3000

# ステージングスロットにイメージを設定
az webapp config container set \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --slot staging \
  --docker-custom-image-name $ACR_NAME.azurecr.io/$IMAGE_NAME:v1.3

# ステージング環境の URL を確認
echo "https://$APP_NAME-staging.azurewebsites.net"

# ステージング環境でテスト
curl https://$APP_NAME-staging.azurewebsites.net

# 問題なければ本番とスワップ
az webapp deployment slot swap \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --slot staging \
  --target-slot production

# スワップは数秒で完了（時間かかることもある）、ダウンタイムなし
```

<div class="mt-4 bg-blue-500/10 p-3 rounded text-xs">
💡 <strong>ゼロダウンタイム:</strong> スロットスワップは、トラフィックを徐々に切り替えるため、ダウンタイムがありません。
</div>

---

## オートスケールの設定 - S1 以上（参考）

トラフィックに応じて自動的にスケールアウトします。

```bash
# まず App Insights を有効化（メトリクス収集用）
az monitor app-insights component create \
  --app $APP_NAME-insights \
  --location $LOCATION \
  --resource-group $RESOURCE_GROUP

# App Insights のインストルメンテーションキーを取得
export INSTRUMENTATION_KEY=$(az monitor app-insights component show \
  --app $APP_NAME-insights \
  --resource-group $RESOURCE_GROUP \
  --query instrumentationKey \
  --output tsv)

# App Service に App Insights を設定
az webapp config appsettings set \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --settings \
    APPINSIGHTS_INSTRUMENTATIONKEY=$INSTRUMENTATION_KEY \
    APPLICATIONINSIGHTS_CONNECTION_STRING="InstrumentationKey=$INSTRUMENTATION_KEY"
```

---

## オートスケールルールの作成（参考）

CPU 使用率に基づいてスケールアウトします。

```bash
# オートスケール設定の作成
az monitor autoscale create \
  --resource-group $RESOURCE_GROUP \
  --resource $PLAN_NAME \
  --resource-type Microsoft.Web/serverfarms \
  --name autoscale-$PLAN_NAME \
  --min-count 1 \
  --max-count 5 \
  --count 1

# CPU 使用率 > 70% でスケールアウト
az monitor autoscale rule create \
  --resource-group $RESOURCE_GROUP \
  --autoscale-name autoscale-$PLAN_NAME \
  --condition "CpuPercentage > 70 avg 1m" \
  --scale out 1

# CPU 使用率 < 30% でスケールイン
az monitor autoscale rule create \
  --resource-group $RESOURCE_GROUP \
  --autoscale-name autoscale-$PLAN_NAME \
  --condition "CpuPercentage < 30 avg 1m" \
  --scale in 1

# 設定確認
az monitor autoscale show \
  --name autoscale-$PLAN_NAME \
  --resource-group $RESOURCE_GROUP \
  --output table
```

---

## 負荷テストでスケーリングを確認（参考）

<div class="grid grid-cols-2 gap-6">
<div>

### 負荷をかけてオートスケールの動作確認します。

```bash
# Apache Bench で負荷テスト（10同時接続、100リクエスト）
END=$((SECONDS+300))  # 5分 = 300秒
while [ $SECONDS -lt $END ]; do
  ab -n 10 -c 10 https://$APP_NAME.azurewebsites.net/ >/dev/null 2>&1
done

# または wrk で負荷テスト（より高負荷）
# wrk -t4 -c50 -d60s https://$APP_NAME.azurewebsites.net/

# メトリクスで CPU 使用率を確認
az monitor metrics list \
  --resource $(az appservice plan show \
    --name $PLAN_NAME \
    --resource-group $RESOURCE_GROUP \
    --query id --output tsv) \
  --metric "CpuPercentage" \
  --start-time $(date -u -v -10M '+%Y-%m-%dT%H:%M:%SZ') \
  --interval 1m \
  --output table

# インスタンス数の変化を確認
az appservice plan show \
  --name $PLAN_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "sku.capacity" \
  --output tsv
```
</div>
<div>

### メトリクスとインスタンス数の確認

CLI での即時反映は難しいため、スケーリングの動きを確認するには ポータルの Metrics Explorer が推奨です。

**確認手順**
- Azure Portal で対象の App Service Plan を開く
- 左側メニューから Metrics を選択
- Metric Namespace を「App Service Plan」に設定
- CPU Percentage を選択し、期間を 5〜10 分に設定
- グラフ上でスケールアウト・スケールインのタイミングを確認
- インスタンス数の変化も同様に Instance Count で確認可能

</div>
</div>

---

## スロット設定の管理（参考）

スロットごとに異なる設定を管理します。

```bash
# 本番環境とステージング環境で異なる設定
# ステージング環境の設定
az webapp config appsettings set \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --slot staging \
  --settings \
    NODE_ENV=staging \
    API_BASE_URL=https://staging-api.example.com \
  --slot-settings NODE_ENV API_BASE_URL  # スロットに固定

# 本番環境の設定
az webapp config appsettings set \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --settings \
    NODE_ENV=production \
    API_BASE_URL=https://api.example.com

# スワップしても、NODE_ENVとAPI_BASE_URLはスロットに固定される
```

<div class="mt-4 bg-yellow-500/10 p-3 rounded text-xs">
⚠️ <strong>Slot Settings:</strong> `--slot-settings` で指定した設定は、スロットスワップ時に移動しません。環境固有の設定に使用します。
</div>

---

## STEP 4-8: パフォーマンス監視

App Service のパフォーマンスメトリクスを確認します。

```bash
# 過去1時間のCPU使用率
az monitor metrics list \
  --resource $(az appservice plan show \
    --name $PLAN_NAME \
    --resource-group $RESOURCE_GROUP \
    --query id --output tsv) \
  --metric "CpuPercentage" \
  --start-time $(date -u -v -10M '+%Y-%m-%dT%H:%M:%SZ') \
  --interval 1m \
  --output table

# メモリ使用量
az monitor metrics list \
  --resource $(az webapp show \
    --name $APP_NAME \
    --resource-group $RESOURCE_GROUP \
    --query id --output tsv) \
  --metric "MemoryWorkingSet" \
  --start-time $(date -u -v -10M '+%Y-%m-%dT%H:%M:%SZ') \
  --interval 5m \
  --output table

# HTTP リクエスト数
az monitor metrics list \
  --resource $(az webapp show \
    --name $APP_NAME \
    --resource-group $RESOURCE_GROUP \
    --query id --output tsv) \
  --metric "Requests" \
  --start-time $(date -u -v -10M '+%Y-%m-%dT%H:%M:%SZ') \
  --interval 5m \
  --output table
```

---

## ハンズオン ④ のまとめ

<div class="grid grid-cols-2 gap-6">
<div>

### ✅ 達成したこと

- ✅ スケールアップ・アウトの実践
- ✅ Always On の設定
- ✅ デプロイスロットの作成と使用
- ✅ オートスケールの設定
- ✅ パフォーマンス監視
- ✅ 複数人実施時の注意点理解

</div>
<div>

### 🔑 重要なポイント

- **スケールアップ**
  - 性能向上（CPU・メモリ）
- **スケールアウト**
  - 同時リクエスト処理数増加
  - 料金 × インスタンス数
- **Always On**
  - 本番環境で必須
  - Basic 以上で利用可能
- **デプロイスロット**
  - ゼロダウンタイムデプロイ
  - S1 以上で利用可能
- **オートスケール**
  - トラフィックに応じて自動調整

</div>
</div>
<div class="mt-4 bg-green-500/10 p-3 rounded text-sm">
✅ <strong>次のステップ:</strong> セキュリティ構成（HTTPS、Managed Identity、VNet統合）を学びます。
</div>
