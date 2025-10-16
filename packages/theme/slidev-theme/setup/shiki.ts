import { defineShikiSetup } from "@slidev/types";

export default defineShikiSetup(() => {
  return {
    theme: {
      dark: "min-light",
      light: "min-light",
    },
    transformers: [
      // カスタムトランスフォーマーを追加可能
    ],
  };
});
