#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

MONITOR_FILE="$SCRIPT_DIR/monitor_report.txt"
FINAL_FILE="$SCRIPT_DIR/final_report.txt"

if [ ! -f "$MONITOR_FILE" ]
then
    echo "ERROR: monitor_report.txt not found."
    exit 1
fi

ERROR_COUNT=$(grep "ERROR COUNT:" "$MONITOR_FILE" | awk '{print $3}')

if [ -z "$ERROR_COUNT" ]
then
    ERROR_COUNT=0
fi

{
    echo "========================================"
    echo "        AUTOMATED SYSTEM REPORT"
    echo "========================================"
    echo
    echo "Generated: $(date)"
    echo

    if [ "$ERROR_COUNT" -eq 0 ]
    then

        echo "STATUS: NORMAL"

        echo
        echo "SUMMARY:"
        echo "No significant errors were detected in the monitored application log."

        echo
        echo "DETECTED PROBLEMS:"
        echo "None."

        echo
        echo "RECOMMENDATIONS:"
        echo "1. Continue normal system monitoring."
        echo "2. Verify scheduled monitoring execution."
        echo "3. Review logs periodically."
        echo "4. Maintain current backup and service configuration."

        echo
        echo "ADMINISTRATOR INTERVENTION:"
        echo "NOT REQUIRED"

    elif [ "$ERROR_COUNT" -le 2 ]
    then

        echo "STATUS: WARNING"

        echo
        echo "SUMMARY:"
        echo "One or more application errors were detected."

        echo
        echo "DETECTED PROBLEMS:"

        grep -Ei \
        "ERROR:|FAILED:|FAILURE:|FATAL:|CRITICAL:" \
        "$MONITOR_FILE" || true

        echo
        echo "RECOMMENDATIONS:"
        echo "1. Inspect the failed application operation."
        echo "2. Verify database and backup services."
        echo "3. Check network connectivity and permissions."
        echo "4. Continue monitoring after corrective action."

        echo
        echo "ADMINISTRATOR INTERVENTION:"
        echo "MONITOR"

    else

        echo "STATUS: CRITICAL"

        echo
        echo "SUMMARY:"
        echo "Multiple application failures were detected."

        echo
        echo "DETECTED PROBLEMS:"

        grep -Ei \
        "ERROR:|FAILED:|FAILURE:|FATAL:|CRITICAL:" \
        "$MONITOR_FILE" || true

        echo
        echo "RECOMMENDATIONS:"
        echo "1. Investigate all detected application failures immediately."
        echo "2. Verify database connectivity."
        echo "3. Check failed backup operations."
        echo "4. Inspect service logs and permissions."
        echo "5. Restart affected services if appropriate."
        echo "6. Continue monitoring after corrective actions."

        echo
        echo "ADMINISTRATOR INTERVENTION:"
        echo "REQUIRED"

    fi

    echo
    echo "========================================"
    echo "Report generation completed."

} > "$FINAL_FILE"

cat "$FINAL_FILE"
