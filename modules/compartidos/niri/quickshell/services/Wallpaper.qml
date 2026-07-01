pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  Process {
    id: wpProc
    running: false
  }

  function next() {
    wpProc.command = [
      "sh",
      "-c",
      'DIR="${WALLPAPER_DIR:-$HOME/Media/Imágenes/Wallpapers}"; ' +
      'WALL=$(find "$DIR" -type f 2>/dev/null | shuf -n1); ' +
      '[ -n "$WALL" ] && exec "$HOME/.config/quickshell/scripts/set-wallpaper.sh" "$WALL"'
    ]
    wpProc.running = true
  }
}
