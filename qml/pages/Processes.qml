import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import CarbonQt 1.0
import FluentUI 1.0

Item {
    anchors.fill: parent

    // Theme Colors based on FluTheme.dark
    readonly property color bgColor: FluTheme.dark ? "#202020" : "#F3F3F3"
    readonly property color cardColor: FluTheme.dark ? "#2D2D2D" : "#FFFFFF"
    readonly property color cardBorder: FluTheme.dark ? "#3F3F3F" : "#E5E5E5"
    readonly property color headerBg: FluTheme.dark ? "#252525" : "#F9F9F9"
    readonly property color primaryText: FluTheme.dark ? "#FFFFFF" : "#1F1F1F"
    readonly property color secondaryText: FluTheme.dark ? "#B4B4B4" : "#616161"
    readonly property color dataText: FluTheme.dark ? "#E0E0E0" : "#424242"
    readonly property color hoverBg: FluTheme.dark ? "#3A3A3A" : "#F5F5F5"
    readonly property color dividerColor: FluTheme.dark ? "#3F3F3F" : "#E5E5E5"
    readonly property color accentBlue: FluTheme.dark ? "#4CC2FF" : "#0078D7"
    readonly property color accentBlueHover: FluTheme.dark ? "#6CD4FF" : "#0067C0"
    readonly property color accentBlueDark: FluTheme.dark ? "#3DA8E6" : "#005A9E"
    readonly property color shadowColor: FluTheme.dark ? "#25000000" : "#15000000"
    readonly property color disabledBg: FluTheme.dark ? "#3F3F3F" : "#E5E5E5"
    readonly property color disabledText: FluTheme.dark ? "#6A6A6A" : "#A6A6A6"

    Component.onCompleted: ProcessModel.refresh()

    // Background
    Rectangle {
        anchors.fill: parent
        color: bgColor
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 16

        // Header Card
        Rectangle {
            Layout.fillWidth: true
            height: 80
            radius: 8
            color: cardColor
            border.color: cardBorder
            border.width: 1

            Rectangle {
                anchors.fill: parent
                anchors.margins: -2
                radius: 8
                color: "transparent"
                border.color: shadowColor
                border.width: 1
                z: -1
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 16

                ColumnLayout {
                    spacing: 4

                    Text {
                        text: "Process Manager"
                        font.pixelSize: 24
                        font.weight: Font.DemiBold
                        color: primaryText
                    }

                    Text {
                        text: "Monitor system processes and performance"
                        font.pixelSize: 13
                        color: secondaryText
                    }
                }

                Item { Layout.fillWidth: true }

                // Refresh Button
                Rectangle {
                    width: 120
                    height: 40
                    radius: 4
                    color: refreshMA.pressed ? accentBlueDark : (refreshMA.containsMouse ? accentBlue : accentBlueHover)


                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: -1
                        radius: 4
                        color: "transparent"
                        border.color: "#20000000"
                        border.width: 1
                        z: -1
                    }

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 8

                        Text {
                            text: "⟳"
                            font.pixelSize: 18
                            color: "#FFFFFF"
                        }

                        Text {
                            text: "Refresh"
                            font.pixelSize: 14
                            font.weight: Font.Medium
                            color: "#FFFFFF"
                        }
                    }

                    MouseArea {
                        id: refreshMA
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: ProcessModel.refresh()
                    }
                }
            }
        }

        // Main Content Card
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 8
            color: cardColor
            border.color: cardBorder
            border.width: 1

            Rectangle {
                anchors.fill: parent
                anchors.margins: -2
                radius: 8
                color: "transparent"
                border.color: shadowColor
                border.width: 1
                z: -1
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 0
                spacing: 0

                // Table Header
                Rectangle {
                    Layout.fillWidth: true
                    height: 48
                    radius: 8
                    color: headerBg

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        height: parent.height / 2
                        color: parent.color
                    }

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 20
                        anchors.rightMargin: 20
                        spacing: 0

                        HeaderColumn { width: 90; text: "PID" }
                        HeaderColumn { width: 220; text: "Process Name" }
                        HeaderColumn { width: 110; text: "CPU %" }
                        HeaderColumn { width: 130; text: "Memory (MB)" }
                        HeaderColumn { width: 100; text: "Threads" }
                        HeaderColumn { width: 110; text: "Vol CS" }
                        HeaderColumn { width: 120; text: "Non-Vol CS" }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: dividerColor
                }

                // Table Content
                ListView {
                    id: listView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds
                    model: ProcessModel

                    delegate: Rectangle {
                        width: listView.width
                        height: 52
                        color: delegateMA.containsMouse ? hoverBg : "transparent"

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            height: 1
                            color: dividerColor
                        }

                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 20
                            anchors.rightMargin: 20
                            spacing: 0

                            DataColumn {
                                width: 90
                                text: model.pid
                                textColor: dataText
                            }
                            DataColumn {
                                width: 220
                                text: model.name
                                textColor: primaryText
                                bold: true
                                elideMode: Text.ElideRight
                            }
                            DataColumn {
                                width: 110
                                text: model.cpu.toFixed(2) + "%"
                                textColor: model.cpu > 50 ? "#F1707B" : "#6CCB5F"
                            }
                            DataColumn {
                                width: 130
                                text: model.memory.toFixed(2)
                                textColor: dataText
                            }
                            DataColumn {
                                width: 100
                                text: model.threads
                                textColor: dataText
                            }
                            DataColumn {
                                width: 110
                                text: model.volCS
                                textColor: dataText
                            }
                            DataColumn {
                                width: 120
                                text: model.nonVolCS
                                textColor: dataText
                            }
                        }

                        MouseArea {
                            id: delegateMA
                            anchors.fill: parent
                            hoverEnabled: true
                        }
                    }

                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded

                        contentItem: Rectangle {
                            implicitWidth: 8
                            radius: 4
                            color: {
                                if (parent.pressed) return FluTheme.dark ? "#707070" : "#8A8A8A"
                                if (parent.hovered) return FluTheme.dark ? "#8A8A8A" : "#A6A6A6"
                                return FluTheme.dark ? "#5A5A5A" : "#BEBEBE"
                            }
                        }
                    }
                }
            }
        }

        // Pagination Card
        Rectangle {
            Layout.fillWidth: true
            height: 64
            radius: 8
            color: cardColor
            border.color: cardBorder
            border.width: 1

            Rectangle {
                anchors.fill: parent
                anchors.margins: -2
                radius: 8
                color: "transparent"
                border.color: shadowColor
                border.width: 1
                z: -1
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                spacing: 16

                FluentButton {
                    text: "❮  Previous"
                    enabled: ProcessModel.page > 0
                    onClicked: ProcessModel.prevPage()
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 40
                    radius: 4
                    color: headerBg
                    Text {
                        anchors.centerIn: parent
                        text: "Page " + (ProcessModel.page + 1) + " of " + ProcessModel.totalPages
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        color: dataText
                    }
                }

                FluentButton {
                    text: "Next  ❯"
                    enabled: ProcessModel.page < ProcessModel.totalPages - 1
                    onClicked: ProcessModel.nextPage()
                }
            }
        }
    }

    // Components
    component HeaderColumn: Item {
        property string text: ""
        width: 100
        height: 48

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: parent.text
            font.pixelSize: 13
            font.weight: Font.DemiBold
            color: dataText
        }
    }

    component DataColumn: Item {
        property string text: ""
        property color textColor: dataText
        property bool bold: false
        property int elideMode: Text.ElideNone
        width: 100
        height: 52

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: parent.text
            font.pixelSize: 14
            font.weight: parent.bold ? Font.Medium : Font.Normal
            color: parent.textColor
            elide: parent.elideMode
            width: parent.width - 10
        }
    }

    component FluentButton: Rectangle {
        id: button
        property string text: ""
        property bool enabled: true
        signal clicked()

        width: 120
        height: 40
        radius: 4
        color: {
            if (!enabled) return disabledBg
            if (buttonMA.pressed) return accentBlueDark
            if (buttonMA.containsMouse) return accentBlue
            return accentBlueHover
        }
        opacity: enabled ? 1.0 : 0.6


        Rectangle {
            anchors.fill: parent
            anchors.margins: -1
            radius: 4
            color: "transparent"
            border.color: button.enabled ? "#20000000" : "transparent"
            border.width: 1
            z: -1
        }

        Text {
            anchors.centerIn: parent
            text: button.text
            font.pixelSize: 14
            font.weight: Font.Medium
            color: button.enabled ? "#FFFFFF" : disabledText
        }

        MouseArea {
            id: buttonMA
            anchors.fill: parent
            hoverEnabled: false
            cursorShape: parent.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: if (parent.enabled) parent.clicked()
        }
    }
}
