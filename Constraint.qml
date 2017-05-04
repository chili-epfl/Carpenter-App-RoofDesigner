import QtQuick 2.0

Item {
    readonly property string class_type: "Constraint"

    property bool existing: true

    property int type: -1
    property double valA: -1.0
    property var ptA: null
    property var ptB: null
    property var entityA: null
    property var entityB: null

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
                type=state.type
                valA=state.valA
                ptA=state.ptA
                ptB=state.ptB
                entityA=state.entityA
                entityB=state.entityB
                existing=state.existing
            }else
                existing=false
        }
    }

    function redo(){
        if(redo_buffer.length>0){
            var state=redo_buffer.pop()
            type=state.type
            valA=state.valA
            ptA=state.ptA
            ptB=state.ptB
            entityA=state.entityA
            entityB=state.entityB
            existing=state.existing
            undo_buffer.push(state)
        }
    }

    function store_state(epoch){
        if(undo_buffer.length!=epoch-1){
            for(var i=0;i<epoch-1;i++)
                undo_buffer.push({
                                     'type':-1,
                                     'valA':-1.0,
                                     'ptA':null,
                                     'ptB':null,
                                     'entityA':null,
                                     'entityB':null,
                                     'existing':false})
        }
        var state={
            'type':type,
            'valA':valA,
            'ptA':valA,
            'ptB':ptB,
            'entityA':entityA,
            'entityB':entityB,
            'existing':existing}
        undo_buffer.push(state)
        redo_buffer=[]
    }

    function kill(){
        existing=false
    }
}
