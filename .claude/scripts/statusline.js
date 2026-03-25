#!/usr/bin/env node
'use strict';

/**
 * Custom Claude Code statusline for Node.js
 * Cross-platform support: Windows, macOS, Linux
 * Theme: detailed | Colors: true | Features: directory, git, model, usage, session, tokens
 * No external dependencies - uses only Node.js built-in modules
 */

const { stdin, stdout, env } = require('process');
const { execSync } = require('child_process');
const os = require('os');

// Configuration
const USE_COLOR = env.FORCE_COLOR || (!env.NO_COLOR && stdout.isTTY);

// Color helpers
const color = (code) => (USE_COLOR ? `\x1b[${code}m` : '');
const reset = () => (USE_COLOR ? '\x1b[0m' : '');

// Color definitions
const DirColor = color('36'); // cyan
const GitColor = color('32'); // green
const GitBranchColor = color('34'); // blue
const ModelColor = color('35'); // magenta
const VersionColor = color('33'); // yellow
const UsageColor = color('35'); // magenta
const CostColor = color('36'); // cyan
const GrayoutColor = color('90'); // dark gray
const Reset = reset();

function formatNumber(num) {
  const units = [
    { value: 1e9, symbol: 'B' },
    { value: 1e6, symbol: 'M' },
    { value: 1e3, symbol: 'K' },
  ];

  for (const unit of units) {
    if (num >= unit.value) {
      const result = num / unit.value;
      return `${Number(result.toFixed(result % 1 === 0 ? 0 : 1))}${unit.symbol}`;
    }
  }

  return String(num);
}

/**
 * Safe command execution wrapper
 */
function exec(cmd) {
  try {
    return execSync(cmd, {
      encoding: 'utf8',
      stdio: ['pipe', 'pipe', 'ignore'],
      windowsHide: true,
    }).trim();
  } catch (err) {
    return '';
  }
}

/**
 * Get session color based on remaining percentage
 */
function getSessionColor(sessionPercent) {
  if (!USE_COLOR) return '';

  const remaining = 100 - sessionPercent;
  if (remaining <= 10) {
    return '\x1b[31m'; // red
  } else if (remaining <= 25) {
    return '\x1b[33m'; // yellow
  } else {
    return '\x1b[32m'; // green
  }
}

/**
 * Check git status - returns true if working directory is clean
 */
function isGitClean() {
  const status = exec('git status --porcelain');
  return status === '';
}

/**
 * Expand home directory to ~
 */
function expandHome(path) {
  const homeDir = os.homedir();
  if (path.startsWith(homeDir)) {
    return path.replace(homeDir, '~');
  }
  return path;
}

/**
 * Read stdin asynchronously
 */
async function readStdin() {
  return new Promise((resolve, reject) => {
    const chunks = [];
    stdin.setEncoding('utf8');

    stdin.on('data', (chunk) => {
      chunks.push(chunk);
    });

    stdin.on('end', () => {
      resolve(chunks.join(''));
    });

    stdin.on('error', (err) => {
      reject(err);
    });
  });
}

/**
 * Main function
 */
async function main() {
  try {
    // Read and parse JSON input
    const input = await readStdin();
    if (!input.trim()) {
      console.error('No input provided');
      process.exit(1);
    }

    const data = JSON.parse(input);

    const usedPercent = data?.context_window?.used_percentage;
    const contextWindowSize = data?.context_window?.context_window_size;
    const inputTokens = data?.context_window?.total_input_tokens || 0;
    const outputTokens = data?.context_window?.total_output_tokens || 0;

    // Extract basic information
    let currentDir = 'unknown';
    if (data.workspace?.current_dir) {
      currentDir = data.workspace.current_dir;
    } else if (data.cwd) {
      currentDir = data.cwd;
    }
    currentDir = expandHome(currentDir);

    const modelName = data.model?.display_name || 'Claude';
    const modelVersion =
      data.model?.version && data.model.version !== 'null' ? data.model.version : '';

    // Git branch detection and status
    let gitBranch = '';
    let gitStatus = '';
    const gitCheck = exec('git rev-parse --git-dir');
    if (gitCheck) {
      gitBranch = exec('git branch --show-current');
      if (!gitBranch) {
        gitBranch = exec('git rev-parse --short HEAD');
      }
      // Check if git status is clean
      if (!isGitClean()) {
        gitStatus = '✗';
      }
    }

    // Native Claude Code data integration
    let sessionText = '';
    let sessionPercent = 0;
    let costUSD = '';
    let linesAdded = 0;
    let linesRemoved = 0;
    const billingMode = env.CLAUDE_BILLING_MODE || 'api';

    // Extract native cost data from Claude Code
    costUSD = data.cost?.total_cost_usd || '';
    linesAdded = data.cost?.total_lines_added || 0;
    linesRemoved = data.cost?.total_lines_removed || 0;

    // Render statusline
    let output = '';

    // Directory
    output += `${DirColor}${currentDir}${Reset} ${ModelColor}[${modelName}]${Reset}`;

    // Git status indicator
    if (gitStatus) {
      const statusColor = color('31'); // red
      output += ` ${statusColor}${gitStatus}${Reset}`;
    }

    // Git branch
    if (gitBranch) {
      output += `  ${GitBranchColor}⎇  ${gitBranch}${Reset}`;
    }

    if (contextWindowSize && usedPercent) {
      output += `  📋 ${GrayoutColor}${usedPercent}%/${formatNumber(
        +contextWindowSize,
      )} tokens${Reset}`;
    } else if (contextWindowSize) {
      output += `  📋 ${GrayoutColor}${formatNumber(+contextWindowSize)} tokens${Reset}`;
    }

    output += `  📦 ${GrayoutColor}In:${formatNumber(+inputTokens)} Out:${formatNumber(+outputTokens)}${Reset}`;

    // Model version
    if (modelVersion) {
      output += `  🏷️ ${VersionColor}${modelVersion}${Reset}`;
    }

    // Session time
    if (sessionText) {
      const sessionColorCode = getSessionColor(sessionPercent);
      output += `  ⌛ ${sessionColorCode}${sessionText}${Reset}`;
    }

    // Cost (only show for API billing mode)
    if (billingMode === 'api' && costUSD && /^\d+(\.\d+)?$/.test(costUSD.toString())) {
      const costUSDNum = parseFloat(costUSD);
      output += `  💸 ${CostColor}$${costUSDNum.toFixed(4)}${Reset}`;
    }

    // Lines changed
    // if (linesAdded > 0 || linesRemoved > 0) {
    //   const linesColor = color('32'); // green
    //   output += `  📝 ${linesColor}+${linesAdded} -${linesRemoved}${Reset}`;
    // }

    console.log(output);
  } catch (err) {
    console.error('Error:', err.message);
    process.exit(1);
  }
}

main().catch((err) => {
  console.error('Fatal error:', err);
  process.exit(1);
});
