---
layout: center
---

# 🌐 ハンズオン ③

Static Web Apps の作成とデプロイ（Next.js）

---

## ハンズオン ③ の概要

このハンズオンでは、Next.js でチャットアプリのフロントエンドを作成し、Static Web Apps でホスティングします。

<div class="pt-6">

### 🎯 学習目標

- Static Web Apps の作成方法を習得する
- Next.js プロジェクトの構築方法を理解する
- SignalR JavaScript SDK の使い方を理解する
- Functions との統合方法を学ぶ

### 📋 実施内容

1. **Static Web App の作成** - Portal と CLI での作成方法
2. **Next.js プロジェクトの作成** - TypeScript で構築
3. **SignalR クライアントの実装** - リアルタイム通信の実装
4. **チャット UI の作成** - React コンポーネントの実装
5. **デプロイ** - Static Web Apps へのデプロイ

</div>

---

## STEP 3-1: Static Web App の作成（Portal）- 1/2

Azure Portal で Static Web Apps を作成します。

### 手順

1. **Static Web Apps の検索**

   - Azure Portal で「静的 Web アプリ」または「Static Web Apps」を検索
   - 「+ 作成」をクリック

2. **基本タブの設定**

   - **サブスクリプション**: 使用するサブスクリプション
   - **リソース グループ**: `rg-chat-app-handson`
   - **名前**: `swa-chat-<your-unique-name>`
     - 例: `swa-chat-taro123`
   - **プランの種類**: `Standard`
   - **リージョン**: `East Asia`（Japan East は未対応のため）

---

## STEP 3-2: Static Web App の作成（Portal）- 2/2

デプロイ方法の設定を行います。

### 手順（続き）

3. **デプロイの詳細**

   - **ソース**: `その他`
     - GitHub 連携も可能ですが、今回は手動デプロイします

4. **確認および作成**

   - 「作成」をクリック
   - デプロイ完了まで約 1〜2 分待機

5. **デプロイトークンの取得**

   - 作成完了後、「リソースに移動」
   - 左メニュー「概要」
   - 「デプロイトークンの管理」から API キーをコピー
   - 後で使用するため保存しておく

---

## STEP 3-3: Static Web App の作成（CLI）

Azure CLI で Static Web Apps を作成します。

```bash
# Static Web Apps拡張機能のインストール（初回のみ）
az extension add --name staticwebapp

# Static Web Appの作成
az staticwebapp create \
  --name swa-chat-taro123 \
  --resource-group rg-chat-app-handson \
  --location eastasia \
  --sku Free

# 作成確認
az staticwebapp show \
  --name swa-chat-taro123 \
  --resource-group rg-chat-app-handson \
  --query "{Name:name, DefaultHostname:defaultHostname, Sku:sku.name}" \
  --output table

# APIキーの取得
az staticwebapp secrets list \
  --name swa-chat-taro123 \
  --resource-group rg-chat-app-handson \
  --query "properties.apiKey" \
  --output tsv
```

---

## STEP 3-4: Next.js プロジェクトの作成

チャットアプリのフロントエンドを Next.js で作成します。

```bash
# プロジェクトディレクトリの作成
npx create-next-app@latest chat-app-frontend
```

**質問が出たら以下のように回答:**

- ✔ TypeScript? → **Yes**
- ✔ ESLint? → **Yes**
- ✔ Tailwind CSS? → **Yes**（スタイリング用）
- ✔ App Router? → **Yes**
- ✔ Turbopack? → **No**
- ✔ Import alias? → **@/\***

```bash
cd chat-app-frontend
```

---

## STEP 3-5: 必要なパッケージのインストール

SignalR クライアントライブラリをインストールします。

```bash
# SignalR JavaScript SDKのインストール
npm install @microsoft/signalr

# 追加の型定義（TypeScript用）
npm install --save-dev @types/node
```

**プロジェクト構成:**

```
chat-app-frontend/
├── app/
│   ├── layout.tsx                 # ルートレイアウト
│   ├── page.tsx                   # チャットページ
│   ├── globals.css                # グローバルスタイル
│   └── profile/
│       └── page.tsx               # プロフィールページ（認証必須）
├── components/
│   ├── ChatBox.tsx                # チャット表示コンポーネント
│   ├── MessageInput.tsx           # メッセージ入力コンポーネント
│   └── UserInfo.tsx               # ユーザー情報コンポーネント
├── lib/
│   └── signalr.ts                 # SignalR接続管理
├── public/
│   └── staticwebapp.config.json   # Static Web Apps設定
├── .env.local                     # ローカル環境変数
├── next.config.js                 # Next.js設定
└── package.json
```

---

## STEP 3-6: SignalR 接続管理の実装

`lib/signalr.ts` を作成して、SignalR 接続を管理します。

```typescript
// lib/signalr.ts
import * as signalR from "@microsoft/signalr";

export interface ChatMessage {
  sender: string;
  text: string;
  timestamp: string;
}

export class SignalRService {
  private connection: signalR.HubConnection | null = null;
  private onMessageCallback: ((message: ChatMessage) => void) | null = null;
  private apiBaseUrl: string;

  constructor() {
    // ローカル開発とAzure環境での切り替え
    this.apiBaseUrl = process.env.NEXT_PUBLIC_API_BASE_URL || "/api";
  }

  async startConnection(): Promise<void> {
    try {
      // negotiateエンドポイントから接続情報を取得
      const response = await fetch(`${this.apiBaseUrl}/negotiate`, {
        method: "POST",
      });

      if (!response.ok) {
        throw new Error("Failed to get connection info");
      }

      const connectionInfo = await response.json();

      // SignalR接続の構築
      this.connection = new signalR.HubConnectionBuilder()
        .withUrl(connectionInfo.url, {
          accessTokenFactory: () => connectionInfo.accessToken,
        })
        .withAutomaticReconnect()
        .build();
      // メッセージ受信ハンドラーの設定
      this.connection.on("newMessage", (message: ChatMessage) => {
        if (this.onMessageCallback) {
          this.onMessageCallback(message);
        }
      });

      // 接続開始
      await this.connection.start();
      console.log("SignalR接続成功");
    } catch (error) {
      console.error("SignalR接続エラー:", error);
      throw error;
    }
  }

  async sendMessage(sender: string, text: string): Promise<void> {
    const response = await fetch(`${this.apiBaseUrl}/messages`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ sender, text }),
    });

    if (!response.ok) {
      throw new Error("Failed to send message");
    }
  }

  onMessage(callback: (message: ChatMessage) => void): void {
    this.onMessageCallback = callback;
  }

  async stopConnection(): Promise<void> {
    if (this.connection) {
      await this.connection.stop();
    }
  }
}
```

<div class="mt-4 text-sm">

**重要なポイント:**

1. **API ベース URL の動的切り替え**

   - `constructor()` で環境変数 `NEXT_PUBLIC_API_BASE_URL` を読み込み
   - ローカル開発: `http://localhost:7071/api`（Azure Functions）
   - Azure 環境: `/api`（Static Web Apps が自動ルーティング）

2. **接続情報の取得**

   - `negotiate` エンドポイントから SignalR の接続 URL とアクセストークンを取得
   - この情報を使って SignalR に接続

3. **メッセージの送信**
   - `messages` エンドポイントに POST リクエスト
   - Functions が SignalR 経由で全クライアントにブロードキャスト

</div>

---

## STEP 3-7: 環境変数の設定

ローカル開発環境で Functions と連携するための環境変数を設定します。

### .env.local ファイルの作成

プロジェクトのルートディレクトリに `.env.local` ファイルを作成します。

```bash
# .env.local
NEXT_PUBLIC_API_BASE_URL=http://localhost:7071/api
```

<div class="mt-4">

**環境別の設定:**

- **ローカル開発**: `http://localhost:7071/api`（Azure Functions のローカルエンドポイント）
- **Azure 環境**: `/api`（Static Web Apps が自動的にルーティング）

</div>

<div class="mt-4 bg-yellow-500/10 p-3 rounded text-sm">
⚠️ <strong>重要：</strong>

- `.env.local` ファイルは `.gitignore` に含まれています（自動的に除外されます）
- ローカル開発では Functions を先に起動（`func start`）してから Next.js を起動してください
- Azure にデプロイする際は、この環境変数は不要です（Static Web Apps が自動的に `/api` をルーティング）

</div>

---

## STEP 3-8: チャット表示コンポーネントの作成

`components/ChatBox.tsx` を作成します。

```typescript
// components/ChatBox.tsx
"use client";

import { ChatMessage } from "@/lib/signalr";

interface ChatBoxProps {
  messages: ChatMessage[];
}

export default function ChatBox({ messages }: ChatBoxProps) {
  return (
    <div className="flex-1 overflow-y-auto p-4 space-y-4 bg-gray-50">
      {messages.map((message, index) => (
        <div
          key={index}
          className="bg-white rounded-lg shadow-sm p-4 hover:shadow-md transition-shadow"
        >
          <div className="flex items-start justify-between">
            <span className="font-semibold text-blue-600">
              {message.sender}
            </span>
            <span className="text-xs text-gray-400">
              {new Date(message.timestamp).toLocaleTimeString("ja-JP")}
            </span>
          </div>
          <p className="mt-2 text-gray-800">{message.text}</p>
        </div>
      ))}
    </div>
  );
}
```

---

## STEP 3-9: メッセージ入力コンポーネントの作成

`components/MessageInput.tsx` を作成します。

```typescript
// components/MessageInput.tsx
"use client";

import { useState } from "react";

interface MessageInputProps {
  onSend: (message: string) => void;
  disabled: boolean;
}

export default function MessageInput({ onSend, disabled }: MessageInputProps) {
  const [message, setMessage] = useState("");

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (message.trim() && !disabled) {
      onSend(message);
      setMessage("");
    }
  };

  return (
    <form onSubmit={handleSubmit} className="p-4 bg-white border-t">
      <div className="flex gap-2">
        <input
          type="text"
          value={message}
          onChange={(e) => setMessage(e.target.value)}
          disabled={disabled}
          placeholder="メッセージを入力..."
          className="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 disabled:bg-gray-100"
        />
        <button
          type="submit"
          disabled={disabled || !message.trim()}
          className="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors"
        >
          送信
        </button>
      </div>
    </form>
  );
}
```

---

## STEP 3-10: ユーザー情報コンポーネントの作成

`components/UserInfo.tsx` を作成します。

```typescript
// components/UserInfo.tsx
"use client";

interface UserInfoProps {
  username: string;
  isAuthenticated: boolean;
  onLogin: () => void;
  onLogout: () => void;
}

export default function UserInfo({
  username,
  isAuthenticated,
  onLogin,
  onLogout,
}: UserInfoProps) {
  return (
    <div className="flex items-center gap-4">
      <span className="font-medium text-white">
        {isAuthenticated ? username : "Anonymous"}
      </span>
      {isAuthenticated ? (
        <button
          onClick={onLogout}
          className="px-4 py-2 bg-white/20 hover:bg-white/30 text-white rounded-lg transition-colors"
        >
          ログアウト
        </button>
      ) : (
        <button
          onClick={onLogin}
          className="px-4 py-2 bg-white text-blue-600 hover:bg-gray-100 rounded-lg transition-colors font-medium"
        >
          ログイン
        </button>
      )}
    </div>
  );
}
```

---

## STEP 3-11: メインページの実装

`app/page.tsx` を作成してチャットページを実装します。

```typescript
// app/page.tsx
"use client";

import { useEffect, useState, useRef } from "react";
import { SignalRService, ChatMessage } from "@/lib/signalr";
import ChatBox from "@/components/ChatBox";
import MessageInput from "@/components/MessageInput";
import UserInfo from "@/components/UserInfo";

export default function Home() {
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [currentUser, setCurrentUser] = useState("Anonymous");
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [isConnected, setIsConnected] = useState(false);
  const signalRService = useRef<SignalRService | null>(null);

  useEffect(() => {
    // ユーザー情報の取得
    getUserInfo();

    // SignalR接続の初期化
    const initSignalR = async () => {
      const service = new SignalRService();
      signalRService.current = service;

      service.onMessage((message) => {
        setMessages((prev) => [...prev, message]);
      });

      try {
        await service.startConnection();
        setIsConnected(true);
      } catch (error) {
        console.error("接続エラー:", error);
      }
    };

    initSignalR();

    return () => {
      if (signalRService.current) {
        signalRService.current.stopConnection();
      }
    };
  }, []);

  const getUserInfo = async () => {
    try {
      const response = await fetch("/.auth/me");
      const payload = await response.json();
      const { clientPrincipal } = payload;

      if (clientPrincipal) {
        setCurrentUser(clientPrincipal.userDetails);
        setIsAuthenticated(true);
      }
    } catch (error) {
      console.log("未認証ユーザー");
    }
  };

  const handleSendMessage = async (text: string) => {
    if (signalRService.current) {
      try {
        await signalRService.current.sendMessage(currentUser, text);
      } catch (error) {
        console.error("メッセージ送信エラー:", error);
        alert("メッセージの送信に失敗しました");
      }
    }
  };

  const handleLogin = () => {
    window.location.href = "/.auth/login/aad";
  };

  const handleLogout = () => {
    window.location.href = "/.auth/logout";
  };

  return (
    <div className="flex flex-col h-screen">
      {/* ヘッダー */}
      <header className="bg-gradient-to-r from-blue-600 to-purple-600 text-white p-4 shadow-lg">
        <div className="max-w-6xl mx-auto flex items-center justify-between">
          <h1 className="text-2xl font-bold">💬 リアルタイムチャット</h1>
          <UserInfo
            username={currentUser}
            isAuthenticated={isAuthenticated}
            onLogin={handleLogin}
            onLogout={handleLogout}
          />
        </div>
      </header>

      {/* メインコンテンツ */}
      <div className="flex-1 flex flex-col max-w-6xl w-full mx-auto">
        <ChatBox messages={messages} />
        <MessageInput onSend={handleSendMessage} disabled={!isConnected} />
      </div>

      {/* ステータスバー */}
      <div className="bg-gray-100 px-4 py-2 text-center text-sm text-gray-600">
        {isConnected ? "✅ 接続済み" : "⏳ 接続中..."}
      </div>
    </div>
  );
}
```

---

## STEP 3-12: グローバルスタイルの設定

`app/globals.css` を編集して、Tailwind CSS を設定します。

```css
@tailwind base;
@tailwind components;
@tailwind utilities;

html,
body {
  height: 100%;
  margin: 0;
  padding: 0;
}

#__next {
  height: 100%;
}
```

---

## STEP 3-13: Next.js 設定ファイルの編集

`next.config.js` を編集して、Static Web Apps 用の設定を追加します。

```javascript
/** @type {import('next').NextConfig} */
const nextConfig = {
  output: "export",
  images: {
    unoptimized: true,
  },
  trailingSlash: true,
};

module.exports = nextConfig;
```

**設定の説明:**

- `output: "export"`: 静的エクスポート
- `images.unoptimized: true`: 画像最適化を無効化（Static Web Apps 用）
- `trailingSlash: true`: URL の末尾にスラッシュを追加

---

## STEP 3-14: ローカルでのテスト

開発環境でフロントエンドをテストします。

```bash
# 開発サーバーの起動
npm run dev

# ブラウザでアクセス
# http://localhost:3000
```

<div class="mt-4 bg-yellow-500/10 p-3 rounded text-sm">
⚠️ <strong>注意：</strong>この段階では Functions が localhost:7071 で動作している必要があります。next.config.js に API のリライト設定を追加すると便利です。
</div>

**API リライト設定（開発用）:**

```javascript
/** @type {import('next').NextConfig} */
const nextConfig = {
  async rewrites() {
    return [
      {
        source: "/api/:path*",
        destination: "http://localhost:7071/api/:path*",
      },
    ];
  },
};
```

---

## STEP 3-15: ビルドとエクスポート

Static Web Apps にデプロイするために、プロジェクトをビルドします。

```bash
# 本番用ビルド
npm run build

# ビルド成果物の確認
ls -la out/
```

**生成されるファイル:**

```
out/
├── _next/
│   ├── static/           # 静的アセット
│   └── ...
├── index.html            # メインページ
└── ...
```

---

## STEP 3-16: Static Web Apps CLI でのローカルテスト

Static Web Apps CLI を使用して、より本番環境に近い環境でテストします。

```bash
# Static Web Apps CLIのインストール
npm install -g @azure/static-web-apps-cli

# ビルド
npm run build

# Static Web Apps CLIでサーバー起動
swa start out --api-location ../chat-app-functions

# ブラウザで http://localhost:4280 にアクセス
```

**メリット:**

- Functions と Static Web Apps の統合をローカルでテスト
- `/api` パスが自動的に Functions にルーティング
- 認証機能のモックも可能

<div class="mt-4 text-xs opacity-75">
💡 本番環境と同じ構成でテストできるので、デプロイ前の確認に最適です。
</div>

---

## STEP 3-17: Azure へのデプロイ（CLI）

Static Web Apps CLI を使用してデプロイします。

```bash
# プロジェクトディレクトリで実行
cd chat-app-frontend

# ビルド
npm run build

# デプロイトークンを環境変数に設定
export SWA_DEPLOYMENT_TOKEN="your-deployment-token-here"

# デプロイ実行
swa deploy \
  --app-location out \
  --deployment-token $SWA_DEPLOYMENT_TOKEN

# または、対話的にデプロイ
swa deploy
```

**デプロイの流れ:**

1. 静的ファイル（HTML/CSS/JS）のアップロード
2. Functions のビルドとデプロイ
3. 設定の適用

<div class="mt-4 bg-green-500/10 p-3 rounded text-sm">
✅ デプロイが完了したら、Static Web Apps の URL にアクセスして確認しましょう。
</div>

---

## STEP 3-18: Azure へのデプロイ（GitHub Actions）

GitHub Actions を使用した自動デプロイの設定方法です。

### 1. GitHub リポジトリの作成

```bash
# Gitリポジトリの初期化
cd chat-app-frontend
git init
git add .
git commit -m "Initial commit"

# GitHubにプッシュ
git remote add origin https://github.com/your-username/chat-app.git
git branch -M main
git push -u origin main
```

### 2. Static Web Apps との連携

Portal で Static Web Apps を作成する際に、「GitHub」を選択すると、自動的に GitHub Actions ワークフローが作成されます。

**利点:**

- コミットごとに自動デプロイ
- プレビュー環境の自動作成
- ビルドステータスの確認

---

## STEP 3-19: プロフィールページの作成（認証必須）

ログイン時のみアクセスできるプロフィールページを作成します。

### app/profile/page.tsx の作成

```typescript
// app/profile/page.tsx
"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";

interface UserProfile {
  userId: string;
  userDetails: string;
  identityProvider: string;
  userRoles: string[];
  claims?: any[];
}

export default function ProfilePage() {
  const [profile, setProfile] = useState<UserProfile | null>(null);
  const [loading, setLoading] = useState(true);
  const router = useRouter();

  useEffect(() => {
    const fetchProfile = async () => {
      try {
        const response = await fetch("/.auth/me");
        const payload = await response.json();
        const { clientPrincipal } = payload;

        if (!clientPrincipal) {
          // 未認証の場合はホームにリダイレクト
          router.push("/");
          return;
        }

        setProfile(clientPrincipal);
      } catch (error) {
        console.error("プロフィール取得エラー:", error);
        router.push("/");
      } finally {
        setLoading(false);
      }
    };

    fetchProfile();
  }, [router]);

  if (loading) {
    return (
      <div className="flex items-center justify-center h-screen">
        <div className="text-xl">読み込み中...</div>
      </div>
    );
  }

  if (!profile) {
    return null;
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <header className="bg-gradient-to-r from-blue-600 to-purple-600 text-white p-4 shadow-lg">
        <div className="max-w-4xl mx-auto flex items-center justify-between">
          <h1 className="text-2xl font-bold">👤 プロフィール</h1>
          <button
            onClick={() => router.push("/")}
            className="px-4 py-2 bg-white/20 hover:bg-white/30 rounded-lg transition-colors"
          >
            チャットに戻る
          </button>
        </div>
      </header>

      <main className="max-w-4xl mx-auto p-6">
        <div className="bg-white rounded-lg shadow-md p-6 space-y-4">
          <div className="border-b pb-4">
            <h2 className="text-xl font-semibold text-gray-800 mb-2">
              ユーザー情報
            </h2>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="text-sm font-medium text-gray-600">
                ユーザー名
              </label>
              <p className="text-lg text-gray-900">{profile.userDetails}</p>
            </div>

            <div>
              <label className="text-sm font-medium text-gray-600">
                ユーザー ID
              </label>
              <p className="text-sm text-gray-900 font-mono break-all">
                {profile.userId}
              </p>
            </div>

            <div>
              <label className="text-sm font-medium text-gray-600">
                認証プロバイダー
              </label>
              <p className="text-lg text-gray-900">
                {profile.identityProvider === "aad"
                  ? "Microsoft"
                  : profile.identityProvider}
              </p>
            </div>

            <div>
              <label className="text-sm font-medium text-gray-600">
                ロール
              </label>
              <div className="flex gap-2 flex-wrap mt-1">
                {profile.userRoles.map((role, index) => (
                  <span
                    key={index}
                    className="px-3 py-1 bg-blue-100 text-blue-800 rounded-full text-sm"
                  >
                    {role}
                  </span>
                ))}
              </div>
            </div>
          </div>

          {profile.claims && profile.claims.length > 0 && (
            <div className="mt-6">
              <label className="text-sm font-medium text-gray-600 mb-2 block">
                追加情報（Claims）
              </label>
              <div className="bg-gray-50 rounded p-4 overflow-x-auto">
                <pre className="text-xs">
                  {JSON.stringify(profile.claims, null, 2)}
                </pre>
              </div>
            </div>
          )}
        </div>
      </main>
    </div>
  );
}
```

---

## STEP 3-20: ナビゲーションの追加

メインページにプロフィールページへのリンクを追加します。

### app/page.tsx の更新

```typescript
// app/page.tsx の return 文内のヘッダー部分に追加
<header className="bg-gradient-to-r from-blue-600 to-purple-600 text-white p-4 shadow-lg">
  <div className="max-w-6xl mx-auto flex items-center justify-between">
    <h1 className="text-2xl font-bold">💬 リアルタイムチャット</h1>
    <div className="flex items-center gap-4">
      {isAuthenticated && (
        <a
          href="/profile"
          className="px-4 py-2 bg-white/20 hover:bg-white/30 rounded-lg transition-colors"
        >
          プロフィール
        </a>
      )}
      <UserInfo
        username={currentUser}
        isAuthenticated={isAuthenticated}
        onLogin={handleLogin}
        onLogout={handleLogout}
      />
    </div>
  </div>
</header>
```

---

## STEP 3-21: 既存の Function App との統合（Portal）

ハンズオン ② で作成した Function App を Static Web Apps にリンクします。

### 手順

1. **Static Web App を開く**

   - Azure Portal で Static Web App を開く

2. **API 設定を開く**

   - 左メニューの「API」をクリック

3. **Function App をリンク**

   - 「リンク」をクリック
   - **既存の関数アプリをリンクする**: オン
   - **サブスクリプション**: 使用するサブスクリプション
   - **関数アプリ**: `func-chat-taro123`（ハンズオン ② で作成したもの）
   - 「リンク」をクリック

<div class="mt-4 bg-blue-500/10 p-3 rounded text-sm">
💡 <strong>重要：</strong>この設定により、Static Web Apps の `/api/*` へのリクエストが、既存の Function App にルーティングされます。
</div>

---

## STEP 3-22: 既存の Function App との統合（CLI）

Azure CLI で Function App をリンクします。

```bash
# Function AppのリソースIDを取得
FUNCTION_APP_ID=$(az functionapp show \
  --name func-chat-taro123 \
  --resource-group rg-chat-app-handson \
  --query id \
  --output tsv)

# Static Web AppにFunction Appをリンク
az staticwebapp backends link \
  --name swa-chat-taro123 \
  --resource-group rg-chat-app-handson \
  --backend-resource-id "$FUNCTION_APP_ID" \
  --region japaneast

# リンク確認
az staticwebapp show \
  --name swa-chat-taro123 \
  --resource-group rg-chat-app-handson \
  --query "linkedBackends"
```

<div class="mt-4 text-xs opacity-75">
💡 リンクが完了すると、Static Web Apps から Function App への API 呼び出しが可能になります。
</div>

---

## STEP 3-23: staticwebapp.config.json の作成

認証とルーティングの設定を行います。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">
<div>

```json
{
  "navigationFallback": {
    "rewrite": "/index.html",
    "exclude": ["/api/*", "/*.{css,js,jpg,png,svg,ico}"]
  },
  "routes": [
    {
      "route": "/api/*",
      "allowedRoles": ["anonymous"]
    },
    {
      "route": "/profile",
      "allowedRoles": ["authenticated"]
    }
  ],
  "responseOverrides": {
    "401": {
      "redirect": "/.auth/login/aad",
      "statusCode": 302
    },
    "404": {
      "rewrite": "/index.html",
      "statusCode": 200
    }
  }
}
```

</div>
<div>

**設定の説明:**

1. **navigationFallback**

   - SPA のクライアントサイドルーティング用
   - API とアセットは除外

2. **routes**

   - `/profile`: 認証済みユーザーのみアクセス可能
   - `/api/*`: すべてのユーザーがアクセス可能
   - `/*`: その他のルートは未認証でもアクセス可能

3. **responseOverrides**
   - `401`: 未認証の場合はログインページにリダイレクト
   - `404`: 404 エラーは index.html にリダイレクト

<div class="mt-4 bg-yellow-500/10 p-3 rounded text-sm">
⚠️ <strong>重要：</strong>この設定ファイルは `public` フォルダに配置してください。Next.js のビルド時に `out` フォルダにコピーされます。
</div>
</div>
</div>

---

## STEP 3-24: デプロイの確認

デプロイしたアプリケーションを確認します。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">
<div>

### Portal での確認

1. **Static Web App を開く**

   - Azure Portal で Static Web App を開く

2. **URL の確認**

   - 「概要」ページで URL を確認
   - 例: `https://swa-chat-taro123.azurestaticapps.net`

3. **デプロイ履歴の確認**

   - 左メニューの「環境」をクリック
   - デプロイ状態を確認

</div>
<div>

### CLI での確認

```bash
# URLの取得
az staticwebapp show \
  --name swa-chat-taro123 \
  --resource-group rg-chat-app-handson \
  --query defaultHostname \
  --output tsv

# ブラウザで開く
open https://$(az staticwebapp show --name swa-chat-taro123 --resource-group rg-chat-app-handson --query defaultHostname --output tsv)
```

</div>
</div>

**本番環境デプロイ**
```bash
swa deploy \
  --app-location out \
  --deployment-token $SWA_DEPLOYMENT_TOKEN \
  --env production
```

---

## STEP 3-25: 動作確認 ①

デプロイしたチャットアプリをテストします。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">
<div>

### 基本機能のテスト

1. **ブラウザでアクセス**

   - Static Web App の URL にアクセス
   - 初期状態では「Anonymous」と表示される

2. **接続状態の確認**

   - 画面下部のステータスが「接続済み」になることを確認

3. **メッセージ送信テスト**

   - メッセージを入力して送信
   - 送信したメッセージが表示されることを確認

4. **複数ブラウザでテスト**

   - 別のブラウザまたはシークレットウィンドウで同じ URL を開く
   - 一方でメッセージを送信すると、もう一方にも表示されることを確認

</div>
<div>

### 認証機能のテスト

5. **ログイン**

   - 「ログイン」ボタンをクリック
   - Microsoft アカウントでサインイン
   - ユーザー名が表示されることを確認
   - 「プロフィール」リンクが表示されることを確認

6. **プロフィールページのアクセス**

   - 「プロフィール」をクリック
   - ユーザー情報が表示されることを確認
     - ユーザー名
     - ユーザー ID
     - 認証プロバイダー（Microsoft）
     - ロール（authenticated）

</div>
</div>

---

## STEP 3-26: 動作確認 ②

7. **認証済みでのメッセージ送信**

   - チャットページに戻る
   - メッセージを送信
   - 送信者名が認証したユーザー名になることを確認

8. **ログアウト**
   - 「ログアウト」ボタンをクリック
   - ユーザー名が「Anonymous」に戻ることを確認
   - 「プロフィール」リンクが非表示になることを確認

### アクセス制御のテスト

9. **未認証でのプロフィールアクセス**
   - ログアウト状態で `/profile` に直接アクセス
   - ログインページにリダイレクトされることを確認

<div class="mt-4 bg-green-500/10 p-3 rounded text-sm">
✅ リアルタイムでメッセージが配信され、認証機能も正常に動作していれば完璧です！
</div>

---

## トラブルシューティング

よくある問題と解決策です。

<div class="grid grid-cols-2 gap-6 text-sm">
<div>

### 接続エラー

**問題:** 「接続エラー」と表示される

**原因:**

- SignalR 接続文字列が正しく設定されていない
- Functions が正常に動作していない

**解決策:**

1. Functions App のアプリケーション設定を確認
2. Functions のログを確認
3. negotiate エンドポイントに直接アクセスしてテスト

### メッセージが送信できない

**問題:** メッセージ送信ボタンを押しても反応がない

**解決策:**

1. ブラウザの開発者ツールでコンソールエラーを確認
2. Network タブで API リクエストの状態を確認
3. Functions のログでエラーを確認

</div>
<div>

### ログインできない

**問題:** ログインボタンをクリックしても認証ページに遷移しない

**解決策:**

1. Static Web Apps の認証設定が正しいか確認
2. ブラウザのポップアップブロックを解除
3. プライベートブラウジングモードでは動作しない場合がある

### プロフィールページにアクセスできない

**問題:** `/profile` にアクセスしてもログインページにリダイレクトされない

**解決策:**

1. `staticwebapp.config.json` が正しく配置されているか確認
2. デプロイが完了しているか確認
3. ブラウザのキャッシュをクリア

</div>
</div>

---

## ハンズオン ③ のまとめ

Static Web Apps（Next.js）の作成とデプロイが完了しました。

<div class="grid grid-cols-2 gap-6 pt-4 text-sm">

<div>

### ✅ 達成したこと

- ✅ Static Web Apps の作成
- ✅ Next.js プロジェクトの構築
- ✅ SignalR JavaScript SDK の統合
- ✅ TypeScript でのチャット UI 実装
- ✅ Microsoft 認証の有効化
- ✅ プロフィールページの作成（認証必須）
- ✅ Functions との連携
- ✅ Azure へのデプロイ
- ✅ リアルタイム通信の動作確認

</div>

<div>

### 🔑 重要なポイント

- **Next.js**: モダンな React フレームワーク
- **TypeScript**: 型安全な開発
- **SignalR SDK**: リアルタイム通信
- **コンポーネント設計**: 再利用可能な UI
- **認証**: `/.auth/*` エンドポイントで簡単実装
- **アクセス制御**: `staticwebapp.config.json` でルートごとに設定
- **Functions 統合**: `/api` パスで自動ルーティング
- **SWA CLI**: ローカル開発とデプロイ

</div>
</div>
