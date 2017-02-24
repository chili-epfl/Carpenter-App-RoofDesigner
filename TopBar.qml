import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import QtMultimedia 5.5
import QtQuick.Controls.Styles 1.4
import "." // to import Settings
import QtQuick.Window 2.0
Rectangle {
    id: menuBar
    color: "transparent"
    height:100
    width: parent.width

    RowLayout {
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        anchors.fill: parent

        Button {
            id: menuButton
            anchors.left: parent.left
            anchors.margins: 10
            width: 100
            text: "Menu"
            style: RoundedButton {
                icon: "\uf060";
            }
            onClicked: {
                welcomeScreenLoader.source = "qrc:/WelcomeScreen.qml"
                sketchScreenLoader.source = ""
            }
        }

        Item {
            width: 10
        }

        Label {
            Layout.fillWidth: true
            Layout.minimumWidth: 100
            text: "Sketch"
            color: Settings.topBarLabelColor
            font.pointSize: 18
        }

        Button {
            id: setBackgroundButton
            anchors.right: applyConstraintsButton.left
            anchors.margins: 10
            width: 100
            text: "Set background"
            style: RoundedButton {
                icon: "\uf030"
            }

            onClicked: {
                if(QtMultimedia.availableCameras.length === 0) {
                    message.displayErrorMessage("No camera available");
                }
                else {
                    mainForm.displayCameraPanel()
                }
            }
        }

        Button {
            id: applyConstraintsButton
            anchors.right: exportButton.left
            anchors.margins: 10
            width: 100
            text:"Apply constraints"
            style: RoundedButton {
                icon: "\uf021"
            }

            onClicked: {
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

        Button {
            id: exportButton
            anchors.right: parent.right
            anchors.margins: 10
            width: 100
            text:"Export"
            style: RoundedButton {
                icon: "\uf1b2"
            }

            onClicked: {
                var basename=new Date().toLocaleString(Qt.locale(),"dMyyhms");

                var staticsExportResult = mouseArea.staticsExporter.exportToFile(basename,Settings.captureImagePath,Qt.size(mainForm.width,mainForm.height));
                console.log("staticsExportResult", staticsExportResult);

                var exportResult = mouseArea.converter.exportToFile(sketch, basename);
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
        }
    }
}



