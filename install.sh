#!/bin/bash

set -e

PLASMOID_ID="SiyamX7.system.monitor.meteoris"
SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="$HOME/.local/share/plasma/plasmoids/$PLASMOID_ID"

echo "Installing Meteoris..."

mkdir -p "$HOME/.local/share/plasma/plasmoids"

rm -rf "$TARGET_DIR"
cp -r "$SOURCE_DIR" "$TARGET_DIR"

echo "Installation complete."

if command -v kquitapp6 >/dev/null 2>&1; then
kquitapp6 plasmashell || true
fi

plasmashell --replace >/dev/null 2>&1 &

echo ""
echo "Meteoris has been installed."
echo "Add it from: Desktop → Add Widgets → Meteoris"
