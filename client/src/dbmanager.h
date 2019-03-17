#ifndef DBMANAGER_H
#define DBMANAGER_H

#include <QtSql>
#include <QList>
//#include "model.h"

class Notification;
class DBManager  : public QObject
{
    Q_OBJECT

public:

    static DBManager* instance()
    {
        if(m_instance == nullptr)
            m_instance = new DBManager();

        return m_instance;
    }

    void readNotice(int no);
    void removeNotice(int no);
    void readAll();
    void readAddtionNotiItems();
    void removeNoticeAll();

    void updateSearchLog(QString keyword);
    void insertSearchLog(QString keyword);
    void updateSearchLogDate(int row);
    void removeSearchLog(int row);
    void readSearchLogAll();
    void removeSearhLogAll();

    int readNo1(int no);
    int readNo2(int no);

private:

    QString dbName = "";

    DBManager(QObject* parent = NULL);
    static DBManager* m_instance;
    QSqlDatabase m_noticedb;
    void createNoticeTable();
    void createSearchLog();

    int m_noticeOffset = 0;
//    void removeNoticeMsgs(QList<int>& msgIdList);

};

#endif // DBMANAGER_H
