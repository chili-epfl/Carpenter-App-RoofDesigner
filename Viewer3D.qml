import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtMultimedia 5.5
import QtGraphicalEffects 1.0
import Qt.labs.folderlistmodel 2.1

import Qt3D.Core 2.0
import Qt3D.Render 2.0
import QtQuick 2.1 as QQ2
import QtQuick.Scene3D 2.0


Rectangle {

    function dp2px(dp){
        return  dp * (0.15875 *Screen.pixelDensity)
    }

    id: viewer3d
    anchors.fill: parent
    color: "white"
    z: 1250
    visible: false
    property Mesh mesh: mesh

    Button {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 20
        text: "Menu"
        style: RoundedButton {
            icon: "\uf060";
        }
        z: 100


        onClicked: {
            welcomeScreen.visible = true
            viewer3d.visible = false
            console.log("hide viewer3d")
        }
    }

    Image {
        anchors.right: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.margins: 20
        source: minus_mouse_area.pressed ? "qrc:/icons/icons/minus_pressed.png" :"qrc:/icons/icons/minus.png"
        z: 100
        width: dp2px(56)
        height: width
        MouseArea{
            id:minus_mouse_area
            anchors.fill: parent;
            onClicked: {
                transform.scale*=0.80
            }
        }
    }
    Image {
        anchors.left: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.margins: 20
        z: 100
        width: dp2px(56)
        height: width
        source: plus_mouse_area.pressed ? "qrc:/icons/icons/plus_pressed.png" :"qrc:/icons/icons/plus.png"
        MouseArea{
            id:plus_mouse_area
            anchors.fill: parent;
            onClicked: {
                transform.scale*=1.2
            }
        }
    }

    Scene3D {
        id: scene3d
        anchors.fill: parent
        anchors.margins: 10
        focus: true
        aspects: "input"

        Entity {
            id: root

            // Render from the mainCamera
            components: [
                FrameGraph {
                    activeFrameGraph: ForwardRenderer {
                        id: renderer
                        camera: mainCamera
                    }
                }
            ]

            Camera {
                id: mainCamera
                projectionType: CameraLens.PerspectiveProjection
                fieldOfView: 22.5
                aspectRatio: mainForm.width / mainForm.height
                nearPlane:   0.01
                farPlane:    1000.0
                viewCenter: Qt.vector3d( 0.0, 0.0, 0.0 )
                upVector:   Qt.vector3d( 0.0, 1.0, 0.0 )
                position: Qt.vector3d( 0.0, 0.0, 15.0 )

            }

            Configuration  {
                controlledCamera: mainCamera
            }

            Entity {
                Mesh {
                    id: mesh
                }
                Transform{
                    id:transform
                    scale:1

                }

                components: [mesh,transform]

            }
        }
    }

}

