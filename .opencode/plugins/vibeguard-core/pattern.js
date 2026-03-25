import { sanitizeCategory, peelInlineFlags } from "./utils.js";

const BUILTIN = new Map([
  [
    "email",
    {
      pattern: String.raw`[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}`,
      flags: "i",
      category: "EMAIL",
    },
  ],
  [
    "uuid",
    {
      pattern: String.raw`[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}`,
      flags: "",
      category: "UUID",
    },
  ],
  [
    "ipv4",
    {
      pattern: String.raw`(?:\d{1,3}\.){3}\d{1,3}`,
      flags: "",
      category: "IPV4",
    },
  ],
  [
    "mac",
    {
      pattern: String.raw`(?:[0-9a-f]{2}:){5}[0-9a-f]{2}`,
      flags: "i",
      category: "MAC",
    },
  ],
  [
    "openai_key",
    {
      pattern: String.raw`sk-[A-Za-z0-9]{48}`,
      flags: "",
      category: "OPENAI_KEY",
    },
  ],
  [
    "github_token",
    {
      pattern: "(ghp|gho|ghu|ghs|ghr)_[A-Za-z0-9]+",
      flags: "",
      category: "GITHUB_TOKEN",
    },
  ],
  [
    "aws_access_key",
    {
      pattern: String.raw`AKIA[0-9A-Z]{16}`,
      flags: "",
      category: "AWS_ACCESS_KEY",
    },
  ],
]);

export function buildPatternSet(patterns) {
  const raw = patterns && typeof patterns === "object" ? patterns : {};

  const keywords = Array.isArray(raw.keywords) ? raw.keywords : [];
  const regex = Array.isArray(raw.regex) ? raw.regex : [];
  const builtin = Array.isArray(raw.builtin) ? raw.builtin : [];
  const exclude = Array.isArray(raw.exclude) ? raw.exclude : [];

  const keywordRules = keywords
    .map((x) => {
      if (!x || typeof x !== "object") return null;
      const value = String(x.value ?? "").trim();
      if (!value) return null;
      const category = sanitizeCategory(x.category);
      return { value, category };
    })
    .filter(Boolean);

  const regexRules = [];

  for (const x of regex) {
    if (!x || typeof x !== "object") continue;
    const pattern = String(x.pattern ?? "").trim();
    if (!pattern) continue;
    const category = sanitizeCategory(x.category);
    const flags = typeof x.flags === "string" ? x.flags : "";
    const peeled = peelInlineFlags(pattern, flags);
    regexRules.push({ pattern: peeled.pattern, flags: peeled.flags, category });
  }

  for (const name of builtin) {
    const key = String(name ?? "").trim();
    if (!key) continue;
    const rule = BUILTIN.get(key);
    if (!rule) continue;
    regexRules.push({
      pattern: rule.pattern,
      flags: rule.flags,
      category: rule.category,
    });
  }

  const excludeSet = new Set(exclude.map((x) => String(x ?? "")));

  return {
    keywords: keywordRules,
    regex: regexRules,
    exclude: excludeSet,
  };
}
