import QtQuick
import QtQuick.Layouts
import FluentUI 1.0
import CarbonQt 1.0
import "../global"

FluWindow {
    id: window
    width: 1200
    height: 800
    visible: true
    title: "CarbonQt"
    fitsAppBarWindows: true

    AboutDialog {
        id: aboutDialog
    }

    ExitDialog { id: exitDialog }

    appBar: FluAppBar {
        height: 36
        showDark: true
        closeClickListener: () => exitDialog.open()
    }

    FluNavigationView {
        id: navView
        anchors.fill: parent

        items: ItemsOriginal
        footerItems: ItemsFooter
        displayMode: GlobalModel.displayMode

        logo: "qrc:/example/res/image/favicon.ico"
        title: "CarbonQt"

        Component.onCompleted: {
            ItemsOriginal.navigationView = navView
            ItemsFooter.requestAbout.connect(() => {
                aboutDialog.show()
            })
            setCurrentIndex(0)
        }
    }
}

