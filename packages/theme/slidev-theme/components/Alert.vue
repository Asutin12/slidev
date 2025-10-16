<template>
  <div class="gaudiy-alert" :class="type">
    <div class="gaudiy-alert-icon">
      <slot name="icon">
        <span v-if="type === 'info'">ℹ️</span>
        <span v-else-if="type === 'warning'">⚠️</span>
        <span v-else-if="type === 'success'">✅</span>
        <span v-else-if="type === 'error'">❌</span>
        <span v-else>💡</span>
      </slot>
    </div>
    <div class="gaudiy-alert-content">
      <slot />
    </div>
  </div>
</template>

<script setup lang="ts">
interface Props {
  type?: "default" | "info" | "warning" | "success" | "error";
}

withDefaults(defineProps<Props>(), {
  type: "default",
});
</script>

<style scoped>
.gaudiy-alert {
  display: flex;
  gap: var(--gaudiy-spacing-sm, 1rem);
  padding: var(--gaudiy-spacing-md, 1.5rem);
  border-radius: var(--gaudiy-radius-sm, 0.5rem);
  margin: var(--gaudiy-spacing-md, 1.5rem) 0;
  border-left: 4px solid;
}

.gaudiy-alert.default {
  background: var(--gaudiy-cream-light, #fffdf5);
  border-left-color: var(--gaudiy-orange, #ff8c42);
}

.gaudiy-alert.info {
  background: #f0f8ff;
  border-left-color: #2196f3;
}

.gaudiy-alert.warning {
  background: #fff8dc;
  border-left-color: #ffa500;
}

.gaudiy-alert.success {
  background: #f0f8f0;
  border-left-color: #4caf50;
}

.gaudiy-alert.error {
  background: #fff0f0;
  border-left-color: #f44336;
}

.gaudiy-alert-icon {
  font-size: 1.5rem;
  line-height: 1;
}

.gaudiy-alert-content {
  flex: 1;
}
</style>
