# Assets ディレクトリ

このディレクトリには、スライドで使用する画像やその他のアセットを配置します。

## 推奨する画像ファイル

LT発表で使用できる画像例：

### 1. Slidev ロゴ・スクリーンショット

- `slidev-logo.png` - Slidevの公式ロゴ
- `slidev-interface.png` - Slidev開発画面のスクリーンショット
- `slidev-preview.png` - スライドプレビューの画面

### 2. Cursor スクリーンショット

- `cursor-ai-chat.png` - Cursor AIチャット機能のスクリーンショット
- `cursor-autocomplete.png` - AI自動補完機能の様子
- `cursor-interface.png` - Cursor全体のインターフェース

### 3. 比較用画像

- `powerpoint-problems.png` - PowerPointの課題を示す画像
- `markdown-vs-gui.png` - MarkdownとGUI編集の比較

### 4. デモ用画像

- `before-after.png` - スライド作成のBefore/After比較
- `workflow-diagram.png` - 開発フローの図解

## 画像の配置方法

```markdown
<!-- スライド内での画像参照 -->

![画像の説明](./assets/images/filename.png)

## <!-- レイアウトで背景画像として使用 -->

layout: image-right
image: './assets/images/background.jpg'

---
```

## 画像最適化のヒント

- **サイズ**: 幅1920px以下に調整
- **形式**: PNG（透明背景が必要な場合）、JPG（写真）
- **容量**: 1MB以下を推奨
- **解像度**: 高DPIディスプレイを考慮して2倍解像度で準備

## 著作権について

- 自作のスクリーンショットを使用
- フリー素材やCC0ライセンスの画像を使用
- 企業ロゴは公式サイトから取得
