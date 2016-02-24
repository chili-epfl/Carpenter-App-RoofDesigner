#include "realtoexporter.h"
#include "globals.h"
#include <QFile>
#include <QDateTime>
#include <QTextStream>
#include <QUrl>
#include <QImage>
#include <quazip/JlCompress.h>
#include <QDebug>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QDirIterator>
#include <QDir>

RealtoExporter::RealtoExporter(QObject *parent) : QObject(parent)
{
    m_loading=false;
    connect(this,SIGNAL(pushCompleted()),this,SLOT(finished()));
}

void RealtoExporter::setHost(QString host)
{
    if(host!=m_host){
        m_host=host;
        emit hostChanged();
    }

}

void RealtoExporter::setUsername(QString username)
{
    if(username!=m_username){
        m_username=username;
        emit usernameChanged();
    }
}


void RealtoExporter::pushScenarios(){
    m_loading=true;
    emit loadingChanged();

    if(!QDir(scenariosDir).exists()){
        emit finished();
        return;
    }

    if(!QDir(tmpDir).exists()){
        qDebug()<<"Creating tmp Path";
        QDir().mkpath(tmpDir);
    }

    QDirIterator scenariosIterator(scenariosDir);
    while (scenariosIterator.hasNext()) {
        scenariosIterator.next();
        QString basename;
        if(scenariosIterator.fileInfo().isDir() &&
                scenariosIterator.fileName()!="." &&
                scenariosIterator.fileName()!=".."){
            basename=scenariosIterator.fileName();
            QString png=scenariosIterator.fileInfo().canonicalFilePath()+"/"+
                    basename+".png";
            if(!QFile::exists(png)) continue;
            QFile::copy(scenariosIterator.fileInfo().canonicalFilePath()+"/"+
                        basename+".png", tmpDir+"/"+m_username+"-"+basename+".png");
            JlCompress::compressDir(tmpDir+m_username+"-"+basename+".static_scenario",scenariosIterator.fileInfo().canonicalFilePath());
        }
    }
    /*At this point int tmp we have all the zip*/
    QDir tmpPath(tmpDir);
    QStringList files=tmpPath.entryList();
    Q_FOREACH(QString file, files){
        if(!file.endsWith(".static_scenario")) continue;
        QString basename=file.split(".static_scenario")[0];
        if(!files.contains(basename+".png")) continue;
        QNetworkRequest push;
        QUrl url=m_host;
        QString query="type=request-put&resourceType=scenario&email="+m_username
                +"&filename="+file+"&thumbnail="+basename+".png";
        url.setQuery(query);
        push.setUrl(url);
        PushData pushData;
        pushData.filename=file;
        pushData.thumbnail=basename+".png";
        pushData.replies_S3=0;

        QNetworkReply* reply=manager.get(push);
        connect(reply, SIGNAL(finished()), this, SLOT(slotPushPhase1()));
        connect(reply, SIGNAL(error(QNetworkReply::NetworkError)),
                this, SLOT(slotError()));
        m_pushData_map[reply]=pushData;
    }
    if(m_pushData_map.count()==0)
        emit pushCompleted();
}

void RealtoExporter::slotPushPhase1(){
    QNetworkReply *reply=static_cast<QNetworkReply *>(QObject::sender());
    if(reply->error()==QNetworkReply::NoError){
        QString urlFile, urlThumbnail;
        urlFile=reply->readLine();
        urlFile=urlFile.split("\r\n")[0];

        urlThumbnail=reply->readLine();
        urlThumbnail=urlThumbnail.split("\r\n")[0];

        QNetworkRequest putFile;
        QUrl URLFile=urlFile;
        putFile.setUrl(URLFile);
        QFile* file=new QFile(tmpDir+m_pushData_map[reply].filename);
        file->open(QIODevice::ReadOnly);
        if(!file->isOpen()){
            emit error("Can't open file "+tmpDir+m_pushData_map[reply].filename);
        }else{
            QNetworkReply *replyFile = manager.put(putFile,file);
            connect(replyFile, SIGNAL(finished()), this, SLOT(slotCloseFile()));
            connect(replyFile, SIGNAL(error(QNetworkReply::NetworkError)),
                    this, SLOT(slotError()));
            m_openFile_map[replyFile]=file;


            QNetworkRequest putThumbnail;
            QUrl URLThumbnail=urlThumbnail;
            putThumbnail.setUrl(URLThumbnail);
            QFile* thumbnailFile=new QFile(tmpDir+m_pushData_map[reply].thumbnail);
            thumbnailFile->open(QIODevice::ReadOnly);
            if(!thumbnailFile->isOpen()){
                emit error("Can't open thumbnail "+tmpDir+m_pushData_map[reply].thumbnail);
            }else{
                QNetworkReply *replyThumbnail = manager.put(putThumbnail,thumbnailFile);
                connect(replyThumbnail, SIGNAL(finished()), this, SLOT(slotCloseFile()));
                connect(replyThumbnail, SIGNAL(finished()), this, SLOT(slotThumbnailUploaded()));
                connect(replyThumbnail, SIGNAL(error(QNetworkReply::NetworkError)),
                        this, SLOT(slotError()));
                m_openFile_map[replyThumbnail]=thumbnailFile;
                m_pushData_map[replyThumbnail]=m_pushData_map[reply];
            }}}

    m_pushData_map.remove(reply);
    reply->deleteLater();
    if(m_pushData_map.count()==0){
        emit pushCompleted();
    }
}
void RealtoExporter::slotPushPhase2(){
    QNetworkReply *reply=static_cast<QNetworkReply *>(QObject::sender());
    m_pushData_map.remove(reply);
    reply->deleteLater();
    if(m_pushData_map.count()==0){
        emit pushCompleted();
    }
}
void RealtoExporter::slotThumbnailUploaded(){
    QNetworkReply *reply=static_cast<QNetworkReply *>(QObject::sender());
    if(reply->error()==QNetworkReply::NoError){
        /*Create the Post*/
        QNetworkRequest createPost;
        QUrl createPostURL=m_host;

        QString resourceType="resourceType=scenario";

        QString email="email="+m_username;

        QString filename="filename="+m_pushData_map[reply].filename;
        QString thumbnail="thumbnail="+m_pushData_map[reply].thumbnail;

        QString query=QString("type=create-post&")+email+"&"+resourceType+"&"+filename
                +"&"+thumbnail;
        createPostURL.setQuery(query);
        createPost.setUrl(createPostURL);
        QNetworkReply *postReply = manager.get(createPost);
        connect(postReply, SIGNAL(finished()), this, SLOT(slotPushPhase2()));
        connect(postReply, SIGNAL(error(QNetworkReply::NetworkError)),
                this, SLOT(slotError()));
        m_pushData_map[postReply]=m_pushData_map[reply];
    }
    m_pushData_map.remove(reply);
    reply->deleteLater();
    if(m_pushData_map.count()==0){
        emit pushCompleted();
    }
}
void RealtoExporter::slotCloseFile(){
    QNetworkReply *reply=static_cast<QNetworkReply *>(QObject::sender());
    if(m_openFile_map.contains(reply)){
        QFile* f=m_openFile_map[reply];
        m_openFile_map.remove(reply);
        f->close();
        //f->copy(uploadedDir+f->fileName());
        f->remove();
        f->deleteLater();
    }
    reply->deleteLater();
}

void RealtoExporter::slotError(){
    QNetworkReply *reply=static_cast<QNetworkReply *>(QObject::sender());
    qDebug()<<reply->error();
    if(m_openFile_map.contains(reply)){
        QFile* f=m_openFile_map[reply];
        m_openFile_map.remove(reply);
        f->close();
        f->deleteLater();
    }
    m_pushData_map.remove(reply);
    reply->deleteLater();
    if(m_pushData_map.count()==0){
        emit pushCompleted();
    }
    emit error(reply->errorString());
}

void RealtoExporter::finished()
{
    m_loading=false;
    emit loadingChanged();
}
