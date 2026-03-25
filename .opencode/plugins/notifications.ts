import type { Plugin } from "@opencode-ai/plugin";

export const Notify: Plugin = async ({ $, directory }) => {
  return {
    event: async ({ event }) => {
      if (event.type === "session.idle") {
        const title = "🏁 Session Completed";
        await $`bash ${directory}/.opencode/plugins/notify.sh -title ${title} -subtitle "${event.properties.sessionID}" -message "${directory}"`;
      }
      if ((event.type as any) === "permission.asked") {
        const title = "🔐 Permission Requested";
        await $`bash ${directory}/.opencode/plugins/notify.sh -title ${title} -message "${directory}"`;
      }
    }
  };
};
