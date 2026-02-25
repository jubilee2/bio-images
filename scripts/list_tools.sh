#!/usr/bin/env bash
set -euo pipefail

# Output JSON array for GitHub Actions matrix, e.g. ["bcftools","samtools"]
tools=$(find tools -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort)
printf '%s\n' "$tools" | jq -R -s -c 'split("\n")[:-1]'
