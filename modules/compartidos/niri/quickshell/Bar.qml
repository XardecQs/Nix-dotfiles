import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import "services"

PanelWindow {
  id: bar
  implicitHeight: 36
  color: "transparent"

  anchors.top: true
  anchors.left: true
  anchors.right: true

  readonly property color accent: Colors.accent
  readonly property color textCol: Colors.onSurface
  readonly property color surfaceContainer: Colors.background
  readonly property color surfaceVariant: Colors.surfaceVariant
  readonly property color outline: Colors.outline
  property bool hotEdgeCooldown: false

  Rectangle {
    anchors.fill: parent
    color: bar.surfaceContainer

    Rectangle {
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      height: 1
      color: Qt.alpha(bar.outline, 0.25)
    }

    Row {
      id: leftGroup
      anchors.left: parent.left
      anchors.leftMargin: 12
      anchors.verticalCenter: parent.verticalCenter
      spacing: 8

      Item {
        id: powerBtn
        width: 30
        height: 30
        anchors.verticalCenter: parent.verticalCenter
        property bool menuOpen: false
        property string confirmAction: ""
        property bool pressed: false

        function doAction(action) {
          powerBtn.menuOpen = false
          powerBtn.confirmAction = ""
          switch (action) {
            case "poweroff": Session.poweroff(); break
            case "reboot": Session.reboot(); break
            case "suspend": Session.suspend(); break
            case "quitNiri": Session.quitNiri(); break
          }
        }

        function requestConfirm(action) {
          if (action === "poweroff" || action === "reboot") {
            powerBtn.confirmAction = action
          } else {
            doAction(action)
          }
        }

        Rectangle {
          id: powerBg
          anchors.centerIn: parent
          width: parent.width
          height: parent.height
          radius: 15
          color: powerBtn.menuOpen ? Qt.alpha(bar.accent, 0.15)
            : (ph.hovered ? Qt.alpha(bar.textCol, 0.08) : "transparent")
          Behavior on color { ColorAnimation { duration: 150 } }
          scale: powerBtn.pressed ? 0.88 : (ph.hovered ? 1.06 : 1)
          Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }
        }
        Text {
          anchors.centerIn: parent
          text: "\u23FB"
          color: powerBtn.menuOpen ? bar.accent : bar.textCol
          font.pixelSize: 15
          Behavior on color { ColorAnimation { duration: 150 } }
        }
        HoverHandler { id: ph }
        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onPressed: powerBtn.pressed = true
          onReleased: powerBtn.pressed = false
          onClicked: powerBtn.menuOpen = !powerBtn.menuOpen
        }
        Timer {
          interval: 5000
          running: powerBtn.menuOpen
          onTriggered: powerBtn.menuOpen = false
        }
      }

      Rectangle {
        width: 1
        height: 16
        radius: 1
        anchors.verticalCenter: parent.verticalCenter
        color: Qt.alpha(bar.outline, 0.35)
      }

      Item {
        id: launchBtn
        width: 30
        height: 30
        anchors.verticalCenter: parent.verticalCenter
        property bool pressed: false

        Rectangle {
          anchors.centerIn: parent
          width: parent.width
          height: parent.height
          radius: 15
          color: lh.hovered ? Qt.alpha(bar.textCol, 0.08) : "transparent"
          Behavior on color { ColorAnimation { duration: 150 } }
          scale: launchBtn.pressed ? 0.88 : 1
          Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }
        }
        Text {
          anchors.centerIn: parent
          text: "\uDB80\uDCC6"
          color: bar.textCol
          font.pixelSize: 18
        }
        HoverHandler { id: lh }
        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onPressed: launchBtn.pressed = true
          onReleased: launchBtn.pressed = false
          onClicked: Session.launchRofi()
        }
      }

      Rectangle {
        width: 1
        height: 16
        radius: 1
        anchors.verticalCenter: parent.verticalCenter
        color: Qt.alpha(bar.outline, 0.35)
      }

      Item {
        id: wallpaperBtn
        width: 30
        height: 30
        anchors.verticalCenter: parent.verticalCenter
        property bool pressed: false

        Rectangle {
          anchors.centerIn: parent
          width: parent.width
          height: parent.height
          radius: 15
          color: wh.hovered ? Qt.alpha(bar.accent, 0.10) : "transparent"
          Behavior on color { ColorAnimation { duration: 150 } }
          scale: wallpaperBtn.pressed ? 0.88 : (wh.hovered ? 1.06 : 1)
          Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }
        }
        Text {
          anchors.centerIn: parent
          text: "\uDB80\uDF49"
          color: bar.textCol
          font.pixelSize: 16
        }
        HoverHandler { id: wh }
        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onPressed: wallpaperBtn.pressed = true
          onReleased: wallpaperBtn.pressed = false
          onClicked: Wallpaper.next()
        }
      }

      Rectangle {
        width: 1
        height: 16
        radius: 1
        anchors.verticalCenter: parent.verticalCenter
        color: Qt.alpha(bar.outline, 0.35)
      }

      ActiveWindow { anchors.verticalCenter: parent.verticalCenter }
    }

    Workspaces { id: workspacesWidget; anchors.centerIn: parent }

    Row {
      id: rightGroup
      anchors.right: parent.right
      anchors.rightMargin: 12
      anchors.verticalCenter: parent.verticalCenter
      spacing: 8

      Text {
        anchors.verticalCenter: parent.verticalCenter
        color: bar.textCol
        font.pixelSize: 11
        font.family: "JetBrainsMono Nerd Font"
        font.weight: Font.DemiBold
        SystemClock { id: sysClock; precision: SystemClock.Seconds }
        text: Qt.formatDateTime(sysClock.date, "ddd dd/MM HH:mm")
      }

      Rectangle {
        width: 1
        height: 16
        radius: 1
        anchors.verticalCenter: parent.verticalCenter
        color: Qt.alpha(bar.outline, 0.35)
      }

      Row {
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6
        Repeater {
          model: SystemTray.items
          Item {
            width: 18
            height: 18
            anchors.verticalCenter: parent.verticalCenter
            Rectangle {
              anchors.fill: parent
              anchors.margins: -4
              radius: 10
              color: sth.hovered ? Qt.alpha(bar.textCol, 0.08) : "transparent"
              Behavior on color { ColorAnimation { duration: 150 } }
            }
            IconImage {
              source: modelData.icon ? ("image://icon/" + modelData.icon) : ""
              anchors.fill: parent
            }
            HoverHandler { id: sth }
            MouseArea {
              anchors.fill: parent
              onClicked: modelData.activate()
            }
          }
        }
      }
    }
  }

  PanelWindow {
    id: popupWindow
    visible: powerBtn.menuOpen
    screen: bar.screen
    color: "transparent"
    anchors.top: true
    anchors.left: true
    margins.top: bar.implicitHeight + 6
    margins.left: 14
    implicitWidth: powerBtn.confirmAction !== "" ? 182 : 164
    implicitHeight: menuCol.height + 12
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusionMode: ExclusionMode.Ignore

    Rectangle {
      anchors.fill: parent
      radius: 14
      color: bar.surfaceContainer
      opacity: powerBtn.menuOpen ? 1 : 0
      scale: powerBtn.menuOpen ? 1 : 0.92
      transformOrigin: Item.TopLeft
      visible: opacity > 0
      Behavior on opacity { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
      Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }

      Rectangle {
        anchors.fill: parent
        radius: 14
        color: "transparent"
        border.width: 1
        border.color: Qt.alpha(bar.outline, 0.30)
      }

      MouseArea {
        anchors.fill: parent
      }

      Column {
        id: menuCol
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 6
        spacing: 1

        Repeater {
          model: powerBtn.confirmAction !== ""
            ? [
                { t: "Estas seguro?", i: "\u26A0", isHeader: true },
                { t: "Si, confirmar", i: "\u2714", act: powerBtn.confirmAction, confirm: true },
                { t: "No, cancelar",  i: "\u2718", act: "" }
              ]
            : [
                { t: "Apagar",        i: "\u23FB", act: "poweroff", confirm: true },
                { t: "Reiniciar",     i: "\u21BB", act: "reboot",   confirm: true },
                { t: "Suspender",     i: "\u23F0", act: "suspend" },
                { t: "Cerrar sesion", i: "\u21A6", act: "quitNiri" }
              ]

          Rectangle {
            width: parent.width
            height: 30
            radius: 10
            color: modelData.isHeader ? "transparent"
              : (mi.containsMouse ? Qt.alpha(bar.accent, 0.12) : "transparent")
            scale: modelData.isHeader ? 1 : (mi.pressed ? 0.95 : 1)
            Behavior on color { ColorAnimation { duration: 100 } }
            Behavior on scale { NumberAnimation { duration: 100; easing.type: Easing.OutBack } }
            Row {
              anchors.left: parent.left
              anchors.leftMargin: 10
              anchors.verticalCenter: parent.verticalCenter
              spacing: 8
              Text {
                text: modelData.i
                color: bar.textCol
                font.pixelSize: 14
                anchors.verticalCenter: parent.verticalCenter
              }
              Text {
                text: modelData.t
                color: modelData.isHeader ? bar.accent : bar.textCol
                font.pixelSize: 11
                font.bold: modelData.isHeader || false
                anchors.verticalCenter: parent.verticalCenter
              }
            }
            MouseArea {
              id: mi
              anchors.fill: parent
              hoverEnabled: modelData.isHeader ? false : true
              cursorShape: modelData.isHeader ? Qt.ArrowCursor : Qt.PointingHandCursor
              onClicked: {
                if (modelData.isHeader) return
                if (modelData.act === "") {
                  powerBtn.confirmAction = ""
                } else if (powerBtn.confirmAction !== "") {
                  powerBtn.doAction(modelData.act)
                } else if (modelData.confirm) {
                  powerBtn.requestConfirm(modelData.act)
                } else {
                  powerBtn.doAction(modelData.act)
                }
              }
            }
          }
        }
      }
    }
}


  Timer {
    id: cooldownTimer
    interval: 800
    onTriggered: bar.hotEdgeCooldown = false
  }

  PanelWindow {
    id: hotEdge
    screen: bar.screen
    anchors.bottom: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 4
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.exclusionMode: ExclusionMode.Ignore

    HoverHandler {
      onHoveredChanged: {
        if (hovered && !bar.hotEdgeCooldown) {
          bar.hotEdgeCooldown = true
          cooldownTimer.restart()
          Session.launchRofi()
        }
      }
    }
  }
}
