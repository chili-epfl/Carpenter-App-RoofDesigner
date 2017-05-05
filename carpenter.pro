TEMPLATE = app

QT += qml quick multimedia 3dcore 3drender 3dinput 3dquick
CONFIG += c++11

ASSIMP_DIR=/home/chili/test/assimp

SOLVESPACE_DIR=/home/chili/test/solvespace

SOURCES += constrainedline.cpp \
    constrainedpoint.cpp \
    derivatives.cpp \
    displaykeyboard.cpp \
    main.cpp \
    realtoexporter.cpp \
    parameter.cpp \
    sketch_converter.cpp \
    sketchconstraintssolver.cpp \
    sketchjoint.cpp \
    sketchline.cpp \
    sketchmesh.cpp \
    sketchpoint.cpp \
    sketchstaticsexporter.cpp \
    solve.cpp \
    jsonsketch.cpp \
    constraints.cpp

HEADERS += constrainedline.h \
    constrainedpoint.h \
    displaykeyboard.h \
    globals.h \
    parameter.h \
    realtoexporter.h \
    sketch_converter.h \
    sketchconstraintssolver.h \
    sketchjoint.h \
    sketchline.h \
    sketchmesh.h \
    sketchpoint.h \
    sketchstaticsexporter.h \
    solve.h \
    jsonsketch.h \
    constraints.h

RESOURCES += qml.qrc

# enable debug
DEFINES += CARPENTER_DEBUG
# enable using SketchPoint as joint component
#DEFINES += CARPENTER_USE_SKETCHPOINT
# enable using SketchJoint as joint component
DEFINES += CARPENTER_USE_SKETCHJOINT

LIBS += -lassimp -lquazip -lz -lslvs

INCLUDEPATH += $$SOLVESPACE_DIR/include/

unix {
    INCLUDEPATH += $$ASSIMP_DIR/build-unix/install/include/
    LIBS += -L/usr/local/lib/
    LIBS += -L$$ASSIMP_DIR/build-unix/install/lib
    LIBS += -L$$SOLVESPACE_DIR/build-unix/src

}

android {
    INCLUDEPATH += $$ASSIMP_DIR/build-android/install/include/

    LIBS += -L$$ASSIMP_DIR/build-android/install/lib
    LIBS += -L$$SOLVESPACE_DIR/build-android/src

    ANDROID_EXTRA_LIBS = \
           $$ASSIMP_DIR/build-android/install/lib/libassimp.so \
           $$SOLVESPACE_DIR/build-android/src/libslvs.so \
           $$[QT_INSTALL_LIBS]/libquazip.so
}

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)
