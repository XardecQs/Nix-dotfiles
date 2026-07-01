import QtQuick
import Quickshell

Scope {
  required property var screen
  property int thickness: 4
  property int barHeight: 36

  PanelWindow {
    screen: root.screen
    anchors.top: true
    anchors.left: true
    anchors.right: true
    exclusiveZone: root.barHeight
    color: "transparent"
  }

  PanelWindow {
    screen: root.screen
    anchors.left: true
    anchors.top: true
    anchors.bottom: true
    exclusiveZone: root.thickness
    color: "transparent"
  }

  PanelWindow {
    screen: root.screen
    anchors.right: true
    anchors.top: true
    anchors.bottom: true
    exclusiveZone: root.thickness
    color: "transparent"
  }

  PanelWindow {
    screen: root.screen
    anchors.bottom: true
    anchors.left: true
    anchors.right: true
    exclusiveZone: root.thickness
    color: "transparent"
  }
}
