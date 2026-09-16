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

const BUILTIN_SECRETS = [
  {
    pattern: "\\bAKIA[0-9A-Z]{16}\\b",
    flags: "",
    category: "AWS_ACCESS_KEY_ID",
  },
  {
    pattern: "\\bASIA[0-9A-Z]{16}\\b",
    flags: "",
    category: "AWS_SESSION_KEY_ID",
  },
  {
    pattern:
      "(?<=aws[_-]?secret[_-]?access[_-]?key\\s*[=:]\\s*['\"]?)[A-Za-z0-9/+=]{40}",
    flags: "i",
    category: "AWS_SECRET_ACCESS_KEY",
  },
  {
    pattern: '(?<="private_key"\\s*:\\s*")[^"]{20,}',
    flags: "",
    category: "GCP_PRIVATE_KEY",
  },
  {
    pattern:
      "-----BEGIN(?:\\s+(?:RSA|EC|DSA|OPENSSH|PGP))?\\s+PRIVATE KEY(?:\\s+BLOCK)?-----[\\s\\S]*?-----END(?:\\s+(?:RSA|EC|DSA|OPENSSH|PGP))?\\s+PRIVATE KEY(?:\\s+BLOCK)?-----",
    flags: "",
    category: "PRIVATE_KEY",
  },
  {
    pattern:
      "-----BEGIN(?:\\s+(?:RSA|EC|DSA|OPENSSH|PGP))?\\s+PRIVATE KEY(?:\\s+BLOCK)?-----",
    flags: "",
    category: "PRIVATE_KEY_HEADER",
  },
  {
    pattern: "\\bsk-(?:proj-|svcacct-)?[A-Za-z0-9_\\-]{20,}\\b",
    flags: "",
    category: "OPENAI_API_KEY",
  },
  {
    pattern: "\\bsk-ant-[A-Za-z0-9\\-_]{20,}\\b",
    flags: "",
    category: "ANTHROPIC_API_KEY",
  },
  {
    pattern: "\\bAIza[A-Za-z0-9_-]{35}\\b",
    flags: "",
    category: "GOOGLE_API_KEY",
  },
  {
    pattern:
      "\\bxox(?:b-[0-9]{10,13}-[0-9]{10,13}[A-Za-z0-9-]*|[pe](?:-[0-9]{10,13}){3}-[A-Za-z0-9-]{28,34}|a-[0-9]-[A-Z0-9]+-[0-9]+-[a-z0-9]+|r-[A-Za-z0-9-]{10,}|s-[0-9]+-[A-Za-z0-9-]{10,})\\b",
    flags: "i",
    category: "SLACK_TOKEN",
  },
  {
    pattern:
      "https://hooks\\.slack\\.com/services/T[A-Za-z0-9_]{8,}/B[A-Za-z0-9_]{8,}/[A-Za-z0-9_]{20,}",
    flags: "",
    category: "SLACK_WEBHOOK_URL",
  },
  {
    pattern: "\\b[rs]k_(?:test|live|prod)_[A-Za-z0-9]{10,99}\\b",
    flags: "",
    category: "STRIPE_API_KEY",
  },
  {
    pattern: "\\b(?:gh[pousr]|github_pat)_[A-Za-z0-9_]{22,}\\b",
    flags: "",
    category: "GITHUB_TOKEN",
  },
  {
    pattern: "\\bglpat-[0-9A-Za-z\\-_]{20,}\\b",
    flags: "",
    category: "GITLAB_TOKEN",
  },
  {
    pattern:
      "\\beyJ[A-Za-z0-9\\-_]{10,}\\.eyJ[A-Za-z0-9\\-_]{10,}\\.[A-Za-z0-9\\-_.+/=]{10,}\\b",
    flags: "",
    category: "JWT",
  },
  {
    pattern: "\\bhvs\\.[A-Za-z0-9_-]{24,}\\b",
    flags: "",
    category: "VAULT_TOKEN",
  },
  {
    pattern: "\\bs\\.[A-Za-z0-9]{24,}\\b",
    flags: "",
    category: "VAULT_SERVICE_TOKEN",
  },
  {
    pattern: "\\bdp\\.pt\\.[A-Za-z0-9]+\\b",
    flags: "",
    category: "DOPPLER_TOKEN",
  },
  {
    pattern: '\\bop://[^\\s"]+',
    flags: "",
    category: "ONEPASSWORD_REF",
  },
  {
    pattern: "\\bSG\\.[A-Za-z0-9_-]{22}\\.[A-Za-z0-9_-]{43}\\b",
    flags: "",
    category: "SENDGRID_API_KEY",
  },
  {
    pattern: "\\bnpm_[A-Za-z0-9]{36}\\b",
    flags: "",
    category: "NPM_TOKEN",
  },
  {
    pattern:
      "(?<=[a-z][a-z0-9+.\\-]{0,31}://(?:[^:/\\s]{1,64})?:)[^\\s@/]{3,}(?=@)",
    flags: "i",
    category: "URL_PASSWORD",
  },
  {
    pattern:
      "(?<=(?:^|[\\s{[,;])['\"]?(?:[a-z0-9]{1,32}[_.\\-]){0,4}(?:api[_-]?keys?|apikeys?|client[_-]?secret|app[_-]?secret|password|passwd|pwd|access[_-]?token|refresh[_-]?token|auth[_-]?token|bearer|private[_-]?key|vault[_-]?token|doppler[_-]?token|stripe[_-]?(?:key|secret)|sendgrid[_-]?key|npm[_-]?token|secret|token|credential|credentials|key|access|refresh)['\"]?\\s*[=:]\\s*['\"]?)(?!\\$\\{|process\\.env\\.|import\\.meta\\.env\\.|deno\\.env\\.|env\\.|config\\.|settings\\.|secret\\.|secrets\\.)[A-Za-z0-9][A-Za-z0-9\\-_./+=]{19,}",
    flags: "i",
    category: "SENSITIVE_VALUE",
  },
  {
    pattern:
      "(?<=(?:^|[\\s{[,;])['\"]?(?:[a-z0-9]{1,32}[_.\\-]){0,4}(?:password|passwd|pwd|pass)['\"]?\\s*[=:]\\s*['\"]?)(?!\\$\\{|process\\.env\\.|import\\.meta\\.env\\.|deno\\.env\\.|env\\.|config\\.|settings\\.|secret\\.|secrets\\.)[^\\s'\"]{8,}",
    flags: "i",
    category: "PASSWORD_VALUE",
  },
];

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

  regexRules.unshift(
    ...BUILTIN_SECRETS.map((r) => ({
      pattern: r.pattern,
      flags: r.flags,
      category: r.category,
    })),
  );

  return {
    keywords: keywordRules,
    regex: regexRules,
    exclude: excludeSet,
  };
}
