#!/bin/bash

# VS Code settings: terminal as editor area, no welcome tab
SETTINGS_DIR="$HOME/.vscode-server/data/Machine"
mkdir -p "$SETTINGS_DIR"
cat > "$SETTINGS_DIR/settings.json" <<'EOF'
{
  "terminal.integrated.defaultLocation": "editor",
  "workbench.startupEditor": "none"
}
EOF
