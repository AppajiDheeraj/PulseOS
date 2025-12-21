pragma Singleton
import QtQuick 2.15
import FluentUI 1.0

FluObject{
    property var navigationView
    property var paneItemMenu

    function rename(item, newName){
        if(newName && newName.trim().length>0){
            item.title = newName;
        }
    }

    FluPaneItem {
        title: "Home"
        icon: FluentIcons.Home
        onTap: {
            // Push the page using the component
            navigationView.push(Qt.resolvedUrl("../pages/Home.qml"))
        }
    }

    FluPaneItem {
        title: "Performance"
        icon: FluentIcons.SpeedHigh
        onTap: {
            navigationView.push(Qt.resolvedUrl("../pages/Performance.qml"))
        }
    }

    FluPaneItem {
        title: "Processes"
        icon: FluentIcons.Process
        onTap: {
            navigationView.push(Qt.resolvedUrl("../pages/Processes.qml"))
        }
    }

    FluPaneItemSeparator{
        spacing:10
        size:1
    }

    FluPaneItemExpander{
        title: qsTr("Other")
        icon: FluentIcons.Shop
        FluPaneItem{
            title: qsTr("QRCode")
            menuDelegate: paneItemMenu
            url: "qrc:/example/qml/page/T_QRCode.qml"
            onTap: { navigationView.push(url) }
        }
        FluPaneItem{
            title: qsTr("Tour")
            menuDelegate: paneItemMenu
            url: "qrc:/example/qml/page/T_Tour.qml"
            onTap: { navigationView.push(url) }
        }
        FluPaneItem{
            title: qsTr("Timeline")
            menuDelegate: paneItemMenu
            url: "qrc:/example/qml/page/T_Timeline.qml"
            onTap: { navigationView.push(url) }
        }
    }

    function getSearchData(){
        if(!navigationView){
            return
        }
        var arr = []
        var items = navigationView.getItems();
        for(var i=0;i<items.length;i++){
            var item = items[i]
            if(item instanceof FluPaneItem){
                if (item.parent instanceof FluPaneItemExpander)
                {
                    arr.push({title:`${item.parent.title} -> ${item.title}`,key:item.key})
                }
                else
                    arr.push({title:item.title,key:item.key})
            }
        }
        return arr
    }
}
