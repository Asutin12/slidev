---
theme: default
background: https://cover.sli.dev
title: Cursor - AI を活用したコードエディタ
info: |
  ## Cursor ハンズオン資料

  AI を活用したコードエディタ Cursor の概要と機能について学習します
class: text-center
drawings:
  persist: false
transition: slide-left
mdc: true
---

# Cursor

## AI を活用したコードエディタ

ハンズオン資料

---

## layout: default

---

# Cursor とは

Cursor は、AI（特に Claude-3.5 や GPT-4）を統合した **VSCode ベース**のコードエディタです

<v-clicks>

- 従来のコーディング体験を革新
- AI 支援によって開発効率を大幅に向上
- VSCode の機能を完全継承

</v-clicks>

---

## layout: default

---

# Cursor の主な特徴

<v-clicks>

- **VSCode 互換**  
  既存の VSCode エクステンションや設定をそのまま利用可能

- **AI 統合**  
  コード生成、リファクタリング、バグ修正を AI が支援

- **マルチモーダル**  
  テキストだけでなく、画像やファイル構造も理解

- **コンテキスト理解**  
  プロジェクト全体を把握した上でのコード提案

</v-clicks>

---

## layout: two-cols

---

# メリット ✅

<v-clicks>

- **生産性向上**  
  コード生成とリファクタリングの自動化

- **学習効率**  
  未知の技術スタックでも即座にサポート

- **VSCode 互換**  
  移行コストが極めて低い

- **プロジェクト理解**  
  大規模コードベースの理解を支援

- **バグ検出**  
  潜在的な問題を事前に発見

</v-clicks>

::right::

# デメリット ❌

<v-clicks>

- **料金**  
  Pro 版は月額$20（無料版は制限あり）

- **依存性**  
  インターネット接続が必要

- **AI の限界**  
  複雑なロジックや特殊要件では不完全

- **プライバシー**  
  コードが AI サーバーに送信される

</v-clicks>

---

## layout: default

---

# Claude Code との比較

| 項目               | Cursor               | Claude Code          |
| ------------------ | -------------------- | -------------------- |
| **統合度**         | エディタ完全統合     | チャット形式         |
| **コンテキスト**   | プロジェクト全体理解 | 提供されたコードのみ |
| **リアルタイム性** | リアルタイム編集支援 | 対話的支援           |
| **学習コスト**     | 低い（VSCode 類似）  | 中程度               |
| **専門性**         | コーディング特化     | 汎用 AI              |
| **料金**           | $20/月               | $20/月（Claude Pro） |

---

## layout: center

---

# Cursor の機能について

主要な機能を詳しく見ていきましょう

---

## layout: default

---

# 基本概念

Cursor の核となる概念

<v-clicks>

## **コンテキスト駆動 AI**

- プロジェクト全体のファイル構造とコードベースを理解
- 変更履歴と開発者の意図を学習
- 関連ファイルを自動的に参照

## **インクリメンタルな開発**

- 段階的なコード改善を提案
- 既存コードとの整合性を維持
- 開発者の判断を尊重した提案

</v-clicks>

---

## layout: default

---

# マルチモーダル理解

<v-clicks>

- **コード、コメント、ドキュメント、画像を統合理解**
- **デザインファイルからの UI 実装**
- **エラーメッセージからの原因特定**

</v-clicks>

---

## layout: center

---

# コア機能について

7つの主要機能を紹介します

---

## layout: default

---

# 1. タブ機能

<v-clicks>

- **予測コード補完**  
  次に書くコードを予測し提案

- **コンテキスト認識**  
  現在の作業内容に基づいた最適な補完

- **学習機能**  
  個人のコーディングスタイルを学習

- **リアルタイム**  
  タイピングと同時に動的に更新

</v-clicks>

---

## layout: default

---

# 2. エージェント機能

<v-clicks>

- **対話型開発**  
  自然言語でのコード生成・修正依頼

- **複雑なタスク処理**  
  複数ファイルにまたがる変更の実行

- **説明と提案**  
  コードの動作説明と改善提案

- **プロジェクト理解**  
  全体構造を把握した上での開発支援

</v-clicks>

---

## layout: default

---

# 3. バックグラウンドエージェント

<v-clicks>

- **自動分析**  
  ファイル変更時の自動解析

- **潜在的問題検出**  
  セキュリティやパフォーマンス問題の早期発見

- **依存関係管理**  
  ライブラリやモジュールの最新化提案

- **継続的最適化**  
  バックグラウンドでのコード改善提案

</v-clicks>

---

## layout: default

---

# 4. インライン編集

<v-clicks>

- **その場編集**  
  コード内で直接 AI 支援を受けながら編集

- **部分的修正**  
  特定行や範囲のみの精密な修正

- **即時フィードバック**  
  変更の影響範囲を即座に表示

- **ロールバック**  
  変更の取り消しが容易

</v-clicks>

---

## layout: default

---

# 5. ルール機能

<v-clicks>

- **プロジェクト固有設定**  
  チーム開発基準の統一

- **コーディング規約**  
  自動的な規約チェックと修正提案

- **カスタマイズ**  
  プロジェクトの特殊要件に対応

- **継承機能**  
  上位ディレクトリからのルール継承

</v-clicks>

---

## layout: default

---

# 6. Bugbot

<v-clicks>

- **自動バグ検出**  
  潜在的なバグを事前に検出

- **修正提案**  
  具体的な修正方法を提案

- **テスト生成**  
  バグを防ぐためのテストコード生成

- **デバッグ支援**  
  エラー原因の特定と解決策提示

</v-clicks>

---

## layout: default

---

# 7. メモリー機能

<v-clicks>

- **学習記録**  
  開発者の判断や選択を記憶

- **コンテキスト保持**  
  セッション間での情報継続

- **パターン認識**  
  繰り返しパターンの学習と活用

- **個人最適化**  
  個人の開発スタイルに合わせた調整

</v-clicks>

---

## layout: center

---

# @ 記号（シンボル参照）

Cursor における強力なコンテキスト指定機能

---

## layout: default

---

# @ 記号の基本的な使用方法

<v-clicks>

```ts
@filename    # 特定ファイルを参照
@folder/     # フォルダ全体を参照
@symbol      # 関数やクラスなどのシンボルを参照
```

</v-clicks>

---

## layout: default

---

# @ 記号の高度な活用例

<v-clicks>

```ts
@components/Button.tsx このボタンコンポーネントを改修して...
```

```ts
@utils/ ここのユーティリティ関数を使って...
```

```ts
@types/User.ts この型定義に基づいて...
```

</v-clicks>

---

## layout: default

---

# シンボル参照の利点

<v-clicks>

- **精密なコンテキスト**  
  必要な情報のみを AI に提供

- **効率的な対話**  
  冗長な説明を省略

- **正確な理解**  
  ファイル構造に基づいた正確な参照

- **スコープ制限**  
  関連する範囲のみに処理を限定

</v-clicks>

---

## layout: center

---

# 実務Tips

効果的にCursorを活用するための実践的なコツ

---

## layout: default

---

# 1. Rulesを充実させる

<v-clicks>

- **具体例（コード）を含める**  
  抽象的な説明よりも実際のコード例で明確に指示

- **目的別にルールを分ける**  
  機能別、プロジェクト別でルールファイルを整理

- **チーム開発基準を統一**  
  コーディング規約やアーキテクチャルールを明文化

</v-clicks>

---

## layout: default

---

# 2. MCPをバンバン使おう

<v-clicks>

- **Playwright MCP は必須**  
  UI テストの自動化で品質向上

- **カスタムRulesでフロー定義**  
  実装完了後の自動UATを設定

- **Hooksがない現在の対策**  
  （2025/9/10現在）ルールで代替実装

</v-clicks>

<div class="text-sm mt-4">
<v-click>

**例**: 実装依頼時に最後に必ずPlaywright MCPでUAT実行

</v-click>
</div>

---

## layout: default

---

# 3. Chat Tabをうまく使い分けよう

<v-clicks>

- **行き詰まったら新セッション**  
  2-3回試してダメなら新しいチャットタブで再開

- **コンテキストリセット効果**  
  過去の失敗を引きずらない新しい視点

- **並列処理が可能**  
  複数タブで異なるタスクを同時進行

- **キューの回避**  
  同チャット内はキューに入るが、別タブなら並列実行

</v-clicks>

---

## layout: default

---

# 4. Undo All は慎重に使う

<v-clicks>

- **部分的な巻き戻し不可**  
  消したくない部分まで消える危険性

- **推奨: 個別プロンプトの巻き戻し**  
  チャット右下の戻るボタンを活用

- **Keep機能の活用**  
  重要な変更は事前にKeepしておく

- **段階的な確認**  
  大きな変更の前は小分けして実行

</v-clicks>

---

## layout: center

---

# まとめ

Cursor は従来のコードエディタの概念を革新し、AI 支援によって開発効率を劇的に向上させるツールです

<v-clicks>

- VSCode との互換性を保ちながら強力な AI 機能を提供
- 個人開発者からエンタープライズまで幅広いニーズに対応
- コンテキスト駆動の AI 支援で効率的な開発を実現
- **実務Tips を活用してより効果的に運用**

</v-clicks>

---

## layout: center

# 参考リンク

<div class="text-sm space-y-2">
<v-clicks>

- [Cursor 基本概念](https://cursor.com/ja/docs/get-started/concepts)
- [タブ機能詳細](https://cursor.com/ja/docs/tab/overview)
- [エージェント機能](https://cursor.com/ja/docs/agent/overview)
- [バックグラウンドエージェント](https://cursor.com/ja/docs/background-agent)
- [インライン編集](https://cursor.com/ja/docs/inline-edit/overview)
- [ルール設定](https://cursor.com/ja/docs/context/rules)
- [Bugbot 機能](https://cursor.com/ja/docs/bugbot)
- [メモリー機能](https://cursor.com/ja/docs/context/memories)
- [シンボル参照](https://cursor.com/ja/docs/context/symbols)

</v-clicks>
</div>
