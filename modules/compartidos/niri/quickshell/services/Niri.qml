pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: svc

  property var workspaces: []
  property int activeIdx: 1
  property string activeTitle: ""
  property string activeAppId: ""
  property var windows: []

  readonly property bool polling: true

  Timer {
    id: pollTimer
    interval: 500
    running: true
    repeat: true
    onTriggered: {
      wsProc.running = true
      winProc.running = true
    }
  }

  Process {
    id: wsProc
    command: ["niri", "msg", "-j", "workspaces"]
    running: false
    stdout: StdioCollector {
      onStreamFinished: {
        try {
          var data = JSON.parse(text)
          if (Array.isArray(data)) {
            svc.workspaces = data
            for (var i = 0; i < data.length; i++) {
              if (data[i].is_active || data[i].is_focused) {
                svc.activeIdx = data[i].idx || data[i].id || (i + 1)
                break
              }
            }
          }
        } catch (e) {}
      }
    }
  }

  Process {
    id: winProc
    command: ["niri", "msg", "-j", "windows"]
    running: false
    stdout: StdioCollector {
      onStreamFinished: {
        try {
          var data = JSON.parse(text)
          if (Array.isArray(data)) {
            svc.windows = data
            for (var i = 0; i < data.length; i++) {
              if (data[i].is_active || data[i].is_focused) {
                svc.activeTitle = data[i].title || ""
                svc.activeAppId = data[i].app_id || ""
                break
              }
            }
          }
        } catch (e) {}
      }
    }
  }
}
