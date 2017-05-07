import QtQuick 2.0

Item{
    property var current_target:undefined

    function onPressed(target,mouse){
        if(target.class_type=="Point"){
            target.mouse_area.drag.target=target
            current_target=target
        }
    }

    function abort(){
        if(current_target!==undefined){
            current_target.mouse_area.drag.target=undefined
        }
        current_target=undefined
    }

    function onReleased(target,mouse){
        if(target.class_type=="Point"){
            var p=target.mouse_area.drag.target
            for(var i=0;i<sketch.children.length;i++){
                if(p!==sketch.children[i] && sketch.children[i].class_type=="Point"
                        && Math.abs((p.x-sketch.children[i].x))<10 &&
                        Math.abs((p.y-sketch.children[i].y))<10){
                    p.replaceMe(sketch.children[i])
                    break;
                }
            }
            target.mouse_area.drag.target=undefined;
            sketch.store_state(sketch.undo_buffer.length+1);
        }
        current_target=undefined
    }

    function onClicked(target,mouse){

    }

    Connections{
        Binding on target{
            when:current_target!==undefined
            value: current_target
        }
        ignoreUnknownSignals: true
        onXChanged:apply_constraint_timer.start()
        onYChanged:apply_constraint_timer.start()
    }
    Timer{
        id:apply_constraint_timer
        interval: 100
        running: false
        onTriggered: sketch.constraints.apply(sketch)
    }

}
