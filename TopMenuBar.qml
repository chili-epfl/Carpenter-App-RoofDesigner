import "." // to import Settings
import QtQuick 2.7
import QtQuick.Controls 2.1
import QtMultimedia 5.5
import QtQuick.Layouts 1.1
import SketchConverter 1.0
import SketchStaticsExporter 1.0

ToolBar {
    id: menuBar
    property var sketchScreenLoader
    property var sketch: sketchScreenLoader.item.sketch
    RowLayout{
        anchors.fill: parent
        ToolButton{
            text: "File"
            onClicked: fileMenu.open()
            Menu {
                id:fileMenu
                title: "File"
                y:parent.height
                width: save_skecth_menu_item.implicitWidth
                MenuItem {
                    text: "New sketch"
                    onTriggered: {
                        if(QtMultimedia.availableCameras.length === 0) {
                            message.displayErrorMessage("No camera available");
                        }
                        else {
                            captureImageLoader.source = "qrc:/CaptureImage.qml"
                            sketchScreenLoader.source = ""
                        }
                    }
                }
                MenuItem {
                    text: "Open a sketch"
                    onTriggered: {
                        fileDialogLoader.source = "OpenFileDialog.qml"
                    }
                }
                MenuSeparator {}
                MenuItem {
                    id:save_skecth_menu_item
                    text: "Save the sketch"
                    onTriggered: {
                        fileDialogLoader.source = "SaveFileDialog.qml"
                    }
                    property SketchStaticsExporter staticsExporter: SketchStaticsExporter {
                        sketch: sketchScreenLoader.item.sketch }
                }
                MenuItem {
                    text: "Export as 3D"
                    onTriggered: {
                        var basename=new Date().toLocaleString(Qt.locale(),"dMyyhms");

                        var staticsExportResult = staticsExporter.exportToFile(basename,Settings.defaultCaptureImagePath,Qt.size(mainForm.width,mainForm.height));
                        console.log("staticsExportResult", staticsExportResult);

                        var exportResult = converter.exportToFile(sketch, basename);
                        console.log("exportResult: ", exportResult);

                        if(exportResult === true) {
                            if(staticsExportResult !== true) {
                                message.displayErrorMessage("Text file export failed: " + staticsExportResult)
                            }
                            else {
                                message.displaySuccessMessage("3D export succeed")
                            }
                        }
                        else {
                            message.displayErrorMessage("3D export failed : " + exportResult);
                        }
                    }
                    property SketchConverter converter: SketchConverter { }
                    property SketchStaticsExporter staticsExporter: SketchStaticsExporter {
                        sketch: sketch }
                }
            }
        }
        ToolSeparator{}
        ToolButton{
            text:"Edit"
            onClicked: editMenu.open()
            Menu {
                id:editMenu
                title: "Edit"
                y:parent.height
                width: insert_menu_item.implicitWidth
                MenuItem {
                    text: "Undo"
                    enabled: Settings.canUndo
                    onTriggered: {
                        sketch.undo()
                    }
                }
                MenuItem {
                    text: "Redo"
                    enabled: Settings.canRedo
                    onTriggered: {
                        sketch.redo()
                    }
                }
                MenuSeparator {}
                MenuItem {
                    text: "Select"
                    onTriggered: {
                        sketchScreenLoader.item.changeTool("SelectTool", "select from key")
                    }
                }
                MenuItem {
                    id:insert_menu_item
                    text: "Insert"
                    onTriggered: {
                        sketchScreenLoader.item.changeTool("InsertTool", "insert from key")
                    }
                }
                MenuItem {
                    text: "Move"
                    onTriggered: {
                        sketchScreenLoader.item.changeTool("MoveTool", "move from key")
                    }
                }
                MenuItem {
                    text: "Delete"
                    onTriggered: {
                        sketchScreenLoader.item.changeTool("DeleteTool", "delete from key")
                    }
                }
            }
        }
        ToolSeparator{}
        ToolButton{
            text:"View"
            onClicked: textMenu.open()
            Menu {
                id:textMenu
                title: "View"
                y:parent.height
                width: display_background_menu_item.implicitWidth
                MenuItem {
                    id:display_background_menu_item
                    text: "Display background"
                    checkable: true
                    checked: sketch.isBackgroundSet()
                    onTriggered: {
                        sketch.enableBackground(this.checked)
                    }
                }
                MenuItem {
                    text: "Display grid"
                    checkable: true
                    checked: Settings.backgroundGridEnable
                    onTriggered: {
                        Settings.backgroundGridEnable = !Settings.backgroundGridEnable
                    }
                }
                MenuItem {
                    text: "Display help tip"
                    checkable: true
                    checked: Settings.helpTipEnable
                    onTriggered: {
                        Settings.helpTipEnable = !Settings.helpTipEnable
                    }
                }
                MenuItem {
                    text: "Display ruler"
                    checkable: true
                    checked: Settings.rulerEnable
                    onTriggered: {
                        Settings.rulerEnable = !Settings.rulerEnable
                    }
                }
            }
        }
        ToolSeparator{}
        ToolButton{
            text:"Old Stuff"
            onClicked: oldstuffMenu.open()
            Menu {
                id:oldstuffMenu
                title: "Old stuff"
                y:parent.height
                MenuItem {
                    text: "Login"
                    onTriggered: {
                        loginFormLoader.source = "qrc:/LoginForm.qml"
                        sketchScreenLoader.source = ""
                    }
                }

                MenuItem {
                    text: "Back to Welcome Screen"
                    onTriggered: {
                        welcomeScreenLoader.source = "qrc:/WelcomeScreen.qml"
                        sketchScreenLoader.source = ""
                    }
                }

                MenuItem {
                    text: "Set background"
                    onTriggered: {
                        if(QtMultimedia.availableCameras.length === 0) {
                            message.displayErrorMessage("No camera available");
                        }
                        else {
                            captureImageLoader.source = "qrc:/CaptureImage.qml"
                            sketchScreenLoader.source = ""
                        }
                    }
                }

                MenuItem {
                    text: "Apply constraints"
                    onTriggered: {
                        var solveResult = mouseArea.constraintsSolver.solve()
                        console.log("solveResult: ", solveResult);
                        if(solveResult === true) {
                            mouseArea.constraintsSolver.applyOnSketch();
                            message.displaySuccessMessage("Constraints application succeed")
                        }
                        else {
                            message.displayErrorMessage("Constraints application failed : " + solveResult)
                        }
                    }
                }
            }
        }
    }
}



