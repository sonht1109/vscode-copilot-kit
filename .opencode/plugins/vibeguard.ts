import { vibeguard } from "./vibeguard-core/index.js";
import type { Plugin } from "@opencode-ai/plugin";

export const VibeGuardPrivacy: Plugin = async ({$}) => {

  const {config, initSession} = vibeguard();

  if (!config.enabled) return {};

  const debug = config.debug;

  /**
   * @type {Map<string, import("./vibeguard/session.js").PlaceholderSession>}
   */
  const sessions = new Map();

  const getSession = (sessionID: string) => {
    const key = String(sessionID ?? "");
    if (!key) return null;
    const existing = sessions.get(key);
    if (existing) return existing;
    const created = initSession();
    sessions.set(key, created);
    return created;
  };

  return {
    "experimental.chat.messages.transform": async (_input, output) => {
      const msgs = output?.messages;
      if (!Array.isArray(msgs) || msgs.length === 0) return;

      const sessionID =
        msgs[0]?.info?.sessionID ?? msgs[0]?.parts?.[0]?.sessionID;
      const session = getSession(sessionID);
      if (!session) return;

      session.evictOldest();

      let changedTextParts = 0;

      for (const msg of msgs) {
        const parts = Array.isArray(msg?.parts) ? msg.parts : [];
        for (const part of parts) {
          if (!part) continue;

          if (part.type === "text") {
            if (part.ignored) continue;
            if (!part.text || typeof part.text !== "string") continue;
            const before = part.text;
            const after = session.redactText(before).text;
            if (after !== before) changedTextParts++;
            part.text = after;
            continue;
          }

          if (part.type === "reasoning") {
            if (!part.text || typeof part.text !== "string") continue;
            const before = part.text;
            const after = session.redactText(before).text;
            if (after !== before) changedTextParts++;
            part.text = after;
            continue;
          }

          if (part.type === "tool") {
            const state = part.state;
            if (!state || typeof state !== "object") continue;

            if (state.input && typeof state.input === "object") {
              session.redactDeep(state.input);
            }

            if (
              state.status === "completed" &&
              typeof state.output === "string"
            ) {
              const before = state.output;
              const after = session.redactText(before).text;
              if (after !== before) changedTextParts++;
              state.output = after;
              continue;
            }
            if (state.status === "error" && typeof state.error === "string") {
              const before = state.error;
              const after = session.redactText(before).text;
              if (after !== before) changedTextParts++;
              state.error = after;
              continue;
            }
            if (state.status === "pending" && typeof state.raw === "string") {
              const before = state.raw;
              const after = session.redactText(before).text;
              if (after !== before) changedTextParts++;
              state.raw = after;
              continue;
            }
          }
        }
      }

      if (debug && changedTextParts > 0) {
        console.log(`[Vibeguard] changedTextParts: ${changedTextParts}`);
      }
    },

    "experimental.text.complete": async (input, output) => {
      if (!output || typeof output !== "object") return;
      if (typeof output.text !== "string" || !output.text) return;
      const session = getSession(input?.sessionID);
      if (!session) return;
      session.evictOldest();
      const before = output.text;
      const after = session.restoreText(before);
      output.text = after;
      if (debug && after !== before) {
        console.log("[Vibeguard] done with text.complete restoreText");
      }
    },

    "tool.execute.before": async (input, output) => {
      const session = getSession(input?.sessionID);
      if (!session) return;
      session.evictOldest();
      session.restoreDeep(output?.args);
    },
  };
};
