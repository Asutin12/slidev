---
theme: "default"
style: "./style.css"
title: "Cursor × Slidev でモダンなスライド作成"
lang: "ja-JP"
drawings:
  enabled: true
highlighter: shiki
lineNumbers: false
info: |
  ## CursorとSlidevでモダンなスライド作成

  開発者のためのプレゼンテーションツールSlidevと、AI搭載エディターCursorを組み合わせた
  効率的なスライド作成方法を紹介します。
---

# Cursor × Slidev でモダンなスライド作成

開発者のための次世代プレゼンテーション

<div class="pt-12">
  <span @click="$slidev.nav.next" class="px-2 py-1 rounded cursor-pointer" hover="bg-white bg-opacity-10">
    Press Space for next page <carbon:arrow-right class="inline"/>
  </span>
</div>

---

## アジェンダ

<v-clicks>

- 💡 **Slidev とは？** - 開発者向けプレゼンテーションツール
- 🤔 **従来ツールの課題** - PowerPoint の限界
- ⚡ **Slidev の特徴** - コードファーストなアプローチ
- 🛠️ **Cursor での開発** - AI と一緒にスライド作成
- 📝 **基本的な使い方** - Markdown でスライド
- 🎨 **高度な機能** - コンポーネント・アニメーション
- 🚀 **実際のデモ** - ライブコーディング
- 📋 **まとめ** - 採用のメリット

</v-clicks>

---
layout: center
---

# Slidev とは？

**Slide**s for **dev**elopers

---

## Slidev の概要

<v-clicks>

- 🖥️ **Web ベース** - ブラウザで表示・操作
- 📝 **Markdown 記法** - 馴染みのある記法でスライド作成
- 🎨 **Vue.js ベース** - コンポーネントでリッチな表現
- ⚡ **ホットリロード** - 即座にプレビュー更新
- 📱 **レスポンシブ** - あらゆるデバイスで最適表示
- 🎞️ **PDF エクスポート** - プレゼンテーション後の配布も簡単

</v-clicks>

<br>

<v-click>

```bash
# 新規プロジェクト作成
npm create slidev@latest

# 開発サーバー起動
npm run dev
```

</v-click>

---

## 従来のスライド作成ツールの課題 😫

<div class="grid grid-cols-2 gap-8">
<div>

### PowerPoint / Keynote

<v-clicks>

- 🐌 **動作が重い** - 大量のスライドで重くなる
- 💸 **有料ソフト** - ライセンス費用
- 🔒 **バージョン管理困難** - Gitで管理できない
- 📐 **デザイン調整が大変** - 微調整に時間がかかる
- 🖼️ **コードの表示が苦手** - シンタックスハイライトなし

</v-clicks>

</div>
<div>

### Google Slides

<v-clicks>

- 🌐 **ネット依存** - オフラインで作業できない
- 📱 **モバイル編集制限** - 細かい編集は困難
- 🎨 **カスタマイズ制限** - デザインの自由度が低い
- 🔗 **外部ツール連携不足** - 開発環境との親和性が低い

</v-clicks>

</div>
</div>

<v-click>

<div class="text-center mt-8">
  <h3 class="text-orange-400">開発者にとって理想的なツールがない！</h3>
</div>

</v-click>

---

## Slidev が解決する課題 ✨

<div class="grid grid-cols-2 gap-8">
<div>

### 📝 コードファースト

<v-clicks>

- Markdown で書けるシンプルさ
- Git でバージョン管理
- IDE での快適な編集体験
- コードスニペットの美しい表示

</v-clicks>

</div>
<div>

### 🎨 豊富な表現力

<v-clicks>

- Vue コンポーネントで拡張
- アニメーションも簡単
- テーマでデザイン統一
- インタラクティブな要素

</v-clicks>

</div>
</div>

<br>

<v-click>

```markdown
---
layout: center
---

# タイトル

<Counter /> <!-- Vue コンポーネント -->
\`\`\`javascript {1-3|4-6}
function hello() {
console.log('Hello World')
}
console.log('アニメーションでハイライト')
\`\`\`
```

</v-click>

---
layout: center
---

# Cursor での開発環境

AI の力でスライド作成を加速

---

## Cursor × Slidev の組み合わせが最強な理由

<v-clicks>

### 🤖 **AI アシスタント**

- スライド構成の提案
- Markdown 記法の自動補完
- Vue コンポーネントの生成

### 🛠️ **開発者体験**

- VSCode ベースの使い慣れた操作
- 豊富な拡張機能
- Git 統合でチーム開発

### ⚡ **効率化**

- Chat で要望を伝えるだけでスライド生成
- リアルタイムプレビュー
- 自動フォーマット・構文チェック

</v-clicks>

---

## 実際の開発フロー

<v-clicks>

### 1. プロジェクト作成・編集

```bash
npm create slidev@latest my-presentation
cursor .  # Cursorで開く
```

### 2. AIでスライド生成

```
"React について5枚のスライドを作って"
→ AI が構成 + Markdown を生成
```

### 3. リアルタイムプレビュー

```bash
npm run dev  # 即座にブラウザ確認
```

</v-clicks>

---

## 基本的な Markdown 記法

<div class="grid grid-cols-2 gap-6">
<div>

### スライド区切り

```markdown
---
# スライド1
---

# スライド2

---
layout: center
---

# センタリングされたスライド
```

### リスト・強調

```markdown
- 通常のリスト
- **太字**
- _斜体_
- `インラインコード`
```

</div>
<div>

### コードブロック

```markdown
\`\`\`javascript {1-2|3-4}
function greet() {
console.log('Hello!')
}
greet()
\`\`\`
```

### 画像・リンク

```markdown
![画像](./assets/image.png)

[リンク](https://sli.dev)
```

</div>
</div>

---

## 高度な機能：インタラクティブなコンポーネント

<div class="grid grid-cols-2 gap-6">
<div>

### Vueコンポーネント

```vue
<template>
  <div class="counter">
    <div class="emoji">{{ emoji }}</div>
    <div class="count">{{ count }}</div>
    <button @click="inc">+</button>
  </div>
</template>

<script setup>
import { ref, computed } from "vue";
const count = ref(0);
const inc = () => count.value++;
const emoji = computed(() => (count.value > 0 ? "😊" : "😐"));
</script>
```

</div>
<div>

### 実際の動作

<Counter />

**特徴**: リアクティブ・再利用可能・型安全

</div>
</div>

---

## 高度な機能：データ視覚化・チャート

<div class="grid grid-cols-2 gap-6">
<div>

### 動的チャート

```vue
<script setup>
const data = ref([
  { label: "Vue.js", value: 85 },
  { label: "React", value: 78 },
]);

const chartType = ref("bar");
</script>

<template>
  <div class="chart">
    <button @click="chartType = 'bar'">棒グラフ</button>
    <button @click="chartType = 'pie'">円グラフ</button>
  </div>
</template>
```

</div>
<div>

### 実際のチャート

<SimpleChart />

**対応**: Chart.js・D3.js・カスタムSVG

</div>
</div>

---

## 高度な機能：アニメーション

<v-clicks>

### v-click でクリックアニメーション

```markdown
<v-clicks>

- 最初の項目
- 2番目の項目
- 3番目の項目

</v-clicks>
```

### カスタムアニメーション

```markdown
<v-click>

<div v-motion-slide-bottom>
  下からスライドイン
</div>

</v-click>
```

</v-clicks>

---
layout: center
---

# 🚀 実際のデモタイム

ライブでスライドを作ってみましょう！

---

## デモ：AI でスライド作成

<v-clicks>

### 1. Cursor のチャット機能を使用

```
「TypeScript の型システムについて説明する
 3枚のスライドを作成して」
```

### 2. AI が提案する構成

- 基本的な型の紹介
- 高度な型機能
- 実践例

### 3. Markdown が自動生成される

### 4. リアルタイムでプレビュー確認

### 5. 細かな調整を AI と対話しながら実施

</v-clicks>

---

## なぜ Cursor × Slidev を選ぶべきか？

<div class="grid grid-cols-2 gap-8">
<div>

### 🚀 **生産性の向上**

<v-clicks>

- AI がスライド構成を提案
- Markdown で高速作成
- Git でバージョン管理
- チームでの共同編集

</v-clicks>

</div>
<div>

### 💡 **クオリティの向上**

<v-clicks>

- 美しいコードハイライト
- インタラクティブな要素
- 一貫したデザイン
- モバイル対応

</v-clicks>

</div>
</div>

<br>

<v-click>

### 🎯 **開発者に最適**

- 慣れ親しんだツールチェーン
- 拡張性の高いアーキテクチャ
- オープンソースで無料

</v-click>

---

## 導入時の注意点

<v-clicks>

- 📚 **学習コスト** - Markdown記法とVue.js基礎
- 🎨 **デザインスキル** - CSSの知識があると◎
- 🔧 **技術的制約** - Node.js環境が必要

<br>

<div class="text-green-400 text-center">
  でも、開発者にとっては大した問題じゃない！
</div>

</v-clicks>

---
layout: center
---

## まとめ

<v-clicks>

### Cursor × Slidev で**開発者の発表が変わる**

🤖 **AI の力**でスライド作成を効率化  
📝 **コードファースト**なアプローチで生産性向上  
🎨 **モダンな表現力**で聴衆を魅了

<br>

### 次のプレゼンテーションから始めてみませんか？

</v-clicks>

---
layout: center
---

# ありがとうございました！

## 質疑応答

<div class="pt-12">
  <span class="text-sm opacity-50">
    このスライドも Cursor × Slidev で作成しました 🚀
  </span>
</div>
