import QtQuick 2.7

QtObject{
    property var current_target:undefined;

    function onPressed(target,mouse){
        if(target.class_type=="Sketch" ){
            target.pinch_area.pinch.target=target
            target.mouse_area.drag.target=target
            current_target=target;
        }
    }

    function onReleased(target,mouse){
        if(target.class_type=="Sketch" ){
            target.pinch_area.pinch.target=undefined
            target.mouse_area.drag.target=undefined
            current_target=undefined;
        }
    }

    function abort(){
        if(current_target!==undefined){
            current_target.pinch_area.pinch.target=undefined
            current_target.mouse_area.drag.target=undefined
        }
        current_target=undefined
    }

    function onClicked(target,mouse){
        if(target.class_type=="Point" || target.class_type=="Line"){
            target.showContextMenu(mouse.x,mouse.y)
            var data = {"object": target}
            var removed = false
            for(var i = 0; i < constraintsPanel.listEntities.count; i++){
                if (constraintsPanel.listEntities.get(i).object == target){
                    constraintsPanel.listEntities.remove(i)
                    removed = true
                    break
                }
            }
            if (!removed){
                constraintsPanel.listEntities.append(data)
            }
            constraintsVisibility()
        }
    }

    function constraintsVisibility(){
        var pointCount = 0
        var lineCount = 0
        for(var i = 0; i < constraintsPanel.listEntities.count; i++){
            switch (constraintsPanel.listEntities.get(i).object.class_type){
            case "Point":
                pointCount++
                break
            case "Line":
                lineCount++
                break
            default:
                break
            }
        }
        if (pointCount == 0 && lineCount > 0){
            constraintsPanel.horz_const.visible = true
            constraintsPanel.vert_const.visible = true
            constraintsPanel.leng_const.visible = true
            constraintsPanel.dist_const.visible = false
            if (lineCount > 1) {
                constraintsPanel.equL_const.visible = true
                constraintsPanel.para_const.visible = true
                if (lineCount == 2){
                    constraintsPanel.perp_const.visible = true
                    constraintsPanel.angl_const.visible = true
                } else {
                    constraintsPanel.perp_const.visible = false
                    constraintsPanel.angl_const.visible = false
                }
            } else {
                constraintsPanel.equL_const.visible = false
                constraintsPanel.para_const.visible = false
                constraintsPanel.perp_const.visible = false
                constraintsPanel.angl_const.visible = false
            }
            constraintsPanel.midP_const.visible = false
            constraintsPanel.no_const.visible = false
        } else if (pointCount == 1 && lineCount == 1){
            constraintsPanel.horz_const.visible = false
            constraintsPanel.vert_const.visible = false
            constraintsPanel.leng_const.visible = false
            constraintsPanel.equL_const.visible = false
            constraintsPanel.dist_const.visible = false
            constraintsPanel.para_const.visible = false
            constraintsPanel.perp_const.visible = false
            constraintsPanel.angl_const.visible = false
            constraintsPanel.midP_const.visible = true
            constraintsPanel.no_const.visible = false
        }  else if (pointCount == 2 && lineCount == 0){
            constraintsPanel.horz_const.visible = false
            constraintsPanel.vert_const.visible = false
            constraintsPanel.leng_const.visible = false
            constraintsPanel.equL_const.visible = false
            constraintsPanel.dist_const.visible = true
            constraintsPanel.para_const.visible = false
            constraintsPanel.perp_const.visible = false
            constraintsPanel.angl_const.visible = false
            constraintsPanel.no_const.visible = false
        } else {
            constraintsPanel.horz_const.visible = false
            constraintsPanel.vert_const.visible = false
            constraintsPanel.leng_const.visible = false
            constraintsPanel.equL_const.visible = false
            constraintsPanel.dist_const.visible = false
            constraintsPanel.para_const.visible = false
            constraintsPanel.perp_const.visible = false
            constraintsPanel.angl_const.visible = false
            constraintsPanel.midP_const.visible = false
            constraintsPanel.no_const.visible = true
        }
    }
}
