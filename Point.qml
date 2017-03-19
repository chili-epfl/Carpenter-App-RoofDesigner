import QtQuick 2.0

Rectangle {

    width: 25
    height: 25
    radius: width/2
    color: "red"
    z:1
    visible: existing

    property bool existing: true

    readonly property string class_type: "Point"
    property alias mouse_area:mouse_area

    property var undo_buffer:[]
    property var redo_buffer:[]

    Connections{
        ignoreUnknownSignals: false
        target: parent
        onStore_state: store_state(epoch)
        onUndo: undo()
        onRedo: redo()

    }
    function undo(){
        if(undo_buffer.length>0){
            redo_buffer.push(undo_buffer.pop())
            if(undo_buffer.length>0){
                var state=undo_buffer[undo_buffer.length-1]
                x=state.x
                y=state.y
                existing=state.existing
            }
            else
                existing=false;
        }
    }
    function redo(){
        if(redo_buffer.length>0){
            var state=redo_buffer.pop()
            x=state.x
            y=state.y
            existing=state.existing
            undo_buffer.push(state)
        }
    }
    function store_state(epoch){
        if(undo_buffer.length!=epoch-1){
            for(var i=0;i<epoch-1;i++)
                undo_buffer.push({'x':0,'y':0,'existing':false})
        }
        var state={'x':x,'y':y,'existing':existing}
        undo_buffer.push(state)
        redo_buffer=[]
    }

    signal replaceMe(var replacement);
    onReplaceMe: kill()

    function kill(){
        existing=false
    }
    function showContextMenu(x,y){
        context_menu.x=x
        context_menu.y=y
        context_menu.visible=true
    }


    MouseArea{
        id:mouse_area
        drag.smoothed: false
        anchors.fill: parent
        onPressed: {current_tool.onPressed(parent,mouse);}
        onReleased: {current_tool.onReleased(parent,mouse);}
        onClicked: {current_tool.onClicked(parent,mouse);}
    }

    PointContextMenu{
        id:context_menu
    }

}


