#!/usr/bin/env node

/**
 * Development Rules Reminder
 *
 * Injects modularization reminders before Session start.
 *
 * Exit Codes:
 *   0 - Success (non-blocking, allows continuation)
 */

const fs = require('fs');
const os = require('os');
const path = require('path');
const { execSync } = require('child_process');

function getGitRemoteUrl() {
  try {
    const url = execSync('git config --get remote.origin.url', {
      stdio: ['ignore', 'pipe', 'ignore'],
    })
      .toString()
      .trim();

    return url || 'Not available';
  } catch (error) {
    return 'Not available';
  }
}

function getPythonVersion() {
  const commands = ['python3 --version', 'python --version'];

  for (const cmd of commands) {
    try {
      const output = execSync(cmd, { stdio: ['ignore', 'pipe', 'ignore'] })
        .toString()
        .trim();

      if (output) {
        return output;
      }
    } catch (error) {
      // Try next command
    }
  }

  return 'Not available';
}

function getGoVersion() {
  try {
    const output = execSync('go version', { stdio: ['ignore', 'pipe', 'ignore'] })
      .toString()
      .trim();

    return output || 'Not available';
  } catch (error) {
    return 'Not available';
  }
}

/**
 * Main hook execution
 */
async function main() {
  try {
    const currentUser =
      process.env.USERNAME || process.env.USER || process.env.LOGNAME || os.userInfo().username;
    const gitRemoteUrl = getGitRemoteUrl();
    const pythonVersion = getPythonVersion();
    const nodeVersion = process.version || 'Not available';
    const goVersion = getGoVersion();
    const reminder = [
      `## Current environment`,
      `- Date time: ${new Date().toLocaleString()}`,
      `- Timezone: ${Intl.DateTimeFormat().resolvedOptions().timeZone}`,
      `- Claude Code settings directory: ${path.resolve(__dirname, '..')}`,
      `- Current working dir (cwd): ${process.cwd()}`,
      `- Git: ${gitRemoteUrl}`,
      `- Node: ${nodeVersion}`,
      `- Python: ${pythonVersion}`,
      `- Go: ${goVersion}`,
      `- OS: ${process.platform}`,
      `- User: ${currentUser}`,
      `- Locale: ${process.env.LANG}`,
      `- IMPORTANT: Include these environment information when prompting subagents to perform tasks.`,
    ].join('\n');

    console.log(reminder);
    process.exit(0);
  } catch (error) {
    // Fail-open: log error but allow operation to continue
    console.error(`Dev rules hook error: ${error.message}`);
    process.exit(0);
  }
}

main();
