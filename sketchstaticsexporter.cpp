#include "sketchstaticsexporter.h"
#include <QDebug>
#include <QDir>
#include <QImage>
#include <QPainter>
#include <iostream>
#include <fstream>
#include "globals.h"
SketchStaticsExporter::SketchStaticsExporter(QObject *parent) : QObject(parent) {
    this->sketch = Q_NULLPTR;
    for(int i = 0; i < 26; i++) {
        this->idToLetter[i] = i + 65;
    }
}

void SketchStaticsExporter::setSketch(QObject *sketch) {
    this->sketch = sketch;
}

QObject* SketchStaticsExporter::getSketch() {
    return this->sketch;
}

bool SketchStaticsExporter::identifierToLetter(int id, QString &name) {
    if(id < 0) {
        return false;
    }
    // would be amazing to have so much point
    if(id > 1000) {
        return false;
    }

    // so we won't have overflow here
    int subscript = (id + 1)/26;
    int letterIndex = id % 26;
    if(letterIndex < 0) {
        return false;
    }

    name.append(this->idToLetter[id % 26]);

    if(subscript != 0) {
        name.append(QString::number(subscript));
    }

    return true;
}

QVariant SketchStaticsExporter::exportToFile(QString basename, QString backgroundImagePath, QSize appSize , QString path) {
    if(this->sketch == Q_NULLPTR) {
        return "No sketch to export";
    }

    QVariant mmPerPixelScale;
    bool isGetMmPerPixelScaleCallWorks = QMetaObject::invokeMethod(
                sketch,
                "getMmPerPixelScale",
                Q_RETURN_ARG(QVariant, mmPerPixelScale)
                );

    if(!mmPerPixelScale.isValid()){
        return "Set Scale First";
    }


    if(basename.isEmpty()){
        return "Invalid basename";
    }

    if(path.isEmpty()){
        path=scenariosDir+basename+"/";
    }

    if(!QDir(path).exists()){
        if(!QDir().mkpath(path))
            return "Can't create path for exportFile";
    }

    QString filename=path+basename+".structure";
    QFile file(filename);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text) ){
        return "Cannot open the model file to export";
    }

    QVariantMap store = this->sketch->property("store").value<QVariantMap>();
    QVariantList points = store["points"].value<QVariantList>();
    QVariantList lines = store["lines"].value<QVariantList>();

    QMap<int, int> pointToStaticsIndex;

    int numberOfPoints = points.size();
    int numberOfReaction = 0;
    int numberOfBeams = lines.size();


    QTextStream stream( &file );

    stream << "#Scale factor between tangible model and real model(affect only the position of the joints)" << endl
           << "0.1" << endl
           << endl;

    stream << "#Number of nodes" << endl
           << numberOfPoints << endl
           << endl;

    stream << "#Node id,x,y,z,dim(always 0)" << endl;

    int i = 0;


    // getting the origin :
    double minX = 0;
    double maxX = 0;
    double minY = 0;
    double maxY = 0;
    bool first = true;

    foreach(QVariant rawPoint, points) {
        QObject* point = rawPoint.value<QObject*>();
        QVector2D position = point->property("start").value<QVector2D>();
        double x = position.x();
        double y = -position.y();

        if(first) {
            first = false;
            minX = x;
            maxY = x;

            minY = y;
            maxY = y;
        }
        else {
            if(x > maxX) {
                maxX = x;
            }
            if(x < minX) {
                minX = x;
            }
            if(y > maxY) {
                maxY = y;
            }
            if(y < minY) {
                minY = y;
            }
        }
    }


    double moveX = - (maxX + minX) / 2.0;
    //double moveY = - (maxY + minY) / 2.0;
    double moveY = -minY ;




    foreach(QVariant rawPoint, points) {
        QObject* point = rawPoint.value<QObject*>();
        int identifier = point->property("identifier").toInt();
        QVector2D position = point->property("start").value<QVector2D>();

        pointToStaticsIndex[identifier] = i;

        stream << i << ","
               << (position.x()+moveX)*mmPerPixelScale.toDouble()*1000 << ","
               << (-position.y()+moveY)*mmPerPixelScale.toDouble()*1000+300 << ","
               << 0 << ","
               << 0
               << endl;
        i++;
    }

    stream << endl;




    QString reactions;
    QTextStream reactionsStream(&reactions, QIODevice::WriteOnly);
    i = 0;
    bool atLeastOneSupport=false;


    foreach(QVariant rawPoint, points) {
        QObject* point = rawPoint.value<QObject*>();

        bool cx = point->property("cx").toBool();
        bool cy = point->property("cy").toBool();
        if(cx && cy) atLeastOneSupport=true;

    }

    foreach(QVariant rawPoint, points) {
        QObject* point = rawPoint.value<QObject*>();

        bool cx = point->property("cx").toBool();
        bool cy = point->property("cy").toBool();
        bool cz = true;point->property("cz").toBool();

        bool mx = true;//point->property("mx").toBool();
        bool my = true;//point->property("my").toBool();
        bool mz = false;point->property("mz").toBool();

        if(cx || cy || cz || mx || my || mz) {
            numberOfReaction++;
            if(i==0 && !atLeastOneSupport){
                atLeastOneSupport=true;
                reactionsStream << i << ","
                                << 1 << ","
                                << 1 << ","
                                << (cz ? "1" : "0") << ","
                                << (mx ? "1" : "0") << ","
                                << (my ? "1" : "0") << ","
                                << 1
                                << endl;
            }
            else{
                reactionsStream << i << ","
                                << (cx ? "1" : "0") << ","
                                << (cy ? "1" : "0") << ","
                                << (cz ? "1" : "0") << ","
                                << (mx ? "1" : "0") << ","
                                << (my ? "1" : "0") << ","
                                << (mz ? "1" : "0")
                                << endl;
            }

        }
        i++;
    }


    stream << "#Number of reaction" << endl
           << numberOfReaction << endl
           << endl;

    stream << "#Node Id,x,y,z,Mx,My,Mz" << endl
           << reactions
           << endl;

    stream << "#Number of beams" << endl
           << numberOfBeams << endl
           << endl;

    stream << "#Beam name,node 1,node 2,width,height,MaterialID,tangibleWidth,tangibleHeight" << endl;

    foreach(QVariant rawLine, lines) {
        QObject* line = rawLine.value<QObject*>();
        QObject* start = line->property("startPoint").value<QObject*>();
        QObject* end = line->property("endPoint").value<QObject*>();
        int idStart = start->property("identifier").toInt();
        int idEnd = end->property("identifier").toInt();
        QVector2D pointer = line->property("pointer").value<QVector2D>();

        QString letterStart;
        QString letterEnd;

        if(
                !this->identifierToLetter(pointToStaticsIndex[idStart], letterStart)
                || !this->identifierToLetter(pointToStaticsIndex[idEnd], letterEnd)
                ) {
            file.close();
            return "Unable to transform identifier to export format";
        }

        stream << letterStart << letterEnd << ","
               << pointToStaticsIndex[idStart] << ","
               << pointToStaticsIndex[idEnd] << ","
               << 120 << ","
               << 250 << ","
               << "default"<<","
               << SketchLine::radius<<","
               << SketchLine::radius
               << endl;
    }

    stream << endl;

    QImage backgroundImage(backgroundImagePath);
    QImage outputImage;
    QPainter painter;
    int xOffset=0;
    int width=640;
    int height=480;
    if(backgroundImage.isNull()){
        outputImage=QImage(width,height,QImage::Format_RGB32);
    }
    else{
        width=backgroundImage.width();
        height=backgroundImage.height();
        outputImage=backgroundImage.copy(0,0,2*backgroundImage.width(),backgroundImage.height());
        xOffset=backgroundImage.width();
    }
    painter.begin(&outputImage);
    QPen pen;
    pen.setColor(Qt::white);
    pen.setCapStyle(Qt::RoundCap);
    pen.setStyle(Qt::DashDotLine);
    pen.setWidth(10);
    painter.setPen(pen);
    painter.fillRect(xOffset,0,width,height, QBrush(QColor(5,4,144)));
    float scaleX=(float)width/appSize.width();
    float scaleY=(float)height/appSize.height();
    foreach(QVariant rawLine, lines) {
        pen.setColor(QColor(166,169,171));
        painter.setPen(pen);
        QObject* line = rawLine.value<QObject*>();
        QObject* start = line->property("startPoint").value<QObject*>();
        QObject* end = line->property("endPoint").value<QObject*>();
        QVector2D startPoint=start->property("start").value<QVector2D>();
        QVector2D endPoint=end->property("start").value<QVector2D>();
        painter.drawLine(startPoint.x()*scaleX + xOffset,startPoint.y()*scaleY,endPoint.x()*scaleX+ xOffset,endPoint.y()*scaleY);
        QVector2D midPoint=0.5*(endPoint+startPoint);
        pen.setColor(Qt::white);
        painter.setPen(pen);
        painter.drawText(midPoint.x()*scaleX+xOffset-pen.width()*1.5,midPoint.y()*scaleY+pen.width()*1.5,QString::number((endPoint-startPoint).length()*mmPerPixelScale.toDouble(),'f',3)+"m");
    }
    painter.end();
    outputImage.save(path+basename+".png");
    return true;
}

QVariant SketchStaticsExporter::saveFile(QString basename, QString backgroundImagePath, QSize appSize , QString path) {
    if(this->sketch == Q_NULLPTR) {
        return "No sketch to save";
    }

    QVariant mmPerPixelScale;
    bool isGetMmPerPixelScaleCallWorks = QMetaObject::invokeMethod(
                sketch,
                "getMmPerPixelScale",
                Q_RETURN_ARG(QVariant, mmPerPixelScale)
                );

    if(!mmPerPixelScale.isValid()){
        return "Set Scale First";
    }


    if(basename.isEmpty()){
        return "Invalid basename";
    }

    if(path.isEmpty()){
        path=scenariosDir+basename+"/";
    }

    if(!QDir(path).exists()){
        if(!QDir().mkpath(path))
            return "Can't create path for saveFile";
    }

    QString filename=path+basename+".carp";
    QFile file(filename);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text) ){
        return "Cannot open the model file to save";
    }

    QVariantMap store = this->sketch->property("store").value<QVariantMap>();
    QVariantList points = store["points"].value<QVariantList>();
    QVariantList lines = store["lines"].value<QVariantList>();

    QMap<int, int> pointToStaticsIndex;

    int numberOfPoints = points.size();
    int numberOfReaction = 0;
    int numberOfBeams = lines.size();


    QTextStream stream( &file );

    stream << "#Scale factor between tangible model and real model(affect only the position of the joints)" << endl
           << "0.1" << endl
           << endl;

    stream << "#Number of nodes" << endl
           << numberOfPoints << endl
           << endl;

    stream << "#Node id,x,y,z,dim(always 0)" << endl;

    int i = 0;


    // getting the origin :
    double minX = 0;
    double maxX = 0;
    double minY = 0;
    double maxY = 0;
    bool first = true;

    foreach(QVariant rawPoint, points) {
        QObject* point = rawPoint.value<QObject*>();
        QVector2D position = point->property("start").value<QVector2D>();
        double x = position.x();
        double y = -position.y();

        if(first) {
            first = false;
            minX = x;
            maxY = x;

            minY = y;
            maxY = y;
        }
        else {
            if(x > maxX) {
                maxX = x;
            }
            if(x < minX) {
                minX = x;
            }
            if(y > maxY) {
                maxY = y;
            }
            if(y < minY) {
                minY = y;
            }
        }
    }


    double moveX = - (maxX + minX) / 2.0;
    //double moveY = - (maxY + minY) / 2.0;
    double moveY = -minY ;




    foreach(QVariant rawPoint, points) {
        QObject* point = rawPoint.value<QObject*>();
        int identifier = point->property("identifier").toInt();
        QVector2D position = point->property("start").value<QVector2D>();

        pointToStaticsIndex[identifier] = i;

        stream << i << ","
               << (position.x()+moveX)*mmPerPixelScale.toDouble()*1000 << ","
               << (-position.y()+moveY)*mmPerPixelScale.toDouble()*1000+300 << ","
               << 0 << ","
               << 0
               << endl;
        i++;
    }

    stream << endl;




    QString reactions;
    QTextStream reactionsStream(&reactions, QIODevice::WriteOnly);
    i = 0;
    bool atLeastOneSupport=false;


    foreach(QVariant rawPoint, points) {
        QObject* point = rawPoint.value<QObject*>();

        bool cx = point->property("cx").toBool();
        bool cy = point->property("cy").toBool();
        if(cx && cy) atLeastOneSupport=true;

    }

    foreach(QVariant rawPoint, points) {
        QObject* point = rawPoint.value<QObject*>();

        bool cx = point->property("cx").toBool();
        bool cy = point->property("cy").toBool();
        bool cz = true;point->property("cz").toBool();

        bool mx = true;//point->property("mx").toBool();
        bool my = true;//point->property("my").toBool();
        bool mz = false;point->property("mz").toBool();

        if(cx || cy || cz || mx || my || mz) {
            numberOfReaction++;
            if(i==0 && !atLeastOneSupport){
                atLeastOneSupport=true;
                reactionsStream << i << ","
                                << 1 << ","
                                << 1 << ","
                                << (cz ? "1" : "0") << ","
                                << (mx ? "1" : "0") << ","
                                << (my ? "1" : "0") << ","
                                << 1
                                << endl;
            }
            else{
                reactionsStream << i << ","
                                << (cx ? "1" : "0") << ","
                                << (cy ? "1" : "0") << ","
                                << (cz ? "1" : "0") << ","
                                << (mx ? "1" : "0") << ","
                                << (my ? "1" : "0") << ","
                                << (mz ? "1" : "0")
                                << endl;
            }

        }
        i++;
    }


    stream << "#Number of reaction" << endl
           << numberOfReaction << endl
           << endl;

    stream << "#Node Id,x,y,z,Mx,My,Mz" << endl
           << reactions
           << endl;

    stream << "#Number of beams" << endl
           << numberOfBeams << endl
           << endl;

    stream << "#Beam name,node 1,node 2,width,height,MaterialID,tangibleWidth,tangibleHeight" << endl;

    foreach(QVariant rawLine, lines) {
        QObject* line = rawLine.value<QObject*>();
        QObject* start = line->property("startPoint").value<QObject*>();
        QObject* end = line->property("endPoint").value<QObject*>();
        int idStart = start->property("identifier").toInt();
        int idEnd = end->property("identifier").toInt();
        QVector2D pointer = line->property("pointer").value<QVector2D>();

        QString letterStart;
        QString letterEnd;

        if(
                !this->identifierToLetter(pointToStaticsIndex[idStart], letterStart)
                || !this->identifierToLetter(pointToStaticsIndex[idEnd], letterEnd)
                ) {
            file.close();
            return "Unable to transform identifier to export format";
        }

        stream << letterStart << letterEnd << ","
               << pointToStaticsIndex[idStart] << ","
               << pointToStaticsIndex[idEnd] << ","
               << 120 << ","
               << 250 << ","
               << "default"<<","
               << SketchLine::radius<<","
               << SketchLine::radius
               << endl;
    }

    stream << endl;

    QImage backgroundImage(backgroundImagePath);
    QImage outputImage;
    QPainter painter;
    int xOffset=0;
    int width=640;
    int height=480;
    if(backgroundImage.isNull()){
        outputImage=QImage(width,height,QImage::Format_RGB32);
    }
    else{
        width=backgroundImage.width();
        height=backgroundImage.height();
        outputImage=backgroundImage.copy(0,0,2*backgroundImage.width(),backgroundImage.height());
        xOffset=backgroundImage.width();
    }
    painter.begin(&outputImage);
    QPen pen;
    pen.setColor(Qt::white);
    pen.setCapStyle(Qt::RoundCap);
    pen.setStyle(Qt::DashDotLine);
    pen.setWidth(10);
    painter.setPen(pen);
    painter.fillRect(xOffset,0,width,height, QBrush(QColor(5,4,144)));
    float scaleX=(float)width/appSize.width();
    float scaleY=(float)height/appSize.height();
    foreach(QVariant rawLine, lines) {
        pen.setColor(QColor(166,169,171));
        painter.setPen(pen);
        QObject* line = rawLine.value<QObject*>();
        QObject* start = line->property("startPoint").value<QObject*>();
        QObject* end = line->property("endPoint").value<QObject*>();
        QVector2D startPoint=start->property("start").value<QVector2D>();
        QVector2D endPoint=end->property("start").value<QVector2D>();
        painter.drawLine(startPoint.x()*scaleX + xOffset,startPoint.y()*scaleY,endPoint.x()*scaleX+ xOffset,endPoint.y()*scaleY);
        QVector2D midPoint=0.5*(endPoint+startPoint);
        pen.setColor(Qt::white);
        painter.setPen(pen);
        painter.drawText(midPoint.x()*scaleX+xOffset-pen.width()*1.5,midPoint.y()*scaleY+pen.width()*1.5,QString::number((endPoint-startPoint).length()*mmPerPixelScale.toDouble(),'f',3)+"m");
    }
    painter.end();
    outputImage.save(path+basename+".png");
    return true;
}
