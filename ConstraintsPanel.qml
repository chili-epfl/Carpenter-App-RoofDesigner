import QtQuick 2.0
import QtQuick.Controls 1.4

Rectangle {
    id: constraintsPanel
    height: 30 + listRect.height +
            constraintButtons.visibleChildren.length * horz_const.height
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
        id: listRect
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
        id: constraintButtons
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10

        Button {
            id: horz_const
            text: "Horizonally constrained"
            checkable: true
            checked: false
            visible: false
            onVisibleChanged: this.checked = false
        }
        Button {
            id: vert_const
            text: "Vertically constrained"
            checkable: true
            checked: false
            visible: false
            onVisibleChanged: this.checked = false
        }
        Label {
            id: leng_const
            property bool checked: leng_const_button.checked
            property double value: leng_const_value.text
            width: parent.width
            height: leng_const_button.height
            visible: false
            Button {
                id: leng_const_button
                text: "Length constrained"
                checkable: true
                checked: false
                visible: parent.visible
                onVisibleChanged: this.checked = false
            }
            TextField {
                id: leng_const_value
                anchors.left: leng_const_button.right
                anchors.right: parent.right
                enabled: true
                validator: RegExpValidator {
                    regExp: /^([0-9]*)\.([0-9]*)|([0-9]+)$/
                }
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                placeholderText: "Length"
                width: implicitWidth
                font.pointSize: 14
                text: "5.0"
                horizontalAlignment: TextInput.AlignRight
                visible: parent.visible
                onVisibleChanged: text = "5.0"
            }
        }
        Button {
            id: equL_const
            text: "Equal length constrained"
            checkable: true
            checked: false
            visible: false
            onVisibleChanged: this.checked = false
        }
        Label {
            id: dist_const
            property bool checked: dist_const_button.checked
            property double value: dist_const_value.text
            width: parent.width
            height: dist_const_button.height
            visible: false
            Button {
                id: dist_const_button
                text: "Distance constrained"
                checkable: true
                checked: false
                visible: parent.visible
                onVisibleChanged: this.checked = false
            }
            TextField {
                id: dist_const_value
                anchors.left: dist_const_button.right
                anchors.right: parent.right
                enabled: true
                validator: RegExpValidator {
                    regExp: /^([0-9]*)\.([0-9]*)|([0-9]+)$/
                }
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                placeholderText: "Distance"
                width: implicitWidth
                font.pointSize: 14
                text: "5.0"
                horizontalAlignment: TextInput.AlignRight
                visible: parent.visible
                onVisibleChanged: text = "5.0"
            }
        }
        Button {
            id: para_const
            text: "Parallel constrained"
            checkable: true
            checked: false
            visible: false
            onVisibleChanged: this.checked = false
        }
        Button {
            id: perp_const
            text: "Perpendicular constrained"
            checkable: true
            checked: false
            visible: false
            onVisibleChanged: this.checked = false
        }
        Label {
            id: angl_const
            property bool checked: angl_const_button.checked
            property double value: angl_const_value.text
            width: parent.width
            height: angl_const_button.height
            visible: false
            Button {
                id: angl_const_button
                text: "Angle constrained"
                checkable: true
                checked: false
                visible: parent.visible
                onVisibleChanged: this.checked = false
            }
            TextField {
                id: angl_const_value
                anchors.left: angl_const_button.right
                anchors.right: parent.right
                enabled: true
                validator: RegExpValidator {
                    regExp: /^([0-9]*)\.([0-9]*)|([0-9]+)$/
                }
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                placeholderText: "Distance"
                width: implicitWidth
                font.pointSize: 14
                text: "5.0"
                horizontalAlignment: TextInput.AlignRight
                visible: parent.visible
                onVisibleChanged: text = "90"
            }
        }
        Button {
            id: midP_const
            text: "Mid point constrained"
            checkable: true
            checked: false
            visible: false
            onVisibleChanged: this.checked = false
        }
        Button {
            id: validate
            text: "Validate constraints"
            anchors.right: parent.right
            visible: !no_const.visible
            onClicked: {
                sketch.constraints.add()
                listEntities.clear()
                horz_const.visible = false
                vert_const.visible = false
                leng_const.visible = false
                equL_const.visible = false
                dist_const.visible = false
                para_const.visible = false
                perp_const.visible = false
                angl_const.visible = false
                midP_const.visible = false
                no_const.visible = true
            }
        }

        Text {
            id: no_const
            text: "No constrains available"
            visible: true
        }
    }
}
