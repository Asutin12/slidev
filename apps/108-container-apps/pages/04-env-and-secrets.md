---
layout: center
---

# ⚙️ ハンズオン ③

環境変数とシークレット管理

---

## ハンズオン ③ の概要

このハンズオンでは、Container Apps での環境変数とシークレットの管理方法を学びます。

<div class="pt-6">

### 🎯 学習目標

- 環境変数の設定方法を理解する
- シークレットの安全な管理方法を学ぶ
- Azure Key Vault との連携を習得する
- Revision による安全なデプロイを実践する

### 📋 実施内容

1. **環境変数の設定** - 基本的な環境変数の追加
2. **シークレットの管理** - 機密情報の安全な保存
3. **Key Vault 連携** - Azure Key Vault からのシークレット取得
4. **Revision 管理** - 設定変更と Revision の関係

</div>

---

## STEP 3-1: 環境変数の追加

Container App に環境変数を追加します。

```bash
# 環境変数の設定
az containerapp update \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --set-env-vars \
    APP_NAME="Hello Container App" \
    ENVIRONMENT="production" \
    LOG_LEVEL="info"

# 設定確認
az containerapp show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "properties.template.containers[0].env" \
  --output table
# 期待される出力
# Name         Value                   SecretRef
# -----------  ----------------------  -----------
# APP_NAME     Hello Container App     null
# ENVIRONMENT  production              null
# LOG_LEVEL    info                    null
```

<div class="mt-4 bg-blue-500/10 p-3 rounded text-sm">
💡 <strong>新しい Revision:</strong> 環境変数を変更すると、新しい Revision が自動的に作成されます。
</div>

---

### デプロイと確認

```bash
# イメージをビルド
docker buildx build --platform linux/amd64 -t todo-containerapp:v3 .

# タグ付けとプッシュ
docker tag todo-containerapp:v3 \
  ${ACR_NAME}.azurecr.io/todo-containerapp:v3
docker push ${ACR_NAME}.azurecr.io/todo-containerapp:v3

# Container App を更新
az containerapp update \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --image ${ACR_NAME}.azurecr.io/todo-containerapp:v3

# 動作確認
curl https://${APP_URL}/config
# 期待される出力
# {
#   "app": {
#     "name": "Hello Container App",
#     "environment": "production",
#     "logLevel": "info"
#   }
# }
```

---

## STEP 3-2: シークレットの追加

機密情報をシークレットとして保存します。

```bash
# シークレットの追加
az containerapp secret set \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --secrets \
    db-password='MySecurePassword123!' \
    api-key='sk-1234567890abcdef'

# シークレットの一覧表示
az containerapp secret list \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --output table

# 期待される出力
# Name          Value
# ------------  -----
# db-password   (hidden)
# api-key       (hidden)
```

<div class="mt-4 bg-yellow-500/10 p-3 rounded text-sm">
⚠️ <strong>セキュリティ:</strong> シークレットの値は表示されません。一度設定すると、CLI や Portal から値を確認することはできません。
</div>

---

## STEP 3-3: シークレットを環境変数として使用

シークレットを環境変数として参照します。

```bash
# シークレットを環境変数として設定
az containerapp update \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --set-env-vars \
    DB_PASSWORD=secretref:db-password \
    API_KEY=secretref:api-key

# 環境変数の確認
az containerapp show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "properties.template.containers[0].env" \
  --output table

# 期待される出力
# Name         Value        SecretRef
# -----------  -----------  -----------
# DB_PASSWORD  null         db-password
# API_KEY      null         api-key
```

<div class="mt-4 bg-blue-500/10 p-3 rounded text-sm">
💡 <strong>secretref:</strong> `secretref:` プレフィックスを使用すると、環境変数がシークレットを参照します。
</div>

---

## シークレットを使用したアプリケーション

### セキュリティのベストプラクティス

✅ **すべきこと**

- シークレットに機密情報を保存
- 環境変数で secretref を使用
- Key Vault を使用（後述）
- シークレットを定期的に更新

❌ **してはいけないこと**

- 環境変数に直接パスワードを設定
- コードにハードコードする
- ログに出力する
- 公開リポジトリに含める

```javascript
// ❌ 悪い例
console.log("Password:", process.env.DB_PASSWORD);

// ✅ 良い例
console.log("Database configured:", !!process.env.DB_PASSWORD);
```

---

## STEP 3-4: Azure Key Vault の作成

より安全な管理のため、Key Vault を使用します。

```bash
# Key Vault の作成
export KEYVAULT_NAME="kv-containerapps-${RANDOM}"

az keyvault create \
  --name $KEYVAULT_NAME \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --enable-rbac-authorization false

# シークレットの追加
az keyvault secret set \
  --vault-name $KEYVAULT_NAME \
  --name 'db-password' \
  --value 'MyVerySecurePassword456!'

az keyvault secret set \
  --vault-name $KEYVAULT_NAME \
  --name 'api-ke' \
  --value 'sk-9876543210fedcba'

# シークレットの確認
az keyvault secret list \
  --vault-name $KEYVAULT_NAME \
  --output table

# 期待される出力
# Name         Enabled
# -----------  ---------
# db-password  True
# api-key      True
```

---

## STEP 3-5: Managed Identity の設定

Container App に Managed Identity を割り当てます。

```bash
# Managed Identity を有効化
az containerapp identity assign \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --system-assigned

# Principal ID を取得
export PRINCIPAL_ID=$(az containerapp identity show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query principalId \
  --output tsv)

echo "Principal ID: $PRINCIPAL_ID"

# Key Vault へのアクセス権限を付与
az keyvault set-policy \
  --name $KEYVAULT_NAME \
  --object-id $PRINCIPAL_ID \
  --secret-permissions get list
```

<div class="mt-4 bg-blue-500/10 p-3 rounded text-sm">
💡 <strong>Managed Identity:</strong> Azure リソースに ID を割り当て、他の Azure サービスに安全にアクセスできるようにします。パスワード管理が不要です。
</div>

---

## STEP 3-6: Key Vault からのシークレット参照

Key Vault のシークレットを Container App で使用します。

```bash
# Key Vault の URI を取得
export KEYVAULT_URI=$(az keyvault show \
  --name $KEYVAULT_NAME \
  --query properties.vaultUri \
  --output tsv)

# シークレットの URI
export DB_PASSWORD_URI="${KEYVAULT_URI}secrets/db-password"
export API_KEY_URI="${KEYVAULT_URI}secrets/api-key"

# Container App のシークレットを Key Vault 参照に更新
az containerapp secret set \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --secrets \
    db-password=keyvaultref:${DB_PASSWORD_URI},identityref:system \
    api-key=keyvaultref:${API_KEY_URI},identityref:system

# 確認
az containerapp secret list \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP
```

<div class="mt-4 bg-blue-500/10 p-3 rounded text-sm">
💡 <strong>keyvaultref:</strong> Key Vault のシークレットを直接参照します。Container Apps が自動的に値を取得します。
</div>

---

## STEP 3-7: 環境変数の分類

環境変数を目的別に整理します。

<div class="grid grid-cols-3 gap-4 text-xs">

<div class="bg-blue-500/10 p-3 rounded">

#### 📋 設定情報

平文で問題ない設定

```bash
az containerapp update \
  --set-env-vars \
    APP_NAME="MyApp" \
    ENVIRONMENT="prod" \
    LOG_LEVEL="info" \
    REGION="japaneast"
```

**例:**

- アプリケーション名
- 環境名（dev/prod）
- ログレベル
- リージョン

</div>

<div class="bg-green-500/10 p-3 rounded">

#### 🔐 シークレット

機密情報

```bash
az containerapp secret set \
  --secrets \
    db-password="xxx" \
    api-key="yyy"

az containerapp update \
  --set-env-vars \
    DB_PASSWORD=secretref:db-password \
    API_KEY=secretref:api-key
```

**例:**

- パスワード
- API キー
- 証明書

</div>

<div class="bg-purple-500/10 p-3 rounded">

#### 🔑 Key Vault 参照

高セキュリティが必要

```bash
az containerapp secret set \
  --secrets \
    secret=keyvaultref:${URI}
```

**例:**

- 本番環境のパスワード
- 外部 API キー
- 暗号化キー

</div>

</div>

---

## STEP 3-8: Revision の動作確認

設定変更による Revision の作成を確認します。

```bash
# 現在の Revision 一覧
az containerapp revision list \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "[].{Name:name, Active:properties.active, CreatedTime:properties.createdTime}" \
  --output table

# 環境変数を変更
az containerapp update \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --set-env-vars VERSION="3.1"

# 新しい Revision が作成される
az containerapp revision list \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "[].{Name:name, Active:properties.active, CreatedTime:properties.createdTime}" \
  --output table

# 新しい Revision が追加されている
```

---

## STEP 3-9: Multiple Revision モードの有効化

複数の Revision を並行稼働させます。

```bash
# Multiple Revision モードに切り替え
az containerapp revision set-mode \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --mode multiple

# 確認
az containerapp show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "properties.configuration.activeRevisionsMode" \
  --output tsv

# 期待される出力: Multiple
```

<div class="mt-4 bg-blue-500/10 p-3 rounded text-sm">
💡 <strong>Multiple Revision モード:</strong> 複数の Revision を並行稼働させ、トラフィックを分割できます。Blue/Green デプロイや Canary リリースに使用します。
</div>

---

## STEP 3-10: トラフィック分割

複数の Revision にトラフィックを分割します。

<div class="grid grid-cols-2 gap-6 text-sm">

<div>

### Revision 名の取得

```bash
# 最新の2つの Revision を取得
export REVISIONS=$(az containerapp revision list \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "[0:2].name" \
  --output tsv)

export REV_NEW=$(echo $REVISIONS | awk '{print $1}')
export REV_OLD=$(echo $REVISIONS | awk '{print $2}')

echo "New Revision: $REV_NEW"
echo "Old Revision: $REV_OLD"
```

</div>

<div>

### トラフィックの分割

```bash
# 80% を新しい Revision、20% を古い Revision に割り当て
az containerapp ingress traffic set \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --revision-weight \
    ${REV_NEW}=80 \
    ${REV_OLD}=20

# 確認
az containerapp ingress traffic show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP
```

</div>

</div>

---

## トラフィック分割の確認

実際にトラフィックが分割されているか確認します。

```bash
# 複数回リクエストを送信
for i in {1..20}; do
  curl -s https://${APP_URL}/ | jq -r '.version, .hostname'
  echo "---"
  sleep 0.5
done

# 出力例
# 3.1                    ← 新しい Revision (80%)
# ca-todo-web--xxx-111
# ---
# 3.0                    ← 古い Revision (20%)
# ca-todo-web--xxx-222
# ---
# 3.1
# ca-todo-web--xxx-111
# ...

# 約 80% が新しい Revision、20% が古い Revision
```

---

## STEP 3-11: Canary リリース戦略

段階的にトラフィックを移行します。

<div class="grid grid-cols-4 gap-2 text-xs">

<div class="bg-blue-500/10 p-2 rounded">

#### ステージ 1

初期デプロイ

```bash
# 5% のみ新バージョン
az containerapp ingress traffic set \
  --revision-weight \
    ${REV_NEW}=5 \
    ${REV_OLD}=95
```

**検証:**

- エラー率
- レスポンス時間

</div>

<div class="bg-green-500/10 p-2 rounded">

#### ステージ 2

問題なければ拡大

```bash
# 25% に拡大
az containerapp ingress traffic set \
  --revision-weight \
    ${REV_NEW}=25 \
    ${REV_OLD}=75
```

**検証:**

- メトリクス監視
- ログ確認

</div>

<div class="bg-purple-500/10 p-2 rounded">

#### ステージ 3

さらに拡大

```bash
# 50% に拡大
az containerapp ingress traffic set \
  --revision-weight \
    ${REV_NEW}=50 \
    ${REV_OLD}=50
```

**検証:**

- パフォーマンス
- ユーザー報告

</div>

<div class="bg-orange-500/10 p-2 rounded">

#### ステージ 4

完全移行

```bash
# 100% 移行
az containerapp ingress traffic set \
  --revision-weight \
    ${REV_NEW}=100
```

**完了:**

- 古い Revision を非アクティブ化

</div>

</div>

---

## STEP 3-12: 緊急ロールバック

問題が発生した場合、即座にロールバックします。

```bash
# 新しい Revision で問題が発生した場合

# 1. 即座に古い Revision へ全トラフィックを戻す
az containerapp ingress traffic set \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --revision-weight ${REV_OLD}=100

# 2. 確認
curl https://${APP_URL}/

# 古い Revision のレスポンスが返ってくる

# 3. 問題のある Revision を非アクティブ化
az containerapp revision deactivate \
  --revision $REV_NEW \
  --resource-group $RESOURCE_GROUP

# 4. 原因を調査
az containerapp logs show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --revision $REV_NEW
```

<div class="mt-4 bg-green-500/10 p-3 rounded text-sm">
✅ <strong>即座にロールバック:</strong> トラフィックの切り替えのみなので、数秒で完了します。ダウンタイムはほぼありません。
</div>

---

## STEP 3-13: 環境変数の削除と更新

環境変数を削除または更新します。

<div class="grid grid-cols-2 gap-6 text-sm">

<div>

### 環境変数の削除

```bash
# 特定の環境変数を削除
az containerapp update \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --remove-env-vars LOG_LEVEL

# すべての環境変数を確認
az containerapp show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "properties.template.containers[0].env" \
  --output table
```

</div>

<div>

### 環境変数の更新

```bash
# 既存の環境変数を更新
az containerapp update \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --set-env-vars \
    ENVIRONMENT="staging" \
    VERSION="3.2"

# 更新確認
az containerapp show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "properties.template.containers[0].env[?name=='ENVIRONMENT']" \
  --output table
```

</div>

</div>

---

## STEP 3-14: シークレットの更新

シークレットを更新します（パスワード変更など）。

```bash
# シークレットの更新
az containerapp secret set \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --secrets \
    db-password="NewSecurePassword789!"

# 更新は即座に反映される（新しい Revision は作成されない）

# 確認（アプリケーションは新しいパスワードを使用）
curl https://${APP_URL}/status
```

<div class="mt-4 bg-blue-500/10 p-3 rounded text-sm">
💡 <strong>シークレットの更新:</strong> シークレットの更新は既存の Revision に反映されます。新しい Revision は作成されません。
</div>

---

## STEP 3-15: Configuration ファイルでの管理

YAML ファイルで設定を管理します。

<div class="text-sm">

### containerapp.yaml の作成

```yaml
properties:
  configuration:
    secrets:
      - name: db-password
        value: "MySecurePassword123!"
      - name: api-key
        keyVaultUrl: "https://kv-containerapps.vault.azure.net/secrets/api-key"
        identity: "system"
  template:
    containers:
      - name: todo-containerapp
        image: acrhandson.azurecr.io/todo-containerapp:v3
        env:
          - name: APP_NAME
            value: "Hello Container App"
          - name: ENVIRONMENT
            value: "production"
          - name: DB_PASSWORD
            secretRef: db-password
          - name: API_KEY
            secretRef: api-key
    scale:
      minReplicas: 0
      maxReplicas: 10
```

### 適用

```bash
# YAML から更新
az containerapp update \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --yaml containerapp.yaml
```

</div>

---

## ベストプラクティス

環境変数とシークレット管理のベストプラクティスです。

<div class="grid grid-cols-2 gap-6 text-xs">

<div>

### ✅ すべきこと

1. **シークレットを使用**

   - パスワード、API キーは必ずシークレットに保存

2. **Key Vault を使用**

   - 本番環境では Key Vault を使用
   - Managed Identity で安全にアクセス

3. **環境ごとに分離**

   - dev/staging/prod で異なる値を使用
   - Environment を分けることも検討

4. **定期的な更新**

   - パスワードやキーを定期的にローテーション
   - Key Vault の自動ローテーション機能を活用

5. **最小権限の原則**
   - 必要最小限のアクセス権限のみ付与

</div>

<div>

### ❌ してはいけないこと

1. **環境変数に直接パスワードを設定**

   ```bash
   # ❌ 悪い例
   --set-env-vars DB_PASSWORD="password123"

   # ✅ 良い例
   --set-env-vars DB_PASSWORD=secretref:db-password
   ```

2. **コードにハードコード**

   ```javascript
   // ❌ 悪い例
   const password = "password123";

   // ✅ 良い例
   const password = process.env.DB_PASSWORD;
   ```

3. **ログに出力**

   ```javascript
   // ❌ 悪い例
   console.log("Password:", process.env.DB_PASSWORD);

   // ✅ 良い例
   console.log("Database connected");
   ```

4. **公開リポジトリにコミット**
   - .env ファイルを .gitignore に追加
   - シークレットは別管理

</div>

</div>

---

## トラブルシューティング

よくある問題と解決方法です。

<div class="text-xs">

| 問題                           | 原因                    | 解決方法                                            |
| ------------------------------ | ----------------------- | --------------------------------------------------- |
| シークレットが取得できない     | Managed Identity 未設定 | Managed Identity を有効化し、Key Vault の権限を付与 |
| 環境変数が反映されない         | 古い Revision が稼働中  | 新しい Revision にトラフィックを向ける              |
| Key Vault からの取得エラー     | アクセス権限不足        | `az keyvault set-policy` で権限を付与               |
| シークレットの値が確認できない | セキュリティ仕様        | 正常動作、Key Vault の Portal で確認                |
| トラフィック分割が効かない     | Single Revision モード  | Multiple Revision モードに切り替え                  |

### デバッグコマンド

```bash
# 環境変数の確認
az containerapp show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "properties.template.containers[0].env"

# Managed Identity の確認
az containerapp identity show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP

# Key Vault のアクセスポリシー確認
az keyvault show-policy \
  --name $KEYVAULT_NAME
```

</div>

---

## まとめ

環境変数とシークレット管理を学びました。

<div class="grid grid-cols-2 gap-6 text-sm">

<div>

### 実施したこと

✅ **環境変数の管理**

- 基本的な環境変数の追加
- 環境変数の更新と削除

✅ **シークレット管理**

- シークレットの作成と使用
- Key Vault との連携
- Managed Identity の設定

✅ **Revision 管理**

- Multiple Revision モード
- トラフィック分割
- Canary リリース

</div>

<div>

### 次のステップ

次のハンズオンでは、スケーリングとオートスケールを学びます。

1. **HTTP ベースのスケーリング**
2. **KEDA によるイベント駆動スケーリング**
3. **カスタムメトリクスでのスケーリング**
4. **スケーリング動作の最適化**

</div>

</div>

<div class="mt-4 bg-green-500/10 p-3 rounded text-sm">
✅ <strong>環境変数とシークレット管理完了!</strong> 次のハンズオンでスケーリングを学びます。
</div>
