<template>
  <div class="slidev-layout persona-layout">
    <!-- 背景装飾 -->
    <div class="background-circles">
      <div class="circle circle-1"></div>
      <div class="circle circle-2"></div>
      <div class="circle circle-3"></div>
    </div>

    <!-- ヘッダー -->
    <div class="persona-header">
      <slot name="header" />
    </div>

    <!-- メインコンテンツ -->
    <div class="persona-main">
      <!-- 左側：イラストとプロフィール -->
      <div class="persona-profile">
        <slot name="illustration" />
      </div>

      <!-- 右側：セクション -->
      <div class="persona-sections">
        <div class="persona-section">
          <slot name="section1" />
        </div>
        <div class="persona-section">
          <slot name="section2" />
        </div>
        <div class="persona-section">
          <slot name="section3" />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
// Persona layout - プロトペルソナ表示用（画像デザイン準拠）
</script>

<style scoped>
.persona-layout {
  width: 100%;
  height: 100%;
  padding: 2.5rem 3rem;
  display: flex;
  flex-direction: column;
  background: var(--gaudiy-cream);
  position: relative;
  overflow: hidden;
}

/* 背景装飾の円 */
.background-circles {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  z-index: 0;
}

.circle {
  position: absolute;
  border-radius: 50%;
  opacity: 0.15;
}

.circle-1 {
  width: 400px;
  height: 400px;
  background: radial-gradient(
    circle,
    rgba(255, 149, 72, 0.3) 0%,
    rgba(255, 149, 72, 0) 70%
  );
  top: -100px;
  right: -100px;
}

.circle-2 {
  width: 350px;
  height: 350px;
  background: radial-gradient(
    circle,
    rgba(253, 180, 75, 0.25) 0%,
    rgba(253, 180, 75, 0) 70%
  );
  bottom: -80px;
  left: -80px;
}

.circle-3 {
  width: 300px;
  height: 300px;
  background: radial-gradient(
    circle,
    rgba(255, 179, 71, 0.2) 0%,
    rgba(255, 179, 71, 0) 70%
  );
  top: 50%;
  left: 40%;
  transform: translate(-50%, -50%);
}

.persona-header {
  margin-bottom: 2rem;
  position: relative;
  z-index: 1;
}

.persona-header :deep(h1) {
  font-size: 1.8rem;
  font-weight: 700;
  color: var(--gaudiy-text-primary);
  margin-bottom: 0.3rem;
  line-height: 1.2;
}

.persona-header :deep(h2) {
  font-size: 1.4rem;
  font-weight: 400;
  color: var(--gaudiy-text-primary);
  border-bottom: none;
  margin: 0;
  line-height: 1.2;
}

.persona-main {
  flex: 1;
  display: grid;
  grid-template-columns: 280px 1fr;
  gap: 2.5rem;
  overflow: hidden;
  position: relative;
  z-index: 1;
}

.persona-profile {
  background: var(--gaudiy-cream-light);
  border: 1px solid var(--gaudiy-border);
  border-radius: 12px;
  padding: 2rem 1.5rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  height: fit-content;
}

.persona-profile :deep(img) {
  max-width: 100%;
  height: auto;
  margin-bottom: 1rem;
}

.persona-profile :deep(p) {
  font-size: 0.85rem;
  line-height: 1.6;
  color: var(--gaudiy-text-secondary);
  margin: 0.5rem 0;
}

.persona-profile :deep(strong) {
  font-size: 1.1rem;
  font-weight: 600;
  color: var(--gaudiy-text-primary);
  display: block;
  margin-top: 0.5rem;
}

.persona-sections {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  overflow-y: auto;
}

.persona-section {
  background: var(--gaudiy-cream-light);
  border: 1px solid var(--gaudiy-border);
  border-radius: 12px;
  padding: 1.5rem 1.8rem;
}

.persona-section :deep(h3) {
  font-size: 0.95rem;
  font-weight: 700;
  color: var(--gaudiy-yellow);
  margin: 0 0 1rem 0;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  line-height: 1;
}

.persona-section :deep(h4) {
  font-size: 0.9rem;
  font-weight: 700;
  color: var(--gaudiy-text-primary);
  margin: 0 0 0.8rem 0;
}

.persona-section :deep(p) {
  font-size: 0.9rem;
  line-height: 1.7;
  color: var(--gaudiy-text-primary);
  margin: 0 0 0.8rem 0;
}

.persona-section :deep(ul) {
  margin: 0;
  padding: 0;
  list-style: none;
}

.persona-section :deep(li) {
  font-size: 0.88rem;
  line-height: 1.8;
  color: var(--gaudiy-text-primary);
  margin-bottom: 0.4rem;
  padding-left: 1.2rem;
  position: relative;
}

.persona-section :deep(li::before) {
  content: "•";
  color: var(--gaudiy-orange);
  font-size: 1.2rem;
  position: absolute;
  left: 0;
  top: -0.1rem;
}

.persona-section :deep(li strong) {
  color: var(--gaudiy-text-primary);
  font-weight: 600;
}

.persona-section :deep(ol) {
  margin: 0;
  padding: 0 0 0 1.2rem;
  list-style: none;
  counter-reset: item;
}

.persona-section :deep(ol li) {
  padding-left: 0;
  counter-increment: item;
}

.persona-section :deep(ol li::before) {
  content: counter(item) ". ";
  color: var(--gaudiy-orange);
  font-weight: 600;
  position: relative;
  left: 0;
}
</style>
