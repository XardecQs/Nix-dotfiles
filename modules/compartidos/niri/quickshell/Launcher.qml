import QtQuick
import Quickshell
import Quickshell.Widgets
import "services"
import "utils"

Item {
  id: launcher
  required property bool open
  signal dismissed()
  signal appLaunched()

  property int panelW: 560
  property int panelH: 360

  // 1. SOLUCIÓN AL FONDO: Forzamos el tamaño real para que no se estire en toda la pantalla
  width: panelW
  height: panelH

  // 2. SOLUCIÓN A LA ANIMACIÓN: Esta propiedad avisa si el launcher está abierto o sigue cerrándose
  readonly property bool launcherVisible: open || yAnim.running

  property bool isReady: false
  Component.onCompleted: isReady = true

  anchors.horizontalCenter: parent.horizontalCenter
  y: launcher.open ? parent.height - panelH : parent.height

  Behavior on y {
    enabled: launcher.isReady
    NumberAnimation { 
      id: yAnim // Le ponemos ID para poder rastrear si está corriendo (.running)
      duration: 300; 
      easing.type: Easing.OutCubic 
    }
  }

  Rectangle {
    id: bg
    anchors.fill: parent // Ahora solo llenará los 560x360 píxeles del Item raíz
    radius: 20
    bottomLeftRadius: 0
    bottomRightRadius: 0
    color: Colors.background

    Rectangle {
      anchors.fill: parent
      radius: 20
      bottomLeftRadius: 0
      bottomRightRadius: 0
      color: "transparent"
      border.width: 1
      border.color: Qt.alpha(Colors.outline, 0.30)
    }

    Column {
      anchors.fill: parent
      anchors.margins: 10
      spacing: 8

      Rectangle {
        width: parent.width
        height: 36
        radius: 18
        color: Colors.surfaceVariant

        Rectangle {
          anchors.fill: parent
          radius: 18
          color: "transparent"
          border.width: searchInput.activeFocus ? 1.5 : 1
          border.color: searchInput.activeFocus ? Colors.accent : Qt.alpha(Colors.outline, 0.20)
          Behavior on border.color { ColorAnimation { duration: 200 } }
          Behavior on border.width { NumberAnimation { duration: 150 } }
        }

        TextInput {
          id: searchInput
          anchors.fill: parent
          anchors.leftMargin: 16
          anchors.rightMargin: 16
          color: Colors.onSurface
          font.pixelSize: 14
          verticalAlignment: Text.AlignVCenter

          Text {
            anchors.fill: parent
            text: "Buscar aplicación..."
            color: Colors.onSurfaceVariant
            font.pixelSize: 14
            verticalAlignment: Text.AlignVCenter
            visible: searchInput.text === "" && !searchInput.activeFocus
          }

          onTextChanged: resultsList.updateFilter()

          onAccepted: {
            if (resultsList.currentItem) {
              resultsList.currentItem.doActivate()
            }
          }

          Keys.onEscapePressed: function(event) { launcher.dismissed(); event.accepted = true; }
          Keys.onDownPressed: function(event) {
            if (resultsList.count > 0) {
              resultsList.incrementCurrentIndex()
              event.accepted = true
            }
          }
          Keys.onUpPressed: function(event) {
            if (resultsList.currentIndex > 0) {
              resultsList.decrementCurrentIndex()
              event.accepted = true
            }
          }
        }
      }

      ListView {
        id: resultsList
        width: parent.width
        height: parent.height - 44
        clip: true
        spacing: 1
        flickDeceleration: 3000
        highlightMoveDuration: 200

        property var filtered: DesktopEntries.applications
        model: filtered

        Searcher {
          id: appSearcher
          model: DesktopEntries.applications
          key: "name"
        }

        function updateFilter() {
          var query = searchInput.text.trim()
          if (query === "") {
            filtered = appSearcher.entries
            resultsList.currentIndex = -1
            return
          }
          filtered = appSearcher.query(query)
          resultsList.currentIndex = filtered.length > 0 ? 0 : -1
        }

        delegate: Item {
          id: delegateItem
          width: resultsList.width
          height: 44
          property bool pressed: false

          scale: delegateItem.pressed ? 0.96 : 1
          Behavior on scale { NumberAnimation { duration: 100; easing.type: Easing.OutBack } }

          Rectangle {
            id: stateLayer
            anchors.fill: parent
            anchors.margins: 2
            radius: 12
            color: index === resultsList.currentIndex ? Qt.alpha(Colors.accent, 0.15) : "transparent"
            Behavior on color { ColorAnimation { duration: 150 } }
          }

          Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 3
            width: 3
            height: parent.height * 0.35
            radius: 2
            color: Colors.accent
            opacity: index === resultsList.currentIndex ? 0.85 : 0
            visible: opacity > 0
            Behavior on opacity { NumberAnimation { duration: 150 } }
          }

          MouseArea {
            id: itemMa
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onPressed: delegateItem.pressed = true
            onReleased: delegateItem.pressed = false
            onClicked: {
              resultsList.currentIndex = index
              doActivate()
            }
          }

          function doActivate() {
            modelData.execute()
            searchInput.text = ""
            launcher.appLaunched()
          }

          Row {
            anchors.fill: parent
            anchors.leftMargin: 12
            spacing: 10

            Rectangle {
              width: 34
              height: 34
              radius: 8
              color: Qt.alpha(Colors.onSurfaceVariant, 0.08)
              anchors.verticalCenter: parent.verticalCenter

              IconImage {
                source: modelData.icon ? ("image://icon/" + modelData.icon) : ""
                width: 26
                height: 26
                anchors.centerIn: parent
              }
            }

            Column {
              anchors.verticalCenter: parent.verticalCenter
              spacing: 1

              Text {
                text: modelData.name || modelData.id
                color: Colors.onSurface
                font.pixelSize: 13
                font.weight: Font.Medium
              }

              Text {
                text: modelData.genericName || ""
                color: Colors.onSurfaceVariant
                font.pixelSize: 10
                visible: text !== ""
              }
            }
          }
        }
      }
    }
  }

  onOpenChanged: {
    if (open) {
      searchInput.text = ""
      searchInput.forceActiveFocus()
    }
  }
}