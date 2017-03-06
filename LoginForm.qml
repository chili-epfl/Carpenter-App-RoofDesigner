import QtQuick 2.0
import QtQuick.Controls 1.4

Rectangle{
    id: loginForm
    visible: true;
    anchors.fill: parent
    color: "#2f3439"

    Image{
        id:logo_image
        source: "qrc:/icons/icons/realto_logo.png"
        height: parent.height/3 - 20
        width: height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top:parent.top
        anchors.margins: 20
    }
    TextField {
        id:email_field
        placeholderText: "Enter Email"
        text:"lorenzo.lucignano@epfl.ch"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: logo_image.bottom
        anchors.margins: 20
        font.pointSize:15
        width: parent.width-40

    }
    TextField {
        id:host_field
        placeholderText: "Enter Realto Host"
        text: "http://10.0.0.15:3003/api/carpenterData"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: email_field.bottom
        font.pointSize:15
        anchors.margins: 20
        width: parent.width-40

    }

    Button{
        id:synch_botton
        text: "Synchronize"
        onClicked: {
            realtoExporter.username=email_field.text
            realtoExporter.host=host_field.text
            realtoExporter.pushScenarios();
        }
        anchors.top: host_field.bottom
        anchors.left: parent.horizontalCenter
        anchors.margins: 20
    }

    Button{
        text: "Close"
        onClicked: {
            welcomeScreenLoader.source = "qrc:/SketchScreen.qml"
            loginFormLoader.source = ""
        }
        anchors.top: host_field.bottom
        anchors.right: parent.horizontalCenter
        anchors.margins: 20
    }
    ProgressBar{
        visible: realtoExporter.loading
        anchors.top:synch_botton.bottom
        width: parent.width-20
        anchors.horizontalCenter: parent.horizontalCenter
        indeterminate: true
        anchors.margins: 20
    }
}
