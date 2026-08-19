#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

LOG_FILE="$SCRIPT_DIR/application.log"
REPORT_FILE="$SCRIPT_DIR/monitor_report.txt"

touch "$LOG_FILE"

ERROR_COUNT=$(grep -Eic \
"ERROR|FAILED|FAILURE|FATAL|CRITICAL|Permission denied|Connection refused|Timeout" \
"$LOG_FILE" || true)

{
    echo "========================================"
    echo "        LOG MONITORING REPORT"
    echo "========================================"
    echo
    echo "Time: $(date)"
    echo "Host: $(hostname)"
    echo "User: $(whoami)"
    echo
    echo "ERROR COUNT: $ERROR_COUNT"

    if [ "$ERROR_COUNT" -eq 0 ]
    then

        echo "STATUS: NORMAL"
        echo
        echo "No errors detected."
        echo
        echo "ACTION:"
        echo "Continue normal monitoring."

    else

        echo "STATUS: ERROR DETECTED"
        echo
        echo "Detected Errors:"

        grep -Ei \
        "ERROR|FAILED|FAILURE|FATAL|CRITICAL|Permission denied|Connection refused|Timeout" \
        "$LOG_FILE" || true

        echo
        echo "ACTION:"
        echo "Investigate the detected errors."

    fi

    echo
    echo "Monitoring completed."
    echo "========================================"

} > "$REPORT_FILE"

cat "$REPORT_FILE"
