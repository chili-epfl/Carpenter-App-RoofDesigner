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
    jsonsketch.cpp \
    constraints.cpp \
    quazip/JlCompress.cpp \
    quazip/qioapi.cpp \
    quazip/quaadler32.cpp \
    quazip/quacrc32.cpp \
    quazip/quagzipfile.cpp \
    quazip/quaziodevice.cpp \
    quazip/quazip.cpp \
    quazip/quazipdir.cpp \
    quazip/quazipfile.cpp \
    quazip/quazipfileinfo.cpp \
    quazip/quazipnewinfo.cpp \
    quazip/unzip.c \
    quazip/zip.c \

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
    constraints.h \
    assimp/Compiler/poppack1.h \
    assimp/Compiler/pstdint.h \
    assimp/Compiler/pushpack1.h \
    assimp/port/AndroidJNI/AndroidJNIIOSystem.h \
    assimp/ai_assert.h \
    assimp/anim.h \
    assimp/camera.h \
    assimp/cexport.h \
    assimp/cfileio.h \
    assimp/cimport.h \
    assimp/color4.h \
    assimp/config.h \
    assimp/DefaultLogger.hpp \
    assimp/defs.h \
    assimp/Exporter.hpp \
    assimp/Importer.hpp \
    assimp/importerdesc.h \
    assimp/IOStream.hpp \
    assimp/IOSystem.hpp \
    assimp/light.h \
    assimp/Logger.hpp \
    assimp/LogStream.hpp \
    assimp/material.h \
    assimp/matrix3x3.h \
    assimp/matrix4x4.h \
    assimp/mesh.h \
    assimp/metadata.h \
    assimp/NullLogger.hpp \
    assimp/postprocess.h \
    assimp/ProgressHandler.hpp \
    assimp/quaternion.h \
    assimp/scene.h \
    assimp/texture.h \
    assimp/types.h \
    assimp/vector2.h \
    assimp/vector3.h \
    assimp/version.h \
    quazip/0.7.3/include/quazip/crypt.h \
    quazip/0.7.3/include/quazip/ioapi.h \
    quazip/0.7.3/include/quazip/JlCompress.h \
    quazip/0.7.3/include/quazip/quaadler32.h \
    quazip/0.7.3/include/quazip/quachecksum32.h \
    quazip/0.7.3/include/quazip/quacrc32.h \
    quazip/0.7.3/include/quazip/quagzipfile.h \
    quazip/0.7.3/include/quazip/quaziodevice.h \
    quazip/0.7.3/include/quazip/quazip.h \
    quazip/0.7.3/include/quazip/quazip_global.h \
    quazip/0.7.3/include/quazip/quazipdir.h \
    quazip/0.7.3/include/quazip/quazipfile.h \
    quazip/0.7.3/include/quazip/quazipfileinfo.h \
    quazip/0.7.3/include/quazip/quazipnewinfo.h \
    quazip/0.7.3/include/quazip/unzip.h \
    quazip/0.7.3/include/quazip/zip.h \
    quazip/crypt.h \
    quazip/ioapi.h \
    quazip/JlCompress.h \
    quazip/quaadler32.h \
    quazip/quachecksum32.h \
    quazip/quacrc32.h \
    quazip/quagzipfile.h \
    quazip/quaziodevice.h \
    quazip/quazip.h \
    quazip/quazip_global.h \
    quazip/quazipdir.h \
    quazip/quazipfile.h \
    quazip/quazipfileinfo.h \
    quazip/quazipnewinfo.h \
    quazip/unzip.h \
    quazip/zip.h \

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
