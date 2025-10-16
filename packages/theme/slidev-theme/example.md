---
theme: ./
title: 'Gaudiy Theme デモ'
info: |
  ## Gaudiy Theme
  温かみのあるクリーム色とオレンジのアクセントカラーを使った
  モダンなSlidevテーマ
class: text-center
highlighter: shiki
drawings:
  persist: false
transition: fade
mdc: true
---

# Gaudiy Theme

温かみのあるクリーム色とオレンジのアクセントを使ったモダンなSlidevテーマ

<div class="pt-12">
  <span @click="$slidev.nav.next" class="px-2 py-1 rounded cursor-pointer" hover="bg-white bg-opacity-10">
    スライドを開始 <carbon:arrow-right class="inline"/>
  </span>
</div>

---
layout: section
---

# テーマの特徴

モダンで温かみのあるデザイン

---
layout: default
---

# 主な特徴

<v-clicks>

- 🎨 **温かみのあるカラーパレット** - クリーム色とオレンジの組み合わせ
- 📝 **豊富なレイアウト** - 7種類以上のカスタムレイアウト
- 🎯 **読みやすいタイポグラフィ** - Noto Sans JPとFira Codeを使用
- ✨ **美しいコードハイライト** - Shikiによるシンタックスハイライト
- 📱 **レスポンシブデザイン** - あらゆる画面サイズに対応

</v-clicks>

---
layout: two-cols
---

# 左側のコンテンツ

## ポイント1
2カラムレイアウトでコンテンツを分けて表示できます。

- 項目A
- 項目B
- 項目C

::right::

# 右側のコンテンツ

## ポイント2
画像やコード、リストなど様々なコンテンツに対応しています。

```typescript
const theme = {
  name: 'gaudiy',
  colors: {
    primary: '#FF8C42',
    background: '#FFF9E6'
  }
}
```

---
layout: center
---

# 中央配置レイアウト

重要なメッセージを強調して表示するのに最適です

---
layout: image-right
---

# 画像と文章の組み合わせ

## サブタイトル

このレイアウトでは、左側にテキストコンテンツ、右側に画像を配置できます。

- **ポイント1**: わかりやすい説明
- **ポイント2**: 視覚的な訴求
- **ポイント3**: バランスの取れたデザイン

::image::

<div class="w-full h-full flex items-center justify-center bg-gradient-to-br from-orange-100 to-orange-200 rounded-lg">
  <div class="text-6xl">🎨</div>
</div>

---
layout: persona
---

::header::

# What is Proto Persona?

プロトペルソナ

::illustration::

<div class="text-center">
  <div class="w-40 h-40 mx-auto mb-4 bg-orange-100 rounded-full flex items-center justify-center">
    <div class="text-6xl">👤</div>
  </div>
  <div class="text-xl font-bold text-orange-600">TETSUTA-SAN</div>
</div>

::section1::

### BEHAVIORS

行動パターンと特徴を記述します

- 毎朝の習慣やルーティン
- よく使うツールやサービス
- 情報収集の方法
- コミュニケーションスタイル

::section2::

### FACTS

事実情報とデモグラフィック

- **年齢**: 30代前半  
- **職業**: ITエンジニア
- **居住地**: 東京都
- **家族構成**: 独身

::section3::

### NEEDS & GOALS

ニーズとゴール

- より効率的な開発環境を求めている
- 新しい技術スキルを習得したい
- ワークライフバランスの改善
- キャリアアップを目指している

---
layout: default
---

# コードのハイライト

テーマはShikiによる美しいシンタックスハイライトをサポートしています。

```typescript {2-4|6-8|all}
// TypeScriptの例
interface Theme {
  name: string
  version: string
}

const gaudiyTheme: Theme = {
  name: 'gaudiy',
  version: '0.1.0'
}

export default gaudiyTheme
```

---
layout: default
---

# テーブルとリスト

## 機能比較表

| 機能 | Gaudiyテーマ | デフォルトテーマ |
|------|-------------|----------------|
| カラースキーム | ✅ カスタム | 🔵 ブルー系 |
| レイアウト数 | 7+ | 5 |
| 日本語最適化 | ✅ 完全対応 | ⚠️ 部分対応 |

## チェックリスト

- [x] 基本レイアウトの実装
- [x] カラーパレットの設定
- [x] タイポグラフィの調整
- [ ] さらなる改善

---
layout: center
---

# 強調表現

<div class="text-orange-600 text-6xl font-bold mb-8">
  85%
</div>

ユーザー満足度

---
layout: default
---

# 引用とアラート

> "優れたデザインとは、単に見た目が美しいだけでなく、
> 使いやすさと機能性を兼ね備えたものである。"
> 
> — デザインの格言

<div class="alert mt-8">
💡 <strong>ヒント:</strong> このテーマは日本語フォントに最適化されています。
</div>

---
layout: section
---

# ありがとうございました

質問はありますか？

---
layout: center
---

# テーマのインストール

```bash
# npmでインストール
npm install slidev-theme-gaudiy

# bunでインストール  
bun add slidev-theme-gaudiy
```

スライドのフロントマターに以下を追加:

```yaml
---
theme: gaudiy
---
```

<div class="text-center mt-8 text-sm text-gray-500">
  Made with ❤️ by Masuda Asuto
</div>
