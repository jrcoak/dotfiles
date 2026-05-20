#!/bin/bash

SETTINGS='{
  "workbench.panel.opensMaximized": "always",
  "workbench.startupEditor": "none",
  "workbench.sideBar.visible": false,
  "files.autoSave": "onFocusChange"
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
