#pragma once

#include <QObject>
#include <QThread>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QMutex>
#include <QUrlQuery>
#include "settings.h"
#include "model.h"
#include "enums.h"
#include <QImage>
#include <QQueue>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonValue>


typedef std::function<void()> FUNC;
class NetHost : public QObject {
    Q_OBJECT
public:
    NetHost(QString type, QString addr, QUrlQuery queries, FUNC func, QString file="")
        : m_type(type), m_addr(addr), m_queries(queries), m_func(func), m_file(file) { }
    NetHost(QString type, QString addr, FUNC func)
        : m_type(type), m_addr(addr), m_func(func) { }
    NetHost(QString type, QString addr, FUNC func, bool dummy)
        : m_type(type), m_addr(addr), m_func(func), m_dummy(dummy) { }
    bool dummy() { bool tmp = m_dummy; m_dummy = false; return tmp; }
    QString type() const { return m_type; }
    QString addr() const { return m_addr; }
    QString file() const { return m_file; }
    int requestCount() const { return m_requestCount; }
    QUrlQuery queries() const { return m_queries; }
    FUNC func() const { return m_func; }

public slots :
    void setDummy(const bool &m) { m_dummy = m; }
    void setType(const QString &m) { m_type = m; }
    void setAddr(const QString &m) { m_addr = m; }
    void setQueries(const QUrlQuery &m) { m_queries = m; }
    void setFunc(const FUNC &m) { m_func = m;}
    void setFile(const QString &m) { m_file = m; }
    NetHost* increaseRequestCount() { m_requestCount = m_requestCount+1; return this; }

private:
    bool m_dummy = false;
    QString m_type;
    QString m_addr;
    QString m_file;
    int m_requestCount = 0;
    QUrlQuery m_queries;
    FUNC m_func;
};

class QJsonObject;
class NetWorker : public QObject
{
    Q_OBJECT

public:
    static NetWorker* getInstance()
    {
        if (m_instance == nullptr)
            m_instance = new NetWorker();
        return m_instance;
    }

    void clearBuf() { m_hosts.clear(); }

    struct Form {
        bool notifyResult;
//        int boardNo;
//        int boardArticleNo;
        int currentIndex;
        int clipNo;
//        int courseNo;
//        int pageNo;
//        int searchType;
//        int type;
//        int repleNo;
//        int filterType;
//        int faqNo;
        QString phone;
        QString id;
        QString pass;
        QString title;
        QString contents;
        QString addr;
        QString name;
        QString nickname;
        QString email;
        QString birth;
        QString categoryNo;
        QString pageNo;
        QString snsType;
        QString pushkey;
        QString deviceId;
        QString deviceName;
        QString accessToken;
        QString osType;
        QString gender;
        QString agreeUse;
        QString agreeUserInfo;
        QString agreeThird;
        QString agreeEvent;
        QString comment;
        QString pushStatus;
        QString oldPass;
        QString pushDateTime;
        QString profileImage;
        QString profileThumbUrl;
        QString isImageFileModify;
        QString noticeType;
        QString boardNo;
        QString boardArticleNo;
        QString nums;
        QString filename;
        QString courseNo;
        QString faqNo;
        QString alarmNo;
        QString prizeNo;
        QString searchType;
        QString lessonSubitemNo;
        QString studyTime;
        QString targetUserNo;
        QString isLike;
        QString unitAttachFileName;
        QString unitAttachImageUrl;
        QString unitAttachThumbnailUrl;
        QString filterType;
        QString quizNo;
        QString answerType;
        QString exampleNo;
        QString repleNo;
        QString reportType;
        QString fileNo;
        QString searchKeyword;
        QString fileUrl;
        QString appliedText;
        QString appliedImageUrl;
        QString reason;
        int distribution;
    } form;


    Q_PROPERTY(int certificatedResult READ certificatedResult NOTIFY certificatedResultChanged)
    Q_INVOKABLE int certificatedResult() { return m_certificatedResult; }
    Q_INVOKABLE int volCertificatedResult() { int tmp = m_certificatedResult; m_certificatedResult= ENums::WAIT; return tmp; }
    Q_INVOKABLE  void setCertificatedResult(int m) { m_certificatedResult = m; emit certificatedResultChanged(); }
    Q_INVOKABLE void checkCertificationSMS(QString phone, QString nums);
    Q_INVOKABLE void procCheckCertificationSMSResult(QByteArray result);

    Q_PROPERTY(int joinResult READ joinResult NOTIFY joinResultChanged)
    Q_INVOKABLE int joinResult() { return m_joinResult; }
    Q_INVOKABLE int vJoinResult() { int tmp = m_joinResult; m_joinResult= ENums::WAIT; return tmp; }
    Q_INVOKABLE void setJoinResult(int m) { m_joinResult = m; emit joinResultChanged(); }
    Q_INVOKABLE void join(QString id, QString pass, QString name, QString nickname, QString email, int sex, QString birth);
    Q_INVOKABLE void procJoinResult(QByteArray result);

    Q_PROPERTY(int loginResult READ loginResult NOTIFY loginResultChanged)
    Q_INVOKABLE int loginResult() { return m_loginResult; }
    Q_INVOKABLE int vLoginResult() { int tmp = m_loginResult; m_loginResult = ENums::WAIT; return tmp; }
    Q_INVOKABLE void setLoginResult(int m) { m_loginResult = m; emit loginResultChanged(); }
    Q_INVOKABLE void login();
    Q_INVOKABLE void procLoginResult(QByteArray result);

    Q_PROPERTY(int sentPhoneResult READ sentPhoneResult NOTIFY sentPhoneResultChanged)
    Q_INVOKABLE int sentPhoneResult() { return m_sentPhoneResult; }
    Q_INVOKABLE int vSentPhoneResult() { int tmp = m_sentPhoneResult; m_sentPhoneResult= ENums::WAIT; return tmp; }
    Q_INVOKABLE  void setSentPhoneResult(int m) { m_sentPhoneResult = m; emit sentPhoneResultChanged(); }
    Q_INVOKABLE void certificate(QString phone);
    Q_INVOKABLE void procCertificateResult(QByteArray result);

    Q_PROPERTY(int duplicatedIDResult READ duplicatedIDResult NOTIFY duplicatedIDResultChanged)
    Q_INVOKABLE int duplicatedIDResult() { return m_duplicatedIDResult; }
    Q_INVOKABLE int volDuplicatedIDResult() { int tmp = m_duplicatedIDResult; m_duplicatedIDResult = ENums::WAIT; return tmp; }
    Q_INVOKABLE void setDuplicatedIDResult(int m) { m_duplicatedIDResult = m; emit duplicatedIDResultChanged(); }
    Q_INVOKABLE void duplicateID(QString id);
    Q_INVOKABLE void procDuplicateIDResult(QByteArray result);

    Q_PROPERTY(int duplicatedNicknameResult READ duplicatedNicknameResult NOTIFY duplicatedNicknameResultChanged)
    Q_INVOKABLE int duplicatedNicknameResult() { return m_duplicatedNicknameResult; }
    Q_INVOKABLE int volDuplicatedNicknameResult() { int tmp = m_duplicatedNicknameResult; m_duplicatedNicknameResult = ENums::WAIT; return tmp; }
    Q_INVOKABLE void setDuplicatedNicknameResult(int m) { m_duplicatedNicknameResult = m; emit duplicatedNicknameResultChanged(); }
    Q_INVOKABLE void duplicateNickname(QString nick);
    Q_INVOKABLE void procDuplicateNicknameResult(QByteArray result);

    Q_PROPERTY(int logoutResult READ logoutResult NOTIFY logoutResultChanged)
    Q_INVOKABLE int logoutResult() { return m_logoutResult; }
    Q_INVOKABLE int volLogoutResult() { int tmp = m_logoutResult; m_logoutResult= ENums::WAIT; return tmp; }
    Q_INVOKABLE void setLogoutResult(int m) { m_logoutResult = m; emit logoutResultChanged(); }
    Q_INVOKABLE int logout();
    Q_INVOKABLE void procLogoutResult(QByteArray result);

    Q_PROPERTY(int withdrawResult READ withdrawResult NOTIFY withdrawResultChanged)
    Q_INVOKABLE int withdrawResult() { return m_withdrawResult; }
    Q_INVOKABLE int volWithdrawResult() { int tmp = m_withdrawResult; m_withdrawResult= ENums::WAIT; return tmp; }
    Q_INVOKABLE void setWithdrawResult(int m) { m_withdrawResult = m; emit withdrawResultChanged(); }
    Q_INVOKABLE int withdraw(QString comment="");
    Q_INVOKABLE void procWithdrawResult(QByteArray result);

    Q_PROPERTY(int setPushStatusResult READ setPushStatusResult NOTIFY setPushStatusResultChanged)
    Q_INVOKABLE int setPushStatusResult() { return m_setPushStatusResult; }
    Q_INVOKABLE int volSetPushStatusResult() { int tmp = m_setPushStatusResult; m_setPushStatusResult= ENums::WAIT; return tmp; }
    Q_INVOKABLE void setSetPushStatusResult(int m) { m_setPushStatusResult = m; emit setPushStatusResultChanged(); }
    Q_INVOKABLE int setPushStatus(int pushStatus);
    Q_INVOKABLE void procSetPushStatusResult(QByteArray result);

    Q_PROPERTY(int findIDResult READ findIDResult NOTIFY findIDResultChanged)
    Q_INVOKABLE int findIDResult() { return m_findIDResult; }
    Q_INVOKABLE int vFindIDResult() { int tmp = m_findIDResult; m_findIDResult= ENums::WAIT; return tmp; }
    Q_INVOKABLE void setFindIDResult(int m) { m_findIDResult = m; emit findIDResultChanged(); }
    Q_INVOKABLE void findID(QString name, QString birth, QString phone);
    Q_INVOKABLE void procFindIDResult(QByteArray result);

    Q_PROPERTY(int findPasswordResult READ findPasswordResult NOTIFY findPasswordResultChanged)
    Q_INVOKABLE int findPasswordResult() { return m_findPasswordResult; }
    Q_INVOKABLE int vFindPasswordResult() { int tmp = m_findPasswordResult; m_findPasswordResult= ENums::WAIT; return tmp; }
    Q_INVOKABLE void setFindPasswordResult(int m) { m_findPasswordResult = m; emit findPasswordResultChanged(); }
    Q_INVOKABLE void findPassword(QString id, QString email);
    Q_INVOKABLE void procFindPasswordResult(QByteArray result);

    Q_PROPERTY(int updatePasswordResult READ updatePasswordResult NOTIFY updatePasswordResultChanged)
    Q_INVOKABLE int updatePasswordResult() { return m_updatePasswordResult; }
    Q_INVOKABLE int vUpdatePasswordResult() { int tmp = m_updatePasswordResult; m_updatePasswordResult= ENums::WAIT; return tmp; }
    Q_INVOKABLE void setUpdatePasswordResult(int m) { m_updatePasswordResult = m; emit updatePasswordResultChanged(); }
    Q_INVOKABLE int updatePassword(QString oldPass, QString newPass);
    Q_INVOKABLE void procUpdatePasswordResult(QByteArray result);

    Q_INVOKABLE int getMyPageCourse();
    Q_INVOKABLE void procGetMyPageCourseResult(QByteArray result);

    Q_INVOKABLE int getMyPageLog(int pageNo=1);
    Q_INVOKABLE void procGetMyPageLogResult(QByteArray result);

    Q_PROPERTY(int  setPushDatetimeResult READ  setPushDatetimeResult NOTIFY  setPushDatetimeResultChanged)
    Q_INVOKABLE int  setPushDatetimeResult() { return m_setPushDatetimeResult; }
    Q_INVOKABLE int volSetPushDatetimeResult() { int tmp = m_setPushDatetimeResult; m_setPushDatetimeResult = ENums::WAIT; return tmp; }
    Q_INVOKABLE void setSetPushDatetimeResult(int m) { m_setPushDatetimeResult = m; emit setPushDatetimeResultChanged(); }
    Q_INVOKABLE int setPushDatetime(QString time);
    Q_INVOKABLE void procSetPushDatetimeResult(QByteArray result);

    Q_PROPERTY(int getUserProfileResult READ getUserProfileResult NOTIFY getUserProfileResultChanged)
    Q_INVOKABLE int getUserProfileResult() { return m_getUserProfileResult; }
    Q_INVOKABLE int volGetUserProfileResult() { int tmp = m_getUserProfileResult; m_getUserProfileResult = ENums::WAIT; return tmp; }
    Q_INVOKABLE void setGetUserProfileResult(int m) { m_getUserProfileResult = m; emit getUserProfileResultChanged(); }
    Q_INVOKABLE int getUserProfile();
    Q_INVOKABLE void procGetUserProfileResult(QByteArray result);

    Q_PROPERTY(int updateUserProfileResult READ updateUserProfileResult NOTIFY updateUserProfileResultChanged)
    Q_INVOKABLE int updateUserProfileResult() { return m_updateUserProfileResult; }
    Q_INVOKABLE int vUpdateUserProfileResult() { int tmp = m_updateUserProfileResult; m_updateUserProfileResult = ENums::WAIT; return tmp; }
    Q_INVOKABLE void setUpdateUserProfileResult(int m) { m_updateUserProfileResult = m; emit updateUserProfileResultChanged(); }
    Q_INVOKABLE int updateUserProfile(bool modifiedImag=false);
    Q_INVOKABLE void procUpdateUserProfileResult(QByteArray result);

    Q_INVOKABLE void getSystemNoticeList(int noticeType, int pageNo);
    Q_INVOKABLE void procGetSystemNoticeListResult(QByteArray result);

    Q_PROPERTY(int getSystemNoticeDetailResult READ getSystemNoticeDetailResult NOTIFY getSystemNoticeDetailResultChanged)
    Q_INVOKABLE int getSystemNoticeDetailResult() { return m_getSystemNoticeDetailResult; }
    Q_INVOKABLE int volGetSystemNoticeDetailResult() { int tmp = m_getSystemNoticeDetailResult; m_getSystemNoticeDetailResult = ENums::WAIT; return tmp; }
    Q_INVOKABLE void setGetSystemNoticeDetailResult(int m) { m_getSystemNoticeDetailResult = m; emit getSystemNoticeDetailResultChanged(); }
    Q_INVOKABLE void getSystemNoticeDetail(int boardArticleNo, int boardNo);
    Q_INVOKABLE void procGetSystemNoticeDetailResult(QByteArray result);

    Q_PROPERTY(int uploadResult READ uploadResult NOTIFY uploadResultChanged)
    Q_INVOKABLE int uploadResult() { return m_uploadResult; }
    Q_INVOKABLE int volUploadResult() { int tmp = m_uploadResult; m_uploadResult = ENums::WAIT; return tmp; }
    Q_INVOKABLE void setUploadResult(int m) { m_uploadResult = m; emit uploadResultChanged(); }
    Q_INVOKABLE void uploadImageFile(QString filename, int distribution=0);
    Q_INVOKABLE void uploadFile(QString filename, int boardNo, int boardArticleNo);
    Q_INVOKABLE void procUploadImageFileResult(QByteArray result);
    Q_INVOKABLE void procUploadFileResult(QByteArray result);

    Q_PROPERTY(int deleteFileResult READ deleteFileResult NOTIFY deleteFileResultChanged)
    Q_INVOKABLE int deleteFileResult() { return m_deleteFileResult; }
    Q_INVOKABLE int volDeleteFileResult() { int tmp = m_deleteFileResult; m_deleteFileResult = ENums::WAIT; return tmp; }
    Q_INVOKABLE void setDeleteFileResult(int m) { m_deleteFileResult = m; emit deleteFileResultChanged(); }
    Q_INVOKABLE void deleteFile(int fileNo);
    Q_INVOKABLE void procDeleteFileResult(QByteArray result);

    Q_PROPERTY(int refreshWorkResult READ refreshWorkResult NOTIFY refreshWorkResultChanged)
    Q_INVOKABLE int refreshWorkResult() { return m_refreshWorkResult; }
    Q_INVOKABLE int vRefreshWorkResult() { int tmp = m_refreshWorkResult; m_refreshWorkResult = ENums::REFRESH_WORK::NONE; return tmp; }
    Q_INVOKABLE void setRefreshWorkResult(int m) { m_refreshWorkResult = m; emit refreshWorkResultChanged(); }
    /* 3-1. */ Q_INVOKABLE void getMain(int nowPage, QString categoryNo);
    Q_INVOKABLE void procGetMainResult(QByteArray result);

    Q_PROPERTY(int getCourseDetailResult READ getCourseDetailResult NOTIFY getCourseDetailResultChanged)
    Q_INVOKABLE int getCourseDetailResult() { return m_getCourseDetailResult; }
    Q_INVOKABLE int vGetCourseDetailResult() { int tmp = m_getCourseDetailResult; m_getCourseDetailResult = ENums::REFRESH_WORK::NONE; return tmp; }
    Q_INVOKABLE void setGetCourseDetailResult(int m) { m_getCourseDetailResult = m; emit getCourseDetailResultChanged(); }
    /* 3-2. */Q_INVOKABLE int getCourseDetail(int courseNo);
    Q_INVOKABLE void procGetCourseDetailResult(QByteArray result);

    /* 3-3. */Q_INVOKABLE int getCourseBoardList(int nowPage, int boardNo);
    Q_INVOKABLE void procGetCourseBoardListResult(QByteArray result);

    Q_PROPERTY(int getCourseBoardDetailResult READ getCourseBoardDetailResult NOTIFY getCourseBoardDetailResultChanged)
    Q_INVOKABLE int getCourseBoardDetailResult() { return m_getCourseBoardDetailResult; }
    Q_INVOKABLE int volGetCourseBoardDetailResult() { int tmp = m_getCourseBoardDetailResult; m_getCourseBoardDetailResult= ENums::WAIT; return tmp; }
    Q_INVOKABLE void setGetCourseBoardDetailResult(int m) { m_getCourseBoardDetailResult = m; emit getCourseBoardDetailResultChanged(); }
    /* 3-4. */Q_INVOKABLE int getCourseBoardDetail(int nowPage, int boardNo, int boardArticleNo);
    Q_INVOKABLE void procGetCourseBoardDetailResult(QByteArray result);

    Q_PROPERTY(int createArticleResult READ createArticleResult NOTIFY createArticleResultChanged)
    Q_INVOKABLE int createArticleResult() { return m_createArticleResult; }
    Q_INVOKABLE int vCreateArticleResult() { int tmp = m_createArticleResult; m_createArticleResult = ENums::WAIT; return tmp; }
    Q_INVOKABLE void changeCreateArticleResult(int m) { m_createArticleResult = m; emit createArticleResultChanged(); }
    /* 3-5. */Q_INVOKABLE int setCourseBoardArticle(int boardNo, QString title, QString contents);
    Q_INVOKABLE void procSetCourseBoardArticleResult(QByteArray result);

    /* 3-6. */Q_INVOKABLE int updateCourseBoardArticle(int boardNo, int boardArticleNo, int index, QString title, QString contents);
    Q_INVOKABLE void procUpdateCourseBoardArticleResult(QByteArray result);

    Q_PROPERTY(int deleteCourseBoardArticleResult READ deleteCourseBoardArticleResult NOTIFY deleteCourseBoardArticleResultChanged)
    Q_INVOKABLE int deleteCourseBoardArticleResult() { return m_deleteCourseBoardArticleResult; }
    Q_INVOKABLE int vDeleteCourseBoardArticleResult() { int tmp = m_deleteCourseBoardArticleResult; m_deleteCourseBoardArticleResult = ENums::WAIT; return tmp; }
    Q_INVOKABLE void chagneDeleteCourseBoardArticleResult(int m) { m_deleteCourseBoardArticleResult = m; emit deleteCourseBoardArticleResultChanged(); }
    /* 3-7. */Q_INVOKABLE int deleteCourseBoardArticle(int boardNo, int boardArticleNo);
    Q_INVOKABLE void procDeleteCourseBoardArticleResult(QByteArray result);

    /* 3-8. */Q_INVOKABLE int setCourseBoardArticleReple(int boardNo, int boardArticleNo, QString contents);
    Q_INVOKABLE void procSetCourseBoardArticleRepleResult(QByteArray result);

    Q_PROPERTY(int updateCourseBoardArticleRepleResult READ updateCourseBoardArticleRepleResult NOTIFY updateCourseBoardArticleRepleResultChanged)
    Q_INVOKABLE int updateCourseBoardArticleRepleResult() { return m_updateCourseBoardArticleRepleResult; }
    Q_INVOKABLE void setUpdateCourseBoardArticleRepleResult(int m) { m_updateCourseBoardArticleRepleResult = m; emit updateCourseBoardArticleRepleResultChanged(); }
    /* 3-9. */Q_INVOKABLE int updateCourseBoardArticleReple(int repleNo, QString contents);
    Q_INVOKABLE void procUpdateCourseBoardArticleRepleResult(QByteArray result);

    /* 3-10. */Q_INVOKABLE int deleteCourseBoardArticleReple(int repleNo);
    Q_INVOKABLE void procDeleteCourseBoardArticleRepleResult(QByteArray result);

    Q_PROPERTY(int setBoardReportResult READ setBoardReportResult NOTIFY setBoardReportResultChanged)
    Q_INVOKABLE int setBoardReportResult() { return m_setBoardReportResult; }
    Q_INVOKABLE int volSetBoardReportResult() { int tmp = m_setBoardReportResult; m_setBoardReportResult = ENums::WAIT; return tmp; }
    Q_INVOKABLE void setSetBoardReportResult(int m) { m_setBoardReportResult = m; emit setBoardReportResultChanged(); }
    /* 3-11. */Q_INVOKABLE int setBoardReport(int boardNo, int boardArticleNo, int repleNo, int reportType, QString reason);
    Q_INVOKABLE void procSetBoardReportResult(QByteArray result);

    /* 3-12. */Q_INVOKABLE int getClipList(int courseNo);
    Q_INVOKABLE void procGetClipListResult(QByteArray result);


    Q_PROPERTY(int getClipDetailResult READ getClipDetailResult NOTIFY getClipDetailResultChanged)
    Q_INVOKABLE int getClipDetailResult() { return m_getClipDetailResult; }
    Q_INVOKABLE int vGetClipDetailResult() { int tmp = m_getClipDetailResult; m_getClipDetailResult = ENums::WAIT; return tmp; }
    Q_INVOKABLE void setGetClipDetailResult(int m) { m_getClipDetailResult = m; emit getClipDetailResultChanged(); }
    /* 3-13. */Q_INVOKABLE int getClipDetail(int lessonSubNo, int courseNo);
    Q_INVOKABLE void procGetClipDetailResult(QByteArray result);
    Q_INVOKABLE int getClipDetailForDelivery(int lessonSubNo, int courseNo);
    Q_INVOKABLE void procGetClipDetailForDeliveryResult(QByteArray result);

    /* 3-14 */Q_INVOKABLE int setQuiz(int quizNo, int answerType, int exampleNo, int lessonSubitemNo, int courseNo);
    Q_INVOKABLE void procSetQuizResult(QByteArray result);

    Q_PROPERTY(int getClipSharingResult READ getClipSharingResult NOTIFY getClipSharingResultChanged)
    Q_INVOKABLE int getClipSharingResult() { return m_getClipSharingResult; }
    Q_INVOKABLE int volGetClipSharingResult() { int tmp = m_getClipSharingResult; m_getClipSharingResult = ENums::WAIT; return tmp; }
    Q_INVOKABLE void setGetClipSharingResult(int m) { m_getClipSharingResult = m; emit getClipSharingResultChanged(); }
    /* 3-15 */Q_INVOKABLE void getClipSharing(int lessonSubitemNo);
    Q_INVOKABLE void procGetClipSharingResult(QByteArray result);


    Q_PROPERTY(int setClipLikeResult READ setClipLikeResult NOTIFY setClipLikeResultChanged)
    Q_INVOKABLE int setClipLikeResult() { return m_setClipLikeResult; }
    Q_INVOKABLE int vSetClipLikeResult() { int tmp = m_setClipLikeResult; m_setClipLikeResult = ENums::WAIT; return tmp; }
    Q_INVOKABLE void setSetClipLikeResult(int m) { m_setClipLikeResult = m; emit setClipLikeResultChanged(); }
    /* 3-16 */Q_INVOKABLE int setClipLike(int courseNo, int lessonSubitemNo, int isLike);
    Q_INVOKABLE void procSetClipLikeResult(QByteArray result);

    /* 3-17 */Q_INVOKABLE void getClipRepleList(int lessonSubitemNo, int filterType, int nowPage);
    Q_INVOKABLE void procGetClipRepleListResult(QByteArray result);

    Q_PROPERTY(int setClipRepleResult READ setClipRepleResult NOTIFY setClipRepleResultChanged)
    Q_INVOKABLE int setClipRepleResult() { return m_setClipRepleResult; }
    Q_INVOKABLE int volSetClipRepleResult() { int tmp = m_setClipRepleResult; m_setClipRepleResult = ENums::WAIT; return tmp; }
    Q_INVOKABLE void setSetClipRepleResult(int m) { m_setClipRepleResult = m; emit setClipRepleResultChanged(); }
    /* 3-18 */Q_INVOKABLE int setClipReple(int boardNo, QString contents, QString unitAttachFileName, QString unitAttachImageUrl, QString unitAttachThumbnailUrl);
    Q_INVOKABLE void procSetClipRepleResult(QByteArray result);

    /* 3-19 */Q_INVOKABLE int updateClip(int boardArticleNo, int boardNo, QString contents, int modifyFile, QString unitAttachFileName, QString unitAttachImageUrl, QString unitAttachThumbnailUrl);
    Q_INVOKABLE void procUpdateClipResult(QByteArray result);
    /* 3-20 */Q_INVOKABLE int deleteClip(int boardArticleNo, int boardNo);
    Q_INVOKABLE void procDeleteClipResult(QByteArray result);

    Q_PROPERTY(int setClipRepleReportResult READ setClipRepleReportResult NOTIFY setClipRepleReportResultChanged)
    Q_INVOKABLE int setClipRepleReportResult() { return m_setClipRepleReportResult; }
    Q_INVOKABLE int volSetClipRepleReportResult() { int tmp = m_setClipRepleReportResult; m_setClipRepleReportResult = ENums::WAIT; return tmp; }
    Q_INVOKABLE void setSetClipRepleReportResult(int m) { m_setClipRepleReportResult = m; emit setClipRepleReportResultChanged(); }
    /* 3-21 */Q_INVOKABLE int setClipRepleReport(int boardArticleNo, int boardNo, QString reason);
    Q_INVOKABLE void procSetClipRepleReportResult(QByteArray result);

    Q_PROPERTY(int setClipRepleLikeResult READ setClipRepleLikeResult NOTIFY setClipRepleLikeResultChanged)
    Q_INVOKABLE int setClipRepleLikeResult() { return m_setClipRepleLikeResult; }
    Q_INVOKABLE int volSetClipRepleLikeResult() { int tmp = m_setClipRepleLikeResult; m_setClipRepleLikeResult = ENums::WAIT; return tmp; }
    Q_INVOKABLE void setSetClipRepleLikeResult(int m) { m_setClipRepleLikeResult = m; emit setClipRepleLikeResultChanged(); }
    /* 3-22 */Q_INVOKABLE int setClipRepleLike(int boardArticleNo, int boardNo, int isLike);
    Q_INVOKABLE void procSetClipRepleLikeResult(QByteArray result);

    /* 3-23 */Q_INVOKABLE void getOtherUserProfile(int targetUserNo);
    Q_INVOKABLE void procGetOtherUserProfileResult(QByteArray result);

    Q_PROPERTY(int  setUserProfileReportResult READ  setUserProfileReportResult NOTIFY  setUserProfileReportResultChanged)
    Q_INVOKABLE int  setUserProfileReportResult() { return m_setUserProfileReportResult; }
    Q_INVOKABLE int volSetUserProfileReportResult() { int tmp = m_setUserProfileReportResult; m_setUserProfileReportResult = ENums::WAIT; return tmp; }
    Q_INVOKABLE void setSetUserProfileReportResult(int m) { m_setUserProfileReportResult = m; emit setUserProfileReportResultChanged(); }
    /* 3-24 */Q_INVOKABLE int setUserProfileReport(int targetUserNo, QString reason);
    Q_INVOKABLE void procSetUserProfileReportResult(QByteArray result);

    /* 3-25 */Q_INVOKABLE int updateStudyTime(int lessonSubitemNo, int studyTime);
    Q_INVOKABLE void procUpdateStudyTimeResult(QByteArray result);

    Q_PROPERTY(int setDeliveryServiceResult READ setDeliveryServiceResult NOTIFY setDeliveryServiceResultChanged)
    Q_INVOKABLE int setDeliveryServiceResult() { return m_setDeliveryServiceResult; }
    Q_INVOKABLE int volSetDeliveryServiceResult() { int tmp = m_setDeliveryServiceResult; m_setDeliveryServiceResult = ENums::WAIT; return tmp; }
    Q_INVOKABLE void setDeliveryServiceResult(int m) { m_setDeliveryServiceResult = m; emit setDeliveryServiceResultChanged(); }
    /* 3-26 */Q_INVOKABLE int setDeliveryService(int courseNo);
    Q_INVOKABLE void procSetDeliveryServiceResult(QByteArray result);

    Q_PROPERTY(int setUnitCompleteResult READ setUnitCompleteResult NOTIFY setUnitCompleteResultChanged)
    Q_INVOKABLE int setUnitCompleteResult() { return m_setUnitCompleteResult; }
    Q_INVOKABLE int vSetUnitCompleteResult() { int tmp = m_setUnitCompleteResult; m_setUnitCompleteResult = ENums::WAIT; return tmp; }
    Q_INVOKABLE void setSetUnitCompleteResult(int m) { m_setUnitCompleteResult = m; emit setUnitCompleteResultChanged(); }
    /* 3-27 */Q_INVOKABLE int setUnitComplete(int lessonSubitemNo, int courseNo);
    Q_INVOKABLE void procSetUnitCompleteResult(QByteArray result);

    Q_PROPERTY(int setDeliveryServiceConfirmResult READ setDeliveryServiceConfirmResult NOTIFY setDeliveryServiceConfirmResultChanged)
    Q_INVOKABLE int setDeliveryServiceConfirmResult() { return m_setDeliveryServiceConfirmResult; }
    Q_INVOKABLE int volSetDeliveryServiceConfirmResult() { int tmp = m_setDeliveryServiceConfirmResult; m_setDeliveryServiceConfirmResult = ENums::WAIT; return tmp; }
    Q_INVOKABLE void setDeliveryServiceConfirmResult(int m) { m_setDeliveryServiceConfirmResult = m; emit setDeliveryServiceConfirmResultChanged(); }
    /* 3-28 */Q_INVOKABLE int setDeliveryServiceConfirm(int courseNo);
    Q_INVOKABLE void procSetDeliveryServiceConfirmResult(QByteArray result);

    Q_PROPERTY(int getSearchMainResult READ getSearchMainResult NOTIFY getSearchMainResultChanged)
    Q_INVOKABLE int getSearchMainResult() { return m_getSearchMainResult; }
    Q_INVOKABLE int vGetSearchMainResult() { int tmp = m_getSearchMainResult; m_getSearchMainResult = ENums::WAIT; return tmp; }
    Q_INVOKABLE void setGetSearchMainResult(int m) { m_getSearchMainResult = m; emit getSearchMainResultChanged(); }
    /* 4-1 */ Q_INVOKABLE void getSearchMain(int nowPage, QString searchKeyword, int searchType);
    Q_INVOKABLE void procGetSearchMainResult(QByteArray result);
    /* 5-1 */ Q_INVOKABLE void getClipLikeList(int nowPage);
    Q_INVOKABLE void procGetClipLikeListResult(QByteArray result);
    /* 5-2 */ Q_INVOKABLE void getRepleLikeList(int nowPage);
    Q_INVOKABLE void procGetRepleLikeListResult(QByteArray result);
    /* 6-1 */ Q_INVOKABLE void getRankingMain();
    Q_INVOKABLE void procGetRankingMainResult(QByteArray result);
    /* 6-2 */ Q_INVOKABLE void getSavingDetail(int nowPage);
    Q_INVOKABLE void procGetSavingDetailResult(QByteArray result);
    /* 6-3 */ Q_INVOKABLE void getSpendingDetail(int nowPage);
    Q_INVOKABLE void procGetSpendingDetailResult(QByteArray result);
    /* 6-4 */ Q_INVOKABLE void getApplyEventList();
    Q_INVOKABLE void procGetApplyEventListResult(QByteArray result);

    Q_PROPERTY(int getApplyEventDetailResult READ getApplyEventDetailResult NOTIFY getApplyEventDetailResultChanged)
    Q_INVOKABLE int getApplyEventDetailResult() { return m_getApplyEventDetailResult; }
    Q_INVOKABLE int vGetApplyEventDetailResult() { int tmp = m_getApplyEventDetailResult; m_getApplyEventDetailResult = ENums::WAIT; return tmp; }
    Q_INVOKABLE void setGetApplyEventDetailResult(int m) { m_getApplyEventDetailResult = m; emit getApplyEventDetailResultChanged(); }
    /* 6-5 */ Q_INVOKABLE void getApplyEventDetail(int prizeNo);
    Q_INVOKABLE void procGetApplyEventDetailResult(QByteArray result);

    Q_PROPERTY(int setApplyEventResult READ setApplyEventResult NOTIFY setApplyEventResultChanged)
    Q_INVOKABLE int setApplyEventResult() { return m_setApplyEventResult; }
    Q_INVOKABLE int vSetApplyEventResult() { int tmp = m_setApplyEventResult; m_setApplyEventResult = ENums::WAIT; return tmp; }
    Q_INVOKABLE void setApplyEventResult(int m) { m_setApplyEventResult = m; emit setApplyEventResultChanged(); }
    /* 6-6 */ Q_INVOKABLE int setApplyEvent(int prizeNo, QString appliedText, QString appliedImageUrl);
    Q_INVOKABLE void procSetApplyEventResult(QByteArray result);
    /* 6-7 */ Q_INVOKABLE int getUserPoint();
    Q_INVOKABLE void procGetUserPointResult(QByteArray result);

    Q_INVOKABLE int getMyAlarmList(int nowPage);
    Q_INVOKABLE void procGetMyAlarmListResult(QByteArray result);
    Q_INVOKABLE int deleteMyAlarm(int alarmNo);
    Q_INVOKABLE void procDeleteMyAlarmResult(QByteArray result);

    Q_INVOKABLE void getSystemFAQList();
    Q_INVOKABLE void procGetSystemFAQListResult(QByteArray result);
    Q_INVOKABLE void getSystemFAQDetail(int faqNo, int currentIndex);
    Q_INVOKABLE void procGetSystemFAQDetailResult(QByteArray result);

    Q_INVOKABLE void error();
    Q_INVOKABLE void alarm(QString msg);

    Q_PROPERTY(int getSystemInfoResult READ getSystemInfoResult NOTIFY getSystemInfoResultChanged)
    Q_INVOKABLE int getSystemInfoResult() { return m_getSystemInfoResult; }
    Q_INVOKABLE int vGetSystemInfoResult() { int tmp = m_getSystemInfoResult; m_getSystemInfoResult = ENums::WAIT; return tmp; }
    Q_INVOKABLE void setGetSystemInfoResult(int m) { m_getSystemInfoResult = m; emit getSystemInfoResultChanged(); }
    Q_INVOKABLE void getSystemInfo();
    Q_INVOKABLE void procGetSystemInfoResult(QByteArray result);

    Q_INVOKABLE void setPushkey();
    Q_INVOKABLE void procSetPushkeyResult(QByteArray result);
    Q_INVOKABLE void empty() { }

    Q_PROPERTY(int setContactUSResult READ setContactUSResult NOTIFY setContactUSResultChanged)
    /* 6-7 */ Q_INVOKABLE void setContactUS(QString title, QString contents, int courseNo=0);
    Q_INVOKABLE void procSetContactUSResult(QByteArray result);
    Q_INVOKABLE int setContactUSResult() { return m_setContactUSResult; }
    Q_INVOKABLE void setSetContactUSResult(int m) { m_setContactUSResult = m; emit setContactUSResultChanged(); }
    Q_INVOKABLE int vSetContactUSResult() { int tmp = m_setContactUSResult; m_setContactUSResult = ENums::WAIT; return tmp; }

    Q_PROPERTY(int sessionState READ sessionState WRITE setSessionState NOTIFY sessionStateChanged)
    Q_INVOKABLE int sessionState() { return m_sessionState; }
    Q_INVOKABLE void setSessionState(int m) { m_sessionState = m; emit sessionStateChanged(); }

    QString domainName() const { return m_domainName; }
    QString domainNameDummy() const { return m_domainNameDummy; }

    QString toUnicode(QString str);
    QString fromUnicode(QString str);


    Q_INVOKABLE void clearDelayedHosts()
    {
        for(NetHost* n : m_delayedHosts)
        {
            m_hosts.append(new NetHost(n->type(), n->addr(), n->queries(), n->func(), n->file()));
        }
        m_delayedHosts.clear();
    }

public slots:
    void request();
    void httpError(QNetworkReply::NetworkError msg);
    void progress(qint64, qint64);
    void watch();

signals:
    void next();
    void update(bool result);
    void upload(bool result);
    void finished();

    void joinResultChanged();
    void loginResultChanged();
    void logoutResultChanged();
    void withdrawResultChanged();
    void pushStatusResultChanged();
    void findIDResultChanged();
    void findPasswordResultChanged();
    void updatePasswordResultChanged();
    void certificatedResultChanged();
    void duplicatedIDResultChanged();
    void duplicatedNicknameResultChanged();
    void setPushDatetimeResultChanged();
    void getUserProfileResultChanged();
    void updateUserProfileResultChanged();
    void uploadResultChanged();
    void getCourseDetailResultChanged();
    void setCourseBoardArticleResultChanged();
    void deleteCourseBoardArticleResultChanged();
    void updateCourseBoardArticleRepleResultChanged();
    void deleteCourseBoardArticleRepleResultChanged();
    void setBoardReportResultChanged();
    void setQuizResultChanged();
    void getClipSharingResultChanged();
    void setDeliveryServiceResultChanged();
    void setDeliveryServiceConfirmResultChanged();
    void setClipLikeResultChanged();
    void setClipRepleLikeResultChanged();
    void setClipRepleResultChanged();
    void setUserProfileReportResultChanged();
    void setClipRepleReportResultChanged();
    void getSystemNoticeDetailResultChanged();
    void setPushStatusResultChanged();
    void getCourseBoardDetailResultChanged();
    void deleteFileResultChanged();
    void createArticleResultChanged();
    void setUnitCompleteResultChanged();
    void getApplyEventDetailResultChanged();
    void setApplyEventResultChanged();
    void getSearchMainResultChanged();
    void refreshWorkResultChanged();
    void sessionStateChanged();
    void sentPhoneResultChanged();
    void getClipDetailResultChanged();
    void getSystemInfoResultChanged();
    void setContactUSResultChanged();

private:
    QNetworkRequest createRequest(QString suffixUrl, QUrlQuery queries, bool useDummy = false);
    bool isSuccess(QJsonObject obj);
    bool isOpen(QJsonObject obj);
    bool isLogined(QJsonObject obj);
    void setSession(QJsonObject obj);

    NetWorker(QObject *parent = NULL);
    ~NetWorker();
    static NetWorker* m_instance;
    QQueue<NetHost*> m_hosts;
    QQueue<NetHost*> m_delayedHosts;
    QQueue<FUNC> m_andNet;

    QNetworkReply* m_netReply;
    Settings* settings = nullptr;
    Model* m = nullptr;

    AlarmPopup* ap = nullptr;
    QNetworkAccessManager m_netManager;

    QString receivedMsg;

    QMutex m_mtx;
    QUrlQuery m_queries;

    #if defined(Q_OS_ANDROID)
    QString m_domainName = "http://mobile01.e-koreatech.ac.kr/";
    #endif

    #if defined(Q_OS_IOS)
    QString m_domainName = "https://mobile01.e-koreatech.ac.kr/";
    #endif

    bool definedAnd()
    {
        #if defined(Q_OS_ANDROID)
        return true;
        #endif
        return false;
    }

    QString m_domainNameDummy = "http://favorite.cafe24app.com/";
    QString m_checkPrevNet = "";

    #if defined(Q_OS_ANDROID)
    //The Variable to Prevent the double call of function
    int m_doubleCallPreventionVarGetMain=0;
    int m_doubleCallPreventionVarGetCourseBoardList=0;
    int m_doubleCallPreventionVarGetCourseBoardDetail=0;
    int m_doubleCallPreventionVarGetClipRepleList=0;
    int m_doubleCallPreventionVarGetSearchMain=0;
    int m_doubleCallPreventionVarGetClipLikeList=0;
    int m_doubleCallPreventionVarGetRepleLikeList=0;
    int m_doubleCallPreventionVarGetSavingDetail=0;
    int m_doubleCallPreventionVarGetSpendingDetail=0;
    int m_doubleCallPreventionVarGetMyAlarmList=0;
    int m_doubleCallPreventionVarGetMyPageLog=0;
    int m_doubleCallPreventionVarGetSystemNoticeList=0;
    int m_doubleCallPreventionVarUploadFile=0;
    bool preventDoubleCall(int *preventionVar);

    struct FileInfo {
        QString filename;
        QString boardArticleNo;
        QString boardNo;
        QString fileUrl;
    };

    QQueue<FileInfo> m_fileQueue;

    #endif

    int m_joinResult = ENums::NETWORK_RESULT::WAIT;
    int m_loginResult = ENums::NETWORK_RESULT::WAIT;
    int m_logoutResult = ENums::NETWORK_RESULT::WAIT;
    int m_withdrawResult = ENums::NETWORK_RESULT::WAIT;
    int m_findIDResult = ENums::NETWORK_RESULT::WAIT;
    int m_pushStatusResult = ENums::NETWORK_RESULT::WAIT;
    int m_findPasswordResult = ENums::NETWORK_RESULT::WAIT;
    int m_updatePasswordResult = ENums::NETWORK_RESULT::WAIT;
    int m_getUserProfileResult 	= ENums::NETWORK_RESULT::WAIT;
    int m_certificatedResult = ENums::NETWORK_RESULT::WAIT;
    int m_duplicatedNicknameResult= ENums::NETWORK_RESULT::WAIT;
    int m_duplicatedIDResult = ENums::NETWORK_RESULT::WAIT;
    int m_setQuizResult = ENums::NETWORK_RESULT::WAIT;
    int m_getClipSharingResult = ENums::NETWORK_RESULT::WAIT;
    int m_setDeliveryServiceResult = ENums::NETWORK_RESULT::WAIT;
    int m_setDeliveryServiceConfirmResult = ENums::NETWORK_RESULT::WAIT;
    int m_setClipLikeResult = ENums::NETWORK_RESULT::WAIT;
    int m_setClipRepleLikeResult = ENums::NETWORK_RESULT::WAIT;
    int m_setClipRepleResult = ENums::NETWORK_RESULT::WAIT;
    int m_setUserProfileReportResult = ENums::NETWORK_RESULT::WAIT;
    int m_setClipRepleReportResult = ENums::NETWORK_RESULT::WAIT;
    int m_getSystemNoticeDetailResult = ENums::NETWORK_RESULT::WAIT;
    int m_uploadResult = ENums::NETWORK_RESULT::WAIT;
    int m_updateUserProfileResult = ENums::NETWORK_RESULT::WAIT;
    int m_setPushStatusResult = ENums::NETWORK_RESULT::WAIT;
    int m_setPushDatetimeResult = ENums::NETWORK_RESULT::WAIT;
    int m_getCourseDetailResult = ENums::NETWORK_RESULT::WAIT;
    int m_getCourseBoardDetailResult = ENums::NETWORK_RESULT::WAIT;
    int m_setBoardReportResult = ENums::NETWORK_RESULT::WAIT;
    int m_updateCourseBoardArticleRepleResult = ENums::NETWORK_RESULT::WAIT;
    int m_deleteCourseBoardArticleResult = ENums::NETWORK_RESULT::WAIT;
    int m_deleteFileResult = ENums::NETWORK_RESULT::WAIT;
    int m_createArticleResult = ENums::NETWORK_RESULT::WAIT;
    int m_setUnitCompleteResult = ENums::NETWORK_RESULT::WAIT;
    int m_getApplyEventDetailResult = ENums::NETWORK_RESULT::WAIT;
    int m_setApplyEventResult = ENums::NETWORK_RESULT::WAIT;
    int m_getSearchMainResult = ENums::NETWORK_RESULT::WAIT;
    int m_sentPhoneResult = ENums::NETWORK_RESULT::WAIT;
    int m_getClipDetailResult = ENums::NETWORK_RESULT::WAIT;

    int m_refreshWorkResult = ENums::REFRESH_WORK::NONE;
    int m_sessionState = ENums::SESSION_STATE::SESSION_WAIT;
    int m_getSystemInfoResult = ENums::NETWORK_RESULT::WAIT;
    int m_setContactUSResult = ENums::NETWORK_RESULT::WAIT;

    bool isValidUser();
    int dInt(QJsonObject o, int order, QString tag)
    {
        int result = o[tag].toInt();
        //qDebug().noquote() << "## " << order << ". "  << tag << ": " << result;
        return result;
    }

    QString dStr(QJsonObject o, int order, QString tag)
    {
        QString result = o[tag].toString();
        result = fromUnicode(result);
        //qDebug().noquote() << "## " << order << ". "  << tag << ": " <<result;
        return result;
    }

    void message(QString msg, bool noQuote = false)
    {
//        if(!noQuote) qDebug() << msg;
//        else qDebug().noquote() << msg;
    }

    void message2(QString msg)
    {
//        qDebug().noquote() << msg;
    }

    QString numToStr(int num) { return QString("%1").arg(num); }

    QTimer* m_watcher;

    void removeDelayedHost(QString name)
    {
        int count = 0;
        while(count < m_delayedHosts.length())
        {
            if(!m_delayedHosts[count]->addr().compare(name))
            {
                m_delayedHosts.removeAt(count);
                continue;
            }
            count++;
        }
    }

    void deleteLater();
    bool requestNextPage(int totalCount, int currentCount);
};

class ListParser : public QObject
{
    Q_OBJECT
private:
    bool m_debugMode = true;
    QJsonObject m_obj;
    int m_cnt = 0;
    QString m_where;
    QString m_what;
public:
    ListParser(QString funcName, QString listVarName)
    {
        m_where = funcName; m_what = listVarName;

        QString msg = "__START TO PARSE FROM [" + m_where + ", " + m_what + "]. ";
        message(msg);
    }
    ListParser* setDebugMode(bool m) { m_debugMode = m; return this; }
    ListParser* setObj(QJsonObject o) { m_obj = o; return this;}
    ListParser* setLocation(QString m1, QString m2) { m_where = m1; m_what = m2; return this;}
    ListParser* start()
    {
        m_cnt++;
        QString msg = "## [" + numToStr(m_cnt) + "] DATA PARSE STARTED. ##";
        message(msg);
        return this;
    }

    int dInt(QString tag)
    {
        int result = m_obj[tag].toInt();
        QString msg = "## " + numToStr(m_cnt) + ". "  + tag + ": " + numToStr(result);
        if(m_debugMode) message(msg, true);
        //if(m_debugMode) qDebug().noquote() << "## " << m_cnt << ". "  << tag << ": " << result;
        return result;
    }

    QString dStr(QString tag)
    {
        QString result = m_obj[tag].toString();
        QString msg = "## " + numToStr(m_cnt) + ". "  + tag + ": " + result;
        if(m_debugMode) message(msg, true);
        return fromUnicode(result);
    }

    ListParser* end()
    {
        QString msg = "!! ENDED [" + numToStr(m_cnt) + "] DATA PARSE. !!\n";
        message(msg);
        return this;
    }
    void close()
    {
        QString msg = "__TOTAL COUNT : " + numToStr(m_cnt) + ", [ " + m_where + ", " + m_what + "]. END TO PARSE. \n";
        message(msg);
    }

    void message(QString msg, bool noQuote = false)
    {
//        if(!noQuote) qDebug() << msg;
//        else qDebug().noquote() << msg;
    }

    QString numToStr(int num) { return QString("%1").arg(num); }

    QString toUnicode(QString str);
    QString fromUnicode(QString str);
};

