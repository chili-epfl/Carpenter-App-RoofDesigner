#ifndef JSONSKETCH_H
#define JSONSKETCH_H

#include <QList>
#include <QVector2D>
#include <QJsonObject>
#include <QQuickItem>

class JSONSketch  : public QObject
{
    Q_OBJECT
public:
    explicit JSONSketch(QObject* parent=0);

    Q_INVOKABLE QString loadSketch(const QString url, QObject* sketch);
    Q_INVOKABLE QString exportJSONSketch(const QString url) const;

    Q_INVOKABLE int addPoint(int x, int y);
    Q_INVOKABLE int addLine(int p1, int p2);
    Q_INVOKABLE void removePoint(int id);
    Q_INVOKABLE void removeLine(int id);
private:
    int nextPointId = 0;
    int nextLineId = 0;
    int nb_points = 0;
    int nb_lines = 0;
    QMap<int, QVector2D> points;
    QMap<int, QVector2D> lines;
    QString read(const QJsonObject json, QObject* sketch);
    void generateSketch(QObject* sketch);
    QString write(QJsonObject &json) const;
    int incrementPointsId();
    int incrementLinesId();
};

#endif // JSONSKETCH_H
