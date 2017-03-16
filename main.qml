import QtQuick 2.7
import QtQuick.Controls 2.1 as QQ2
import QtQuick.Layouts 1.1
import QtMultimedia 5.5

import "." // to import Settings
import "qrc:/tools/tools/SelectTool.js" as SelectTool
import "qrc:/tools/tools/InsertTool.js" as InsertTool
import "qrc:/tools/tools/MoveTool.js" as MoveTool
import "qrc:/tools/tools/DeleteTool.js" as DeleteTool

import SketchConverter 1.0
import SketchConstraintsSolver 1.0
import SketchStaticsExporter 1.0
import RealtoExporter 1.0

QQ2.ApplicationWindow {
    visible: true
    width: Settings.appWidth
    height: Settings.appHeight
    visibility: "Maximized"

    header:Loader {
        id: menuBarLoader
        Binding {
            when: menuBarLoader.status == Loader.Ready
            target: menuBarLoader.item
            property: "sketchScreenLoader"
            value: sketchScreenLoader
        }
    }


    Loader{
        id: fileDialogLoader
        Binding {
            when: fileDialogLoader.status == Loader.Ready
            target: fileDialogLoader.item
            property: "sketchScreenLoader"
            value: sketchScreenLoader
        }
    }


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
            if(status == Loader.Ready){
                item.mesh.source=meshSource;
            }
        }
    }

    RealtoExporter{
        id:realtoExporter
        onError: {
            message.displayErrorMessage(err);
        }
    }

    MessageBox {
        id: message
    }

}

