import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
import CarbonQt 1.0

FluScrollablePage {
    id: page
    title: "Performance & Energy"

    Component.onCompleted: system.refresh()

    SystemController {
        id: system
    }

    ColumnLayout {
        width: parent.width
        spacing: 16
        anchors.margins: 20

        // ================= CPU =================
        Rectangle {
            Layout.fillWidth: true
            height: 120
            radius: 8
            color: FluTheme.cardBackgroundColor
            border.color: FluTheme.dividerColor
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 6

                FluText {
                    text: "CPU"
                    font.pixelSize: 18
                    font.bold: true
                }

                FluText {
                    text: "Usage: " + system.cpuUsage.toFixed(1) + " %"
                }

                FluText {
                    text: "Power: " + system.cpuWatts.toFixed(2) + " W"
                }
            }
        }

        // ================= MEMORY =================
        Rectangle {
            Layout.fillWidth: true
            height: 120
            radius: 8
            color: FluTheme.cardBackgroundColor
            border.color: FluTheme.dividerColor
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 6

                FluText {
                    text: "Memory"
                    font.pixelSize: 18
                    font.bold: true
                }

                FluText {
                    text: "Usage: " + system.memoryUsage.toFixed(1) + " %"
                }

                FluText {
                    text: "Power: " + system.ramWatts.toFixed(2) + " W"
                }
            }
        }

        // ================= ENERGY =================
        Rectangle {
            Layout.fillWidth: true
            height: 140
            radius: 8
            color: FluTheme.cardBackgroundColor
            border.color: FluTheme.dividerColor
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 6

                FluText {
                    text: "Energy & Emissions"
                    font.pixelSize: 18
                    font.bold: true
                }

                FluText {
                    text: "Energy (this interval): "
                          + system.energyJoules.toFixed(2) + " J"
                }

                FluText {
                    text: "CO₂ Emissions: "
                          + system.co2e.toExponential(2) + " kg"
                }
            }
        }

        // ================= REFRESH =================
        FluButton {
            text: "Refresh"
            Layout.alignment: Qt.AlignRight
            onClicked: system.refresh()
        }
    }
}
