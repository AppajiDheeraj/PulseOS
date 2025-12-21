import QtQuick
import FluentUI 1.0

FluContentDialog {
    id: exitDialog
    title: qsTr("Exit CarbonQt")
    message: qsTr("Are you sure you want to exit?")

    positiveText: qsTr("Exit")
    negativeText: qsTr("Cancel")

    onPositiveClicked: Qt.quit()
}
