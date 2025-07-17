# Slidev ハンズオン資料リポジトリ

このリポジトリは、[Slidev](https://sli.dev/) を用いて作成された様々なハンズオン資料を格納することを目的としています。各資料は、特定の技術やツールに関する実践的な学習コンテンツとして設計されています。

## プロジェクトの目的

- **ハンズオン資料の集約:** さまざまな技術分野におけるハンズオン資料を一元的に管理します。
- **学習体験の向上:** Slidev のインタラクティブな機能と視覚的な表現力を活用し、効果的な学習体験を提供します。
- **Gemini CLI との連携:** 本リポジトリの Slidev 資料は、[Gemini CLI](https://github.com/google-gemini/gemini-cli) を活用して作成・管理されています。これにより、効率的な資料作成プロセスを実現しています。

## 特徴

- **Slidev ベース:** Markdown と Vue.js の知識があれば、簡単にスライドを作成・編集できます。
- **インタラクティブなコンテンツ:** コードブロック、ライブデモ、埋め込みコンテンツなど、多様な形式の資料をサポートします。
- **一貫したスタイル:** `docs/rules.md` に定義されたルールに従い、資料全体で統一されたデザインと構成を維持します。
- **Gemini CLI による開発:** 資料の作成、更新、管理に Gemini CLI が利用されており、開発プロセスが効率化されています。

## はじめに

### 前提条件

- Node.js (推奨 LTS バージョン)
- bun (推奨) または npm/yarn

### インストール

```bash
# リポジトリをクローン
git clone https://github.com/your-username/slidev-hands-on.git
cd slidev-hands-on/slidev

# 依存関係をインストール
bun install
```

### スライドの実行

開発サーバーを起動し、ブラウザでスライドをプレビューします。

```bash
bun dev
```

### スライドのエクスポート

PDF や SPA (Single Page Application) としてスライドをエクスポートできます。

```bash
# PDFとしてエクスポート
bun export
```

## 新しいスライドの作成

新しいハンズオン資料を作成する際は、`slidev/slides.md` をテンプレートとして使用し、`docs/rules.md` に記載されているスライド作成ルールを遵守してください。

```bash
# 新しいスライドファイルを作成（例: slidev/slides-new-topic.md）
cp slidev/slides.md slidev/slides-new-topic.md
```

## プロジェクト構造

```
.
├── README.md               # このREADMEファイル
├── .git/                   # Gitリポジトリ
└── slidev/                 # Slidevプロジェクトルート
    ├── .gitignore
    ├── .npmrc
    ├── bun.lock
    ├── netlify.toml
    ├── package.json        # プロジェクトの依存関係とスクリプト
    ├── README.md           # SlidevプロジェクトのREADME
    ├── slides.md           # メインのスライドファイル
    ├── style.css           # カスタムスタイル
    ├── vercel.json
    ├── components/         # カスタムVueコンポーネント
    │   └── Counter.vue
    ├── node_modules/       # 依存関係
    ├── pages/              # ページ固有のMarkdownファイル
    │   └── imported-slides.md
    └── snippets/           # コードスニペット
        └── external.ts
    └── docs/               # ドキュメント関連
        └── rules.md        # スライド作成ルール
```
