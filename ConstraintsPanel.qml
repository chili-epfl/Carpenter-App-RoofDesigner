import QtQuick 2.0
import QtQuick.Controls 2.1
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
Rectangle {
    id: constraintsPanel
    color: "#999999"

    Drag.active: drag_area.drag.active

    Rectangle{
        color: "white"
        border.color: "black"
        border.width: 2
        Text {
            anchors.fill: parent
            text: "\uf047"
            font.family: "FontAwesome"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        anchors.verticalCenter: parent.verticalCenter
        width: Screen.pixelDensity*5
        height: width
        anchors.right: parent.left
        radius: width/2
        MouseArea{
            id:drag_area
            anchors.fill: parent
            drag.target: constraintsPanel
            drag.onActiveChanged: {
                if(!drag.active){
                    var x_anchor=constraintsPanel.x
                    var y_anchor=constraintsPanel.y+0.5*constraintsPanel.height
                    if(x_anchor<Screen.pixelDensity*10 ||
                            x_anchor>constraintsPanel.parent.width-Screen.pixelDensity*10 ||
                            y_anchor<Screen.pixelDensity*10 ||
                            y_anchor>constraintsPanel.parent.height-Screen.pixelDensity*10
                            ){
                        constraintsPanel.x=constraintsPanel.parent.width
                        constraintsPanel.y=constraintsPanel.parent.height/2-constraintsPanel.height/2
                    }
                }

            }
        }
    }
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

    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 5
        Rectangle {
            id: listRect
            color: "white"
            border.width: 1
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumHeight: parent.height/2
            Layout.minimumHeight: Screen.pixelDensity*5
            ListView {
                anchors.fill: parent
                clip: true
                model: ListModel{
                    id: listEntities
                }
                delegate: Text {
                    width: listRect.width
                    height: Screen.pixelDensity*5
                    text: "" + object
                    fontSizeMode: Text.Fit
                    minimumPixelSize: 10;
                }
            }
        }
        GridLayout{
            id: constraintButtons
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: Screen.pixelDensity*5*2
            Layout.maximumHeight: parent.width
            columns: 3
            Item{
                Layout.fillHeight: true
                Layout.fillWidth: true
                Button {
                    id: horz_const
                    anchors.centerIn: parent
                    width: height
                    height: Math.min(parent.width,parent.height)
                    text: "\u2015"
                    checkable: true
                    checked: false
                    enabled: false
                    onEnabledChanged: this.checked = false
                }
            }
            Item{
                Layout.fillHeight: true
                Layout.fillWidth: true
                Button {
                    id: vert_const
                    text: "\u007C"
                    anchors.centerIn: parent
                    width: height
                    height: Math.min(parent.width,parent.height)
                    checkable: true
                    checked: false
                    enabled: false
                    onEnabledChanged: this.checked = false
                }
            }
            Item{
                Layout.fillHeight: true
                Layout.fillWidth: true
                Button {
                    id: equL_const
                    text: "\uFF1D"
                    anchors.centerIn: parent
                    width: height
                    height: Math.min(parent.width,parent.height)
                    checkable: true
                    checked: false
                    enabled: false
                    onEnabledChanged: this.checked = false
                }

            }
            Item{
                Layout.fillHeight: true
                Layout.fillWidth: true
                Button {
                     id: para_const
                     text: "\u2225"
                     anchors.centerIn: parent
                     width: height
                     height: Math.min(parent.width,parent.height)
                     checkable: true
                     checked: false
                     enabled: false
                     onEnabledChanged: this.checked = false
                 }

            }
            Item{
                Layout.fillHeight: true
                Layout.fillWidth: true
                Button {
                    id: perp_const
                    text: "\u27C2"
                    anchors.centerIn: parent
                    width: height
                    height: Math.min(parent.width,parent.height)
                    checkable: true
                    checked: false
                    enabled: false
                    onEnabledChanged: this.checked = false
                }

            }
            Item{
                Layout.fillHeight: true
                Layout.fillWidth: true
                visible:false
                Button {
                    id: midP_const
                    text: "\u237F"
                    anchors.centerIn: parent
                    width: height
                    height: Math.min(parent.width,parent.height)
                    checkable: true
                    checked: false
                    enabled: false
                    onEnabledChanged: this.checked = false
                }

            }
        }
        Item {
            id: leng_const
            property bool checked: leng_const_button.checked
            property double value: leng_const_value.text
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: Screen.pixelDensity*5
            Layout.maximumHeight: Screen.pixelDensity*10
            enabled: false
            Button {
                id: leng_const_button
                text: "Length:"
                height: parent.height
                checkable: true
                checked: false
                enabled: parent.enabled
                onEnabledChanged: this.checked = false
            }
            TextField {
                id: leng_const_value
                height: parent.height
                anchors.left: leng_const_button.right
                anchors.right: parent.right
                validator: RegExpValidator {
                    regExp: /^([0-9]*)\.([0-9]*)|([0-9]+)$/
                }
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                placeholderText: "Length"
                text: "100.0"
                horizontalAlignment: TextInput.AlignRight
                enabled: parent.enabled
                onTextChanged: leng_const_button.checked = true
            }
        }
        Item {
            id: dist_const
            property bool checked: dist_const_button.checked
            property double value: dist_const_value.text
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: Screen.pixelDensity*5
            Layout.maximumHeight: Screen.pixelDensity*10
            enabled: false
            Button {
                id: dist_const_button
                height: parent.height
                text: "Distance"
                checkable: true
                checked: false
                enabled: parent.enabled
                onEnabledChanged: this.checked = false
            }
            TextField {
                id: dist_const_value
                anchors.left: dist_const_button.right
                anchors.right: parent.right
                height: parent.height
                validator: RegExpValidator {
                    regExp: /^([0-9]*)\.([0-9]*)|([0-9]+)$/
                }
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                placeholderText: "Distance"
                text: "100.0"
                horizontalAlignment: TextInput.AlignRight
                enabled: parent.enabled
                onTextChanged: dist_const_button.checked = true
            }
        }
        Item {
            id: angl_const
            property bool checked: angl_const_button.checked
            property double value: angl_const_value.text
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: Screen.pixelDensity*5
            Layout.maximumHeight: Screen.pixelDensity*10
            enabled: false
            Button {
                id: angl_const_button
                text: "Angle"
                checkable: true
                height: parent.height
                checked: false
                enabled: parent.enabled
                onEnabledChanged: this.checked = false
            }
            TextField {
                id: angl_const_value
                anchors.left: angl_const_button.right
                anchors.right: parent.right
                height: parent.height
                validator: RegExpValidator {
                    regExp: /^([0-9]*)\.([0-9]*)|([0-9]+)$/
                }
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                placeholderText: "Angle"
                text: "90"
                horizontalAlignment: TextInput.AlignRight
                enabled: parent.enabled
                onTextChanged: angl_const_button.checked = true
            }
        }
        Button {
            id: validate
            text: "Validate constraints"
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: Screen.pixelDensity*5
            Layout.maximumHeight: Screen.pixelDensity*10
            onClicked: {
                sketch.constraints.add()
                listEntities.clear()
                horz_const.enabled = false
                vert_const.enabled = false
                leng_const.enabled = false
                equL_const.enabled = false
                dist_const.enabled = false
                para_const.enabled = false
                perp_const.enabled = false
                angl_const.enabled = false
                midP_const.enabled = false
                sketch.constraints.apply(sketch)
            }
        }
    }

}
