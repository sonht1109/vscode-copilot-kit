import { loadConfig } from "./config.js";
import { buildPatternSet } from "./pattern.js";
import { PlaceholderSession } from "./session.js";

export const vibeguard = () => {
  const config = loadConfig();
  const debug = config.debug;

  if (debug) {
    console.log(
      `[VibeGuardAdapter] Initialized with patterns: ${JSON.stringify(config.patterns)}`,
    );
  }

  return {
    config,
    initSession: () => {
      return new PlaceholderSession({
        prefix: config.prefix,
        maxMappings: config.maxMappings,
        patterns: buildPatternSet(config.patterns),
      });
    },
  };
};
