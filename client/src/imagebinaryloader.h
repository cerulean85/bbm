#pragma once
#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QMutex>
#include <QTimer>

class ImageBinaryLoader : public QObject
{
	Q_OBJECT
public:
	ImageBinaryLoader(QObject *parent = NULL);

	void requestImage(QString urlStr, QMutex* mtx);
	bool isNotFound() { return m_notFound; }

	public slots:
	void httpError(QNetworkReply::NetworkError msg);
    void cleared();

	QByteArray binary() { return m_binary; }

private:
	QNetworkAccessManager m_netManager;
	QNetworkReply* m_netReply;

	QByteArray m_binary;

	QMutex* m_mtx;
	bool m_notFound = false;
};
