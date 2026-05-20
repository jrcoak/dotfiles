#!/bin/bash

SETTINGS='{
  "terminal.integrated.defaultLocation": "editor",
  "workbench.startupEditor": "none"
}'

# VS Code Desktop / SSH remote
DESKTOP_DIR="$HOME/.vscode-server/data/Machine"
mkdir -p "$DESKTOP_DIR"
echo "$SETTINGS" > "$DESKTOP_DIR/settings.json"

# VS Code Browser
BROWSER_DIR="$HOME/.vscode-browser-server/data/Machine"
mkdir -p "$BROWSER_DIR"
echo "$SETTINGS" > "$BROWSER_DIR/settings.json"
