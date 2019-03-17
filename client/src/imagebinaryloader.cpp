#include "imagebinaryloader.h"
#include <QDebug>
#include <QWaitCondition>
#include "networker.h"
#include "model.h"
#include <QPixmap>
#include <QBuffer>
ImageBinaryLoader::ImageBinaryLoader(QObject *parent) : QObject(parent)
{

}

void ImageBinaryLoader::requestImage(QString urlStr, QMutex* mtx)
{
    if(urlStr.isEmpty()) return;
    m_mtx = mtx;

    QString dName = NetWorker::getInstance()->domainName() + "img/";
    if(urlStr.startsWith("http://") || urlStr.startsWith("https://")) dName = "";

    if(Model::getInstance()->useDummy())
        dName = NetWorker::getInstance()->domainNameDummy() + "img/";

    QUrl url(dName + urlStr);
    //    qDebug() << "## LOADED IMAGE FILE NAME : " << dName + urlStr;
    //    qDebug() << "@@ Do Check this >> Have the image url two protocol addresses such as 'http://http://'?" << dName + urlStr;

    QNetworkRequest request(url);
    m_netReply = m_netManager.get(request);
    connect(m_netReply, &QNetworkReply::finished, this,
            [&]()-> void {

                m_binary = m_netReply->readAll();

//                QPixmap pixmap;
//                pixmap.loadFromData(m_netReply->readAll());
//                QPixmap dstPixmap = pixmap.scaled(pixmap.width()/2, pixmap.height()/2, Qt::KeepAspectRatio, Qt::SmoothTransformation);
//                QBuffer buffer(&m_binary);
//                buffer.open(QIODevice::WriteOnly);
//                dstPixmap.save(&buffer, "jpg");

                m_mtx->unlock();
                QWaitCondition cond;
                cond.wakeAll();


                m_netReply->deleteLater();

            });
    connect(m_netReply, QOverload<QNetworkReply::NetworkError>::of(&QNetworkReply::error), this, QOverload<QNetworkReply::NetworkError>::of(&ImageBinaryLoader::httpError));
}

void ImageBinaryLoader::httpError(QNetworkReply::NetworkError msg)
{
    //qDebug() << "[FROM ImageBinaryLoader] THE ERROR WAS OCCURED. " << msg;
    m_notFound = true;
    m_mtx->unlock();
}

void ImageBinaryLoader::cleared()
{
    //qDebug() << "clear!!";
    m_binary.clear();
}
