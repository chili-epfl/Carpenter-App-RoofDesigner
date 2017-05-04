import QtQuick 2.0

QtObject{
    function onPressed(target,mouse){
        if(target.class_type=="Point"){
            target.mouse_area.drag.target=target
        }
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

    }

    function onClicked(target,mouse){

    }




}
