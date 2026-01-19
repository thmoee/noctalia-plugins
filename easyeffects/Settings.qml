import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

ColumnLayout {
  id: root

  property var pluginApi: null

  property var cfg: pluginApi?.pluginSettings || ({})
  property var defaults: pluginApi?.manifest?.metadata?.defaultSettings || ({})
  property bool onlyIcon: cfg.onlyIcon ?? defaults.onlyIcon

  spacing: Style.marginM

  ColumnLayout {
    spacing: Style.marginM
    Layout.fillWidth: true

    NToggle {
      label: "Hide active Profile"
      description: "Hide the active Profile in the Widget. Useful if you only want the Icon in the Widget"
      checked: root.onlyIcon
      onToggled: function (checked) {
        root.onlyIcon = checked
      }
    }
  }

  function saveSettings() {
    if (!pluginApi) {
      Logger.e("EasyEffects", "Cannot save settings: pluginApi is null")
      return
    }
    
    pluginApi.pluginSettings.onlyIcon = root.onlyIcon
    pluginApi.saveSettings()
    
    Logger.i("EasyEffects", "Settings saved successfully")
  }
}