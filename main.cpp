#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>

#include <sketch_converter.h>
#include <sketchconstraintssolver.h>
#include <sketchstaticsexporter.h>
#include <displaykeyboard.h>
#include <jsonsketch.h>

#include <QSharedPointer>
#include <QSharedDataPointer>
#include <QDir>
#include <QDebug>
#include "globals.h"
#include "realtoexporter.h"
int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<SketchConverter>("SketchConverter", 1, 0, "SketchConverter");
    qmlRegisterType<SketchConstraintsSolver>("SketchConstraintsSolver", 1, 0, "SketchConstraintsSolver");
    qmlRegisterType<SketchStaticsExporter>("SketchStaticsExporter", 1, 0, "SketchStaticsExporter");
    qmlRegisterType<DisplayKeyboard>("DisplayKeyboard", 1, 0, "DisplayKeyboard");
    qmlRegisterType<RealtoExporter>("RealtoExporter", 1, 0, "RealtoExporter");
    qmlRegisterType<JSONSketch>("JSONSketch", 1, 0, "JSONSketch");

    engine.rootContext()->setContextProperty("scenariosPath", "file://"+scenariosDir);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

