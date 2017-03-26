#include <QJsonArray>
#include <QList>
#include <QVector2D>
#include <QJsonObject>
#include <QString>
#include <QFile>
#include <QByteArray>
#include <QQuickItem>
#include <QJsonDocument>
#include <QString>
#include <QQmlContext>
#include <QQmlComponent>

#include "jsonsketch.h"

JSONSketch::JSONSketch(QObject *parent):QObject(parent){}

QString JSONSketch::loadSketch(const QString url, QObject* sketch)
{
    QFile file(url);

    if (!file.open(QIODevice::ReadOnly)) {
        return "cannot open the JSON file";
    }

    QByteArray data = file.readAll();

    QJsonParseError error;
    QJsonDocument doc(QJsonDocument::fromJson(data, &error));

    return read(doc.object(), sketch);
}

QString JSONSketch::read(const QJsonObject json, QObject* sketch)
{
    qDebug()<<json;

    QJsonArray qPid = json["pid"].toArray();
    QJsonArray qLid = json["lid"].toArray();
    QJsonObject qPoints = json["points"].toObject();
    QJsonObject qLines = json["lines"].toObject();

    qDebug() << "qPid : " << qPid;
    qDebug() << "qLid : " << qLid;
    qDebug() << "qPoints : " << qPoints;
    qDebug() << "qLines : " << qLines;

    nb_points = json["nb_points"].toInt();
    nb_lines = json["nb_lines"].toInt();

    qDebug() << "nb_points : " << nb_points;
    qDebug() << "nb_lines : " << nb_lines;

    if(nb_points != qPoints.size() || nb_lines != qLines.size()) {
        return "corrupted number of points or lines";
    }

    QJsonArray currPoint;
    for(int p(0); p < nb_points; p++){
        int intPid = qPid[p].toInt();
        currPoint = qPoints[QString::number(intPid)].toArray();
        if (currPoint.size() != 2){
            return "corrupted point with id: " + QString::number(intPid);
        }
        points.insert(intPid, QVector2D(currPoint[0].toInt(), currPoint[1].toInt()));
    }



    QJsonArray currLine;
    for(int l(0); l < nb_lines; l++){
        int intLid = qLid[l].toInt();
        currLine = qLines[QString::number(intLid)].toArray();
        if (currLine.size() != 2){
            return "corrupted line with id: " + QString::number(intLid);
        }
        if(currLine[0] == currLine[1] ||
                !points.contains(currLine[0].toInt()) ||
                !points.contains(currLine[1].toInt())) {
            return "corrupted point id of line with id: ";
        }
        lines.insert(intLid, QVector2D(currLine[0].toInt(), currLine[1].toInt()));
    }

    generateSketch(sketch);

    return "true";
}

void JSONSketch::generateSketch(QObject* sketch) {
    QQmlComponent point_component(qmlEngine(sketch),sketch);
    point_component.loadUrl(QUrl("qrc:/Point.qml"));

    QMap<int, QQuickItem*> qPoints;

    foreach (int pid, points.keys()) {
        QQmlContext* point_context = new QQmlContext(qmlContext(sketch),sketch);
        QQuickItem* point = qobject_cast<QQuickItem*>(point_component.create(point_context));

        point_context->setContextObject(point);
        point->setProperty("x", points[pid].x());
        point->setProperty("y", points[pid].y());

        point->setParent(sketch);
        point->setParentItem(qobject_cast<QQuickItem*>(sketch));

        qPoints.insert(pid, point);
    }

    QQmlComponent line_component(qmlEngine(sketch),sketch);
    line_component.loadUrl(QUrl("qrc:/Line.qml"));

    foreach (int lid, lines.keys()) {
        QQmlContext* line_context = new QQmlContext(qmlContext(sketch),sketch);
        QQuickItem* line = qobject_cast<QQuickItem*>(line_component.beginCreate(line_context));

        line_context->setContextObject(line);

        line->setProperty("p1", qVariantFromValue(qPoints[lines[lid].x()]));
        line->setProperty("p2", qVariantFromValue(qPoints[lines[lid].y()]));

        line->setParent(sketch);
        line->setParentItem(qobject_cast<QQuickItem*>(sketch));
        line_component.completeCreate();
    }
}

QString JSONSketch::exportJSONSketch(const QString url) const{
    QFile file(url);

    if (!file.open(QIODevice::WriteOnly)) {
        return "cannot open the JSON file";
    }

    QJsonObject object;
    write(object);
    QJsonDocument doc(object);
    file.write(doc.toJson());

    file.close();

    return "true";
}

QString JSONSketch::write(QJsonObject &json) const
{
    json["nb_points"] = nb_points;
    json["nb_lines"] = nb_lines;

    QJsonObject qPoints;
    QJsonArray qPid;
    foreach (int pid, points.keys()) {
        qPid.append(pid);
        QJsonArray currPoint;
        currPoint.append(points[pid].x());
        currPoint.append(points[pid].y());
        qPoints.insert(QString::number(pid), currPoint);
    }
    json["pid"] = qPid;
    json["points"] = qPoints;


    QJsonObject qLines;
    QJsonArray qLid;
    foreach (int lid, lines.keys()) {
        qLid.append(lid);
        QJsonArray currLine;
        currLine.append(lines[lid].x());
        currLine.append(lines[lid].y());
        qLines.insert(QString::number(lid), currLine);
    }
    json["lid"] = qLid;
    json["lines"] = qLines;

    return "true";
}

int JSONSketch::addPoint(int x, int y) {
    int id = incrementPointsId();
    points.insert(id, QVector2D(x, y));
    nb_points++;
    return id;
}

int JSONSketch::addLine(int p1, int p2) {
    int id = incrementLinesId();
    lines.insert(id, QVector2D(p1, p2));
    nb_lines++;
    return id;
}

void JSONSketch::removePoint(int id) {
    if (points.contains(id)) {
        points.remove(id);
        nb_points--;
    } else {
        qDebug() << "Try to remove inexisting point with id: " << id;
    }
}

void JSONSketch::removeLine(int id) {
    if (lines.contains(id)) {
        lines.remove(id);
        nb_lines--;
    } else {
        qDebug() << "Try to remove inexisting line with id: " << id;
    }
}
int JSONSketch::incrementPointsId() {
    return nextPointId++;
}

int JSONSketch::incrementLinesId() {
    return nextLineId++;
}
