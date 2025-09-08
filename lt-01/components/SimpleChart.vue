<script setup lang="ts">
import { ref, onMounted, computed } from "vue";

// サンプルデータ
const data = ref([
  { label: "Vue.js", value: 85, color: "#4FC08D" },
  { label: "React", value: 78, color: "#61DAFB" },
  { label: "Angular", value: 65, color: "#DD0031" },
  { label: "Svelte", value: 72, color: "#FF3E00" },
  { label: "Solid", value: 68, color: "#2C4F7C" },
]);

const chartType = ref<"bar" | "pie">("bar");
const maxValue = computed(() => Math.max(...data.value.map((d) => d.value)));

// アニメーション用
const animationProgress = ref(0);

onMounted(() => {
  // チャート表示のアニメーション
  const animate = () => {
    if (animationProgress.value < 1) {
      animationProgress.value += 0.02;
      requestAnimationFrame(animate);
    }
  };
  animate();
});

// 円グラフ用の角度計算
const total = computed(() => data.value.reduce((sum, d) => sum + d.value, 0));
const pieSlices = computed(() => {
  let currentAngle = -90; // 12時方向から開始
  return data.value.map((item) => {
    const angle = (item.value / total.value) * 360;
    const slice = {
      ...item,
      startAngle: currentAngle,
      endAngle: currentAngle + angle,
      percentage: Math.round((item.value / total.value) * 100),
    };
    currentAngle += angle;
    return slice;
  });
});

// SVGパス生成（円グラフ用）
const createPieSlicePath = (
  centerX: number,
  centerY: number,
  radius: number,
  startAngle: number,
  endAngle: number
) => {
  const start = polarToCartesian(centerX, centerY, radius, endAngle);
  const end = polarToCartesian(centerX, centerY, radius, startAngle);
  const largeArcFlag = endAngle - startAngle <= 180 ? "0" : "1";

  return [
    "M",
    centerX,
    centerY,
    "L",
    start.x,
    start.y,
    "A",
    radius,
    radius,
    0,
    largeArcFlag,
    0,
    end.x,
    end.y,
    "Z",
  ].join(" ");
};

const polarToCartesian = (
  centerX: number,
  centerY: number,
  radius: number,
  angleInDegrees: number
) => {
  const angleInRadians = ((angleInDegrees - 90) * Math.PI) / 180.0;
  return {
    x: centerX + radius * Math.cos(angleInRadians),
    y: centerY + radius * Math.sin(angleInRadians),
  };
};
</script>

<template>
  <div class="chart-container">
    <div class="chart-header">
      <h4>📊 フレームワーク人気度調査</h4>
      <div class="chart-controls">
        <button
          @click="chartType = 'bar'"
          :class="{ active: chartType === 'bar' }"
          class="chart-btn"
        >
          棒グラフ
        </button>
        <button
          @click="chartType = 'pie'"
          :class="{ active: chartType === 'pie' }"
          class="chart-btn"
        >
          円グラフ
        </button>
      </div>
    </div>

    <!-- 棒グラフ -->
    <div v-if="chartType === 'bar'" class="bar-chart">
      <div v-for="item in data" :key="item.label" class="bar-item">
        <div class="bar-label">{{ item.label }}</div>
        <div class="bar-container">
          <div
            class="bar"
            :style="{
              width: `${(item.value / maxValue) * 100 * animationProgress}%`,
              backgroundColor: item.color,
            }"
          ></div>
          <span class="bar-value"
            >{{ Math.round(item.value * animationProgress) }}%</span
          >
        </div>
      </div>
    </div>

    <!-- 円グラフ -->
    <div v-else class="pie-chart">
      <svg width="200" height="200" viewBox="0 0 200 200">
        <path
          v-for="slice in pieSlices"
          :key="slice.label"
          :d="
            createPieSlicePath(
              100,
              100,
              80,
              slice.startAngle,
              slice.startAngle +
                (slice.endAngle - slice.startAngle) * animationProgress
            )
          "
          :fill="slice.color"
          class="pie-slice"
        />
      </svg>
      <div class="pie-legend">
        <div v-for="item in data" :key="item.label" class="legend-item">
          <div
            class="legend-color"
            :style="{ backgroundColor: item.color }"
          ></div>
          <span class="legend-label">{{ item.label }}</span>
          <span class="legend-value"
            >{{
              Math.round((item.value / total) * 100 * animationProgress)
            }}%</span
          >
        </div>
      </div>
    </div>

    <div class="chart-description">
      <small>リアルタイムで更新される動的チャート</small>
    </div>
  </div>
</template>

<style scoped>
.chart-container {
  max-width: 600px;
  margin: 0 auto;
  padding: 1.5rem;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 12px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.chart-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.5rem;
}

.chart-header h4 {
  margin: 0;
  font-size: 1.2rem;
}

.chart-controls {
  display: flex;
  gap: 0.5rem;
}

.chart-btn {
  padding: 0.4rem 0.8rem;
  border: 1px solid #666;
  background: transparent;
  color: #666;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.2s;
  font-size: 0.9rem;
}

.chart-btn.active,
.chart-btn:hover {
  background: #007acc;
  color: white;
  border-color: #007acc;
}

/* 棒グラフスタイル */
.bar-chart {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.bar-item {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.bar-label {
  width: 80px;
  font-weight: 600;
  text-align: right;
  font-size: 0.9rem;
}

.bar-container {
  flex: 1;
  position: relative;
  height: 25px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 4px;
  overflow: hidden;
}

.bar {
  height: 100%;
  transition: width 0.1s ease;
  border-radius: 4px;
  position: relative;
}

.bar-value {
  position: absolute;
  right: 8px;
  top: 50%;
  transform: translateY(-50%);
  font-size: 0.8rem;
  font-weight: 600;
  color: white;
}

/* 円グラフスタイル */
.pie-chart {
  display: flex;
  align-items: center;
  gap: 2rem;
  justify-content: center;
}

.pie-slice {
  cursor: pointer;
  transition: opacity 0.2s;
}

.pie-slice:hover {
  opacity: 0.8;
}

.pie-legend {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.legend-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.9rem;
}

.legend-color {
  width: 12px;
  height: 12px;
  border-radius: 2px;
}

.legend-label {
  min-width: 60px;
}

.legend-value {
  font-weight: 600;
  color: #007acc;
}

.chart-description {
  text-align: center;
  margin-top: 1rem;
  color: #6b7280;
  font-style: italic;
}

/* レスポンシブ対応 */
@media (max-width: 600px) {
  .pie-chart {
    flex-direction: column;
    gap: 1rem;
  }

  .chart-header {
    flex-direction: column;
    gap: 1rem;
    align-items: stretch;
  }
}
</style>
