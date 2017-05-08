#include "constraints.h"
#include <iostream>
#include <QMap>
#include <QString>
#include <QQmlComponent>
#include <QVector2D>
#include <QObject>
#include <QList>
#include <QAbstractListModel>
#include <QDebug>


void *Constraints::CheckMalloc(size_t n) {
    void *r = malloc(n);
    if(!r) {
        printf("out of memory!\n");
        exit(-1);
    }
    return r;
}

int operator <(QVector2D v1, QVector2D v2){
    return v1.x() == v2.x() ? v1.y() < v2.y() : v1.x() < v2.x();
}

/*-----------------------------------------------------------------------------
 * An example of a constraint in 2d. In our first group, we create a workplane
 * along the reference frame's xy plane. In a second group, we create some
 * entities in that group and dimension them.
 *---------------------------------------------------------------------------*/
void Constraints::Example2d() {
    Slvs_hGroup g;
    double qw, qx, qy, qz;

    g = 1;
    /* First, we create our workplane. Its origin corresponds to the origin
     * of our base frame (x y z) = (0 0 0) */
    sys.param[sys.params++] = Slvs_MakeParam(1, g, 0.0);
    sys.param[sys.params++] = Slvs_MakeParam(2, g, 0.0);
    sys.param[sys.params++] = Slvs_MakeParam(3, g, 0.0);
    sys.entity[sys.entities++] = Slvs_MakePoint3d(101, g, 1, 2, 3);
    /* and it is parallel to the xy plane, so it has basis vectors (1 0 0)
     * and (0 1 0). */
    Slvs_MakeQuaternion(1, 0, 0,
                        0, 1, 0, &qw, &qx, &qy, &qz);
    sys.param[sys.params++] = Slvs_MakeParam(4, g, qw);
    sys.param[sys.params++] = Slvs_MakeParam(5, g, qx);
    sys.param[sys.params++] = Slvs_MakeParam(6, g, qy);
    sys.param[sys.params++] = Slvs_MakeParam(7, g, qz);
    sys.entity[sys.entities++] = Slvs_MakeNormal3d(102, g, 4, 5, 6, 7);

    sys.entity[sys.entities++] = Slvs_MakeWorkplane(200, g, 101, 102);

    /* Now create a second group. We'll solve group 2, while leaving group 1
     * constant; so the workplane that we've created will be locked down,
     * and the solver can't move it. */
    g = 2;
    /* These points are represented by their coordinates (u v) within the
     * workplane, so they need only two parameters each. */
    sys.param[sys.params++] = Slvs_MakeParam(11, g, 10.0);
    sys.param[sys.params++] = Slvs_MakeParam(12, g, 20.0);
    sys.entity[sys.entities++] = Slvs_MakePoint2d(301, g, 200, 11, 12);

    sys.param[sys.params++] = Slvs_MakeParam(13, g, 20.0);
    sys.param[sys.params++] = Slvs_MakeParam(14, g, 10.0);
    sys.entity[sys.entities++] = Slvs_MakePoint2d(302, g, 200, 13, 14);

    /* And we create a line segment with those endpoints. */
    sys.entity[sys.entities++] = Slvs_MakeLineSegment(400, g,
                                                      200, 301, 302);

    /* Now three more points. */
    sys.param[sys.params++] = Slvs_MakeParam(15, g, 100.0);
    sys.param[sys.params++] = Slvs_MakeParam(16, g, 120.0);
    sys.entity[sys.entities++] = Slvs_MakePoint2d(303, g, 200, 15, 16);

    sys.param[sys.params++] = Slvs_MakeParam(17, g, 120.0);
    sys.param[sys.params++] = Slvs_MakeParam(18, g, 110.0);
    sys.entity[sys.entities++] = Slvs_MakePoint2d(304, g, 200, 17, 18);

    sys.param[sys.params++] = Slvs_MakeParam(19, g, 115.0);
    sys.param[sys.params++] = Slvs_MakeParam(20, g, 115.0);
    sys.entity[sys.entities++] = Slvs_MakePoint2d(305, g, 200, 19, 20);

    /* And arc, centered at point 303, starting at point 304, ending at
     * point 305. */
    sys.entity[sys.entities++] = Slvs_MakeArcOfCircle(401, g, 200, 102,
                                                      303, 304, 305);

    /* Now one more point, and a distance */
    sys.param[sys.params++] = Slvs_MakeParam(21, g, 200.0);
    sys.param[sys.params++] = Slvs_MakeParam(22, g, 200.0);
    sys.entity[sys.entities++] = Slvs_MakePoint2d(306, g, 200, 21, 22);

    sys.param[sys.params++] = Slvs_MakeParam(23, g, 30.0);
    sys.entity[sys.entities++] = Slvs_MakeDistance(307, g, 200, 23);

    /* And a complete circle, centered at point 306 with radius equal to
     * distance 307. The normal is 102, the same as our workplane. */
    sys.entity[sys.entities++] = Slvs_MakeCircle(402, g, 200,
                                                 306, 102, 307);


    /* The length of our line segment is 30.0 units. */
    sys.constraint[sys.constraints++] = Slvs_MakeConstraint(
                1, g,
                SLVS_C_PT_PT_DISTANCE,
                200,
                30.0,
                301, 302, 0, 0);

    /* And the distance from our line segment to the origin is 10.0 units. */
    sys.constraint[sys.constraints++] = Slvs_MakeConstraint(
                2, g,
                SLVS_C_PT_LINE_DISTANCE,
                200,
                10.0,
                101, 0, 400, 0);
    /* And the line segment is vertical. */
    sys.constraint[sys.constraints++] = Slvs_MakeConstraint(
                3, g,
                SLVS_C_VERTICAL,
                200,
                0.0,
                0, 0, 400, 0);
    /* And the distance from one endpoint to the origin is 15.0 units. */
    sys.constraint[sys.constraints++] = Slvs_MakeConstraint(
                4, g,
                SLVS_C_PT_PT_DISTANCE,
                200,
                15.0,
                301, 101, 0, 0);
#if 0
    /* And same for the other endpoint; so if you add this constraint then
     * the sketch is overconstrained and will signal an error. */
    sys.constraint[sys.constraints++] = Slvs_MakeConstraint(
                5, g,
                SLVS_C_PT_PT_DISTANCE,
                200,
                18.0,
                302, 101, 0, 0);
#endif /* 0 */

    /* The arc and the circle have equal radius. */
    sys.constraint[sys.constraints++] = Slvs_MakeConstraint(
                6, g,
                SLVS_C_EQUAL_RADIUS,
                200,
                0.0,
                0, 0, 401, 402);
    /* The arc has radius 17.0 units. */
    sys.constraint[sys.constraints++] = Slvs_MakeConstraint(
                7, g,
                SLVS_C_DIAMETER,
                200,
                17.0*2,
                0, 0, 401, 0);

    /* If the solver fails, then ask it to report which constraints caused
     * the problem. */
    sys.calculateFaileds = 1;

    /* And solve. */
    Slvs_Solve(&sys, g);

    if(sys.result == SLVS_RESULT_OKAY) {
        printf("solved okay\n");
        printf("line from (%.3f %.3f) to (%.3f %.3f)\n",
               sys.param[7].val, sys.param[8].val,
                sys.param[9].val, sys.param[10].val);

        printf("arc center (%.3f %.3f) start (%.3f %.3f) finish (%.3f %.3f)\n",
               sys.param[11].val, sys.param[12].val,
                sys.param[13].val, sys.param[14].val,
                sys.param[15].val, sys.param[16].val);

        printf("circle center (%.3f %.3f) radius %.3f\n",
               sys.param[17].val, sys.param[18].val,
                sys.param[19].val);
        printf("%d DOF\n", sys.dof);
    } else {
        int i;
        printf("solve failed: problematic constraints are:");
        for(i = 0; i < sys.faileds; i++) {
            printf(" %d", sys.failed[i]);
        }
        printf("\n");
        if(sys.result !=0) {
            printf("system inconsistent\n");
        } else {
            printf("system nonconvergent\n");
        }
    }
}

void Constraints::compute2d(QObject* sketch) {
    QMap<int, QObject*> entityObjects;

    Slvs_hGroup g;

    int paramId = 1;
    const int entityOriginId = 1;
    const int entityQuaternionId = 2;
    const int entityPlanId = 3;
    int entityId = 100;
    int constId = 1;
    double qw, qx, qy, qz;

    g = 1;
    /* First, we create our workplane. Its origin corresponds to the origin
     * of our base frame (x y z) = (0 0 0) */
    sys.param[sys.params++] = Slvs_MakeParam(paramId++, g, 0.0);
    sys.param[sys.params++] = Slvs_MakeParam(paramId++, g, 0.0);
    sys.param[sys.params++] = Slvs_MakeParam(paramId++, g, 0.0);
    sys.entity[sys.entities++] = Slvs_MakePoint3d(entityOriginId, g, paramId - 3, paramId - 2, paramId - 1);
    /* and it is parallel to the xy plane, so it has basis vectors (1 0 0)
     * and (0 1 0). */
    Slvs_MakeQuaternion(1, 0, 0,
                        0, 1, 0, &qw, &qx, &qy, &qz);
    sys.param[sys.params++] = Slvs_MakeParam(paramId++, g, qw);
    sys.param[sys.params++] = Slvs_MakeParam(paramId++, g, qx);
    sys.param[sys.params++] = Slvs_MakeParam(paramId++, g, qy);
    sys.param[sys.params++] = Slvs_MakeParam(paramId++, g, qz);
    sys.entity[sys.entities++] = Slvs_MakeNormal3d(entityQuaternionId, g, paramId - 4, paramId - 3, paramId - 2, paramId - 1);

    sys.entity[sys.entities++] = Slvs_MakeWorkplane(entityPlanId, g, entityOriginId, entityQuaternionId);

    /* Now create a second group. We'll solve group 2, while leaving group 1
     * constant; so the workplane that we've created will be locked down,
     * and the solver can't move it. */
    g = 2;
    /* These points are represented by their coordinates (u v) within the
     * workplane, so they need only two parameters each. */
    foreach (QObject* child, sketch->children()) {
        if (!QString::compare(child->property("class_type").toString(), "Point")
                && child->property("visible").toBool()) {
            pointIdsFromPosition.insert(QVector2D(child->property("x").toInt(), child->property("y").toInt()), entityId);
            sys.param[sys.params++] = Slvs_MakeParam(paramId++, g, child->property("x").toInt());
            sys.param[sys.params++] = Slvs_MakeParam(paramId++, g, child->property("y").toInt());
            sys.entity[sys.entities] = Slvs_MakePoint2d(entityId++, g, entityPlanId, paramId - 2, paramId - 1);
            entityObjects.insert(sys.entities++, child);
        }
    }

    // Make line ids begin at the next thousand
    entityId += 1000 - entityId % 1000;

    /* And we create a line segment with those endpoints which are mapped
     * to their ids by their position in pointIdsFromPosition. The map needs
     * the operator< to be overwritten. */
    foreach (QObject* child, sketch->children()) {
        if (!QString::compare(child->property("class_type").toString(), "Line")
                && child->property("visible").toBool()) {
            int p1Id = getP1Id(child);
            int p2Id = getP2Id(child);
            linesIdsFromPointIds.insert(QVector2D(p1Id, p2Id), entityId);
            sys.entity[sys.entities] = Slvs_MakeLineSegment(entityId++, g, entityPlanId, p1Id, p2Id);
            entityObjects.insert(sys.entities++, child);
        }
    }

    /* Now we iterate over all children again, in order to make specified
     * constraints.*/
    QList<int> constraintCodes({
                                   SLVS_C_HORIZONTAL,
                                   SLVS_C_VERTICAL,
                                   SLVS_C_PT_PT_DISTANCE,
                                   SLVS_C_EQUAL_LENGTH_LINES,
                                   SLVS_C_PT_PT_DISTANCE,
                                   SLVS_C_PARALLEL,
                                   SLVS_C_PERPENDICULAR,
                                   SLVS_C_ANGLE,
                                   SLVS_C_AT_MIDPOINT});

    foreach (QObject* child, sketch->children()) {
        if (!QString::compare(child->property("class_type").toString(), "Constraint")) {
            QObject* ptA = qvariant_cast<QObject*>(child->property("ptA"));
            int hPtA = ptA ? pointIdsFromPosition[QVector2D(ptA->property("x").toInt(), ptA->property("y").toInt())] : 0;

            QObject* ptB = qvariant_cast<QObject*>(child->property("ptB"));
            int hPtB = ptB ? pointIdsFromPosition[QVector2D(ptB->property("x").toInt(), ptB->property("y").toInt())] : 0;

            QObject* entityA = qvariant_cast<QObject*>(child->property("entityA"));
            int hEntityA = entityA ? linesIdsFromPointIds[QVector2D(getP1Id(entityA), getP2Id(entityA))] : 0;

            QObject* entityB = qvariant_cast<QObject*>(child->property("entityB"));
            int hEntityB = entityB ? linesIdsFromPointIds[QVector2D(getP1Id(entityB), getP2Id(entityB))] : 0;

//            qDebug() << "(" << constraintCodes[child->property("type").toInt()]
//                     << ", " << child->property("valA").toDouble() << ", "
//                     << hPtA << ", " << hPtB << ", " << hEntityA << ", "
//                     << hEntityB << ")";

            sys.constraint[sys.constraints++] =
                    Slvs_MakeConstraint(
                        constId++,
                        g,
                        constraintCodes[child->property("type").toInt()],
                    entityPlanId,
                    child->property("valA").toDouble(),
                    hPtA,
                    hPtB,
                    hEntityA,
                    hEntityB);
        }
    }
    /* If the solver fails, then ask it to report which constraints caused
     * the problem. */
    sys.calculateFaileds = 1;

    /* And solve. */
    Slvs_Solve(&sys, g);

    if(sys.result == SLVS_RESULT_OKAY) {
        /* This loop prints points and lines parameters value to check if all
         * is correctly stored. */
        for (int i = 0; i < sys.entities; i++) {
            Slvs_Entity entity = sys.entity[i];
            /* sys.param[sys.entity[i].param[0] - 1]: it's needed to decrease the index
             * of sys.param since the param with handle 0 is reserved but not stored in the array.*/
            if (entity.type == SLVS_E_POINT_IN_2D){
                entityObjects[i]->setProperty("x", sys.param[sys.entity[i].param[0] - 1].val);
                entityObjects[i]->setProperty("y", sys.param[sys.entity[i].param[1] - 1].val);
                std::cout << "P " << sys.entity[i].h << " = (" << sys.param[sys.entity[i].param[0] - 1].val
                        << ", " << sys.param[sys.entity[i].param[1] - 1].val << ")" << std::endl;
            }
            if (entity.type == SLVS_E_LINE_SEGMENT) {
                std::cout << "L " << sys.entity[i].h << " = (" << sys.entity[i].point[0]
                          << ", " << sys.entity[i].point[1] << ")" << std::endl;
            }
        }
    } else {
        int i;
        printf("solve failed: problematic constraints are:");
        for(i = 0; i < sys.faileds; i++) {
            printf(" %d", sys.failed[i]);
        }
        printf("\n");
        if(sys.result !=0) {
            printf("system inconsistent\n");
        } else {
            printf("system nonconvergent\n");
        }
    }
}

int Constraints::getP1Id(QObject* line) {
    QObject* p1 = qvariant_cast<QObject*>(line->property("p1"));
    int p1x = p1->property("x").toInt();
    int p1y = p1->property("y").toInt();
    return pointIdsFromPosition[QVector2D(p1x, p1y)];
}

int Constraints::getP2Id(QObject* line) {
    QObject* p2 = qvariant_cast<QObject*>(line->property("p2"));
    int p2x = p2->property("x").toInt();
    int p2y = p2->property("y").toInt();
    return pointIdsFromPosition[QVector2D(p2x, p2y)];
}

void Constraints::apply(QObject* sketch)
{
//    std::cout << "Constraints start" << std::endl;
    int estimated_memory_need=sketch->children().length()*3;
    if(m_allocated_memory<estimated_memory_need){
        m_allocated_memory=estimated_memory_need*3;
        sys.param      = (Slvs_Param*)CheckMalloc(m_allocated_memory*sizeof(sys.param[0]));
        sys.entity     = (Slvs_Entity*)CheckMalloc(m_allocated_memory*sizeof(sys.entity[0]));
        sys.constraint = (Slvs_Constraint*)CheckMalloc(m_allocated_memory*sizeof(sys.constraint[0]));
        sys.failed  = (Slvs_hConstraint*)CheckMalloc(m_allocated_memory*sizeof(sys.failed[0]));
    }

    sys.faileds = m_allocated_memory;
    sys.dragged[0]=sys.dragged[1]=sys.dragged[2]=sys.dragged[3]=0;
    sys.params = sys.constraints = sys.entities = 0;

    sketch == nullptr ? Example2d(): compute2d(sketch);

//    std::cout << "Constraints end" << std::endl;
}

Constraints::Constraints(QObject *parent):
    QObject(parent)
{
    m_allocated_memory=0;
}

Constraints::~Constraints()
{
    if(m_allocated_memory>0){
        free(sys.param);
        free(sys.entity);
        free(sys.constraint);
        free(sys.failed);
    }
}
