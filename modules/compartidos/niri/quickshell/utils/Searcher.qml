import "scripts/fuzzysort.js" as Fuzzy
import QtQuick
import Quickshell

Item {
  id: root
  required property var model
  property string key: "name"

  readonly property var entries: {
    var arr = []
    for (var i = 0; i < root.model.length; i++) {
      var e = root.model[i]
      if (e && !e.noDisplay) arr.push(e)
    }
    return arr
  }

  function query(search) {
    search = search.trim()
    if (!search) return root.entries

    var results = Fuzzy.go(search, root.entries, {
      key: root.key,
      all: true
    })

    return results.map(function (r) { return r.obj })
  }
}
