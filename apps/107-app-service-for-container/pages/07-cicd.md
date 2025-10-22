---
layout: center
---

# 🔄 ハンズオン ⑦

CI/CD による自動デプロイ

---

## ハンズオン ⑦ の概要

GitHub Actions を使って自動デプロイパイプラインを構築します。

<div class="pt-6">

### 🎯 学習目標

- GitHub Actions の基本を理解する
- ACR へのイメージビルド・プッシュを自動化する
- App Service への自動デプロイを設定する
- ゼロダウンタイムデプロイを実現する

### 📋 実施内容

1. **GitHub リポジトリの準備** - ソースコードの管理
2. **GitHub Actions ワークフローの作成** - CI/CD パイプライン
3. **ACR への自動ビルド** - コンテナイメージの自動作成
4. **App Service への自動デプロイ** - アプリケーションの更新
5. **デプロイスロットでの Blue/Green デプロイ** - ゼロダウンタイム

</div>

---

## CI/CD パイプラインの全体像

自動デプロイの流れを理解します。

1. コードを GitHub にプッシュ
2. GitHub Actions が自動起動
3. Docker イメージをビルド
4. ACR にプッシュ
5. ステージングスロットにデプロイ
6. テスト成功後、本番にスワップ

---

## STEP 7-1: GitHub リポジトリの準備

ソースコードを GitHub で管理します。

```bash
# サンプルアプリのディレクトリに移動
cd container-handson

# Git リポジトリを初期化
git init
git branch -M main

# .gitignore を作成
cat > .gitignore << 'EOF'
node_modules/
*.log
.env
.DS_Store
EOF

# 初回コミット
git add .
git commit -m "Initial commit: Node.js container app"

# GitHub にリポジトリを作成（GitHub CLI または Web UI）
# gh repo create container-handson --public --source=. --remote=origin --push

# または、既存のリポジトリにプッシュ
# git remote add origin https://github.com/<your-username>/container-handson.git
# git push -u origin main
```

---

## STEP 7-2: Service Principal の作成

GitHub Actions が Azure にアクセスするための認証情報を作成します。

```bash
# Service Principal を作成
az ad sp create-for-rbac \
  --name "github-actions-$APP_NAME" \
  --role contributor \
  --scopes /subscriptions/$(az account show --query id --output tsv)/resourceGroups/$RESOURCE_GROUP \
  --sdk-auth

# 出力される JSON を保存（GitHub Secrets に登録）
{
  "clientId": "<client-id>",
  "clientSecret": "<client-secret>",
  "subscriptionId": "<subscription-id>",
  "tenantId": "<tenant-id>",
  ...
}
```

<div class="mt-4 bg-yellow-500/10 p-3 rounded text-xs">
⚠️ <strong>重要:</strong> この JSON は GitHub Secrets に保存します。絶対にコードにコミットしないでください。
</div>

---

## STEP 7-3: GitHub Secrets の設定

1. **リポジトリの Settings を開く**

   - GitHub リポジトリページで「Settings」タブ

2. **Secrets and variables を開く**

   - 左メニューの「Secrets and variables」→「Actions」

3. **New repository secret をクリック**

4. **以下のシークレットを追加:**

   ```
   Name: AZURE_CREDENTIALS
   Value: <Service Principalの出力JSON全体>

   Name: ACR_NAME
   Value: acrhandsontaro01

   Name: ACR_USERNAME
   Value: acrhandsontaro01

   Name: ACR_PASSWORD
   Value: <ACRのパスワード>

   Name: APP_NAME
   Value: app-container-taro

   Name: RESOURCE_GROUP
   Value: rg-container-handson-taro
   ```

---

## STEP 7-4: GitHub Actions ワークフローの作成（基本）

```bash
# .github/workflows ディレクトリを作成
mkdir -p .github/workflows
```

**.github/workflows/deploy.yml**

```yaml
name: Build and Deploy to App Service

on:
  push:
    branches: [main]
  workflow_dispatch:

env:
  IMAGE_NAME: sample-app
  IMAGE_TAG: ${{ github.sha }}

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Log in to Azure Container Registry
        uses: docker/login-action@v2
        with:
          registry: ${{ secrets.ACR_NAME }}.azurecr.io
          username: ${{ secrets.ACR_USERNAME }}
          password: ${{ secrets.ACR_PASSWORD }}

      - name: Build and push Docker image
        uses: docker/build-push-action@v4
        with:
          context: .
          push: true
          tags: |
            ${{ secrets.ACR_NAME }}.azurecr.io/${{ env.IMAGE_NAME }}:${{ env.IMAGE_TAG }}
            ${{ secrets.ACR_NAME }}.azurecr.io/${{ env.IMAGE_NAME }}:latest

      - name: Azure Login
        uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}

      - name: Deploy to App Service
        uses: azure/webapps-deploy@v2
        with:
          app-name: ${{ secrets.APP_NAME }}
          images: ${{ secrets.ACR_NAME }}.azurecr.io/${{ env.IMAGE_NAME }}:${{ env.IMAGE_TAG }}
```

---

## STEP 7-5: ワークフローのコミットとプッシュ

作成したワークフローを GitHub にプッシュします。

```bash
# ワークフローファイルを追加
git add .github/workflows/deploy.yml
git commit -m "Add GitHub Actions workflow for CI/CD"
git push origin main

# GitHub Actions が自動的に起動
# リポジトリの "Actions" タブで確認可能
```

<div class="mt-4 bg-green-500/10 p-3 rounded text-xs">
✅ <strong>自動デプロイ開始:</strong> main ブランチにプッシュすると自動的にビルド・デプロイが実行されます。
</div>

---

## STEP 7-6: デプロイスロットを使った Blue/Green デプロイ

ゼロダウンタイムデプロイを実現する高度なワークフローです。

<div class="text-xs">

**.github/workflows/deploy-with-slot.yml**

```yaml
name: Blue-Green Deploy with Staging Slot

on:
  push:
    branches: [main]

env:
  IMAGE_NAME: sample-app
  IMAGE_TAG: ${{ github.sha }}

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Log in to ACR
        uses: docker/login-action@v2
        with:
          registry: ${{ secrets.ACR_NAME }}.azurecr.io
          username: ${{ secrets.ACR_USERNAME }}
          password: ${{ secrets.ACR_PASSWORD }}

      - name: Build and push
        uses: docker/build-push-action@v4
        with:
          context: .
          push: true
          tags: ${{ secrets.ACR_NAME }}.azurecr.io/${{ env.IMAGE_NAME }}:${{ env.IMAGE_TAG }}

  deploy-to-staging:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: Azure Login
        uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}

      - name: Deploy to Staging Slot
        uses: azure/webapps-deploy@v2
        with:
          app-name: ${{ secrets.APP_NAME }}
          slot-name: staging
          images: ${{ secrets.ACR_NAME }}.azurecr.io/${{ env.IMAGE_NAME }}:${{ env.IMAGE_TAG }}

      - name: Test Staging
        run: |
          sleep 30  # コンテナ起動を待つ
          curl -f https://${{ secrets.APP_NAME }}-staging.azurewebsites.net/health || exit 1
```

</div>

---

## STEP 7-7: Blue/Green デプロイ（続き）

テスト成功後、本番環境にスワップします。

<div class="text-xs">

```yaml
swap-to-production:
  needs: deploy-to-staging
  runs-on: ubuntu-latest
  environment:
    name: production
    url: https://${{ secrets.APP_NAME }}.azurewebsites.net
  steps:
    - name: Azure Login
      uses: azure/login@v1
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}

    - name: Swap Staging to Production
      run: |
        az webapp deployment slot swap \
          --name ${{ secrets.APP_NAME }} \
          --resource-group ${{ secrets.RESOURCE_GROUP }} \
          --slot staging \
          --target-slot production

    - name: Verify Production
      run: |
        sleep 10
        curl -f https://${{ secrets.APP_NAME }}.azurewebsites.net/health || exit 1

    - name: Notify Success
      if: success()
      run: echo "✅ Deployment successful!"

    - name: Rollback on Failure
      if: failure()
      run: |
        echo "❌ Deployment failed, rolling back..."
        az webapp deployment slot swap \
          --name ${{ secrets.APP_NAME }} \
          --resource-group ${{ secrets.RESOURCE_GROUP }} \
          --slot production \
          --target-slot staging
```

</div>

---

## STEP 7-8: Pull Request でのテストデプロイ

PR ごとに一時的な環境を作成してテストします。

<div class="text-xs">

```yaml
name: PR Preview Deploy

on:
  pull_request:
    branches: [main]

jobs:
  preview:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Set PR number
        run: echo "PR_NUMBER=${{ github.event.pull_request.number }}" >> $GITHUB_ENV

      - name: Build and push
        uses: docker/build-push-action@v4
        with:
          tags: ${{ secrets.ACR_NAME }}.azurecr.io/${{ env.IMAGE_NAME }}:pr-${{ env.PR_NUMBER }}

      - name: Deploy to Preview Slot
        run: |
          # PR番号ごとのスロットを作成（初回のみ）
          az webapp deployment slot create \
            --name ${{ secrets.APP_NAME }} \
            --resource-group ${{ secrets.RESOURCE_GROUP }} \
            --slot pr-${{ env.PR_NUMBER }} || true

          # デプロイ
          az webapp config container set \
            --name ${{ secrets.APP_NAME }} \
            --resource-group ${{ secrets.RESOURCE_GROUP }} \
            --slot pr-${{ env.PR_NUMBER }} \
            --docker-custom-image-name ${{ secrets.ACR_NAME }}.azurecr.io/${{ env.IMAGE_NAME }}:pr-${{ env.PR_NUMBER }}

      - name: Comment PR
        uses: actions/github-script@v6
        with:
          script: |
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: '✅ Preview deployed to: https://${{ secrets.APP_NAME }}-pr-${{ env.PR_NUMBER }}.azurewebsites.net'
            })
```

</div>

---

## STEP 7-9: ロールバック戦略

デプロイに問題があった場合の復旧方法です。

<div class="grid grid-cols-2 gap-6">
<div>

### 方法 1: スロットスワップで即座に戻す

```bash
# 本番とステージングを再度スワップ
az webapp deployment slot swap \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --slot production \
  --target-slot staging

# 数秒で前のバージョンに戻る
```

### 方法 2: 特定のイメージタグにロールバック

```bash
# 以前のイメージタグを指定
az webapp config container set \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --docker-custom-image-name $ACR_NAME.azurecr.io/$IMAGE_NAME:v1.0

az webapp restart --name $APP_NAME --resource-group $RESOURCE_GROUP
```

</div>
<div>

### 方法 3: Git でリバート後、再デプロイ

```bash
git revert <commit-hash>
git push origin main
# GitHub Actions が自動的に前のバージョンをデプロイ
```

</div>
</div>

---

## ハンズオン ⑦ のまとめ

<div class="grid grid-cols-2 gap-6">
<div>

### ✅ 達成したこと

- ✅ GitHub Actions ワークフローの作成
- ✅ ACR への自動ビルド・プッシュ
- ✅ App Service への自動デプロイ
- ✅ Blue/Green デプロイの実装
- ✅ PR プレビュー環境の構築
- ✅ キャッシュによる高速化
- ✅ ロールバック戦略の理解

</div>
<div>

### 🔑 重要なポイント

- **自動化の価値**
  - 手動デプロイのミス削減 / デプロイ頻度の向上
- **GitHub Secrets**
  - 認証情報の安全な管理
- **Blue/Green デプロイ**
  - ゼロダウンタイム
  - 簡単なロールバック
- **キャッシュ活用**
  - ビルド時間短縮
  - CI/CD パイプライン高速化
- **PR プレビュー**
  - レビュー前に動作確認
  - 品質向上

</div>
</div>
