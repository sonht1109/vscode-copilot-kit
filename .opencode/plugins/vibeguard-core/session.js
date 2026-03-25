import { createHmac, randomBytes } from "crypto";
import { redactText, restoreText } from "./engine.js";
import { redactDeep, restoreDeep } from "./deep.js";
import { sanitizeCategory, toHexLower } from "./utils.js";

export class PlaceholderSession {
  /**
   * @param {{ prefix: string, maxMappings: number, secret?: Uint8Array, patterns: any }} options
   */
  constructor(options) {
    const prefix = String(options?.prefix ?? "__VG_");
    this.prefix = String(prefix).replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
    this.maxMappings = Number.isFinite(options?.maxMappings)
      ? Number(options.maxMappings)
      : 100000;
    this.secret = options?.secret
      ? Uint8Array.from(options.secret)
      : randomBytes(32);
    this.patterns = options.patterns;

    /** @type {Map<string,string>} */
    this.forward = new Map();
    /** @type {Map<string,string>} */
    this.reverse = new Map();
  }

  evictOldest() {
    if (this.forward.size < this.maxMappings) return;

    const oldest = Array.from(this.forward).slice(
      0,
      this.forward.size - this.maxMappings - 1,
    );

    for (const [placeholder] of oldest) {
      this.forward.delete(placeholder);
      const original = this.reverse.get(placeholder);
      if (original) {
        this.reverse.delete(original);
      }
    }
  }

  lookup(placeholder) {
    return this.forward.get(placeholder);
  }

  lookupReverse(original) {
    return this.reverse.get(original);
  }

  /**
   * placeholder = `${prefix}${CATEGORY}_${hash12}__`
   * @param {string} original
   * @param {string} category
   */
  generatePlaceholder(original, category) {
    const cat = sanitizeCategory(category);
    const h = createHmac("sha256", this.secret);
    h.update(String(original));
    const sum = h.digest();
    const hash12 = toHexLower(sum).slice(0, 12);
    const base = `${this.prefix}${cat}_${hash12}`;
    return `${base}__`;
  }

  /**
   * @param {string} original
   * @param {string} category
   */
  getOrCreatePlaceholder(original, category) {
    const existing = this.lookupReverse(original);
    if (existing) return existing;

    const base = this.generatePlaceholder(original, category);
    const current = this.forward.get(base);
    if (current === undefined) {
      this.forward.set(base, original);
      this.reverse.set(original, base);

      return base;
    }

    if (current === original) {
      this.reverse.set(original, base);
      return base;
    }

    // there would be a rare hash collision (2 different originals but same hash), we need to find a unique placeholder by appending _N
    const withoutSuffix = base.slice(0, -2); // replace "__"
    for (let i = 2; ; i++) {
      const candidate = `${withoutSuffix}_${i}__`;
      const prev = this.forward.get(candidate);
      if (prev === undefined) {
        this.forward.set(candidate, original);
        this.reverse.set(original, candidate);
        return candidate;
      }
      if (prev === original) {
        this.reverse.set(original, candidate);
        return candidate;
      }
    }
  }

  getPlaceholderRegex() {
    // Pattern: __VG_CATEGORY_HASH12__ or __VG_CATEGORY_HASH12_N__
    return new RegExp(
      `${this.prefix}[A-Za-z0-9_]+_[a-f0-9A-F]{12}(?:_\\d+)?__`,
      "g",
    );
  }

  redactText(text) {
    const session = this;
    return redactText(text, this.patterns, session);
  }

  restoreText(text) {
    const session = this;
    return restoreText(text, session);
  }

  redactDeep(obj) {
    const session = this;
    return redactDeep(obj, this.patterns, session);
  }

  restoreDeep(obj) {
    const session = this;
    return restoreDeep(obj, session);
  }
}
