const fs = require("fs");
const rl = require("readline");

const eligibleFileExts = [".ts", ".tsx", ".js", ".jsx", ".go"];

async function separatePatch(prNumber) {
  if (!prNumber) {
    throw new Error("PR number is required as the first argument.");
  }

  const patchFileDir = `${process.cwd()}/notes/prs/${prNumber}/diff.patch`;

  if (!fs.existsSync(patchFileDir)) {
    throw new Error(
      `Patch file for PR #${prNumber} does not exist at path: ${patchFileDir}`,
    );
  }

  // create dir
  const prDir = `${process.cwd()}/notes/prs/${prNumber}/contents`;
  if (!fs.existsSync(prDir)) {
    fs.mkdirSync(prDir, { recursive: true });
  }

  const patchContent = fs.createReadStream(patchFileDir, "utf8");
  const rlInterface = rl.createInterface({
    input: patchContent,
    crlfDelay: Infinity,
  });

  let lastFilePath = null;
  let filePatchStream = null;

  for await (const line of rlInterface) {
    if (line.startsWith("diff --git")) {
      if (filePatchStream) {
        filePatchStream.end();
      }
      // this is the start of a new file patch
      const filePath = line.split(" b/")[1];
      const isEligible = eligibleFileExts.some((ext) => filePath.endsWith(ext));
      if (!isEligible) {
        lastFilePath = null;
        filePatchStream = null;
        continue; // skip non-eligible files
      }
      console.log(`New file patch detected for: ${filePath}`);

      lastFilePath = filePath;
      // create a new file to store this patch
      filePatchStream = fs.createWriteStream(
        `${process.cwd()}/notes/prs/${prNumber}/contents/${lastFilePath.replace(/\//g, "_")}-patch.patch`,
      );
    }
    if (filePatchStream) {
      filePatchStream.write(line + "\n");
    }
  }
  if (filePatchStream) {
    filePatchStream.end();
  }
}

if (require.main === module) {
  const prNumber = process.argv[2];
  separatePatch(prNumber).catch((err) => {
    console.error("Error separating patch:", err);
    process.exit(1);
  });
}

module.exports = separatePatch;
