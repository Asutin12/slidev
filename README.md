# Slidev Presentations - Monorepo

このリポジトリは複数のSlidevプレゼンテーションを管理するモノレポ構成になっています。

## 📁 プロジェクト構造

```
.
├── apps/               # 各スライドプロジェクト
│   ├── 00-cursor/
│   ├── 01-init/
│   ├── 02-eks-hands-on/
│   ├── 03-eks-automode-hands-on/
│   ├── 04-todo-app/
│   ├── 100-service-list/
│   ├── 101-app-service/
│   ├── 102-database/
│   └── lt-00/
├── packages/           # 共有パッケージ
│   ├── templates/      # カスタムテンプレート
│   └── theme/          # カスタムテーマ
└── dist/               # ビルド出力先
```

## 🚀 セットアップ

依存関係のインストール：

```bash
pnpm install
```

## 🛠️ 開発

### 特定のスライドを開発モードで起動

```bash
cd apps/01-init
pnpm run dev
```

または、ルートディレクトリから：

```bash
pnpm run --filter 01-init dev
```

### 全スライドをビルド

```bash
pnpm run build
```

これは `pnpm run -r build` を実行し、すべてのワークスペースのビルドスクリプトを並列実行します。

### PDFエクスポート

全スライドをPDF化：

```bash
pnpm run export
```

特定のスライドだけをPDF化：

```bash
pnpm run --filter 01-init export
```

## 📤 Cloudflare Pages へのデプロイ

### 方法1: GitHub経由で自動デプロイ（推奨）

1. GitHubリポジトリにプッシュ
2. [Cloudflare Dashboard](https://dash.cloudflare.com/) にログイン
3. **Workers & Pages** → **Create application** → **Pages** → **Connect to Git**
4. リポジトリを選択して以下の設定を行う：

**ビルド設定:**

- **Framework preset**: `None`
- **Build command**: `pnpm run build`
- **Build output directory**: `dist`
- **Root directory**: `/`（デフォルト）

**環境変数:**

- `NODE_VERSION`: `20`

5. **Save and Deploy** をクリック

### 方法2: Wrangler CLI でデプロイ

```bash
# ログイン
pnpm wrangler login

# ビルド
pnpm run build

# デプロイ
pnpm wrangler pages deploy dist --project-name=your-project-name
```

## 🌐 デプロイ後のアクセス

デプロイが完了すると、以下のようにアクセスできます：

- 各スライド: `https://your-project.pages.dev/00-cursor/` など

## 📝 新しいスライドの追加

1. 新しいディレクトリを作成：

```bash
cd apps
mkdir 05-my-new-slide
cd 05-my-new-slide
```

2. `package.json` を作成：

```json
{
  "name": "05-my-new-slide",
  "type": "module",
  "private": true,
  "scripts": {
    "build": "slidev build --base /05-my-new-slide/ --out ../../dist/05-my-new-slide",
    "dev": "slidev --open",
    "export": "slidev export --dark --output ../../dist/05-my-new-slide.pdf"
  }
}
```

3. `slides.md` を作成：

```markdown
---
theme: default
title: My New Slide
---

# My New Slide

スライドコンテンツをここに書く
```

4. 開発モードで確認：

```bash
pnpm run dev
```

5. ビルド：

```bash
cd ../..
pnpm run build
```

## 🔧 技術スタック

- [Slidev](https://sli.dev/) - プレゼンテーションフレームワーク
- [pnpm](https://pnpm.io/) - パッケージマネージャー
- [Cloudflare Pages](https://pages.cloudflare.com/) - ホスティングプラットフォーム
- [Vue 3](https://vuejs.org/) - UI フレームワーク

## 💡 pnpmワークスペースのメリット

- **効率的な依存関係管理**: 共通の依存関係は1回だけインストール
- **並列ビルド**: `pnpm run -r build` で全プロジェクトを並列ビルド
- **フィルター機能**: `--filter` オプションで特定のプロジェクトのみを操作

## 📄 ライセンス

このプロジェクトは MIT ライセンスの下で公開されています。
