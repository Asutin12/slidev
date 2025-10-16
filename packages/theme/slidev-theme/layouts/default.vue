<template>
  <div class="slidev-layout default">
    <slot />
  </div>
</template>

<script setup lang="ts">
// Default layout - シンプルな汎用レイアウト
</script>

<style scoped>
.slidev-layout.default {
  width: 100%;
  height: 100%;
  padding: 3rem;
  display: flex;
  flex-direction: column;
}
</style>
