<template>
  <div class="slidev-layout cover">
    <div class="cover-content">
      <slot />
    </div>
    <div class="cover-footer" v-if="$slidev.configs.info">
      <p>{{ $slidev.configs.info }}</p>
    </div>
  </div>
</template>

<script setup lang="ts">
// Cover layout - タイトルスライド用
</script>

<style scoped>
.slidev-layout.cover {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  text-align: center;
  background: linear-gradient(
    135deg,
    var(--gaudiy-cream) 0%,
    var(--gaudiy-cream-dark) 100%
  );
  padding: 3rem;
}

.cover-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

.cover-content :deep(h1) {
  font-size: 4rem;
  margin-bottom: 2rem;
  color: var(--gaudiy-orange);
  text-shadow: 2px 2px 4px var(--gaudiy-shadow);
}

.cover-content :deep(p) {
  font-size: 1.5rem;
  color: var(--gaudiy-text-secondary);
  max-width: 800px;
}

.cover-footer {
  margin-top: auto;
  padding-top: 2rem;
  font-size: 1rem;
  color: var(--gaudiy-text-light);
}
</style>
