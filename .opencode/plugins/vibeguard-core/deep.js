import { redactText, restoreText } from "./engine.js";

function isPlainObject(value) {
  if (!value || typeof value !== "object") return false;
  if (Array.isArray(value)) return false;
  const proto = Object.getPrototypeOf(value);
  return proto === Object.prototype || proto === null;
}

/**
 * @param {unknown} value
 * @param {{ prefix: string, lookup(ph: string): string | undefined }} session
 */
export function restoreDeep(value, session) {
  const seen = new WeakSet();

  const walk = (node) => {
    if (!node || typeof node !== "object") return;
    if (seen.has(node)) return;
    seen.add(node);

    if (Array.isArray(node)) {
      for (let i = 0; i < node.length; i++) {
        const v = node[i];
        if (typeof v === "string") node[i] = restoreText(v, session);
        if (v && typeof v === "object") walk(v);
      }
      return;
    }

    if (!isPlainObject(node)) return;

    for (const key of Object.keys(node)) {
      const v = node[key];
      if (typeof v === "string") node[key] = restoreText(v, session);
      if (v && typeof v === "object") walk(v);
    }
  };

  walk(value);
}

/**
 * @param {unknown} value
 * @param {{ keywords: Array<{value:string,category:string}>, regex: Array<{pattern:string,flags:string,category:string}>, exclude: Set<string> }} patterns
 * @param {{ getOrCreatePlaceholder(original: string, category: string): string }} session
 */
export function redactDeep(value, patterns, session) {
  const seen = new WeakSet();

  const walk = (node) => {
    if (!node || typeof node !== "object") return;
    if (seen.has(node)) return;
    seen.add(node);

    if (Array.isArray(node)) {
      for (let i = 0; i < node.length; i++) {
        const v = node[i];
        if (typeof v === "string")
          node[i] = redactText(v, patterns, session).text;
        if (v && typeof v === "object") walk(v);
      }
      return;
    }

    if (!isPlainObject(node)) return;

    for (const key of Object.keys(node)) {
      const v = node[key];
      if (typeof v === "string")
        node[key] = redactText(v, patterns, session).text;
      if (v && typeof v === "object") walk(v);
    }
  };

  walk(value);
}
