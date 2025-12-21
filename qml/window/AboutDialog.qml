import QtQuick
import QtQuick.Layouts
import FluentUI 1.0

FluWindow {
    id: aboutDialog
    title: "About CarbonQt"
    width: 580
    height: 560
    fixSize: true
    modality: Qt.ApplicationModal

    // Ensure dialog is closed by default
    Component.onCompleted: {
        visible = false
    }

    Item {
        anchors.fill: parent
        anchors.margins: 30
        anchors.bottomMargin: 40

        ColumnLayout {
            anchors.fill: parent
            spacing: 16

            // App Icon and Title
            RowLayout {
                spacing: 16
                Layout.fillWidth: true

                Rectangle {
                    width: 64
                    height: 64
                    radius: 12
                    border.width: 0
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#0078D4" }
                        GradientStop { position: 1.0; color: "#106EBE" }
                    }

                    FluText {
                        anchors.centerIn: parent
                        text: "CQ"
                        font.pixelSize: 28
                        font.bold: true
                        color: "white"
                    }
                }

                ColumnLayout {
                    spacing: 4

                    FluText {
                        text: "CarbonQt"
                        font: FluTextStyle.TitleLarge
                    }

                    FluText {
                        text: "Version 1.0.0"
                        opacity: 0.6
                        font.pixelSize: 13
                    }
                }
            }

            FluText {
                text: "A modern, lightweight system monitor built with Qt and Fluent UI. Real-time monitoring of CPU, memory, disk, and network performance with an elegant interface."
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                Layout.preferredHeight: 60
            }

            FluDivider {
                Layout.fillWidth: true
            }

            // Features Section
            ColumnLayout {
                spacing: 8
                Layout.fillWidth: true

                FluText {
                    text: "Key Features"
                    font: FluTextStyle.Subtitle
                }

                ColumnLayout {
                    spacing: 6
                    Layout.leftMargin: 8

                    Repeater {
                        model: [
                            "Real-time CPU and memory monitoring",
                            "Network bandwidth tracking",
                            "Disk usage visualization",
                            "Modern Fluent Design interface"
                        ]

                        RowLayout {
                            spacing: 8

                            Rectangle {
                                width: 6
                                height: 6
                                radius: 3
                                color: "#0078D4"
                            }

                            FluText {
                                text: modelData
                                font.pixelSize: 13
                                opacity: 0.8
                            }
                        }
                    }
                }
            }

            FluDivider {
                Layout.fillWidth: true
            }

            // Links Section
            ColumnLayout {
                spacing: 10
                Layout.fillWidth: true

                FluText {
                    text: "Resources"
                    font: FluTextStyle.Subtitle
                }

                RowLayout {
                    spacing: 12

                    FluTextButton {
                        text: "GitHub Repository"
                        icon: FluentIcons.Code
                        onClicked: Qt.openUrlExternally("https://github.com/yourname/CarbonQt")
                    }

                    FluTextButton {
                        text: "Documentation"
                        icon: FluentIcons.Documentation
                        onClicked: Qt.openUrlExternally("https://github.com/yourname/CarbonQt/wiki")
                    }

                    FluTextButton {
                        text: "Report Issue"
                        icon: FluentIcons.Bug
                        onClicked: Qt.openUrlExternally("https://github.com/yourname/CarbonQt/issues")
                    }
                }
            }

            FluDivider {
                Layout.fillWidth: true
            }

            // Copyright Info
            FluText {
                text: "© 2024 CarbonQt. Licensed under MIT License."
                font.pixelSize: 12
                opacity: 0.6
                Layout.fillWidth: true
            }

            Item {
                Layout.fillHeight: true
            }

            // Close Button
            FluFilledButton {
                text: "Close"
                Layout.alignment: Qt.AlignRight
                Layout.preferredWidth: 100
                onClicked: aboutDialog.close()
            }
        }
    }
}
