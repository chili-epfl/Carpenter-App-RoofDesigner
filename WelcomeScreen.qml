import QtQuick 2.7
import QtQuick.Controls 2.1

Page {
    id:welcome_page

    Rectangle{
        anchors.fill: parent
        color:"lightgrey"

    }
    ListView{
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: welcome_page.availableHeight/3
        anchors.bottomMargin: welcome_page.availableHeight/3
        anchors.fill:parent
        clip: true
        orientation: ListView.Horizontal
        model:ListModel{
            ListElement{
                picture_url:"qrc:/icons/icons/plus-1270001_1280.png"
                sketch_file:"jsontest"
            }
        }
        delegate:Rectangle{
            width: height*4/3
            height: welcome_page.availableHeight/3
            border.color: "black"
            border.width: 3
            Image{
                anchors.fill: parent
                anchors.margins: 10
                fillMode: Image.PreserveAspectFit
                source:picture_url
            }
            MouseArea{
                anchors.fill: parent
                onDoubleClicked: {
                    loading_indicator.visible=true;
                    stack_view.push("qrc:/SketchScreen.qml",{"sketch_file":sketch_file});
                }
            }
        }
        BusyIndicator {
            id:loading_indicator
            visible:false
            Timer{
                interval: 2000
                repeat: false
                running: loading_indicator.visible
                onTriggered: loading_indicator.visible=false
            }
            anchors.centerIn: parent
            running: true

        }

    }
}
