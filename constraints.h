#ifndef CONSTRAINTS_H
#define CONSTRAINTS_H

#include <stdlib.h>
#include <QMap>
#include <QObject>
#include <QVector2D>

class Constraints : public QObject
{
    Q_OBJECT
public:
    Q_INVOKABLE void apply(QObject* sketch);
private:
    void *CheckMalloc(size_t n);
    void compute2d(QObject* sketch);
    void Example2d();
    int getP1Id(QObject* line);
    int getP2Id(QObject* line);

    QMap<QVector2D, int> pointIdsFromPosition;
    QMap<QVector2D, int> linesIdsFromPointIds;

};

#endif // CONSTRAINTS_H
