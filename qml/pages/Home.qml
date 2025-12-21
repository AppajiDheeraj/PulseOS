import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
import CarbonQt 1.0

FluScrollablePage {
    title: qsTr("Home")
    // System Controller instance
    property var systemController: SystemController {}

    // Auto-refresh timer
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: systemController.refresh()
    }

    Component.onCompleted: {
        systemController.refresh()
    }

    ColumnLayout {
        Layout.fillWidth: true
        Layout.preferredWidth: parent.width
        spacing: 16

        // Hero Section
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 100
            radius: 12
            color: FluTheme.dark ? Qt.rgba(1, 1, 1, 0.03) : Qt.rgba(0, 0, 0, 0.02)
            border.width: 1
            border.color: FluTheme.dark ? Qt.rgba(1, 1, 1, 0.06) : Qt.rgba(0, 0, 0, 0.06)

            RowLayout {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 16

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    FluText {
                        text: qsTr("System Monitor")
                        font: FluTextStyle.Title
                        Layout.fillWidth: true
                    }

                    FluText {
                        text: qsTr("Real-time performance monitoring")
                        font: FluTextStyle.Caption
                        opacity: 0.6
                        Layout.fillWidth: true
                    }
                }

                Rectangle {
                    Layout.preferredWidth: 1
                    Layout.fillHeight: true
                    Layout.topMargin: 8
                    Layout.bottomMargin: 8
                    color: FluTheme.dark ? Qt.rgba(1, 1, 1, 0.1) : Qt.rgba(0, 0, 0, 0.1)
                }

                RowLayout {
                    spacing: 8

                    FluIcon {
                        iconSource: FluentIcons.Refresh
                        iconSize: 14
                        opacity: 0.5
                    }

                    FluText {
                        text: qsTr("Updates every 2s")
                        font: FluTextStyle.Caption
                        opacity: 0.5
                    }
                }
            }
        }

        // System Info Card
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: sysInfoLayout.implicitHeight + 48
            radius: 12
            color: FluTheme.dark ? Qt.rgba(1, 1, 1, 0.03) : Qt.rgba(0, 0, 0, 0.02)
            border.width: 1
            border.color: FluTheme.dark ? Qt.rgba(1, 1, 1, 0.06) : Qt.rgba(0, 0, 0, 0.06)

            ColumnLayout {
                id: sysInfoLayout
                anchors.fill: parent
                anchors.margins: 24
                spacing: 20

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    FluIcon {
                        iconSource: FluentIcons.Info
                        iconSize: 22
                    }

                    FluText {
                        text: qsTr("System Information")
                        font: FluTextStyle.Subtitle
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: FluTheme.dark ? Qt.rgba(1, 1, 1, 0.08) : Qt.rgba(0, 0, 0, 0.08)
                }

                GridLayout {
                    Layout.fillWidth: true
                    columns: 2
                    rowSpacing: 20
                    columnSpacing: 40

                    // Hostname
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        RowLayout {
                            spacing: 8

                            FluIcon {
                                iconSource: FluentIcons.PC1
                                iconSize: 16
                                opacity: 0.6
                            }

                            FluText {
                                text: qsTr("Hostname")
                                font: FluTextStyle.Caption
                                opacity: 0.6
                            }
                        }

                        FluText {
                            text: systemController.hostname
                            font: FluTextStyle.BodyStrong
                            Layout.leftMargin: 24
                        }
                    }

                    // Operating System
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        RowLayout {
                            spacing: 8

                            FluIcon {
                                iconSource: FluentIcons.System
                                iconSize: 16
                                opacity: 0.6
                            }

                            FluText {
                                text: qsTr("Operating System")
                                font: FluTextStyle.Caption
                                opacity: 0.6
                            }
                        }

                        FluText {
                            text: systemController.os
                            font: FluTextStyle.BodyStrong
                            Layout.leftMargin: 24
                        }
                    }

                    // Kernel
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        RowLayout {
                            spacing: 8

                            FluIcon {
                                iconSource: FluentIcons.Developer
                                iconSize: 16
                                opacity: 0.6
                            }

                            FluText {
                                text: qsTr("Kernel")
                                font: FluTextStyle.Caption
                                opacity: 0.6
                            }
                        }

                        FluText {
                            text: systemController.kernel
                            font: FluTextStyle.BodyStrong
                            Layout.leftMargin: 24
                        }
                    }

                    // Uptime
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        RowLayout {
                            spacing: 8

                            FluIcon {
                                iconSource: FluentIcons.Clock
                                iconSize: 16
                                opacity: 0.6
                            }

                            FluText {
                                text: qsTr("Uptime")
                                font: FluTextStyle.Caption
                                opacity: 0.6
                            }
                        }

                        FluText {
                            text: systemController.uptime
                            font: FluTextStyle.BodyStrong
                            Layout.leftMargin: 24
                        }
                    }
                }
            }
        }

        // CPU Info Card
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: cpuInfoLayout.implicitHeight + 48
            radius: 12
            color: FluTheme.dark ? Qt.rgba(1, 1, 1, 0.03) : Qt.rgba(0, 0, 0, 0.02)
            border.width: 1
            border.color: FluTheme.dark ? Qt.rgba(1, 1, 1, 0.06) : Qt.rgba(0, 0, 0, 0.06)

            ColumnLayout {
                id: cpuInfoLayout
                anchors.fill: parent
                anchors.margins: 24
                spacing: 20

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    FluIcon {
                        iconSource: FluentIcons.ProcessingRun
                        iconSize: 22
                    }

                    FluText {
                        text: qsTr("Processor")
                        font: FluTextStyle.Subtitle
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: FluTheme.dark ? Qt.rgba(1, 1, 1, 0.08) : Qt.rgba(0, 0, 0, 0.08)
                }

                GridLayout {
                    Layout.fillWidth: true
                    columns: 2
                    rowSpacing: 20
                    columnSpacing: 40

                    // CPU Model
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        RowLayout {
                            spacing: 8

                            FluIcon {
                                iconSource: FluentIcons.Chip
                                iconSize: 16
                                opacity: 0.6
                            }

                            FluText {
                                text: qsTr("Model")
                                font: FluTextStyle.Caption
                                opacity: 0.6
                            }
                        }

                        FluText {
                            text: systemController.cpuModel
                            font: FluTextStyle.BodyStrong
                            Layout.leftMargin: 24
                        }
                    }

                    // CPU Cores
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        RowLayout {
                            spacing: 8

                            FluIcon {
                                iconSource: FluentIcons.Processing
                                iconSize: 16
                                opacity: 0.6
                            }

                            FluText {
                                text: qsTr("Cores")
                                font: FluTextStyle.Caption
                                opacity: 0.6
                            }
                        }

                        FluText {
                            text: systemController.cpuCores.toString()
                            font: FluTextStyle.BodyStrong
                            Layout.leftMargin: 24
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: FluTheme.dark ? Qt.rgba(1, 1, 1, 0.08) : Qt.rgba(0, 0, 0, 0.08)
                }

                // Overall CPU Usage
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12

                        FluIcon {
                            iconSource: FluentIcons.SpeedHigh
                            iconSize: 18
                        }

                        FluText {
                            text: qsTr("Overall CPU Usage")
                            font: FluTextStyle.BodyStrong
                        }

                        Item { Layout.fillWidth: true }

                        FluText {
                            text: systemController.cpuUsage.toFixed(1) + "%"
                            font: FluTextStyle.TitleLarge
                            color: {
                                if (systemController.cpuUsage > 80) return "#ff4444"
                                if (systemController.cpuUsage > 50) return "#ffaa00"
                                return FluTheme.primaryColor
                            }
                        }
                    }

                    FluSlider {
                        Layout.fillWidth: true
                        from: 0
                        to: 100
                        value: systemController.cpuUsage
                        enabled: false
                    }
                }

                // Per-Core Usage
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        FluIcon {
                            iconSource: FluentIcons.GridView
                            iconSize: 18
                        }

                        FluText {
                            text: qsTr("Per-Core Usage")
                            font: FluTextStyle.BodyStrong
                        }
                    }

                    GridLayout {
                        Layout.fillWidth: true
                        columns: 2
                        rowSpacing: 16
                        columnSpacing: 24

                        Repeater {
                            model: systemController.cpuCores

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 8

                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 8

                                    FluText {
                                        text: qsTr("Core %1").arg(index)
                                        font: FluTextStyle.Caption
                                        opacity: 0.7
                                    }

                                    Item { Layout.fillWidth: true }

                                    FluText {
                                        text: (systemController.perCoreUsage && systemController.perCoreUsage[index] !== undefined
                                               ? systemController.perCoreUsage[index].toFixed(1)
                                               : "0.0") + "%"
                                        font: FluTextStyle.Caption
                                        color: {
                                            var usage = systemController.perCoreUsage && systemController.perCoreUsage[index] !== undefined
                                                       ? systemController.perCoreUsage[index] : 0
                                            if (usage > 80) return "#ff4444"
                                            if (usage > 50) return "#ffaa00"
                                            return FluTheme.primaryColor
                                        }
                                    }
                                }

                                FluSlider {
                                    Layout.fillWidth: true
                                    from: 0
                                    to: 100
                                    value: systemController.perCoreUsage && systemController.perCoreUsage[index] !== undefined
                                           ? systemController.perCoreUsage[index] : 0
                                    enabled: false
                                }
                            }
                        }
                    }
                }
            }
        }

        // Memory Info Card
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: memInfoLayout.implicitHeight + 48
            radius: 12
            color: FluTheme.dark ? Qt.rgba(1, 1, 1, 0.03) : Qt.rgba(0, 0, 0, 0.02)
            border.width: 1
            border.color: FluTheme.dark ? Qt.rgba(1, 1, 1, 0.06) : Qt.rgba(0, 0, 0, 0.06)

            ColumnLayout {
                id: memInfoLayout
                anchors.fill: parent
                anchors.margins: 24
                spacing: 20

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    FluIcon {
                        iconSource: FluentIcons.Database
                        iconSize: 22
                    }

                    FluText {
                        text: qsTr("Memory")
                        font: FluTextStyle.Subtitle
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: FluTheme.dark ? Qt.rgba(1, 1, 1, 0.08) : Qt.rgba(0, 0, 0, 0.08)
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12

                        FluIcon {
                            iconSource: FluentIcons.FullView
                            iconSize: 18
                        }

                        FluText {
                            text: qsTr("Memory Usage")
                            font: FluTextStyle.BodyStrong
                        }

                        Item { Layout.fillWidth: true }

                        FluText {
                            text: systemController.memoryUsage.toFixed(1) + "%"
                            font: FluTextStyle.TitleLarge
                            color: {
                                if (systemController.memoryUsage > 80) return "#ff4444"
                                if (systemController.memoryUsage > 50) return "#ffaa00"
                                return FluTheme.primaryColor
                            }
                        }
                    }

                    FluSlider {
                        Layout.fillWidth: true
                        from: 0
                        to: 100
                        value: systemController.memoryUsage
                        enabled: false
                    }
                }
            }
        }
    }
}
