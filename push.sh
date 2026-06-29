#!/usr/bin/env bash
#
# Upload theme code without overwriting page/content data.
#
# Skips the JSON files that hold theme-editor content so your live page
# settings, blocks, and theme settings are never reverted:
#   - config/settings_data.json   (theme settings values)
#   - templates/**/*.json         (per-page/template content)
#   - sections/*.json             (header/footer section-group data)
#
# Usage:  ./push.sh
#
set -euo pipefail

THEME_ID=141439402087

shopify theme push --theme "$THEME_ID" \
  --ignore "config/settings_data.json" \
  --ignore "templates/*.json" \
  --ignore "templates/**/*.json" \
  --ignore "sections/*.json"
