import QtQuick 2.7
import QtQuick.Window 2.0
import Constraints 1.0

Item {
    width: 10000
    height: 10000
    anchors.fill:parent
    x:-(width-parent.width)/2
    y:-(height-parent.height)/2

    property real scaleFactor: Screen.pixelDensity

    property alias mouse_area: mouse_area
    property alias pinch_area: pinch_area

    property alias constraints: constraints
    property alias constraintsList: constraints.list

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

    Constraints {
        id: constraints

        property var constraint_component

        Component.onCompleted:  {
            constraint_component = Qt.createComponent("Constraint.qml");
        }

        property ListModel list: ListModel {}

        function add(){
            if (constraintsPanel.horz_const.checked) {
                for(var e = 0; e < constraintsPanel.listEntities.count; e++){
                    var c = constraint_component.createObject(sketch)
                    c.type = 0
                    c.entityA = constraintsPanel.listEntities.get(e).object
                }
            }
            if (constraintsPanel.vert_const.checked) {
                for(var e = 0; e < constraintsPanel.listEntities.count; e++){
                    var c = constraint_component.createObject(sketch)
                    c.type = 1
                    c.entityA = constraintsPanel.listEntities.get(e).object
                }
            }
            if (constraintsPanel.leng_const.checked) {
                for(var e = 0; e < constraintsPanel.listEntities.count; e++){
                    var c = constraint_component.createObject(sketch)
                    c.type = 2
                    c.valA = 0 //TODO
                    c.entityA = constraintsPanel.listEntities.get(e).object
                }
            }
            if (constraintsPanel.equL_const.checked) {
                for(var e = 1; e < constraintsPanel.listEntities.count; e++){
                    var c = constraint_component.createObject(sketch)
                    c.type = 3
                    c.entityA = constraintsPanel.listEntities.get(0).object
                    c.entityB = constraintsPanel.listEntities.get(e).object
                }
            }
            if (constraintsPanel.dist_const.checked) {
                var c = constraint_component.createObject(sketch).object
                c.type = 4
                c.valA = 0 //TODO
                c.ptA = constraintsPanel.listEntities.get(0).object
                c.ptB = constraintsPanel.listEntities.get(1).object
            }
            if (constraintsPanel.para_const.checked) {
                for(var e = 1; e < constraintsPanel.listEntities.count; e++){
                    var c = constraint_component.createObject(sketch)
                    c.type = 5
                    c.entityA = constraintsPanel.listEntities.get(0).object
                    c.entityB = constraintsPanel.listEntities.get(e).object
                }
            }
            if (constraintsPanel.perp_const.checked) {
                var c = constraint_component.createObject(sketch)
                c.type = 6
                c.entityA = constraintsPanel.listEntities.get(0).object
                c.entityB = constraintsPanel.listEntities.get(1).object
            }
            if (constraintsPanel.angl_const.checked) {
                var c = constraint_component.createObject(sketch)
                c.type = 7
                c.valA = 0 //TODO
                c.entityA = constraintsPanel.listEntities.get(2).object
                c.entityB = constraintsPanel.listEntities.get(1).object
            }
            if (constraintsPanel.midP_const.checked) {
                pId = constraintsPanel.listEntities.get(0).object.class_type == "Point" ? 0 : 1
                var c = constraint_component.createObject(sketch)
                c.type = 8
                c.ptA = constraintsPanel.listEntities.get(pId).object
                c.entityA = constraintsPanel.listEntities.get(1 - pId).object
            }
        }
    }
}
