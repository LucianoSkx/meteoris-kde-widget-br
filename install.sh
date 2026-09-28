#!/bin/bash

set -e

PLASMOID_ID="SiyamX7.system.monitor.meteoris"

DEST=~/.local/share/plasma/plasmoids/$PLASMOID_ID

mkdir -p "$DEST"

find . -maxdepth 1 -mindepth 1 ! -name '.git' -exec cp -r {} "$DEST/" \;

echo ""
echo "✓ Meteoris instalado com sucesso."
echo "Adicione-o em Widgets do Plasma do KDE."
