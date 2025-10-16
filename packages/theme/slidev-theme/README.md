# Slidev Theme Gaudiy

[![NPM version](https://img.shields.io/npm/v/slidev-theme-gaudiy?color=FF8C42)](https://www.npmjs.com/package/slidev-theme-gaudiy)

温かみのあるクリーム色とオレンジのアクセントカラーを使った、モダンなSlidevテーマです。

## 特徴

- 🎨 **温かみのあるカラーパレット** - クリーム色（#FFF9E6）とオレンジ（#FF8C42）の組み合わせ
- 📝 **豊富なレイアウト** - 7種類以上のカスタムレイアウト
- 🎯 **読みやすいタイポグラフィ** - Noto Sans JP、Noto Serif JP、Fira Codeを使用
- ✨ **美しいコードハイライト** - Shikiによるシンタックスハイライト
- 📱 **レスポンシブデザイン** - あらゆる画面サイズに対応
- 🇯🇵 **日本語最適化** - 日本語フォントとレイアウトに最適化

## インストール

```bash
npm install slidev-theme-gaudiy
```

または

```bash
bun add slidev-theme-gaudiy
```

## 使い方

スライドのフロントマターに以下を追加してください:

```yaml
---
theme: gaudiy
---
```

## レイアウト

### `default`

標準的な汎用レイアウト

```yaml
---
layout: default
---
```

### `cover`

タイトルスライド用のレイアウト

```yaml
---
layout: cover
---
```

### `section`

セクションの区切り用レイアウト（オレンジ背景）

```yaml
---
layout: section
---
```

### `two-cols`

2カラムレイアウト

```yaml
---
layout: two-cols
---
# 左側のコンテンツ

::right::
# 右側のコンテンツ
```

### `center`

中央配置レイアウト

```yaml
---
layout: center
---
```

### `image-right`

左側にコンテンツ、右側に画像を配置するレイアウト

```yaml
---
layout: image-right
---

# コンテンツ

::image::

![画像](./image.png)
```

### `persona`

プロトペルソナやユーザー情報の表示に適したレイアウト

```yaml
---
layout: persona
---

::header::
# タイトル

::illustration::
![イラスト](./avatar.png)

::section1::
### セクション1

::section2::
### セクション2

::section3::
### セクション3
```

## カスタマイズ

### カラーパレット

テーマでは以下のCSS変数を使用しています:

```css
--gaudiy-cream: #fff9e6 --gaudiy-orange: #ff8c42 --gaudiy-text-primary: #2c2c2c;
```

これらは `style.css` で上書きできます。

### フォント

デフォルトでは以下のフォントを使用しています:

- **Sans**: Noto Sans JP
- **Serif**: Noto Serif JP
- **Mono**: Fira Code

フロントマターで変更可能:

```yaml
---
theme: gaudiy
fonts:
  sans: "Your Font"
  serif: "Your Serif Font"
  mono: "Your Mono Font"
---
```

## 開発

```bash
# 依存関係のインストール
bun install

# 開発サーバーの起動
bun dev

# ビルド
bun build

# エクスポート
bun export
```

## ライセンス

MIT License © 2025 Masuda Asuto

## 参考

- [Slidev公式ドキュメント](https://sli.dev/)
- [テーマ作成ガイド](https://ja.sli.dev/themes/write-a-theme.html)
