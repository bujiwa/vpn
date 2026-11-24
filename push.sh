#!/usr/bin/env bash
set -euo pipefail

MSG="${1:-docs: update $(date '+%Y-%m-%d %H:%M:%S')}"
git add -A
if git diff --cached --quiet; then
  echo "没有需要提交的改动。"
  exit 0
fi
git commit -m "$MSG"
git push origin main
echo "推送完成：$MSG"
