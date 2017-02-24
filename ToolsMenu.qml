import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import "." // to import Settings


Rectangle {
    id: toolsMenu
    width: childrenRect.width
    height: menuItems.count * itemHeight

    property real itemHeight: 72

    function toggleState() {
        console.log("change state")
        if(menu.state === "hidden") {
            menu.state = "visible"
        }
        else {
            menu.state = "hidden"
        }
    }

    transitions: Transition {
        PropertyAnimation { properties: "y"; easing.type: Easing.InOutQuad }
    }

    ListView {
        height: toolsMenu.height
        width: itemHeight

        model: menuItems
        delegate: Rectangle {
            width: childrenRect.width
            height: childrenRect.height
            color: isToolSelected(tool) ? Settings.paletteHighlight : Settings.palette;

            function isToolSelected(tool) {
                return sketchScreen.state === tool;
            }

            property color labelColor : isToolSelected(tool) ? Settings.selectedToolColor : Settings.toolColor
            property int labelFontSize : 24

            Label {
                text: icon
                font.family: fontName
                font.pointSize: labelFontSize
                color: labelColor
                height: toolsMenu.itemHeight
                width: toolsMenu.width
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            MouseArea {
                anchors.fill: parent
                onClicked: sketchScreen.changeTool(tool, name)
            }
        }
    }

    MenuItem{
        id: menuItems
    }
}



