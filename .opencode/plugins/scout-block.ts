import { Plugin } from "@opencode-ai/plugin";
import fs from "fs/promises";
import path from "path";
import os from "os"

const getProtectionPatterns = async (): Promise<string[]> => {
  const filePath = path.join(os.homedir(), ".config", "vscode-copilot-kit", ".agentignore");
  const content = await fs.readFile(filePath, "utf8");

  return content
    .split(/\r?\n/)
    .map((line: string) => line.trim())
    .filter((line: string) => line && !line.startsWith("#"))
    .filter(Boolean);
};

const matchesPattern = (text: string, pattern: string): boolean => {
  // Escape regex special characters in the pattern
  const escaped = pattern.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  // Match as a complete path segment (not a prefix/suffix of another segment)
  const regex = new RegExp(`(^|[/\\\\])${escaped}([/\\\\]|$)`);
  return regex.test(text);
};

export const ScoutBlock: Plugin = async ({}) => {
  const patterns = await getProtectionPatterns();

  return {
    "tool.execute.before": async (input, output) => {
      const error = new Error(
        "Files are protected intentionally and cannot be accessed by any tools. Do not try again.",
      );
      if (
        input.tool === "read" &&
        patterns.some((pattern) => matchesPattern(output.args?.filePath ?? "", pattern))
      ) {
        throw error;
      }
      if (
        input.tool === "bash" &&
        patterns.some((pattern) => matchesPattern(output.args?.command ?? "", pattern))
      ) {
        throw error;
      }
    },
  };
};
