#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DEFAULT="$SCRIPT_DIR/Default"

if [[ ! -d "$SRC_DEFAULT" ]]; then
  echo "Error: No se encontro la carpeta Default en $SRC_DEFAULT" >&2
  exit 1
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  ST_ROOT="$HOME/Library/Application Support/Sublime Text"
else
  ST_ROOT="$HOME/.config/sublime-text"
fi

DEST_DEFAULT="$ST_ROOT/Packages/Default"
mkdir -p "$DEST_DEFAULT"
cp -f "$SRC_DEFAULT/"* "$DEST_DEFAULT/"

echo "[OK] Traduccion al espanol instalada en: $DEST_DEFAULT"
echo "Reinicia Sublime Text para ver todos los menus y comandos en espanol."
