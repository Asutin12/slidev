<template>
  <div class="slidev-layout center">
    <div class="center-content">
      <slot />
    </div>
  </div>
</template>

<script setup lang="ts">
// Center layout - 中央配置レイアウト
</script>

<style scoped>
.slidev-layout.center {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  text-align: center;
  padding: 3rem;
}

.center-content {
  max-width: 900px;
}

.center-content :deep(h1) {
  font-size: 3.5rem;
  margin-bottom: 2rem;
}

.center-content :deep(p) {
  font-size: 1.5rem;
  line-height: 1.8;
}
</style>
