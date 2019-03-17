#pragma once
#include <QObject>
#include <QList>
#include <QDebug>
class Page : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int no READ no WRITE setNo NOTIFY noChanged)
    Q_PROPERTY(QString namePage READ namePage WRITE setNamePage NOTIFY namePageChanged)
    Q_PROPERTY(QString nameStack READ nameStack WRITE setNameStack NOTIFY nameStackChanged)

public:
    Page(int no, QString namePage, QString nameStack) : m_no(no), m_namePage(namePage), m_nameStack(nameStack) { }
    Q_INVOKABLE int no() { return m_no; }
    Q_INVOKABLE QString namePage() { return m_namePage; }
    Q_INVOKABLE QString nameStack() { return m_nameStack; }

public slots:
    void setNo(int m) { m_no = m; emit noChanged();}
    void setNamePage(QString m) { m_namePage = m; emit namePageChanged(); }
    void setNameStack(QString m) { m_nameStack = m; emit nameStackChanged(); }

signals:
    void noChanged();
    void namePageChanged();
    void nameStackChanged();

private:
    int m_no = 0;
    QString m_namePage = "";
    QString m_nameStack = "";
};

class PageManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(Page* item READ item)

public:
    static PageManager* getInstance() {
        if (m_instance == nullptr)
            m_instance = new PageManager();
        return m_instance;
    }

    Q_INVOKABLE void push(QString namePage, QString nameStack)
    {
        int no = m_stack.length();
        m_stack.append(new Page(no, namePage, nameStack));
    }

    Q_INVOKABLE bool pop()
    {
        int length = m_stack.length();
        if(length < 1) return false;
        else m_stack.removeAt(length-1);
        return true;
    }

    Q_INVOKABLE bool top()
    {
        int length = m_stack.length();
        if(length < 1) return false;
        else m_selectedIndex = length-1;
        return true;
    }

    Q_INVOKABLE int count(QString nameStack = "")
    {
        if(nameStack.isEmpty()) return m_stack.length();

        int cnt = 0;
        for(QObject* o : m_stack)
        {
            Page* p = qobject_cast<Page*>(o);
            if(!p->nameStack().compare(nameStack)) cnt++;
        }
        return cnt;
    }

    Q_INVOKABLE void clear(QString nameStack)
    {
        int index=0;
        while(index < m_stack.length())
        {
            Page* page = qobject_cast<Page*>(m_stack[index]);
            if(!page->nameStack().compare(nameStack))
            {
                m_stack.removeAt(index);
            }
            else index++;
        }
    }

    Q_INVOKABLE bool searchByIndex(int index)
    {
        int length = m_stack.length();
//        qDebug() << "searchByIndex: " << length << ", " << index;
        if(length < 1 || index < 0) return false;
        if(index >= length) return false;
        else m_selectedIndex = index;
        return true;
    }

    Q_INVOKABLE int getIndexByName(QString pageName)
    {
        int index = 0;
        for(QObject* o : m_stack)
        {
            Page* p = qobject_cast<Page*>(o);
            if(!p->namePage().compare(pageName)) return index;
            else index++;
        }
        return -1;
    }

    Q_INVOKABLE int length() { return m_stack.length(); }

    Q_INVOKABLE Page* item() { return qobject_cast<Page*>(m_stack[m_selectedIndex]); }

    Q_INVOKABLE void printPageInfo()
    {
        for(QObject* o : m_stack)
        {
            Page* p = qobject_cast<Page*>(o);
            message("Name: " + p->namePage() + ", STACK: " + p->nameStack());
        }
    }

    Q_INVOKABLE QString getPageNameByIndex(int index)
    {
        message("Searched Index: " + numToString(index));
        if(searchByIndex(index))
        {
            Page* p = qobject_cast<Page*>(m_stack[index]);
            return p->namePage();
        }
        return "undefined";
    }

    Q_INVOKABLE bool comparePrevPage(QString pageName)
    {
        int index = length()-2;
        if(index < 0) return false;
        QString topPageName = getPageNameByIndex(index);
        return !topPageName.compare(pageName);
    }

    Q_INVOKABLE bool compareCurrentPage(QString willPushPage)
    {
        int index = length()-1;
        if(index < 0) return false;
        QString topPageName = getPageNameByIndex(index);
        return !topPageName.compare(willPushPage);
    }

    Q_INVOKABLE void setMainTabName(QString tabName) { m_mainTabName = tabName; }
    Q_INVOKABLE QString getMainTabName() { return m_mainTabName; }
    Q_INVOKABLE void setLikeTabName(QString tabName) { m_likeTabName = tabName; }
    Q_INVOKABLE QString getLikeTabName() { return m_likeTabName; }

private:
    static PageManager* m_instance;
    PageManager() { }

    QList<QObject*> m_stack;
    int m_selectedIndex = 0;
    QString m_mainTabName;
    QString m_likeTabName;

    void message(QString msg)
    {
//        qDebug() << msg;
    }

    QString numToString(int num)
    {
        return QString("%1").arg(num);
    }
};
