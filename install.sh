#!/bin/bash

set -e

PLASMOID_ID="SiyamX7.system.monitor.meteoris"

mkdir -p ~/.local/share/plasma/plasmoids

cp -r . ~/.local/share/plasma/plasmoids/$PLASMOID_ID

echo ""
echo "✓ Meteoris installed successfully."
echo "Add it from KDE Plasma Widgets."
