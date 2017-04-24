import QtQuick 2.0
import QtQuick.Controls 1.4

Rectangle {
    id: constraintsPanel
    height: (listEntities.count + checkBoxes.visibleChildren.length + 2) * 20
    width: 300
    color: "#999999"
    anchors.margins: 10

    property ListModel listEntities: listEntities
    property alias horz_const: horz_const
    property alias vert_const: vert_const
    property alias leng_const: leng_const
    property alias equL_const: equL_const
    property alias dist_const: dist_const
    property alias para_const: para_const
    property alias perp_const: perp_const
    property alias angl_const: angl_const
    property alias midP_const: midP_const
    property alias no_const: no_const

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
            id: horz_const
            text: "Horizonally constrained"
            checked: false
            visible: false
            onVisibleChanged: this.checked = false
        }
        CheckBox {
            id: vert_const
            text: "Vertically constrained"
            checked: false
            visible: false
            onVisibleChanged: this.checked = false
        }
        CheckBox {
            id: leng_const
            text: "Length constrained"
            checked: false
            visible: false
            onVisibleChanged: this.checked = false
        }
        CheckBox {
            id: equL_const
            text: "Equal length constrained"
            checked: false
            visible: false
            onVisibleChanged: this.checked = false
        }
        CheckBox {
            id: dist_const
            text: "Distance constrained"
            checked: false
            visible: false
            onVisibleChanged: this.checked = false
        }
        CheckBox {
            id: para_const
            text: "Parallel constrained"
            checked: false
            visible: false
            onVisibleChanged: this.checked = false
        }
        CheckBox {
            id: perp_const
            text: "Perpendicular constrained"
            checked: false
            visible: false
            onVisibleChanged: this.checked = false
        }
        CheckBox {
            id: angl_const
            text: "Angle constrained"
            checked: false
            visible: false
            onVisibleChanged: this.checked = false
        }
        CheckBox {
            id: midP_const
            text: "Mid point constrained"
            checked: false
            visible: false
            onVisibleChanged: this.checked = false
        }
        Text {
            id: no_const
            text: "No constrains available"
            visible: true
        }
    }
}
