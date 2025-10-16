<template>
  <span class="gaudiy-badge" :class="variant">
    <slot />
  </span>
</template>

<script setup lang="ts">
interface Props {
  variant?: "default" | "primary" | "success" | "warning" | "info";
}

withDefaults(defineProps<Props>(), {
  variant: "default",
});
</script>

<style scoped>
.gaudiy-badge {
  display: inline-block;
  padding: 0.25rem 0.75rem;
  border-radius: var(--gaudiy-radius-sm, 0.5rem);
  font-size: 0.875rem;
  font-weight: 600;
  line-height: 1.5;
}

.gaudiy-badge.default {
  background: var(--gaudiy-cream-dark, #fff5d6);
  color: var(--gaudiy-text-primary, #2c2c2c);
}

.gaudiy-badge.primary {
  background: var(--gaudiy-orange, #ff8c42);
  color: white;
}

.gaudiy-badge.success {
  background: #4caf50;
  color: white;
}

.gaudiy-badge.warning {
  background: #ffa500;
  color: white;
}

.gaudiy-badge.info {
  background: #2196f3;
  color: white;
}
</style>
