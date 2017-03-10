import QtQuick 2.0
import QtQuick.Dialogs 1.0

import SketchStaticsExporter 1.0
import "."

FileDialog {
    id: saveFileDialog
    title: "Please browse a folder"
    folder: shortcuts.desktop
    selectFolder: true

    property var sketchScreenLoader
    property var sketch: sketchScreenLoader.item.sketch

    onAccepted: {
        console.log("currently saving...")
        var basename=new Date().toLocaleString(Qt.locale(),"dMyyhms");

        var staticsSaveResult = staticsExporter.saveFile(basename, Settings.defaultCaptureImagePath, Qt.size(mainForm.width,mainForm.height), fileUrl);
        console.log("staticsSaveResult", staticsSaveResult);

        if(staticsSaveResult !== true) {
            message.displayErrorMessage("Text file save failed: " + staticsSaveResult)
        } else {
            message.displaySuccessMessage("save succeed")
            console.log("You've saved the sketch in: " + saveFileDialog.fileUrl)
        }

    }

    property SketchStaticsExporter staticsExporter: SketchStaticsExporter {
        sketch: sketchScreenLoader.item.sketch }

    onRejected: {
        console.log("Save canceled")
    }

    Component.onCompleted: visible = true

}
