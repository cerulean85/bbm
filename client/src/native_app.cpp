#include "native_app.h"
#include <QDebug>
#include <QDir>
#include <QDateTime>
#include "dbmanager.h"
#include "model.h"
#include <QTimer>
#include "networker.h"
NativeApp* NativeApp::m_instance = nullptr;
//NativeApp::NativeApp(QObject *parent) : QObject(parent)
//{

//}
//NativeApp::~NativeApp()
//{

//}

QString NativeApp::deviceId() {
    if (m_deviceId.length() == 0)
        m_deviceId = getDeviceId();
    return m_deviceId;
}

void NativeApp::resume()
{

}
void NativeApp::pause()
{

}

void NativeApp::setNativeChanner(int value)
{
    Model* m = Model::getInstance();
    m->setNativeChanner(m->nativeChanner() * value);
    qDebug() << "Called Android setNativeChanner() function.";
}

void NativeApp::setRequestNativeBackBehavior()
{
    Model* m = Model::getInstance();
    if(m->nativeChanner() == 11)
    {
        m->setRequestNativeBackBehavior(ENums::REQUESTED_BEHAVIOR_WEBVIEW);
    }
    else
    {
        m->setRequestNativeBackBehavior(ENums::REQUESTED_BEHAVIOR);
    }
}

void NativeApp::notifyLoginResult(bool isSuccess, const char* result)
{
    if(isSuccess)
        emit loginSuccess(result);
    else
        emit loginFailed(result);
}

void NativeApp::notifyLogoutResult(bool isSuccess)
{
    if(isSuccess)
        emit logoutSuccess();
    else
        emit logoutFailed();
}

void NativeApp::notifyWithdrawResult(bool isSuccess)
{
    if(isSuccess)
        emit withdrawSuccess();
    else
        emit withdrawFailed();
}

void NativeApp::notifyInviteResult(bool isSuccess)
{
    if(isSuccess)
        emit inviteSuccess();
    else
        emit inviteFailed();
}

void NativeApp::notifyTokenInfo(bool isSuccess, const char* result)
{
    if(isSuccess)
        emit tokenInfoSuccess(result);
    else
        emit tokenInfoFailed(result);
}

void NativeApp::notifyNotificated(int type, QString message, int no1, int no2, bool isRead)
{
    qDebug() << type << "/" << message << "/" << no1 << "/" << no2 << "/" <<isRead;
    emit notifyResult(type, message, no1, no2, isRead);
    //    int insertedId = DBManager::instance()->insertNotification(new Notification(type, message, no1, no2, isRead, QDateTime::currentDateTime().toString()));
}


void NativeApp::readNotice(int no)
{
    qDebug() << no;
    DBManager::instance()->readNotice(no);
}

QString NativeApp::getTempDirToStr(int dirType)
{
    if(dirType == DIR_IMAGE)
        return "img";
    if(dirType == DIR_VIDEO)
        return "vid";
    if(dirType == DIR_FILE)
        return "file";
    if(dirType == DIR_DATA)
        return "data";
    return "temp";
}

QString NativeApp::getTempDirectoryPath()
{
    return QDir::toNativeSeparators(QDir::tempPath() + "/ibeobom"/* + CommonInfo::APP_NAME*/);
}


QString NativeApp::getTempDirectoryPath(int dirType)
{
    QString dirPath = QDir::toNativeSeparators(getTempDirectoryPath() + "/" +
                                               getTempDirToStr(dirType));
    QDir tempDir(dirPath);
    if(!tempDir.exists())
        if(!tempDir.mkpath("."))
            return "";
    return dirPath;
}
void NativeApp::clearTempDirectoryPath(int dirType)
{
    QString dirPath = getTempDirectoryPath(dirType);
    if(dirPath.length() > 0){
        QDir dir( dirPath );
        if(dir.exists())
        {
            dir.setFilter( QDir::NoDotAndDotDot | QDir::Files );
            foreach( QString dirItem, dir.entryList() )
                dir.remove( dirItem );

            dir.setFilter( QDir::NoDotAndDotDot | QDir::Dirs );
            foreach( QString dirItem, dir.entryList() )
            {
                QDir subDir( dir.absoluteFilePath( dirItem ) );
                subDir.removeRecursively();
            }
        }
    }
}

QString NativeApp::getTempFilePathByName(int dirType, QString fileName)
{
    QString tempDirPath = getTempDirectoryPath(dirType);
    if(tempDirPath.length() > 0)
        return QDir::toNativeSeparators(tempDirPath + "/" + fileName);
    return "";
}

QString NativeApp::getTempFilePathByExtension(int dirType, QString fileExtension)
{
    QString fileName = QString::number(QDateTime::currentDateTime().toMSecsSinceEpoch()) + "." + fileExtension;
    return getTempFilePathByName(dirType, fileName);
}

QString NativeApp::getAppDatabaseDirectoryPath()
{
    return getTempDirectoryPath(NativeApp::DIR_DATA);
}
bool NativeApp::forcedPortrait()
{
    return Model::getInstance()->forcedPortrait();
}
void NativeApp::forcePortrait(bool m)
{
    Model::getInstance()->forcePortrait(m);
}
void NativeApp::setVideoStatus(int m)
{
    Model::getInstance()->setVideoStatus(m);
}
bool NativeApp::checkSignature(QString sig)
{
    QString s = "qE00Qd0Qms05vJlQrBwEBAtBmQCe5qL7wLDNq5I4tww=";
    s += "\n";
    return s.compare(sig);
}
void NativeApp::exitFromUI()
{
    Model::getInstance()->forceExit(true);
    //    qDebug() << "ASFASFA";
    //    QTimer* tm = new QTimer(this);
    //    tm->setInterval(1000);
    //    connect(tm, SIGNAL(timeout()), this, SLOT(exitApp()));
    //    tm->start();
}
void NativeApp::notifySecured()
{
    Model::getInstance()->secure(true);
}
void NativeApp::notifyAndLoginResult(QString result) { emit procLoginResult(result.toUtf8()); }
void NativeApp::notifyAndGetCourseDetailResult(QString result) { emit procGetCourseDetailResult(result.toUtf8()); }
void NativeApp::notifyAndCheckCertificationSMSResult(QString result)
{
    emit procCheckCertificationSMSResult(result.toUtf8());
}
void NativeApp::notifyAndJoinResult(QString result)
{
    emit procJoinResult(result.toUtf8());
}
void NativeApp::notifiyAndCertificateResult(QString result)
{
    emit procCertificateResult(result.toUtf8());
}
void NativeApp::notifyAndDuplicateIDResult(QString result)
{
    emit procDuplicateIDResult(result.toUtf8());
}
void NativeApp::notifyAndDuplicateNicknameResult(QString result)
{
    emit procDuplicateNicknameResult(result.toUtf8());
}
void NativeApp::notifyAndLogoutResult(QString result)
{
    emit procLogoutResult(result.toUtf8());
}
void NativeApp::notifyAndWithdrawResult(QString result)
{
    emit procWithdrawResult(result.toUtf8());
}
void NativeApp::notifyAndSetPushStatusResult(QString result)
{
    emit procSetPushStatusResult(result.toUtf8());
}
void NativeApp::notifyAndFindIDResult(QString result)
{
    emit procFindIDResult(result.toUtf8());
}
void NativeApp::notifyAndFindPasswordResult(QString result)
{
    emit procFindPasswordResult(result.toUtf8());
}
void NativeApp::notifyAndUpdatePasswordResult(QString result)
{
    emit procUpdatePasswordResult(result.toUtf8());
}
void NativeApp::notifyAndGetMyPageCourseResult(QString result)
{
    emit procGetMyPageCourseResult(result.toUtf8());
}
void NativeApp::notifyAndGetMyPageLogResult(QString result)
{
    emit procGetMyPageLogResult(result.toUtf8());
}
void NativeApp::notifyAndSetPushDateTimeResult(QString result)
{
    emit procSetPushDateTimeResult(result.toUtf8());
}
void NativeApp::notifyAndGetUserProfileResult(QString result)
{
    emit procGetUserProfileResult(result.toUtf8());
}
void NativeApp::notifyAndUpdateUserProfileResult(QString result)
{
    emit procUpdateUserProfileResult(result.toUtf8());
}
void NativeApp::notifyAndGetSystemNoticeListResult(QString result)
{
    emit procGetSystemNoticeListResult(result.toUtf8());
}
void NativeApp::notifyAndGetSystemNoticeDetailResult(QString result)
{
    emit procGetSystemNoticeDetailResult(result.toUtf8());
}
void NativeApp::notifyAndUploadImageFileResult(QString result)
{
    emit procUploadImageFileResult(result.toUtf8());
}
void NativeApp::notifyAndUploadFileResult(QString result)
{
    emit procUploadFileResult(result.toUtf8());
}
void NativeApp::notifyAndDeleteFileResult(QString result)
{
    emit procDeleteFileResult(result.toUtf8());
}
void NativeApp::notifyAndGetMainResult(QString result)
{
    emit procGetMainResult(result.toUtf8());
}
void NativeApp::notifyAndGetCourseBoardListResult(QString result)
{
    emit procGetCourseBoardListResult(result.toUtf8());
}
void NativeApp::notifyAndGetCourseBoardDetailResult(QString result)
{
    emit procGetCourseBoardDetailResult(result.toUtf8());
}
void NativeApp::notifyAndSetCourseBoardArticleResult(QString result)
{
    emit procSetCourseBoardArticleResult(result.toUtf8());
}
void NativeApp::notifyAndSetCourseBoardArticleRepleResult(QString result)
{
    emit procSetCourseBoardArticleRepleResult(result.toUtf8());
}
void NativeApp::notifyAndUpdateCourseBoardArticleResult(QString result)
{
    emit procUpdateCourseBoardArticleResult(result.toUtf8());
}
void NativeApp::notifyAndUpdateCourseBoardArticleRepleResult(QString result)
{
    emit procUpdateCourseBoardArticleRepleResult(result.toUtf8());
}

void NativeApp::notifyAndDeleteCourseBoardArticleResult(QString result)
{
    emit procDeleteCourseBoardArticleResult(result.toUtf8());
}
void NativeApp::notifyAndDeleteCourseBoardArticleRepleResult(QString result)
{
    emit procDeleteCourseBoardArticleRepleResult(result.toUtf8());
}
void NativeApp::notifyAndSetBoardReportResult(QString result)
{
    emit procSetBoardReportResult(result.toUtf8());
}
void NativeApp::notifyAndGetClipListResult(QString result)
{
    emit procGetClipListResult(result.toUtf8());
}
void NativeApp::notifyAndGetClipDetailResult(QString result)
{
    emit procGetClipDetailResult(result.toUtf8());
}
void NativeApp::notifyAndGetClipDetailForDeliveryResult(QString result)
{
    emit procGetClipDetailForDeliveryResult(result.toUtf8());
}
void NativeApp::notifyAndSetQuizResult(QString result)
{
    emit procSetQuizResult(result.toUtf8());
}
void NativeApp::notifyAndGetClipSharingResult(QString result)
{
    emit procGetClipSharingResult(result.toUtf8());
}
void NativeApp::notifyAndSetClipLikeResult(QString result)
{
    emit procSetClipLikeResult(result.toUtf8());
}
void NativeApp::notifyAndGetClipRepleListResult(QString result)
{
    emit procGetClipRepleListResult(result.toUtf8());
}
void NativeApp::notifyAndSetClipRepleResult(QString result)
{
    emit procSetClipRepleResult(result.toUtf8());
}
void NativeApp::notifyAndSetClipRepleReportResult(QString result)
{
    emit procSetClipRepleReportResult(result.toUtf8());
}
void NativeApp::notifyAndSetClipRepleLikeResult(QString result)
{
    emit procSetClipRepleLikeResult(result.toUtf8());
}
void NativeApp::notifyAndUpdateClipResult(QString result)
{
    emit procUpdateClipResult(result.toUtf8());
}
void NativeApp::notifyAndDeleteClipResult(QString result)
{
    emit procDeleteClipResult(result.toUtf8());
}
void NativeApp::notifyAndGetOtherUserProfileResult(QString result)
{
    emit procGetOtherUserProfileResult(result.toUtf8());
}
void NativeApp::notifyAndSetUserProfileReportResult(QString result)
{
    emit procSetUserProfileReportResult(result.toUtf8());
}
void NativeApp::notifyAndUpdateStudyTimeResult(QString result)
{
    emit procUpdateStudyTimeResult(result.toUtf8());
}
void NativeApp::notifyAndSetDeliveryServiceResult(QString result)
{
    emit procSetDeliveryServiceResult(result.toUtf8());
}
void NativeApp::notifyAndSetUnitCompleteResult(QString result)
{
    emit procSetUnitCompleteResult(result.toUtf8());
}
void NativeApp::notifyAndSetDeliveryServiceConfirmResult(QString result)
{
    emit procSetDeliveryServiceConfirmResult(result.toUtf8());
}
void NativeApp::notifyAndGetSearchMainResult(QString result)
{
    emit procGetSearchMainResult(result.toUtf8());
}
void NativeApp::notifyAndGetClipLikeListResult(QString result)
{
    emit procGetClipLikeListResult(result.toUtf8());
}
void NativeApp::notifyAndGetRepleLikeListResult(QString result)
{
    emit procGetRepleLikeListResult(result.toUtf8());
}
void NativeApp::notifyAndGetRankingMainResult(QString result)
{
    emit procGetRankingMainResult(result.toUtf8());
}
void NativeApp::notifyAndGetSavingDetailResult(QString result)
{
    emit procGetSavingDetailResult(result.toUtf8());
}
void NativeApp::notifyAndGetSpendingDetailResult(QString result)
{
    emit procGetSpendingDetailResult(result.toUtf8());
}
void NativeApp::notifyAndGetApplyEventListResult(QString result)
{
    emit procGetApplyEventListResult(result.toUtf8());
}
void NativeApp::notifyAndGetApplyEventDetailResult(QString result)
{
    emit procGetApplyEventDetailResult(result.toUtf8());
}
void NativeApp::notifyAndSetApplyEventResult(QString result)
{
    emit procSetApplyEventResult(result.toUtf8());
}
void NativeApp::notifyAndGetUserPointResult(QString result)
{
    emit procGetUserPointResult(result.toUtf8());
}
void NativeApp::notifyAndGetMyAlarmListResult(QString result)
{
    emit procGetMyAlarmListResult(result.toUtf8());
}
void NativeApp::notifyAndDeleteMyAlarmResult(QString result)
{
    emit procDeleteMyAlarmResult(result.toUtf8());
}
void NativeApp::notifyAndGetSystemFAQListResult(QString result)
{
    emit procGetSystemFAQListResult(result.toUtf8());
}
void NativeApp::notifyAndGetSystemFAQDetailResult(QString result)
{
    emit procGetSystemFAQDetailResult(result.toUtf8());
}
void NativeApp::notifyAndGetSystemInfoResult(QString result)
{
    emit procGetSystemInfoResult(result.toUtf8());
}
void NativeApp::notifyAndSetPushkeyResult(QString result)
{
    emit procSetPushkeyResult(result.toUtf8());
}
void NativeApp::notifyAndSetContactUSResult(QString result)
{
    emit procSetContactUSResult(result.toUtf8());
}

void NativeApp::requestShrinkVideo(bool m)
{
    Model::getInstance()->requestShrinkVideo(m);
}

QString NativeApp::toUnicode(QString contents)
{
    QString tmp = "";
    contents = contents.replace("&", "").replace("\n", "<br>");
    for(int i=0; i < contents.length(); i++)
    {
        QString origin = QString(contents.at(i));
        QString replaced = convertToUnicode(origin);
        if(replaced.length() == 1 || isKorean(replaced)) tmp += origin;
        else tmp += replaced;
    }
    return tmp;
}

QString NativeApp::fromUnicode(QString contents)
{
    contents = convertToUnicode(contents).replace("\\\\", "\\");
    QString decoded = convertFromUnicode(contents);
    return decoded;
}


bool NativeApp::isKorean(QString c)
{
    if(c.contains("\\u"))
    {
        bool ok = true;
        int oxy = c.replace("\\u", "0x").toInt(&ok, 16);

        QString value = "0x3131"; int leftOxy = value.toInt(&ok, 16);
        value = "0x3163"; int rightOxy = value.toInt(&ok, 16);
        if(leftOxy <= oxy && oxy <= rightOxy) return true;

        value = "0xAC00"; leftOxy = value.toInt(&ok, 16);
        value = "0xD7A3"; rightOxy = value.toInt(&ok, 16);
        if(leftOxy <= oxy && oxy <= rightOxy) return true;
    }
    return false;
}

#if defined(Q_OS_IOS)
QString NativeApp::getPushkey()
{
    Settings* settings = Settings::getInstance();
    return settings->nativePushkey();
}
void NativeApp::setStatusBarColor(QString colorString) { }
void NativeApp::toast(QString message) { }
void NativeApp::execTimer(bool state) { }
void NativeApp::checkStatusBar(bool check) { }
void NativeApp::bringNotifyResult() { }
void NativeApp::andLogin(QString id, QString pass, QString snsType) { }
void NativeApp::andCertificate(QString phone) { }
void NativeApp::andDuplicateID(QString id) { }
void NativeApp::andDuplicateNickname(QString nickname) { }
int NativeApp::andLogout() { return 0; }
int NativeApp::andWithdraw(QString comment) { return 0; }
void NativeApp::andSetPushStatus(QString pushStatus) { }
void NativeApp::andFindID(QString name, QString birth, QString phone) { }
void NativeApp::andFindPassword(QString id, QString email) { }
int NativeApp::andUpdatePassword(QString oldPass, QString newPass) { return 0; }
int NativeApp::andGetMyPageCourse() { return 0; }
int NativeApp::andGetMyPageLog(QString pageNo) { return 0; }
int NativeApp::andSetPushDateTime(QString time) { return 0; }
int NativeApp::andGetUserProfile() { return 0; }
int NativeApp::andUpdateUserProfile(QString profileImage, QString profileThumbUrl, QString name, QString birth, QString gender, QString email, QString isImageFileModify) { return 0; }
void NativeApp::andGetSystemNoticeList(QString noticeType, QString pageNo) { }
void NativeApp::andGetSystemNoticeDetail(QString boardArticleNo, QString boardNo) { }
void NativeApp::andUploadImageFile(QString filename, QString fileurl) { }
void NativeApp::andUploadFile(QString filename, QString boardArticleNo, QString boardNo, QString fileurl) { }
void NativeApp::andDeleteFile(QString fileNo) { }
void NativeApp::andGetMain(QString nowPage, QString categoryNo) { }
int NativeApp::andGetCourseDetail(QString courseNo){ return 0; }
int NativeApp::andGetCourseBoardList(QString nowPage, QString boardNo){ return 0; }
int NativeApp::andGetCourseBoardDetail(QString nowPage, QString boardNo, QString boardArticleNo){ return 0; }
int NativeApp::andSetCourseBoardArticle(QString boardNo, QString title, QString contents){ return 0; }
int NativeApp::andSetCourseBoardArticleReple(QString boardNo, QString boardArticleNo, QString contents){ return 0; }
int NativeApp::andUpdateCourseBoardArticle(QString boardNo, QString boardArticleNo, QString title, QString contents){ return 0; }
int NativeApp::andUpdateCourseBoardArticleReple(QString repleNo, QString contents){ return 0; }
int NativeApp::andDeleteCourseBoardArticle(QString boardNo, QString boardArticleNo){ return 0; }
int NativeApp::andDeleteCourseBoardArticleReple(QString repleNo){ return 0; }
int NativeApp::andSetBoardReport(QString boardNo, QString boardArticleNo, QString repleNo, QString reportType, QString reason){ return 0; }
int NativeApp::andGetClipList(QString courseNo){ return 0; }
int NativeApp::andGetClipDetail(QString lessonSubNo, QString courseNo){ return 0; }
int NativeApp::andGetClipDetailForDelivery(QString lessonSubNo, QString courseNo){ return 0; }
int NativeApp::andSetQuiz(QString quizNo, QString answerType, QString exampleNo, QString lessonSubitemNo, QString courseNo){ return 0; }
void NativeApp::andGetClipSharing(QString lessonSubitemNo){}
int NativeApp::andSetClipLike(QString courseNo, QString lessonSubitemNo, QString isLike){ return 0; }
void NativeApp::andGetClipRepleList(QString lessonSubitemNo, QString filterType, QString nowPage){}
int NativeApp::andSetClipReple(QString boardNo, QString contents, QString unitAttachFileName, QString unitAttachImageUrl, QString unitAttachThumbnailUrl){ return 0; }
int NativeApp::andSetClipRepleReport(QString boardArticleNo, QString boardNo, QString reason){ return 0; }
int NativeApp::andSetClipRepleLike(QString boardArticleNo, QString boardNo, QString isLike){ return 0; }
int NativeApp::andUpdateClip(QString boardArticleNo, QString boardNo, QString contents, QString modifyFile, QString unitAttachFileName, QString unitAttachImageUrl, QString unitAttachThumbnailUrl){ return 0; }
int NativeApp::andDeleteClip(QString boardArticleNo, QString boardNo){ return 0; }
void NativeApp::andGetOtherUserProfile(QString targetUserNo){  }
int NativeApp::andSetUserProfileReport(QString targetUserNo, QString reason){ return 0; }
int NativeApp::andUpdateStudyTime(QString lessonSubitemNo, QString studyTime){ return 0; }
int NativeApp::andSetDeliveryService(QString courseNo){ return 0; }
int NativeApp::andSetUnitComplete(QString lessonSubmitNo, QString courseNo){ return 0; }
int NativeApp::andSetDeliveryServiceConfirm(QString courseNo){ return 0; }
void NativeApp::andGetSearchMain(QString nowPage, QString searchKeyword, QString searchType){  }
void NativeApp::andGetClipLikeList(QString nowPage){  }
void NativeApp::andGetRepleLikeList(QString nowPage){  }
void NativeApp::andGetRankingMain(){  }
void NativeApp::andGetSavingDetail(QString nowPage){  }
void NativeApp::andGetSpendingDetail(QString nowPage){  }
void NativeApp::andGetApplyEventList(){  }
void NativeApp::andGetApplyEventDetail(QString prizeNo){  }
int NativeApp::andSetApplyEvent(QString prizeNo, QString appliedText, QString appliedImageUrl) { return 0; }
int NativeApp::andGetUserPoint(){ return 0; }
int NativeApp::andGetMyAlarmList(QString nowPage){ return 0; }
int NativeApp::andDeleteMyAlarm(QString alarmNo){ return 0; }
void NativeApp::andGetSystemFAQList(){  }
void NativeApp::andGetSystemFAQDetail(QString faqNo){  }
void NativeApp::andGetSystemInfo(){  }
void NativeApp::andSetPushkey(QString devceID, QString osType, QString deviceName, QString pushkey){  }
int NativeApp::andSetContactUS(QString email, QString contents, QString title, QString courseNo) { return 0; }
#endif

#if defined(Q_OS_ANDROID)
void NativeApp::removeBadge() { }
#endif

/* PC Version */
#if !defined(Q_OS_ANDROID) && !defined(Q_OS_IOS)
QString NativeApp::getDeviceId()
{
    return "123456789011123";
}
QString NativeApp::getDeviceName()
{
    return "xxx";
}

bool needUpdate()
{	
    return false;
}
QString NativeApp::getPhoneNumber()
{
    return "01056667777";
}
void NativeApp::joinKakao()
{
    qDebug() << "THIS EVENT WAS INVOKED AT PC VERSION. HAS NO EVENT.";
}
void NativeApp::loginKakao()
{
    qDebug() << "THIS EVENT WAS INVOKED AT PC VERSION. HAS NO EVENT.";
}
void NativeApp::logoutKakao()
{
    qDebug() << "THIS EVENT WAS INVOKED AT PC VERSION. HAS NO EVENT.";
}
void NativeApp::withdrawKakao()
{
    qDebug() << "THIS EVENT WAS INVOKED AT PC VERSION. HAS NO EVENT.";
}
void NativeApp::inviteKakao(QString senderId, QString image, QString title, QString desc, QString link)
{
    qDebug() << "THIS EVENT WAS INVOKED AT PC VERSION. HAS NO EVENT.";
}
void NativeApp::shareKakao(QString senderId, QString image, QString title, QString desc, QString link)
{
    qDebug() << "THIS EVENT WAS INVOKED AT PC VERSION. HAS NO EVENT.";
}
void NativeApp::loginFacebook()
{
    qDebug() << "THIS EVENT WAS INVOKED AT PC VERSION. HAS NO EVENT.";
}
void NativeApp::logoutFacebook()
{
    qDebug() << "THIS EVENT WAS INVOKED AT PC VERSION. HAS NO EVENT.";
}
void NativeApp::withdrawFacebook()
{
    qDebug() << "THIS EVENT WAS INVOKED AT PC VERSION. HAS NO EVENT.";
}
void NativeApp::inviteFacebook(QString senderId, QString image, QString title, QString desc, QString link)
{
    qDebug() << "THIS EVENT WAS INVOKED AT PC VERSION. HAS NO EVENT.";
}
void NativeApp::shareFacebook(QString senderId, QString image, QString title, QString desc, QString link)
{
    qDebug() << "THIS EVENT WAS INVOKED AT PC VERSION. HAS NO EVENT.";
}
bool NativeApp::isInstalledApp(QString nameOrScheme)
{
    qDebug() << "THIS EVENT WAS INVOKED AT PC VERSION. HAS NO EVENT.";
    return true;
}
int NativeApp::isOnline()
{
    qDebug() << "THIS EVENT WAS INVOKED AT PC VERSION. HAS NO EVENT.";
    return 0;
}
bool NativeApp::isRunning()
{
    qDebug() << "THIS EVENT WAS INVOKED AT PC VERSION. HAS NO EVENT.";
    return false;
}

bool NativeApp::needUpdate()
{
    qDebug() << "THIS EVENT WAS INVOKED AT PC VERSION. HAS NO EVENT.";
    return false;
}
float NativeApp::versionOS()
{
    qDebug() << "THIS EVENT WAS INVOKED AT PC VERSION. HAS NO EVENT.";
    return -999;
}
void NativeApp::exitApp()
{
    qDebug() << "THIS EVENT WAS INVOKED AT PC VERSION. HAS NO EVENT.";
}
QString NativeApp::appVersionName()
{
    qDebug() << "THIS EVENT WAS INVOKED AT PC VERSION. HAS NO EVENT.";
}
void NativeApp::openMarket()
{
    qDebug() << "THIS EVENT WAS INVOKED AT PC VERSION. HAS NO EVENT.";
}
void NativeApp::sendMail(QString destination, QString title, QString contents)
{
    qDebug() << "THIS EVENT WAS INVOKED AT PC VERSION. HAS NO EVENT.";
}
int NativeApp::getTimerSec()
{
    qDebug() << "THIS EVENT WAS INVOKED AT PC VERSION. HAS NO EVENT.";
    return 0;
}
int NativeApp::getStatusBarHeight()
{
    qDebug() << "THIS EVENT WAS INVOKED AT PC VERSION. HAS NO EVENT.";
    return 0;
}


QString NativeApp::convertToUnicode(QString contents)
{
    qDebug() << "THIS EVENT WAS INVOKED AT PC VERSION. HAS NO EVENT.";
    return "";
}
QString NativeApp::convertFromUnicode(QString contents)
{
    qDebug() << "THIS EVENT WAS INVOKED AT PC VERSION. HAS NO EVENT.";
    return "";
}

void NativeApp::showStatusBar(bool isShow)
{
    qDebug() << "THIS EVENT WAS INVOKED AT PC VERSION. HAS NO EVENT.";
}

void NativeApp::setOrientation(int type)
{
    qDebug() << "THIS EVENT WAS INVOKED AT PC VERSION. HAS NO EVENT.";
}
QString NativeApp::encrypted(QString str)
{
    qDebug() << "THIS EVENT WAS INVOKED AT PC VERSION. HAS NO EVENT.";
    return "";
}

QString NativeApp::decrypted(QString str)
{
    qDebug() << "THIS EVENT WAS INVOKED AT PC VERSION. HAS NO EVENT.";
    return "";
}

bool NativeApp::isSystemSecured()
{
    return false;
}
#endif

