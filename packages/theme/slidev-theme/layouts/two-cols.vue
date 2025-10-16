<template>
  <div class="slidev-layout two-cols">
    <div class="col-left">
      <slot name="left" />
      <slot v-if="!$slots.left" />
    </div>
    <div class="col-right">
      <slot name="right" />
    </div>
  </div>
</template>

<script setup lang="ts">
// Two columns layout - 2カラムレイアウト
</script>

<style scoped>
.slidev-layout.two-cols {
  width: 100%;
  height: 100%;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 3rem;
  padding: 3rem;
  align-items: start;
}

.col-left,
.col-right {
  height: 100%;
  overflow: auto;
}
</style>
