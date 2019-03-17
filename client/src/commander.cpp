#include "commander.h"
#include "settings.h"
#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>
#include <QFileInfo>
#include <QPixmap>
#include "dbmanager.h"
#include "model.h"
#include <QRegularExpression>
#include "enums.h"
#include "networker.h"
#include "page_manager.h"
#include "model.h"
Commander* Commander::m_instance = nullptr;
Commander::Commander(QObject *parent) : QObject(parent)
{
    app = NativeApp::getInstance();
    connect(app, SIGNAL(loginSuccess(const char*)), this, SLOT(onLoginSuccess(const char*)));
    connect(app, SIGNAL(loginFailed(const char*)), this, SLOT(onLoginFailed(const char*)));
    connect(app, SIGNAL(logoutSuccess()), this, SLOT(onLogoutSuccess()));
    connect(app, SIGNAL(logoutFailed()), this, SLOT(onLogoutFailed()));
    connect(app, SIGNAL(withdrawSuccess()), this, SLOT(onWithdrawSuccess()));
    connect(app, SIGNAL(withdrawFailed()), this, SLOT(onWithdrawFailed()));
    connect(app, SIGNAL(inviteSuccess()), this, SLOT(onInviteSuccess()));
    connect(app, SIGNAL(inviteFailed()), this, SLOT(onInviteFailed()));
    connect(app, SIGNAL(notifyResult(int, QString, int, int, bool)), this, SLOT(processNotifyResult(int, QString, int, int, bool)));

    m_settings = Settings::getInstance();
    m_dbms = DBManager::instance();
}
Commander::~Commander()
{
    //delete m_model;
}
void Commander::exit()
{    
    app->exitApp();
    
}
void Commander::joinSNS()
{
    //qDebug() << "JOIN USING SNS";
}

void Commander::joinKakao()
{
    //qDebug() << "JOIN USING SNS";
    app->joinKakao();
}

void Commander::loginKakao()
{
    //qDebug() << "[KAKAO] LOGIN.";
    m_settings->setSnsType(ENums::KAKAO);
    app->loginKakao();
}

void Commander::logoutKakao()
{
    //qDebug() << "[KAKAO] LOGOUT.";
    app->logoutKakao();
}

void Commander::withdrawKakao()
{
    //qDebug() << "[KAKAO] WITHDRAW ACCOUNT.";
    app->withdrawKakao();
}

void Commander::inviteKakao()
{
    //qDebug() << "[KAKAO] INVITE FRIEND.";
    Model* m = Model::getInstance();

    QString nickname = m_settings->nickName();
    if(nickname.isEmpty()) nickname = "이름없음";

    QString title = "[" + nickname +"]님께서 이버봄으로 초대하였습니다.";
    QString desc = "링크를 눌러 앱을 다운받아 보세요.";
    qDebug() << m->clipHttpUrl();
    app->inviteKakao("", m->clipDetail()->thumbnailUrl(), title, desc, m_settings->inviteUrl());
}

void Commander::shareKakao()
{
    //qDebug() << "[KAKAO] SHARE FRIEND.";
    Model* m = Model::getInstance();
    QString title = "[" + m_settings->nickName() + "]님께서 [" + m->clipDetail()->title() +"]클립을 공유하였습니다.";
    QString desc = "링크를 눌러 확인해보세요.";
    //qDebug() << m->clipHttpUrl();

    //썸네일이미지, 타이틀, 설명, 클립주소
    app->shareKakao("", m->clipDetail()->thumbnailUrl(), title, desc, m->clipHttpUrl());
}

void Commander::loginFacebook()
{
    //qDebug() << "[FACEBOOK] LOGIN.";
    m_settings->setSnsType(ENums::FACEBOOK);
    app->loginFacebook();
}
void Commander::logoutFacebook()
{
    //qDebug() << "[FACEBOOK] LOGOUT.";
    app->logoutFacebook();
}
void Commander::withdrawFacebook()
{
    //qDebug() << "[FACEBOOK] WITHDRAW ACCOUNT.";
    app->withdrawFacebook();
}

void Commander::inviteFacebook()
{
    //qDebug() << "[FACEBOOK] INVITE FRIEND.";

    Model* m = Model::getInstance();
    QString desc = "[" + m_settings->nickName() + "]님께서 이버봄으로 초대하였습니다.\n링크를 눌러 앱을 다운받아 보세요.";
    app->inviteFacebook("", "", "", desc, m_settings->inviteUrl());
}

void Commander::shareFacebook()
{
    //qDebug() << "[FACEBOOK] INVITE FRIEND.";

    Model* m = Model::getInstance();
    QString desc = "[" + m_settings->nickName() + "]님께서 [" + m->clipDetail()->title() +"]클립을 공유하였습니다.\n링크를 눌러 확인해보세요.";
    app->shareFacebook("", "", "", desc, m->clipHttpUrl());
}

void Commander::setStatusBarColor(QString color)
{
    app->setStatusBarColor(color);
}

void Commander::onLoginSuccess(const char* result)
{
    //qDebug() << "[RESULT] LOGIN SUCCESS.";
    //qDebug() << result;

    QString qresult(result);
    QJsonDocument jsonDoc = QJsonDocument::fromJson(qresult.toLocal8Bit());
    QJsonObject jsonObj = jsonDoc.object();

    m_settings->setId(jsonObj["id"].toString());
    m_settings->setNickName(jsonObj["nickname"].toString());
    m_settings->setEmail(jsonObj["email"].toString());
    m_settings->setAccessToken(jsonObj["access_token"].toString());
    m_settings->setThumbnailImage(jsonObj["thumbnail_image"].toString());
    m_settings->setProfileImage(jsonObj["profile_image"].toString());

    Model::getInstance()->setShowIndicator(true);
    NetWorker* wk = NetWorker::getInstance();
    m_settings->setPassword("");
    wk->login();
    wk->request();
}

void Commander::onLoginFailed(const char* result)
{
    Model::getInstance()->setShowIndicator(false);
    //qDebug() << "[RESULT] LOGIN FAILED.";
    //qDebug() << result;


    QString rst = QString(result);
    if(!rst.compare("cancelled")) return;

    m_settings->clearUser();
    AlarmPopup* ap = AlarmPopup::getInstance();
    ap->setVisible(true);
    ap->setButtonCount(1);
    ap->setMessage("SNS에 로그인할 수 없습니다.");
    ap->setYButtonName("확인");
    ap->setYMethod(this, "empty");
}

void Commander::onLogoutSuccess()
{
    Model::getInstance()->setShowIndicator(false);
    //qDebug() << "[RESULT] LOGOUT SUCCESS.";
}

void Commander::onLogoutFailed()
{
    Model::getInstance()->setShowIndicator(false);
    //qDebug() << "[RESULT] LOGOUT FAILED.";
}

void Commander::onWithdrawSuccess()
{
    Model::getInstance()->setShowIndicator(false);
    //qDebug() << "[RESULT] WITHDRAW SUCCESS.";
}

void Commander::onWithdrawFailed()
{
    Model::getInstance()->setShowIndicator(false);
    //qDebug() << "[RESULT] WITHDRAW FAILED.";
}

void Commander::onInviteSuccess()
{
    Model::getInstance()->setShowIndicator(false);
    //qDebug() << "[RESULT] INVITE SUCCESS.";
}

void Commander::onInviteFailed()
{
    Model::getInstance()->setShowIndicator(false);
    //qDebug() << "[RESULT] INVITE FAILED.";
}

float Commander::versionOS() { return app->versionOS(); }
int Commander::isOnline() { return app->isOnline(); }
bool Commander::isInstalledApp(QString nameOrScheme)
{
    return app->isInstalledApp(nameOrScheme);
}

bool Commander::needUpdate()
{
    return app->needUpdate();
}

QString Commander::getDeviceId()
{
    return app->getDeviceId();
}

void Commander::openImagePicker()
{
    if(m_picker == nullptr)
    {
        m_picker = new ImagePicker();
        //qDebug() << "Create Image Picker";
    }

    //qDebug() << "Open Image Picker";
    m_picker->setImagePath("");
    connect(m_picker, SIGNAL(imagePathChanged(QString)), this, SLOT(onImagePickerResult(QString)));
    m_picker->openPicker();
}

void Commander::openImageCamera()
{
    if(m_picker == nullptr)
        m_picker = new ImagePicker();

    m_picker->setImagePath("");

    connect(m_picker, SIGNAL(imagePathChanged(QString)), this, SLOT(onImagePickerResult(QString)));
    m_picker->openCamera();
}
void Commander::clearImagePickerSlots()
{
    disconnect(SIGNAL(imagePickerResult(QString, QString)));
}

void Commander::onImagePickerResult(QString imagePath)
{
    disconnect(m_picker, SIGNAL(imagePathChanged(QString)), this, SLOT(onImagePickerResult(QString)));
    emit imagePickerResult(imagePath, m_picker->imageName());
}

QString Commander::resizeImage(QString path, int width, int height)
{
    //    //qDebug() << "INPUT FILE PATH : " + path;
    if(path.length() > 0)
        path.remove("file:///");

    QFileInfo srcFileInfo(path);

    if(srcFileInfo.isFile() && srcFileInfo.exists())
    {
        //        //qDebug() << "EXIST FILE : " << path;
        if(srcFileInfo.size() >= width * height)
        {
            QString dstImageFilePath = app->getTempFilePathByExtension(NativeApp::DIR_TEMP, srcFileInfo.suffix());

            int rate = srcFileInfo.size() / (width * height);
            QPixmap srcPixmap(path);
            QPixmap dstPixmap = srcPixmap.scaled(srcPixmap.width() / rate, srcPixmap.height() / rate, Qt::KeepAspectRatio, Qt::SmoothTransformation);
            QFile dstFile(dstImageFilePath);
            dstFile.open(QIODevice::WriteOnly);
            //            //qDebug() << "DESTIONATION FILE PATH : " + dstImageFilePath;
            if(dstPixmap.save(dstImageFilePath, srcFileInfo.suffix().toStdString().c_str(), 100))
            {
                path = dstImageFilePath;
            }
            dstFile.close();
        }
    }

    return "file:///" + path;
}
QString Commander::getProfileImage(QString path)
{
    return resizeImage(path, 1024, 1024);
}
QString Commander::getProfileThumbImage(QString path)
{
    return resizeImage(path, 300, 300);
}
void Commander::dbReadAll()
{
    m_dbms->readAll();
}

void Commander::readAdditionPushItems()
{
    m_dbms->readAddtionNotiItems();
}

void Commander::removePushItem(int no)
{
    m_dbms->removeNotice(no);
    Model::getInstance()->removeNotice(no, "push");

}

void Commander::readPushItem(int no, bool read)
{
    m_dbms->readNotice(no);
    Model::getInstance()->readNotice(no, read);
}

void Commander::processNotifyResult(int type, QString message, int no1, int no2, bool isRead)
{
    //    //qDebug() << "Commander::processNotifyResult " << type;
    Model* m = Model::getInstance();

    switch(type)
    {
    case 1:
    case 2: /* UI가 포그라운드에 있을 때만 동작*/
    {
        //        m->clearClipDetail();
        m->setCurrentCourseNo(no1);
        m->setCurrentClipNo(no2);
        break;
    }
    case 3: break;
    }
    m->deliver(type);

    PageManager* pm = PageManager::getInstance();
    if(!pm->compareCurrentPage("ClipViewer")) m->setShowIndicator(true);
}

int Commander::checkID(QString str)
{
    int minLength = 6;
    int maxLength = 12;
    if(minLength <= str.length() && str.length() <= maxLength)
    {
        QString checkExpression = "^[a-zA-Z][a-zA-Z0-9]{" + QString("%1").arg(minLength-1) +","+QString("%1").arg(maxLength-1)+"}";
        QRegularExpression re(checkExpression);
        QRegularExpressionMatch match = re.match(str);
        if(match.hasMatch())
        {
            QString exportedStr = match.captured(0);
            if(exportedStr.length() == str.length()) return ENums::ALL_RIGHT;
        }
        return ENums::WRONG_FORM;
    }

    return ENums::WRONG_LENGTH;
}
int Commander::checkPass(QString str)
{
    int minLength = 9;
    int maxLength = 16;

    if(minLength <= str.length() && str.length() <= maxLength)
    {
        QString checkExpression = "[a-z]";
        QRegularExpression re(checkExpression);
        QRegularExpressionMatch match = re.match(str);
        if(!match.hasMatch()) return ENums::NO_SMALL;
        
        checkExpression = "[A-Z]";
        QRegularExpression re1(checkExpression);
        QRegularExpressionMatch match1 = re1.match(str);
        if(!match1.hasMatch()) return ENums::NO_CAPITAL;

        checkExpression = "[0-9]";
        QRegularExpression re2(checkExpression);
        QRegularExpressionMatch match2 = re2.match(str);
        if(!match2.hasMatch()) return ENums::NO_NUMBER;

        checkExpression = "[^가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9]";
        QRegularExpression re3(checkExpression);
        QRegularExpressionMatch match3 = re3.match(str);
        if(!match3.hasMatch()) return ENums::NO_SPECIAL_CHAR;

        checkExpression = "[가-힣ㄱ-ㅎㅏ-ㅣ]";
        QRegularExpression re4(checkExpression);
        QRegularExpressionMatch match4 = re4.match(str);
        if(match4.hasMatch()) return ENums::NO_KOREAN;

        return ENums::ALL_RIGHT;
    }

    return ENums::WRONG_LENGTH;
}

int Commander::checkNickname(QString str)
{
    int minLength = 2;
    int maxLength = 30;

    //    //qDebug() << str;
    if(minLength <= str.length() && str.length() <= maxLength)
    {
        QString checkExpression = "[^가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9]";
        QRegularExpression re(checkExpression);
        QRegularExpressionMatch match = re.match(str);
        if(match.hasMatch()) return ENums::NO_SPECIAL_CHAR; /* 특수문자 포함 */

        checkExpression = "[ㄱ-ㅎㅏ-ㅣ]";
        QRegularExpression re2(checkExpression);
        QRegularExpressionMatch match2 = re2.match(str);
        if(match2.hasMatch()) return ENums::NO_KOREAN_INITIAL; /* 한글 초성 포함 */

        return ENums::ALL_RIGHT;
    }

    return ENums::WRONG_LENGTH;
}
int Commander::checkPhone(QString str)
{
    int minLength = 10;
    int maxLength = 11;
    if(minLength <= str.length() && str.length() <= maxLength)
    {
        QString checkExpression = "[0-9]{" + QString("%1").arg(minLength) +","+QString("%1").arg(maxLength)+"}";
        QRegularExpression re(checkExpression);
        QRegularExpressionMatch match = re.match(str);
        if(match.hasMatch())
        {
            QString exportedStr = match.captured(0);
            if(exportedStr.length() == str.length()) return ENums::ALL_RIGHT;
        }
        return ENums::WRONG_FORM;
    }

    return ENums::WRONG_LENGTH;
}
int Commander::checkEmail(QString str)
{
    int minLength = 10;
    int maxLength = 50;
    if(minLength <= str.length() && str.length() <= maxLength)
    {
        QString checkExpression = "^[a-zA-Z0-9]+([-_]?[a-zA-Z0-9])*@[a-zA-Z0-9]([-_.]?[a-zA-Z0-9])*.[a-zA-Z0-9]{2,3}$";
        QRegularExpression re(checkExpression);
        QRegularExpressionMatch match = re.match(str);
        if(match.hasMatch())
        {
            QString exportedStr = match.captured(0);
            if(exportedStr.length() == str.length()) return ENums::ALL_RIGHT;
        }
        return ENums::WRONG_FORM;
    }

    return ENums::WRONG_LENGTH;
}
int Commander::checkBirth(QString str)
{
    int minLength = 8;
    int maxLength = 8;
    if(minLength <= str.length() && str.length() <= maxLength)
    {
        QString checkExpression = "[0-9]{" + QString("%1").arg(minLength) +","+QString("%1").arg(maxLength)+"}";
        QRegularExpression re(checkExpression);
        QRegularExpressionMatch match = re.match(str);
        if(match.hasMatch())
        {
            QString exportedStr = match.captured(0);
            if(exportedStr.length() == str.length())
            {
                str.insert(4, "-");
                str.insert(7, "-");
                QDateTime tCnv = QDateTime::fromString(str, "yyyy-MM-dd");

                if(tCnv.isValid()) return ENums::ALL_RIGHT;
                else return ENums::WRONG_BIRTH;
            }
        }
        return ENums::WRONG_FORM;
    }

    return ENums::WRONG_LENGTH;
}

qint64 Commander::getLeftTime()
{
    Model* m = Model::getInstance();
    if(!m->runningTimeCounter())
    {
        //        //qDebug() << "Has no the running counter";
        m->setLeftTime("02:30");
        return 0;
    }

    qint64 leftSecTime = 150;
    //    #if defined(Q_OS_ANDROID)
    //    leftSecTime = leftSecTime - NativeApp::getInstance()->getTimerSec();
    //    #elif defined(Q_OS_IOS)
    leftSecTime = leftSecTime - (m->startedSecTime().secsTo(QDateTime::currentDateTime()));
    //    #endif


    if(leftSecTime < 0)
    {
        //qDebug() << "No Left Time. So, the counter would be stop. ";
        m->setRunningTimeCounter(false);
        m->setLeftTime("02:30");
        return leftSecTime;
    }

    qint64 hour = leftSecTime / 60;
    QString hourStr = QString("%1").arg(hour);
    if(hour < 10) hourStr = QString("0%1").arg(hour);

    qint64 minute = leftSecTime % 60;
    QString minuteStr = QString("%1").arg(minute);
    if(minute < 10) minuteStr = QString("0%1").arg(minute);

    QString leftTime = hourStr + ":" + minuteStr;
    //qDebug() << "leftTime : " << leftTime;
    m->setLeftTime(leftTime);
    
    return leftSecTime;
}

void Commander::toast(QString message)
{
    NativeApp::getInstance()->toast(message);
}

void Commander::execTimer(bool state)
{
    NativeApp::getInstance()->execTimer(state);
}

int Commander::getTimerSec()
{
    return NativeApp::getInstance()->getTimerSec();
}

void Commander::readSearchLogAll()
{
    Model::getInstance()->clearSearchLogList();
    m_dbms->readSearchLogAll();
}
void Commander::removeSearchLog(int row)
{
    m_dbms->removeSearchLog(row);
    m_dbms->readSearchLogAll();
}
void Commander::removeSearchLogAll()
{
    m_dbms->removeSearhLogAll();
    m_dbms->readSearchLogAll();
}
void Commander::updateSearchLog(QString keyword)
{
    m_dbms->updateSearchLog(keyword);
    m_dbms->readSearchLogAll();
}

void Commander::updateSearchLogDate(int row)
{
    m_dbms->updateSearchLogDate(row);
    m_dbms->readSearchLogAll();
}

void Commander::message(QString msg)
{
    //qDebug() << msg;
}

QString Commander::readText()
{
    QFile file("/text.txt");
    if(!file.open(QIODevice::WriteOnly))
    {
        return "null";
    }

    QTextStream in(&file);

    QString r = "";
    while(!in.atEnd()) {
        r += in.readLine();
    }
    file.close();
    return r;
}
