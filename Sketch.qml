import QtQuick 2.7
import QtQuick.Window 2.0

Item {
    width: 10000
    height: 10000
    anchors.fill:parent
    x:-(width-parent.width)/2
    y:-(height-parent.height)/2

    property real scaleFactor: Screen.pixelDensity

    property alias mouse_area: mouse_area
    property alias pinch_area: pinch_area

    readonly property string class_type: "Sketch"

    property var undo_buffer: []
    property var redo_buffer: []

    signal undo()
    signal redo()

    onUndo: {
        if(undo_buffer.length>0){
            redo_buffer.push(undo_buffer.pop())
            if(undo_buffer.length>0){

            }else{

            }
        }
    }

    onRedo: {
        if(redo_buffer.length>0){
            var state=redo_buffer.pop()
            undo_buffer.push(state)
        }
    }

    signal store_state(var epoch)
    onStore_state: {
        var state={}
        undo_buffer.push(state)
        redo_buffer=[]
    }

    PinchArea{
        id:pinch_area
        anchors.fill: parent
        enabled: false
        onPinchUpdated: {
            if(pinch.scale>0)
                ( parent.scale=Math.max(0.25, parent.scale*(pinch.scale/pinch.previousScale) ) )
        }
    }

    MouseArea{
        id:mouse_area
        anchors.fill: parent
        drag.smoothed: false
        scrollGestureEnabled:false
        onPressed: {
            current_tool.onPressed(parent,mouse);
        }
        onReleased: {current_tool.onReleased(parent,mouse);}
        onClicked: {current_tool.onClicked(parent,mouse);}
        onWheel: {
           parent.x=wheel.x-parent.width/2
            if(wheel.angleDelta.y>0)
                parent.scale=Math.max(0.25, parent.scale*(1.25*wheel.angleDelta.y/120))
            else if(wheel.angleDelta.y<0)
                parent.scale=Math.max(0.25, -parent.scale*(0.75*wheel.angleDelta.y/120))
        }
    }
}
