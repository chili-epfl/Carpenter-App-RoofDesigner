#include "sketchjoint.h"
#include "sketchline.h"
#include <QDebug>


SketchJoint::SketchJoint(QObject* rawPoint, QList<QObject*> lines) {

    /**
      * Precondition : note that this is only possible to compute
      * if the angle between each line is greater than
      * 2*Arctan(SketchLine::radius/SketchLine::edgeShortcut) otherwise
      * we would need to cut more than SketchLine::edgeShortcut
      *
      * 1) Sort the line with respect to angle from the rawPoint center
      * 2) Compute two point on the line equation at distance parametrized
      *    via SketchLine::radius  and compute two point on the line
      * 3) compute the intersection
      *    from following equation : http://stackoverflow.com/a/385355
      *
      *    float x12 = x1 - x2;
      *    float x34 = x3 - x4;
      *    float y12 = y1 - y2;
      *    float y34 = y3 - y4;
      *
      *    float c = x12 * y34 - y12 * x34;
      *
      *    if (fabs(c) < 0.01)
      *    {
      *      // No intersection
      *      return false;
      *    }
      *    else
      *    {
      *      // Intersection
      *      float a = x1 * y2 - y1 * x2;
      *      float b = x3 * y4 - y3 * x4;
      *
      *      float x = (a * x34 - b * x12) / c;
      *      float y = (a * y34 - b * y12) / c;
      *
      *      return true;
      *    }
      *
      * 4) We build the list of vertices in this way :
      *     foreach Lines
      *     I.   take the first point on the line drawn by third and fourth point on line 1
      *     II.  take the intersection between the current and next line
      *     III. take the first point on the line drawn by first and sercond point on line 2
      * 5) Compute the 3D vertex
      */

#ifdef CARPENTER_DEBUG
    qDebug() << "SketchJoint: new SketchJoint";
    qDebug() << "SketchJoint: " << lines;
    qDebug() << "SketchJoint: " << rawPoint;
    qDebug() << "SketchJoint: edgeShortcut" << SketchLine::edgeShortcut;
    qDebug() << "SketchJoint: radius" << SketchLine::radius;
#endif

    QVariant startProperty = rawPoint->property("start");

    if(!startProperty.isValid() || !startProperty.canConvert<QVector2D>()) {
        this->setErrorMessage("Cannot find origin in Point");
        return;
    }

    QVector2D point = startProperty.value<QVector2D>();

    // Nothing to do if no more than one line
    if(lines.size() <= 1) {
        this->setValid(true);
        return;
    }

    foreach(QObject* line, lines) {
        // ----------------------------------------------------------------------------------
        // Cast and properties check

        QVariant pointerProperty = line->property("pointer");
        if(!pointerProperty.isValid() || !pointerProperty.canConvert<QVector2D>()) {
            this->setErrorMessage("Cannot find or convert pointer in Line");
            return;
        }

        QVariant endPointProperty = line->property("endPoint");
        if(!endPointProperty.isValid() || !endPointProperty.canConvert<QObject*>()) {
            this->setErrorMessage("Cannot find or convert endPoint in Line");
            return;
        }

        QVariant identifierProperty = line->property("identifier");
        if(!identifierProperty.isValid() || !identifierProperty.canConvert<int>()) {
            this->setErrorMessage("Cannot find or convert identifier in Line");
            return;
        }

        int identifier = identifierProperty.toInt();

        // ----------------------------------------------------------------------------------

        QVector2D pointer = pointerProperty.value<QVector2D>().normalized();
        if(endPointProperty.value<QObject*>() == rawPoint) {
            //qDebug() << "invert the pointer";
            pointer *= -1.0f;
        }

        double angle = qRadiansToDegrees(qAtan2(pointer.y(),pointer.x()));
        // want angle from 0 to 360
        if(angle < 0) {
            angle = 360 + angle;
        }

        line->setProperty("sortAngle", angle);
#ifdef CARPENTER_DEBUG
        qDebug() << "SketchJoint: line #" << identifier << ":" << angle;
#endif

        /*
         * 2) compute the two points
         */

        // need the normal in the inverse direction of angle
        QVector2D normal = QVector2D(pointer.y(), -pointer.x()).normalized();

        QVector2D firstPoint = point + (normal * SketchLine::radius);
        QVector2D secondPoint = point + (pointer * SketchLine::edgeShortcut) + (normal * SketchLine::radius);

        QVector2D thirdPoint = point - (normal * SketchLine::radius);
        QVector2D fourthPoint = point + (pointer * SketchLine::edgeShortcut) - (normal * SketchLine::radius);

#ifdef CARPENTER_DEBUG
        qDebug() << "SketchJoint: #:" <<  identifier;

        qDebug() << "SketchJoint:  -> origin" << point.x() << point.y() <<  "";
        qDebug() << "SketchJoint:  -> normal" << normal <<  "";
        qDebug() << "SketchJoint:  -> normal * radius" << (normal * SketchLine::radius) <<  "\n";
        qDebug() << "SketchJoint:  -> pointer" << pointer <<  "";
        qDebug() << "SketchJoint:  -> pointer * edgeShortcut" << (pointer * SketchLine::edgeShortcut) <<  "\n";

        qDebug() << "SketchJoint:  -> firstPoint (" << firstPoint.x() << "," << firstPoint.y() << ")";
        qDebug() << "SketchJoint:  -> secondPoint (" << secondPoint.x() << "," << secondPoint.y() << ")";

        qDebug() << "SketchJoint:  -> thirdPoint (" << thirdPoint.x() << "," << thirdPoint.y() << ")";
        qDebug() << "SketchJoint:  -> fourthPoint (" << fourthPoint.x() << "," << fourthPoint.y() << ")";
#endif

        line->setProperty("firstPoint", firstPoint);
        line->setProperty("secondPoint", secondPoint);
        line->setProperty("thirdPoint", thirdPoint);
        line->setProperty("fourthPoint", fourthPoint);
    }

    std::sort(lines.begin(), lines.end(), [](const QObject* line1, const QObject* line2) -> bool {
        double angle1 = line1->property("sortAngle").toDouble();
        double angle2 = line2->property("sortAngle").toDouble();
        return angle1 < angle2;
    });

    // 3) Compute the intersection
    int i = 0;
    foreach(QObject* line, lines) {
#ifdef CARPENTER_DEBUG
        qDebug() << "SketchJoint: #" <<  i << ":" <<  line->property("identifier").toInt();
#endif
        i++;
    }

    // List of vertices of the joint mesh
    QList<QVector2D> vertices;

    double preconditionAngle = qRadiansToDegrees(2*qAtan(SketchLine::radius/SketchLine::edgeShortcut));
#ifdef CARPENTER_DEBUG
    qDebug() << "SketchJoint: preconditionAngle: " << preconditionAngle;
#endif

    for(int lineIndex = 0; lineIndex < lines.size(); lineIndex++) {

        /**
         * Line 1 is characterized by A = (x1,y1) and B = (x2,y2)
         * Line 2 is characterized by C = (x3,y3) and D = (x4,y4)
         */

        QObject* line1 = lines.at(lineIndex);
        QObject* line2 = lines.at((lineIndex + 1) % lines.size());

#ifdef CARPENTER_DEBUG
        qDebug() << "SketchJoint: #" <<  i << ":" <<  line1->property("identifier").toInt();
#endif

        /*
         * Before computing, we check for the precondition on angle
         */
        double deltaAngle = line2->property("sortAngle").toDouble() - line1->property("sortAngle").toDouble();


        if(deltaAngle < 0) {
            deltaAngle += 360;
        }

#ifdef CARPENTER_DEBUG
        qDebug() << "SketchJoint:" << "deltaAngle: " << deltaAngle;
#endif

        if(deltaAngle < preconditionAngle) {
            this->setErrorMessage("Impossible to compute the joint two lines have too small angle between them");
            return;
        }

        QVector2D A = line1->property("thirdPoint").value<QVector2D>();
        QVector2D B = line1->property("fourthPoint").value<QVector2D>();

        QVector2D C = line2->property("firstPoint").value<QVector2D>();
        QVector2D D = line2->property("secondPoint").value<QVector2D>();

        double x1 = A.x();
        double y1 = A.y();

        double x2 = B.x();
        double y2 = B.y();

        double x3 = C.x();
        double y3 = C.y();

        double x4 = D.x();
        double y4 = D.y();

        double x12 = x1 - x2;
        double x34 = x3 - x4;
        double y12 = y1 - y2;
        double y34 = y3 - y4;

        double c = x12 * y34 - y12 * x34;

        QVector2D intersection;
        // No intersection
        if (fabs(c) < 0.01) {
            if(A.distanceToPoint(B)==0 || A.distanceToPoint(C)==0 || A.distanceToPoint(D)==0)
                intersection=A;
            else if(B.distanceToPoint(C)==0 || B.distanceToPoint(D)==0)
                intersection=B;
            else if(C.distanceToPoint(D)==0)
                intersection=C;
            else {
                this->setErrorMessage("Cannot build a joint because of an intersection");
                return;
            }
        }
        else{

            // Intersection
            double a = x1 * y2 - y1 * x2;
            double b = x3 * y4 - y3 * x4;

            double x = (a * x34 - b * x12) / c;
            double y = (a * y34 - b * y12) / c;

            intersection = QVector2D(x, y);
        }
        vertices << B;
        vertices << intersection;
        vertices << D;
    }

#ifdef CARPENTER_DEBUG
    qDebug() << "SketchJoint: \nSketchJoint: ---------";
    qDebug() << "SketchJoint: vertices\n";
#endif

//    /*CCW sorting*/
//    QVector2D centre(0,0);
//    Q_FOREACH(QVector2D v, vertices){
//        centre+=v;
//    }
//    centre/=vertices.size();

//    QMap<qreal,QVector2D> angles;
//    Q_FOREACH(QVector2D v, vertices){
//        qreal val=atan2(v.y()-centre.y(),v.x()-centre.x());
//        if(val<0)
//            val=M_PI+(M_PI+val);
//        angles[val]=v;
//    }

//    if(angles.size()!=vertices.size()){
//        qDebug()<<"Found Duplicates!";
//    }
//    /*http://gamedev.stackexchange.com/questions/79638/calculating-the-winding-and-normal-when-programatically-adding-triangles-to-a-me*/


//    QList<QVector2D> ordered_vertices=angles.values();

//    Q_FOREACH(QVector2D v, ordered_vertices)
//        this->vertices.append(QVector3D(v.x(),v.y(),SketchLine::radius));
//    Q_FOREACH(QVector2D v, ordered_vertices)
//        this->vertices.append(QVector3D(v.x(),v.y(),-SketchLine::radius));

//    /*Top cap*/
//    QList<int> _part;
//    for(int i=0;i<ordered_vertices.size()-2;i++){
//        _part.clear();
//        _part.append(i);
//        _part.append(i+1);
//        _part.append(i+2);
//        this->faces.append(_part);
//    }
//    /*Bottom cap*/
//    for(int i=ordered_vertices.size();i<2*ordered_vertices.size()-2;i++){
//        _part.clear();
//        _part.append(ordered_vertices.size());
//        _part.append(ordered_vertices.size()+2);
//        _part.append(ordered_vertices.size()+1);
//        this->faces.append(_part);
//    }
//    /*Side cap*/
//    for(int i=0;i<ordered_vertices.size();i++){
//        _part.clear();
//        _part.append(i+ordered_vertices.size());
//        if( (i+ordered_vertices.size()+1) <(2*ordered_vertices.size()) )
//            _part.append(i+ordered_vertices.size()+1);
//        else
//            _part.append(ordered_vertices.size());
//        _part.append(i);
//        this->faces.append(_part);

//        _part.clear();
//        _part.append(i+ordered_vertices.size());
//        _part.append(i);
//        _part.append((i+1)%ordered_vertices.size());
//        this->faces.append(_part);

//    }

    int faceIndex = 0;
    int totalFaces = vertices.size();
    QList<int> topFace;
    QList<int> bottomFace;
    QList<QVector3D> topVertices;


    foreach(QVector2D vertex, vertices) {
#ifdef CARPENTER_DEBUG
        qDebug() << "SketchJoint: (" << vertex.x() << "," << vertex.y() << ")";
#endif

        this->vertices << QVector3D(vertex.x(), vertex.y(), SketchLine::radius);
        topVertices << QVector3D(vertex.x(), vertex.y(), -SketchLine::radius);

        topFace << faceIndex;
        bottomFace << faceIndex + totalFaces;

        QList<int> sideFace;
        sideFace << faceIndex
                 << (faceIndex + totalFaces)
                 << (((faceIndex + 1) % totalFaces) + totalFaces)
                 << ((faceIndex + 1) % totalFaces);

        this->faces << sideFace;

        faceIndex++;
    }

    this->vertices << topVertices;
    this->faces << topFace;
    //this->faces << bottomFace;

    QList<int> rlist; // reverse list+
    for(int i=bottomFace.size()-1;i>=0;i--){
        rlist<<bottomFace[i];
    }
    this->faces << rlist;

#ifdef CARPENTER_DEBUG
    qDebug() << "SketchJoint: ---------\nSketchJoint: ";
#endif


    this->setValid(true);
}

QList<QVector3D> SketchJoint::getVertices() {
    //qDebug() << "get vertices" << vertices;
    return vertices;
}

QList<QList<int>> SketchJoint::getFaces() {
    //qDebug() << "get faces" << faces;
    return faces;
}


