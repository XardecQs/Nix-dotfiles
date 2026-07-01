#!/bin/sh
# Espera a que wal/pywal16 genere los colores y actualiza config.kdl
while [ ! -f "$HOME/.cache/wal/colors.json" ]; do sleep 2; done

python3 -c "
import json

def hex_to_rgb(hex_color):
    return (
        int(hex_color[1:3], 16),
        int(hex_color[3:5], 16),
        int(hex_color[5:7], 16)
    )

def darken(hex_color, factor=0.45):
    r, g, b = hex_to_rgb(hex_color)
    r = int(r * factor)
    g = int(g * factor)
    b = int(b * factor)
    return f'#{r:02x}{g:02x}{b:02x}'

def lighten(hex_color, factor=0.30):
    r, g, b = hex_to_rgb(hex_color)
    r = int(r + (255 - r) * factor)
    g = int(g + (255 - g) * factor)
    b = int(b + (255 - b) * factor)
    return f'#{r:02x}{g:02x}{b:02x}'

c = json.load(open('$HOME/.cache/wal/colors.json'))['colors']
color0 = c.get('color0', '#1e1e2e')
r, g, b = hex_to_rgb(color0)

if r + g + b > 384:
    # Tema claro: backdrop mas claro que el fondo
    backdrop = lighten(color0, 0.30)
else:
    # Tema oscuro: backdrop mas oscuro que el fondo
    backdrop = darken(color0, 0.45)

print('ACCENT=' + c.get('color2', c.get('color4', '#cba6f7')))
print('BACKDROP=' + backdrop)
" | while IFS='=' read -r key value; do
  case "$key" in
    ACCENT)   sed -i "s/active-color.*/active-color \"$value\"/" "$HOME/.config/niri/config.kdl" ;;
    BACKDROP) sed -i "s/backdrop-color.*/backdrop-color \"$value\"/" "$HOME/.config/niri/config.kdl" ;;
  esac
done

echo "niri: colors actualizados desde pywal16"

SCRIPT_DIR="$(dirname "$0")"
"$SCRIPT_DIR/generate-rofi-theme.sh"
