#pragma once

#include <QQmlEngine>
#include <QQuickImageProvider>
#include <QQuickAsyncImageProvider>
#include <QQuickImageResponse>
#include <QDebug>
#include <QImage>
#include <QThreadPool>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include "networker.h"
#include "imagebinaryloader.h"
#include <QMutex>

class AsyncImageResponse : public QQuickImageResponse, public QRunnable
{
	Q_OBJECT
public:
	AsyncImageResponse(const QString &urlStr, const QSize &requestedSize)
		: m_url(urlStr), m_requestedSize(requestedSize)
	{
		if (!urlStr.isEmpty())
		{
			m_mtx.lock();
			doRun = true;
			m_image = QImage(50, 50, QImage::Format_RGB32);
			loader = new ImageBinaryLoader(this);
			loader->requestImage(urlStr, &m_mtx);
			setAutoDelete(false);
		}
	}

	QQuickTextureFactory *textureFactory() const
	{
		return QQuickTextureFactory::textureFactoryForImage(m_image);
	}

	void run()
	{
		if (!doRun) return;

		QMutexLocker locker(&m_mtx);

		if (!loader->isNotFound())
			m_image.loadFromData(loader->binary());		

		emit finished();
	}

private:
	QString m_url;
	QSize m_requestedSize;
	QImage m_image;
	QMutex m_mtx;

	ImageBinaryLoader* loader;
	bool doRun = false;
};

class AsyncImageProvider : public QQuickAsyncImageProvider
{
public:
	QQuickImageResponse *requestImageResponse(const QString &url, const QSize &requestedSize)
	{
		AsyncImageResponse *response = new AsyncImageResponse(url, requestedSize);
		pool.start(response);
		return response;
	}

private:
	QThreadPool pool;
};
