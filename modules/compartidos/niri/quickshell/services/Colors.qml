pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: svc

  readonly property var p: svc.palette.colors || null

  readonly property color accent: svc.p
    ? (svc.p.color2 || "#cba6f7")
    : "#cba6f7"
  readonly property color background: svc.p
    ? (svc.p.color0 || "#1e1e2e")
    : "#1e1e2e"
  readonly property color onSurface: svc.p
    ? (svc.p.color7 || "#cdd6f4")
    : "#cdd6f4"
  readonly property color onSurfaceVariant: svc.p
    ? (svc.p.color15 || "#a6adc8")
    : "#a6adc8"
  readonly property color surfaceVariant: svc.p
    ? (svc.p.color8 || "#45475a")
    : "#45475a"
  readonly property color outline: svc.p
    ? (svc.p.color8 || "#585b70")
    : "#585b70"

  property var palette: ({})

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: readProc.running = true
  }

  Process {
    id: readProc
    command: ["sh", "-c", "cat $HOME/.cache/wal/colors.json"]
    running: false
    stdout: StdioCollector {
      onStreamFinished: {
        try {
          var data = JSON.parse(text)
          svc.palette = data
        } catch (e) {}
      }
    }
  }
}
