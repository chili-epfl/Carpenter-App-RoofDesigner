TEMPLATE = app

QT += qml quick multimedia 3dcore 3drender 3dinput 3dquick
CONFIG += c++11

SOURCES += main.cpp \
    sketch_converter.cpp \
    sketchmesh.cpp \
    sketchpoint.cpp \
    sketchline.cpp \
    sketchconstraintssolver.cpp \
    constrainedpoint.cpp \
    constrainedline.cpp \
    sketchjoint.cpp \
    solve.cpp \
    derivatives.cpp \
    parameter.cpp \
    displaykeyboard.cpp \
    sketchstaticsexporter.cpp \
    realtoexporter.cpp

HEADERS += sketch_converter.h \
    sketchmesh.h \
    sketchpoint.h \
    sketchline.h \
    sketchconstraintssolver.h \
    constrainedpoint.h \
    constrainedline.h \
    sketchjoint.h \
    solve.h \
    parameter.h \
    displaykeyboard.h \
    sketchstaticsexporter.h \
    globals.h \
    realtoexporter.h


RESOURCES += qml.qrc

# enable debug
DEFINES += CARPENTER_DEBUG
# enable using SketchPoint as joint component
#DEFINES += CARPENTER_USE_SKETCHPOINT
# enable using SketchJoint as joint component
DEFINES += CARPENTER_USE_SKETCHJOINT

LIBS += -lassimp
LIBS += -lquazip -lz

linux {
#    INCLUDEPATH += /usr/local/include/

    LIBS += -L/usr/local/lib/
}
android {

    INCLUDEPATH+= assimp/include/
    LIBS += -L$$_PRO_FILE_PWD_/assimp -lassimp
    ANDROID_EXTRA_LIBS = \
        $$_PRO_FILE_PWD_/assimp/libassimp.so \
        $$[QT_INSTALL_LIBS]/libquazip.so
}


# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

DISTFILES += \
    qmldir

#QMAKE_CC=/usr/local/Cellar/gcc/5.2.0/bin/g++-5
#QMAKE_CXX=/usr/local/Cellar/gcc/5.2.0/bin/g++-5
#QMAKE_LINK=/usr/local/Cellar/gcc/5.2.0/bin/g++-5
