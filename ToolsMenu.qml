import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0

Rectangle {
    id: toolsMenu
    width:Screen.pixelDensity*10+20
    height: tool_list.model.count * Screen.pixelDensity*10+ 20

    ListView {
        id:tool_list
        anchors.fill: parent
        anchors.margins: 10
        clip:true
        currentIndex:0

        model:ListModel{
            ListElement {
                name: "SelectTool"
                icon: "\uf245"
            }
            ListElement {
                name: "InsertTool"
                icon: "\uf040"
            }
            ListElement {
                name: "MoveTool"
                icon: "\uf047"
            }
            ListElement {
                name: "DeleteTool"
                icon: "\uf00d"
            }
        }
        delegate: Rectangle {
            width: Screen.pixelDensity*10
            height: width
            color: ListView.isCurrentItem ? "#40404040": "#20000000"
            Label {
                text: icon
                font.family: "FontAwesome"
                font.pointSize: 24
                color: ListView.isCurrentItem ? "#444444" : "black"
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    sketchScreen.toolName=name
                    tool_list.currentIndex=index
                }
            }
        }
    }

}



