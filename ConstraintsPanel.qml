import QtQuick 2.0
import QtQuick.Controls 1.4

Rectangle {
    height: (listEntities.count + checkBoxes.visibleChildren.length) * 20 + 25
    width: 300
    color: "#999999"
    anchors.margins: 10

    property ListModel listEntities: listEntities

    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 10
        color: "white"
        border.width: 1
        height: (listEntities.count + 1) * 20
        width: parent.width - 20
        ListView {
            anchors.fill: parent
            anchors.margins: 10
            model: ListModel{
                id: listEntities
            }
            delegate: Text {
                text: "" + object
            }
        }
    }

    Column {
        id: checkBoxes
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 10

        CheckBox {
            text: "Horizonally constrained"
            checked: false
            visible: true
        }
        CheckBox {
            text: "Vertically constrained"
            checked: false
            visible: true
        }
        CheckBox {
            text: "Equal length constrained"
            checked: false
            visible: true
        }
        CheckBox {
            text: "Parallel constrained"
            checked: false
            visible: true
        }
        CheckBox {
            text: "Angle constrained"
            checked: false
            visible: true
        }
        CheckBox {
            text: "Mid point constrained"
            checked: false
            visible: true
        }
        Text {
            text: "No constrains available"
            visible: true
        }
    }
}
