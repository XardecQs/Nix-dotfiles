#!/bin/sh
# set-wallpaper.sh — Aplica un wallpaper con awww, regenera colores con pywal16
# y actualiza el focus-ring de niri.
#
# Uso: set-wallpaper.sh <ruta-imagen>
#
# Si no se pasa argumento, toma un wallpaper aleatorio de ~/Media/Imágenes/Wallpapers.

set -e

if [ -z "$1" ]; then
  WALL_DIR="${WALLPAPER_DIR:-$HOME/Media/Imágenes/Wallpapers}"
  WALLPAPER=$(find "$WALL_DIR" -type f 2>/dev/null | shuf -n1)
  if [ -z "$WALLPAPER" ]; then
    echo "No se encontraron wallpapers en $WALL_DIR"
    exit 1
  fi
else
  WALLPAPER="$1"
fi

if [ ! -f "$WALLPAPER" ]; then
  echo "Archivo no encontrado: $WALLPAPER"
  exit 1
fi

echo "Wallpaper: $WALLPAPER"

# Matar cualquier proceso pywal previo para evitar superposicion
pkill -f "wal -i" 2>/dev/null || true

# Detectar si el wallpaper es claro u oscuro para elegir tema de pywal
BRIGHTNESS=$(magick identify -format "%[mean]" "$WALLPAPER" 2>/dev/null || echo 0)
if [ "$BRIGHTNESS" -gt 32768 ]; then
  WAL_FLAGS="-l"
  echo "Tema: claro"
else
  WAL_FLAGS=""
  echo "Tema: oscuro"
fi

# Generar paleta de colores con pywal16 (en bg, mientras awww transiciona)
# timeout evita que imagenes monocromaticas bloqueen el script
timeout 15 wal -i "$WALLPAPER" $WAL_FLAGS -n -s -t &
WAL_PID=$!

# Aplicar wallpaper con awww (el daemon ya corre desde el startup de niri)
awww img --transition-type random --transition-fps 60 --transition-duration 1.33 "$WALLPAPER"

# Esperar a que pywal termine y actualizar config de niri
if wait $WAL_PID 2>/dev/null; then
  SCRIPT_DIR="$(dirname "$0")"
  "$SCRIPT_DIR/apply-wal-colors.sh"
else
  echo "pywal omitido (timeout o fallo) — conservando colores actuales"
fi
