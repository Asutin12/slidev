<script setup lang="ts">
import { ref, computed } from "vue";

// TypeScriptの型システムのデモ用コンポーネント
interface User {
  id: number;
  name: string;
  email: string;
  role: "admin" | "user" | "guest";
}

const users = ref<User[]>([
  { id: 1, name: "田中太郎", email: "tanaka@example.com", role: "admin" },
  { id: 2, name: "佐藤花子", email: "sato@example.com", role: "user" },
  { id: 3, name: "山田次郎", email: "yamada@example.com", role: "guest" },
]);

const selectedRole = ref<User["role"] | "all">("all");

const filteredUsers = computed(() => {
  if (selectedRole.value === "all") return users.value;
  return users.value.filter((user) => user.role === selectedRole.value);
});

const getRoleColor = (role: User["role"]): string => {
  const colors = {
    admin: "#ef4444",
    user: "#3b82f6",
    guest: "#6b7280",
  };
  return colors[role];
};
</script>

<template>
  <div class="type-demo">
    <h4>TypeScript 型システムデモ</h4>

    <div class="filter">
      <label>役割でフィルター:</label>
      <select v-model="selectedRole">
        <option value="all">すべて</option>
        <option value="admin">管理者</option>
        <option value="user">ユーザー</option>
        <option value="guest">ゲスト</option>
      </select>
    </div>

    <div class="user-list">
      <div v-for="user in filteredUsers" :key="user.id" class="user-card">
        <div class="user-info">
          <strong>{{ user.name }}</strong>
          <small>{{ user.email }}</small>
        </div>
        <span
          class="role-badge"
          :style="{ backgroundColor: getRoleColor(user.role) }"
        >
          {{ user.role }}
        </span>
      </div>
    </div>
  </div>
</template>

<style scoped>
.type-demo {
  max-width: 500px;
  margin: 0 auto;
  padding: 1.5rem;
  border-radius: 12px;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.filter {
  margin-bottom: 1rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

select {
  padding: 0.4rem;
  border-radius: 4px;
  border: 1px solid #ccc;
  background: white;
}

.user-list {
  display: flex;
  flex-direction: column;
  gap: 0.8rem;
}

.user-card {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  transition: transform 0.2s ease;
}

.user-card:hover {
  transform: translateY(-2px);
}

.user-info {
  display: flex;
  flex-direction: column;
  gap: 0.2rem;
}

.user-info strong {
  font-size: 1rem;
}

.user-info small {
  color: #9ca3af;
  font-size: 0.8rem;
}

.role-badge {
  padding: 0.3rem 0.8rem;
  border-radius: 12px;
  color: white;
  font-size: 0.8rem;
  font-weight: 600;
  text-transform: uppercase;
}
</style>
