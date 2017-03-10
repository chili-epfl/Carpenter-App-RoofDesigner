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

import "qrc:/lib/lib/lodash.js" as Lodash
import SketchConstraintsSolver 1.0
import DisplayKeyboard 1.0
import RealtoExporter 1.0

Rectangle {
    id: sketchScreen

    anchors.fill: parent

    property alias sketch: sketch;

    states: [
        State {
            name: "SelectTool"
            PropertyChanges {
                target: mouseArea
                onPressed: { mouseArea.selectTool.onPressed() }
                onPositionChanged: { mouseArea.selectTool.onPositionChanged() }
                onReleased: { mouseArea.selectTool.onReleased() }
            }
        },
        State {
            name: "InsertTool"
            PropertyChanges {
                target: mouseArea
                onPressed: { console.log('pressed', mouseArea.insertTool.onPressed); mouseArea.insertTool.onPressed() }
                onPositionChanged: { mouseArea.insertTool.onPositionChanged() }
                onReleased: { mouseArea.insertTool.onReleased() }
            }
        },
        State {
            name: "MoveTool"
            PropertyChanges {
                target: mouseArea
                onPressed: { mouseArea.moveTool.onPressed() }
                onPositionChanged: { mouseArea.moveTool.onPositionChanged() }
                onReleased: { mouseArea.moveTool.onReleased() }
            }
        },
        State {
            name: "DeleteTool"
            PropertyChanges {
                target: mouseArea
                onPressed: { mouseArea.deleteTool.onPressed() }
                onPositionChanged: { mouseArea.deleteTool.onPositionChanged() }
                onReleased: { mouseArea.deleteTool.onReleased() }
            }
        }
    ]
    state: Settings.defaultTool
    property string previousTool: ""
    property string currentTool: state;

    property var _;
    Component.onCompleted: {
        this._ = Lodash.lodash(this);
    }

    function toolItem(name) {
        return name.charAt(0).toLowerCase() + name.slice(1);
    }

    function changeTool(newTool, name) {
        if(newTool !== currentTool) {
            previousTool = currentTool;
            mouseArea[toolItem(previousTool)].onLeaveTool();
            mouseArea[toolItem(newTool)].onEnterTool();

            // Could be used if you want a message on every tool changes
            // message.displayInfoMessage("Selected tool: " + name);

            currentTool = newTool
            console.log("change tool: " + name)
        }
    }

    /*function hideCameraPanel() {
        mouseArea.enabled = true
        captureImagePanel.visible = false
    }*/

    onCurrentToolChanged: {
        state = currentTool;
    }

    Image {
        id: backgroundImage
        anchors.fill: parent
        fillMode: Settings.backgroundFillMode
        source: sketch.isBackgroundSet() ? sketch.getBackground() : ""
    }

    Image {
        id: backgroundgrid
        anchors.fill: parent
        fillMode: Image.Tile
        opacity: 0.42
        source: Settings.backgroundGridEnable? "pictures/background_grid.png" : ""
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        property var points: Object.create(Object.prototype)
        property var lines: Object.create(Object.prototype)

        property var sketch : Sketch {
            id:sketch
            anchors.fill: parent
        }

        property var insertPoint : Qt.createComponent("InsertPoint.qml");
        property var intermediatePoint : Qt.createComponent("IntermediatePoint.qml");
        property var lineUiComponent : Qt.createComponent("LineUi.qml");
        property var insertLineComponent : Qt.createComponent("InsertLine.qml");

        property SketchConstraintsSolver constraintsSolver: SketchConstraintsSolver { sketch: sketch }

        function createPointUi(point, identifier) {
            // todo move ui components outside of sketch class
            var newPoint = sketch.components.insertPoint.createObject(parent, { 'start': point, 'identifier': identifier })
            return newPoint
        }

        function createLineUi(line) {
            // todo move ui components outside of sketch class
            var startPoint =  mouseArea.points[line.startPoint.identifier]
            var endPoint =  mouseArea.points[line.endPoint.identifier]

            var properties = { 'startPoint':startPoint, 'endPoint': endPoint, 'identifier': line.identifier }
            var newLine = sketch.components.lineUi.createObject(parent, properties)
            return newLine
        }

        function getMousePosition() {
            return Qt.vector2d(mouseX, mouseY);
        }

        property var selectTool: new SelectTool.SelectTool(mouseArea);
        property var insertTool: new InsertTool.InsertTool(mouseArea);
        property var moveTool: new MoveTool.MoveTool(mouseArea);
        property var deleteTool: new DeleteTool.DeleteTool(mouseArea);

        property PointContextMenu pointContextMenu: pointContextMenu;
        property LineContextMenu lineContextMenu: lineContextMenu;

        property ToolsMenu toolsMenu: toolsMenu;

        onClicked: {
            message.hideMessage()
        }
    }

    Label {
        id: helpTip
        text: "First, you should set the scale by selecting an item, and defines its length"
        visible: Settings.helpTipEnable
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 10
    }

    Ruler {
        id: ruler
    }

    ToolsMenu{
        id: toolsMenu
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.verticalCenter: parent.verticalCenter
    }

    LineContextMenu {
        id: lineContextMenu
    }

    PointContextMenu {
        id: pointContextMenu
    }
}
