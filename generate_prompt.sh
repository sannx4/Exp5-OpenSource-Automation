#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PROMPT_FILE="$SCRIPT_DIR/monitoring_prompt.txt"
REPORT_FILE="$SCRIPT_DIR/monitor_report.txt"
OUTPUT_FILE="$SCRIPT_DIR/llm_input.txt"

if [ ! -f "$PROMPT_FILE" ]
then
    echo "ERROR: Prompt file not found."
    exit 1
fi

if [ ! -f "$REPORT_FILE" ]
then
    echo "ERROR: Monitoring report not found."
    exit 1
fi

{
    cat "$PROMPT_FILE"

    echo
    echo "----------------------------------------"

    cat "$REPORT_FILE"

} > "$OUTPUT_FILE"

echo "Prompt generated successfully."
echo "Output: llm_input.txt"
