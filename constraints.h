#ifndef CONSTRAINTS_H
#define CONSTRAINTS_H

#include <stdlib.h>
#include <QObject>

class Constraints : public QObject
{
    Q_OBJECT
public:
    Q_INVOKABLE static void apply(QObject* sketch);
private:
    static void *CheckMalloc(size_t n);
    static void compute2d(QObject* sketch);
    static void Example2d();
};

#endif // CONSTRAINTS_H
