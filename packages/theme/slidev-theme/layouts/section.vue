<template>
  <div class="slidev-layout section">
    <div class="section-content">
      <slot />
    </div>
  </div>
</template>

<script setup lang="ts">
// Section layout - セクションの区切り用
</script>

<style scoped>
.slidev-layout.section {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  text-align: center;
  background: var(--gaudiy-orange);
  color: white;
  padding: 3rem;
}

.section-content :deep(h1),
.section-content :deep(h2) {
  color: white;
  border-bottom: none;
  font-size: 3.5rem;
  margin-bottom: 1rem;
}

.section-content :deep(p) {
  color: rgba(255, 255, 255, 0.9);
  font-size: 1.5rem;
}
</style>
