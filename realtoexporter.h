#ifndef RealtoExporter_H
#define RealtoExporter_H
#include <QObject>
#include <QNetworkAccessManager>
#include <QUrl>
#include <QNetworkReply>

class QFile;
class RealtoExporter : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString username READ username WRITE setUsername NOTIFY usernameChanged)
    Q_PROPERTY(QString host READ host WRITE setHost NOTIFY hostChanged)
    Q_PROPERTY(bool loading READ loading NOTIFY loadingChanged)

public:
    explicit RealtoExporter(QObject *parent = 0);
    QString host(){return m_host;}
    QString username(){return m_username;}
    void setHost(QString host);
    void setUsername(QString username);
    Q_INVOKABLE void pushScenarios();
    bool loading(){return m_loading;}
signals:
    void usernameChanged();
    void hostChanged();
    void pushCompleted();
    void error(QString err);
    void loadingChanged();

public slots:
    void slotPushPhase1();
    void slotPushPhase2();
    void slotThumbnailUploaded();
    void slotCloseFile();
    void slotError();
    void finished();
private:
    QNetworkAccessManager manager;
    QString m_username;
    QString m_host;
    bool m_loading;

    struct PushData{
        QString filename;
        QString thumbnail;
        short replies_S3;
    };
    QMap<QNetworkReply*, PushData > m_pushData_map;
    QMap<QNetworkReply*, QFile* > m_openFile_map;
};

#endif // RealtoExporter_H
