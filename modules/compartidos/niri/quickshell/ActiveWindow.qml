import QtQuick
import "services"

Item {
  id: aw
  implicitWidth: bg.visible ? bg.width : 0
  implicitHeight: 24

  readonly property int maxWidth: 250
  readonly property color textCol: Colors.onSurface
  readonly property color surfaceVariant: Colors.surfaceVariant

  Rectangle {
    id: bg
    height: 24
    radius: 12
    color: aw.surfaceVariant
    visible: Niri.activeTitle !== ""
    width: Math.min(titleText.implicitWidth + 16, aw.maxWidth)

    Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

    Text {
      id: titleText
      anchors.verticalCenter: parent.verticalCenter
      anchors.left: parent.left
      anchors.leftMargin: 8
      width: Math.min(implicitWidth, aw.maxWidth - 16)
      text: Niri.activeTitle || ""
      color: aw.textCol
      font.pixelSize: 10
      font.weight: Font.Medium
      elide: Text.ElideRight
      maximumLineCount: 1
    }
  }
}
