import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import qs.Commons
import qs.Widgets

Item {
  id: root

  property var pluginApi: null

  readonly property var geometryPlaceholder: panelContainer
  readonly property bool allowAttach: true

  property real contentPreferredWidth: 340 * Style.uiScaleRatio
  property real contentPreferredHeight: 420 * Style.uiScaleRatio

  property var cfg: pluginApi?.pluginSettings || ({})

  property var outputProfiles: cfg.outputProfiles || []
  property var inputProfiles: cfg.inputProfiles || []
  property var activeOutput: cfg.activeOutput || ""
  property var activeInput: cfg.activeInput || ""

  function openEasyEffects() {
    runEasyEffects.running = true
    if (!pluginApi) {
      Logger.e("EasyEffects", "Cannot close Panel: pluginApi is null")
      return
    }
    pluginApi.closePanel(root.screen)
  }

  function reload() {
    if (pluginApi?.mainInstance) {
      pluginApi.mainInstance.reloadProfiles()
    }
  }

  anchors.fill: parent

  Process {
    id: runEasyEffects
    command: ["sh", "-c", "easyeffects"]
    running: false
  }

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
          onClicked: reload()
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
        onClicked: openEasyEffects()
      }
    }
  }
}