import QtQuick 2.7

QtObject{
    function onPressed(target,mouse){
        if(target.class_type=="Sketch" ){
            target.pinch_area.pinch.target=target
            target.mouse_area.drag.target=target
        }
    }

    function onReleased(target,mouse){
        if(target.class_type=="Sketch" ){
            target.pinch_area.pinch.target=undefined
            target.mouse_area.drag.target=undefined
        }
    }

    function onClicked(target,mouse){
        if(target.class_type=="Point" || target.class_type=="Line"){
            target.showContextMenu(mouse.x,mouse.y);
        }
    }

}