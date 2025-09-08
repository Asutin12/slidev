<script setup lang="ts">
import { ref, computed } from "vue";

const count = ref(0);

const inc = () => count.value++;
const dec = () => count.value--;
const reset = () => (count.value = 0);

const emoji = computed(() => {
  if (count.value < 0) return "😢";
  if (count.value === 0) return "😐";
  if (count.value < 5) return "😊";
  if (count.value < 10) return "😄";
  return "🤩";
});

const color = computed(() => {
  if (count.value < 0) return "#ef4444";
  if (count.value === 0) return "#6b7280";
  if (count.value < 5) return "#3b82f6";
  if (count.value < 10) return "#10b981";
  return "#f59e0b";
});
</script>

<template>
  <div class="counter">
    <div class="emoji" :style="{ color }">{{ emoji }}</div>
    <div class="count" :style="{ color }">{{ count }}</div>
    <div class="buttons">
      <button @click="dec" class="btn-dec">−</button>
      <button @click="reset" class="btn-reset">Reset</button>
      <button @click="inc" class="btn-inc">＋</button>
    </div>
    <div class="description">
      <small>インタラクティブなVueコンポーネントの例</small>
    </div>
  </div>
</template>

<style scoped>
.counter {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
  padding: 2rem;
  border-radius: 12px;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
}

.emoji {
  font-size: 4rem;
  transition: all 0.3s ease;
}

.count {
  font-size: 4rem;
  font-weight: bold;
  transition: all 0.3s ease;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
}

.buttons {
  display: flex;
  gap: 0.8rem;
}

button {
  font-size: 1.2rem;
  padding: 0.6rem 1.2rem;
  border: 2px solid currentColor;
  background: transparent;
  cursor: pointer;
  border-radius: 8px;
  transition: all 0.2s ease;
  font-weight: 600;
}

.btn-inc {
  color: #10b981;
}

.btn-dec {
  color: #ef4444;
}

.btn-reset {
  color: #6b7280;
}

button:hover {
  background: currentColor;
  color: white;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

button:active {
  transform: translateY(0);
}

.description {
  color: #6b7280;
  font-style: italic;
}
</style>
