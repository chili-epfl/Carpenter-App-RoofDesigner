import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import QtMultimedia 5.5
import QtQuick.Window 2.0

import "." // to import Settings

ApplicationWindow {
    visible: true
    width: Settings.appWidth
    height: Settings.appHeight

    property real scalePixelFactor:Math.min( (1/110)*width/Screen.pixelDensity,
                                             (1/65)*height/Screen.pixelDensity)
    visibility: "Maximized"

    FontLoader{
        name: "FontAwesome";
        source: "qrc:/fonts/FontAwesome.otf"
    }
    FontLoader{
        name: "Code2000";
        source: "qrc:/fonts/CODE2000.TTF"
    }
    StackView{
        id:stack_view
        anchors.fill: parent
        initialItem: "qrc:/SplashScreen.qml"
    }

}

