echo "Pulling latest changes from the repository..."

cd "$SCRIPT_DIR" && git pull origin main && cd "$TARGET_DIR"