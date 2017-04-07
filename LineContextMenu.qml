import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.2
import QtQuick.Window 2.0

Popup {
    id: lineContextMenu
    width: Screen.pixelDensity*55 +20
    height: Screen.pixelDensity*10 +20
    visible: false

    RowLayout {
        anchors.fill: parent
        spacing: 5
        Label {
            text: "\uf07e"
            font.family: "FontAwesome"
            font.pointSize: 14
        }
        TextField {
            Layout.preferredWidth: Screen.pixelDensity*25
            enabled: true
            validator: RegExpValidator {
                regExp: /^([0-9]*)\.([0-9]*)|([0-9]+)$/
            }
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            placeholderText: "Initial scale"
            width: implicitWidth
            font.pointSize: 14
        }
        Label {
            text: "m"
            font.pointSize: 14
        }

        ToolButton {
            text: "|"
            onClicked: {
            }
            checkable: true
        }
        ToolButton {
            text: " – "
            onClicked: {
            }
            checkable: true
        }
    }
}

