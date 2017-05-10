import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Window 2.0
import JSONSketch 1.0
import "." // to import Settings

Page {
    id: sketchScreen

    JSONSketch {
        id: json_sketch
    }

    property string sketch_to_load

    Component.onCompleted: {
        if(sketch_to_load.length>0){
            console.log(json_sketch.loadSketch(Settings.exportPath + sketch_to_load+ ".json", sketch))
            top_menu_bar.sketch_name=sketch_to_load;
            sketch.store_state(sketch.undo_buffer.length+1);
        }
    }

    property alias aux_loader: aux_loader

    property alias constraintsPanel: constraintsPanel

    property bool isBackgroundSet: (background_picture_url!="")
    property alias visibleBackground: backgroundImage.visible
    property url background_picture_url: ""

    property alias visibleGrid: backgroundgrid.visible

    property string toolName: "SelectTool"
    property var current_tool: toolName == "SelectTool" ? select_tool :
                                                          toolName == "InsertTool" ? insert_tool :
                                                                                     toolName == "MoveTool"? move_tool : delete_tool

    property alias sketch: sketch

    header: TopMenuBar{
        id:top_menu_bar
        height: Screen.pixelDensity*5*scalePixelFactor
        visible: aux_loader.status!=Loader.Ready
    }

    footer: BottomToolBar{
        height: Screen.pixelDensity*5*scalePixelFactor
        visible: aux_loader.status!=Loader.Ready
    }

    Image {
        id: backgroundImage
        mipmap: true
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: background_picture_url
        transform:  Scale{
            origin.x:sketch.zoom_origin_x
            origin.y:sketch.zoom_origin_y
            xScale: sketch.zoomFactor
            yScale: sketch.zoomFactor
        }

    }

    Image {
        id: backgroundgrid
        anchors.fill: parent
        fillMode: Image.Tile
        opacity: 0.42
        source: "pictures/background_grid.png"
        transform:  Scale{
            origin.x:sketch.zoom_origin_x
            origin.y:sketch.zoom_origin_y
            xScale: sketch.zoomFactor
            yScale: sketch.zoomFactor
        }
        mipmap: true
    }

    Sketch{
        id:sketch
//        mouse_area.enabled: Qt.platform.os=="android"? current_tool!==select_tool : true
//        pinch_area.enabled: Qt.platform.os=="android" ? current_tool===select_tool : false

    }


    ToolsMenu {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.margins: 10
    }

    ConstraintsPanel {
        id: constraintsPanel
        visible: current_tool===select_tool
        x:parent.width-(width+10)
        y:parent.height/2-height/2
        height: parent.height-10
        width: Screen.pixelDensity*50
    }

    Loader{
        id:aux_loader
        anchors.fill: parent

    }

    SelectTool{
        id:select_tool
    }

    InsertTool{
        id:insert_tool
    }
    MoveTool{
        id:move_tool
    }
    DeleteTool{
        id:delete_tool
    }



}
