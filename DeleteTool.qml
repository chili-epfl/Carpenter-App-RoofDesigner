import QtQuick 2.0

QtObject{


    function onPressed(target,mouse){

    }

    function onReleased(target,mouse){

    }
    function onClicked(target,mouse){
        if(target.class_type=="Point" || target.class_type=="Line"){
                target.kill();
                sketch.store_state(sketch.undo_buffer.length+1);
        }
    }



}
