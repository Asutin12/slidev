<template>
  <div class="gaudiy-card" :class="{ hover: hoverable }">
    <div v-if="$slots.header" class="gaudiy-card-header">
      <slot name="header" />
    </div>
    <div class="gaudiy-card-body">
      <slot />
    </div>
    <div v-if="$slots.footer" class="gaudiy-card-footer">
      <slot name="footer" />
    </div>
  </div>
</template>

<script setup lang="ts">
interface Props {
  hoverable?: boolean;
}

withDefaults(defineProps<Props>(), {
  hoverable: false,
});
</script>

<style scoped>
.gaudiy-card {
  background: var(--gaudiy-cream-light, #fffdf5);
  padding: var(--gaudiy-spacing-lg, 2rem);
  border-radius: var(--gaudiy-radius-md, 1rem);
  border: 1px solid var(--gaudiy-border, #e8e0d0);
  box-shadow: 0 2px 8px var(--gaudiy-shadow, rgba(255, 140, 66, 0.15));
  transition: all 0.3s ease;
}

.gaudiy-card.hover:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 16px var(--gaudiy-shadow, rgba(255, 140, 66, 0.25));
}

.gaudiy-card-header {
  margin-bottom: var(--gaudiy-spacing-md, 1.5rem);
  padding-bottom: var(--gaudiy-spacing-md, 1.5rem);
  border-bottom: 2px solid var(--gaudiy-orange-light, #ffb07c);
}

.gaudiy-card-body {
  flex: 1;
}

.gaudiy-card-footer {
  margin-top: var(--gaudiy-spacing-md, 1.5rem);
  padding-top: var(--gaudiy-spacing-md, 1.5rem);
  border-top: 1px solid var(--gaudiy-border, #e8e0d0);
}
</style>
