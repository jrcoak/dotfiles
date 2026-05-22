#!/bin/bash

SETTINGS='{
  "workbench.panel.opensMaximized": "always",
  "workbench.startupEditor": "none",
  "workbench.sideBar.visible": false,
  "files.autoSave": "onFocusChange",
  "files.watcherExclude": {
    "**/node_modules/**": true,
    "**/.git/objects/**": true,
    "**/.git/subtree-cache/**": true,
    "**/dist/**": true,
    "**/build/**": true,
    "**/__pycache__/**": true
  },
  "editor.stickyScroll.enabled": true,
  "terminal.integrated.scrollback": 50000,
  "git.autofetch": true,
  "git.decorations.enabled": true,
  "scm.diffDecorations": "gutter"
}'

# Merge settings into a VS Code settings.json file
merge_settings() {
  local settings_file="$1"
  mkdir -p "$(dirname "$settings_file")"

  if [ -f "$settings_file" ]; then
    if command -v jq &>/dev/null; then
      jq -s '.[0] * .[1]' "$settings_file" <(echo "$SETTINGS") > "${settings_file}.tmp" \
        && mv "${settings_file}.tmp" "$settings_file"
    elif command -v python3 &>/dev/null; then
      python3 -c "
import json
with open('$settings_file') as f: existing = json.load(f)
existing.update($SETTINGS)
with open('$settings_file', 'w') as f: json.dump(existing, f, indent=4)
"
    fi
  else
    echo "$SETTINGS" > "$settings_file"
  fi
}

# User-level settings (what VS Code browser actually respects)
merge_settings "$HOME/.vscode-browser-server/data/User/settings.json"
merge_settings "$HOME/.vscode-server/data/User/settings.json"

# Environment configuration via CLI
# Use the environment-scoped token so the CLI can resolve the current environment,
# even when ONA_TOKEN is set to a user-scoped PAT.
if command -v ona &>/dev/null && [ -f /usr/local/gitpod/secrets/token ]; then
  ENV_TOKEN=$(cat /usr/local/gitpod/secrets/token)

  # Verify CLI can resolve the current environment
  ONA_TOKEN="$ENV_TOKEN" ona environment get -f id 2>/dev/null && echo "dotfiles: environment detected"

  # Set default inactivity timeout to 3 hours (requires CLI >= 20260522)
  ONA_TOKEN="$ENV_TOKEN" ona environment update --inactivity-timeout 3h &>/dev/null &
fi
