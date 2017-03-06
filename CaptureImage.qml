import QtQuick 2.0
import QtMultimedia 5.6
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.4

import "." // to import Settings

Rectangle {
    anchors.fill: parent
    color: Settings.captureImagePanelBackground
    id: capturePanel

    property bool isImageCaptured: false;

    /*onVisibleChanged: {
        if(visible) {
            camera.start()
            isImageCaptured = false
        }
    }*/

    Camera {
        id: camera
        cameraState: Camera.ActiveState
        imageCapture {
            onImageCaptured: {
                photoPreview.source = preview
                isImageCaptured = true
                camera.stop()
            }
            onImageSaved: {
                console.log("preview", camera.imageCapture.capturedImagePath)
            }
        }
    }

    VideoOutput {
        id: videoOutput
        source: camera
        anchors.fill: parent
        fillMode: Settings.backgroundFillMode
        MouseArea {
            anchors.fill: parent
            onPressed: {
                camera.imageCapture.capture()
                console.log("resolution", camera.imageCapture.resolution)
            }
        }
    }

    Rectangle {
        id: previewPane
        width: parent.width
        anchors.bottom: parent.bottom

        Image {
            id: photoPreview
            fillMode: Settings.backgroundFillMode
            anchors.fill: parent
        }

        Button {
            text: "Retake"
            anchors.leftMargin: 20
            anchors.bottomMargin: 20
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            visible: isImageCaptured
            onClicked: {
                camera.start()
                isImageCaptured = false
            }
        }
        Button {
            text: "Cancel"
            anchors.bottomMargin: 20
            anchors.bottom: parent.bottom;
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                captureImageLoader.source = ""
                sketchScreenLoader.source = "qrc:/SketchScreen.qml"
            }
        }

        Button {
            text: "Use it"
            anchors.bottomMargin: 20
            anchors.rightMargin: 20
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            visible: isImageCaptured
            onClicked: {
                sketchScreenLoader.source = "qrc:/SketchScreen.qml"
                sketchScreenLoader.item.sketch.setBackground("file:///" + camera.imageCapture.capturedImagePath)
                captureImageLoader.source = ""
            }
        }
    }


    Rectangle {
        anchors.centerIn: parent
        color: "#20FFFFFF"
        border.color: "#80FFFFFF"
        radius: 5;
        visible: !isImageCaptured

        Label {
            text: "Touch the screen to take a picture"
            color: "#ffffff"
            anchors.centerIn: parent
        }
    }
}



