import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import CarbonQt 1.0

Item {
    anchors.fill: parent

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        // Header
        RowLayout {
            Layout.fillWidth: true

            Text {
                text: "Processes"
                font.pixelSize: 22
                font.bold: true
                color: "#333333"  // ← ADD THIS
            }

            Item { Layout.fillWidth: true }

            Button {
                text: "Refresh"
                onClicked: ProcessModel.refresh()
            }
        }

        // Table Header
        Rectangle {
            Layout.fillWidth: true
            height: 40
            color: "#f0f0f0"
            border.color: "#d0d0d0"

            Row {
                anchors.fill: parent
                anchors.margins: 4

                Text { width: 80; text: "PID"; font.bold: true; color: "#333333"; verticalAlignment: Text.AlignVCenter }  // ← ADD color
                Text { width: 200; text: "Name"; font.bold: true; color: "#333333"; verticalAlignment: Text.AlignVCenter }
                Text { width: 90; text: "CPU %"; font.bold: true; color: "#333333"; verticalAlignment: Text.AlignVCenter }
                Text { width: 120; text: "Memory (MB)"; font.bold: true; color: "#333333"; verticalAlignment: Text.AlignVCenter }
                Text { width: 90; text: "Threads"; font.bold: true; color: "#333333"; verticalAlignment: Text.AlignVCenter }
                Text { width: 90; text: "Vol CS"; font.bold: true; color: "#333333"; verticalAlignment: Text.AlignVCenter }
                Text { width: 110; text: "Non-Vol CS"; font.bold: true; color: "#333333"; verticalAlignment: Text.AlignVCenter }
            }
        }

        // Table Content
        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            model: ProcessModel

            delegate: Rectangle {
                width: listView.width
                height: 35
                color: index % 2 === 0 ? "white" : "#fafafa"
                border.color: "#e0e0e0"

                Row {
                    anchors.fill: parent
                    anchors.margins: 4

                    Text {
                        width: 80
                        text: model.pid
                        color: "#333333"  // ← ADD THIS
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text {
                        width: 200
                        text: model.name
                        color: "#333333"  // ← ADD THIS
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }
                    Text {
                        width: 90
                        text: model.cpu.toFixed(2)
                        color: "#333333"  // ← ADD THIS
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text {
                        width: 120
                        text: model.memory.toFixed(2)
                        color: "#333333"  // ← ADD THIS
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text {
                        width: 90
                        text: model.threads
                        color: "#333333"  // ← ADD THIS
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text {
                        width: 90
                        text: model.volCS
                        color: "#333333"  // ← ADD THIS
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text {
                        width: 110
                        text: model.nonVolCS
                        color: "#333333"  // ← ADD THIS
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            ScrollBar.vertical: ScrollBar {}
        }

        // Pagination Controls
        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Button {
                text: "◀ Previous"
                enabled: ProcessModel.page > 0
                onClicked: ProcessModel.prevPage()
            }

            Text {
                text: "Page " + (ProcessModel.page + 1) + " / " + ProcessModel.totalPages
                font.pixelSize: 14
                color: "#333333"  // ← ADD THIS
            }

            Button {
                text: "Next ▶"
                enabled: ProcessModel.page < ProcessModel.totalPages - 1
                onClicked: ProcessModel.nextPage()
            }

            Item { Layout.fillWidth: true }
        }
    }
}
