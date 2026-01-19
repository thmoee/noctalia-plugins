import QtQuick
import Quickshell
import Quickshell.Io
import qs.Services.UI
import qs.Commons

Item {
  id: root

  property var pluginApi: null

  property string profileOutput: ""
  property var outputProfiles: []
  property var inputProfiles: []
  property bool profilesLoaded: false


  Process {
    id: loadProfiles
    command: ["sh", "-c", "easyeffects -p"]
    running: false
    stdout: StdioCollector {
      onStreamFinished:  {
        root.profileOutput = data + "\n"
      }
    }

    onExited: (code, status) => {
      var outputs = []
      var inputs = []

      var section = ""
      var lines = root.profileOutput.split("\n")
      var itemRe = /^\s*\d+\s+(.+)$/

      for (var i = 0; i < lines.length; i++) {
        var line = lines[i]

        if (line.toLowerCase().indexOf("output presets") !== -1) {
          section = "output"
        }

        if (line.toLowerCase().indexOf("input presets") !== -1) {
          section = "input"
        }

        var match = line.match(itemRe)
        if (match) {
          var name = match[1].trim()
          if (section === "output") outputs.push(name)
          else if (section === "input") inputs.push(name)
        }
      }

      root.outputProfiles = outputs
      root.inputProfiles = inputs
      root.profilesLoaded = true

      if (!pluginApi) {
        root.profilesLoaded = false
        Logger.e("EasyEffects", "can't save loaded profiles into pluginSettings: pluginApi is null")
        return
      }
      
      pluginApi.pluginSettings.outputProfiles = outputs
      pluginApi.pluginSettings.inputProfiles = inputs
      pluginApi.saveSettings()
    }
  }

  Process {
    id: checkActiveOutputProfile
    command: ["sh", "-c", "easyeffects -a output"]
    running: false
    stdout: StdioCollector {
      onStreamFinished: {
        if (pluginApi) {
          // Need to trim because somehow it saves \n characters
          pluginApi.pluginSettings.activeOutput = this.text.trim("\n")
          pluginApi.saveSettings()
        }
      }
    }
  }

  Process {
    id: checkActiveInputProfile
    command: ["sh", "-c", "easyeffects -a input"]
    running: false
    stdout: StdioCollector {
      onStreamFinished: {
        if (pluginApi) {
          pluginApi.pluginSettings.activeInput = this.text.trim("\n")
          pluginApi.saveSettings()
        }
      }
    }
  }

  IpcHandler {
    target: "plugin:easyeffects"

    function reloadProfiles() {
      if (!pluginApi) {
        Logger.e("EasyEffects", "Can't reload profiles: pluginApi is null")
        return
      }
      checkActiveInputProfile.running = true
    }
  }

  Component.onCompleted: {
    loadProfiles.running = true
    checkActiveOutputProfile.running = true
    checkActiveInputProfile.running = true
  }
}