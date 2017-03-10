import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtMultimedia 5.5
import QtGraphicalEffects 1.0

Rectangle {
    anchors.fill: parent
    color: "white"

    Label {
        id: appTitle
        text: "CARPENTER"
        //font.family: "Avenir LT Std 65 Medium"
        color: Qt.rgba(0.96470588235294117647058823529412,0.58823529411764705882352941176471,0.0039215686274509803921568627451,1)
        font.pointSize: 74
        anchors.centerIn: parent
    }

    Label {
        id: slogan
        text: "the app that plans"
        anchors.left: appTitle.left
        anchors.top: appTitle.bottom
        anchors.topMargin: -31
        color: Qt.rgba(0,0,0,0.8)
        //font.family: "Avenir LT Std 65 Medium"
        font.pointSize: 36
    }

    Rectangle {
        anchors.left: firstPoint.left
        color: "#BBBBBB"
        height: firstPoint.height
        anchors.verticalCenter: firstPoint.verticalCenter
        radius: firstPoint.radius

        SequentialAnimation on width {
            loops: 1
            PropertyAnimation {
                to: 200
                easing.type: Easing.OutQuad
                duration: 2000
            }
            PropertyAnimation {
                from: 200
                to: 260
                duration: 0

            }
        }
    }

    Rectangle {
        id: firstPoint
        radius:15
        anchors.verticalCenterOffset: 9
        border.width: 0
        width:30
        height:30
        color: "#808080"
        anchors.left: slogan.right
        anchors.leftMargin: 30
        anchors.verticalCenter: slogan.verticalCenter
        anchors.topMargin: 10
    }

    Rectangle {
        id:secondPoint
        radius:firstPoint.radius
        border.width: 0
        width:firstPoint.height
        height:firstPoint.height
        color: "#808080"
        anchors.left: firstPoint.right;
        anchors.leftMargin: 200
        anchors.verticalCenter: firstPoint.verticalCenter
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 700
        }
    }

    Timer {
        id: reset
        interval: 3500
        running: true

        onTriggered: {
            sketchScreenLoader.source = "qrc:/SketchScreen.qml"
            menuBarLoader.source = "qrc:/MenuBar.qml"
            splashScreenLoader.source = ""
        }
    }

    MouseArea {
        anchors.fill: parent
    }
}
