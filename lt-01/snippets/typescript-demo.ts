// TypeScript型システムの実例

// 基本的な型定義
interface User {
  id: number;
  name: string;
  email: string;
  role: "admin" | "user" | "guest";
}

// ユニオン型とリテラル型
type Theme = "light" | "dark" | "auto";
type Status = "loading" | "success" | "error";

// ジェネリック型
interface ApiResponse<T> {
  data: T;
  status: number;
  message: string;
}

// 型ガード関数
function isUser(obj: unknown): obj is User {
  return (
    typeof obj === "object" &&
    obj !== null &&
    typeof (obj as User).id === "number" &&
    typeof (obj as User).name === "string" &&
    typeof (obj as User).email === "string" &&
    ["admin", "user", "guest"].includes((obj as User).role)
  );
}

// 条件型（Conditional Types）
type NonNullable<T> = T extends null | undefined ? never : T;

// マップ型（Mapped Types）
type Partial<T> = {
  [P in keyof T]?: T[P];
};

// テンプレートリテラル型
type EventName<T extends string> = `on${Capitalize<T>}`;
type ClickEvent = EventName<"click">; // "onClick"

// 実用例：APIクライアント
class ApiClient {
  async fetchUser(id: number): Promise<ApiResponse<User>> {
    const response = await fetch(`/api/users/${id}`);
    return response.json();
  }

  async updateUser(
    id: number,
    updates: Partial<Omit<User, "id">>
  ): Promise<ApiResponse<User>> {
    const response = await fetch(`/api/users/${id}`, {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(updates),
    });
    return response.json();
  }
}
