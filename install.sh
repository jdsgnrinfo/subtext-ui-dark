#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_SRC="$SCRIPT_DIR/dist/subtext-ui-dark.sublime-package"

if [[ ! -f "$PKG_SRC" ]]; then
  echo "Error: No se encontro $PKG_SRC" >&2
  exit 1
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  ST_ROOT="$HOME/Library/Application Support/Sublime Text"
else
  ST_ROOT="$HOME/.config/sublime-text"
fi

INSTALLED_PKGS="$ST_ROOT/Installed Packages"
USER_DIR="$ST_ROOT/Packages/User"

mkdir -p "$INSTALLED_PKGS" "$USER_DIR"
cp -f "$PKG_SRC" "$INSTALLED_PKGS/subtext-ui-dark.sublime-package"
echo "[OK] Paquete instalado en: $INSTALLED_PKGS/subtext-ui-dark.sublime-package"

PREFS="$USER_DIR/Preferences.sublime-settings"
if command -v python3 >/dev/null 2>&1; then
  python3 - "$PREFS" <<'PY'
import json, os, re, sys
path = sys.argv[1]
data = {}
if os.path.exists(path):
    raw = open(path, "r", encoding="utf-8").read()
    raw_clean = re.sub(r"(?m)^\s*//.*$", "", raw)
    try:
        data = json.loads(raw_clean) if raw_clean.strip() else {}
    except Exception:
        open(path + ".bak", "w", encoding="utf-8").write(raw)
data["theme"] = "Antigravity.sublime-theme"
data["color_scheme"] = "Antigravity.sublime-color-scheme"
data["themed_title_bar"] = True
data["overlay_scroll_bars"] = "enabled"
with open(path, "w", encoding="utf-8") as f:
    json.dump(data, f, indent="\t")
    f.write("\n")
PY
  echo "[OK] Tema activado en: $PREFS"
else
  echo "Activa el tema manualmente en Preferences -> Settings:"
  echo '  "theme": "Antigravity.sublime-theme",'
  echo '  "color_scheme": "Antigravity.sublime-color-scheme"'
fi

echo "Listo! Reinicia Sublime Text para aplicar todos los cambios."
