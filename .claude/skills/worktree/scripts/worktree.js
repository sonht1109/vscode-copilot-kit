const { execSync } = require("child_process");
const { readFileSync, symlinkSync } = require("fs");
const os = require("os");
const path = require("path");

const git = (cmd, options = {}) => {
  try {
    const res = execSync(`git ${cmd}`, {
      encoding: "utf-8",
      stdio: "pipe",
      cwd: options.cwd || process.cwd(),
    }).trim();

    return {
      success: true,
      data: res,
    };
  } catch (error) {
    return {
      success: false,
      error: error.message,
    };
  }
};

const checkGitRepo = () => {
  // check if .git exists
  const res = git("rev-parse --show-toplevel");

  if (!res.success) {
    console.error("Not a git repository.");
    process.exit(1);
  }
};

const checkBranchExists = (branch) => {
  const res = git(`rev-parse --verify ${branch}`);
  return res.success;
};

const checkBranchCheckouted = (branch) => {
  const res = git("worktree list --porcelain");
  if (res.success) {
    return res.data.includes(`branch refs/heads/${branch}`);
  }
  return false;
};

const linkWorktreeInclude = (sourceDir, targetDir) => {
  // read .worktreeinclude
  const includeFile = path.join(os.homedir(), ".config", "vscode-copilot-kit", ".worktreeinclude");
  const content = readFileSync(includeFile, "utf-8");
  const lines = content
    .split("\n")
    .map((line) => line.trim())
    .filter((line) => line && !line.startsWith("#"));

  for (const line of lines) {
    const sourcePath = path.join(sourceDir, line);
    const targetPath = path.join(targetDir, line);

    // create symlink
    try {
      symlinkSync(sourcePath, targetPath);
      console.log(`Linked ${sourcePath} to ${targetPath}`);
    } catch (error) {
      console.error(
        `Failed to link ${sourcePath} to ${targetPath}:`,
        error.message,
      );
    }
  }
};

const createWorktree = (featureBranch, baseBranch, worktreeRoot) => {
  checkGitRepo();

  // check if branch is checkouted
  const branchCheckouted = checkBranchCheckouted(featureBranch);
  if (branchCheckouted) {
    console.error(
      `Branch ${featureBranch} is already checkouted in a worktree.`,
    );
    process.exit(1);
  }

  // check if branch exists
  const branchExists = checkBranchExists(featureBranch);

  // create worktree
  const branchDir = path.join(
    worktreeRoot,
    featureBranch.replace(/[^\w-]/g, "-"),
  );

  let res;
  if (branchExists) {
    res = git(`worktree add ${branchDir} ${featureBranch}`);
  } else {
    res = git(`worktree add -b ${featureBranch} ${branchDir} ${baseBranch}`);
  }

  if (!res.success) {
    console.error("Failed to create worktree:", res.error);
    process.exit(1);
  }

  // read .worktreeinclude and then do link
  linkWorktreeInclude(process.cwd(), branchDir);

  console.log(`Worktree for branch ${featureBranch} created at ${branchDir}`);
};

const listWorktrees = () => {
  checkGitRepo();

  const res = git("worktree list");
  if (!res.success) {
    console.error("Failed to list worktrees:", res.error);
    process.exit(1);
  }

  const worktrees = res.data
    .split("\n")
    .filter(Boolean)
    .map((line) => {
      const parts = line.split(/\s+/);
      return {
        path: parts[0],
        commit: parts[1],
        branch: parts[2]?.replace(/[\[\]]/g, "") || "detached",
      };
    });

  console.log(worktrees);
};

const removeWorktree = (path) => {
  checkGitRepo();
  const res = git(`worktree remove ${path} --force`);
  if (!res.success) {
    console.error("Failed to remove worktree:", res.error);
    process.exit(1);
  }

  console.log(`Worktree at ${path} removed.`);
};

const main = () => {
  const args = process.argv.slice(2);
  let baseBranch = "develop";
  let featureBranch = "";

  let worktreeRoot = ".worktrees";
  let action = "create";
  let path = "";

  for (const arg of args) {
    if (arg.startsWith("--base=")) {
      baseBranch = arg.replace("--base=", "");
    } else if (arg.startsWith("--branch=")) {
      featureBranch = arg.replace("--branch=", "");
    } else if (arg.startsWith("--worktree-root=")) {
      worktreeRoot = arg.replace("--worktree-root=", "");
    } else if (arg.startsWith("--action=")) {
      action = arg.replace("--action=", "");
    } else if (arg.startsWith("--path=")) {
      path = arg.replace("--path=", "");
    }
  }

  const usage = `. Usage: node worktree.js --branch=feature-branch-name [--base=base-branch-name] [--worktree-root=path-to-worktree-root] [--action=create|list|remove] [--path=path-to-remove]`;

  if (action === "create" && !featureBranch) {
    console.error("Please provide feature branch." + usage);
    process.exit(1);
  }

  if (!worktreeRoot) {
    console.error("Please provide worktree root." + usage);
    process.exit(1);
  }

  if (action === "remove" && !path) {
    console.error("Please provide path to remove." + usage);
    process.exit(1);
  }

  switch (action) {
    case "create":
      createWorktree(featureBranch, baseBranch, worktreeRoot);
      break;
    case "list":
      listWorktrees();
      break;
    case "remove":
      removeWorktree(path);
      break;
    case "help":
      console.log(usage);
      break;
    default:
      console.error("Invalid action." + usage);
      process.exit(1);
  }
};

main();
