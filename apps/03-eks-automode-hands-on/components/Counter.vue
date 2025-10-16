<template>
  <div class="counter">
    <div class="emoji">{{ emoji }}</div>
    <div class="count text-3xl font-mono">{{ count }}</div>
    <button @click="inc" class="px-4 py-2 bg-blue-500 text-white rounded">
      +
    </button>
    <button @click="dec" class="px-4 py-2 bg-red-500 text-white rounded ml-2">
      -
    </button>
  </div>
</template>

<script setup>
import { ref, computed } from "vue";

const count = ref(0);

const inc = () => count.value++;
const dec = () => count.value--;

const emoji = computed(() => {
  if (count.value > 10) return "🚀";
  if (count.value > 5) return "😊";
  if (count.value > 0) return "🙂";
  return "😐";
});
</script>

<style scoped>
.counter {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
  padding: 2rem;
}

.emoji {
  font-size: 3rem;
}

.count {
  font-size: 2rem;
  font-weight: bold;
  color: #007acc;
}
</style>
