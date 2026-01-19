import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

Item {
  id: root

  // Plugin API (injected by PluginPanelSlot)
  property var pluginApi: null

  // SmartPanel properties (required for panel behavior)
  readonly property var geometryPlaceholder: panelContainer
  readonly property bool allowAttach: true

  // Preferred dimensions
  property real contentPreferredWidth: 340 * Style.uiScaleRatio
  property real contentPreferredHeight: 420 * Style.uiScaleRatio

  property var outputProfiles: pluginApi?.pluginSettings?.outputProfiles || []
  property var inputProfiles: pluginApi?.pluginSettings?.inputProfiles || []
  property var activeOutput: pluginApi?.pluginSettings?.activeOutput || ""
  property var activeInput: pluginApi?.pluginSettings?.activeInput || ""

  anchors.fill: parent

  Rectangle {
    id: panelContainer
    anchors.fill: parent
    color: "transparent"

    ColumnLayout {
      anchors {
        fill: parent
        margins: Style.marginM
      }
      spacing: Style.marginXL

      RowLayout {
        spacing: Style.marginM

        NText {
          text: "Audio Profiles"
          font.weight: Style.fontWeightBold
          font.pointSize: Style.fontSizeXL
        }

        Item {
          Layout.fillWidth: true
        }

        NIconButton {
          icon: "reload"
        }
      }

      Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: "transparent"


        ColumnLayout {
          anchors.fill: parent
          spacing: Style.marginL

          NBox {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
              anchors.fill: parent
              anchors.margins: Style.marginM

              NText {
                text: "Output"
                color: Color.mPrimary
              }

              NScrollView {
                Layout.fillWidth: true
                Layout.preferredHeight: Math.round(90 * Style.uiScaleRatio)
                clip: true

                ColumnLayout {
                  width: parent.width
                  spacing: Style.marginS

                  Repeater {
                    model: root.outputProfiles

                    NRadioButton {
                      required property string modelData
                      text: modelData
                      checked: activeOutput === modelData ? true : false
                    }
                  }
                }
              }
            }
          }

          NBox {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
              anchors.fill: parent
              anchors.margins: Style.marginM

              NText {
                text: "Input"
                color: Color.mPrimary
              }

              NScrollView {
                Layout.fillWidth: true
                Layout.preferredHeight: Math.round(90 * Style.uiScaleRatio)
                clip: true

                ColumnLayout {
                  width: parent.width
                  spacing: Style.marginS

                  Repeater {
                    model: root.inputProfiles

                    NRadioButton {
                      required property string modelData
                      text: modelData
                      checked: activeInput === modelData ? true : false
                    }
                  }
                }
              }
            }
          }
        }
      }

      // horizontal line
      Rectangle {
        width: parent.width
        height: 1
        color: Color.mSurfaceVariant
        opacity: 1
      }

      NButton {
        Layout.fillWidth: true
        text: "Open EasyEffects"
        icon: "external-link"
      }
    }
  }
}