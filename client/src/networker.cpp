#include "networker.h"
#include <QMutexLocker>
#include <QHttpMultiPart>
#include "imageresponseprovider.h"
#include "settings.h"
#include "model.h"
#include "native_app.h"
#include "enums.h"
#include <QTimer>

NetWorker* NetWorker::m_instance = nullptr;
NetWorker::NetWorker(QObject *parent) : QObject(parent)
{
    settings = Settings::getInstance();
    m = Model::getInstance();
    ap = AlarmPopup::getInstance();

    m_watcher = new QTimer(this);
    m_watcher->setInterval(5000);
    connect(m_watcher, SIGNAL(timeout()), this, SLOT(watch()));
    connect(this, SIGNAL(next()), this, SLOT(request()));
}
NetWorker::~NetWorker()
{
    //delete m;
}

void NetWorker::watch()
{
    QMutexLocker locker(&m_mtx);
    int length = m_hosts.length();
    if(length > 0)
    {
        if(m_hosts[length-1]->requestCount() > 1)
        {
            m_hosts.clear();
            QString message = "네트워크 환경이 원활하지 않습니다. 네트워크 환경을 확인해주세요.";
            if(NativeApp::getInstance()->isOnline() == 0)
                message = "네트워크가 연결되어 있지 않습니다. 네트워크 환경을 확인해주세요";
            m->setError(message);
            error();
        } else request();
    }

    m_watcher->stop();
    message("watched!");
}

void NetWorker::request()
{
#if defined(Q_OS_ANDROID)
        if(m_andNet.isEmpty()) return;
        (m_andNet.dequeue())();
        return;
#endif

    if(NativeApp::getInstance()->isOnline() == 0)
    {
        m_hosts.clear();
        m->setError("네트워크가 연결되어 있지 않습니다. 네트워크 상태를 확인해주세요.");
        error();
        return;
    }

    if (m_hosts.isEmpty()) return;

    NetHost* host = (m_hosts.front())->increaseRequestCount();
    if(!m_watcher->isActive()) m_watcher->start();
    QNetworkRequest req;

    bool useDummy = host->dummy();
    QString requestUrl = m_domainName + host->addr();
    if(useDummy) requestUrl = m_domainNameDummy + host->addr();


    if (!host->type().compare("post"))
    {
        QUrl url(requestUrl);
        QNetworkRequest req(url);
        if(requestUrl.startsWith("https"))
        {
            QSslConfiguration conf = req.sslConfiguration();
            conf.setProtocol(QSsl::TlsV1_2);
            req.setSslConfiguration(conf);
        }

        req.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded;charset=UTF-8");
        m_netReply = m_netManager.post(req, host->queries().toString(QUrl::FullyDecoded).toUtf8());
    }
    else if (!host->type().compare("get"))
    {
        req = createRequest(host->addr(), host->queries(), useDummy);
        m_netReply = m_netManager.get(req);
    }
    else if (!host->type().compare("file"))
    {
        QHttpMultiPart *multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);
        QHttpPart imagePart;
        imagePart.setHeader(QNetworkRequest::ContentTypeHeader, QVariant("image/jpeg")); /*jpeg*/
        imagePart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"file\"; filename=\"" + host->file() + "\""));

        QHttpPart txtPart;
        txtPart.setHeader(QNetworkRequest::ContentDispositionHeader,QVariant("form-data; name=\"file_name\""));
        QList<QPair<QString, QString>> qItems = host->queries().queryItems();
        int size = qItems.size();
        for(int i=0; i<size; i++)
        {
            QPair<QString, QString> p = qItems.at(i);
            if(!p.first.compare("file_name"))
            {
                txtPart.setBody(p.second.toUtf8());
                break;
            }
        }

        QFile *file = new QFile(host->file());
        file->open(QIODevice::ReadOnly);
        imagePart.setBodyDevice(file);
        file->setParent(multiPart);
        multiPart->append(imagePart);
        multiPart->append(txtPart);

        qItems = host->queries().queryItems();
        size = qItems.size();
        if (size > 0)
        {
            for(int i=0; i<size; i++)
            {
                QPair<QString, QString> p = qItems.at(i);
                if(!p.first.compare("file_name")) continue;

                QHttpPart param;
                param.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"" + p.first +"\""));
                param.setBody(p.second.toLatin1());
                multiPart->append(param);
            }
        }

        QUrl url(requestUrl);
        if (!host->queries().isEmpty())
            url.setQuery(host->queries());

        req.setUrl(url);
        m_netReply = m_netManager.post(req, multiPart);
        multiPart->setParent(m_netReply);


        /*QUrl url(DOMAIN_NAME + host->addr());
        QNetworkRequest req(url);
        req.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded;charset=UTF-8");
        m_netReply = m_netManager.post(req, multiPart);
        multiPart->setParent(m_netReply);*/
    }
    else return;

    message("########## NETWORK INFORMATION ##########");
    QString msg = requestUrl;
    QList<QPair<QString, QString>> qItems = host->queries().queryItems();
    int size = qItems.size();
    if (size > 0)
    {
        for(int i=0; i<size; i++)
        {
            QPair<QString, QString> p = qItems.at(i);
            msg  += "\n[" + QString::number(i + 1) + "] key: " + p.first  + ", value: " +  p.second;
        }
    }
    message("TO : " + msg, true);
    message("#########################################\n");

    connect(m_netReply, QOverload<QNetworkReply::NetworkError>::of(&QNetworkReply::error), this, QOverload<QNetworkReply::NetworkError>::of(&NetWorker::httpError));
    connect(m_netReply, &QNetworkReply::finished, host->func());
    connect(m_netReply, SIGNAL(uploadProgress(qint64, qint64)), this, SLOT(progress(qint64, qint64)));
    m_hosts.pop_front();
}

void NetWorker::progress(qint64 a, qint64 b)
{
    Q_UNUSED(a)
    Q_UNUSED(b)
    //    qDebug() << a << "/" << b;
}

QNetworkRequest NetWorker::createRequest(QString suffixUrl, QUrlQuery queries, bool useDummy)
{
    QString dName = m_domainName + suffixUrl;
    if(useDummy) dName = m_domainNameDummy + suffixUrl;

    QUrl url(dName);
    if (!queries.isEmpty())
        url.setQuery(queries);

    QNetworkRequest request(url);
    if(dName.startsWith("https"))
    {
        QSslConfiguration conf = request.sslConfiguration();
        conf.setProtocol(QSsl::TlsV1_2);
        request.setSslConfiguration(conf);
    }
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded;charset=UTF-8");

    queries.clear();
    return request;
}

void NetWorker::httpError(QNetworkReply::NetworkError msg)
{
    Q_UNUSED(msg)
    message("[**] THE ERROR WAS OCCURED. ");
}

bool NetWorker::isSuccess(QJsonObject jsonObj)
{
    if(!jsonObj["is_success"].toBool())
    {
        m->setShowIndicator(false);
        m->setError(jsonObj["error_message"].toString());
        message("@@ Can't connect to the server as the following reason. >>" + jsonObj["error_message"].toString());
        return false;
    }
    message("@@ SERVER succeeded to Connect. ");
    return true;
}

bool NetWorker::isOpen(QJsonObject jsonObj)
{
    if(!jsonObj["is_open"].toBool())
    {
        m->setShowIndicator(false);
        m->setError("서버에 연결할 수 없습니다.");
        //        m->setError(jsonObj["error_message"].toString());
        message("@@ Can't open to the server as follwing reason. >> " + jsonObj["close_message"].toString());
        return false;
    }
    message("@@ SERVER succeeded to Open.");
    return true;
}
bool NetWorker::isLogined(QJsonObject jsonObj)
{
    if(jsonObj["is_login"].isBool())
        return jsonObj["is_login"].toBool(); // .toInt() > 0 ? true : false;
    else
        return jsonObj["is_login"].toInt() > 0 ? true : false;
}

void NetWorker::setSession(QJsonObject jsonObj)
{
    bool needLogin = settings->logined();
    bool sessionConnected = isLogined(jsonObj);

    if(needLogin)
    {
        if(!sessionConnected)
        {
            message("setSession Cleared");
            settings->clearUser();
            setSessionState(ENums::NEED_BUT_UNCONNECTED);
        }
        else m_delayedHosts.clear();
    }
}

void NetWorker::error()
{
    message("error");
    ap->setVisible(true);
    ap->setButtonCount(1);
    ap->setMessage(m->error());
    ap->setYButtonName("확인");
    ap->setYMethod(this, "empty");
}

void NetWorker::alarm(QString msg)
{
    message("alarm: " + msg);
    ap->setVisible(true);
    ap->setButtonCount(1);
    ap->setMessage(msg);
    ap->setYButtonName("확인");
    ap->setYMethod(this, "empty");
}

void NetWorker::getSystemInfo()
{
    NativeApp* app = NativeApp::getInstance();

#if defined(Q_OS_ANDROID)
    settings->setOsType(0);
#endif

#if defined(Q_OS_IOS)
    settings->setOsType(1);
#endif

    /**/
    QString deviceId = app->getDeviceId();
    settings->setDeviceId(deviceId);

    QString deviceName = app->getDeviceName();
    settings->setDeviceName(deviceName);

    QString pushkey = settings->nativePushkey();
#if defined(Q_OS_ANDROID)
    if(pushkey.isEmpty())
    {
        settings->setNativePushkey(app->getPushkey());
        pushkey = settings->nativePushkey();
    }
#endif

    float versionOS = app->versionOS();
    settings->setVersOS(versionOS);
    message("##### NATIVE DEVICE INFORMATION #####");
    message("1. DEVICE ID   : " + deviceId);
    message("2. DEVICE NAME : " + deviceName);
    message("3. PUSH KEY    : " + pushkey);
    message("4. OS VERSION  : " + QString::number(versionOS));
    message("#####################################");

#if defined(Q_OS_ANDROID)
//    m_andNet.enqueue([&]()->void { app->andGetSystemInfo(); });
    m_andNet.append([&]()->void { app->andGetSystemInfo(); });
    connect(app, SIGNAL(procGetSystemInfoResult(QByteArray)), this, SLOT(procGetSystemInfoResult(QByteArray)));
    return;
#endif
    m_hosts.append(new NetHost("post", "getSystemInfo", [&]()-> void { procGetSystemInfoResult(m_netReply->readAll()); }));
    return;
}

void NetWorker::procGetSystemInfoResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procGetSystemInfoResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    if(isOpen(jsonObj))
    {
        if(isSuccess(jsonObj))
        {
//            QString latestVersion = jsonObj["version"].toString();
            QString latestVersion = "";
            #if defined(Q_OS_ANDROID)
            latestVersion = jsonObj["android_version"].toString();
            #elif defined(Q_OS_IOS)
            latestVersion = jsonObj["ios_version"].toString();
            #endif

            QString evtUrl = jsonObj["event_popup_url"].toString();
            QString andOSVers = jsonObj["android_min_version"].toString();
            QString iosOSVers = jsonObj["ios_min_version"].toString();
            message("LatestVersion" + latestVersion + "/" + evtUrl  + "/" + andOSVers + "/" + iosOSVers);

            settings->setVersServer(latestVersion);
            message("## Server Version : " + latestVersion);
            settings->setEventUrl(jsonObj["event_popup_url"].toString());
            message("## Event Url: " + settings->eventUrl());

            float versionOS = NativeApp::getInstance()->versionOS();
            #if defined(Q_OS_ANDROID)
            settings->setVersOS(andOSVers.toFloat());
            #elif defined(Q_OS_IOS)
            settings->setVersOS(iosOSVers.toFloat());
            #endif

            //versionOS = 9; // FOR TEST.
            if(versionOS < settings->versOS())
            {
                m->setNeedUpdateOS(true);
                deleteLater();
                emit next();
                return;
            }

            QString currentAppVersion = NativeApp::getInstance()->appVersionName();
            message("App Version Check: " + latestVersion + " // " + currentAppVersion);
            if(latestVersion.compare(currentAppVersion))
            {
                m->setNeedUpdateApp(true);
                return;
            }

            ListParser* p = (new ListParser("getSystemInfo", ""))->setObj(jsonObj)->start();
            m->noticePopup()->setBoardNo(p->dInt("board_no"));
            m->noticePopup()->setBoardArticleNo(p->dInt("board_article_no"));
            m->noticePopup()->setTitle(p->dStr("popup_title"));
            m->noticePopup()->setImageUrl(p->dStr("image_url"));
            m->noticePopup()->setPopupNo(p->dInt("popup_no"));
            p->end()->close();

            /* NEED UPDATE */

            settings->setVersCurrentApp(latestVersion);

            QJsonArray jsonArr = jsonObj["data_list"].toArray();
            QList<QObject*> list;
            int noCategory = 0;
            QString title = "전체";

            Category* d = new Category();
            d->setId(noCategory);
            d->setName(title);
            QObject* o = qobject_cast<QObject*>(d);
            list.append(o);

            foreach(const QJsonValue &value, jsonArr)
            {
                QJsonObject obj = value.toObject();
                d = new Category();

                noCategory = dInt(obj, 1, "category_no");
                title = dStr(obj, 1, "title");

                d->setId(noCategory);
                d->setName(title);

                QObject* o = qobject_cast<QObject*>(d);
                list.append(o);
            }
            if(list.size() > 0)
            {
                Category* o = qobject_cast<Category*>(list[0]);
                o->select(true);
            }
            m->setCategoryList(list);
            m->setCheckedSystem(ENums::POSITIVE);
            emit m->categorylistChanged();
        }

        setGetSystemInfoResult(ENums::POSITIVE);
    }
    else
    {
        m->setError(jsonObj["close_message"].toString());
        m->setCheckedSystem(ENums::NOT_OPENED);
        setGetSystemInfoResult(ENums::NAGATIVE);
    }

    deleteLater();
    emit next();
}

void NetWorker::setPushkey()
{
    QString pushKey = NativeApp::getInstance()->getPushkey();
    settings->setNativePushkey(pushKey);

#if defined(Q_OS_ANDROID)
    form.deviceId = settings->deviceId();
    form.osType = QString("%1").arg(settings->osType());
    form.deviceName = settings->deviceName();
    form.pushkey = settings->nativePushkey();
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andSetPushkey(form.deviceId, form.osType, form.deviceName, form.pushkey); });
    connect(NativeApp::getInstance(), SIGNAL(procSetPushkeyResult(QByteArray)), this, SLOT(procSetPushkeyResult(QByteArray)));
    return;
#endif

    QUrlQuery q;
    q.addQueryItem("device_id", settings->deviceId());
    q.addQueryItem("os_type", QString("%1").arg(settings->osType()));
    q.addQueryItem("device_name", settings->deviceName());
    q.addQueryItem("pushkey", settings->nativePushkey());

    FUNC func = [&]()-> void { procSetPushkeyResult(m_netReply->readAll()); };
    m_hosts.append(new NetHost("post", "setPushkey", q, func));
    m_delayedHosts.append(new NetHost("post", "setPushkey", q, func));

}

void NetWorker::procSetPushkeyResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procSetPushkeyResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();
    setSession(jsonObj);
    deleteLater();
    emit next();
}

void NetWorker::setContactUS(QString title, QString contents, int courseNo)
{
    QString pushKey = NativeApp::getInstance()->getPushkey();
    settings->setNativePushkey(pushKey);

    form.email = Settings::getInstance()->email();
    form.title =  toUnicode(title);
    form.contents = toUnicode(contents);
#if defined(Q_OS_ANDROID)

    form.courseNo = QString("%1").arg(courseNo);

    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andSetContactUS(form.email, form.contents, form.title, form.courseNo); });
    connect(NativeApp::getInstance(), SIGNAL(procSetContactUSResult(QByteArray)), this, SLOT(procSetContactUSResult(QByteArray)));
    return;
#endif

    QUrlQuery q;
    q.addQueryItem("email", form.email);
    q.addQueryItem("title", form.title);
    q.addQueryItem("contents", form.contents);
    q.addQueryItem("course_no", QString("%1").arg(courseNo));

    FUNC func = [&]()-> void { procSetContactUSResult(m_netReply->readAll()); };
    m_hosts.append(new NetHost("post", "setContactUS", q, func));
}

void NetWorker::procSetContactUSResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procSetContactUSResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();
    if(isOpen(jsonObj) && isSuccess(jsonObj))
    {
        setSetContactUSResult(ENums::POSITIVE);
        setSession(jsonObj);
    }
    else
    {
        m->setShowIndicator(false);
        error();
    }

    deleteLater();
    emit next();
}


void NetWorker::join(QString id, QString pass, QString name, QString nickname, QString email, int sex, QString birth)
{
    birth.insert(4, "-");
    birth.insert(7, "-");

#if defined(Q_OS_ANDROID)
    form.id = id;
    form.pass = pass;
    form.name = name;
    form.nickname = nickname;
    form.birth = birth;
    form.gender = QString("%1").arg(sex);
    form.phone = settings->phone();
    form.osType = QString("%1").arg(settings->osType());
    form.deviceId = settings->deviceId();
    form.deviceName = settings->deviceName();
    form.snsType = QString("%1").arg(settings->snsType());
    form.pushkey = settings->nativePushkey();
    form.email = email;
    form.accessToken = settings->accessToken();
    form.agreeUse = QString("%1").arg(m->checkedClause1());
    form.agreeUserInfo = QString("%1").arg(m->checkedClause2());
    form.agreeThird = QString("%1").arg(m->checkedClause3());
    form.agreeEvent = QString("%1").arg(0);
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andJoin(form.id, form.pass, form.name,
                                   form.nickname, form.birth, form.gender,
                                   form.phone, form.osType, form.deviceId,
                                   form.deviceName, form.snsType, form.pushkey,
                                   form.email, form.accessToken, form.accessToken,
                                   form.agreeUse, form.agreeUserInfo, form.agreeThird, form.agreeEvent); });
    connect(NativeApp::getInstance(), SIGNAL(procJoinResult(QByteArray)), this, SLOT(procJoinResult(QByteArray)));
    return;

#endif
    QString pushkey = settings->nativePushkey();
    QString deviceId = settings->deviceId();
    QString deviceName = settings->deviceName();
    QString snsType = QString("%1").arg(settings->snsType());
    QString accessToken = settings->accessToken();
    QString phone = settings->phone();
    QString osType = QString("%1").arg(settings->osType());
    QString gender = QString("%1").arg(sex);
    QString agreeUse = QString("%1").arg(m->checkedClause1());
    QString agreeUserInfo = QString("%1").arg(m->checkedClause2());
    QString agreeThird = QString("%1").arg(m->checkedClause3());
    QString agreeEvent = QString("%1").arg(0); //m->checkedClause4();

    QUrlQuery q;
    q.addQueryItem("id", id);
    q.addQueryItem("password", pass);
    q.addQueryItem("name", name);
    q.addQueryItem("nickname", nickname);
    q.addQueryItem("birth", birth);
    q.addQueryItem("gender", gender);
    q.addQueryItem("phone", phone);
    q.addQueryItem("os_type", osType);
    q.addQueryItem("device_id", deviceId);
    q.addQueryItem("device_name", deviceName);
    q.addQueryItem("sns_type", snsType);
    q.addQueryItem("pushkey", pushkey);
    q.addQueryItem("email", email);
    q.addQueryItem("sns_access_token", accessToken);
    q.addQueryItem("sns_refresh_token", accessToken);
    q.addQueryItem("agree_use", agreeUse);
    q.addQueryItem("agree_user_info", agreeUserInfo);
    q.addQueryItem("agree_third", agreeThird);
    q.addQueryItem("agree_event", agreeEvent);

    message("###########################################################");
    message("id : " + phone);
    message("password : " + pass);
    message("name : " + name);
    message("nickname : " + nickname);
    message("birth : " + birth);
    message("gender : " + gender);
    message("phone : " + phone);
    message("os_type : " + osType);
    message("device_id : " + deviceId);
    message("device_name : " + deviceName);
    message("sns_type : " + snsType);
    message("pushkey : " + pushkey);
    message("email : " + email);
    message("sns_access_token : " + accessToken);
    message("sns_refresh_token : " + accessToken);
    message("agree_use : " + agreeUse);
    message("agree_user_info : " + agreeUserInfo);
    message("agree_third : " + agreeThird);
    message("agree_event : " + agreeEvent);
    message("###########################################################");

    m_hosts.append(new NetHost("post", "join", q, [&]()-> void { procJoinResult(m_netReply->readAll()); }));

}

void NetWorker::procJoinResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procJoinResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    if(isOpen(jsonObj) && isSuccess(jsonObj)) setJoinResult(ENums::POSITIVE);
    else error();

    deleteLater();
    emit next();
}

void NetWorker::login()
{
    form.id = settings->id();
    form.pass = settings->password();
    if(form.id.isEmpty()) return;

    form.snsType = QString("%1").arg(settings->snsType());
#if defined(Q_OS_ANDROID)
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andLogin(form.id, form.pass, form.snsType); });
    connect(NativeApp::getInstance(), SIGNAL(procLoginResult(QByteArray)), this, SLOT(procLoginResult(QByteArray)));
    return;
#endif

    QUrlQuery q;
    q.addQueryItem("id", form.id);
    q.addQueryItem("password", form.pass);
    q.addQueryItem("id_type", form.snsType);
    m_hosts.append(new NetHost("post", "login", q, [&]()-> void { procLoginResult(m_netReply->readAll()); }));
}

void NetWorker::procLoginResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procLoginResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();
    if(!isOpen(jsonObj)) error(); //setLoginResult(ENums::NAGATIVE);
    else
    {
        if(isSuccess(jsonObj))
        {
            int     userNo              = jsonObj["user_no"].toInt();
            int     roleCode            = jsonObj["role_code"].toInt();

            QString nickname            = jsonObj["nickname"].toString();
            QString name                = jsonObj["name"].toString();
            QString email               = jsonObj["email"].toString();
            QString phone               = jsonObj["phone"].toString();
            QString pushkey             = jsonObj["pushkey"].toString();
            QString profileImage        = jsonObj["profile_image"].toString();
            QString profileThumbnailUrl = jsonObj["profile_thumbnail_url"].toString();
            int     pushStatus          = jsonObj["push_status"].toInt();
            int     totalScore          = jsonObj["total_score"].toInt();
            int     snsType             = jsonObj["sns_type"].toInt();
            QString recentDate          = jsonObj["recent_date"].toString();
            QString pushTime            = jsonObj["push_time"].toString();
            int     pushType            = jsonObj["push_type"].toInt();
            int     eventType           = jsonObj["event_type"].toInt();
            int     score               = jsonObj["score"].toInt();
            QString imageUrl            = jsonObj["image_url"].toString();
            QString textDescription     = jsonObj["text_description"].toString();

            message("[LOGIN] Succeeded to login.");
            message("###################  LOGIN RESULT  ###################");
            message("1.  userNo : " + numToStr(userNo));
            message("2.  roleCode : " + numToStr(roleCode));
            message("3.  name : " + name);
            message("4.  nickname : " + nickname);
            message("5.  phone : " + phone);
            message("6.  pushStatus : " + numToStr(pushStatus));
            message("7.  pushkey : " + pushkey);
            message("8.  profileImage : " + profileImage);
            message("9.  profileThumbnailUrl : " + profileThumbnailUrl);
            message("10. totalScore : " + numToStr(totalScore));
            message("11. snsType : " + numToStr(snsType));
            message("12. email : " + email);
            message("13. recentDate : " + recentDate);
            message("14. pushTime : " + pushTime);
            message("15. pushType : " + numToStr(pushType));
            message("16. eventType : " + numToStr(eventType));
            message("17. score : " + numToStr(score));
            message("18. imageUrl : " + imageUrl);
            message("19. textDescription : " + textDescription);

            message("#######################################################");

            bool autoLogin = settings->autoLogin();
            settings->clearUser();
            settings->setAutoLogin(autoLogin);
            settings->setLogined(true);
            setSessionState(ENums::NEED_AND_CONNECTED);
            settings->setNoUser(userNo);
            settings->setRoleCode(roleCode);
            settings->setName(name);
            settings->setNickName(nickname);
            settings->setPhone(phone);
            settings->setPushStatus(pushStatus);

            QString nativePushkey = settings->nativePushkey();
            QString servedPushkey = pushkey;

            settings->setPushkey(nativePushkey);
            if(nativePushkey.compare(servedPushkey)) setPushkey();

            settings->setProfileImage(profileImage);
            settings->setThumbnailImage(profileThumbnailUrl);
            settings->setTotalHavePoint(totalScore);
            settings->setSnsType(snsType);
            settings->setEmail(email);
            settings->setRecentDate(recentDate);

            /* PUSH TIME SET. */
            QStringList times = pushTime.split(":");
            if(times[0].toInt() - 12 > 0)
            {
                settings->setPushTimeAMPM(1);
                settings->setPushTimeHour(times[0].toInt() - 12   -1); /* -1: 클라이언트 보정값 */
            }
            else
            {
                settings->setPushTimeAMPM(0);
                settings->setPushTimeHour(times[0].toInt()   -1); /* -1: 클라이언트 보정값 */
            }
            settings->setPushTimeMinutes(times[1].toInt() == 0 ? 0 : 1);

            settings->setPushTime(pushTime);
            settings->setPushType(pushType);
            settings->setEventType(eventType);
            settings->setEventScore(score);
            settings->setEventImageUrl(imageUrl);
            settings->setEventDesc(textDescription);

            settings->setId(form.id);
            settings->setPassword(form.pass);
            setLoginResult(ENums::POSITIVE);
        }
        else
        {
            switch(form.snsType.toInt())
            {
            case ENums::SELF:
            {
                message("Failed to login as email.");
                getMain(1, "");
                error();
                break;
            }
            case ENums::KAKAO:
            case ENums::FACEBOOK:
            {
                message("Failed to login as sns.");
                /* TO LOGIN SNS */
                QString id = settings->id(); /* FOR SNS LOGIN. */
                int snsType = settings->snsType(); /* FOR SNS LOGIN. */
                QString accessToken = settings->accessToken(); /* FOR SNS LOGIN. */
                settings->clearUser();

                settings->setId(id);
                settings->setSnsType(snsType);
                settings->setAccessToken(accessToken);
                setLoginResult(ENums::NAGATIVE);
                break;
            }
            }
        }

    }

    deleteLater();
    emit next();
}

int NetWorker::withdraw(QString comment)
{
    if(!isValidUser()) return 0;

#if defined(Q_OS_ANDROID)
    form.comment = toUnicode(comment);
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andWithdraw(form.comment); });
    connect(NativeApp::getInstance(), SIGNAL(procWithdrawResult(QByteArray)), this, SLOT(procWithdrawResult(QByteArray)));
    return 1;
#endif

    QUrlQuery q;
    q.addQueryItem("comment", comment);
    m_hosts.append(new NetHost("post", "withdraw", q, [&]()-> void { procWithdrawResult(m_netReply->readAll()); }));
    return 1;
}

void NetWorker::procWithdrawResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procWithdrawResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    if(isOpen(jsonObj) && isSuccess(jsonObj))
    {
        settings->clearUser();
        setWithdrawResult(ENums::POSITIVE);
    }
    else
    {
        settings->clearUser();
        error();
    }

    deleteLater();
    emit next();
}

int NetWorker::logout()
{
    if(!isValidUser()) return 0;

#if defined(Q_OS_ANDROID)
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andLogout(); });
    connect(NativeApp::getInstance(), SIGNAL(procLogoutResult(QByteArray)), this, SLOT(procLogoutResult(QByteArray)));
    return 1;
#endif
    QUrlQuery q;
    m_hosts.append(new NetHost("post", "logout", q, [&]()-> void { procLogoutResult(m_netReply->readAll()); }));
    return 1;
}

void NetWorker::procLogoutResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procLogoutResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    if(isOpen(jsonObj) && isSuccess(jsonObj))
    {
        settings->clearUser();
        setLogoutResult(ENums::POSITIVE);
    }
    else
    {
        settings->clearUser();
        error();
    }

    deleteLater();
    emit next();
}

int NetWorker::setPushStatus(int pushStatus)
{
    if(!isValidUser()) return 0;

#if defined(Q_OS_ANDROID)
    form.pushStatus = QString("%1").arg(pushStatus);
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andSetPushStatus(form.pushStatus); });
    connect(NativeApp::getInstance(), SIGNAL(procSetPushStatusResult(QByteArray)), this, SLOT(procSetPushStatusResult(QByteArray)));
    return 1;
#endif
    QUrlQuery q;
    q.addQueryItem("push_status", QString("%1").arg(pushStatus));
    m_hosts.append(new NetHost("post", "setPushStatus", q, [&]()-> void { procSetPushStatusResult(m_netReply->readAll()); }));
    return 1;
}

void NetWorker::procSetPushStatusResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procSetPushStatusResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();
    if(isOpen(jsonObj) && isSuccess(jsonObj)) setSetPushStatusResult(ENums::POSITIVE);
    else setSetPushStatusResult(ENums::NAGATIVE);

    deleteLater();
    emit next();
}

void NetWorker::findID(QString name, QString birth, QString phone)
{
    birth.insert(4, "-");
    birth.insert(7, "-");

#if defined(Q_OS_ANDROID)
    form.name = name;
    form.birth = birth;
    form.phone = phone;
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andFindID(form.name, form.birth, form.phone); });
    connect(NativeApp::getInstance(), SIGNAL(procFindIDResult(QByteArray)), this, SLOT(procFindIDResult(QByteArray)));
    return;
#endif
    QUrlQuery q;
    q.addQueryItem("name", name);
    q.addQueryItem("birth", birth);
    q.addQueryItem("phone", phone);
    m_hosts.append(new NetHost("post", "findUserID", q, [&]()-> void { procFindIDResult(m_netReply->readAll()); }));
}

void NetWorker::procFindIDResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procFindIDResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();
    if(isOpen(jsonObj) && isSuccess(jsonObj))
    {
        m->setMessageStr(jsonObj["user_id"].toString());
        setFindIDResult(ENums::POSITIVE);
    }
    else error();

    deleteLater();
    emit next();
}

void NetWorker::findPassword(QString id, QString email)
{

#if defined(Q_OS_ANDROID)
    form.id = id;
    form.email = email;
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andFindPassword(form.id, form.email); });
    connect(NativeApp::getInstance(), SIGNAL(procFindPasswordResult(QByteArray)), this, SLOT(procFindPasswordResult(QByteArray)));
    return;
#endif
    QUrlQuery q;
    q.addQueryItem("user_id", id);
    q.addQueryItem("email", email);
    m_hosts.append(new NetHost("post", "findUserPassword", q, [&]()-> void { procFindPasswordResult(m_netReply->readAll()); }));

}

void NetWorker::procFindPasswordResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procFindPasswordResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();
    if(isOpen(jsonObj) && isSuccess(jsonObj)) setFindPasswordResult(ENums::POSITIVE);
    else error();

    deleteLater();
    emit next();
}

int NetWorker::updatePassword(QString oldPass, QString newPass)
{
    if(!isValidUser()) return 0;

#if defined(Q_OS_ANDROID)
    form.oldPass = oldPass;
    form.pass = newPass;
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andUpdatePassword(form.oldPass, form.pass); });
    connect(NativeApp::getInstance(), SIGNAL(procUpdatePasswordResult(QByteArray)), this, SLOT(procUpdatePasswordResult(QByteArray)));
    return 1;
#endif
    QUrlQuery q;
    q.addQueryItem("old_password", oldPass);
    q.addQueryItem("password", newPass);
    m_hosts.append(new NetHost("post", "updateUserPassword", q, [&]()-> void { procUpdatePasswordResult(m_netReply->readAll()); }));
    return 1;
}

void NetWorker::procUpdatePasswordResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procUpdatePasswordResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();
    if(isOpen(jsonObj) && isSuccess(jsonObj)) setUpdatePasswordResult(ENums::POSITIVE);
    else setUpdatePasswordResult(ENums::NAGATIVE);

    deleteLater();
    emit next();
}

int NetWorker::getMyPageCourse()
{
    if(!isValidUser()) return 0;
    setRefreshWorkResult(ENums::WORKING_MYPAGE);

#if defined(Q_OS_ANDROID)
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andGetMyPageCourse(); });
    connect(NativeApp::getInstance(), SIGNAL(procGetMyPageCourseResult(QByteArray)), this, SLOT(procGetMyPageCourseResult(QByteArray)));
    return 1;
#endif
    QUrlQuery q;
    m_hosts.append(new NetHost("post", "getMyPageCourse", q, [&]()-> void { procGetMyPageCourseResult(m_netReply->readAll()); }));
    return 1;
}

void NetWorker::procGetMyPageCourseResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procGetMyPageCourseResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();
    if(isOpen(jsonObj) && isSuccess(jsonObj))
    {
        settings->setProfileImage(jsonObj["profile_image"].toString());
        settings->setThumbnailImage(jsonObj["profile_thumbnail_url"].toString());
        settings->setSnsType(jsonObj["sns_type"].toInt());

        QJsonArray jsonArr = jsonObj["data_list1"].toArray();
        QList<QObject*> dlist1;
        foreach(const QJsonValue &value, jsonArr)
        {
            QJsonObject obj = value.toObject();

            Univ* d = new Univ();
            d->setCourseNo(dInt(obj, 1, "course_no"));
            d->setCourseContentNo(dInt(obj, 2, "course_content_no"));
            d->setServiceTitle(dStr(obj, 3, "service_title"));
            d->setStudentProgress(dInt(obj, 4, "student_progress"));

            QObject* o = qobject_cast<QObject*>(d);
            dlist1.append(o);
        }
        //                                       m->setMyCourseList(dlist1);

        jsonArr = jsonObj["data_list2"].toArray();
        //                                       QList<QObject*> dlist2;
        foreach(const QJsonValue &value, jsonArr)
        {
            QJsonObject obj = value.toObject();
            Univ* d = new Univ();
            d->setCourseNo(dInt(obj, 1, "course_no"));
            d->setCourseContentNo(dInt(obj, 2, "course_content_no"));
            d->setServiceTitle(dStr(obj, 3, "service_title"));
            d->setStudentProgress(dInt(obj, 4, "student_progress"));

            QObject* o = qobject_cast<QObject*>(d);
            dlist1.append(o);
        }
        //                                       m->setCompleteCourseList(dlist2);
        m->setMyCourseList(dlist1);
    }

    setRefreshWorkResult(ENums::FINISHED_MYPAGE);
    deleteLater();
    emit next();
}

int NetWorker::getMyPageLog(int pageNo)
{
    if(!isValidUser()) return 0;
    setRefreshWorkResult(ENums::WORKING_MYPAGE);

    form.pageNo = QString("%1").arg(pageNo);
#if defined(Q_OS_ANDROID)
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andGetMyPageLog(form.pageNo); });
    connect(NativeApp::getInstance(), SIGNAL(procGetMyPageLogResult(QByteArray)), this, SLOT(procGetMyPageLogResult(QByteArray)));
    return 1;
#endif
    QUrlQuery q;
    q.addQueryItem("now_page", form.pageNo);
    m_hosts.append(new NetHost("post", "getMyPageLog", q, [&]()-> void { procGetMyPageLogResult(m_netReply->readAll()); }));
    return 1;
}

void NetWorker::procGetMyPageLogResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procGetMyPageLogResult(QByteArray)));
    if(!preventDoubleCall(&m_doubleCallPreventionVarGetMyPageLog)) return;
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();
    if(isOpen(jsonObj) && isSuccess(jsonObj))
    {
        m->setTotalLogCount(jsonObj["total_count"].toInt());

        QJsonArray jsonArr = jsonObj["data_list"].toArray();
        QList<QObject*> dlist;
        foreach(const QJsonValue &value, jsonArr)
        {
            QJsonObject obj = value.toObject();
            Log* d = new Log();
            d->setLogNo(obj["log_no"].toInt());
            d->setLogCode(obj["log_code"].toInt());
            d->setLogText(obj["log_text"].toString());
            d->setLogDate(obj["log_date"].toString());

            message("###### getMyPageLog RESULT ######");
            message("1. log_no: " + QString("%1").arg(obj["log_no"].toInt()));
            message("2. log_code : "  + QString("%1").arg(obj["log_code"].toInt()));
            message("3. log_text : "  + QString("%1").arg(obj["log_text"].toString()));
            message("4. log_date : "  + QString("%1").arg(obj["log_date"].toString()));

            QObject* o = qobject_cast<QObject*>(d);
            dlist.append(o);
        }

        if(form.pageNo.toInt() == 1) m->setRecentLogList(dlist);
        else {
            foreach(QObject* o, m->recentLogList())
            {
                Log* m = qobject_cast<Log*>(o);
                m->show(true);
            }
            m->appendRecentLogList(dlist);
            message("Refresh Main Result POSITIVE.");
        }
    }

    setRefreshWorkResult(ENums::FINISHED_MYPAGE);
    deleteLater();
    emit next();
}

int NetWorker::setPushDatetime(QString time)
{
    if(!isValidUser()) return 0;

#if defined(Q_OS_ANDROID)
    form.pushDateTime = time;
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andSetPushDateTime(form.pushDateTime); });
    connect(NativeApp::getInstance(), SIGNAL(procSetPushDatetimeResult(QByteArray)), this, SLOT(procSetPushDatetimeResult(QByteArray)));
    return 1;
#endif
    QUrlQuery q;
    q.addQueryItem("push_time", time);
    m_hosts.append(new NetHost("post", "setPushDatetime", q, [&]()-> void { procSetPushDatetimeResult(m_netReply->readAll()); }));
    return 1;
}

void NetWorker::procSetPushDatetimeResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procSetPushDatetimeResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();
    if(isOpen(jsonObj) && isSuccess(jsonObj)) setSetPushDatetimeResult(ENums::POSITIVE);
    else setSetPushDatetimeResult(ENums::NAGATIVE);
    deleteLater();
    emit next();
}

int NetWorker::getUserProfile()
{
    if(!isValidUser()) return 0;

#if defined(Q_OS_ANDROID)
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andGetUserProfile(); });
    connect(NativeApp::getInstance(), SIGNAL(procGetUserProfileResult(QByteArray)), this, SLOT(procGetUserProfileResult(QByteArray)));
    return 1;
#endif
    QUrlQuery q;
    m_hosts.append(new NetHost("post", "getUserProfile", q, [&]()-> void { procGetUserProfileResult(m_netReply->readAll()); }));
    return 1;
}

void NetWorker::procGetUserProfileResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procGetUserProfileResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    if(isOpen(jsonObj) && isSuccess(jsonObj))
    {
        int snsType             = jsonObj["sns_type"].toInt();
        QString name            = jsonObj["name"].toString();
        QString nickname        = jsonObj["nickname"].toString();
        int     pushStatus      = jsonObj["push_status"].toInt();
        QString pushTime        = jsonObj["push_time"].toString();
        QString birth            = jsonObj["birth"].toString();
        int     gender            = jsonObj["gender"].toInt();
        QString phone               = jsonObj["phone"].toString();
        QString email               = jsonObj["email"].toString();
        int     totalScore          = jsonObj["total_score"].toInt();
        QString joinDate             = jsonObj["join_date"].toString();
        QString recentDate          = jsonObj["recent_date"].toString();
        int     blocked            = jsonObj["is_block"].toInt();
        QString profileImage        = jsonObj["profile_image"].toString();
        QString profileThumbnailUrl = jsonObj["profile_thumbnail_url"].toString();

        message("[JOIN] Succeeded to getUserProfile.");
        message("###################  PROFILE RESULT  ###################");
        message(" 1. snsType : " + numToStr(snsType));
        message(" 2.  name : " + name);
        message(" 3.  nickname : " + nickname);
        message(" 4.  pushStatus : " + numToStr(pushStatus));
        message(" 5. pushTime : " + pushTime);
        message(" 6. birth : " + birth);
        message(" 7. gender : " + numToStr(gender));
        message(" 8.  phone : " + phone);
        message(" 9. email : " + email);
        message("10. totalScore : " + numToStr(totalScore));
        message("11.  joinDate : " + joinDate);
        message("12. recentDate : " + recentDate);
        message("13. blocked : " + numToStr(blocked));
        message("14.  profileImage : " + profileImage);
        message("15.  profileThumbnailUrl : " + profileThumbnailUrl);
        message("#######################################################");

//        settings->setLogined(true);
        settings->setSnsType(snsType);
        settings->setName(name);
        settings->setNickName(nickname);
        settings->setPushStatus(pushStatus);
        settings->setPushTime(pushTime);
        settings->setBirth(birth);//settings->setBirth(birth);
        settings->setGender(gender);
        settings->setPhone(phone);
        settings->setEmail(email);//settings->setEmail(email);
        settings->setTotalHavePoint(totalScore);
        settings->setJoinDate(joinDate);
        settings->setRecentDate(recentDate);
        settings->setBlocked(blocked);
        settings->setProfileImage(profileImage);
        settings->setThumbnailImage(profileThumbnailUrl);
    } else error();

    deleteLater();
    emit next();
}

int NetWorker::updateUserProfile(bool modifiedImage)
{
    if(!isValidUser()) return 0;
    form.isImageFileModify = QString("%1").arg(modifiedImage ? 1 : 0);

#if defined(Q_OS_ANDROID)
    form.profileImage = settings->profileImage();
    form.profileThumbUrl = settings->thumbnailImage();
    form.name = settings->name();
    form.birth = settings->birth();
    form.gender = QString("%1").arg(settings->gender());
    form.email = settings->email();
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andUpdateUserProfile(form.profileImage, form.profileThumbUrl, form.name, form.birth, form.gender, form.email, form.isImageFileModify); });
    connect(NativeApp::getInstance(), SIGNAL(procUpdateUserProfileResult(QByteArray)), this, SLOT(procUpdateUserProfileResult(QByteArray)));
    return 1;
#endif
    QString profileImage = settings->profileImage();
    QString profileThumbUrl = settings->thumbnailImage();
    QString name = settings->name();
    QString birth = settings->birth();
    QString gender = QString("%1").arg(settings->gender());
    QString email = settings->email();

    QUrlQuery q;
    q.addQueryItem("profile_image", profileImage);
    q.addQueryItem("profile_thumbnail_url", profileThumbUrl);
    q.addQueryItem("name", name);
    q.addQueryItem("birth", birth);
    q.addQueryItem("gender", gender);
    q.addQueryItem("email", email);
    q.addQueryItem("is_image_file_modify", form.isImageFileModify);
    m_hosts.append(new NetHost("post", "updateUserProfile", q, [&]()-> void { procUpdateUserProfileResult(m_netReply->readAll()); }));
    return 1;
}

void NetWorker::procUpdateUserProfileResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procUpdateUserProfileResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();
    if(isOpen(jsonObj) && isSuccess(jsonObj))
    {
        if(form.isImageFileModify.toInt() == 0) setUpdateUserProfileResult(ENums::POSITIVE);
        else setUpdateUserProfileResult(ENums::PICKER);
    }
    else
    {
        if(form.isImageFileModify.toInt() == 0) error();
    }

    deleteLater();
    emit next();
}

void NetWorker::getSystemNoticeList(int noticeType, int pageNo)
{
    form.pageNo = QString("%1").arg(pageNo);
#if defined(Q_OS_ANDROID)
    form.noticeType = QString("%1").arg(noticeType);
    m_andNet.enqueue([&]()->void{ NativeApp::getInstance()->andGetSystemNoticeList(form.noticeType, form.pageNo); });
    connect(NativeApp::getInstance(), SIGNAL(procGetSystemNoticeListResult(QByteArray)), this, SLOT(procGetSystemNoticeListResult(QByteArray)));
    return;
#endif
    QUrlQuery q;
    q.addQueryItem("notice_type", QString("%1").arg(noticeType));
    q.addQueryItem("now_page", form.pageNo);
    FUNC func = [&]()-> void { procGetSystemNoticeListResult(m_netReply->readAll()); };
    m_hosts.append(new NetHost("post", "getSystemNoticeList", q, func));
    m_delayedHosts.append(new NetHost("post", "getSystemNoticeList", q, func));
}

void NetWorker::procGetSystemNoticeListResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procGetSystemNoticeListResult(QByteArray)));
    if(!preventDoubleCall(&m_doubleCallPreventionVarGetSystemNoticeList)) return;
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();
    if(isOpen(jsonObj) && isSuccess(jsonObj))
    {
        ListParser* p = (new ListParser("getSystemNoticeList", ""))->setObj(jsonObj)->start();
        m->setTotalNoticeCount(p->dInt("total_count"));

        QJsonArray jsonArr = jsonObj["data_list"].toArray();

        QList<QObject*> dlist;
        QList<QObject*> dToplist;
        p = new ListParser("getSystemNoticeList", "data_list");
        foreach(const QJsonValue &value, jsonArr)
        {
            p->setObj(value.toObject())->start();
            Univ* d = new Univ();
            d->setBoardNo(p->dInt("board_no"));
            d->setBoardArticleNo(p->dInt("board_article_no"));
            d->setUserNo(p->dInt("user_no"));
            d->setNickname(p->dStr("nickname"));
            d->setTitle(fromUnicode(p->dStr("title")));
            d->setViewCount(p->dInt("view_count"));
            d->setRepleCount(p->dInt("reple_count"));
            d->setWriteDate(p->dStr("write_date"));
            int top = p->dInt("is_top");
            d->setTop(top);
            p->end();

            QObject* o = qobject_cast<QObject*>(d);
            if(top > 0) dToplist.append(o);
            else dlist.append(o);
        }
        p->close();

        if(form.pageNo.toInt() == 1)
        {
            m->setNoticeTopList(dToplist);
            m->setNoticeList(dlist);
        }
        else {
            foreach(QObject* o, m->noticeList())
            {
                Univ* m = qobject_cast<Univ*>(o);
                m->show(true);
            }
            m->appendNoticeList(dlist);
        }

        setSession(jsonObj);
    }

    setRefreshWorkResult(ENums::FINISHED_SYSTEMNOTICE);
    deleteLater();
    emit next();
}

void NetWorker::getSystemNoticeDetail(int boardArticleNo, int boardNo)
{
#if defined(Q_OS_ANDROID)
    form.boardArticleNo = QString("%1").arg(boardArticleNo);
    form.boardNo = QString("%1").arg(boardNo);
    m_andNet.enqueue([&]()->void{ NativeApp::getInstance()->andGetSystemNoticeDetail(form.boardArticleNo, form.boardNo); });
    connect(NativeApp::getInstance(), SIGNAL(procGetSystemNoticeDetailResult(QByteArray)), this, SLOT(procGetSystemNoticeDetailResult(QByteArray)));
    return;
#endif
    QUrlQuery q;
    q.addQueryItem("board_article_no", QString("%1").arg(boardArticleNo));
    q.addQueryItem("board_no", QString("%1").arg(boardNo));
    m_hosts.append(new NetHost("post", "getSystemNoticeDetail", q, [&]()-> void { procGetSystemNoticeDetailResult(m_netReply->readAll()); }));
}

void NetWorker::procGetSystemNoticeDetailResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procGetSystemNoticeDetailResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();
    if(isOpen(jsonObj) && isSuccess(jsonObj))
    {
        ListParser* p = (new ListParser("getSystemNoticeDetail", ""))->setObj(jsonObj)->start();
        Univ* d = new Univ();
        d->setUserNo(0);
        d->setBoardArticleNo(p->dInt("board_article_no"));
        d->setBoardNo(p->dInt("board_no"));
        d->setTitle(fromUnicode(p->dStr("title")));
        d->setNickname(p->dStr("nickname"));
        d->setContents(fromUnicode(p->dStr("contents")));
        d->setViewCount(p->dInt("view_count"));
        d->setRepleCount(p->dInt("reple_count"));
        d->setWriteDate(p->dStr("write_date"));
        d->setUpdateDate(p->dStr("update_date"));
        d->setTop(p->dInt("is_top"));
        p->end()->close();

        QJsonArray jsonArr = jsonObj["data_list1"].toArray();
        QList<QObject*> fileList;
        QList<QObject*> imgList;
        foreach(const QJsonValue &value, jsonArr)
        {
            p->setObj(value.toObject())->start();
            QJsonObject obj = value.toObject();
            File* f = new File();
            f->setFileNo(p->dInt("file_no"));
            f->setFileName(p->dStr("file_name"));

            QString fileUrl = p->dStr("file_url");
            f->setFileUrl(fileUrl);

            QStringList strList = fileUrl.split("/");
            if(strList.count() > 1)
            {
                strList = strList[strList.count()-1].split(".");
                if(strList.count() > 1)
                {
                    QString ext = strList[1];
                    if(!ext.compare("jpg") || !ext.compare("jpeg") || !ext.compare("JPG") || !ext.compare("JPEG") || !ext.compare("png") || !ext.compare("PNG"))
                    {
                        message("***file_url: " + fileUrl);
                        QObject* oimg = qobject_cast<QObject*>(f);
                        imgList.append(oimg);
                    }
                }
            }

            QObject* o = qobject_cast<QObject*>(f);
            fileList.append(o);
            p->end();
        }
        p->close();
        d->setFileList(fileList);
        d->setImageList(imgList);

        jsonArr = jsonObj["data_list2"].toArray();
        QList<QObject*> dlist2;
        p = new ListParser("getSystemNoticeDetail", "data_list2");
        foreach(const QJsonValue &value, jsonArr)
        {
            p->setObj(value.toObject())->start();
            Univ* d = new Univ();
            d->setRepleNo(p->dInt("reple_no"));
            d->setUserNo(p->dInt("user_no"));
            d->setNickname(p->dStr("nickname"));
            d->setContents(p->dStr("contents"));
            d->setProfileImage(p->dStr("profile_image"));
            d->setProfileThumbNailUrl(p->dStr("profile_thumbnail_url"));

            QString filename = p->dStr("file_name");
            QString fileurl = p->dStr("file_url");
            QList<QObject*> fileList;
            File* file = new File();
            file->setFileName(filename);
            file->setFileUrl(fileurl);
            QObject* fo = qobject_cast<QObject*>(file);
            fileList.append(fo);
            d->setFileList(fileList);

            d->setReportCount(p->dInt("report_count"));
            d->setWriteDate(p->dStr("write_date"));
            d->setGood(p->dInt("is_good"));
            p->end();

            QObject* o = qobject_cast<QObject*>(d);
            dlist2.append(o);
        }
        m->setRepleList(dlist2);
        m->setNoticeDetail(d);

        message("Succeeded to get [getSystemNoticeDetail].");
        setGetSystemNoticeDetailResult(ENums::POSITIVE);
    }
    else
    {
        message("Failed to get [getSystemNoticeDetail].");
        setGetSystemNoticeDetailResult(ENums::NAGATIVE);
    }

    deleteLater();
    emit next();
}

void NetWorker::certificate(QString phone)
{
#if defined(Q_OS_ANDROID)
    form.phone = phone;
    m_andNet.enqueue([&]()->void{ NativeApp::getInstance()->andCertificate(form.phone); });
    connect(NativeApp::getInstance(), SIGNAL(procCertificateResult(QByteArray)), this, SLOT(procCertificateResult(QByteArray)));
    return;
#endif
    QUrlQuery q;
    q.addQueryItem("phone", phone);
    m_hosts.append(new NetHost("post", "certification", q, [&]()-> void { procCertificateResult(m_netReply->readAll()); }));
}

void NetWorker::procCertificateResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procCertificateResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    if(isOpen(jsonObj))
    {
        if(isSuccess(jsonObj)) setSentPhoneResult(ENums::POSITIVE);
        else error();
    }

    m->setShowIndicator(false);
    deleteLater();
    emit next();
}

void NetWorker::checkCertificationSMS(QString phone, QString nums)
{
    form.phone = phone;
#if defined(Q_OS_ANDROID)
    form.nums = nums;
    m_andNet.enqueue([&]()->void{ NativeApp::getInstance()->andCheckCertificationSMS(form.phone, form.nums); });
    connect(NativeApp::getInstance(), SIGNAL(procCheckCertificationSMSResult(QByteArray)), this, SLOT(procCheckCertificationSMSResult(QByteArray)));
    return;
#endif
    QUrlQuery q;
    q.addQueryItem("phone", form.phone);
    q.addQueryItem("unique_number", nums);
    m_hosts.append(new NetHost("post", "checkCertificationSMS", q, [&]()-> void { procCheckCertificationSMSResult(m_netReply->readAll()); }));
}

void NetWorker::procCheckCertificationSMSResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procCheckCertificationSMSResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    bool serverResult = isOpen(jsonObj) && isSuccess(jsonObj);
    if(!serverResult) error();
    else
    {
        settings->setPhone(form.phone);
        setCertificatedResult(ENums::POSITIVE);
    }

    deleteLater();
    emit next();
}

void NetWorker::duplicateID(QString id)
{
#if defined(Q_OS_ANDROID)
    form.id = id;
    m_andNet.enqueue([&]()->void{ NativeApp::getInstance()->andDuplicateID(form.id); });
    connect(NativeApp::getInstance(), SIGNAL(procDuplicateIDResult(QByteArray)), this, SLOT(procDuplicateIDResult(QByteArray)));
    return;
#endif
    QUrlQuery q;
    q.addQueryItem("id", id);
    m_hosts.append(new NetHost("post", "duplicateID", q, [&]()-> void { procDuplicateIDResult(m_netReply->readAll()); }));
}

void NetWorker::procDuplicateIDResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procDuplicateIDResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    bool serverResult = isOpen(jsonObj) && isSuccess(jsonObj);
    if(!serverResult) setDuplicatedIDResult(ENums::NAGATIVE);
    else setDuplicatedIDResult(ENums::POSITIVE);

    deleteLater();
    emit next();
}

void NetWorker::duplicateNickname(QString nickname)
{
#if defined(Q_OS_ANDROID)
    form.nickname = nickname;
    m_andNet.enqueue([&]()->void{ NativeApp::getInstance()->andDuplicateNickname(form.nickname); });
    connect(NativeApp::getInstance(), SIGNAL(procDuplicateNicknameResult(QByteArray)), this, SLOT(procDuplicateNicknameResult(QByteArray)));
    return;
#endif
    QUrlQuery q;
    q.addQueryItem("nickname", nickname);
    m_hosts.append(new NetHost("post", "duplicateNickname", q, [&]()-> void { procDuplicateNicknameResult(m_netReply->readAll()); }));
}

void NetWorker::procDuplicateNicknameResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procDuplicateNicknameResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    bool serverResult = isOpen(jsonObj) && isSuccess(jsonObj);
    if(!serverResult) setDuplicatedNicknameResult(ENums::NAGATIVE);
    else setDuplicatedNicknameResult(ENums::POSITIVE);

    deleteLater();
    emit next();
}

void NetWorker::uploadImageFile(QString fileurl, int distribution)
{
    QString filename;
    QStringList strList = fileurl.split("/");
    if(strList.count() > 1)
    {
        strList = strList[strList.count()-1].split(".");
        if(strList.count() > 1)
        {
            QString ext = strList[strList.count() - 1];
            if(!ext.compare("jpg") || !ext.compare("jpeg") || !ext.compare("JPG") || !ext.compare("JPEG") || !ext.compare("png") || !ext.compare("PNG"))
            {
                for(int i=0; i<strList.count(); i++)
                {
                    filename += strList[i];
                    if(i < (strList.count()-1)) filename += ".";
                }

                message("***extracted FILE NAME: " + filename);
            }
            else
            {
                message("It's no image file: " + fileurl + ", " + ext);
                return;
            }
        }
    }

    form.distribution = distribution;

#if defined(Q_OS_ANDROID)
    form.filename = filename;
    form.fileUrl = fileurl;
    m_andNet.enqueue([&]()->void{ NativeApp::getInstance()->andUploadImageFile(form.filename, form.fileUrl.remove("file:///")); });
    connect(NativeApp::getInstance(), SIGNAL(procUploadImageFileResult(QByteArray)), this, SLOT(procUploadImageFileResult(QByteArray)));
    return;
#endif
    QUrlQuery q;
    q.addQueryItem("file_name", filename);
    m_hosts.append(new NetHost("file", "uploadImageFile", q, [&]()-> void { procUploadImageFileResult(m_netReply->readAll()); }, fileurl.remove("file:///")));
}

void NetWorker::procUploadImageFileResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procUploadImageFileResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();
    if(isOpen(jsonObj) && isSuccess(jsonObj))
    {
        QString fUrl = jsonObj["file_url"].toString();
        QString fThumbUrl = jsonObj["file_thumbnail_url"].toString();
        QString fName = jsonObj["file_name"].toString();

        if(form.distribution == 0)
        {
            settings->setProfileImage(fUrl);
            settings->setThumbnailImage(fThumbUrl);  //사진 짜부됨
        }
        else
        {
            Model::getInstance()->noticeDetail()->setAppliedImageUrl(fUrl);
        }


        message("############################################");
        message("1. FILE URL : " + fUrl);
        message("2. FILE THUMB URL : " + fThumbUrl);
        message("3. FILE NAME : " + fName);

        setUploadResult(ENums::POSITIVE);
    }
    else setUploadResult(ENums::NAGATIVE);

    deleteLater();
    emit next();
}

void NetWorker::uploadFile(QString fileurl, int boardNo, int boardArticleNo)
{
    QString filename;
    QStringList strList = fileurl.split("/");
    if(strList.count() > 1)
    {
        strList = strList[strList.count()-1].split(".");
        if(strList.count() > 1)
        {
            QString ext = strList[strList.count() - 1];
            if(!ext.compare("jpg") || !ext.compare("jpeg") || !ext.compare("JPG") || !ext.compare("JPEG") || !ext.compare("png") || !ext.compare("PNG"))
            {
                for(int i=0; i<strList.count(); i++)
                {
                    filename += strList[i];
                    if(i < (strList.count()-1)) filename += ".";
                }

                message("***extracted FILE NAME: " + filename);
            }
            else
            {
                message("It's no image file: " + fileurl + ", " + ext);
                return;
            }
        }
    }

#if defined(Q_OS_ANDROID)
    FileInfo file;
    file.filename = filename;
    file.boardArticleNo = QString("%1").arg(boardArticleNo);
    file.boardNo = QString("%1").arg(boardNo);
    file.fileUrl = fileurl;
    m_fileQueue.enqueue(file);
    m_andNet.enqueue([&]()->void
    {
        if(m_fileQueue.length() == 0) return;
        FileInfo f = m_fileQueue.dequeue();
        NativeApp::getInstance()->andUploadFile(f.filename, f.boardArticleNo, f.boardNo, f.fileUrl.remove("file:///"));
    });

    connect(NativeApp::getInstance(), SIGNAL(procUploadFileResult(QByteArray)), this, SLOT(procUploadFileResult(QByteArray)));
    return;
#endif
    QUrlQuery q;
    q.addQueryItem("file_name", filename);
    q.addQueryItem("board_no", QString("%1").arg(boardNo));
    q.addQueryItem("board_article_no", QString("%1").arg(boardArticleNo));
    m_hosts.append(new NetHost("file", "uploadFile", q, [&]()-> void { procUploadFileResult(m_netReply->readAll()); }, fileurl.remove("file:///")));
}

void NetWorker::procUploadFileResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procUploadFileResult(QByteArray)));
    if(!preventDoubleCall(&m_doubleCallPreventionVarUploadFile)) return;
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    if(isOpen(jsonObj) && isSuccess(jsonObj))
    {
        QString fUrl = jsonObj["file_url"].toString();
        QString fThumbUrl = jsonObj["file_thumbnail_url"].toString();
        QString fName = jsonObj["file_name"].toString();

        settings->setProfileImage(fUrl);
        settings->setThumbnailImage(fThumbUrl);

        message("############################################");
        message("1. FILE URL : " + fUrl);
        message("2. FILE THUMB URL : " + fThumbUrl);
        message("3. FILE NAME : " + fName);

        setUploadResult(ENums::POSITIVE);
    }
    else setUploadResult(ENums::NAGATIVE);

    deleteLater();
    emit next();
}

void NetWorker::deleteFile(int fileNo)
{
#if defined(Q_OS_ANDROID)
    form.fileNo = QString("%1").arg(fileNo);
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andDeleteFile(form.fileNo); });
    connect(NativeApp::getInstance(), SIGNAL(procDeleteFileResult(QByteArray)), this, SLOT(procDeleteFileResult(QByteArray)));
    return;
#endif
    QUrlQuery q;
    q.addQueryItem("file_no", QString("%1").arg(fileNo));
    m_hosts.append(new NetHost("post", "deleteFile", q, [&]()-> void { procDeleteFileResult(m_netReply->readAll()); }));
}

void NetWorker::procDeleteFileResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procDeleteFileResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    if(isOpen(jsonObj) && isSuccess(jsonObj))
    {
        m->popRemovedFileStorage();
        if(m->removedFileStorage().length() == 0) setDeleteFileResult(ENums::POSITIVE);
        else setDeleteFileResult(ENums::WAIT);
    }
    else
    {
        m->setShowIndicator(false);
        error();
    }

    deleteLater();
    emit next();
}

void NetWorker::getMain(int nowPage, QString categoryNo)
{
    if(!categoryNo.compare("0")) categoryNo = "";

    if(nowPage == 1) m->setTotalCourseCount(0);
    else
    {
        if(!requestNextPage(m->totalCourseCount(), m->homelist().length()))
        return;
    }

    form.pageNo = QString("%1").arg(nowPage);

#if defined(Q_OS_ANDROID)
    form.categoryNo = categoryNo;
    m_andNet.enqueue([&]()-> void { NativeApp::getInstance()->andGetMain(form.pageNo, form.categoryNo); });

    NativeApp* app = NativeApp::getInstance();
    connect(app, SIGNAL(procGetMainResult(QByteArray)), this, SLOT(procGetMainResult(QByteArray)));
    return;
#endif

    QUrlQuery q;
    q.addQueryItem("now_page", form.pageNo);
    q.addQueryItem("category_no", categoryNo);

    m_hosts.append(new NetHost("post", "getMain", q, [&]()-> void { procGetMainResult(m_netReply->readAll()); }));
    m_delayedHosts.append(new NetHost("post", "getMain", q, [&]()-> void { procGetMainResult(m_netReply->readAll()); }));

}

void NetWorker::procGetMainResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procGetMainResult(QByteArray)));
    if(!preventDoubleCall(&m_doubleCallPreventionVarGetMain)) return;

#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();
    if(isOpen(jsonObj) && isSuccess(jsonObj))
    {
        m->setBannerCount(jsonObj["banner_count"].toInt());
        m->setTotalCourseCount(jsonObj["total_course_count"].toInt());
        m->setNewAlarm(jsonObj["exists_new_alarm"].toInt() > 0 ? true : false);

        int order = 1;
        ListParser* p = new ListParser("getMain", "HomeList");
        QJsonArray jsonArr = jsonObj["data_list2"].toArray();
        if(form.pageNo.toInt() == 1)
        {
            jsonArr = jsonObj["data_list2"].toArray();
            QList<QObject*> dlist2;
            order = 1;
            p = new ListParser("getMain", "BannerList");
            foreach(const QJsonValue &value, jsonArr)
            {
                p->setObj(value.toObject());
                p->start();
                Banner* d = new Banner();
                d->setBoardNo(p->dInt("board_no"));
                d->setBoardArticleNo(p->dInt("board_article_no"));
                d->setTitle(p->dStr("title"));
                d->setFileUrl(p->dStr("file_url"));
                d->setThumbNailUrl(p->dStr("thumbnail_url"));
                d->setOrder(order++);
                p->end();
                QObject* o = qobject_cast<QObject*>(d);
                dlist2.append(o);
            }
            p->close();
            m->setBannerList(dlist2);
        }

        int d0CourseNo = -1;
        jsonArr = jsonObj["data_list1"].toArray();
        QList<QObject*> dlist1;
        foreach(const QJsonValue &value, jsonArr)
        {
            p->setObj(value.toObject());
            p->start();
            Main* d = new Main();
            d0CourseNo = p->dInt("course_no");
            d->setCourseNo(d0CourseNo);
            d->setCourseContentNo(p->dInt("course_content_no"));
            d->setServiceTitle(p->dStr("service_title"));
            d->setStartDate(p->dStr("start_date"));
            d->setEndDate(p->dStr("end_date"));
            d->setCategoryTitle(p->dStr("category_title"));
            d->setCourseImageUrl(p->dStr("course_image_url"));
            d->setCourseImageThumnailUrl(p->dStr("course_image_thumbnail_url"));
            d->setViewCount(p->dInt("view_count"));
            d->setOrder(order++);
            p->end();
            QObject* o = qobject_cast<QObject*>(d);
            dlist1.append(o);
        }
        p->close();

        if(form.pageNo.toInt() == 1) m->setHomeList(dlist1);
        else
        {
            foreach(QObject* o, m->homelist())
            {
                Main* m = qobject_cast<Main*>(o);
                m->show(true);
            }

            bool already = false;
            if(d0CourseNo > -1)
            {
                foreach(QObject* o, m->homelist())
                {
                    Main* tc = qobject_cast<Main*>(o);
                    if(tc->courseNo() == d0CourseNo)
                    {
                        already = true;
                        break;
                    }
                }
            }

            if(!already)
                m->appendHomeList(dlist1);



        }
        setSession(jsonObj);
    }
    setRefreshWorkResult(ENums::FINISHED_MAIN);

    deleteLater();
    emit next();
}

int NetWorker::getCourseDetail(int courseNo)
{
    if(courseNo < 1) return 2;

#if defined(Q_OS_ANDROID)
    form.courseNo = QString("%1").arg(courseNo);
    m_andNet.enqueue([&]()->void{ NativeApp::getInstance()->andGetCourseDetail(form.courseNo); });
    connect(NativeApp::getInstance(), SIGNAL(procGetCourseDetailResult(QByteArray)), this, SLOT(procGetCourseDetailResult(QByteArray)));
    return 1;
#endif
    QUrlQuery q;
    q.addQueryItem("course_no", QString("%1").arg(courseNo));
    m_hosts.append(new NetHost("post", "getCourseDetail", q, [&]()-> void { procGetCourseDetailResult(m_netReply->readAll()); }));
    m_delayedHosts.append(new NetHost("post", "getCourseDetail", q, [&]()-> void { procGetCourseDetailResult(m_netReply->readAll()); }));
    return 1;
}

void NetWorker::procGetCourseDetailResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procGetCourseDetailResult(QByteArray)));
#endif
    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();
    if(isOpen(jsonObj) && isSuccess(jsonObj))
    {
        ListParser* p = (new ListParser("getCourseDetail", ""))->setObj(jsonObj)->start();
        m->courseDetail()->setCourseNo(p->dInt("course_no"));
        m->courseDetail()->setServiceTitle(p->dStr("service_title"));
        m->courseDetail()->setCourseContentNo(p->dInt("course_content_no"));
        m->courseDetail()->setStudyGoal(p->dStr("study_goal"));
        m->courseDetail()->setStudyTarget(p->dStr("study_target"));
        m->courseDetail()->setStudyRef(p->dStr("study_ref"));
        m->courseDetail()->setStudyComplete(p->dStr("study_complete"));
        m->courseDetail()->setTeacherInfo(p->dStr("teacher_info"));
        m->courseDetail()->setStudyNcs(p->dStr("study_ncs"));
        m->courseDetail()->setCourseInfoImageUrl(p->dStr("course_info_image_url"));
        m->courseDetail()->setViewCount(p->dInt("view_count"));
        m->courseDetail()->setShortDescription(p->dStr("short_description"));
        m->courseDetail()->setCourseIntroduce(p->dStr("course_introduce"));
        m->courseDetail()->setCourseImageUrl(p->dStr("course_image_url"));
        m->courseDetail()->setCourseImageThumnailUrl(p->dStr("course_image_thumbnail_url"));
        p->end()->close();

        QJsonArray jsonArr = jsonObj["data_list"].toArray();
        QList<QObject*> dlist;
        p = new ListParser("getCourseDetail", "data_list");
        foreach(const QJsonValue &value, jsonArr)
        {
            p->setObj(value.toObject())->start();
            Board* d = new Board();
            d->setBoardNo(p->dInt("board_no"));
            d->setTitle(p->dStr("title"));
            d->setWritableStudent(p->dInt("writable_student"));
            p->end();
            QObject* o = qobject_cast<QObject*>(d);
            dlist.append(o);
        }
        p->close();
        m->setBoardList(dlist);
        setSession(jsonObj);
    }

    deleteLater();
    emit next();
}

int NetWorker::getCourseBoardList(int nowPage, int boardNo)
{
    if(boardNo < 1) return 2;
    setRefreshWorkResult(ENums::WORKING_COURSENOTICE);

    if(nowPage == 1) m->setTotalNoticeCount(0);
    else
    {
        if(!requestNextPage(m->totalNoticeCount(), m->noticeList().length()))
        return 3;
    }

    m->noticeTopList();
    m->noticeList().clear();
    form.pageNo = QString("%1").arg(nowPage);

#if defined(Q_OS_ANDROID)
    if(!m_checkPrevNet.compare("getMain"))
    {
        m_checkPrevNet = "";
        setRefreshWorkResult(ENums::FINISHED_COURENOTICE);
        return 4;
    }

    form.boardNo = QString("%1").arg(boardNo);
    message("PageNo: " +  form.pageNo + ", BoardNo: " + form.boardNo);
    m_andNet.enqueue([&]()->void{ NativeApp::getInstance()->andGetCourseBoardList(form.pageNo, form.boardNo); });
    connect(NativeApp::getInstance(), SIGNAL(procGetCourseBoardListResult(QByteArray)), this, SLOT(procGetCourseBoardListResult(QByteArray)));
    return 1;
#endif
    QUrlQuery q;
    q.addQueryItem("board_no", QString("%1").arg(boardNo));
    q.addQueryItem("now_page", form.pageNo);
    FUNC func = [&]()-> void { procGetCourseBoardListResult(m_netReply->readAll()); };
    m_hosts.append(new NetHost("post", "getCourseBoardList", q, func));
    m_delayedHosts.append(new NetHost("post", "getCourseBoardList", q, func));
    return 1;
}

void NetWorker::procGetCourseBoardListResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procGetCourseBoardListResult(QByteArray)));
    if(!preventDoubleCall(&m_doubleCallPreventionVarGetCourseBoardList)) return;
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();
    if(isOpen(jsonObj) && isSuccess(jsonObj))
    {
        ListParser* p = (new ListParser("getCourseBoardList", ""))->setObj(jsonObj)->start();
        m->setTotalNoticeCount(p->dInt("total_count"));

        QJsonArray jsonArr = jsonObj["data_list"].toArray();
        QList<QObject*> dlist;
        QList<QObject*> dToplist;
        p = new ListParser("getCourseBoardList", "data_list");
        foreach(const QJsonValue &value, jsonArr)
        {
            p->setObj(value.toObject())->start();
            Univ* d = new Univ();
            d->setBoardNo(p->dInt("board_no"));
            d->setBoardArticleNo(p->dInt("board_article_no"));
            d->setUserNo(p->dInt("user_no"));
            d->setNickname(p->dStr("nickname"));
            d->setTitle(p->dStr("title"));
            d->setViewCount(p->dInt("view_count"));
            d->setRepleCount(p->dInt("reple_count"));
            d->setWriteDate(p->dStr("write_date"));
            int top = p->dInt("is_top");
            d->setTop(top);
            p->end();

            QObject* o = qobject_cast<QObject*>(d);
            if(top > 0) dToplist.append(o);
            else dlist.append(o);
        }
        p->close();

        if(form.pageNo.toInt() == 1)
        {
            m->setNoticeTopList(dToplist);
            m->setNoticeList(dlist);
        }
        else {
            foreach(QObject* o, m->noticeList())
            {
                Univ* m = qobject_cast<Univ*>(o);
                m->show(true);
            }
            m->appendNoticeList(dlist);
        }

        setSession(jsonObj);
    }

    setRefreshWorkResult(ENums::FINISHED_COURENOTICE);
    deleteLater();
    emit next();
}

int NetWorker::getCourseBoardDetail(int nowPage, int boardNo, int boardArticleNo)
{
    if(boardNo < 1) return 2;
    if(boardArticleNo < 1) return 3;
    form.pageNo = QString("%1").arg(nowPage);

#if defined(Q_OS_ANDROID)
    form.boardNo = QString("%1").arg(boardNo);
    form.boardArticleNo = QString("%1").arg(boardArticleNo);
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andGetCourseBoardDetail(form.pageNo, form.boardNo, form.boardArticleNo); });
    connect(NativeApp::getInstance(), SIGNAL(procGetCourseBoardDetailResult(QByteArray)), this, SLOT(procGetCourseBoardDetailResult(QByteArray)));
    return 1;
#endif
    QUrlQuery q;
    q.addQueryItem("board_no", QString("%1").arg(boardNo));
    q.addQueryItem("board_article_no", QString("%1").arg(boardArticleNo));
    q.addQueryItem("now_page", form.pageNo);
    FUNC func = [&]()-> void { procGetCourseBoardDetailResult(m_netReply->readAll()); };
    m_hosts.append(new NetHost("post", "getCourseBoardDetail", q, func));
    m_delayedHosts.append(new NetHost("post", "getCourseBoardDetail", q, func));

    return 1;
}

void NetWorker::procGetCourseBoardDetailResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procGetCourseBoardDetailResult(QByteArray)));
    if(!preventDoubleCall(&m_doubleCallPreventionVarGetCourseBoardDetail)) return;
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();
    if(isOpen(jsonObj) && isSuccess(jsonObj))
    {
        QJsonArray jsonArr;
        ListParser* p;
        if(form.pageNo.toInt() == 1)
        {
            p = (new ListParser("getCourseBoardDetail", ""))->setObj(jsonObj)->start();
            m->noticeDetail()->setBoardArticleNo(p->dInt("board_article_no"));
            m->noticeDetail()->setBoardNo(p->dInt("board_no"));
            m->noticeDetail()->setTitle(p->dStr("title"));
            m->noticeDetail()->setUserNo(p->dInt("user_no"));
            m->noticeDetail()->setNickname(p->dStr("nickname"));

            m->noticeDetail()->setContents(p->dStr("contents"));
            m->noticeDetail()->setViewCount(p->dInt("view_count"));
            m->noticeDetail()->setRepleCount(p->dInt("reple_count"));
            m->noticeDetail()->setWriteDate(p->dStr("write_date"));
            m->noticeDetail()->setUpdateDate(p->dStr("update_date"));
            m->noticeDetail()->setTop(p->dInt("is_top"));
            m->noticeDetail()->setGood(p->dInt("is_good"));

            jsonArr = jsonObj["data_list1"].toArray();
            QList<QObject*> dlist1;
            p = new ListParser("getCourseBoardDetail", "data_list1");
            foreach(const QJsonValue &value, jsonArr)
            {
                p->setObj(value.toObject())->start();
                File* d = new File();
                d->setFileNo(p->dInt("file_no"));

                QString filename = p->dStr("file_name");
                QStringList strList = filename.split("/");
                if(strList.count() > 1) filename = strList[strList.count()-1];

                d->setFileName(filename);
                d->setFileUrl(p->dStr("file_url"));
                p->end();

                QObject* o = qobject_cast<QObject*>(d);
                dlist1.append(o);
            }
            p->close();
            m->noticeDetail()->setFileList(dlist1);
        }

        jsonArr = jsonObj["data_list2"].toArray();
        QList<QObject*> dlist2;
        p = new ListParser("getCourseBoardDetail", "data_list2");
        foreach(const QJsonValue &value, jsonArr)
        {
            p->setObj(value.toObject())->start();
            Univ* d = new Univ();
            d->setRepleNo(p->dInt("reple_no"));
            d->setUserNo(p->dInt("user_no"));
            d->setNickname(p->dStr("nickname"));
            d->setContents(p->dStr("contents"));
            d->setProfileImage(p->dStr("profile_image"));
            d->setProfileThumbNailUrl(p->dStr("profile_thumbnail_url"));

            QString filename = p->dStr("file_name");
            QStringList strList = filename.split("/");
            if(strList.count() > 1)
            {
                strList = strList[strList.count()-1].split(".");
                if(strList.count() > 1)
                {
                    filename = strList[0] + "." + strList[1];
                }
            }

            QString fileurl = p->dStr("file_url");
            QList<QObject*> fileList;
            File* file = new File();
            file->setFileName(filename);
            file->setFileUrl(fileurl);
            QObject* fo = qobject_cast<QObject*>(file);
            fileList.append(fo);
            d->setFileList(fileList);

            d->setReportCount(p->dInt("report_count"));
            d->setWriteDate(p->dStr("write_date"));
            d->setGood(p->dInt("is_good"));
            p->end();

            QObject* o = qobject_cast<QObject*>(d);
            dlist2.append(o);
        }
        setGetCourseBoardDetailResult(ENums::POSITIVE);
        p->close();

        if(form.pageNo.toInt() == 1) m->setRepleList(dlist2);
        else
        {
            foreach(QObject* o, m->noticeList())
            {
                Univ* m = qobject_cast<Univ*>(o);
                m->show(true);
            }
            m->appendRepleList(dlist2);
        }

        setSession(jsonObj);
    } else setGetCourseBoardDetailResult(ENums::NAGATIVE);

    setRefreshWorkResult(ENums::FINISHED_COURSENOTICECOMMENT);
    deleteLater();
    emit next();
}

int NetWorker::setCourseBoardArticle(int boardNo, QString title, QString contents)
{
    if(boardNo < 1) return 2;

    m->setShowIndicator(true);
    form.contents = NativeApp::getInstance()->toUnicode(contents);
//    message("form.contents: " + form.contents);

#if defined(Q_OS_ANDROID)
    form.boardNo = QString("%1").arg(boardNo);
    form.title = title;
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andSetCourseBoardArticle(form.boardNo, form.title, form.contents); });
    connect(NativeApp::getInstance(), SIGNAL(procSetCourseBoardArticleResult(QByteArray)), this, SLOT(procSetCourseBoardArticleResult(QByteArray)));
    return 1;
#endif

    QUrlQuery q;
    q.addQueryItem("board_no", QString("%1").arg(boardNo));
    q.addQueryItem("title", title);
    q.addQueryItem("contents", form.contents);
    m_hosts.append(new NetHost("post", "setCourseBoardArticle", q, [&]()-> void { procSetCourseBoardArticleResult(m_netReply->readAll()); }));

    return 1;
}

void NetWorker::procSetCourseBoardArticleResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procSetCourseBoardArticleResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();
    if(isOpen(jsonObj) && isSuccess(jsonObj))
    {
        ListParser* p = new ListParser("setCourseBoardArticle", "");
        p->start()->setObj(jsonObj);
        int noBoard = p->dInt("board_no");
        int noBoardArticle = p->dInt("board_article_no");
        m->noticeDetail()->setBoardNo(noBoard);
        m->noticeDetail()->setBoardArticleNo(noBoardArticle);
        p->end()->close();
        changeCreateArticleResult(ENums::POSITIVE);
    }
    else
    {
        m->setShowIndicator(false);
        error();
    }

    deleteLater();
    emit next();
}

int NetWorker::updateCourseBoardArticle(int boardNo, int boardArticleNo, int index, QString title, QString contents)
{
    if(!isValidUser()) return 0;
    if(boardNo < 1) return 2;
    if(boardArticleNo < 1) return 3;

    m->setShowIndicator(true);
    form.currentIndex = index;
    form.title = toUnicode(title);
    form.contents = toUnicode(contents);

#if defined(Q_OS_ANDROID)
    form.boardNo = QString("%1").arg(boardNo);
    form.boardArticleNo = QString("%1").arg(boardArticleNo);

    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andUpdateCourseBoardArticle(form.boardNo, form.boardArticleNo, form.title, form.contents); });
    connect(NativeApp::getInstance(), SIGNAL(procUpdateCourseBoardArticleResult(QByteArray)), this, SLOT(procUpdateCourseBoardArticleResult(QByteArray)));
    return 1;
#endif

    QUrlQuery q;
    q.addQueryItem("board_no", QString("%1").arg(boardNo));
    q.addQueryItem("board_article_no", QString("%1").arg(boardArticleNo));
    q.addQueryItem("title", form.title);
    q.addQueryItem("contents", form.contents);
    m_hosts.append(new NetHost("post", "updateCourseBoardArticle", q, [&]()-> void { procUpdateCourseBoardArticleResult(m_netReply->readAll()); }));
    return 1;
}

void NetWorker::procUpdateCourseBoardArticleResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procUpdateCourseBoardArticleResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();
    if(isOpen(jsonObj) && isSuccess(jsonObj))
    {
        Univ* u = qobject_cast<Univ*>(m->noticeList()[form.currentIndex]);
        u->setTitle(form.title);
        u->setWriteDate(QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss"));//현재 시간
        changeCreateArticleResult(ENums::POSITIVE);
    }
    else
    {
        m->setShowIndicator(false);
        error();
    }
    deleteLater();
    emit next();
}

int NetWorker::deleteCourseBoardArticle(int boardNo, int boardArticleNo)
{
    if(!isValidUser()) return 0;
    if(boardNo < 1) return 2;
    if(boardArticleNo < 1) return 3;

#if defined(Q_OS_ANDROID)
    form.boardNo = QString("%1").arg(boardNo);
    form.boardArticleNo = QString("%1").arg(boardArticleNo);
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andDeleteCourseBoardArticle(form.boardNo, form.boardArticleNo); });
    connect(NativeApp::getInstance(), SIGNAL(procDeleteCourseBoardArticleResult(QByteArray)), this, SLOT(procDeleteCourseBoardArticleResult(QByteArray)));
    return 1;
#endif
    QUrlQuery q;
    q.addQueryItem("board_no", QString("%1").arg(boardNo));
    q.addQueryItem("board_article_no", QString("%1").arg(boardArticleNo));
    m_hosts.append(new NetHost("post", "deleteCourseBoardArticle", q, [&]()-> void { procDeleteCourseBoardArticleResult(m_netReply->readAll()); }));
    return 1;
}

void NetWorker::procDeleteCourseBoardArticleResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procDeleteCourseBoardArticleResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();
    if(isOpen(jsonObj) && isSuccess(jsonObj))
    {
        chagneDeleteCourseBoardArticleResult(ENums::POSITIVE);
    }
    else
    {
        m->setShowIndicator(false);
        error();
    }

    deleteLater();
    emit next();
}

int NetWorker::setCourseBoardArticleReple(int boardNo, int boardArticleNo, QString contents)
{
    if(!isValidUser()) return 0;
    if(boardNo < 1) return 2;

    form.contents = toUnicode(contents);

#if defined(Q_OS_ANDROID)
    form.boardNo = QString("%1").arg(boardNo);
    form.boardArticleNo = QString("%1").arg(boardArticleNo);
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andSetCourseBoardArticleReple(form.boardNo, form.boardArticleNo, form.contents); });
    connect(NativeApp::getInstance(), SIGNAL(procSetCourseBoardArticleRepleResult(QByteArray)), this, SLOT(procSetCourseBoardArticleRepleResult(QByteArray)));
    return 1;
#endif

    QUrlQuery q;
    q.addQueryItem("board_no", QString("%1").arg(boardNo));
    q.addQueryItem("board_article_no", QString("%1").arg(boardArticleNo));
    q.addQueryItem("contents", form.contents);
    m_hosts.append(new NetHost("post", "setCourseBoardArticleReple", q, [&]()-> void { procSetCourseBoardArticleRepleResult(m_netReply->readAll()); }));
    return 1;
}

void NetWorker::procSetCourseBoardArticleRepleResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procSetCourseBoardArticleRepleResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();
    if(isOpen(jsonObj) && isSuccess(jsonObj))
    {
        Univ* comment = new Univ();
        comment->setWriteDate(QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss"));//현재 시간.
        comment->setNickname(settings->nickName());//작성자 닉네임.
        comment->setProfileImage(settings->profileImage());  //프로필 이미지
        comment->setProfileThumbNailUrl(settings->thumbnailImage()); //프로필 썸네일 이미지
        comment->setRepleNo(jsonObj["reple_no"].toInt());//댓글 번호.
        comment->setContents(form.contents);//댓글 내용.
        comment->setUserNo(settings->noUser()); //작성자
        comment->setGood(0);

        QObject* o = qobject_cast<QObject*>(comment);
        m->insertRepleList(0, o);
    }
    else error();

    deleteLater();
    emit next();
}

int NetWorker::updateCourseBoardArticleReple(int repleNo, QString contents)
{
    if(!isValidUser()) return 0;
    if(repleNo < 1) return 2;

    form.repleNo = QString("%1").arg(repleNo);
    form.contents = toUnicode(contents);

#if defined(Q_OS_ANDROID)
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andUpdateCourseBoardArticleReple(form.repleNo, form.contents); });
    connect(NativeApp::getInstance(), SIGNAL(procUpdateCourseBoardArticleRepleResult(QByteArray)), this, SLOT(procUpdateCourseBoardArticleRepleResult(QByteArray)));
    return 1;
#endif
    QUrlQuery q;
    q.addQueryItem("reple_no", form.repleNo);
    q.addQueryItem("contents", form.contents);
    m_hosts.append(new NetHost("post", "updateCourseBoardArticleReple", q, [&]()-> void { procUpdateCourseBoardArticleRepleResult(m_netReply->readAll()); }));
    return 1;
}

void NetWorker::procUpdateCourseBoardArticleRepleResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procUpdateCourseBoardArticleRepleResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();
    if(isOpen(jsonObj) && isSuccess(jsonObj))
    {
        int index = 0;
        for(QObject* o : m->repleList())
        {
            Univ* u = qobject_cast<Univ*>(o);
            if(u->repleNo() == form.repleNo.toInt())
            {
                u->setContents(form.contents);
                u->setWriteDate(QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss"));
                setUpdateCourseBoardArticleRepleResult(ENums::POSITIVE);
                break;
            }
            index++;
        }
    }
    else error();

    deleteLater();
    emit next();
}

int NetWorker::deleteCourseBoardArticleReple(int repleNo)
{
    if(!isValidUser()) return 0;
    if(repleNo < 1) return 2;
    form.repleNo = QString("%1").arg(repleNo);

#if defined(Q_OS_ANDROID)
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andDeleteCourseBoardArticleReple(form.repleNo); });
    connect(NativeApp::getInstance(), SIGNAL(procDeleteCourseBoardArticleRepleResult(QByteArray)), this, SLOT(procDeleteCourseBoardArticleRepleResult(QByteArray)));
    return 1;
#endif
    QUrlQuery q;
    q.addQueryItem("reple_no", form.repleNo);
    m_hosts.append(new NetHost("post", "deleteCourseBoardArticleReple", q, [&]()-> void { procDeleteCourseBoardArticleRepleResult(m_netReply->readAll()); }));
    return 1;
}

void NetWorker::procDeleteCourseBoardArticleRepleResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procDeleteCourseBoardArticleRepleResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();
    if(isOpen(jsonObj) && isSuccess(jsonObj))
    {
        int index = 0;
        for(QObject* o : m->repleList())
        {
            Univ* u = qobject_cast<Univ*>(o);
            if(u->repleNo() == form.repleNo.toInt())
            {
                m->deleteRepleList(index);
                break;
            }
            index++;
        }
    }
    else error();

    deleteLater();
    emit next();
}

int NetWorker::setBoardReport(int boardNo, int boardArticleNo, int repleNo, int reportType, QString reason)
{
    if(!isValidUser()) return 0;

    form.reason = toUnicode(reason);
#if defined(Q_OS_ANDROID)
    form.boardNo = QString("%1").arg(boardNo);
    form.boardArticleNo = QString("%1").arg(boardArticleNo);
    form.repleNo = QString("%1").arg(repleNo);
    form.reportType = QString("%1").arg(reportType);
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andSetBoardReport(form.boardNo, form.boardArticleNo, form.repleNo, form.reportType, form.reason); });
    connect(NativeApp::getInstance(), SIGNAL(procSetBoardReportResult(QByteArray)), this, SLOT(procSetBoardReportResult(QByteArray)));
    return 1;
#endif
    QUrlQuery q;
    q.addQueryItem("board_no", QString("%1").arg(boardNo));
    q.addQueryItem("board_article_no", QString("%1").arg(boardArticleNo));
    q.addQueryItem("reple_no", QString("%1").arg(repleNo));
    q.addQueryItem("report_type", QString("%1").arg(reportType));
    q.addQueryItem("reason", form.reason);
    m_hosts.append(new NetHost("post", "setBoardReport", q, [&]()-> void { procSetBoardReportResult(m_netReply->readAll()); }));
    return 1;
}

void NetWorker::procSetBoardReportResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procSetBoardReportResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();
    if(isOpen(jsonObj) && isSuccess(jsonObj))
    {
        setSetBoardReportResult(ENums::POSITIVE);
    }
    else error();

    deleteLater();
    emit next();
}

int NetWorker::getClipList(int courseNo)
{
    if(courseNo < 1) return 2;
    setRefreshWorkResult(ENums::WORKING_CLIPLIST);

#if defined(Q_OS_ANDROID)
    form.courseNo = QString("%1").arg(courseNo);
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andGetClipList(form.courseNo); });
    connect(NativeApp::getInstance(), SIGNAL(procGetClipListResult(QByteArray)), this, SLOT(procGetClipListResult(QByteArray)));
    return 1;
#endif

    QUrlQuery q;
    q.addQueryItem("course_no", QString("%1").arg(courseNo));
    FUNC func = [&]()-> void { procGetClipListResult(m_netReply->readAll()); };
    m_hosts.append(new NetHost("post", "getClipList", q, func));
    m_delayedHosts.append(new NetHost("post", "getClipList", q, func));
    return 1;
}

void NetWorker::procGetClipListResult(QByteArray result)
{
    setRefreshWorkResult(ENums::FINISHED_CLIPLIST);

#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procGetClipListResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();
    if(isOpen(jsonObj) && isSuccess(jsonObj))
    {
        ListParser* p = (new ListParser("getClipList", ""))->setObj(jsonObj)->start();
        m->courseDetail()->setDeliveryFlag(p->dInt("delivery_flag"));
        m->courseDetail()->setServiceTitle(p->dStr("service_title"));

        QJsonArray jsonArr = jsonObj["data_list1"].toArray();
        QList<QObject*> dlist1;
        p = new ListParser("getClipList", "data_list1");
        foreach(const QJsonValue &value, jsonArr)
        {
            p->setObj(value.toObject())->start();
            Univ* d = new Univ();
            d->setCourseNo(p->dInt("course_no"));
            int lessonSubNo = p->dInt("lesson_subitem_no");
            d->setLessonSubitemNo(lessonSubNo);
            d->setTitle(p->dStr("title"));
            d->setLessonTitle(p->dStr("lesson_title"));
            d->setRequiredLearningTimeInSeconds(p->dInt("required_learning_time_in_secondes"));
            d->setDisplayOrder(p->dInt("display_order"));
            d->setImageUrl(p->dStr("image_url"));
            d->setThumbnailUrl(p->dStr("thumbnail_url"));
            d->setLikeCount(p->dInt("like_count"));
            d->setViewCount(p->dInt("view_count"));

            QJsonArray jsonArr2 = jsonObj["data_list2"].toArray();
            foreach(const QJsonValue &value2, jsonArr2)
            {
                QJsonObject obj = value2.toObject();
                if(lessonSubNo == obj["lesson_subitem_no"].toInt())
                {
                    d->setAttendanceCode(dInt(obj, 999, "attendance_code_code"));
                    break;
                }
            }
            p->end();

            QObject* o = qobject_cast<QObject*>(d);
            dlist1.append(o);
        }
        p->close();
        m->setClipList(dlist1);
        setSession(jsonObj);
    }

    deleteLater();
    emit next();
}

int NetWorker::getClipDetail(int lessonSubNo, int courseNo)
{
    if(courseNo < 1) return 2;
    if(lessonSubNo < 1) return 3;

    form.courseNo = QString("%1").arg(courseNo);
    form.clipNo = lessonSubNo;

#if defined(Q_OS_ANDROID)
    form.lessonSubitemNo = QString("%1").arg(lessonSubNo);
    form.courseNo = QString("%1").arg(courseNo);
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andGetClipDetail(form.lessonSubitemNo, form.courseNo); });
    connect(NativeApp::getInstance(), SIGNAL(procGetClipDetailResult(QByteArray)), this, SLOT(procGetClipDetailResult(QByteArray)));
    return 1;
#endif

    QUrlQuery q;
    q.addQueryItem("course_no", QString("%1").arg(courseNo));
    q.addQueryItem("lesson_subitem_no", QString("%1").arg(lessonSubNo));
    FUNC func = [&]()-> void { procGetClipDetailResult(m_netReply->readAll()); };
    m_hosts.append(new NetHost("post", "getClipDetail", q, func));
    m_delayedHosts.append(new NetHost("post", "getClipDetail", q, func));
    return 1;
}

void NetWorker::procGetClipDetailResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procGetClipDetailResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();
    if(isOpen(jsonObj) && isSuccess(jsonObj))
    {
        ListParser* p = (new ListParser("getClipDetail", ""))->setObj(jsonObj)->start();
        m->clipDetail()->setTitle(p->dStr("title"));
        m->clipDetail()->setLinkUrl(p->dStr("url"));
        m->clipDetail()->setRepleCount(p->dInt("reple_count"));
        m->clipDetail()->setLike(p->dInt("is_clip_like"));
        m->clipDetail()->setIsVerticalVideo(p->dInt("is_vertical_video"));


        QJsonArray jsonArr = jsonObj["data_list"].toArray();
        QList<QObject*> quizList;
        p = new ListParser("getClipDetail", "data_list");

        int prevQuizNo = 0;
        foreach(const QJsonValue &value, jsonArr)
        {
            QJsonObject obj = value.toObject();
            if(prevQuizNo != obj["quiz_no"].toInt())
            {
                p->setObj(value.toObject())->start();
                Quiz* d = new Quiz();
                prevQuizNo = p->dInt("quiz_no");
                d->setQuizNo(prevQuizNo);
                d->setQuizType(p->dInt("quiz_type"));
                d->setQuizText(p->dStr("quiz_text"));
                d->setQuizTextFileUrl(p->dStr("quiz_text_file_url"));
                d->setQuizScore(p->dInt("quiz_score"));
                d->setDifficulty(p->dInt("difficulty"));
                d->setDescription(p->dStr("description"));
                p->end();

                QObject* o = qobject_cast<QObject*>(d);
                quizList.append(o);
            }
        }

        p = (new ListParser("getClipDetail", ""))->setObj(jsonObj)->start();
        jsonArr = jsonObj["data_list"].toArray();
        int answerNo = 1;
        foreach(const QJsonValue &value, jsonArr)
        {
            p->setObj(value.toObject())->start();
            int quizNo = p->dInt("quiz_no");
            Example* d = new Example();
            int correctExampleNo = p->dInt("correct_example_no");
            int exampleNo = p->dInt("example_no");
            if(correctExampleNo == exampleNo)
            {
                for(QObject* obj : quizList)
                {
                    Quiz* o = qobject_cast<Quiz*>(obj);
                    if(o->quizNo() == quizNo)
                    {
                        o->setAnswerNo(answerNo);
                        break;
                    }
                }
            }
            d->setExampleNo(exampleNo);
            int order = p->dInt("display_order");
            d->setDisplayOrder(order);
//            d->select(order==1?true:false);
            d->setExampleType(p->dInt("example_type"));
            d->setExample(p->dStr("examples"));
            p->end();

            for(QObject* obj : quizList)
            {
                Quiz* o = qobject_cast<Quiz*>(obj);
                if(o->quizNo() == quizNo)
                {
                    o->appendExamples(d);
                    break;
                }
            }

            answerNo++;
        }
        p->close();
        m->setQuizList(quizList);
        setSession(jsonObj);
        setGetClipDetailResult(ENums::POSITIVE);
    }

    deleteLater();
    emit next();
}

int NetWorker::getClipDetailForDelivery(int lessonSubNo, int courseNo)
{
    if(!isValidUser()) return 0;
    if(courseNo < 1) return 2;
    if(lessonSubNo < 1) return 3;

    form.courseNo = QString("%1").arg(courseNo);
    form.clipNo = lessonSubNo;

#if defined(Q_OS_ANDROID)
    form.lessonSubitemNo = QString("%1").arg(lessonSubNo);
    form.courseNo = QString("%1").arg(courseNo);
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andGetClipDetailForDelivery(form.lessonSubitemNo, form.courseNo); });
    connect(NativeApp::getInstance(), SIGNAL(procGetClipDetailForDeliveryResult(QByteArray)), this, SLOT(procGetClipDetailForDeliveryResult(QByteArray)));
    return 1;
#endif
    QUrlQuery q;
    q.addQueryItem("course_no", QString("%1").arg(courseNo));
    q.addQueryItem("lesson_subitem_no", QString("%1").arg(lessonSubNo));
    FUNC func = [&]()-> void { procGetClipDetailForDeliveryResult(m_netReply->readAll()); };
    m_hosts.append(new NetHost("post", "getClipDetailForDelivery", q, func));
    return 1;
}

void NetWorker::procGetClipDetailForDeliveryResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procGetClipDetailForDeliveryResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();
    if(isOpen(jsonObj) && isSuccess(jsonObj))
    {
        ListParser* p = (new ListParser("getClipDetail", ""))->setObj(jsonObj)->start();
        m->clipDetail()->setTitle(p->dStr("title"));
        m->clipDetail()->setLinkUrl(p->dStr("url"));
        m->clipDetail()->setRepleCount(p->dInt("reple_count"));
        m->clipDetail()->setLike(p->dInt("is_clip_like"));
        m->clipDetail()->setIsVerticalVideo(p->dInt("is_vertical_video"));

        QJsonArray jsonArr = jsonObj["data_list"].toArray();
        QList<QObject*> quizList;
        p = new ListParser("getClipDetail", "data_list");

        int prevQuizNo = 0;
        foreach(const QJsonValue &value, jsonArr)
        {
            QJsonObject obj = value.toObject();
            if(prevQuizNo != obj["quiz_no"].toInt())
            {
                p->setObj(value.toObject())->start();
                Quiz* d = new Quiz();
                prevQuizNo = p->dInt("quiz_no");
                d->setQuizNo(prevQuizNo);
                d->setQuizType(p->dInt("quiz_type"));
                d->setQuizText(p->dStr("quiz_text"));
                d->setQuizTextFileUrl(p->dStr("quiz_text_file_url"));
                d->setQuizScore(p->dInt("quiz_score"));
                d->setDifficulty(p->dInt("difficulty"));
                d->setDescription(p->dStr("description"));
                p->end();

                QObject* o = qobject_cast<QObject*>(d);
                quizList.append(o);
            }
        }

        p = (new ListParser("getClipDetail", ""))->setObj(jsonObj)->start();
        jsonArr = jsonObj["data_list"].toArray();
        int answerNo = 1;
        foreach(const QJsonValue &value, jsonArr)
        {
            p->setObj(value.toObject())->start();
            int quizNo = p->dInt("quiz_no");
            Example* d = new Example();
            int correctExampleNo = p->dInt("correct_example_no");
            int exampleNo = p->dInt("example_no");
            if(correctExampleNo == exampleNo)
            {
                for(QObject* obj : quizList)
                {
                    Quiz* o = qobject_cast<Quiz*>(obj);
                    if(o->quizNo() == quizNo)
                    {
                        o->setAnswerNo(answerNo);
                        break;
                    }
                }
            }
            d->setExampleNo(exampleNo);
            d->setDisplayOrder(p->dInt("display_order"));
            d->setExampleType(p->dInt("example_type"));
            d->setExample(p->dStr("examples"));
            p->end();

            for(QObject* obj : quizList)
            {
                Quiz* o = qobject_cast<Quiz*>(obj);
                if(o->quizNo() == quizNo)
                {
                    o->appendExamples(d);
                    break;
                }
            }

            answerNo++;
        }
        p->close();
        m->setQuizList(quizList);
        setSession(jsonObj);
        setGetClipDetailResult(ENums::POSITIVE);
    }

    deleteLater();
    emit next();
}

int NetWorker::setQuiz(int quizNo, int answerType, int exampleNo, int lessonSubitemNo, int courseNo) {

    if(!isValidUser()) return 0;
    if (courseNo < 1) return 2;

    form.clipNo = lessonSubitemNo;
    form.courseNo = QString("%1").arg(courseNo);

#if defined(Q_OS_ANDROID)
    form.quizNo = QString("%1").arg(quizNo);
    form.answerType = QString("%1").arg(answerType);
    form.exampleNo = QString("%1").arg(exampleNo);
    form.lessonSubitemNo = QString("%1").arg(lessonSubitemNo);
    form.courseNo = QString("%1").arg(courseNo);
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andSetQuiz(form.quizNo, form.answerType, form.exampleNo, form.lessonSubitemNo, form.courseNo); });
    connect(NativeApp::getInstance(), SIGNAL(procSetQuizResult(QByteArray)), this, SLOT(procSetQuizResult(QByteArray)));
    return 1;
#endif

    QUrlQuery q;
    q.addQueryItem("quiz_no", QString("%1").arg(quizNo));
    q.addQueryItem("answer_type", QString("%1").arg(answerType));
    q.addQueryItem("example_no", QString("%1").arg(exampleNo));
    q.addQueryItem("lesson_subitem_no", QString("%1").arg(lessonSubitemNo));
    q.addQueryItem("course_no", QString("%1").arg(courseNo));
    m_hosts.append(new NetHost("post", "setQuiz", q, [&]()->void { procSetQuizResult(m_netReply->readAll()); }));
    return 1;
}

void NetWorker::procSetQuizResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procSetQuizResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();
    if(isOpen(jsonObj) && isSuccess(jsonObj))
    {
        for(QObject* o : m->clipList())
        {
            Univ* u = qobject_cast<Univ*>(o);
            if(u->lessonSubitemNo()==form.clipNo && u->courseNo()==form.courseNo.toInt())
            {
                u->setAttendanceCode(1);
                break;
            }
        }
    }
    else error();

    deleteLater();
    emit next();
}

void NetWorker::getClipSharing(int lessonSubitemNo)
{
    if (lessonSubitemNo < 1) return;

#if defined(Q_OS_ANDROID)
    form.lessonSubitemNo = QString("%1").arg(lessonSubitemNo);
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andGetClipSharing(form.lessonSubitemNo); });
    connect(NativeApp::getInstance(), SIGNAL(procGetClipSharingResult(QByteArray)), this, SLOT(procGetClipSharingResult(QByteArray)));
    return;
#endif
    QUrlQuery q;
    q.addQueryItem("lesson_subitem_no", QString("%1").arg(lessonSubitemNo));
    m_hosts.append(new NetHost("post", "getClipSharing", q, [&]()->void { procGetClipSharingResult(m_netReply->readAll()); }));
}

void NetWorker::procGetClipSharingResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procGetClipSharingResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    if (isOpen(jsonObj) && isSuccess(jsonObj)) {
        m->setClipHttpUrl(jsonObj["clip_http_url"].toString());

        bool serverResult = isOpen(jsonObj) && isSuccess(jsonObj);
        if(!serverResult) setGetClipSharingResult(ENums::NAGATIVE);
        else setGetClipSharingResult(ENums::POSITIVE);
    }

    deleteLater();
    emit next();
}

int NetWorker::setClipLike(int courseNo, int lessonSubitemNo, int isLike)
{
    if(!isValidUser()) return 0;
    if(courseNo < 1) return 2;
    if(lessonSubitemNo < 1) return 3;

    message("Course No: " + QString("%1").arg(courseNo));
#if defined(Q_OS_ANDROID)
    form.lessonSubitemNo = QString("%1").arg(lessonSubitemNo);
    form.courseNo = QString("%1").arg(courseNo);
    form.isLike = QString("%1").arg(isLike);
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andSetClipLike(form.courseNo, form.lessonSubitemNo, form.isLike); });
    connect(NativeApp::getInstance(), SIGNAL(procSetClipLikeResult(QByteArray)), this, SLOT(procSetClipLikeResult(QByteArray)));
    return 1;
#endif
    QUrlQuery q;
    q.addQueryItem("lesson_subitem_no", QString("%1").arg(lessonSubitemNo));
    q.addQueryItem("course_no", QString("%1").arg(courseNo));
    q.addQueryItem("is_like", QString("%1").arg(isLike));

    m_hosts.append(new NetHost("post", "setClipLike", q, [&]()->void { procSetClipLikeResult(m_netReply->readAll()); }));
    return 1;
}

void NetWorker::procSetClipLikeResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procSetClipLikeResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    if (isOpen(jsonObj) && isSuccess(jsonObj))
        setSetClipLikeResult(ENums::POSITIVE);

    deleteLater();
    emit next();
}

void NetWorker::getClipRepleList(int lessonSubitemNo, int filterType, int nowPage)
{
    if (lessonSubitemNo < 1 || filterType < 0 || nowPage < 1) return;

    setRefreshWorkResult(ENums::WORKING_CLIPCOMMENT);
    form.pageNo = QString("%1").arg(nowPage);
    m->setCurrentClipRepleListFilterType(filterType);
#if defined(Q_OS_ANDROID)
    form.lessonSubitemNo = QString("%1").arg(lessonSubitemNo);
    form.filterType = QString("%1").arg(filterType);
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andGetClipRepleList(form.lessonSubitemNo, form.filterType, form.pageNo); });
    connect(NativeApp::getInstance(), SIGNAL(procGetClipRepleListResult(QByteArray)), this, SLOT(procGetClipRepleListResult(QByteArray)));
    return;
#endif
    QUrlQuery q;
    q.addQueryItem("lesson_subitem_no", QString("%1").arg(lessonSubitemNo));
    q.addQueryItem("filter_type", QString("%1").arg(filterType));
    q.addQueryItem("now_page", form.pageNo);
    FUNC func = [&]()->void { procGetClipRepleListResult(m_netReply->readAll()); };
    m_hosts.append(new NetHost("post", "getClipRepleList", q, func));
    m_delayedHosts.append(new NetHost("post", "getClipRepleList", q, func));
}

void NetWorker::procGetClipRepleListResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procGetClipRepleListResult(QByteArray)));
    if(!preventDoubleCall(&m_doubleCallPreventionVarGetClipRepleList)) return;
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    if (isOpen(jsonObj) && isSuccess(jsonObj))
    {
        ListParser* p = (new ListParser("getClipRepleList", ""))->setObj(jsonObj)->start();
        m->clipDetail()->setRepleCount(p->dInt("total_count"));
        QJsonArray jsonArr = jsonObj["data_list"].toArray();
        QList<QObject*> dlist;

        p = new ListParser("getClipRepleList", "data_list");

        foreach(const QJsonValue &value, jsonArr) {

            p->setObj(value.toObject())->start();
            Univ* d = new Univ();

            d->setBoardArticleNo(p->dInt("board_article_no"));
            d->setBoardNo(p->dInt("board_no"));
            d->setNickname(p->dStr("nickname"));
            d->setContents(p->dStr("contents"));
            d->setLikeCount(p->dInt("like_count"));
            d->setViewCount(p->dInt("view_count"));
            d->setRepleCount(p->dInt("reple_count"));
            d->setReportCount(p->dInt("report_count"));
            d->setUpdateDate(p->dStr("update_date"));
            d->setGood(p->dInt("is_good"));
            d->setUserNo(p->dInt("user_no"));
            d->setLike(p->dInt("user_likes"));
            d->setProfileImage(p->dStr("profile_image"));
            d->setProfileThumbNailUrl(p->dStr("profile_thumbnail_url"));
            d->setTitle(p->dStr("clip_name"));

            QString filename = p->dStr("unit_attach_file_name");
            QString thumbnailUrl = p->dStr("unit_attach_thumbnail_url");
            QString fileurl = p->dStr("unit_attach_image_url");
            QList<QObject*> fileList;
            File* file = new File();
            file->setFileName(filename);
            file->setFileUrl(fileurl);
            file->setFileThumbNailUrl(thumbnailUrl);

            QObject* fo = qobject_cast<QObject*>(file);
            fileList.append(fo);
            d->setFileList(fileList);

            QObject* o = qobject_cast<QObject*>(d);
            dlist.append(o);
        }
        p->close();

        if(form.pageNo.toInt() == 1) m->setRepleList(dlist);
        else
        {
            foreach(QObject* o, m->noticeList())
            {
                Univ* m = qobject_cast<Univ*>(o);
                m->show(true);
            }
            m->appendRepleList(dlist);
        }

        setSession(jsonObj);
    }
    setRefreshWorkResult(ENums::FINISHED_CLIPCOMMENT);
    deleteLater();
    emit next();
}

int NetWorker::setClipReple(int boardNo, QString contents, QString unitAttachFileName, QString unitAttachImageUrl, QString unitAttachThumbnailUrl)
{
    if(!isValidUser()) return 0;
    if (boardNo < 1) return 2;

#if defined(Q_OS_ANDROID)
    form.boardNo = QString("%1").arg(boardNo);
    form.contents = contents;
    form.unitAttachFileName = unitAttachFileName;
    form.unitAttachImageUrl = unitAttachImageUrl;
    form.unitAttachThumbnailUrl = unitAttachThumbnailUrl;
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andSetClipReple(form.boardNo, form.contents, form.unitAttachFileName, form.unitAttachImageUrl, form.unitAttachThumbnailUrl); });
    connect(NativeApp::getInstance(), SIGNAL(procSetClipRepleResult(QByteArray)), this, SLOT(procSetClipRepleResult(QByteArray)));
    return 1;
#endif
    QUrlQuery q;
    q.addQueryItem("lesson_subitem_no", QString("%1").arg(boardNo));
    q.addQueryItem("contents", contents);
    q.addQueryItem("unit_attach_file_name", unitAttachFileName);
    q.addQueryItem("unit_attach_image_url", unitAttachImageUrl);
    q.addQueryItem("unit_attach_thumbnail_url", unitAttachThumbnailUrl);
    m_hosts.append(new NetHost("post", "setClipReple", q, [&]()->void { procSetClipRepleResult(m_netReply->readAll()); }));
    return 1;
}

void NetWorker::procSetClipRepleResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procSetClipRepleResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    if (isOpen(jsonObj) && isSuccess(jsonObj))
    {
        setSetClipRepleResult(ENums::POSITIVE);
        int currentFilterType = m->currentClipRepleListFilterType();
        getClipRepleList(m->currentClipNo(), currentFilterType, 1);
    } else {
        setSetClipRepleResult(ENums::NAGATIVE);
    }

    deleteLater();
    emit next();
}

int NetWorker::updateClip(int boardArticleNo, int boardNo, QString contents, int modifyFile, QString unitAttachFileName, QString unitAttachImageUrl, QString unitAttachThumbnailUrl)
{
    if(!isValidUser()) return 0;
    if (boardArticleNo < 1) return 2;
    if (boardNo < 1) return 3;

#if defined(Q_OS_ANDROID)
    form.boardNo = QString("%1").arg(boardNo);
    form.boardArticleNo = QString("%1").arg(boardArticleNo);
    form.isImageFileModify = QString("%1").arg(modifyFile);
    form.contents = toUnicode(contents);
    form.unitAttachFileName = unitAttachFileName;
    form.unitAttachImageUrl = unitAttachImageUrl;
    form.unitAttachThumbnailUrl = unitAttachThumbnailUrl;
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andUpdateClip(form.boardArticleNo, form.boardNo, form.contents,
                                   form.isImageFileModify, form.unitAttachFileName, form.unitAttachImageUrl, form.unitAttachThumbnailUrl); });
    connect(NativeApp::getInstance(), SIGNAL(procUpdateClipResult(QByteArray)), this, SLOT(procUpdateClipResult(QByteArray)));
    return 1;
#endif
    QUrlQuery q;
    q.addQueryItem("board_article_no", QString("%1").arg(boardArticleNo));
    q.addQueryItem("board_no", QString("%1").arg(boardNo));
    q.addQueryItem("contents", contents);
    q.addQueryItem("modify_file", QString("%1").arg(modifyFile));
    q.addQueryItem("unit_attach_file_name", unitAttachFileName);
    q.addQueryItem("unit_attach_image_url", unitAttachImageUrl);
    q.addQueryItem("unit_attach_thumbnail_url", unitAttachThumbnailUrl);
    m_hosts.append(new NetHost("post", "updateClip", q, [&]()->void { procUpdateClipResult(m_netReply->readAll()); }));

    return 1;
}

void NetWorker::procUpdateClipResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procUpdateClipResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    if (isOpen(jsonObj) && isSuccess(jsonObj))
    {
        int currentFilterType = m->currentClipRepleListFilterType();
        getClipRepleList(m->currentClipNo(), currentFilterType, 1);
    }

    deleteLater();
    emit next();
}

int NetWorker::deleteClip(int boardArticleNo, int boardNo)
{
    if(!isValidUser()) return 0;
    if (boardArticleNo < 1) return 2;

#if defined(Q_OS_ANDROID)
    form.boardNo = QString("%1").arg(boardNo);
    form.boardArticleNo = QString("%1").arg(boardArticleNo);
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andDeleteClip(form.boardArticleNo, form.boardNo); });
    connect(NativeApp::getInstance(), SIGNAL(procDeleteClipResult(QByteArray)), this, SLOT(procDeleteClipResult(QByteArray)));
    return 1;
#endif
    QUrlQuery q;
    q.addQueryItem("board_article_no", QString("%1").arg(boardArticleNo));
    q.addQueryItem("board_no", QString("%1").arg(boardNo));
    m_hosts.append(new NetHost("post", "deleteClip", q, [&]()->void { procDeleteClipResult(m_netReply->readAll()); }));
    return 1;
}

void NetWorker::procDeleteClipResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procDeleteClipResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    if (isOpen(jsonObj) && isSuccess(jsonObj))
    {
        int currentFilterType = m->currentClipRepleListFilterType();
        getClipRepleList(m->currentClipNo(), currentFilterType, 1);
    }

    deleteLater();
    emit next();
}

int NetWorker::setClipRepleReport(int boardArticleNo, int boardNo, QString reason)
{
    if(!isValidUser()) return 0;
    if (boardNo < 1) return 2;

    form.reason = toUnicode(reason);

#if defined(Q_OS_ANDROID)
    form.boardNo = QString("%1").arg(boardNo);
    form.boardArticleNo = QString("%1").arg(boardArticleNo);
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andSetClipRepleReport(form.boardArticleNo, form.boardNo, form.reason); });
    connect(NativeApp::getInstance(), SIGNAL(procSetClipRepleReportResult(QByteArray)), this, SLOT(procSetClipRepleReportResult(QByteArray)));
    return 1;
#endif
    QUrlQuery q;
    q.addQueryItem("board_article_no", QString("%1").arg(boardArticleNo));
    q.addQueryItem("board_no", QString("%1").arg(boardNo));
    q.addQueryItem("reason", form.reason);
    m_hosts.append(new NetHost("post", "setClipRepleReport", q, [&]()->void { procSetClipRepleReportResult(m_netReply->readAll()); }));
    return 1;
}

void NetWorker::procSetClipRepleReportResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procSetClipRepleReportResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    if (isOpen(jsonObj) && isSuccess(jsonObj))
    {
        setSetClipRepleReportResult(ENums::POSITIVE);
    }
    else error();
    deleteLater();
    emit next();
}

int NetWorker::setClipRepleLike(int boardArticleNo, int boardNo, int isLike)
{
    if(!isValidUser()) return 0;
    if (boardNo < 1) return 2;
    if (boardArticleNo < 1) return 3;

#if defined(Q_OS_ANDROID)
    form.boardArticleNo = QString("%1").arg(boardArticleNo);
    form.boardNo = QString("%1").arg(boardNo);
    form.isLike = QString("%1").arg(isLike);
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andSetClipRepleLike(form.boardArticleNo, form.boardNo, form.isLike); });
    connect(NativeApp::getInstance(), SIGNAL(procSetClipRepleLikeResult(QByteArray)), this, SLOT(procSetClipRepleLikeResult(QByteArray)));
    return 1;
#endif
    QUrlQuery q;
    q.addQueryItem("board_article_no", QString("%1").arg(boardArticleNo));
    q.addQueryItem("board_no", QString("%1").arg(boardNo));
    q.addQueryItem("is_like", QString("%1").arg(isLike));

    m_hosts.append(new NetHost("post", "setClipRepleLike", q, [&]()->void { procSetClipRepleLikeResult(m_netReply->readAll()); }));
    return 1;
}

void NetWorker::procSetClipRepleLikeResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procSetClipRepleLikeResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();
    if (isOpen(jsonObj) && isSuccess(jsonObj))
    {
        setSetClipRepleLikeResult(ENums::POSITIVE);
        int currentFilterType = m->currentClipRepleListFilterType();
        getClipRepleList(m->currentClipNo(), currentFilterType, 1);
    } else
    {
        setSetClipRepleLikeResult(ENums::NAGATIVE);
    }

    deleteLater();
    emit next();
}

void NetWorker::getOtherUserProfile(int targetUserNo)
{
    if (targetUserNo < 1) return;

#if defined(Q_OS_ANDROID)
    form.targetUserNo = QString("%1").arg(targetUserNo);
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andGetOtherUserProfile(form.targetUserNo); });
    connect(NativeApp::getInstance(), SIGNAL(procGetOtherUserProfileResult(QByteArray)), this, SLOT(procGetOtherUserProfileResult(QByteArray)));
    return;
#endif
    QUrlQuery q;
    q.addQueryItem("target_user_no", QString("%1").arg(targetUserNo));
    m_hosts.append(new NetHost("post", "getOtherUserProfile", q, [&]()->void { procGetOtherUserProfileResult(m_netReply->readAll()); }));
}

void NetWorker::procGetOtherUserProfileResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procGetOtherUserProfileResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();
    if (isOpen(jsonObj) && isSuccess(jsonObj))
    {
        ListParser* p = (new ListParser("getOtherUserProfile", ""))->setObj(jsonObj)->start();
        m->user()->setName(p->dStr("name"));
        m->user()->setNickName(p->dStr("nickname"));
        m->user()->setProfileImage(p->dStr("profile_image"));
        m->user()->setProfileThumbNailUrl(p->dStr("profile_thumbnail_url"));
        m->user()->setSnsType(p->dInt("sns_type"));
        m->user()->setRecentDate(p->dStr("recent_date"));
        m->user()->setScore(p->dInt("score"));
        p->end();
    }

    deleteLater();
    emit next();
}

int NetWorker::setUserProfileReport(int targetUserNo, QString reason)
{
    if(!isValidUser()) return 0;
    if (targetUserNo < 1) return 2;

    form.reason = toUnicode(reason);
#if defined(Q_OS_ANDROID)
    form.targetUserNo = QString("%1").arg(targetUserNo);
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andSetUserProfileReport(form.targetUserNo, form.reason); });
    connect(NativeApp::getInstance(), SIGNAL(procSetUserProfileReportResult(QByteArray)), this, SLOT(procSetUserProfileReportResult(QByteArray)));
    return 1;
#endif
    QUrlQuery q;
    q.addQueryItem("target_user_no", QString("%1").arg(targetUserNo));
    q.addQueryItem("reason", form.reason);
    m_hosts.append(new NetHost("post", "setUserProfileReport", q, [&]()->void { procSetUserProfileReportResult(m_netReply->readAll()); }));
    return 1;
}

void NetWorker::procSetUserProfileReportResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procSetUserProfileReportResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();
    if (isOpen(jsonObj) && isSuccess(jsonObj)) setSetUserProfileReportResult(ENums::POSITIVE);
    else setSetUserProfileReportResult(ENums::NAGATIVE);

    deleteLater();
    emit next();
}

int NetWorker::updateStudyTime(int lessonSubitemNo, int studyTime)
{
    if(!isValidUser()) return 0;
    if (lessonSubitemNo < 1) return 2;

#if defined(Q_OS_ANDROID)
    form.lessonSubitemNo = QString("%1").arg(lessonSubitemNo);
    form.studyTime = QString("%1").arg(studyTime);
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andUpdateStudyTime(form.lessonSubitemNo, form.studyTime); });
    connect(NativeApp::getInstance(), SIGNAL(procUpdateStudyTimeResult(QByteArray)), this, SLOT(procUpdateStudyTimeResult(QByteArray)));
    return 1;
#endif
    QUrlQuery q;
    q.addQueryItem("lesson_subitem_no", QString("%1").arg(lessonSubitemNo));
    q.addQueryItem("study_time", QString("%1").arg(studyTime));
    m_hosts.append(new NetHost("post", "updateStudyTime", q, [&]()->void { procUpdateStudyTimeResult(m_netReply->readAll()); }));
    return 1;
}

void NetWorker::procUpdateStudyTimeResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procUpdateStudyTimeResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();
    if (isOpen(jsonObj) && isSuccess(jsonObj))
    {
        setSession(jsonObj);
    }
    deleteLater();
    emit next();
}

int NetWorker::setDeliveryService(int courseNo)
{
    if(!isValidUser()) return 0;
    if (courseNo < 1) return 2;

#if defined(Q_OS_ANDROID)
    form.courseNo = QString("%1").arg(courseNo);
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andSetDeliveryService(form.courseNo); });
    connect(NativeApp::getInstance(), SIGNAL(procSetDeliveryServiceResult(QByteArray)), this, SLOT(procSetDeliveryServiceResult(QByteArray)));
    return 1;
#endif
    QUrlQuery q;
    q.addQueryItem("course_no", QString("%1").arg(courseNo));
    m_hosts.append(new NetHost("post", "setDeliveryService", q, [&]()->void { procSetDeliveryServiceResult(m_netReply->readAll()); }));
    return 1;

}

void NetWorker::procSetDeliveryServiceResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procSetDeliveryServiceResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    if (isOpen(jsonObj) && isSuccess(jsonObj))
    {
        m->setDeliveryFlag(jsonObj["delivery_flag"].toInt());
        setDeliveryServiceResult(ENums::POSITIVE);
    }
    else setDeliveryServiceResult(ENums::NAGATIVE);

    deleteLater();
    emit next();
}

int NetWorker::setUnitComplete(int lessonSubitemNo, int courseNo)
{
    if(!isValidUser()) return 0;
    if (courseNo < 1) return 2;

    form.clipNo = lessonSubitemNo;
    form.courseNo = QString("%1").arg(courseNo);
#if defined(Q_OS_ANDROID)
    form.lessonSubitemNo = QString("%1").arg(lessonSubitemNo);
    form.courseNo = QString("%1").arg(courseNo);
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andSetUnitComplete(form.lessonSubitemNo, form.courseNo); });
    connect(NativeApp::getInstance(), SIGNAL(procSetUnitCompleteResult(QByteArray)), this, SLOT(procSetUnitCompleteResult(QByteArray)));
    return 1;
#endif
    QUrlQuery q;
    q.addQueryItem("lesson_subitem_no", QString("%1").arg(lessonSubitemNo));
    q.addQueryItem("course_no", QString("%1").arg(courseNo));
    FUNC func = [&]()->void { procSetUnitCompleteResult(m_netReply->readAll()); };
    m_hosts.append(new NetHost("post", "setUnitComplete", q, func));
    m_delayedHosts.append(new NetHost("post", "setUnitComplete", q, func));

    return 1;
}

void NetWorker::procSetUnitCompleteResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procSetUnitCompleteResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    if (isOpen(jsonObj) && isSuccess(jsonObj))
    {
        setSetUnitCompleteResult(ENums::POSITIVE);
        setSession(jsonObj);

        for(QObject* o : m->clipList())
        {
            Univ* u = qobject_cast<Univ*>(o);
            if(u->lessonSubitemNo()==form.clipNo && u->courseNo()==form.courseNo.toInt())
            {
                u->setAttendanceCode(1);
                break;
            }
        }
    }
    else error();

    deleteLater();
    emit next();
}

int NetWorker::setDeliveryServiceConfirm(int courseNo)
{
    if(!isValidUser()) return 0;
    if (courseNo < 1) return 2;

#if defined(Q_OS_ANDROID)
    form.courseNo = QString("%1").arg(courseNo);
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andSetDeliveryServiceConfirm(form.courseNo); });
    connect(NativeApp::getInstance(), SIGNAL(procSetDeliveryServiceConfirmResult(QByteArray)), this, SLOT(procSetDeliveryServiceConfirmResult(QByteArray)));
    return 1;
#endif
    QUrlQuery q;
    q.addQueryItem("course_no", QString("%1").arg(courseNo));
    m_hosts.append(new NetHost("post", "setDeliveryServiceConfirm", q, [&]()->void { procSetDeliveryServiceConfirmResult(m_netReply->readAll()); }));
    return 1;
}

void NetWorker::procSetDeliveryServiceConfirmResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procSetDeliveryServiceConfirmResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    if (isOpen(jsonObj) && isSuccess(jsonObj)) setDeliveryServiceConfirmResult(ENums::POSITIVE);
    else error();

    deleteLater();
    emit next();
}

void NetWorker::getSearchMain(int nowPage, QString searchKeyword, int searchType)
{
    if(nowPage == 1) m->setTotalSearchCount(0);
    else
    {
        if(!requestNextPage(m->totalSearchCount(), m->searchClipList().length()))
        return;
    }

    form.pageNo = QString("%1").arg(nowPage);

#if defined(Q_OS_ANDROID)
    form.searchKeyword = searchKeyword;
    form.searchType = QString("%1").arg(searchType);
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andGetSearchMain(form.pageNo, form.searchKeyword, form.searchType); });
    connect(NativeApp::getInstance(), SIGNAL(procGetSearchMainResult(QByteArray)), this, SLOT(procGetSearchMainResult(QByteArray)));
    return;
#endif
    QUrlQuery q;
    q.addQueryItem("now_page", QString("%1").arg(nowPage));
    q.addQueryItem("search_keyword", searchKeyword);
    q.addQueryItem("search_tyep", QString("%1").arg(searchType));
    FUNC func = [&]()->void { procGetSearchMainResult(m_netReply->readAll()); };
    m_hosts.append(new NetHost("post", "getSearchMain", q, func));
    m_delayedHosts.append(new NetHost("post", "getSearchMain", q, func));
}

void NetWorker::procGetSearchMainResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procGetSearchMainResult(QByteArray)));
    if(!preventDoubleCall(&m_doubleCallPreventionVarGetSearchMain)) return;
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    if (isOpen(jsonObj) && isSuccess(jsonObj))
    {
        ListParser* p = (new ListParser("getSearchMain", ""))->setObj(jsonObj)->start();

        m->setTotalSearchCount(jsonObj["total_count"].toInt());

        QJsonArray jsonArr = jsonObj["data_list"].toArray();
        QList<QObject*> dlist;
        p = new ListParser("getSearchMain", "data_list");

        if(form.searchType.toInt() == 0)
        {
            foreach(const QJsonValue &value, jsonArr)
            {
                p->setObj(value.toObject())->start();
                Univ* d = new Univ();
                d->setLessonSubitemNo(p->dInt("lesson_subitem_no"));
                d->setTitle(p->dStr("title"));
                d->setImageUrl(p->dStr("image_url"));
                d->setThumbnailUrl(p->dStr("thumbnail_url"));
                d->setViewCount(p->dInt("view_count"));
                d->setLikeCount(p->dInt("like_count"));
                d->setRepleCount(p->dInt("reple_count"));

                QString keywordStr = p->dStr("keyword");
                if(!keywordStr.isEmpty())
                {
                    keywordStr = "#" + keywordStr.remove(keywordStr.length()-1, 1).replace(",", " #");
                }
                d->setKeyword(keywordStr);
                d->setCourseNo(p->dInt("course_no"));
                p->end();

                QObject* o = qobject_cast<QObject*>(d);
                dlist.append(o);
            }
            if(form.pageNo.toInt() == 1)
            {
                m->setSearchClipList(dlist);
            }
            else
            {
                foreach(QObject* o, m->searchClipList())
                {
                    Univ* u = qobject_cast<Univ*>(o);
                    u->show(true);
                }
                m->appendSearchClipList(dlist);
            }
        }
        else
        {
            foreach(const QJsonValue &value, jsonArr)
            {
                p->setObj(value.toObject())->start();
                Univ* d = new Univ();
                d->setLessonSubitemNo(p->dInt("lesson_subitem_no"));
                d->setTitle(p->dStr("title"));
                d->setImageUrl(p->dStr("image_url"));
                d->setThumbnailUrl(p->dStr("thumbnail_url"));
                d->setViewCount(p->dInt("view_count"));
                d->setLikeCount(p->dInt("like_count"));
                d->setRepleCount(p->dInt("reple_count"));

                QString keywordStr = p->dStr("keyword");
                if(!keywordStr.isEmpty())
                {
                    keywordStr = "#" + keywordStr.remove(keywordStr.length()-1, 1).replace(",", " #");
                }
                d->setKeyword(keywordStr);
                p->end();

                QObject* o = qobject_cast<QObject*>(d);
                dlist.append(o);
            }

            if(form.pageNo.toInt() == 1) m->setSearchClipList(dlist);
            else
            {
                foreach(QObject* o, m->searchClipList())
                {
                    Univ* u = qobject_cast<Univ*>(o);
                    u->show(true);
                }
                m->appendSearchClipList(dlist);
            }
        }
        p->close();
        setGetSearchMainResult(ENums::POSITIVE);
        setSession(jsonObj);
    }
    else error();
    setRefreshWorkResult(ENums::FINISHED_MAIN);
    deleteLater();
    emit next();
}

void NetWorker::getClipLikeList(int nowPage)
{
    if(nowPage == 1) m->setTotalClipCount(0);
    else
    {
        if(!requestNextPage(m->totalClipCount(), m->likeClipList().length()))
        return;
    }
    form.pageNo = QString("%1").arg(nowPage);
#if defined(Q_OS_ANDROID)
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andGetClipLikeList(form.pageNo); });
    connect(NativeApp::getInstance(), SIGNAL(procGetClipLikeListResult(QByteArray)), this, SLOT(procGetClipLikeListResult(QByteArray)));
    return;
#endif

    QUrlQuery q;
    q.addQueryItem("now_page", form.pageNo);
    m_hosts.append(new NetHost("post", "getClipLikeList", q, [&]()->void { procGetClipLikeListResult(m_netReply->readAll()); }));
}

void NetWorker::procGetClipLikeListResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procGetClipLikeListResult(QByteArray)));
    if(!preventDoubleCall(&m_doubleCallPreventionVarGetClipLikeList)) return;
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    if (isOpen(jsonObj) && isSuccess(jsonObj))
    {
        ListParser* p = (new ListParser("getClipLikeList", ""))->setObj(jsonObj)->start();
        m->setTotalClipCount(jsonObj["total_unit_count"].toInt());

        QJsonArray jsonArr = jsonObj["data_list"].toArray();
        QList<QObject*> dlist;
        p = new ListParser("getClipLikeList", "data_list");
        foreach(const QJsonValue &value, jsonArr)
        {
            p->setObj(value.toObject())->start();
            Univ* d = new Univ();
            d->setLessonSubitemNo(p->dInt("lesson_subitem_no"));
            d->setTitle(p->dStr("title"));
            d->setImageUrl(p->dStr("image_url"));
            d->setThumbnailUrl(p->dStr("thumbnail_url"));
            d->setViewCount(p->dInt("view_count"));
            d->setLikeCount(p->dInt("like_count"));
            d->setLikeDate(p->dStr("like_date"));
            d->setCourseNo(p->dInt("course_no"));
            d->select(d->likeDate().isEmpty() ? false : true);

            QObject* o = qobject_cast<QObject*>(d);
            dlist.append(o);
        }
        p->close();

        if(form.pageNo.toInt() == 1) m->setLikeClipList(dlist);
        else
        {
            foreach(QObject* o, m->likeClipList())
            {
                Univ* u = qobject_cast<Univ*>(o);
                u->show(true);
            }
            m->appendLikeClipList(dlist);
        }
    }

    setRefreshWorkResult(ENums::FINISHED_MAIN);
    deleteLater();
    emit next();
}

void NetWorker::getRepleLikeList(int nowPage)
{
    form.pageNo = QString("%1").arg(nowPage);
#if defined(Q_OS_ANDROID)
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andGetRepleLikeList(form.pageNo); });
    connect(NativeApp::getInstance(), SIGNAL(procGetRepleLikeListResult(QByteArray)), this, SLOT(procGetRepleLikeListResult(QByteArray)));
    return;
#endif
    QUrlQuery q;
    q.addQueryItem("now_page", form.pageNo);
    m_hosts.append(new NetHost("post", "getRepleLikeList", q, [&]()->void { procGetRepleLikeListResult(m_netReply->readAll()); }));
}

void NetWorker::procGetRepleLikeListResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procGetRepleLikeListResult(QByteArray)));
    if(!preventDoubleCall(&m_doubleCallPreventionVarGetRepleLikeList)) return;
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    if (isOpen(jsonObj) && isSuccess(jsonObj))
    {
        ListParser* p = (new ListParser("getRepleLikeList", ""))->setObj(jsonObj)->start();
        m->setTotalRepleCount(jsonObj["total_reple_count"].toInt());

        QJsonArray jsonArr = jsonObj["data_list"].toArray();
        QList<QObject*> dlist;
        p = new ListParser("getRepleLikeList", "data_list");
        foreach(const QJsonValue &value, jsonArr)
        {
            p->setObj(value.toObject())->start();
            Univ* d = new Univ();

            d->setBoardNo(p->dInt("board_no"));
            d->setBoardArticleNo(p->dInt("board_article_no"));
            d->setLikeDate(p->dStr("like_date"));
            d->select(d->likeDate().isEmpty() ? false : true);
            d->setUserNo(p->dInt("user_no"));
            d->setNickname(p->dStr("nickname"));
            d->setLikeCount(p->dInt("like_count"));
            d->setViewCount(p->dInt("view_count"));
            d->setContents(p->dStr("contents"));
            d->setServiceTitle(p->dStr("service_title"));
            d->setCourseNo(p->dInt("course_no"));
            d->setLessonSubitemNo(p->dInt("lesson_subitem_no"));
            d->setTitle(p->dStr("clip_name"));

            QObject* o = qobject_cast<QObject*>(d);
            dlist.append(o);
        }
        p->close();
        if(form.pageNo.toInt() == 1) m->setLikeRepleList(dlist);
        else
        {
            foreach(QObject* o, m->likeRepleList())
            {
                Univ* u = qobject_cast<Univ*>(o);
                u->show(true);
            }
            m->appendLikeRepleList(dlist);
        }
    }
    setRefreshWorkResult(ENums::FINISHED_MAIN);

    deleteLater();
    emit next();
}

void NetWorker::getRankingMain()
{
#if defined(Q_OS_ANDROID)
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andGetRankingMain(); });
    connect(NativeApp::getInstance(), SIGNAL(procGetRankingMainResult(QByteArray)), this, SLOT(procGetRankingMainResult(QByteArray)));
    return;
#endif
    QUrlQuery q;
    FUNC func = [&]()->void { procGetRankingMainResult(m_netReply->readAll()); };
    m_hosts.append(new NetHost("post", "getRankingMain", q, func));
    m_delayedHosts.append(new NetHost("post", "getRankingMain", q, func));
}

void NetWorker::procGetRankingMainResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procGetRankingMainResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    if (isOpen(jsonObj) && isSuccess(jsonObj))
    {
        ListParser* p = (new ListParser("getRankingMain", ""))->setObj(jsonObj)->start();

        QList<QObject*> dlist;
        m->myRank()->setUserNo(p->dInt("user_no"));
        m->myRank()->setProfileImage(p->dStr("profile_image"));
        m->myRank()->setProfileThumbNailUrl(p->dStr("profile_thumbnail_url"));
        m->myRank()->setTotalPoint(p->dInt("total_score"));
        m->myRank()->setRankNo(p->dInt("rank_no"));
        m->myRank()->setNickname(p->dStr("nickname"));
        m->myRank()->setCourseScore(p->dInt("validate_course_score"));
        m->myRank()->setSocialScore(p->dInt("validate_social_score"));
        int totalPoint = p->dInt("validate_total_score");
        m->myRank()->setTotalScore(totalPoint);
        settings->setTotalHavePoint(totalPoint);
        m->myRank()->setEtcScore(p->dInt("validate_etc_score"));
        m->myRank()->setStartDate(p->dStr("start_date"));
        m->myRank()->setEndDate(p->dStr("end_date"));

        QJsonArray jsonArr = jsonObj["data_list"].toArray();
        p = new ListParser("getRankingMain", "data_list");
        foreach(const QJsonValue &value, jsonArr)
        {
            p->setObj(value.toObject())->start();
            Rank* r2 = new Rank();

            r2->setRankUserNo(p->dInt("rank_user_no"));
            r2->setRankNo(p->dInt("rank_no"));
            r2->setNickname(p->dStr("nickname"));
            r2->setProfileImage(p->dStr("profile_image"));
            r2->setProfileThumbNailUrl(p->dStr("profile_thumbnail_url"));
            r2->setCourseScore(p->dInt("course_score"));
            r2->setSocialScore(p->dInt("social_score"));
            r2->setEtcScore(p->dInt("etc_score"));
            r2->setTotalScore(p->dInt("total_score"));

            QObject* o = qobject_cast<QObject*>(r2);
            dlist.append(o);
        }
        p->close();
        m->setRankList(dlist);
        setSession(jsonObj);
    } else error();

    deleteLater();
    emit next();
}

void NetWorker::getSavingDetail(int nowPage)
{
    setRefreshWorkResult(ENums::WORKING_HISTORY);
#if defined(Q_OS_ANDROID)
    form.pageNo = QString("%1").arg(nowPage);
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andGetSavingDetail(form.pageNo); });
    connect(NativeApp::getInstance(), SIGNAL(procGetSavingDetailResult(QByteArray)), this, SLOT(procGetSavingDetailResult(QByteArray)));
    return;
#endif
    QUrlQuery q;
    q.addQueryItem("now_page", QString("%1").arg(nowPage));
    m_hosts.append(new NetHost("post", "getSavingDetail", q, [&]()->void { procGetSavingDetailResult(m_netReply->readAll()); }));
}

void NetWorker::procGetSavingDetailResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procGetSavingDetailResult(QByteArray)));
    if(!preventDoubleCall(&m_doubleCallPreventionVarGetSavingDetail)) return;
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    if (isOpen(jsonObj) && isSuccess(jsonObj))
    {
        ListParser* p = (new ListParser("getSavingDetail", ""))->setObj(jsonObj)->start();
        m->setMyTotalPointCount(p->dInt("total_count"));
        m->setMyTotalHavePoint(p->dInt("total_score"));
        m->setMyTotalSumPoint(p->dInt("total_sum_score"));

        QJsonArray jsonArr = jsonObj["data_list"].toArray();
        QList<QObject*> dlist;
        p = new ListParser("getSavingDetail", "data_list");
        foreach(const QJsonValue &value, jsonArr)
        {
            p->setObj(value.toObject())->start();
            Point* pt = new Point();

            pt->setType(p->dInt("save_type"));
            pt->setScore(p->dInt("save_score"));
            pt->setComment(p->dStr("save_comment"));
            pt->setDate(p->dStr("save_date"));


            QObject* o = qobject_cast<QObject*>(pt);
            dlist.append(o);

        }
        p->close();
        m->setPointSaveList(dlist);
    }
    setRefreshWorkResult(ENums::FINISHED_HISTORY);
    deleteLater();
    emit next();
}

void NetWorker::getSpendingDetail(int nowPage)
{
    setRefreshWorkResult(ENums::WORKING_HISTORY);
#if defined(Q_OS_ANDROID)
    form.pageNo = QString("%1").arg(nowPage);
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andGetSpendingDetail(form.pageNo); });
    connect(NativeApp::getInstance(), SIGNAL(procGetSpendingDetailResult(QByteArray)), this, SLOT(procGetSpendingDetailResult(QByteArray)));
    return;
#endif
    QUrlQuery q;
    q.addQueryItem("now_page", QString("%1").arg(nowPage));
    m_hosts.append(new NetHost("post", "getSpendingDetail", q, [&]()->void { procGetSpendingDetailResult(m_netReply->readAll()); }));
}

void NetWorker::procGetSpendingDetailResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procGetSpendingDetailResult(QByteArray)));
    if(!preventDoubleCall(&m_doubleCallPreventionVarGetSpendingDetail)) return;
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    if (isOpen(jsonObj) && isSuccess(jsonObj))
    {
        ListParser* p = (new ListParser("getSpendingDetail", ""))->setObj(jsonObj)->start();
        m->setMyTotalPointCount(p->dInt("total_count"));
        m->setMyTotalHavePoint(p->dInt("total_score"));
        m->setMyTotalSumPoint(p->dInt("total_sum_score"));

        QJsonArray jsonArr = jsonObj["data_list"].toArray();
        QList<QObject*> dlist;
        p = new ListParser("getSpendingDetail", "data_list");

        foreach(const QJsonValue &value, jsonArr)
        {
            p->setObj(value.toObject())->start();
            Point* pt = new Point();

            pt->setType(p->dInt("spend_type"));
            pt->setScore(p->dInt("spend_score"));
            pt->setComment(p->dStr("spend_comment"));
            pt->setDate(p->dStr("spend_date"));

            QObject* o = qobject_cast<QObject*>(pt);
            dlist.append(o);

        }

        p->close();
        m->setPointSpendList(dlist);
    }
    setRefreshWorkResult(ENums::FINISHED_HISTORY);
    deleteLater();
    emit next();
}

void NetWorker::getApplyEventList()
{
    setRefreshWorkResult(ENums::WORKING_EVENTLIST);

#if defined(Q_OS_ANDROID)
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andGetApplyEventList(); });
    connect(NativeApp::getInstance(), SIGNAL(procGetApplyEventListResult(QByteArray)), this, SLOT(procGetApplyEventListResult(QByteArray)));
    return;
#endif

    QUrlQuery q;
    FUNC func = [&]()->void { procGetApplyEventListResult(m_netReply->readAll()); };
    m_hosts.append(new NetHost("post", "getApplyEventList", q, func));
    m_delayedHosts.append(new NetHost("post", "getApplyEventList", q, func));
}

void NetWorker::procGetApplyEventListResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procGetApplyEventListResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    if (isOpen(jsonObj) && isSuccess(jsonObj))
    {
        ListParser* p = (new ListParser("getApplyEventList", ""))->setObj(jsonObj)->start();

        QJsonArray jsonArr = jsonObj["data_list"].toArray();
        QList<QObject*> dlist;
        p = new ListParser("getSpendingDetail", "data_list");

        foreach(const QJsonValue &value, jsonArr)
        {
            p->setObj(value.toObject())->start();
            Univ* u = new Univ();
            u->setPrizeNo(p->dInt("prize_no"));
            u->setTitle(p->dStr("title"));
            u->setPoint(p->dInt("cash"));
            u->setImageUrl(p->dStr("image_url"));
            u->setUpdateDate(p->dStr("start_date") + " ~ " + p->dStr("end_date"));
            u->setPrizeType(p->dInt("prize_tyep"));

            QObject* o = qobject_cast<QObject*>(u);
            dlist.append(o);
        }

        p->close();
        m->setNoticeList(dlist);
        setSession(jsonObj);
    }

    setRefreshWorkResult(ENums::FINISHED_EVENTLIST);
    deleteLater();
    emit next();
}

void NetWorker::getApplyEventDetail(int prizeNo)
{
    if (prizeNo < 1) return;

#if defined(Q_OS_ANDROID)
    form.prizeNo = QString("%1").arg(prizeNo);
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andGetApplyEventDetail(form.prizeNo); });
    connect(NativeApp::getInstance(), SIGNAL(procGetApplyEventDetailResult(QByteArray)), this, SLOT(procGetApplyEventDetailResult(QByteArray)));
    return;
#endif
    QUrlQuery q;
    q.addQueryItem("prize_no", QString("%1").arg(prizeNo));
    FUNC func = [&]()->void { procGetApplyEventDetailResult(m_netReply->readAll()); };
    m_hosts.append(new NetHost("post", "getApplyEventDetail", q, func));
    m_delayedHosts.append(new NetHost("post", "getApplyEventDetail", q, func));
}

void NetWorker::procGetApplyEventDetailResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procGetApplyEventDetailResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    if (isOpen(jsonObj) && isSuccess(jsonObj))
    {
        ListParser* p = (new ListParser("getApplyEventDetail", ""))->setObj(jsonObj)->start();
        settings->setTotalHavePoint(p->dInt("user_total_score"));
        m->noticeDetail()->setAttendanceCode(p->dInt("is_complete"));
        m->noticeDetail()->setWriteDate(p->dStr("complete_date"));
        m->noticeDetail()->setPrizeNo(p->dInt("prize_no"));
        m->noticeDetail()->setTitle(p->dStr("title"));
        m->noticeDetail()->setContents(p->dStr("contents"));
        m->noticeDetail()->setPoint(p->dInt("cash"));
        m->noticeDetail()->setImageUrl(p->dStr("image_url"));
        m->noticeDetail()->setUpdateDate(p->dStr("start_date") + " ~ " + p->dStr("end_date"));
        m->noticeDetail()->setAppliedText(p->dStr("apply_prize_text"));
        m->noticeDetail()->setAppliedImageUrl(p->dStr("apply_prize_image"));
        m->noticeDetail()->setPrizeType(p->dInt("prize_type"));

        p->end()->close();

        setSession(jsonObj);
    }
    else setGetApplyEventDetailResult(ENums::NAGATIVE);

    deleteLater();
    emit next();
}

int NetWorker::setApplyEvent(int prizeNo, QString appliedText, QString appliedImageUrl)
{
    if(!isValidUser()) return 0;
    if (prizeNo < 1) return 2;

    form.appliedText = toUnicode(appliedText);
#if defined(Q_OS_ANDROID)
    form.prizeNo = QString("%1").arg(prizeNo);
    form.appliedImageUrl = appliedImageUrl;
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andSetApplyEvent(form.prizeNo, form.appliedText, form.appliedImageUrl); });
    connect(NativeApp::getInstance(), SIGNAL(procSetApplyEventResult(QByteArray)), this, SLOT(procSetApplyEventResult(QByteArray)));
    return 1;
#endif
    QUrlQuery q;
    q.addQueryItem("prize_no", QString("%1").arg(prizeNo));
    q.addQueryItem("apply_prize_text", form.appliedText);
    q.addQueryItem("apply_prize_image", appliedImageUrl);
    m_hosts.append(new NetHost("post", "setApplyEvent", q, [&]()->void { procSetApplyEventResult(m_netReply->readAll()); }));
    return 1;
}

void NetWorker::procSetApplyEventResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procSetApplyEventResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    if (isOpen(jsonObj) && isSuccess(jsonObj)) setApplyEventResult(ENums::POSITIVE);
    else
    {
        setApplyEventResult(ENums::NAGATIVE);
        error();
    }

    deleteLater();
    emit next();
}

int NetWorker::getUserPoint()
{
    if(!isValidUser()) return 0;

#if defined(Q_OS_ANDROID)
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andGetUserPoint(); });
    connect(NativeApp::getInstance(), SIGNAL(procGetUserPointResult(QByteArray)), this, SLOT(procGetUserPointResult(QByteArray)));
    return 1;
#endif
    QUrlQuery q;
    m_hosts.append(new NetHost("post", "getUserPoint", q, [&]()->void { procGetUserPointResult(m_netReply->readAll()); }));
    return 1;
}

void NetWorker::procGetUserPointResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procGetUserPointResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    if (isOpen(jsonObj) && isSuccess(jsonObj))
    {
        ListParser* p = (new ListParser("getUserPoint", ""))->setObj(jsonObj)->start();
        settings->setTotalHavePoint(p->dInt("total_score"));
    }
    else error();

    deleteLater();
    emit next();
}

int NetWorker::getMyAlarmList(int nowPage)
{
    if(nowPage == 1) m->setTotalAlarmCount(0);
    else
    {
        if(!requestNextPage(m->totalAlarmCount(), m->alarmList().length()))
        return 3;
    }
    if(!isValidUser()) return 0;

#if defined(Q_OS_ANDROID)
    form.pageNo = QString("%1").arg(nowPage);
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andGetMyAlarmList(form.pageNo); });
    connect(NativeApp::getInstance(), SIGNAL(procGetMyAlarmListResult(QByteArray)), this, SLOT(procGetMyAlarmListResult(QByteArray)));
    return 1;
#endif
    QUrlQuery q;
    q.addQueryItem("now_page", QString("%1").arg(nowPage));
    m_hosts.append(new NetHost("post", "getMyAlarmList", q, [&]()->void { procGetMyAlarmListResult(m_netReply->readAll()); }));
    return 1;
}

void NetWorker::procGetMyAlarmListResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procGetMyAlarmListResult(QByteArray)));
    if(!preventDoubleCall(&m_doubleCallPreventionVarGetMyAlarmList)) return;
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    if (isOpen(jsonObj) && isSuccess(jsonObj))
    {
        ListParser* p = (new ListParser("getMyAlarmList", ""))->setObj(jsonObj)->start();
        m->setTotalAlarmCount(p->dInt("total_count"));

        QJsonArray jsonArr = jsonObj["data_list"].toArray();
        QList<QObject*> dlist;
        p = new ListParser("getMyAlarmList", "data_list");

        foreach(const QJsonValue &value, jsonArr)
        {
            p->setObj(value.toObject())->start();
            Alarm* a = new Alarm();
            a->setAlarmNo(p->dInt("alarm_no"));
            a->setPushType(p->dInt("push_type"));
            a->setEventType(p->dInt("event_type"));
            a->setScore(p->dInt("score"));
            a->setWriteDate(p->dStr("write_date"));
            a->setDescription(p->dStr("text_description"));
            a->setUserRead(p->dInt("user_read") > 0 ? true : false);

            QObject* o = qobject_cast<QObject*>(a);
            dlist.append(o);
        }

        p->close();
        if(form.pageNo.toInt() == 1) m->setAlarmList(dlist);
        else m->appendAlarmList(dlist);
    }
    deleteLater();
    emit next();
}

int NetWorker::deleteMyAlarm(int alarmNo)
{
    if(!isValidUser()) return 0;
    if(alarmNo < 1) return 2;

    if(m->deleteAlarm(alarmNo))
    {
#if defined(Q_OS_ANDROID)
        form.alarmNo = QString("%1").arg(alarmNo);
        m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andDeleteMyAlarm(form.alarmNo); });
        connect(NativeApp::getInstance(), SIGNAL(procDeleteMyAlarmResult(QByteArray)), this, SLOT(procDeleteMyAlarmResult(QByteArray)));
        return 1;
#endif

        QUrlQuery q;
        q.addQueryItem("alarm_no", QString("%1").arg(alarmNo));
        m_hosts.append(new NetHost("post", "deleteMyAlarm", q, [&]()->void { procDeleteMyAlarmResult(m_netReply->readAll()); }));
    }
    return 1;
}

void NetWorker::procDeleteMyAlarmResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procDeleteMyAlarmResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    if (isOpen(jsonObj) && isSuccess(jsonObj));
    else error();

    deleteLater();
    emit next();
}

void NetWorker::getSystemFAQList()
{
#if defined(Q_OS_ANDROID)
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andGetSystemFAQList(); });
    connect(NativeApp::getInstance(), SIGNAL(procGetSystemFAQListResult(QByteArray)), this, SLOT(procGetSystemFAQListResult(QByteArray)));
    return;
#endif
    QUrlQuery q;
    FUNC func = [&]()->void { procGetSystemFAQListResult(m_netReply->readAll()); };

    m_hosts.append(new NetHost("post", "getSystemFAQList", q, func));
    m_delayedHosts.append(new NetHost("post", "getSystemFAQList", q, func));
}

void NetWorker::procGetSystemFAQListResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procGetSystemFAQListResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    if (isOpen(jsonObj) && isSuccess(jsonObj))
    {
        ListParser* p = (new ListParser("getSystemFAQList", ""))->setObj(jsonObj)->start();
        QJsonArray jsonArr = jsonObj["data_list"].toArray();
        QList<QObject*> dlist;
        p = new ListParser("getSystemFAQList", "data_list");

        foreach(const QJsonValue &value, jsonArr)
        {
            p->setObj(value.toObject())->start();
            Univ* u = new Univ();
            u->setBoardNo(p->dInt("faq_no"));
            u->setTitle(p->dStr("title"));
            QObject* o = qobject_cast<QObject*>(u);
            dlist.append(o);
        }
        p->end()->close();
        m->setHelpList(dlist);

        setSession(jsonObj);
    }
    deleteLater();
    emit next();
}

void NetWorker::getSystemFAQDetail(int faqNo, int currentIndex)
{
    if (faqNo < 1) return;
    form.addr = "getSystemFAQDetail";
    form.currentIndex = currentIndex;

#if defined(Q_OS_ANDROID)
    form.faqNo = QString("%1").arg(faqNo);
    m_andNet.enqueue([&]()->void { NativeApp::getInstance()->andGetSystemFAQDetail(form.faqNo); });
    connect(NativeApp::getInstance(), SIGNAL(procGetSystemFAQDetailResult(QByteArray)), this, SLOT(procGetSystemFAQDetailResult(QByteArray)));
    return;
#endif

    QUrlQuery q;
    q.addQueryItem("faq_no", QString("%1").arg(faqNo));
    FUNC func = [&]()->void { procGetSystemFAQDetailResult(m_netReply->readAll()); };

    m_hosts.append(new NetHost("post", form.addr, q, func));
    m_delayedHosts.append(new NetHost("post", form.addr, q, func));
}

void NetWorker::procGetSystemFAQDetailResult(QByteArray result)
{
#if defined(Q_OS_ANDROID)
    disconnect(NativeApp::getInstance(), SIGNAL(procGetSystemFAQDetailResult(QByteArray)));
#endif

    QMutexLocker locker(&m_mtx);
    QJsonObject jsonObj = QJsonDocument::fromJson(result).object();

    if (isOpen(jsonObj) && isSuccess(jsonObj))
    {
        ListParser* p = (new ListParser(form.addr, ""))->setObj(jsonObj)->start();
        m->noticeDetail()->setTitle(p->dStr("title"));
        bool isImage = p->dInt("is_image") > 0 ? true : false;

        Univ* u = qobject_cast<Univ*>(m->helpList().at(form.currentIndex));
        u->setImageUrl(isImage ? p->dStr("image_url") : "");
        u->setContents(p->dStr("contents"));
        p->end()->close();

        setSession(jsonObj);
    }
    else error();

    deleteLater();
    emit next();
}

bool NetWorker::isValidUser()
{
    if(settings->noUser() < 1 || !settings->logined())
        return false;
    return true;
}

void NetWorker::deleteLater()
{
#if !defined(Q_OS_ANDROID)
    m_netReply->deleteLater();
#endif
}


bool NetWorker::requestNextPage(int totalCount, int currentCount)
{
    if(totalCount != currentCount) return true;
    return false;
}

#if defined(Q_OS_ANDROID)
bool NetWorker::preventDoubleCall(int *preventionVar)
{
    (*preventionVar)++;
    if((*preventionVar) > 2)
    {
        (*preventionVar) = 0;
        return false;
     }
    return true;
}
#endif

QString NetWorker::toUnicode(QString str)
{
    return NativeApp::getInstance()->toUnicode(str);
}
QString NetWorker::fromUnicode(QString str)
{
    return NativeApp::getInstance()->fromUnicode(str);
}


QString ListParser::toUnicode(QString str)
{
    return NativeApp::getInstance()->toUnicode(str);
}
QString ListParser::fromUnicode(QString str)
{
    return NativeApp::getInstance()->fromUnicode(str);
}
