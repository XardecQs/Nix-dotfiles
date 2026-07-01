#!/bin/sh
# generate-rofi-theme.sh — Genera config.rasi M3 Expressive con pywal16
# Debe ejecutarse después de que wal haya generado colors.json.

COLORS="$HOME/.cache/wal/colors.json"
ROFI_DIR="$HOME/.config/rofi"
ROFI_CONFIG="$ROFI_DIR/config.rasi"

if [ ! -f "$COLORS" ]; then
  echo "colors.json no encontrado, omitiendo rofi"
  exit 0
fi

mkdir -p "$ROFI_DIR"

python3 -c "
import json

def rgba(hex_color, alpha='100'):
    r = int(hex_color[1:3], 16)
    g = int(hex_color[3:5], 16)
    b = int(hex_color[5:7], 16)
    return f'#{r:02x}{g:02x}{b:02x}{alpha}'

def blend(bg, fg_hex, factor):
    r1, g1, b1 = int(bg[1:3],16), int(bg[3:5],16), int(bg[5:7],16)
    r2, g2, b2 = int(fg_hex[1:3],16), int(fg_hex[3:5],16), int(fg_hex[5:7],16)
    r = int(r1 + (r2 - r1) * factor)
    g = int(g1 + (g2 - g1) * factor)
    b = int(b1 + (b2 - b1) * factor)
    return f'#{r:02x}{g:02x}{b:02x}'

c = json.load(open('$COLORS'))['colors']

# M3 color roles from pywal
surface        = c.get('color0', '#1e1e2e')
surface_v      = c.get('color8', '#45475a')
on_surface     = c.get('color7', '#cdd6f4')
on_surface_v   = c.get('color15', '#a6adc8')
primary        = c.get('color2', c.get('color4', '#cba6f7'))
on_primary     = c.get('color0', '#1e1e2e')
outline        = c.get('color8', '#585b70')
error_c        = c.get('color1', '#f38ba8')

# Elevation levels (darken surface for lower, lighten for higher)
surface_low   = blend(surface, '#000000', 0.12)
surface_high  = blend(surface, '#ffffff', 0.08)

# Search bar container
search_bg     = blend(surface, surface_v, 0.5)

print(f'''/* Rofi M3 Expressive — generado por pywal16 */
* {{
    font: \"JetBrainsMono Nerd Font 13\";
}}

#window {{
    transparency: \"real\";
    background-color: {rgba(surface, 'e8')};
    border: 1px;
    border-color: {rgba(outline, '35')};
    border-radius: 18px;
    padding: 0;
    width: 600px;
    location: center;
    anchor: center;
    children: [mainbox];
}}

#mainbox {{
    padding: 12px;
    spacing: 10px;
    background-color: transparent;
    children: [inputbar, listview, mode-switcher];
}}

#inputbar {{
    padding: 10px 16px;
    background-color: {rgba(search_bg, 'b0')};
    border-radius: 14px;
    children: [prompt, entry];
}}

#prompt {{
    text-color: {primary};
    font: \"JetBrainsMono Nerd Font 15\";
    padding: 0 6px 0 0;
    vertical-align: 0.5;
    background-color: transparent;
}}

#entry {{
    text-color: {on_surface};
    font: \"JetBrainsMono Nerd Font 14\";
    placeholder-color: {rgba(on_surface_v, '50')};
    placeholder: \"Buscar…\";
    background-color: transparent;
}}

#listview {{
    lines: 8;
    columns: 1;
    fixed-height: false;
    scrollbar: false;
    padding: 0 4px;
    spacing: 3px;
    background-color: transparent;
}}

#element {{
    padding: 10px 12px;
    border-radius: 12px;
    text-color: {on_surface};
    font: \"JetBrainsMono Nerd Font 13\";
    background-color: transparent;
    cursor: pointer;
}}

#element selected {{
    background-color: {rgba(primary, '28')};
    text-color: {on_surface};
}}

#element alternate {{
    background-color: {rgba(surface_v, '20')};
}}

#element-icon {{
    size: 28px;
    padding: 0 10px 0 2px;
    background-color: transparent;
}}

#element-text {{
    vertical-align: 0.5;
    background-color: transparent;
}}

#mode-switcher {{
    border: 1px solid {rgba(outline, '20')};
    border-radius: 12px;
    padding: 6px 12px;
    font: \"JetBrainsMono Nerd Font 11\";
    background-color: {rgba(surface_v, '30')};
    text-color: {on_surface_v};
}}

#button selected {{
    background-color: {rgba(primary, '25')};
    border-radius: 8px;
    text-color: {primary};
}}

#message {{
    background-color: transparent;
    border: none;
    padding: 8px;
}}

#textbox {{
    text-color: {on_surface};
    background-color: transparent;
}}

#textbox-prompt-colon {{
    text-color: {primary};
}}
"""

echo "rofi: tema M3 Expressive generado en $ROFI_CONFIG"
