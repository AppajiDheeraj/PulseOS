pragma Singleton

import QtQuick 2.15
import FluentUI 1.0

FluObject{

    signal requestAbout()

    property var navigationView

    FluPaneItemSeparator{}

    FluPaneItem {
        title: "About"
        icon: FluentIcons.Info
        onTap: requestAbout()
    }

    FluPaneItem {
        title: "Settings"
        icon: FluentIcons.Settings
        onTap: navigationView.push("qrc:/carbonqt/qml/page/Settings.qml")
    }
}
