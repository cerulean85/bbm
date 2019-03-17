#pragma once
#include <QObject>
#include <QDebug>
class NativeApp : public QObject
{
    Q_OBJECT

public:
    static NativeApp* getInstance()
    {
        if (m_instance == nullptr)
            m_instance = new NativeApp();
        return m_instance;
    }

    QString deviceId();

    void resume();
    void pause();
    void setNativeChanner(int channer);
    void setRequestNativeBackBehavior();
    Q_INVOKABLE void checkStatusBar(bool check);

    void joinKakao(); /* connect app */
    void loginKakao();
    void logoutKakao();
    Q_INVOKABLE void withdrawKakao();
    void inviteKakao(QString senderId, QString image, QString title, QString desc, QString link);
    void shareKakao(QString senderId, QString image, QString title, QString desc, QString link);

    void loginFacebook();
    void logoutFacebook();
    Q_INVOKABLE void withdrawFacebook();
    void inviteFacebook(QString senderId, QString image, QString title, QString desc, QString link);
    void shareFacebook(QString senderId, QString image, QString title, QString desc, QString link);

    void setStatusBarColor(QString colorString);

    Q_INVOKABLE QString getDeviceId();
    Q_INVOKABLE QString getDeviceName();
    Q_INVOKABLE QString getPhoneNumber();
    Q_INVOKABLE QString getPushkey();
    Q_INVOKABLE QString appVersionName();
    Q_INVOKABLE void openMarket();
    Q_INVOKABLE void sendMail(QString destination, QString title, QString contents);
    Q_INVOKABLE void removeBadge();

    bool isInstalledApp(QString nameOrScheme);
    int isOnline();
    Q_INVOKABLE bool isRunning();
    bool needUpdate();
    float versionOS();

    void toast(QString message);
    Q_INVOKABLE void execTimer(bool state);
    int getTimerSec();
    Q_INVOKABLE void bringNotifyResult();
    Q_INVOKABLE int getStatusBarHeight();
    Q_INVOKABLE void showStatusBar(bool isShow);

    void notifyLoginResult(bool isSuccess, const char* result);
    void notifyLogoutResult(bool isSuccess);
    void notifyWithdrawResult(bool isSuccess);
    void notifyInviteResult(bool isSuccess);
    void notifyTokenInfo(bool isSuccess, const char* result);
    void notifyNotificated(int type, QString message, int no1, int no2, bool isRead);
    void readNotice(int no);

    bool isKorean(QString c);
    QString toUnicode(QString contents);
    QString fromUnicode(QString contents);
    QString convertToUnicode(QString contents);
    QString convertFromUnicode(QString contents);

    enum TEMP_DIR
    {
        DIR_IMAGE = 1,
        DIR_VIDEO = 2,
        DIR_FILE = 3,
        DIR_DATA = 4,
        DIR_TEMP = 5
    };
    Q_ENUMS(TEMP_DIR)

    static QString getTempDirToStr(int dirType);
    static QString getTempDirectoryPath();
    Q_INVOKABLE static QString getTempDirectoryPath(int dirType);
    Q_INVOKABLE static void    clearTempDirectoryPath(int dirType);
    Q_INVOKABLE static QString getTempFilePathByName(int dirType, QString fileName);
    Q_INVOKABLE static QString getTempFilePathByExtension(int dirType, QString fileExtension);
    static QString getAppDatabaseDirectoryPath();

    Q_INVOKABLE void setOrientation(int type);

    bool forcedPortrait();
    void forcePortrait(bool m);
    void setVideoStatus(int m);

    Q_INVOKABLE QString encrypted(QString str);
    Q_INVOKABLE QString decrypted(QString str);

    bool checkSignature(QString sig);
    void exitFromUI();
    void notifySecured();
    Q_INVOKABLE bool isSystemSecured();

    void andCheckCertificationSMS(QString phone, QString nums);
    void notifyAndCheckCertificationSMSResult(QString result);

    void andJoin(QString id, QString pass, QString name,
                 QString nickname, QString birth, QString gender,
                 QString phone, QString osType, QString deviceID,
                 QString deviceName, QString snsType, QString pushKey,
                 QString email, QString snsAccessToken, QString snsRefreshToken,
                 QString agreeUse, QString agreeUserInfo, QString agreeThird, QString agreeEvent);
    void notifyAndJoinResult(QString result);

    void andLogin(QString id, QString pass, QString snsType);
    void notifyAndLoginResult(QString result);

    void andCertificate(QString phone);
    void notifiyAndCertificateResult(QString result);

    void andDuplicateID(QString id);
    void notifyAndDuplicateIDResult(QString result);

    void andDuplicateNickname(QString nickname);
    void notifyAndDuplicateNicknameResult(QString result);

    int andLogout();
    void notifyAndLogoutResult(QString result);

    int andWithdraw(QString comment);
    void notifyAndWithdrawResult(QString result);

    void andSetPushStatus(QString pushStatus);
    void notifyAndSetPushStatusResult(QString result);

    void andFindID(QString name, QString birth, QString phone);
    void notifyAndFindIDResult(QString result);

    void andFindPassword(QString id, QString email);
    void notifyAndFindPasswordResult(QString result);

    int andUpdatePassword(QString oldPass, QString newPass);
    void notifyAndUpdatePasswordResult(QString result);

    int andGetMyPageCourse();
    void notifyAndGetMyPageCourseResult(QString result);

    int andGetMyPageLog(QString pageNo);
    void notifyAndGetMyPageLogResult(QString result);

    int andSetPushDateTime(QString time);
    void notifyAndSetPushDateTimeResult(QString result);

    int andGetUserProfile();
    void notifyAndGetUserProfileResult(QString result);

    int andUpdateUserProfile(QString profileImage, QString profileThumbUrl, QString name,
                              QString birth, QString gender, QString email, QString isImageFileModify);
    void notifyAndUpdateUserProfileResult(QString result);

    void andGetSystemNoticeList(QString noticeType, QString pageNo);
    void notifyAndGetSystemNoticeListResult(QString result);

    void andGetSystemNoticeDetail(QString boardArticleNo, QString boardNo);
    void notifyAndGetSystemNoticeDetailResult(QString result);

    void andUploadImageFile(QString filename, QString fileurl);
    void notifyAndUploadImageFileResult(QString result);

    void andUploadFile(QString filename, QString boardArticleNo, QString boardNo, QString fileurl);
    void notifyAndUploadFileResult(QString result);

    void andDeleteFile(QString fileNo);
    void notifyAndDeleteFileResult(QString result);

    void andGetMain(QString nowPage, QString categoryNo);
    void notifyAndGetMainResult(QString result);

    int andGetCourseDetail(QString courseNo);
    void notifyAndGetCourseDetailResult(QString result);

    int andGetCourseBoardList(QString nowPage, QString boardNo);
    void notifyAndGetCourseBoardListResult(QString result);

    int andGetCourseBoardDetail(QString nowPage, QString boardNo, QString boardArticleNo);
    void notifyAndGetCourseBoardDetailResult(QString result);

    int andSetCourseBoardArticle(QString boardNo, QString title, QString contents);
    void notifyAndSetCourseBoardArticleResult(QString result);

    int andSetCourseBoardArticleReple(QString boardNo, QString boardArticleNo, QString contents);
    void notifyAndSetCourseBoardArticleRepleResult(QString result);

    int andUpdateCourseBoardArticle(QString boardNo, QString boardArticleNo, QString title, QString contents);
    void notifyAndUpdateCourseBoardArticleResult(QString result);

    int andUpdateCourseBoardArticleReple(QString repleNo, QString contents);
    void notifyAndUpdateCourseBoardArticleRepleResult(QString result);

    int andDeleteCourseBoardArticle(QString boardNo, QString boardArticleNo);
    void notifyAndDeleteCourseBoardArticleResult(QString result);

    int andDeleteCourseBoardArticleReple(QString repleNo);
    void notifyAndDeleteCourseBoardArticleRepleResult(QString result);

    int andSetBoardReport(QString boardNo, QString boardArticleNo, QString repleNo, QString reportType, QString reason);
    void notifyAndSetBoardReportResult(QString result);

    int andGetClipList(QString courseNo);
    void notifyAndGetClipListResult(QString result);

    int andGetClipDetail(QString lessonSubNo, QString courseNo);
    void notifyAndGetClipDetailResult(QString result);

    int andGetClipDetailForDelivery(QString lessonSubNo, QString courseNo);
    void notifyAndGetClipDetailForDeliveryResult(QString result);

    int andSetQuiz(QString quizNo, QString answerType, QString exampleNo, QString lessonSubitemNo, QString courseNo);
    void notifyAndSetQuizResult(QString result);

    void andGetClipSharing(QString lessonSubitemNo);
    void notifyAndGetClipSharingResult(QString result);

    int andSetClipLike(QString courseNo, QString lessonSubitemNo, QString isLike);
    void notifyAndSetClipLikeResult(QString result);

    void andGetClipRepleList(QString lessonSubitemNo, QString filterType, QString nowPage);
    void notifyAndGetClipRepleListResult(QString result);

    int andSetClipReple(QString boardNo, QString contents, QString unitAttachFileName, QString unitAttachImageUrl, QString unitAttachThumbnailUrl);
    void notifyAndSetClipRepleResult(QString result);

    int andSetClipRepleReport(QString boardArticleNo, QString boardNo, QString reason);
    void notifyAndSetClipRepleReportResult(QString result);

    int andSetClipRepleLike(QString boardArticleNo, QString boardNo, QString isLike);
    void notifyAndSetClipRepleLikeResult(QString result);

    int andUpdateClip(QString boardArticleNo, QString boardNo, QString contents,
                       QString modifyFile, QString unitAttachFileName, QString unitAttachImageUrl, QString unitAttachThumbnailUrl);
    void notifyAndUpdateClipResult(QString result);

    int andDeleteClip(QString boardArticleNo, QString boardNo);
    void notifyAndDeleteClipResult(QString result);


    void andGetOtherUserProfile(QString targetUserNo);
    void notifyAndGetOtherUserProfileResult(QString result);

    int andSetUserProfileReport(QString targetUserNo, QString reason);
    void notifyAndSetUserProfileReportResult(QString result);

    int andUpdateStudyTime(QString lessonSubitemNo, QString studyTime);
    void notifyAndUpdateStudyTimeResult(QString result);

    int andSetDeliveryService(QString courseNo);
    void notifyAndSetDeliveryServiceResult(QString result);

    int andSetUnitComplete(QString lessonSubmitNo, QString courseNo);
    void notifyAndSetUnitCompleteResult(QString result);

    int andSetDeliveryServiceConfirm(QString courseNo);
    void notifyAndSetDeliveryServiceConfirmResult(QString reesult);

    void andGetSearchMain(QString nowPage, QString searchKeyword, QString searchType);
    void notifyAndGetSearchMainResult(QString result);

    void andGetClipLikeList(QString nowPage);
    void notifyAndGetClipLikeListResult(QString result);

    void andGetRepleLikeList(QString nowPage);
    void notifyAndGetRepleLikeListResult(QString result);

    void andGetRankingMain();
    void notifyAndGetRankingMainResult(QString result);

    void andGetSavingDetail(QString nowPage);
    void notifyAndGetSavingDetailResult(QString result);

    void andGetSpendingDetail(QString nowPage);
    void notifyAndGetSpendingDetailResult(QString result);

    void andGetApplyEventList();
    void notifyAndGetApplyEventListResult(QString result);

    void andGetApplyEventDetail(QString prizeNo);
    void notifyAndGetApplyEventDetailResult(QString result);

    int andSetApplyEvent(QString prizeNo, QString appliedText, QString appliedImageUrl);
    void notifyAndSetApplyEventResult(QString result);

    int andGetUserPoint();
    void notifyAndGetUserPointResult(QString result);

    int andGetMyAlarmList(QString nowPage);
    void notifyAndGetMyAlarmListResult(QString result);

    int andDeleteMyAlarm(QString alarmNo);
    void notifyAndDeleteMyAlarmResult(QString result);

    void andGetSystemFAQList();
    void notifyAndGetSystemFAQListResult(QString result);

    void andGetSystemFAQDetail(QString faqNo);
    void notifyAndGetSystemFAQDetailResult(QString result);

    void andGetSystemInfo();
    void notifyAndGetSystemInfoResult(QString result);

    void andSetPushkey(QString devceID, QString osType, QString deviceName, QString pushkey);
    void notifyAndSetPushkeyResult(QString result);

    int andSetContactUS(QString email, QString contents, QString title, QString courseNo);
    void notifyAndSetContactUSResult(QString result);

    void requestShrinkVideo(bool m);

public slots:
    void exitApp();
signals:
    void resumed();
    void paused();
    void loginSuccess(const char* result);
    void loginFailed(const char* result);
    void logoutSuccess();
    void logoutFailed();
    void withdrawSuccess();
    void withdrawFailed();
    void inviteSuccess();
    void inviteFailed();
    void tokenInfoSuccess(const char* result);
    void tokenInfoFailed(const char* result);
    void notifyResult(int type, QString message, int no1, int no2, bool isRead);

    void procGetMainResult(QByteArray result);
    void procGetSystemInfoResult(QByteArray result);
    void procSetPushkeyResult(QByteArray result);
    void procLoginResult(QByteArray result);
    void procGetCourseDetailResult(QByteArray result);
    void procJoinResult(QByteArray result);
    void procCertificateResult(QByteArray result);
    void procCheckCertificationSMSResult(QByteArray result);
    void procDuplicateIDResult(QByteArray result);
    void procDuplicateNicknameResult(QByteArray result);
    void procLogoutResult(QByteArray result);
    void procWithdrawResult(QByteArray result);
    void procSetPushStatusResult(QByteArray result);
    void procFindIDResult(QByteArray result);
    void procFindPasswordResult(QByteArray result);
    void procUpdatePasswordResult(QByteArray result);
    void procGetMyPageCourseResult(QByteArray result);
    void procGetMyPageLogResult(QByteArray result);
    void procSetPushDateTimeResult(QByteArray result);
    void procGetUserProfileResult(QByteArray result);
    void procUpdateUserProfileResult(QByteArray result);
    void procGetSystemNoticeListResult(QByteArray result);
    void procGetSystemNoticeDetailResult(QByteArray result);
    void procUploadImageFileResult(QByteArray result);
    void procUploadFileResult(QByteArray result);
    void procDeleteFileResult(QByteArray result);
    void procGetCourseBoardListResult(QByteArray result);
    void procGetCourseBoardDetailResult(QByteArray result);
    void procSetCourseBoardArticleResult(QByteArray result);
    void procSetCourseBoardArticleRepleResult(QByteArray result);
    void procUpdateCourseBoardArticleResult(QByteArray result);
    void procUpdateCourseBoardArticleRepleResult(QByteArray result);
    void procDeleteCourseBoardArticleResult(QByteArray result);
    void procDeleteCourseBoardArticleRepleResult(QByteArray result);
    void procSetBoardReportResult(QByteArray result);
    void procGetClipListResult(QByteArray result);
    void procGetClipDetailResult(QByteArray result);
    void procGetClipDetailForDeliveryResult(QByteArray result);
    void procSetQuizResult(QByteArray result);
    void procGetClipSharingResult(QByteArray result);
    void procSetClipLikeResult(QByteArray result);
    void procGetClipRepleListResult(QByteArray result);
    void procSetClipRepleResult(QByteArray result);
    void procSetClipRepleReportResult(QByteArray result);
    void procSetClipRepleLikeResult(QByteArray result);
    void procUpdateClipResult(QByteArray result);
    void procDeleteClipResult(QByteArray result);
    void procGetOtherUserProfileResult(QByteArray result);
    void procSetUserProfileReportResult(QByteArray result);
    void procUpdateStudyTimeResult(QByteArray result);
    void procSetDeliveryServiceResult(QByteArray result);
    void procSetUnitCompleteResult(QByteArray result);
    void procSetDeliveryServiceConfirmResult(QByteArray reesult);
    void procGetSearchMainResult(QByteArray result);
    void procGetClipLikeListResult(QByteArray result);
    void procGetRepleLikeListResult(QByteArray result);
    void procGetRankingMainResult(QByteArray result);
    void procGetSavingDetailResult(QByteArray result);
    void procGetSpendingDetailResult(QByteArray result);
    void procGetApplyEventListResult(QByteArray result);
    void procGetApplyEventDetailResult(QByteArray result);
    void procSetApplyEventResult(QByteArray result);
    void procGetUserPointResult(QByteArray result);
    void procGetMyAlarmListResult(QByteArray result);
    void procDeleteMyAlarmResult(QByteArray result);
    void procGetSystemFAQListResult(QByteArray result);
    void procGetSystemFAQDetailResult(QByteArray result);
    void procSetContactUSResult(QByteArray result);

private:
    static NativeApp* m_instance;
    NativeApp()
    {

    }
    //    NativeApp(QObject *parent = NULL);
    //    ~NativeApp();

private:
    QString m_deviceId;
};

//extern NativeApp* app;
