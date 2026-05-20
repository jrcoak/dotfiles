#!/bin/bash

# Merge VS Code settings into existing Machine settings.json
merge_settings() {
  local settings_file="$1"
  mkdir -p "$(dirname "$settings_file")"

  local new_settings='{
    "terminal.integrated.defaultLocation": "editor",
    "workbench.startupEditor": "none"
  }'

  if [ -f "$settings_file" ]; then
    if command -v jq &>/dev/null; then
      jq -s '.[0] * .[1]' "$settings_file" <(echo "$new_settings") > "${settings_file}.tmp" \
        && mv "${settings_file}.tmp" "$settings_file"
    elif command -v python3 &>/dev/null; then
      python3 -c "
import json
with open('$settings_file') as f: existing = json.load(f)
existing.update($new_settings)
with open('$settings_file', 'w') as f: json.dump(existing, f, indent=4)
"
    fi
  else
    echo "$new_settings" > "$settings_file"
  fi
}

# VS Code Desktop / SSH remote
merge_settings "$HOME/.vscode-server/data/Machine/settings.json"

# VS Code Browser
merge_settings "$HOME/.vscode-browser-server/data/Machine/settings.json"
