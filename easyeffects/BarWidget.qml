import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Widgets

Rectangle {
  id: root

  property var pluginApi: null

  property ShellScreen screen
  property string widgetId: ""
  property string section: ""

  property var cfg: pluginApi?.pluginSettings || ({})
  property var defaults: pluginApi?.manifest?.metadata?.defaultSettings || ({})

  readonly property string outputProfile: cfg.activeOutput || ""
  readonly property string inputProfile: cfg.activeInput || ""
    
  readonly property string barPosition: Settings.data.bar.position || "top"
  readonly property bool barIsVertical: barPosition === "left" || barPosition === "right"

  property bool onlyIcon: cfg.onlyIcon ?? defaults.onlyIcon
  property bool textVisible: !barIsVertical && !onlyIcon

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
