#include "dbmanager.h"
#include "native_app.h"
#include "model.h"
#include "networker.h"
#include "enums.h"

DBManager *DBManager::m_instance = nullptr;

DBManager::DBManager(QObject* parent): QObject(parent)
{
    m_noticedb = QSqlDatabase::addDatabase("QSQLITE", "SQLITE_CONNECT");
    QString dbDirPath = "";
#ifdef Q_OS_ANDROID
    dbDirPath = NativeApp::getAppDatabaseDirectoryPath();
#else
    dbDirPath = NativeApp::getTempDirectoryPath(NativeApp::DIR_DATA);
#endif

    QDir tempDir(dbDirPath);
    if(!tempDir.exists())
        if(!tempDir.mkpath("."))
            dbDirPath = ".";

    if(dbDirPath.length() > 0)
    {
        QString dbfilepath = QDir::toNativeSeparators(dbDirPath + "/NoticeData.db");
        m_noticedb.setDatabaseName(dbfilepath);
        createNoticeTable();
        createSearchLog();
    }
}

void DBManager::createNoticeTable()
{
    if(m_noticedb.open())
    {
        QSqlQuery qry(m_noticedb);
        qry.prepare(QString("CREATE TABLE IF NOT EXISTS NOTICES "
                            "(NO INTEGER PRIMARY KEY AUTOINCREMENT, "
                            "TYPE INTEGER, TITLE TEXT, MESSAGE TEXT, IS_READ INTEGER, "
                            "NO1 INTEGER, NO2 INTEGER, "
                            "CREATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP)"));
        qry.exec();
    }
    m_noticedb.close();
}
void DBManager::createSearchLog()
{
    if(m_noticedb.open())
    {
        QSqlQuery qry(m_noticedb);
        qry.prepare(QString("CREATE TABLE IF NOT EXISTS SEARCH_LOG "
                            "(NO INTEGER PRIMARY KEY AUTOINCREMENT, "
                            "KEYWORD TEXT, "
                            "CREATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP)"));

        qry.exec();
    }
    m_noticedb.close();
}

void DBManager::updateSearchLog(QString keyword)
{
    if(m_noticedb.open())
    {
        QSqlQuery qry(m_noticedb);
        qry.prepare(QString("SELECT NO FROM SEARCH_LOG WHERE KEYWORD = '%1'").arg(keyword));
        if(qry.exec())
        {
            if(!qry.first())
            {
                insertSearchLog(keyword);
            }
            else
            {
                int no = qry.value(0).toInt();
                updateSearchLogDate(no);
            }
        }
    }
    m_noticedb.close();
}

void DBManager::insertSearchLog(QString keyword)
{
    QSqlQuery qry(m_noticedb);
    qry.prepare( QString( "INSERT INTO SEARCH_LOG (KEYWORD, CREATED_AT)"
                          " VALUES ('%1', '%2')").arg(keyword).arg(QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss")));
    qry.exec();
}

void DBManager::updateSearchLogDate(int row)
{
    QSqlQuery qry(m_noticedb);
    qry.prepare( QString( "UPDATE SEARCH_LOG SET CREATED_AT = '%1' WHERE NO = %2")
                 .arg(QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss")).arg(row));
    qry.exec();
}

void DBManager::removeSearchLog(int row)
{
    if(m_noticedb.open())
    {
        QSqlQuery qry(m_noticedb);
        qry.prepare(QString("DELETE FROM SEARCH_LOG WHERE NO = %1").arg(row));
        qry.exec();
    }
    m_noticedb.close();
}

void DBManager::readNotice(int no)
{
    if(m_noticedb.open())
    {
        QSqlQuery qry(m_noticedb);
        qry.prepare(QString( "UPDATE NOTICES SET IS_READ=1 WHERE NO=:no"));
        qry.bindValue(":no", no);
        qry.exec();
    }
    m_noticedb.close();
}

void DBManager::removeNotice(int no)
{
    if(m_noticedb.open())
    {
        QSqlQuery qry(m_noticedb);
        qry.prepare(QString( "DELETE FROM NOTICES WHERE NO=:no"));
        qry.bindValue(":no", no);
        qry.exec();
    }
    m_noticedb.close();
}

void DBManager::readAll()
{
    if(m_noticedb.open())
    {
        QSqlQuery qry(m_noticedb);
        qry.prepare(QString("SELECT * FROM NOTICES ORDER BY NO ASC"));
        if( qry.exec() )
        {
            QList<QObject*> list;
            while(qry.next())
            {
                Notification* noti = new Notification();
                noti->setNo(qry.value(0).toInt());
                noti->setType(qry.value(1).toInt());
                noti->setTitle(qry.value(2).toString());
                noti->setMessage(qry.value(3).toString());
                noti->setIsRead(qry.value(4).toInt() != 0);
                noti->setItemNo1(qry.value(5).toInt());
                noti->setItemNo2(qry.value(6).toInt());
                noti->setDateTime(qry.value(7).toString());

                QObject* o = qobject_cast<QObject*>(noti);
                list.append(o);
            }
            Model::getInstance()->setNoticeList(list);
        }
    }
    m_noticedb.close();
}

int DBManager::readNo1(int no)
{
    if(m_noticedb.open())
    {
        QSqlQuery qry(m_noticedb);
        qry.prepare(QString("SELECT NO1 FROM NOTICES WHERE NO = %1").arg(no));
        if( qry.exec() )
        {
            QList<QObject*> list;
            while(qry.next())
            {
                int readNo = qry.value(0).toInt();
                if(readNo > 0)
                {
                    m_noticedb.close();
                    return readNo;
                }
            }
        }
    }
    m_noticedb.close();
    return 0;
}

int DBManager::readNo2(int no)
{
    if(m_noticedb.open())
    {
        QSqlQuery qry(m_noticedb);
        qry.prepare(QString("SELECT NO2 FROM NOTICES WHERE NO = %1").arg(no));
        if( qry.exec() )
        {
            QList<QObject*> list;
            while(qry.next())
            {
                int readNo = qry.value(0).toInt();
                if(readNo > 0)
                {
                    m_noticedb.close();
                    return readNo;
                }
            }
        }
    }
    m_noticedb.close();
    return 0;
}

void DBManager::readAddtionNotiItems()
{
    if(m_noticedb.open())
    {
        QSqlQuery qry(m_noticedb);
        //        qry.prepare(QString("SELECT * FROM NOTICES WHERE NO > %1 ORDER BY NO ASC LIMIT 20").arg(m_noticeOffset));
        qry.prepare(QString("SELECT * FROM NOTICES ORDER BY NO ASC"));

        if(qry.exec())
        {
            QList<QObject*> list;
            while(qry.next())
            {
                Notification* noti = new Notification();
                noti->setNo(qry.value(0).toInt());
                noti->setType(qry.value(1).toInt());
                noti->setTitle(qry.value(2).toString());
                noti->setMessage(qry.value(3).toString());
                noti->setIsRead(qry.value(4).toInt() != 0);
                noti->setItemNo1(qry.value(5).toInt());
                noti->setItemNo2(qry.value(6).toInt());
                noti->setDateTime(qry.value(7).toString());

                QObject* o = qobject_cast<QObject*>(noti);
                list.append(o);
            }
            Model::getInstance()->appendNoticeList(list); //setNoticeList(list);
            NetWorker::getInstance()->setRefreshWorkResult(ENums::FINISHED_PUSHNOTICE);
        }
    }

    m_noticedb.close();
}

void DBManager::removeNoticeAll()
{
    if(m_noticedb.open())
    {
        QSqlQuery qry(m_noticedb);
        qry.prepare(QString( "DELETE FROM NOTICES"));
        qry.exec();
    }
    m_noticedb.close();
}

void DBManager::readSearchLogAll()
{
    if(m_noticedb.open())
    {
        QSqlQuery qry(m_noticedb);
        qry.prepare(QString("SELECT * FROM SEARCH_LOG ORDER BY CREATED_AT DESC"));

        if( qry.exec() )
        {
            QList<QObject*> list;
            while(qry.next())
            {
                Univ* log = new Univ();
                log->setBoardNo(qry.value(0).toInt());
                log->setKeyword(qry.value(1).toString());
                log->setWriteDate(qry.value(2).toString());

                QObject* o = qobject_cast<QObject*>(log);
                list.append(o);
            }
            Model::getInstance()->setSearchLogList(list);
        }
    }
    m_noticedb.close();
}

void DBManager::removeSearhLogAll()
{
    if(m_noticedb.open())
    {
        QSqlQuery qry(m_noticedb);
        qry.prepare(QString( "DELETE FROM SEARCH_LOG"));
        qry.exec();
    }
    m_noticedb.close();
}
