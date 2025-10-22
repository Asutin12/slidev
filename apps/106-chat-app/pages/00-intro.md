---
layout: center
---

# 🎯 ハンズオンの目標

認証機能付きリアルタイムチャットアプリを構築する

---

## このハンズオンで学べること

Azure のサーバーレスサービスを組み合わせて、本格的なリアルタイムアプリケーションを構築します。

<div class="grid grid-cols-2 gap-6 pt-6 text-sm">

<div>

### 🎓 技術スキル

**Azure SignalR Service**

- リアルタイム通信の仕組み
- WebSocket 接続の管理
- サーバーレスモードの活用

**Azure Functions（Python）**

- Python での HTTP トリガーの実装
- SignalR バインディングの使用
- サーバーレス API の開発

**Static Web Apps（Next.js）**

- Next.js フロントエンドのホスティング
- TypeScript での型安全な開発
- Functions との統合

</div>

<div>

### 💡 実践的な知識

**認証・認可**

- Microsoft 認証の統合
- ユーザー情報の取得
- セキュアな通信

**アーキテクチャ設計**

- サーバーレス構成のメリット
- スケーラブルな設計
- コスト最適化

**DevOps**

- ローカル開発環境
- Azure へのデプロイ
- デバッグとトラブルシューティング

</div>

</div>

---

## 完成イメージ

### 📱 主要機能

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

✅ **リアルタイムメッセージング**

- 全ユーザーにメッセージを即時配信
- WebSocket による双方向通信

✅ **プライベートメッセージ**

- 特定のユーザーへの直接メッセージ
- ユーザー名によるターゲティング

</div>
<div>

✅ **認証機能**

- Microsoft アカウントでログイン
- ユーザー名の自動取得
- セキュアな接続

✅ **オンラインユーザー表示**

- 接続中のユーザー一覧
- リアルタイム更新

</div>
</div>

<div class="bg-blue-500/10 p-4 rounded text-sm">
💡 <strong>ポイント：</strong>このハンズオンで学ぶ技術は、チャット以外にも応用できます。通知システム、ライブダッシュボード、協調編集ツールなど、様々なリアルタイムアプリケーションに活用できます。
</div>

---

## 開発の流れ

1. **Azure リソース作成** - SignalR Service、Functions App、Storage を作成
2. **Functions プロジェクト作成（Python）** - negotiate、messages 関数を実装
3. **ローカルでテスト** - Azure Functions Core Tools で動作確認
4. **Functions をデプロイ** - Azure にデプロイ
5. **フロントエンド作成（Next.js）** - TypeScript で React コンポーネントを作成
6. **Static Web Apps デプロイ** - フロントエンドをホスティング
7. **認証設定** - Microsoft 認証を有効化
8. **動作確認** - 実際にチャットしてみる
