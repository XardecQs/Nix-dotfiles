import QtQuick
import Quickshell
import Quickshell.Io
import "services"

Item {
  id: wsWidget
  implicitWidth: wsRow.width
  implicitHeight: 28

  readonly property color accent: Colors.accent
  readonly property color subtext: Colors.onSurfaceVariant

  Process { id: focusProc; running: false }

  function goToWorkspace(idx) {
    focusProc.command = ["niri", "msg", "action", "focus-workspace", String(idx)]
    focusProc.running = true
  }

  function workspaceExists(idx) {
    for (var i = 0; i < Niri.workspaces.length; i++) {
      if ((Niri.workspaces[i].idx || Niri.workspaces[i].id || (i + 1)) === idx) {
        return true
      }
    }
    return false
  }

  Row {
    id: wsRow
    spacing: 6

    Repeater {
      model: Math.max(Niri.workspaces.length + 2, 9)

      Item {
        id: wsItem
        width: wsDot.width + 2
        height: 28
        property bool hovered: false

        Rectangle {
          id: wsDot
          anchors.centerIn: parent

          property bool active: index + 1 === Niri.activeIdx
          property bool exists: active || wsWidget.workspaceExists(index + 1)

          width: active ? 30 : (exists ? 11 : 6)
          height: active ? 26 : (exists ? 11 : 6)
          radius: height / 2
          color: active ? wsWidget.accent
            : (exists ? (wsItem.hovered
              ? Qt.alpha(wsWidget.subtext, 0.65)
              : Qt.alpha(wsWidget.subtext, 0.40))
            : Qt.alpha(wsWidget.subtext, 0.12))
          border.width: active ? 0 : (exists ? 1 : 0)
          border.color: wsWidget.subtext

          scale: wsItem.hovered && !active ? 1.15 : 1

          Behavior on width { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
          Behavior on height { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
          Behavior on color { ColorAnimation { duration: 180 } }
          Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }

          Text {
            anchors.centerIn: parent
            text: String(index + 1)
            color: wsDot.active ? Colors.background : wsWidget.subtext
            font.pixelSize: wsDot.active ? 11 : 9
            font.bold: wsDot.active
            visible: wsDot.active || wsDot.exists

            Behavior on font.pixelSize { NumberAnimation { duration: 180 } }
          }
        }

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onEntered: wsItem.hovered = true
          onExited: wsItem.hovered = false
          onClicked: wsWidget.goToWorkspace(index + 1)
        }
      }
    }
  }
}
