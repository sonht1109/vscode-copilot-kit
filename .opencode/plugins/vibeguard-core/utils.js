export function sanitizeCategory(input) {
  const raw = String(input ?? "").trim();
  if (!raw) return "TEXT";
  const upper = raw.toUpperCase();
  const safe = upper.replace(/[^A-Z0-9_]/g, "_").replace(/_+/g, "_");
  if (!safe) return "TEXT";
  return safe;
}

export function toHexLower(buffer) {
  return Buffer.from(buffer).toString("hex");
}

/**
 * @param {string} pattern
 * @param {string} flags
 */
export function peelInlineFlags(pattern, flags) {
  let p = String(pattern ?? "");
  let f = String(flags ?? "");

  for (;;) {
    if (p.startsWith("(?i)")) {
      p = p.slice(4);
      if (!f.includes("i")) f += "i";
      continue;
    }
    if (p.startsWith("(?m)")) {
      p = p.slice(4);
      if (!f.includes("m")) f += "m";
      continue;
    }
    break;
  }

  return { pattern: p, flags: f };
}