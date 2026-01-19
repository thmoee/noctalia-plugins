import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Widgets

Rectangle {
  id: root

  // Plugin API (injected by PluginService)
  property var pluginApi: null

  // Required properties for bar widgets
  property ShellScreen screen
  property string widgetId: ""
  property string section: ""

  readonly property string outputProfile: pluginApi?.pluginSettings?.activeOutput || ""
  readonly property string inputProfile: pluginApi?.pluginSettings?.activeInput || ""
    
  readonly property string barPosition: Settings.data.bar.position || "top"
  readonly property bool barIsVertical: barPosition === "left" || barPosition === "right"
  // add settings later
  property bool onlyIcon: false
  property bool textVisible: barIsVertical || !onlyIcon
    
  implicitWidth: barIsVertical ? Style.capsuleHeight : contentRow.implicitWidth + Style.marginM * 2
  implicitHeight: Style.capsuleHeight

  color: Style.capsuleColor
  radius: Style.radiusL

  RowLayout {
    id: contentRow
    anchors.centerIn: parent
    spacing: Style.marginS
    
    NIcon {
      icon: "wave-saw-tool"
      color: mouseArea.containsMouse ? Color.mOnHover : Color.mOnSurface
    }

    NText {
      visible: !barIsVertical && !onlyIcon
      text: root.outputProfile + " / " +  root.inputProfile
      color: mouseArea.containsMouse ? Color.mOnHover : Color.mOnSurface
      pointSize: Style.barFontSize
    }
  }

    MouseArea {
      id: mouseArea
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor

      onEntered: {
        root.color = Color.mHover;
      }

      onExited: {
        root.color = Style.capsuleColor
      }

      onClicked: {
        if (pluginApi) {
          Logger.i("EasyEffects", "Opening Panel");
          pluginApi.openPanel(root.screen);
        }
      }
    }
}
