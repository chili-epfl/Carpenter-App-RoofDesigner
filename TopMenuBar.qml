import "." // to import Settings
import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0

import Constraints 1.0
import SketchConverter 1.0
import SketchStaticsExporter 1.0

ToolBar {
    id: menuBar
    property alias sketch_name:title_field.text
    TextField{
        id:title_field
        background: Rectangle{color: "transparent"}
        anchors.left: parent.left
        anchors.topMargin: 5
        anchors.bottomMargin: 5
        anchors.leftMargin: 15
        anchors.top:parent.top
        anchors.bottom: parent.bottom
        placeholderText: "Title: "+ default_title
        property string default_title
        Component.onCompleted: {
            var date=new Date()
            default_title= date.toLocaleString(Qt.locale("en_GB"),"dd-MMM-yy_hh-mm")
        }
    }
    Row{
        anchors.centerIn: parent
        spacing: 10
        Image{
            source: "qrc:/icons/icons/simple-orange-house-md.png"
            fillMode: Image.PreserveAspectFit
            height: menuBar.height-10
            anchors.verticalCenter: parent.verticalCenter
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    //Add code to save
                    title_field.text.trim().length>0 ?
                                json_sketch.exportJSONSketch(title_field.text.trim()+".json",sketch):
                                json_sketch.exportJSONSketch(title_field.default_title+".json",sketch)
                    stack_view.pop()
                }
            }
        }
        ToolSeparator{height: menuBar.height}
        Image{
            source: "qrc:/icons/icons/undo-4-xxl.png"
            fillMode: Image.PreserveAspectFit
            height: menuBar.height-10
            anchors.verticalCenter: parent.verticalCenter
            MouseArea{
                anchors.fill: parent
                onClicked: sketch.undo();
            }
        }
        Image{
            source: "qrc:/icons/icons/redo-4-xxl.png"
            fillMode: Image.PreserveAspectFit
            height: menuBar.height-10
            anchors.verticalCenter: parent.verticalCenter
            MouseArea{
                anchors.fill: parent
                onClicked: sketch.redo();
            }
        }
        ToolSeparator{height: menuBar.height}
        Image{
            source: "qrc:/icons/icons/camera.png"
            fillMode: Image.PreserveAspectFit
            height: menuBar.height-10
            anchors.verticalCenter: parent.verticalCenter
            MouseArea{
                anchors.fill: parent
                onClicked: sketchScreen.aux_loader.source="qrc:/CaptureImage.qml"

            }
        }
        ToolSeparator{height: menuBar.height}
        Image{
            source: "qrc:/icons/icons/export3d.png"
            fillMode: Image.PreserveAspectFit
            height: menuBar.height-10
            anchors.verticalCenter: parent.verticalCenter
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    console.log(json_sketch.exportJSONSketch(sketch_folder + sketch_file, sketch))
                }
            }
        }
        ToolSeparator{height: menuBar.height}
        ToolButton{
            text:"⋮"
            height: menuBar.height
            onClicked: textMenu.open()
            Menu {
                id:textMenu
                title: "View"
                y:parent.height
                width: display_background_menu_item.implicitWidth
                MenuItem {
                    id:display_background_menu_item
                    text: "Display background"
                    enabled: sketchScreen.isBackgroundSet
                    checkable: true
                    checked: sketchScreen.isBackgroundSet && sketchScreen.visibleBackground
                    onTriggered: {
                        sketchScreen.visibleBackground=this.checked
                    }
                }
                MenuItem {
                    text: "Display grid"
                    checkable: true
                    checked: sketchScreen.visibleGrid
                    onTriggered: {
                        sketchScreen.visibleGrid=this.checked
                    }
                }
                MenuItem {
                    text: "Login"
                    onTriggered: {
                        //                        loginFormLoader.source = "qrc:/LoginForm.qml"
                        //                        sketchScreenLoader.source = ""
                    }
                }

                MenuItem {
                    text: "Apply EXAMPLE constraints"
                    onTriggered: {
                        sketch.constraints.apply()
                    }
                }

                MenuItem {
                    text: "Apply constraints"
                    onTriggered: {
                        sketch.constraints.apply(sketch)
                    }
                }
            }
        }
    }
}




