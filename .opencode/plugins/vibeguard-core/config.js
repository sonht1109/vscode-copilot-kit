import fs from "fs";
import os from "os";
import path from "path";

const getConfigCandidates = () => {
  const home = os.homedir();
  const homeConfig = path.join(
    home,
    ".config",
    "vscode-copilot-kit",
    "vibeguard.config.json",
  );
  return [homeConfig]; // can be extended to include more paths, e.g., project-level config
};

const nomalizeConfig = (config) => {
  const enabled = Boolean(config.enabled);
  const patterns =
    config.patterns && typeof config.patterns === "object"
      ? config.patterns
      : {};
  const prefix =
    typeof config.placeholder_prefix === "string"
      ? config.placeholder_prefix
      : "__VG__PLACEHOLDER__";
  const maxMappings =
    typeof config.max_mappings === "number" && config.max_mappings > 0
      ? config.max_mappings
      : 1000;
  const debug = Boolean(config.debug);

  return {
    enabled,
    debug,
    patterns,
    prefix,
    maxMappings,
  };
};

/**
 * @typedef {Object} VibeguardConfig
 * @property {boolean} enabled
 * @property {boolean} debug
 * @property {Object.<string, string>} patterns
 * @property {string} prefix
 * @property {number} maxMappings
 *
 * @returns {VibeguardConfig}
 */
export const loadConfig = () => {
  const paths = getConfigCandidates();
  for (const p of paths) {
    if (!fs.existsSync(p)) continue;
    try {
      const content = fs.readFileSync(p, "utf-8");
      const config = JSON.parse(content);
      return nomalizeConfig(config);
    } catch (e) {
      console.warn(`Failed to load config from ${p}:`, e);
    }
  }

  return { enabled: false };
};
