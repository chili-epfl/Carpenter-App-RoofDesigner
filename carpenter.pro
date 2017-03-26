TEMPLATE = app

QT += qml quick multimedia 3dcore 3drender 3dinput 3dquick
CONFIG += c++11

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
    jsonsketch.cpp

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
    jsonsketch.h

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
    INCLUDEPATH+= /home/chili/android-ndk-r10d/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/user/include/
    LIBS += -L/home/chili/android-ndk-r10d/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/user/lib -lassimp
     ANDROID_EXTRA_LIBS = \
          /home/chili/android-ndk-r10d/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/user/lib/libassimp.so \
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

win32:CONFIG(release, debug|release): LIBS += -L$$PWD/assimp/lib/release/ -lassimp.3.3.1
else:win32:CONFIG(debug, debug|release): LIBS += -L$$PWD/assimp/lib/debug/ -lassimp.3.3.1
else:unix: LIBS += -L$$PWD/assimp/lib/ -lassimp.3.3.1

INCLUDEPATH += $$PWD/assimp
DEPENDPATH += $$PWD/assimp

win32:CONFIG(release, debug|release): LIBS += -L$$PWD/quazip/0.7.3/lib/release/ -lquazip.1.0.0
else:win32:CONFIG(debug, debug|release): LIBS += -L$$PWD/quazip/0.7.3/lib/debug/ -lquazip.1.0.0
else:unix: LIBS += -L$$PWD/quazip/0.7.3/lib/ -lquazip.1.0.0

INCLUDEPATH += $$PWD/quazip
DEPENDPATH += $$PWD/quazip
