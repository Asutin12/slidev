<template>
  <div class="slidev-layout image-right">
    <div class="content">
      <slot name="default" />
      <slot v-if="!$slots.default" />
    </div>
    <div class="image">
      <slot name="image" />
    </div>
  </div>
</template>

<script setup lang="ts">
// Image right layout - 右側に画像を配置するレイアウト
</script>

<style scoped>
.slidev-layout.image-right {
  width: 100%;
  height: 100%;
  display: grid;
  grid-template-columns: 1.5fr 1fr;
  gap: 3rem;
  padding: 3rem;
  align-items: center;
}

.content {
  padding-right: 2rem;
}

.image {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
}

.image :deep(img) {
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
}
</style>
