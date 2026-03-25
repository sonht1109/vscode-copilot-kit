#!/bin/bash
# permission-alert.sh

WORK_DIR="$PWD"
BASH_SOURCE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

TITLE="🏁 Session Completed"

bash $BASH_SOURCE_DIR/notify.sh -title "$TITLE" -message "$WORK_DIR"