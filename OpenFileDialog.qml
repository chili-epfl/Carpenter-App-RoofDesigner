import QtQuick 2.0
import QtQuick.Dialogs 1.0

FileDialog {
    id: openFileDialog
    title: "Please choose a file"
    folder: shortcuts.home
    nameFilters: [ "Carpenter files (*.obj)" ]

    onAccepted: {
        console.log("You chose: " + fileDialog.fileUrls)
        viewer3dLoader.active=true;
        viewer3dLoader.meshSource = fileURL
    }
    onRejected: {
        console.log("Canceled")
    }
    Component.onCompleted: visible = true

}
