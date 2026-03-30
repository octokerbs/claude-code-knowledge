#!/usr/bin/env bash
# update.sh — Fetches latest content from shanraisshan/claude-code-best-practice
# and prints a summary. To update the knowledge graph data, run this script
# and then manually update the KNOWLEDGE_DATA in index.html.
#
# Usage: ./update.sh

set -euo pipefail

REPO="shanraisshan/claude-code-best-practice"
RAW_BASE="https://raw.githubusercontent.com/${REPO}/main"
OUT_DIR="$(dirname "$0")/.data"

mkdir -p "$OUT_DIR"

echo "Fetching latest content from ${REPO}..."

# Fetch README (main knowledge source)
curl -sL "${RAW_BASE}/README.md" -o "${OUT_DIR}/README.md"
echo "  ✓ README.md"

# Fetch best practice guides
for file in subagent commands skills mcp settings memory cli-flags hooks; do
  curl -sL "${RAW_BASE}/best-practice/${file}.md" -o "${OUT_DIR}/bp-${file}.md" 2>/dev/null || true
done
echo "  ✓ Best practice guides"

# Fetch reports
for file in agent-sdk-vs-cli browser-automation-mcp settings skills-monorepo agent-memory advanced-tool-use usage-rate-limits agents-commands-skills llm-degradation; do
  curl -sL "${RAW_BASE}/reports/${file}.md" -o "${OUT_DIR}/report-${file}.md" 2>/dev/null || true
done
echo "  ✓ Reports"

echo ""
echo "Content saved to ${OUT_DIR}/"
echo "Last fetched: $(date -Iseconds)"
echo ""
echo "To update the knowledge graph:"
echo "  1. Review the fetched content in ${OUT_DIR}/"
echo "  2. Update KNOWLEDGE_DATA in index.html with any new items"
echo "  3. Update LAST_UPDATED date"
echo ""
echo "Summary of README.md:"
head -80 "${OUT_DIR}/README.md" | grep -E "^#{1,3} " || true
