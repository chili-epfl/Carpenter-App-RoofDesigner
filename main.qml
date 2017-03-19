import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import QtMultimedia 5.5

import "." // to import Settings

ApplicationWindow {
    visible: true
    width: Settings.appWidth
    height: Settings.appHeight
    visibility: "Maximized"

    FontLoader{
        name: "FontAwesome";
        source: "qrc:/fonts/FontAwesome.otf"
    }

    StackView{
        id:stack_view
        anchors.fill: parent
        initialItem: "qrc:/SplashScreen.qml"
    }

}

