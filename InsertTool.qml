import QtQuick 2.0

Item{
    property var point_component
    property var line_component

    Component.onCompleted:  {
        line_component = Qt.createComponent("Line.qml");
        point_component = Qt.createComponent("Point.qml");
    }

    property var unfinished_p1: undefined
    property var unfinished_p2: undefined
    property var unfinished_line: undefined

    function abort(){
        if(unfinished_p1!==undefined)
            unfinished_p1.destroy()
        if(unfinished_p2!==undefined)
            unfinished_p2.destroy()
        if(unfinished_line!==undefined)
            unfinished_line.destroy()

        unfinished_p1= undefined
        unfinished_p2= undefined
        unfinished_line= undefined

    }

    function onPressed(target,mouse){
        var p1;
        if(target.class_type=="Sketch"){
            p1=point_component.createObject(sketch)
            p1.x=mouse.x-p1.width/2
            p1.y=mouse.y-p1.width/2
            unfinished_p1=p1
        }
        else if(target.class_type=="Point"){
            p1=target
        }
        var p2=point_component.createObject(sketch)
        var pos=target.mapToItem(sketch,mouse.x,mouse.y)
        p2.x=pos.x-p2.width/2
        p2.y=pos.y-p2.width/2
        target.mouse_area.drag.target=p2
        var line=line_component.createObject(sketch)
        line.p1=p1
        line.p2=p2
        unfinished_p2=p2
        unfinished_line=line

    }

    function onReleased(target,mouse){
        var p2=target.mouse_area.drag.target
        for(var i=0;i<sketch.children.length;i++){
            if(p2!==sketch.children[i] && sketch.children[i].class_type=="Point"
                    && Math.abs((p2.x-sketch.children[i].x))<10 &&
                       Math.abs((p2.y-sketch.children[i].y))<10){
                p2.replaceMe(sketch.children[i])
                break;
            }
        }
        target.mouse_area.drag.target=undefined;
        sketch.store_state(sketch.undo_buffer.length+1);
        unfinished_p1= undefined
        unfinished_p2= undefined
        unfinished_line= undefined
    }

    function onClicked(target,mouse){


    }



}
