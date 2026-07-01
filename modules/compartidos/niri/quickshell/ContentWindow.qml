import QtQuick
import Quickshell
import Quickshell.Wayland
import "services"

PanelWindow {
  id: root
  required property int borderWidth
  required property bool launcherOpen
  signal dismissLauncher()

  color: "transparent"

  anchors.top: true
  anchors.bottom: true
  anchors.left: true
  anchors.right: true

  WlrLayershell.exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Top
  WlrLayershell.keyboardFocus: root.launcherOpen
    ? WlrKeyboardFocus.OnDemand
    : WlrKeyboardFocus.None

  readonly property int border: root.borderWidth
  readonly property color surface: Colors.background
  readonly property color accent: Colors.accent
  readonly property color borderCol: Qt.alpha(Colors.background, 0.85)

  Region {
    id: borderMask
    Region { x: 0; y: 0; width: root.width; height: root.border }
    Region { x: 0; y: 0; width: root.border; height: root.height }
    Region { x: root.width - root.border; y: 0; width: root.border; height: root.height }
    Region { x: 0; y: root.height - root.border; width: root.width; height: root.border }
  }

  Region {
    id: fullMask
    x: root.border
    y: root.border
    width: root.width - root.border * 2
    height: root.height - root.border * 2
  }

  mask: root.launcherOpen ? fullMask : borderMask

  readonly property real cornerRadius: 16

  Rectangle {
    x: 0; y: 0
    width: root.width; height: root.border
    color: root.borderCol
    bottomLeftRadius: root.cornerRadius
    bottomRightRadius: root.cornerRadius
  }

  Rectangle {
    x: 0; y: root.height - root.border
    width: root.width; height: root.border
    color: root.borderCol
    topLeftRadius: root.cornerRadius
    topRightRadius: root.cornerRadius
  }

  Rectangle {
    x: 0; y: 0
    width: root.border; height: root.height
    color: root.borderCol
    topRightRadius: root.cornerRadius
    bottomRightRadius: root.cornerRadius
  }

  Rectangle {
    x: root.width - root.border; y: 0
    width: root.border; height: root.height
    color: root.borderCol
    topLeftRadius: root.cornerRadius
    bottomLeftRadius: root.cornerRadius
  }

  Rectangle {
    id: scrim
    anchors.fill: parent
    color: Qt.rgba(0, 0, 0, 0.60)
    opacity: root.launcherOpen ? 1 : 0
    visible: opacity > 0

    Behavior on opacity { NumberAnimation { duration: 200 } }

    MouseArea {
      anchors.fill: parent
      onClicked: root.dismissLauncher()
    }
  }

  Launcher {
    id: launcherPanel
    open: root.launcherOpen

    anchors.horizontalCenter: parent.horizontalCenter
    y: root.launcherOpen
      ? root.height - launcherPanel.panelH - 60
      : root.height + 10

    Behavior on y {
      NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
    }

    onDismissed: root.dismissLauncher()
    onAppLaunched: root.dismissLauncher()
  }
}
