import type { Plugin } from "@opencode-ai/plugin";

export const Prettier: Plugin = async ({ $, directory }) => {
  return {
    event: async ({ event }) => {
      if (event.type === "file.edited") {
        await $`npx prettier --write ${event.properties.file} >/dev/null 2>&1`;
      }
    },
  };
};
