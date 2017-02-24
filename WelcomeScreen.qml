import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtMultimedia 5.5
import QtGraphicalEffects 1.0
import Qt.labs.folderlistmodel 2.1


Rectangle {
    function dp2px(dp){
        return  dp * (0.15875 *Screen.pixelDensity)
    }
    id: welcomeScreen
    anchors.fill: parent

    SplitView {
        anchors.fill: parent

        Rectangle {
            id: newSketchButton
            color: "#CCCCCC"
            width: parent.width / 2
            height: parent.height
            Label {
                text: "Create a new sketch"
                //font.family: "Avenir LT Std 65 Medium"
                font.pointSize: 25
                anchors.centerIn: parent
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    sketchScreenLoader.source = "qrc:/SketchScreen.qml"
                    welcomeScreenLoader.source = ""
                }
            }
            Image{
                source: "qrc:/icons/icons/realto_logo.png";
                width: dp2px(100)
                height: width
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.margins: dp2px(16)
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        loginFormLoader.source = "qrc:/LoginForm.qml"
                        welcomeScreenLoader.source = ""
                    }
                }
            }
        }

        ColumnLayout {
            id: fileColumn
            Layout.fillHeight: true


            width: parent.width / 2
            Rectangle {
                color: "transparent"
                height: childrenRect.height + 40
                Layout.fillWidth: true
                Label {
                    y:20
                    x: 20
                    Layout.fillWidth: true
                    text: "Browse models"
                    //font.family: "Avenir LT Std 65 Medium"
                    font.pointSize: 16
                }
            }
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                ListView {
                    id: fileList
                    property var colors: ["#f2fbff", "transparent"]
                    width: fileColumn.width


                    model: FolderListModel {
                        id:folderModel
                        nameFilters: ["*.obj"]
                        showDirs: true
                        showDotAndDotDot: true
                        showOnlyReadable: true
                        folder: scenariosPath
                    }
                    delegate: Column {
                        Rectangle {
                            color: fileList.colors[index % 2]
                            width: fileColumn.width
                            height: 100
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                x: 20
                                text: fileName == ".." ? "Previous directory" : fileName
                                horizontalAlignment: Qt.AlignLeft
                                font.pointSize: 14
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if(fileIsDir)
                                        folderModel.folder=fileURL
                                    else{
                                        viewer3dLoader.active=true;
                                        viewer3dLoader.meshSource = fileURL
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

