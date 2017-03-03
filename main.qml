import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtMultimedia 5.5
import QtGraphicalEffects 1.0
import Qt.labs.folderlistmodel 2.1

import QtQuick 2.1 as QQ2

import "." // to import Settings
import "qrc:/tools/tools/SelectTool.js" as SelectTool
import "qrc:/tools/tools/InsertTool.js" as InsertTool
import "qrc:/tools/tools/MoveTool.js" as MoveTool
import "qrc:/tools/tools/DeleteTool.js" as DeleteTool

import SketchConverter 1.0
import SketchConstraintsSolver 1.0
import SketchStaticsExporter 1.0
import DisplayKeyboard 1.0
import RealtoExporter 1.0

Window {
    visible: true
    width: Settings.appWidth
    height: Settings.appHeight
    visibility: "Maximized"

    MainForm {
        id: mainForm
        anchors.fill: parent

        property SketchScreen sketchScreen: sketchScreen

        Loader {
            id: splashScreenLoader
            source: "qrc:/SplashScreen.qml"
            anchors.fill: parent
        }

        Loader {
            id: welcomeScreenLoader
            anchors.fill: parent
        }

        Loader {
            id: loginFormLoader
            anchors.fill: parent
        }

        Loader {
            id: sketchScreenLoader
            anchors.fill: parent
            focus: true
            Keys.onPressed: {
                if (status == Loader.Ready){
                    switch (event.key) {
                    case Qt.Key_S :
                        item.changeTool("SelectTool", "select from key")
                        break;
                    case Qt.Key_I :
                        item.changeTool("InsertTool", "insert from key")
                        break;
                    case Qt.Key_M :
                        item.changeTool("MoveTool", "move from key")
                        break;
                    case Qt.Key_D :
                        item.changeTool("DeleteTool", "delete from key")
                        break;
                    default :
                        console.log("key " + event.key + " pressed")
                        break;
                    }
                }
            }
        }

        Loader {
            id: captureImageLoader
            anchors.fill: parent
        }

        Loader {
            Component.onCompleted: this;
        }

        FontLoader { source: "fonts/Material-Design-Iconic-Font.ttf" }

        FontLoader { source: "fonts/FontAwesome.otf" }

        Loader{
            id:viewer3dLoader
            anchors.fill:parent;
            source: "qrc:/Viewer3D.qml"
            asynchronous: true
            active: false
            property url meshSource;
            onStatusChanged: {
                if(status===Loader.Ready){
                    item.mesh.source=meshSource;
                }
            }
        }

        DisplayKeyboard {
            id: displayKeyboard
        }

        RealtoExporter{
            id:realtoExporter
            onError: {
                message.displayErrorMessage(err);
            }
        }
    }
}

