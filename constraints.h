#ifndef CONSTRAINTS_H
#define CONSTRAINTS_H

#include <array>
#include <stdlib.h>
#include <QList>
#include <QMap>
#include <QObject>
#include <QVector2D>
#include <slvs.h>

class Constraints : public QObject
{
    Q_OBJECT
public:
    Q_INVOKABLE void apply(QObject* sketch);
    Q_INVOKABLE void solve();
    Constraints(QObject* parent=Q_NULLPTR);
    ~Constraints();
private:

    void *CheckMalloc(size_t n);
    void compute2d(QObject* sketch);
    int getPointId(QObject* line, const char* pointPropertyName) const;

    QMap<QVector2D, int> pointIdsFromPosition;
    QMap<QVector2D, int> linesIdsFromPointIds;

    int m_allocated_memory;
    Slvs_System sys;
    QMap<int, QObject*> entityObjects;
};

#endif // CONSTRAINTS_H
