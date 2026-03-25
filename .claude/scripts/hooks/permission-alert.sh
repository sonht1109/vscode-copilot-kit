#!/bin/bash
# permission-alert.sh

WORK_DIR="$PWD"
BASH_SOURCE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

bash $BASH_SOURCE_DIR/notify.sh -title "🔐 Permission Requested" -message "$WORK_DIR"