import Quickshell
import QtQuick

Scope {
  Variants {
    model: Quickshell.screens
    Scope {
      required property var modelData

      Bar {
        screen: modelData
      }
    }
  }
}
