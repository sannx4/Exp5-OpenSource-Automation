#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$PROJECT_DIR"

echo "========================================"
echo "Starting automated monitoring cycle"
echo "========================================"

./monitor.sh

./generate_prompt.sh

./generate_final_report.sh

git add application.log
git add monitor_report.txt
git add llm_input.txt
git add final_report.txt

if git diff --cached --quiet
then

    echo "No monitoring changes to commit."
    exit 0

fi

git commit -m "monitor: automated log report $(date '+%F %T')"

echo "Monitoring results committed successfully."

if git remote get-url origin >/dev/null 2>&1
then

    echo "Pushing monitoring update to GitHub..."

    git push origin "$(git branch --show-current)"

fi
