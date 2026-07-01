pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  Process {
    id: proc
    running: false
  }

  function poweroff() {
    proc.command = ["systemctl", "poweroff"]
    proc.running = true
  }

  function reboot() {
    proc.command = ["systemctl", "reboot"]
    proc.running = true
  }

  function suspend() {
    proc.command = ["systemctl", "suspend"]
    proc.running = true
  }

  function quitNiri() {
    proc.command = [
      "sh",
      "-c",
      "SOCK=$(ls $XDG_RUNTIME_DIR/niri.wayland-*.sock 2>/dev/null | tail -1); NIRI_SOCKET=$SOCK niri msg action quit"
    ]
    proc.running = true
  }

  Process {
    id: launchProc
    running: false
  }

  function launchRofi() {
    launchProc.command = ["rofi", "-show", "drun"]
    launchProc.running = true
  }
}
