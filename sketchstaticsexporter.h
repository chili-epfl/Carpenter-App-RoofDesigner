#ifndef SketchStaticsExporter_H
#define SketchStaticsExporter_H

#include <QObject>
#include <QVariant>
#include <QString>
#include <QIODevice>
#include <QFile>
#include <QTextStream>
#include <QVariantMap>
#include <QVector2D>
#include <QSize>
#include "sketchline.h"

/**
 * @brief The SketchStaticsExporter class
 *
 * SketchStaticsExporter allows to export the current
 * sketch document in a flat text file.
 *
 * After qml registration, it can be used as a qml
 * component like that :
 * SketchStaticsExporter { sketch: mySketchComponent },
 */
class SketchStaticsExporter : public QObject {
    Q_OBJECT

    Q_PROPERTY(QObject* sketch READ getSketch WRITE setSketch)

public:
    explicit SketchStaticsExporter(QObject *parent = 0);

public slots:
    void setSketch(QObject *sketch);
    QObject* getSketch();
    QVariant exportToFile(QString basename, QString backgroundImagePath, QSize appSize, QString path=QString());
    Q_INVOKABLE QVariant saveFile(QString basename, QString backgroundImagePath, QSize appSize , QString path);
private:
    QObject *sketch;
    QString idToLetter[26];
    bool identifierToLetter(int id, QString &name);
};

#endif // SketchStaticsExporter_H
