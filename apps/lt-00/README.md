# LT-01 Slidev プロジェクト

このプロジェクトは[Slidev](https://sli.dev/)を使用してプレゼンテーションスライドを作成するためのテンプレートです。

## 🚀 はじめ方

### 前提条件

- [Bun](https://bun.sh/) (バージョン 1.0 以上)

### インストールと実行

```bash
# 依存関係のインストール
bun install

# 開発サーバーの起動
bun run dev

# プレゼンテーションのビルド
bun run build

# PDFエクスポート（オプション）
bun run export
```

## 📁 プロジェクト構造

```
lt-01/
├── slides.md          # メインのスライドファイル
├── style.css          # カスタムスタイル
├── package.json       # 依存関係とスクリプト
├── assets/            # 画像やリソース
│   └── images/        # 画像ファイル
├── components/        # Vueコンポーネント
│   └── Counter.vue    # サンプルコンポーネント
└── snippets/          # コードスニペット
    └── external.ts    # TypeScriptサンプル
```

## 📝 スライドの編集

`slides.md` ファイルを編集してスライドの内容を変更できます。Markdown の記法を使用し、`---` でスライドを区切ります。

### 基本的な記法

```markdown
---
# タイトルスライド
---

## 見出し

- リストアイテム 1
- リストアイテム 2

---

## layout: center

## センタリングされたスライド
```

## 🎨 スタイルのカスタマイズ

`style.css` ファイルでスライドのスタイルをカスタマイズできます。このプロジェクトでは統一されたデザインガイドラインに準拠しています。

## 📸 画像の追加

画像は `assets/images/` ディレクトリに配置し、以下のように参照します：

```markdown
![画像の説明](./assets/images/your-image.png)
```

## 🧩 コンポーネントの使用

Vue コンポーネントをスライドに組み込むことができます：

```markdown
<Counter />
```

## 💻 コードスニペットの参照

`snippets/` ディレクトリのコードファイルを参照できます：

```markdown
\`\`\`ts {src="../snippets/external.ts"}
\`\`\`
```

## 🔗 参考リンク

- [Slidev 公式ドキュメント](https://sli.dev/)
- [Slidev テーマ](https://sli.dev/themes/)
- [Slidev アニメーション](https://sli.dev/guide/animations.html)
