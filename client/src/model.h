#pragma once
#include <QObject>
#include <QList>
#include <QDebug>
#include <QDateTime>
#include "enums.h"
#include <QMutex>

using namespace std;

class File : public QObject
{
    Q_OBJECT

public:

    Q_PROPERTY(int fileNo READ fileNo WRITE setFileNo NOTIFY fileNoChanged)
    Q_PROPERTY(QString fileUrl READ fileUrl WRITE setFileUrl NOTIFY fileUrlChanged)
    Q_PROPERTY(QString fileThumbNailUrl READ fileThumbNailUrl WRITE setFileThumbNailUrl NOTIFY fileThumbNailUrlChanged)
    Q_PROPERTY(QString fileName READ fileName WRITE setFileName NOTIFY fileNameChanged)

    Q_INVOKABLE int fileNo() const { return m_fileNo; }
    Q_INVOKABLE QString fileUrl() const { return m_fileUrl; }
    Q_INVOKABLE QString fileThumbNailUrl() const { return m_fileThumbNailUrl; }
    Q_INVOKABLE QString fileName() const { return m_fileName; }
signals:
    void fileUrlChanged();
    void fileThumbNailUrlChanged();
    void fileNameChanged();
    void fileNoChanged();

public slots:
    void setFileUrl(QString m) { m_fileUrl = m; emit fileUrlChanged(); }
    void setFileThumbNailUrl(QString m) { m_fileThumbNailUrl = m; emit fileThumbNailUrlChanged(); }
    void setFileName(QString m) { m_fileName = m; emit fileNameChanged(); }
    void setFileNo(int m) { m_fileNo = m; emit fileNoChanged(); }

private:
    QString m_fileUrl;
    QString m_fileThumbNailUrl;
    QString m_fileName;
    int m_fileNo = 0;
};

class User : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int roleCode READ roleCode WRITE setRoleCode NOTIFY roleCodeChanged)
    Q_PROPERTY(int pushStatus READ pushStatus WRITE setPushStatus NOTIFY pushStatusChanged)
    Q_PROPERTY(int totalScore READ totalScore WRITE setTotalScore NOTIFY totalScoreChanged)
    Q_PROPERTY(int snsType READ snsType WRITE setSnsType NOTIFY snsTypeChanged)
    Q_PROPERTY(int pushType READ pushType WRITE setPushType NOTIFY pushTypeChanged)
    Q_PROPERTY(int eventType READ eventType WRITE setEventType NOTIFY eventTypeChanged)
    Q_PROPERTY(int score READ score WRITE setScore NOTIFY scoreChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString nickName READ nickName WRITE setNickName NOTIFY nickNameChanged)
    Q_PROPERTY(QString phone READ phone WRITE setPhone NOTIFY phoneChanged)
    Q_PROPERTY(QString pushKey READ pushKey WRITE setPushKey NOTIFY pushKeyChanged)
    Q_PROPERTY(QString profileImage READ profileImage WRITE setProfileImage NOTIFY profileImageChanged)
    Q_PROPERTY(QString profileThumbNailUrl READ profileThumbNailUrl WRITE setProfileThumbNailUrl NOTIFY profileThumbNailUrlChanged)
    Q_PROPERTY(QString email READ email WRITE setEmail NOTIFY emailChanged)
    Q_PROPERTY(QString recentDate READ recentDate WRITE setRecentDate NOTIFY recentDateChanged)
    Q_PROPERTY(QString pushTime READ pushTime WRITE setPushTime NOTIFY pushTimeChanged)
    Q_PROPERTY(QString imageUrl READ imageUrl WRITE setImageUrl NOTIFY imageUrlChanged)
    Q_PROPERTY(QString textDescription READ textDescription WRITE setTextDescription NOTIFY textDescriptionChanged)

public:

    Q_INVOKABLE int roleCode() const { return m_roleCode; }
    Q_INVOKABLE int pushStatus() const { return m_pushStatus; }
    Q_INVOKABLE int totalScore() const { return m_totalScore; }
    Q_INVOKABLE int snsType() const { return m_snsType; }
    Q_INVOKABLE int pushType() const { return m_pushType; }
    Q_INVOKABLE int eventType() const { return m_eventType; }
    Q_INVOKABLE int score() const { return m_score; }
    Q_INVOKABLE QString name() const { return m_name; }
    Q_INVOKABLE QString nickName() const { return m_nickName; }
    Q_INVOKABLE QString phone() const { return m_phone; }
    Q_INVOKABLE QString pushKey() const { return m_pushKey; }
    Q_INVOKABLE QString profileImage() const { return m_profileImage; }
    Q_INVOKABLE QString profileThumbNailUrl() const { return m_profileThumbNailUrl; }
    Q_INVOKABLE QString email() const { return m_email; }
    Q_INVOKABLE QString recentDate() const { return m_recentDate; }
    Q_INVOKABLE QString pushTime() const { return m_pushTime; }
    Q_INVOKABLE QString imageUrl() const { return m_imageUrl; }
    Q_INVOKABLE QString textDescription() const { return m_textDescription; }

public slots:
    void setRoleCode(int m) { m_roleCode = m; emit roleCodeChanged(); }
    void setPushStatus(int m) { m_pushStatus = m; emit pushStatusChanged(); }
    void setTotalScore(int m) { m_totalScore = m; emit totalScoreChanged(); }
    void setSnsType(int m) { m_snsType = m; emit snsTypeChanged(); }
    void setPushType(int m) { m_pushType = m; emit pushTypeChanged(); }
    void setEventType(int m) { m_eventType = m; emit eventTypeChanged(); }
    void setScore(int m) { m_score = m; emit scoreChanged(); }
    void setImageUrl(QString m) { m_imageUrl = m; emit imageUrlChanged(); }
    void setPhone(QString m) { m_phone = m; emit phoneChanged(); }
    void setName(QString m) { m_name = m; emit nameChanged(); }
    void setNickName(QString m) { m_nickName = m; emit nickNameChanged(); }
    void setPushKey(QString m) { m_pushKey = m; emit pushKeyChanged(); }
    void setProfileImage(QString m) { m_profileImage = m; emit profileImageChanged(); }
    void setProfileThumbNailUrl(QString m) { m_profileThumbNailUrl = m; emit profileThumbNailUrlChanged(); }
    void setEmail(QString m) { m_email = m; emit emailChanged(); }
    void setRecentDate(QString m) { m_recentDate = m; emit recentDateChanged(); }
    void setPushTime(QString m) { m_pushTime = m; emit pushTimeChanged(); }
    void setTextDescription(QString m) { m_textDescription = m; emit textDescriptionChanged(); }

signals:
    void roleCodeChanged();
    void nameChanged();
    void nickNameChanged();
    void phoneChanged();
    void pushStatusChanged();
    void pushKeyChanged();
    void profileImageChanged();
    void profileThumbNailUrlChanged();
    void totalScoreChanged();
    void snsTypeChanged();
    void emailChanged();
    void recentDateChanged();
    void pushTimeChanged();
    void pushTypeChanged();
    void eventTypeChanged();
    void scoreChanged();
    void imageUrlChanged();
    void textDescriptionChanged();

private:

    int m_roleCode;
    int m_pushStatus;
    int m_totalScore;
    int m_snsType;
    int m_pushType;
    int m_eventType;
    int m_score;
    QString m_name;
    QString m_nickName;
    QString m_phone;
    QString m_pushKey;
    QString m_profileImage;
    QString m_profileThumbNailUrl;
    QString m_email;
    QString m_recentDate;
    QString m_pushTime;
    QString m_imageUrl;
    QString m_textDescription;
};

class Log : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool showed READ showed WRITE show NOTIFY showedChanged)
    Q_PROPERTY(int logNo READ logNo WRITE setLogNo NOTIFY logNoChanged)
    Q_PROPERTY(int logCode READ logCode WRITE setLogCode NOTIFY logCodeChanged)
    Q_PROPERTY(QString logText READ logText WRITE setLogText NOTIFY logTextChanged)
    Q_PROPERTY(QString logDate READ logDate WRITE setLogDate NOTIFY logDateChanged)
public:
    Q_INVOKABLE bool showed() { return m_showed; }
    Q_INVOKABLE int logNo() { return m_logNo; }
    Q_INVOKABLE int logCode() { return m_logCode; }
    Q_INVOKABLE QString logText() { return m_logText; }
    Q_INVOKABLE QString logDate() { return m_logDate; }
public slots :
    void show(bool m) { m_showed = m; emit showedChanged(); }
    void setLogNo(int m) { m_logNo = m; emit logNoChanged(); }
    void setLogCode(int m) { m_logCode = m; emit logCodeChanged(); }
    void setLogText(QString m) { m_logText = m; emit logTextChanged(); }
    void setLogDate(QString m) { m_logDate = m; emit logDateChanged(); }
signals:
    void logNoChanged();
    void logCodeChanged();
    void logTextChanged();
    void logDateChanged();
    void showedChanged();
private:
    bool m_showed;
    int m_logNo;
    int m_logCode;
    QString m_logText;
    QString m_logDate;
};

class Univ : public QObject {
    Q_OBJECT
    Q_PROPERTY(int boardArticleNo READ boardArticleNo WRITE setBoardArticleNo NOTIFY boardArticleNoChanged) //3-1.
    Q_PROPERTY(int boardNo READ boardNo WRITE setBoardNo NOTIFY boardNoChanged) //3-1
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged) //3-1 //3-13
    Q_PROPERTY(int userNo READ userNo WRITE setUserNo NOTIFY userNoChanged)
    Q_PROPERTY(QString nickname READ nickname WRITE setNickname NOTIFY nicknameChanged)
    Q_PROPERTY(int viewCount READ viewCount WRITE setViewCount NOTIFY viewCountChanged)
    Q_PROPERTY(int repleCount READ repleCount WRITE setRepleCount NOTIFY repleCountChanged)
    Q_PROPERTY(QString writeDate READ writeDate WRITE setWriteDate NOTIFY writeDateChanged)
    Q_PROPERTY(QString contents READ contents WRITE setContents NOTIFY contentsChanged)
    Q_PROPERTY(QString updateDate READ updateDate WRITE setUpdateDate NOTIFY updateDateChanged)
    Q_PROPERTY(int repleNo READ repleNo WRITE setRepleNo NOTIFY repleNoChanged)

    //3-4.에서 file에 대해서 List로 사용
    Q_PROPERTY(QList<QObject*> fileList READ fileList WRITE setFileList NOTIFY fileListChanged)
    Q_PROPERTY(QList<QObject*> imageList READ imageList WRITE setImageList NOTIFY imageListChanged)


    //3-12. 강의목록(클립 목록)보기
    Q_PROPERTY(int courseNo READ courseNo WRITE setCourseNo NOTIFY courseNoChanged) //3-1. //3-2.
    Q_PROPERTY(int lessonSubitemNo READ lessonSubitemNo WRITE setLessonSubitemNo NOTIFY lessonSubitemNoChanged)
    Q_PROPERTY(QString lessonTitle READ lessonTitle WRITE setLessonTitle NOTIFY lessonTitleChanged)
    Q_PROPERTY(int requiredLearningTimeInSeconds READ requiredLearningTimeInSeconds WRITE setRequiredLearningTimeInSeconds NOTIFY requiredLearningTimeInSecondsChanged)
    Q_PROPERTY(int displayOrder READ displayOrder WRITE setDisplayOrder NOTIFY displayOrderChanged)
    Q_PROPERTY(QString imageUrl READ imageUrl WRITE setImageUrl NOTIFY imageUrlChanged)
    Q_PROPERTY(QString thumbnailUrl READ thumbnailUrl WRITE setThumbnailUrl NOTIFY thumbnailUrlChanged)
    Q_PROPERTY(int likeCount READ likeCount WRITE setLikeCount NOTIFY likeCountChanged)

    //2-7. 마이페이지 탭 메인화면(나의수강강좌)
    Q_PROPERTY(int courseContentNo READ courseContentNo WRITE setCourseContentNo NOTIFY courseContentNoChanged) //3-1. //3-2.
    Q_PROPERTY(QString serviceTitle READ serviceTitle WRITE setServiceTitle NOTIFY serviceTitleChanged) //3-1. //3-2. //3-12.
    Q_PROPERTY(int studentProgress READ studentProgress WRITE setStudentProgress NOTIFY studentProgressChanged)

    //3-2. 과목 상세보기
    /* Added By JHKim, When 2018.06.20.  Moved from class Model */
    Q_PROPERTY(QString studyGoal READ studyGoal WRITE setStudyGoal NOTIFY studyGoalChanged)
    Q_PROPERTY(QString studyTarget READ studyTarget WRITE setStudyTarget NOTIFY studyTargetChanged)
    Q_PROPERTY(QString studyRef READ studyRef WRITE setStudyRef NOTIFY studyRefChanged)
    Q_PROPERTY(QString teacherInfo READ teacherInfo WRITE setTeacherInfo NOTIFY teacherInfoChanged)
    Q_PROPERTY(QString studyComplete READ studyComplete WRITE setStudyComplete NOTIFY studyCompleteChanged)
    Q_PROPERTY(QString studyNcs READ studyNcs WRITE setStudyNcs NOTIFY studyNcsChanged)
    Q_PROPERTY(QString shortDescription READ shortDescription WRITE setShortDescription NOTIFY shortDescriptionChanged)
    Q_PROPERTY(QString courseIntroduce READ courseIntroduce WRITE setCourseIntroduce NOTIFY courseIntroduceChanged)
    Q_PROPERTY(QString courseInfoImageUrl READ courseInfoImageUrl WRITE setCourseInfoImageUrl NOTIFY courseInfoImageUrlChanged)
    Q_PROPERTY(QString courseImageUrl READ courseImageUrl WRITE setCourseImageUrl NOTIFY courseImageUrlChanged) //3-1. courseImageUrl (과목배경이미지 활용) 변수와 다름
    Q_PROPERTY(QString courseImageThumnailUrl READ courseImageThumnailUrl WRITE setCourseImageThumnailUrl NOTIFY courseImageThumnailUrlChanged) //3-1. courseImageThumnailUrl (과목썸네일배경이미지 활용) 변수와 다름

    //4-1. 검색 탭 메인화면
    Q_PROPERTY(QString keyword READ keyword WRITE setKeyword NOTIFY keywordChanged)

    //5-1. 좋아요 탭 메인화면-클립
    Q_PROPERTY(QString likeDate READ likeDate WRITE setLikeDate NOTIFY likeDateChanged)

    Q_PROPERTY(QString linkUrl READ linkUrl WRITE setLinkUrl NOTIFY linkUrlChanged) /* Added By JHKim, When 2018.06.17.*/
    Q_PROPERTY(int like READ like WRITE setLike NOTIFY likeChanged) /* Added By JHKim, When 2018.06.17.*/
    Q_PROPERTY(int top READ top WRITE setTop NOTIFY topChanged) /* Added By JHKim, When 2018.06.17.*/

    Q_PROPERTY(int deliveryFlag READ deliveryFlag WRITE setDeliveryFlag NOTIFY deliveryFlagChanged) /* Added By JHKim, When 2018.06.20.*/
    Q_PROPERTY(int attendanceCode READ attendanceCode WRITE setAttendanceCode NOTIFY attendanceCodeChanged) /* Added By JHKim, When 2018.06.20.*/
    Q_PROPERTY(int good READ good WRITE setGood NOTIFY goodChanged) /* Added By JHKim, When 2018.06.20.*/
    Q_PROPERTY(int reportCount READ reportCount WRITE setReportCount NOTIFY reportCountChanged) /* Added By JHKim, When 2018.06.20.*/

    Q_PROPERTY(bool   clicked   READ clicked      WRITE click       NOTIFY clickedChanged)
    Q_PROPERTY(bool   selected   READ selected      WRITE select       NOTIFY selectedChanged)

    Q_PROPERTY(QString profileImage READ profileImage WRITE setProfileImage NOTIFY profileImageChanged) //2-7. 2-10.
    Q_PROPERTY(QString profileThumbNailUrl READ profileThumbNailUrl WRITE setProfileThumbNailUrl NOTIFY profileThumbNailUrlChanged) //2-7. 2-10.

    Q_PROPERTY(int prizeNo READ prizeNo WRITE setPrizeNo NOTIFY prizeNoChanged) /* Added By JHKim, When 2018.07.12.*/
    Q_PROPERTY(int point READ point WRITE setPoint NOTIFY pointChanged) /* Added By JHKim, When 2018.07.12.*/

    Q_PROPERTY(bool showed READ showed WRITE show NOTIFY showedChanged)
    Q_PROPERTY(int popupNo READ popupNo WRITE setPopupNo NOTIFY popupNoChanged)

    Q_PROPERTY(int isVerticalVideo READ isVerticalVideo WRITE setIsVerticalVideo NOTIFY isVerticalVideoChanged)
    Q_PROPERTY(int prizeType READ prizeType WRITE setPrizeType NOTIFY prizeTypeChanged)

    Q_PROPERTY(QString appliedText READ appliedText WRITE setAppliedText NOTIFY appliedTextChanged) //2-7. 2-10.
    Q_PROPERTY(QString appliedImageUrl READ appliedImageUrl WRITE setAppliedImageUrl NOTIFY appliedImageUrlChanged) //2-7. 2-10.


public:
    explicit Univ(QObject *parent = 0) { }
    Q_INVOKABLE int boardArticleNo() { return m_boardArticleNo; } //3-1.
    Q_INVOKABLE int boardNo() { return m_boardNo; }//3-1.
    Q_INVOKABLE QString title() { return m_title; } //3-1.
    Q_INVOKABLE int userNo() { return m_userNo; }
    Q_INVOKABLE QString nickname() { return m_nickname; }
    Q_INVOKABLE int viewCount() { return m_viewCount; }
    Q_INVOKABLE int repleCount() { return m_repleCount; }
    Q_INVOKABLE QString writeDate() { return m_writeDate; }
    Q_INVOKABLE QString contents() { return m_contents; }
    Q_INVOKABLE QString updateDate() { return m_updateDate; }
    Q_INVOKABLE int repleNo() { return m_repleNo; }


    //3-4.에서 file에 대해서 List로 사용
    Q_INVOKABLE QList<QObject*> fileList() const { return m_fileList; }
    Q_INVOKABLE QList<QObject*> imageList() const { return m_imageList; }

    //3-12. 강의목록(클립 목록)보기
    Q_INVOKABLE int courseNo() const { return m_courseNo; } //3-1. //3-2.
    Q_INVOKABLE int lessonSubitemNo() const { return m_lessonSubitemNo; }
    Q_INVOKABLE QString lessonTitle() const { return m_lessonTitle; }
    Q_INVOKABLE int requiredLearningTimeInSeconds() const { return m_requiredLearningTimeInSeconds; }
    Q_INVOKABLE int displayOrder() const { return m_displayOrder; }
    Q_INVOKABLE QString imageUrl() const { return m_imageUrl; }
    Q_INVOKABLE QString thumbnailUrl() const { return m_thumbnailUrl; }
    Q_INVOKABLE int likeCount() const { return m_likeCount; }

    //3-2. 과목 상세보기
    /* Added By JHKim, When 2018.06.20.  Moved from class Model */
    Q_INVOKABLE QString studyGoal() const { return m_studyGoal; }
    Q_INVOKABLE QString studyTarget() const { return m_studyTarget; }
    Q_INVOKABLE	QString studyRef() const { return m_studyRef; }
    Q_INVOKABLE QString teacherInfo() const { return m_teacherInfo; }
    Q_INVOKABLE QString studyComplete() const { return m_studyComplete; }
    Q_INVOKABLE QString studyNcs() const { return m_studyNcs; }
    Q_INVOKABLE QString shortDescription() { return m_shortDescription; }
    Q_INVOKABLE QString courseIntroduce() const { return m_courseIntroduce; }
    Q_INVOKABLE QString courseInfoImageUrl() const { return m_courseInfoImageUrl; }
    Q_INVOKABLE QString courseImageUrl() const { return m_courseImageUrl; } //3-1. courseImageUrl (과목배경이미지 활용) 변수와 다름
    Q_INVOKABLE QString courseImageThumnailUrl() const { return m_courseImageThumnailUrl; } //3-1. courseImageThumnailUrl (과목썸네일배경이미지 활용) 변수와 다름

    //2-7. 마이페이지 탭 메인화면(나의수강강좌)
    Q_INVOKABLE int courseContentNo() const { return m_courseContentNo; } //3-1. //3-2
    Q_INVOKABLE QString serviceTitle() const { return m_serviceTitle; } //3-1. //3-2.
    Q_INVOKABLE int studentProgress() const { return m_studentProgress; }

    //4-1. 검색 탭 메인화면
    Q_INVOKABLE QString keyword() const { return m_keyword; }

    //5-1. 좋아요 탭 메인화면-클립
    Q_INVOKABLE QString likeDate() const { return m_likeDate; }

    Q_INVOKABLE QString linkUrl() const { return m_linkUrl; } /* Added By JHKim, When 2018.06.17.*/
    Q_INVOKABLE int like() const { return m_like; } /* Added By JHKim, When 2018.06.17.*/
    Q_INVOKABLE int top() const { return m_top; } /* Added By JHKim, When 2018.06.17.*/

    Q_INVOKABLE int deliveryFlag() const { return m_deliveryFlag; } /* Added By JHKim, When 2018.06.20.*/
    Q_INVOKABLE int attendanceCode() const { return m_attendanceCode; } /* Added By JHKim, When 2018.06.20.*/
    Q_INVOKABLE int good() const { return m_good; } /* Added By JHKim, When 2018.06.20.*/
    Q_INVOKABLE int reportCount() const { return m_reportCount; } /* Added By JHKim, When 2018.06.20.*/

    Q_INVOKABLE bool clicked()    const { return m_clicked; }
    Q_INVOKABLE bool selected()   const { return m_selected; }

    Q_INVOKABLE QString profileImage() const { return m_profileImage; } //2-7. 2-10.
    Q_INVOKABLE QString profileThumbNailUrl() const { return m_profileThumbNailUrl; } //2-7. 2-10.

    Q_INVOKABLE int prizeNo() const { return m_prizeNo; } /* Added By JHKim, When 2018.06.20.*/
    Q_INVOKABLE int point() const { return m_point; } /* Added By JHKim, When 2018.06.20.*/
    Q_INVOKABLE bool showed() const { return m_showed; }
    Q_INVOKABLE int popupNo() const { return m_popupNo; }

    Q_INVOKABLE int isVerticalVideo() const { return m_isVerticalVideo; }
    Q_INVOKABLE int prizeType() const { return m_prizeType; }

    Q_INVOKABLE QString appliedText() const { return m_appliedText; }
    Q_INVOKABLE QString appliedImageUrl() const { return m_appliedImageUrl; }

public slots :
    void setBoardArticleNo(int m) { m_boardArticleNo = m; emit boardArticleNoChanged(); }  //3-1.
    void setBoardNo(int m) { m_boardNo = m; emit boardNoChanged(); } //3-1.
    void setTitle(QString m) { m_title = m; emit titleChanged(); } //3-1.
    void setUserNo(int m) { m_userNo = m; emit userNoChanged(); }
    void setNickname(QString m) { m_nickname = m; emit nicknameChanged(); }

    void setViewCount(int m) { m_viewCount = m; emit viewCountChanged(); }
    void setRepleCount(int m) { m_repleCount = m; emit repleCountChanged(); }
    void setWriteDate(QString m) { m_writeDate = m; emit writeDateChanged(); }
    void setContents(QString m) { m_contents = m; emit contentsChanged(); }
    void setUpdateDate(QString m) { m_updateDate = m; emit updateDateChanged(); }
    void setRepleNo(int m) { m_repleNo = m; emit repleNoChanged(); }

    //3-4.에서 file에 대해서 List로 사용
    void setFileList(QList<QObject*> m) { m_fileList.clear(); m_fileList = m; emit fileListChanged(); }
    void setImageList(QList<QObject*> m) { m_imageList.clear(); m_imageList = m; emit imageListChanged(); }

    //3-12. 강의목록(클립 목록)보기
    void setCourseNo(int m) { m_courseNo = m; emit courseNoChanged(); } //3-1. //3-2.
    void setLessonSubitemNo(int m) { m_lessonSubitemNo = m; emit lessonSubitemNoChanged(); }
    void setLessonTitle(QString m) { m_lessonTitle = m; emit lessonTitleChanged(); }
    void setRequiredLearningTimeInSeconds(int m) { m_requiredLearningTimeInSeconds = m; emit requiredLearningTimeInSecondsChanged(); }
    void setDisplayOrder(int m) { m_displayOrder = m; emit displayOrderChanged(); }
    void setImageUrl(QString m) { m_imageUrl = m; emit imageUrlChanged(); }
    void setThumbnailUrl(QString m) { m_thumbnailUrl = m; emit thumbnailUrlChanged(); }
    void setLikeCount(int m) { m_likeCount = m; emit likeCountChanged(); }

    //2-7. 마이페이지 탭 메인화면(나의수강강좌)
    void setCourseContentNo(int m) { m_courseContentNo = m; emit courseContentNoChanged(); } //3-1.
    void setServiceTitle(QString m) { m_serviceTitle = m; emit serviceTitleChanged(); }
    void setStudentProgress(int m) {m_studentProgress = m; emit studentProgressChanged(); }

    //3-2. 과목 상세보기
    /* Added By JHKim, When 2018.06.20.  Moved from class Model */
    void setStudyGoal(QString m) { m_studyGoal = m; emit studyGoalChanged(); }
    void setStudyTarget(QString m) { m_studyTarget = m; emit studyTargetChanged(); }
    void setStudyRef(QString m) { m_studyRef = m; emit studyRefChanged(); }
    void setTeacherInfo(QString m) { m_teacherInfo = m; emit teacherInfoChanged(); }
    void setStudyComplete(QString m) { m_studyComplete = m; emit studyCompleteChanged(); }
    void setStudyNcs(QString m) { m_studyNcs = m; emit studyNcsChanged(); }
    void setShortDescription(QString m) { m_shortDescription = m; emit shortDescriptionChanged(); }
    void setCourseIntroduce(QString m) { m_courseIntroduce = m; emit courseIntroduceChanged(); }
    void setCourseInfoImageUrl(QString m) { m_courseInfoImageUrl = m; emit courseInfoImageUrlChanged(); }
    void setCourseImageUrl(QString m) { m_courseImageUrl = m; emit courseImageUrlChanged(); } //3-1. courseImageUrl (과목배경이미지 활용) 변수와 다름
    void setCourseImageThumnailUrl(QString m) { m_courseImageThumnailUrl = m; emit courseImageThumnailUrlChanged(); } //3-1. courseImageThumnailUrl (과목썸네일배경이미지 활용) 변수와 다름

    //4-1. 검색 탭 메인화면
    void setKeyword(QString m) { m_keyword = m; emit keywordChanged(); }

    //5-1. 좋아요 탭 메인화면-클립
    void setLikeDate(QString m) { m_likeDate = m; emit likeDateChanged(); }

    void setLinkUrl(QString m) { m_linkUrl = m; emit linkUrlChanged(); } /* Added By JHKim, When 2018.06.17.*/
    void setLike(int m) { m_like = m; emit likeChanged(); } /* Added By JHKim, When 2018.06.17.*/
    void setTop(int m) { m_top = m; emit topChanged(); } /* Added By JHKim, When 2018.06.17.*/

    void setDeliveryFlag(int m) { m_deliveryFlag = m; emit deliveryFlagChanged(); } /* Added By JHKim, When 2018.06.20.*/
    void setAttendanceCode(int m) { m_attendanceCode = m; emit attendanceCodeChanged(); } /* Added By JHKim, When 2018.06.20.*/

    void setGood(int m) { m_good = m; emit goodChanged(); } /* Added By JHKim, When 2018.06.20.*/
    void setReportCount(int m) { m_reportCount = m; emit reportCountChanged(); }/* Added By JHKim, When 2018.06.20.*/

    void click(bool m)       { m_clicked = m; emit clickedChanged(); }
    void select(bool m)      { m_selected = m; emit selectedChanged(); }

    void setProfileImage(QString m) { m_profileImage = m; emit profileImageChanged(); } //2-7. 2-10.
    void setProfileThumbNailUrl(QString m) { m_profileThumbNailUrl = m; emit profileThumbNailUrlChanged(); } //2-7. 2-10.

    void setPrizeNo(int m) { m_prizeNo = m; emit prizeNoChanged(); }
    void setPoint(int m) { m_point = m; emit pointChanged(); }

    void show(int m) { m_showed = m; emit showedChanged(); }

    void clearFileList() { m_fileList.clear(); emit fileListChanged();}
    void clearImageList() { m_imageList.clear(); emit imageListChanged();}
    void setPopupNo(int m) { m_popupNo = m; emit popupNoChanged(); }

    void setIsVerticalVideo(int m) { m_isVerticalVideo = m; emit isVerticalVideoChanged(); }
    void setPrizeType(int m) { m_prizeType = m; emit prizeTypeChanged(); }

    void setAppliedText(QString m) { m_appliedText = m; emit appliedTextChanged(); }
    void setAppliedImageUrl(QString m) { m_appliedImageUrl = m; emit appliedImageUrlChanged(); }


signals:
    void boardArticleNoChanged(); //3-1.
    void boardNoChanged(); //3-1.
    void titleChanged(); //3-1.
    void userNoChanged();
    void nicknameChanged();

    void viewCountChanged();
    void repleCountChanged();
    void writeDateChanged();
    void contentsChanged();
    void updateDateChanged();
    void repleNoChanged();

    //3-4.에서 file에 대해서 List로 사용
    void fileListChanged();
    void imageListChanged();

    //3-12. 강의목록(클립 목록)보기
    void courseNoChanged(); //3-1. //3-2.
    void lessonSubitemNoChanged();
    void lessonTitleChanged();
    void requiredLearningTimeInSecondsChanged();
    void displayOrderChanged();
    void imageUrlChanged();
    void thumbnailUrlChanged();
    void likeCountChanged();

    //2-7. 마이페이지 탭 메인화면(나의수강강좌)
    void courseContentNoChanged(); //3-1.
    void serviceTitleChanged(); //3-1. //3-2.
    void studentProgressChanged();

    //3-2. 과목 상세보기
    /* Added By JHKim, When 2018.06.20.  Moved from class Model */
    void studyGoalChanged();
    void studyTargetChanged();
    void studyRefChanged();
    void teacherInfoChanged();
    void studyCompleteChanged();
    void studyNcsChanged();
    void shortDescriptionChanged();
    void courseIntroduceChanged();
    void courseInfoImageUrlChanged();
    void courseImageUrlChanged(); //3-1. courseImageUrl (과목배경이미지 활용) 변수와 다름
    void courseImageThumnailUrlChanged(); //3-1. courseImageThumnailUrl (과목썸네일배경이미지 활용) 변수와 다름

    //4-1. 검색 탭 메인화면
    void keywordChanged();

    //5-1. 좋아요 탭 메인화면-클립
    void likeDateChanged();

    void linkUrlChanged(); /* Added By JHKim, When 2018.06.17.*/
    void likeChanged(); /* Added By JHKim, When 2018.06.17.*/
    void topChanged();  /* Added By JHKim, When 2018.06.17.*/

    void deliveryFlagChanged(); /* Added By JHKim, When 2018.06.20.*/
    void attendanceCodeChanged(); /* Added By JHKim, When 2018.06.20.*/

    void goodChanged(); /* Added By JHKim, When 2018.06.20.*/
    void reportCountChanged(); /* Added By JHKim, When 2018.06.20.*/

    void clickedChanged();
    void selectedChanged();

    void profileImageChanged(); //2-7. 2-10.
    void profileThumbNailUrlChanged(); //2-7. 2-10.

    void prizeNoChanged();
    void pointChanged();

    void showedChanged();
    void popupNoChanged();

    void isVerticalVideoChanged();
    void prizeTypeChanged();

    void appliedTextChanged();
    void appliedImageUrlChanged();

private:
    int m_boardArticleNo = 0;
    int m_boardNo = 0;
    QString m_title; //3-1.
    int m_userNo = 0;
    QString m_nickname;

    int m_viewCount = 0;
    int m_repleCount = 0;
    QString m_writeDate;
    QString m_contents;
    QString m_updateDate;
    int m_repleNo = 0;

    //3-4.에서 file에 대해서 List로 사용
    QList<QObject*> m_fileList;
    QList<QObject*> m_imageList;

    //3-12. 강의목록(클립 목록)보기
    int m_courseNo = 0;
    int m_lessonSubitemNo = 0;
    QString m_lessonTitle;
    int m_requiredLearningTimeInSeconds;
    int m_displayOrder;
    QString m_imageUrl;
    QString m_thumbnailUrl;
    int m_likeCount = 0;

    //2-7. 마이페이지 탭 메인화면(나의수강강좌)
    int m_courseContentNo = 0;
    QString m_serviceTitle; //3-1. //3-2.
    int m_studentProgress;

    //3-2. 과목 상세보기
    /* Added By JHKim, When 2018.06.20.  Moved from class Model */
    QString m_studyGoal = "";
    QString m_studyTarget = "";
    QString m_studyRef = "";
    QString m_teacherInfo = "";
    QString m_studyComplete = "";
    QString m_studyNcs = "";
    QString m_shortDescription = "";
    QString m_courseIntroduce = "";
    QString m_courseInfoImageUrl = "";
    QString m_courseImageUrl = ""; //3-1. courseImageUrl (과목배경이미지 활용) 변수와 다름
    QString m_courseImageThumnailUrl = "";  //3-1. courseImageThumnailUrl (과목썸네일배경이미지 활용) 변수와 다름

    //4-1. 검색 탭 메인화면
    QString m_keyword;

    //5-1. 좋아요 탭 메인화면-클립
    QString m_likeDate;

    QString m_linkUrl; /* Added By JHKim, When 2018.06.17.*/
    int m_like = 0; /* Added By JHKim, When 2018.06.17.*/
    int m_top = 0; /* Added By JHKim, When 2018.06.17.*/

    int m_deliveryFlag = -1; /* Added By JHKim, When 2018.06.20.*/
    int m_attendanceCode = 0;

    int m_good; /* Added By JHKim, When 2018.06.20.*/
    int m_reportCount = 0;
    bool m_clicked = false;
    bool m_selected = false;

    QString m_profileImage; //2-7. 2-10.
    QString m_profileThumbNailUrl; //2-7. 2-10.

    int m_prizeNo = 0;
    int m_point = 0;

    bool m_showed = false;
    int m_popupNo = 0;

    int m_isVerticalVideo = 0;
    int m_prizeType = 0;

    QString m_appliedText;
    QString m_appliedImageUrl;
};

class Alarm : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int alarmNo READ alarmNo WRITE setAlarmNo NOTIFY alarmNoChanged)
    Q_PROPERTY(int pushType READ pushType WRITE setPushType NOTIFY pushTypeChanged)
    Q_PROPERTY(int eventType READ eventType WRITE setEventType NOTIFY eventTypeChanged)
    Q_PROPERTY(int score READ score WRITE setScore NOTIFY scoreChanged)
    Q_PROPERTY(QString writeDate READ writeDate WRITE setWriteDate NOTIFY writeDateChanged)
    Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY descriptionChanged)
    Q_PROPERTY(bool userRead READ userRead WRITE setUserRead NOTIFY userReadChanged)
    Q_PROPERTY(bool folded READ folded WRITE fold NOTIFY foldedChanged)

public:
    Q_INVOKABLE int alarmNo() { return m_alarmNo; }
    Q_INVOKABLE int pushType() { return m_pushType; }
    Q_INVOKABLE int eventType() { return m_eventType; }
    Q_INVOKABLE int score() { return m_score; }
    Q_INVOKABLE QString writeDate() { return m_writeDate; }
    Q_INVOKABLE QString description() { return m_description; }
    Q_INVOKABLE bool userRead() { return m_userRead; }
    Q_INVOKABLE bool folded() { return m_folded; }

public slots:
    void setAlarmNo(int m) { m_alarmNo = m; emit alarmNoChanged(); }
    void setPushType(int m) { m_pushType = m; emit pushTypeChanged(); }
    void setEventType(int m) { m_eventType = m; emit eventTypeChanged(); }
    void setScore(int m) { m_score = m; emit scoreChanged(); }
    void setWriteDate(QString m) { m_writeDate = m; emit writeDateChanged(); }
    void setDescription(QString m) { m_description = m; emit descriptionChanged(); }
    void setUserRead(bool m) { m_userRead = m; emit userReadChanged(); }
    void fold(bool m) { m_folded = m; emit foldedChanged(); }

signals:
    void alarmNoChanged();
    void pushTypeChanged();
    void eventTypeChanged();
    void scoreChanged();
    void writeDateChanged();
    void descriptionChanged();
    void userReadChanged();
    void foldedChanged();

private:
    int m_alarmNo = 0;
    int m_pushType = 0;
    int m_eventType = 0;
    int m_score = 0;
    QString m_writeDate;
    QString m_description;
    bool m_userRead = false;
    bool m_folded = true;
};

//3-1. 홈 메인화면(과목리스트받아오기)
class Main : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString startDate READ startDate WRITE setStartDate NOTIFY startDateChanged)
    Q_PROPERTY(QString endDate READ endDate WRITE setEndDate NOTIFY endDateChanged)
    Q_PROPERTY(QString categoryTitle READ categoryTitle WRITE setCategoryTitle NOTIFY categoryTitleChanged)
    Q_PROPERTY(QString courseImageUrl READ courseImageUrl WRITE setCourseImageUrl NOTIFY courseImageUrlChanged)
    Q_PROPERTY(QString courseImageThumnailUrl READ courseImageThumnailUrl WRITE setCourseImageThumnailUrl NOTIFY courseImageThumnailUrlChanged)

    /* Added By JHKim, When 2018.06.19.*/
    Q_PROPERTY(int courseNo READ courseNo WRITE setCourseNo NOTIFY courseNoChanged) //3-1. //3-2.
    Q_PROPERTY(int courseContentNo READ courseContentNo WRITE setCourseContentNo NOTIFY courseContentNoChanged) //3-1. //3-2.
    Q_PROPERTY(QString serviceTitle READ serviceTitle WRITE setServiceTitle NOTIFY serviceTitleChanged) //3-1. //3-2. //3-12.

    /* Added By JHKim, When 2018.06.20.*/
    Q_PROPERTY(bool   clicked   READ clicked      WRITE click       NOTIFY clickedChanged)
    Q_PROPERTY(bool   selected  READ selected     WRITE select          NOTIFY selectedChanged)
    Q_PROPERTY(bool   showed  READ showed     WRITE show          NOTIFY showedChanged)
    Q_PROPERTY(int   order READ order WRITE setOrder NOTIFY orderChanged)

    Q_PROPERTY(int   viewCount  READ viewCount     WRITE setViewCount          NOTIFY viewCountChanged)

public:
    Q_INVOKABLE QString startDate() const { return m_startDate; }
    Q_INVOKABLE QString endDate() const { return m_endDate; }
    Q_INVOKABLE QString categoryTitle() const { return m_categoryTitle; }
    Q_INVOKABLE QString courseImageUrl() const { return m_courseImageUrl; }
    Q_INVOKABLE QString courseImageThumnailUrl() const { return m_courseImageThumnailUrl; }

    /* Added By JHKim, When 2018.06.19.*/
    Q_INVOKABLE int courseNo() const { return m_courseNo; } //3-1. //3-2.
    Q_INVOKABLE int courseContentNo() const { return m_courseContentNo; } //3-1. //3-2
    Q_INVOKABLE QString serviceTitle() const { return m_serviceTitle; } //3-1. //3-2

    /* Added By JHKim, When 2018.06.20.*/
    Q_INVOKABLE bool clicked()    const { return m_clicked; }
    Q_INVOKABLE bool selected() const { return m_selected; }
    Q_INVOKABLE bool showed() const { return m_showed; }
    Q_INVOKABLE int order()     const { return m_order;    }

    Q_INVOKABLE int viewCount()     const { return m_viewCount;    }


public slots :
    void setStartDate(QString m) { m_startDate = m; emit startDateChanged(); }
    void setEndDate(QString m) { m_endDate = m; emit endDateChanged(); }
    void setCategoryTitle(QString m) { m_categoryTitle = m; emit categoryTitleChanged(); }
    void setCourseImageUrl(QString m) { m_courseImageUrl = m; emit courseImageUrlChanged(); }
    void setCourseImageThumnailUrl(QString m) { m_courseImageThumnailUrl = m; emit courseImageThumnailUrlChanged(); }

    /* Added By JHKim, When 2018.06.19.*/
    void setCourseNo(int m) { m_courseNo = m; emit courseNoChanged(); } //3-1. //3-2.
    void setCourseContentNo(int m) { m_courseContentNo = m; emit courseContentNoChanged(); } //3-1.
    void setServiceTitle(QString m) { m_serviceTitle = m; emit serviceTitleChanged(); }

    /* Added By JHKim, When 2018.06.20.*/
    void select(bool m) { m_selected = m; emit selectedChanged(); }
    void click(bool m)       { m_clicked = m; emit clickedChanged();}
    void show(bool m) {m_showed = m; emit showedChanged(); }
    void setOrder(int m)     { m_order = m; emit orderChanged();}

    void setViewCount(int m) { m_viewCount = m; emit viewCountChanged(); }

signals:
    void startDateChanged();
    void endDateChanged();
    void categoryTitleChanged();
    void courseImageUrlChanged();
    void courseImageThumnailUrlChanged();

    /* Added By JHKim, When 2018.06.19.*/
    void courseNoChanged(); //3-1. //3-2.
    void courseContentNoChanged(); //3-1.
    void serviceTitleChanged(); //3-1. //3-2.

    /* Added By JHKim, When 2018.06.20.*/
    void clickedChanged();
    void selectedChanged();
    void showedChanged();
    void orderChanged();

    void viewCountChanged();
    void newAlarmChanged();


private:
    QString m_startDate;
    QString m_endDate;
    QString m_categoryTitle;
    QString m_courseImageUrl;
    QString m_courseImageThumnailUrl;

    /* Added By JHKim, When 2018.06.19.*/
    int m_courseNo; //3-1. //3-2.
    int m_courseContentNo; //3-1. //3-2.
    QString m_serviceTitle; //3-1. //3-2.

    /* Added By JHKim, When 2018.06.20.*/
    bool m_clicked = false;
    bool m_selected = false;
    bool m_showed = false;
    int m_order = 0;

    int m_viewCount = 0;

};

//3-1. 홈 메인화면(과목리스트받아오기)_배너
class Banner : public QObject
{
    Q_OBJECT

public:
    Q_PROPERTY(int boardNo READ boardNo WRITE setBoardNo NOTIFY boardNoChanged)
    Q_PROPERTY(int boardArticleNo READ boardArticleNo WRITE setBoardArticleNo NOTIFY boardArticleNoChanged)

    /* Added By JHKim, When 2018.06.17.*/
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QString fileUrl READ fileUrl WRITE setFileUrl NOTIFY fileUrlChanged)
    Q_PROPERTY(QString thumbNailUrl READ thumbNailUrl WRITE setThumbNailUrl NOTIFY thumbNailUrlChanged)

    /* Added By JHKim, When 2018.06.20.*/
    Q_PROPERTY(bool   clicked   READ clicked      WRITE click       NOTIFY clickedChanged)
    Q_PROPERTY(bool   selected  READ selected     WRITE select          NOTIFY selectedChanged)
    Q_PROPERTY(int   order READ order WRITE setOrder NOTIFY orderChanged)

public:
    Q_INVOKABLE int boardArticleNo() { return m_boardArticleNo; }
    Q_INVOKABLE int boardNo() { return m_boardNo; }

    /* Added By JHKim, When 2018.06.17.*/
    Q_INVOKABLE QString title() { return m_title; }
    Q_INVOKABLE QString fileUrl() { return m_fileUrl; }
    Q_INVOKABLE QString thumbNailUrl() { return m_thumbNailUrl; }

    /* Added By JHKim, When 2018.06.20.*/
    Q_INVOKABLE bool clicked()    const { return m_clicked;    }
    Q_INVOKABLE bool selected() const { return m_selected; }
    Q_INVOKABLE int order()     const { return m_order;    }

public slots :
    void setBoardArticleNo(int m) { m_boardArticleNo = m; emit boardArticleNoChanged(); }
    void setBoardNo(int m) { m_boardNo = m; emit boardNoChanged(); }

    /* Added By JHKim, When 2018.06.17.*/
    void setTitle(QString m) { m_title = m; emit titleChanged(); }
    void setFileUrl(QString m) {m_fileUrl = m; emit fileUrlChanged(); }
    void setThumbNailUrl(QString m) { m_thumbNailUrl = m; emit thumbNailUrlChanged(); }

    /* Added By JHKim, When 2018.06.20.*/
    void select(bool m) { m_selected = m; emit selectedChanged(); }
    void click(bool m)       { m_clicked = m; emit clickedChanged();}
    void setOrder(int m)     { m_order = m; emit orderChanged();}

signals:
    void boardArticleNoChanged();
    void boardNoChanged();

    /* Added By JHKim, When 2018.06.17.*/
    void titleChanged();
    void fileUrlChanged();
    void thumbNailUrlChanged();

    /* Added By JHKim, When 2018.06.20.*/
    void clickedChanged();
    void selectedChanged();
    void orderChanged();

private:
    int m_boardArticleNo;
    int m_boardNo;

    /* Added By JHKim, When 2018.06.17.*/
    QString m_title;
    QString m_fileUrl;
    QString m_thumbNailUrl;

    /* Added By JHKim, When 2018.06.20.*/
    bool m_clicked = false;
    bool m_selected = false;
    int m_order = 0;


};
class Image : public QObject
{
    Q_OBJECT

public:
    Q_PROPERTY(int no READ no WRITE setNo NOTIFY noChanged)
    Q_PROPERTY(QString url READ url WRITE setUrl NOTIFY urlChanged)

    /* Added By JHKim, When 2018.06.17. */
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(int width READ width WRITE setWidth NOTIFY widthChanged)
    Q_PROPERTY(int height READ height WRITE setHeight NOTIFY heightChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    ///

    Q_INVOKABLE int no() const { return m_no; }
    Q_INVOKABLE QString url() const { return m_url; }

    /* Added By JHKim, When 2018.06.17. */
    Q_INVOKABLE int id() const { return m_id; }
    Q_INVOKABLE int width() const { return m_width; }
    Q_INVOKABLE int height() const { return m_height; }
    Q_INVOKABLE QString name() const { return m_name; }
    ///

    Image(QObject* parent = 0) : QObject(parent) { }

signals:
    void noChanged();
    void urlChanged();

    /* Added By JHKim, When 2018.06.17. */
    void idChanged();
    void widthChanged();
    void heightChanged();
    void nameChanged();
    ///


public slots:
    void setNo(int m) { m_no = m; emit noChanged(); }
    void setUrl(QString m) { m_url = m; emit urlChanged(); }

    /* Added By JHKim, When 2018.06.17. */
    void setId(int m) { m_id = m; }
    void setWidth(int m) { m_width = m; emit widthChanged();}
    void setHeight(int m) { m_height = m; emit heightChanged();}
    void setName(QString m) { m_name = m; emit nameChanged();}
    ///

private:
    int m_no;
    QString m_url;

    /* Added By JHKim, When 2018.06.17. */
    int m_id;
    int m_width;
    int m_height;
    QString m_name;
    ///
};

//3-2. 과목 상세보기(해당과목과 연결된 게시판)
class Board : public QObject
{
    Q_OBJECT

public:
    Q_PROPERTY(int boardNo READ boardNo WRITE setBoardNo NOTIFY boardNoChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(int writableStudent READ writableStudent WRITE setWritableStudent NOTIFY writableStudentChanged)

public:
    Q_INVOKABLE int boardNo() const { return m_boardNo; }
    Q_INVOKABLE QString title() const { return m_title; }
    Q_INVOKABLE int writableStudent() const { return m_writableStudent; }

public slots :
    void setBoardNo(int m) { m_boardNo = m; emit boardNoChanged(); }
    void setTitle(QString m) { m_title = m; emit titleChanged(); }
    void setWritableStudent(int m) { m_writableStudent = m; emit writableStudentChanged(); }

signals:
    void boardNoChanged();
    void titleChanged();
    void writableStudentChanged();
private:
    int m_boardNo;
    QString m_title;
    int m_writableStudent;
};

//퀴즈 보기
class Example : public QObject
{
    Q_OBJECT
public:
    Q_PROPERTY(int correctExample READ correctExample WRITE setCorrectExample NOTIFY correctExampleChanged)
    Q_PROPERTY(int exampleNo READ exampleNo WRITE setExampleNo NOTIFY exampleNoChanged)
    Q_PROPERTY(int exampleType READ exampleType WRITE setExampleType NOTIFY exampleTypeChanged)
    Q_PROPERTY(int displayOrder READ displayOrder WRITE setDisplayOrder NOTIFY displayOrderChanged)
    Q_PROPERTY(QString example READ example WRITE setExample NOTIFY exampleChanged)
    Q_PROPERTY(int selected READ selected WRITE select NOTIFY selectedChanged)

public:
    Q_INVOKABLE int correctExample() const { return m_correctExample; }
    Q_INVOKABLE int exampleNo() const { return m_exampleNo; }
    Q_INVOKABLE int displayOrder() const { return m_displayOrder; }
    Q_INVOKABLE int exampleType() const { return m_exampleType; }
    Q_INVOKABLE QString example() const { return m_example; }
    Q_INVOKABLE int selected() const { return m_selected; }

public slots:
    void setCorrectExample(int m) { m_correctExample = m; emit correctExampleChanged(); }
    void setExampleNo(int m) { m_exampleNo = m; emit exampleNoChanged(); }
    void setDisplayOrder(int m) { m_displayOrder = m; emit displayOrderChanged(); }
    void setExampleType(int m) { m_exampleType = m; emit exampleTypeChanged(); }
    void setExample(QString m) { m_example = m; emit exampleChanged(); }
    void select(int m) { m_selected = m; emit selectedChanged();}

signals:
    void correctExampleChanged();
    void exampleNoChanged();
    void displayOrderChanged();
    void exampleTypeChanged();
    void exampleChanged();
    void selectedChanged();

private:
    int m_correctExample;
    int m_exampleNo;
    int m_displayOrder;
    int m_exampleType;
    QString m_example;
    int m_selected;
};

//3-13. 클립 상세 보기(학습페이지)
class Quiz : public QObject
{
    Q_OBJECT

public:
    Q_PROPERTY(int quizNo READ quizNo WRITE setQuizNo NOTIFY quizNoChanged)
    Q_PROPERTY(int quizType READ quizType WRITE setQuizType NOTIFY quizTypeChanged)
    Q_PROPERTY(QString quizText READ quizText WRITE setQuizText NOTIFY quizTextChanged)
    Q_PROPERTY(int correctExampleNo READ correctExampleNo WRITE setCorrectExampleNo NOTIFY correctExampleNoChanged)
    Q_PROPERTY(int quizScore READ quizScore WRITE setQuizScore NOTIFY quizScoreChanged)
    Q_PROPERTY(int difficulty READ difficulty WRITE setDifficulty NOTIFY difficultyChanged)
    Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY descriptionChanged)
    Q_PROPERTY(int exampleNo READ exampleNo WRITE setExampleNo NOTIFY exampleNoChanged)
    Q_PROPERTY(int displayOrder READ displayOrder WRITE setDisplayOrder NOTIFY displayOrderChanged)
    Q_PROPERTY(int exampleType READ exampleType WRITE setExampleType NOTIFY exampleTypeChanged)
    Q_PROPERTY(int answerNo READ answerNo WRITE setAnswerNo NOTIFY answerNoChanged)

    /* Added By JHKim, When 2018.06.20. */
    Q_PROPERTY(QString quizTextFileUrl READ quizTextFileUrl WRITE setQuizTextFileUrl NOTIFY quizTextFileUrlChanged)

    /* Added By JHKim, When 2018.06.22. */
    Q_PROPERTY(QList<QObject*> examples READ examples WRITE setExamples NOTIFY examplesChanged)

public:
    Q_INVOKABLE int quizNo() const { return m_quizNo; }
    Q_INVOKABLE int quizType() const { return m_quizType; }
    Q_INVOKABLE QString quizText() const { return m_quizText; }
    Q_INVOKABLE int correctExampleNo() const { return m_correctExampleNo; }
    Q_INVOKABLE int quizScore() const { return m_quizScore; }
    Q_INVOKABLE int difficulty() const { return m_difficulty; }
    Q_INVOKABLE QString description() const { return m_description; }
    Q_INVOKABLE int exampleNo() const { return m_exampleNo; }
    Q_INVOKABLE int displayOrder() const { return m_displayOrder; }
    Q_INVOKABLE int exampleType() const { return m_exampleType; }
    Q_INVOKABLE int answerNo() const { return m_answerNo; }

    /* Added By JHKim, When 2018.06.20. */
    Q_INVOKABLE QString quizTextFileUrl() const { return m_quizTextFileUrl; }

    /* Added By JHKim, When 2018.06.22. */
    Q_INVOKABLE QList<QObject*> examples() const { return m_examples; }

public slots:
    void setQuizNo(int m) { m_quizNo = m; emit quizNoChanged(); }
    void setQuizType(int m) { m_quizType = m; emit quizTypeChanged(); }
    void setQuizText(QString m) { m_quizText = m; emit quizTextChanged(); }
    void setCorrectExampleNo(int m) { m_correctExampleNo = m; emit correctExampleNoChanged(); }
    void setQuizScore(int m) { m_quizScore = m; emit quizScoreChanged(); }
    void setDifficulty(int m) { m_difficulty = m; emit difficultyChanged(); }
    void setDescription(QString m) { m_description = m; emit descriptionChanged(); }
    void setExampleNo(int m) { m_exampleNo = m; emit exampleNoChanged(); }
    void setDisplayOrder(int m) { m_displayOrder = m; emit displayOrderChanged(); }
    void setExampleType(int m) { m_exampleType = m; emit exampleTypeChanged(); }
    void setAnswerNo(int m) { m_answerNo = m; emit answerNoChanged(); }

    /* Added By JHKim, When 2018.06.20. */
    void setQuizTextFileUrl(QString m) { m_quizTextFileUrl = m; emit quizTextFileUrlChanged(); }

    /* Added By JHKim, When 2018.06.22. */
    void setExamples(QList<QObject*> m) { m_examples.clear(); m_examples = m; emit examplesChanged();}
    void appendExamples(QObject* m) { m_examples.append(m); emit examplesChanged();}
    void clearExamples() { m_examples.clear(); }

    void select(int index)
    {
        for(QObject* o : examples())
        {
            Example* e = qobject_cast<Example*>(o);
            e->select(0);
        }
        Example* target = qobject_cast<Example*>(m_examples[index]);
        target->select(1);
    }

signals:
    void quizNoChanged();
    void quizTypeChanged();
    void quizTextChanged();
    void correctExampleNoChanged();
    void quizScoreChanged();
    void difficultyChanged();
    void descriptionChanged();
    void exampleNoChanged();
    void displayOrderChanged();
    void exampleTypeChanged();
    void examplesChanged();
    void answerNoChanged();

    /* Added By JHKim, When 2018.06.20. */
    void quizTextFileUrlChanged();

private:
    int m_quizNo;
    int m_quizType;
    QString m_quizText;
    int m_correctExampleNo;
    int m_quizScore;
    int m_difficulty;
    QString m_description;
    int m_exampleNo;
    int m_displayOrder;
    int m_exampleType;
    int m_answerNo;

    /* Added By JHKim, When 2018.06.20. */
    QString m_quizTextFileUrl;

    /* Added By JHKim, When 2018.06.22. */
    QList<QObject*> m_examples;
};

//6-1.랭킹 탭 메인화면
class Rank : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int rankNo READ rankNo WRITE setRankNo NOTIFY rankNoChanged)
    Q_PROPERTY(int rankUserNo READ rankUserNo WRITE setRankUserNo NOTIFY rankUserNoChanged)
    Q_PROPERTY(QString nickname READ nickname WRITE setNickname NOTIFY nicknameChanged)
    Q_PROPERTY(QString profileImage READ profileImage WRITE setProfileImage NOTIFY profileImageChanged) //2-7. 2-10.
    Q_PROPERTY(QString profileThumbNailUrl READ profileThumbNailUrl WRITE setProfileThumbNailUrl NOTIFY profileThumbNailUrlChanged) //2-7. 2-10.
    Q_PROPERTY(int courseScore READ courseScore WRITE setCourseScore NOTIFY courseScoreChanged)
    Q_PROPERTY(int socialScore READ socialScore WRITE setSocialScore NOTIFY socialScoreChanged)
    Q_PROPERTY(int etcScore	   READ etcScore WRITE setEtcScore NOTIFY etcScoreChanged)
    Q_PROPERTY(int totalScore  READ totalScore WRITE setTotalScore NOTIFY totalScoreChanged)
    Q_PROPERTY(int validateNo  READ validateNo WRITE setValidateNo NOTIFY validateNoChanged)
    Q_PROPERTY(QString startDate  READ startDate WRITE setStartDate NOTIFY startDateChanged)
    Q_PROPERTY(QString endDate  READ endDate WRITE setEndDate NOTIFY endDateChanged)
    Q_PROPERTY(int totalPoint  READ totalPoint WRITE setTotalPoint NOTIFY totalPointChanged)
    Q_PROPERTY(int userNo  READ userNo WRITE setUserNo NOTIFY userNoChanged)

public:
    Q_INVOKABLE int rankNo() const { return m_rankNo; }
    Q_INVOKABLE int rankUserNo() const { return m_rankUserNo; }
    Q_INVOKABLE QString nickname() const { return m_nickname; }
    Q_INVOKABLE QString profileImage() const { return m_profileImage; } //2-7. 2-10.
    Q_INVOKABLE QString profileThumbNailUrl() const { return m_profileThumbNailUrl; } //2-7. 2-10.
    Q_INVOKABLE int courseScore() const { return m_courseScore; }
    Q_INVOKABLE	int socialScore() const { return m_socialScore; }
    Q_INVOKABLE	int etcScore()	  const { return m_etcScore; }
    Q_INVOKABLE	int totalScore()  const { return m_totalScore; }
    Q_INVOKABLE	int validateNo() const { return m_validateNo; }
    Q_INVOKABLE	QString startDate()	  const { return m_startDate; }
    Q_INVOKABLE	QString endDate()  const { return m_endDate; }
    Q_INVOKABLE int totalPoint() const { return m_totalPoint; }
    Q_INVOKABLE int userNo() const { return m_userNo; }

public slots:
    void setRankNo(int m) { m_rankNo = m; emit rankNoChanged(); }
    void setRankUserNo(int m) { m_rankUserNo = m; emit rankUserNoChanged(); }
    void setNickname(QString m) { m_nickname = m; emit nicknameChanged(); }
    void setProfileImage(QString m) { m_profileImage = m; emit profileImageChanged(); } //2-7. 2-10.
    void setProfileThumbNailUrl(QString m) { m_profileThumbNailUrl = m; emit profileThumbNailUrlChanged(); } //2-7. 2-10.
    void setCourseScore(int m) { m_courseScore = m; emit courseScoreChanged(); }
    void setSocialScore(int m) { m_socialScore = m; emit socialScoreChanged(); }
    void setEtcScore(int m) { m_etcScore = m; emit etcScoreChanged(); }
    void setTotalScore(int m) { m_totalScore = m; emit totalScoreChanged(); }
    void setValidateNo(int m) { m_validateNo = m; emit validateNoChanged(); }
    void setStartDate(QString m) { m_startDate = m; emit startDateChanged(); }
    void setEndDate(QString m) { m_endDate = m; emit endDateChanged(); }
    void setTotalPoint(int m) { m_totalPoint = m; emit totalPointChanged(); }
    void setUserNo(int m) { m_userNo = m; emit userNoChanged(); }

signals:
    void rankNoChanged();
    void rankUserNoChanged();
    void nicknameChanged();
    void profileImageChanged(); //2-7. 2-10.
    void profileThumbNailUrlChanged(); //2-7. 2-10.
    void courseScoreChanged();
    void socialScoreChanged();
    void etcScoreChanged();
    void totalScoreChanged();
    void validateNoChanged();
    void startDateChanged();
    void endDateChanged();
    void totalPointChanged();
    void userNoChanged();

private:
    int m_rankNo;
    int m_rankUserNo;
    QString m_nickname;
    QString m_profileImage; //2-7. 2-10.
    QString m_profileThumbNailUrl; //2-7. 2-10.

    int m_courseScore;
    int	m_socialScore;
    int m_etcScore;
    int m_totalScore;
    int	m_validateNo;
    QString m_startDate;
    QString m_endDate;
    int m_totalPoint;
    int m_userNo;

};

//6-2. 적립내역 상세보기
class Point : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(int score READ score WRITE setScore NOTIFY scoreChanged)
    Q_PROPERTY(QString comment READ comment WRITE setComment NOTIFY commentChanged)
    Q_PROPERTY(QString date READ date WRITE setDate NOTIFY dateChanged)

public:
    Q_INVOKABLE int type() const { return m_type; }
    Q_INVOKABLE int score() const { return m_score; }
    Q_INVOKABLE QString comment() const { return m_comment; }
    Q_INVOKABLE QString date() const { return m_date; }


public slots :
    void setType(int m) { m_type = m; emit typeChanged(); }
    void setScore(int m) { m_score = m; emit scoreChanged(); }
    void setComment(QString m) { m_comment = m; emit commentChanged(); }
    void setDate(QString m) { m_date = m; emit dateChanged(); }

signals:
    void typeChanged();
    void scoreChanged();
    void commentChanged();
    void dateChanged();


private:
    int m_type;
    int m_score;
    QString m_comment;
    QString m_date;
};


//6-4. 이벤트 내용 리스트 보기
class Event : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int prizeNo READ prizeNo WRITE setPrizeNo NOTIFY prizeNoChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(int cash READ cash WRITE setCash NOTIFY cashChanged)
    Q_PROPERTY(QString imageUrl READ imageUrl WRITE setImageUrl NOTIFY imageUrlChanged)
    Q_PROPERTY(QString startDate READ startDate WRITE setStartDate NOTIFY startDateChanged)
    Q_PROPERTY(QString endDate READ endDate WRITE setEndDate NOTIFY endDateChanged)

    Q_PROPERTY(int isComplete READ isComplete WRITE setIsComplete NOTIFY isCompleteChanged)
    Q_PROPERTY(QString completeDate READ completeDate WRITE setCompleteDate NOTIFY completeDateChanged)
    Q_PROPERTY(QString contents READ contents WRITE setContents NOTIFY contentsChanged)

public:
    Q_INVOKABLE int prizeNo() const { return m_prizeNo; }
    Q_INVOKABLE QString title() const { return m_title; }
    Q_INVOKABLE int cash() const { return m_cash; }
    Q_INVOKABLE QString imageUrl() const { return m_imageUrl; }
    Q_INVOKABLE QString startDate() const { return m_startDate; }
    Q_INVOKABLE QString endDate() const { return m_endDate; }
    Q_INVOKABLE int isComplete() const { return m_isComplete; }
    Q_INVOKABLE QString completeDate() const { return m_completeDate; }
    Q_INVOKABLE QString contents() const { return m_contents; }

public slots :
    void setPrizeNo(int m) { m_prizeNo = m; emit prizeNoChanged(); }
    void setTitle(QString m) { m_title = m; emit titleChanged(); }
    void setCash(int m) { m_cash = m; emit cashChanged(); }
    void setImageUrl(QString m) { m_imageUrl = m; emit imageUrlChanged(); }
    void setStartDate(QString m) { m_startDate = m; emit startDateChanged(); }
    void setEndDate(QString m) { m_endDate = m; emit endDateChanged(); }
    void setIsComplete(int m) { m_isComplete = m; emit isCompleteChanged(); }
    void setCompleteDate(QString m) { m_completeDate = m; emit completeDateChanged(); }
    void setContents(QString m) { m_contents = m; emit contentsChanged(); }

signals:
    void prizeNoChanged();
    void titleChanged();
    void cashChanged();
    void imageUrlChanged();
    void startDateChanged();
    void endDateChanged();
    void isCompleteChanged();
    void completeDateChanged();
    void contentsChanged();

private:
    int m_prizeNo;
    QString m_title;
    int m_cash;
    QString m_imageUrl;
    QString m_startDate;
    QString m_endDate;
    int m_isComplete = 0;
    QString m_completeDate;
    QString m_contents;
};


class Category: public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(bool selected READ selected WRITE select NOTIFY selectedChanged)

public:
    Category() {}
    Category(int id, QString name) : m_id(id), m_name(name) {}
    Category(int id, QString name, bool selected) : m_id(id), m_name(name), m_selected(selected) {}

    Q_INVOKABLE int id() const { return m_id; }
    Q_INVOKABLE QString name() const { return m_name; }
    Q_INVOKABLE bool selected() const { return m_selected;}

signals:
    void idChanged();
    void nameChanged();
    void selectedChanged();

public slots:
    void setId(int m) { m_id = m; emit idChanged();}
    void setName(QString m) { m_name = m; emit nameChanged();}
    void select(bool m) {m_selected = m; emit selectedChanged();}

private:
    int m_id;
    QString m_name;
    bool m_selected = false;

};

class Color: public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(QString code READ code WRITE setCode NOTIFY codeChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString desc READ desc WRITE setDesc NOTIFY descChanged)

public:
    Color() {}
    Color(int id, QString code, QString name, QString desc) : m_code(code), m_id(id), m_name(name), m_desc(desc) {}

    Q_INVOKABLE int id() const { return m_id; }
    Q_INVOKABLE QString code() const { return m_code; }
    Q_INVOKABLE QString name() const { return m_name; }
    Q_INVOKABLE QString desc() const { return m_desc; }

signals:
    void idChanged();
    void nameChanged();
    void codeChanged();
    void descChanged();

public slots:
    void setId(int m) { m_id = m; }
    void setCode(QString m) { m_code = m; emit idChanged();}
    void setName(QString m) { m_name = m; emit nameChanged();}
    void setDesc(QString m) { m_desc = m; emit descChanged();}

private:
    int m_id;
    QString m_code;
    QString m_name;
    QString m_desc;
};

class Dummy : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int           id READ id           WRITE setId           NOTIFY idChanged)
    Q_PROPERTY(int       parent READ parent       WRITE setParent       NOTIFY parentChanged)
    Q_PROPERTY(QString contents READ contents     WRITE setContents     NOTIFY contentsChanged)
    Q_PROPERTY(QString    title READ title        WRITE setTitle        NOTIFY titleChanged)
    Q_PROPERTY(QString   imgUrl READ imgUrl       WRITE setImgUrl       NOTIFY imgUrlChanged)
    Q_PROPERTY(QString   date READ date       WRITE setDate       NOTIFY dateChanged)
    Q_PROPERTY(int   category READ category       WRITE setCategory  NOTIFY categoryChanged)
    Q_PROPERTY(int   type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(int   order READ order WRITE setOrder NOTIFY orderChanged)
    Q_PROPERTY(int    viewCount READ viewCount    WRITE setViewCount    NOTIFY viewCountChanged)
    Q_PROPERTY(int    likeCount READ likeCount    WRITE setLikeCount    NOTIFY likeCountChanged)
    Q_PROPERTY(bool      myLike READ myLike       WRITE isMyLike        NOTIFY myLikeChanged)
    Q_PROPERTY(int commentCount READ commentCount WRITE setCommentCount NOTIFY commentCountChanged)
    Q_PROPERTY(bool   myComment READ myComment    WRITE isMyComment     NOTIFY myCommentChanged)
    Q_PROPERTY(bool   clicked   READ clicked      WRITE isClicked       NOTIFY clickedChanged)
    Q_PROPERTY(bool   selected  READ selected     WRITE select          NOTIFY selectedChanged)
    Q_PROPERTY(QString bgColor  READ bgColor      WRITE setBgColor      NOTIFY bgColorChanged)
    Q_PROPERTY(int    progress  READ progress     WRITE setProgress    NOTIFY progressChanged)


public:
    Dummy() {}
    Dummy(int id, QString contents, QString title, QString imgUrl, QString date, int category, int viewCount, int likeCount, bool myLike, int commentCount, bool myComment)
        : m_id(id), m_contents(m_contents), m_title(title), m_imgUrl(imgUrl), m_date(date), m_category(category), m_viewCount(viewCount), m_likeCount(likeCount), m_myLike(myLike), m_commentCount(commentCount), m_myComment(myComment)
    {

    }

    Q_INVOKABLE int id()            const { return m_id;           }
    Q_INVOKABLE int parent()        const { return m_parent;  }
    Q_INVOKABLE QString contents()  const { return m_contents;     }
    Q_INVOKABLE QString title()     const { return m_title;        }
    Q_INVOKABLE QString imgUrl()    const { return m_imgUrl;       }
    Q_INVOKABLE int viewCount()     const { return m_viewCount;    }
    Q_INVOKABLE int type()     const { return m_type;    }
    Q_INVOKABLE int order()     const { return m_order;    }
    Q_INVOKABLE int likeCount()     const { return m_likeCount;    }
    Q_INVOKABLE bool myLike()       const { return m_myLike;       }
    Q_INVOKABLE int commentCount()  const { return m_commentCount; }
    Q_INVOKABLE bool myComment()    const { return m_myComment;    }
    Q_INVOKABLE bool clicked()    const { return m_clicked;    }
    Q_INVOKABLE QString bgColor() const { return m_bgColor; }
    Q_INVOKABLE QString date() const { return m_date; }
    Q_INVOKABLE int category() const { return m_category; }
    Q_INVOKABLE int progress() const { return m_progress; }
    Q_INVOKABLE bool selected() const { return m_selected; }


public slots:
    void setId(int m)            { m_id = m; emit idChanged();}
    void setParent(int m)       { m_parent = m; emit parentChanged();}
    void setContents(QString m) { m_contents = m; emit contents();}
    void setTitle(QString m)    { m_title = m; emit titleChanged();}
    void setImgUrl(QString m)   { m_imgUrl = m; emit imgUrlChanged();}
    void setType(int m)     { m_type = m; emit typeChanged();}
    void setOrder(int m)     { m_order = m; emit orderChanged();}
    void setViewCount(int m)     { m_viewCount = m; emit viewCountChanged();}
    void setLikeCount(int m)     { m_likeCount = m; emit likeCountChanged();}
    void isMyLike(bool m)        { m_myLike = m; emit myLikeChanged();}
    void setCommentCount(int m)  { m_commentCount = m; emit commentCountChanged();}
    void isMyComment(bool m)     { m_myComment = m; emit myCommentChanged();}
    void isClicked(bool m)       { m_clicked = m; emit clickedChanged();}
    void setBgColor(QString m)  {m_bgColor = m; emit bgColorChanged();}
    void setDate(QString m) {m_date = m; emit dateChanged();}
    void setCategory(int m) {m_category = m; emit categoryChanged();}
    void setProgress(int m) {m_progress = m; emit progressChanged();}
    void select(bool m) { m_selected = m; emit selectedChanged(); }

signals:
    void idChanged();
    void parentChanged();
    void contentsChanged();
    void titleChanged();
    void imgUrlChanged();
    void viewCountChanged();
    void likeCountChanged();
    void myLikeChanged();
    void commentCountChanged();
    void myCommentChanged();
    void clickedChanged();
    void bgColorChanged();
    void categoryChanged();
    void dateChanged();
    void typeChanged();
    void orderChanged();
    void progressChanged();
    void selectedChanged();

private:
    int m_id = 0;
    int m_parent = 0;
    QString m_contents;
    QString m_title;
    QString m_imgUrl;
    int m_viewCount = 0;
    int m_likeCount = 0;
    bool m_myLike = false;
    int m_commentCount = 0;
    bool m_myComment = false;
    bool m_clicked = false;
    QString m_bgColor = "transparent";
    QString m_date;
    int m_category = 0;
    int m_type = 0;
    int m_order = 0;
    int m_progress = 0;
    bool m_selected = false;
};

class Tab : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int                id READ id          WRITE setId          NOTIFY idChanged)
    Q_PROPERTY(QString         title READ title       WRITE setTitle       NOTIFY titleChanged)
    Q_PROPERTY(QString    pressedImg READ pressedImg  WRITE setPressedImg  NOTIFY pressedImgChanged)
    Q_PROPERTY(QString   releasedImg READ releasedImg WRITE setReleasedImg NOTIFY releasedImgChanged)
    Q_PROPERTY(QString    pressedColor READ pressedColor  WRITE setPressedColor  NOTIFY pressedColorChanged)
    Q_PROPERTY(QString   releasedColor READ releasedColor WRITE setReleasedColor NOTIFY releasedColorChanged)
    Q_PROPERTY(bool         selected READ selected    WRITE select         NOTIFY selectedChanged)

public:
    Tab(int id, QString title, QString pressedImg, QString releasedImg, QString pressedColor, QString releasedColor, bool selected)
        : m_id(id), m_title(title), m_pressedImg(pressedImg), m_releasedImg(releasedImg), m_selected(selected), m_pressedColor(pressedColor), m_releasedColor(releasedColor) {}

    Q_INVOKABLE int id()            const { return m_id;           }
    Q_INVOKABLE QString title()     const { return m_title;        }
    Q_INVOKABLE QString pressedImg()    const { return m_pressedImg;       }
    Q_INVOKABLE QString releasedImg()    const { return m_releasedImg;       }
    Q_INVOKABLE QString pressedColor()    const { return m_pressedColor;       }
    Q_INVOKABLE QString releasedColor()    const { return m_releasedColor;       }
    Q_INVOKABLE bool selected()       const { return m_selected;       }

public slots:
    void setId(int m)            { m_id = m; emit idChanged();}
    void setTitle(QString m)    { m_title = m; emit titleChanged();}
    void setPressedImg(QString m)   { m_pressedImg = m; emit pressedImgChanged();}
    void setReleasedImg(QString m)   { m_releasedImg = m; emit releasedImgChanged();}
    void setPressedColor(QString m)   { m_pressedColor = m; emit pressedColorChanged();}
    void setReleasedColor(QString m)   { m_releasedColor = m; emit releasedColorChanged();}
    void select(bool m)        { m_selected = m; emit selectedChanged();}

signals:
    void idChanged();
    void titleChanged();
    void pressedImgChanged();
    void releasedImgChanged();
    void selectedChanged();
    void pressedColorChanged();
    void releasedColorChanged();

private:
    int m_id = 0;
    QString m_title;
    QString m_pressedImg;
    QString m_releasedImg;
    QString m_pressedColor;
    QString m_releasedColor;
    bool m_selected = false;
};

class AlarmPopup : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString message READ message WRITE setMessage NOTIFY messageChanged)
    Q_PROPERTY(bool yes READ yes WRITE setYes NOTIFY yesChanged)
    Q_PROPERTY(bool no READ no WRITE setNo NOTIFY noChanged)
    Q_PROPERTY(bool visible READ visible WRITE setVisible NOTIFY visibleChanged)
    Q_PROPERTY(int buttonCount READ buttonCount WRITE setButtonCount NOTIFY buttonCountChanged)
    Q_PROPERTY(QString yButtonName READ yButtonName WRITE setYButtonName NOTIFY yButtonNameChanged)
    Q_PROPERTY(QString nButtonName READ nButtonName WRITE setNButtonName NOTIFY nButtonNameChanged)

public:
    static AlarmPopup* getInstance() {
        if (m_instance == nullptr)
            m_instance = new AlarmPopup();
        return m_instance;
    }
    Q_INVOKABLE bool yes() { return m_yes; }
    Q_INVOKABLE bool no() { return m_no; }
    Q_INVOKABLE bool visible() { return m_visible; }
    Q_INVOKABLE int buttonCount() { return m_buttonCount; }
    Q_INVOKABLE QString message() { return m_message; }
    Q_INVOKABLE QString yButtonName() { return m_yButtonName; }
    Q_INVOKABLE QString nButtonName() { return m_nButtonName; }
    Q_INVOKABLE void setYMethod(QObject* obj, QString method)
    {
        m_methodObj = obj;
        m_yMethodName = method;
    }
    Q_INVOKABLE void setNMethod(QObject* obj, QString method)
    {
        m_methodObj = obj;
        m_nMethodName = method;
    }

public slots:
    void setMessage(QString m) { m_message = m; emit messageChanged(); }
    void setYes(bool m) { m_yes = m; emit yesChanged(); }
    void setNo(bool m) { m_no = m; emit noChanged(); }
    void setVisible(bool m) { m_visible = m; emit visibleChanged(); }
    void setButtonCount(int m) { m_buttonCount = m; emit buttonCountChanged(); }
    void invokeYMethod() { QMetaObject::invokeMethod(m_methodObj, m_yMethodName.toLatin1().constData()); }
    void invokeNMethod() { QMetaObject::invokeMethod(m_methodObj, m_nMethodName.toLatin1().constData()); }
    void setYButtonName(QString m) { m_yButtonName = m; emit yButtonNameChanged(); }
    void setNButtonName(QString m) { m_nButtonName = m; emit nButtonNameChanged(); }

signals:
    void messageChanged();
    void yesChanged();
    void noChanged();
    void visibleChanged();
    void buttonCountChanged();
    void yButtonNameChanged();
    void nButtonNameChanged();

private:
    static AlarmPopup* m_instance;
    AlarmPopup(){}
    QString m_message = "";
    bool m_yes = false;
    bool m_no = false;
    bool m_visible = false;
    int m_buttonCount = 2;
    QObject* m_methodObj;
    QString m_yMethodName;
    QString m_nMethodName;
    QString m_yButtonName;// = "예";
    QString m_nButtonName;// = "아니오";
};

class Notification : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int no READ no WRITE setNo NOTIFY noChanged)
    Q_PROPERTY(int type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(int itemNo1 READ itemNo1 WRITE setItemNo1 NOTIFY itemNo1Changed)
    Q_PROPERTY(int itemNo2 READ itemNo2 WRITE setItemNo2 NOTIFY itemNo2Changed)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QString message READ message WRITE setMessage NOTIFY messageChanged)
    Q_PROPERTY(bool isRead READ isRead WRITE setIsRead NOTIFY isReadChanged)
    Q_PROPERTY(bool folded READ folded WRITE fold NOTIFY foldedChanged)
    Q_PROPERTY(QString dateTime READ dateTime WRITE setDateTime NOTIFY dateTimeChanged)

public:
    Notification() {}
    Notification(int type, QString title, QString message, bool isRead, QString dateTime)
        : m_type(type), m_title(title), m_message(message), m_isRead(isRead), m_dateTime(dateTime)
    {}
    Notification(int no, int type, QString message, bool isRead, QString dateTime)
        : m_no(no), m_type(type), m_message(message), m_isRead(isRead), m_dateTime(dateTime)
    {                                                                                  }
    Notification(int no, int type, QString title, QString message, bool isRead, QString dateTime)
        : m_no(no), m_type(type), m_title(title), m_message(message), m_isRead(isRead), m_dateTime(dateTime)
    {                                                                                  }
    Notification(int type, QString message, int itemNo1, int itemNo2, bool isRead, QString dateTime)
        : m_type(type), m_message(message), m_itemNo1(itemNo1), m_itemNo2(itemNo2), m_isRead(isRead), m_dateTime(dateTime)
    {                                                                                  }

    Q_INVOKABLE int no() { return m_no; }
    Q_INVOKABLE int type() { return m_type; }
    Q_INVOKABLE bool isRead() { return m_isRead; }
    Q_INVOKABLE bool folded() { return m_folded; }
    Q_INVOKABLE QString title() { return m_title; }
    Q_INVOKABLE QString message() { return m_message; }
    Q_INVOKABLE QString dateTime() { return m_dateTime; }
    Q_INVOKABLE int itemNo1() { return m_itemNo1; }
    Q_INVOKABLE int itemNo2() { return m_itemNo2; }

public slots:
    void setNo(int m) { m_no = m; emit noChanged();}
    void setType(int m) { m_type = m; emit typeChanged();}
    void setIsRead(bool m) { m_isRead = m; emit isReadChanged(); }
    void setTitle(QString m) { m_title = m; emit titleChanged(); }
    void setMessage(QString m) { m_message = m; emit messageChanged(); }
    void setDateTime(QString m) { m_dateTime = m; emit dateTimeChanged(); }
    void fold(bool m) { m_folded = m; emit foldedChanged(); }
    void setItemNo1(int m) { m_itemNo1 = m; emit itemNo1Changed(); }
    void setItemNo2(int m) { m_itemNo2 = m; emit itemNo2Changed(); }

signals:
    void noChanged();
    void typeChanged();
    void isReadChanged();
    void titleChanged();
    void messageChanged();
    void dateTimeChanged();
    void foldedChanged();
    void itemNo1Changed();
    void itemNo2Changed();

private:
    QString m_message = "";
    QString m_title = "";
    QString m_dateTime;
    bool m_isRead = false;
    int m_no = 0;
    int m_type = 0;
    int m_itemNo1 = 0;
    int m_itemNo2 = 0;
    bool m_folded = true;
};

class Course : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QString desc READ desc WRITE setDesc NOTIFY descChanged)
    Q_PROPERTY(QString thumbnailUrl READ thumbnailUrl WRITE setThumbnailUrl NOTIFY thumbnailUrlChanged)

public:
    Course() {}
    Course(int id, QString title, QString thumbnailUrl, QString desc)
        : m_id(id), m_title(title), m_thumbnailUrl(thumbnailUrl), m_desc(desc)
    {                                                                                  }

    Q_INVOKABLE int id() { return m_id; }
    Q_INVOKABLE QString title() { return m_title; }
    Q_INVOKABLE QString desc() { return m_desc; }
    Q_INVOKABLE QString thumbnailUrl() { return m_thumbnailUrl; }

public slots:
    void setId(int m) { m_id = m; emit idChanged();}
    void setTitle(QString m) { m_title = m; emit titleChanged(); }
    void setDesc(QString m) { m_desc = m; emit descChanged(); }
    void setThumbnailUrl(QString m) { m_thumbnailUrl = m; emit thumbnailUrlChanged(); }

signals:
    void idChanged();
    void titleChanged();
    void thumbnailUrlChanged();
    void descChanged();

private:
    QString m_thumbnailUrl = "";
    QString m_title = "";
    QString m_desc = "";
    int m_id = 0;
};

class ClipViewer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool runningDataGetter READ runningDataGetter WRITE setRunningDataGetter NOTIFY runningDataGetterChanged)
    Q_PROPERTY(bool refreshWebView READ refreshWebView WRITE setRefreshWebView NOTIFY refreshWebViewChanged)
    Q_PROPERTY(bool loadRefreshedWebView READ loadRefreshedWebView WRITE setLoadRefreshedWebView NOTIFY loadRefreshedWebViewChanged)
public:
    Q_INVOKABLE bool runningDataGetter() { return m_runningDataGetter; }
    Q_INVOKABLE bool refreshWebView() { return m_refreshWebView; }
    Q_INVOKABLE bool loadRefreshedWebView() { return m_loadRefreshedWebView; }
public slots:
    void setRunningDataGetter(bool m) { m_runningDataGetter = m; emit runningDataGetterChanged(); }
    void setRefreshWebView(bool m) { m_refreshWebView = m; emit refreshWebViewChanged(); }
    void setLoadRefreshedWebView(bool m) { m_loadRefreshedWebView = m; emit loadRefreshedWebViewChanged(); }
signals:
    void runningDataGetterChanged();
    void refreshWebViewChanged();
    void loadRefreshedWebViewChanged();
private:
    bool m_runningDataGetter = false;
    bool m_refreshWebView = false;
    bool m_loadRefreshedWebView = false;
};

class Model : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool initializedSystem READ initializedSystem WRITE initializeSystem NOTIFY initializedSystemChanged)
    Q_PROPERTY(bool unvisibleWebView READ unvisibleWebView WRITE setUnvisibleWebView NOTIFY unvisibleWebViewChanged)
    Q_PROPERTY(bool useDummy READ useDummy WRITE setUseDummy NOTIFY useDummyChanged)
    Q_PROPERTY(bool blockedDrawer READ blockedDrawer WRITE setBlockedDrawer NOTIFY blockedDrawerChanged)
    Q_PROPERTY(bool openedDrawer READ openedDrawer WRITE setOpenedDrawer NOTIFY openedDrawerChanged)
    Q_PROPERTY(bool fullScreen READ fullScreen WRITE setFullScreen NOTIFY fullScreenChanged)
    Q_PROPERTY(bool showIndicator READ showIndicator WRITE setShowIndicator NOTIFY showIndicatorChanged)
    Q_PROPERTY(bool clicked READ clicked WRITE click NOTIFY clickedChanged)
    Q_PROPERTY(bool checkedClause1 READ checkedClause1 WRITE setCheckedClause1 NOTIFY checkedClause1Changed)
    Q_PROPERTY(bool checkedClause2 READ checkedClause2 WRITE setCheckedClause2 NOTIFY checkedClause2Changed)
    Q_PROPERTY(bool checkedClause3 READ checkedClause3 WRITE setCheckedClause3 NOTIFY checkedClause3Changed)
    Q_PROPERTY(bool checkedClause4 READ checkedClause4 WRITE setCheckedClause4 NOTIFY checkedClause4Changed)
    Q_PROPERTY(bool needUpdateApp READ needUpdateApp WRITE setNeedUpdateApp NOTIFY needUpdateAppChanged)
    Q_PROPERTY(bool needUpdateOS READ needUpdateOS WRITE setNeedUpdateOS NOTIFY needUpdateOSChanged)
    Q_PROPERTY(bool runningTimeCounter READ runningTimeCounter WRITE setRunningTimeCounter NOTIFY runningTimeCounterChanged)
    Q_PROPERTY(bool forcedPortrait READ forcedPortrait WRITE forcePortrait NOTIFY forcedPortraitChanged)
    Q_PROPERTY(bool showedMyPage READ showedMyPage WRITE showMyPage NOTIFY showedMyPageChanged)
    Q_PROPERTY(bool popMyPage READ popMyPage WRITE setPopMyPage NOTIFY popMyPageChanged)
    Q_PROPERTY(bool newAlarm READ newAlarm WRITE setNewAlarm NOTIFY newAlarmChanged)
    Q_PROPERTY(bool viewOption READ viewOption WRITE setViewOption)
    Q_PROPERTY(bool forcedExit READ forcedExit  WRITE forceExit NOTIFY forcedExitChanged)
    Q_PROPERTY(bool showedCommentViewer READ showedCommentViewer WRITE showCommentViewer NOTIFY showedCommentViewerChanged)

    Q_PROPERTY(int messageInt READ messageInt WRITE setMessageInt NOTIFY messageIntChanged)
    Q_PROPERTY(int homeCateAreaWidth READ homeCateAreaWidth WRITE setHomeCateAreaWidth NOTIFY homeCateAreaWidthChanged)
    Q_PROPERTY(int myloginType READ myloginType WRITE setMyLoginType NOTIFY myloginTypeChanged)
    Q_PROPERTY(int checkedSystem READ checkedSystem WRITE setCheckedSystem NOTIFY checkedSystemChanged)
    Q_PROPERTY(int certificated READ certificated WRITE setCertificated NOTIFY certificatedChanged)
    Q_PROPERTY(int duplicated READ duplicated WRITE setDuplicated NOTIFY duplicatedChanged)
    Q_PROPERTY(int totalLogCount READ totalLogCount WRITE setTotalLogCount NOTIFY totalLogCountChanged) //2-12.
    Q_PROPERTY(int totalNoticeCount READ totalNoticeCount WRITE setTotalNoticeCount NOTIFY totalNoticeCountChanged)
    Q_PROPERTY(int bannerCount READ bannerCount WRITE setBannerCount NOTIFY bannerCountChanged)
    Q_PROPERTY(int totalCourseCount READ totalCourseCount WRITE setTotalCourseCount NOTIFY totalCourseCountChanged)
    Q_PROPERTY(int totalSearchCount READ totalSearchCount WRITE setTotalSearchCount NOTIFY totalSearchCountChanged)
    Q_PROPERTY(int totalClipCount READ totalClipCount WRITE setTotalClipCount NOTIFY totalClipCountChanged)
    Q_PROPERTY(int totalRepleCount READ totalRepleCount WRITE setTotalRepleCount NOTIFY totalRepleCountChanged)
    Q_PROPERTY(int snsLoginResult READ snsLoginResult WRITE setSnsLoginResult NOTIFY snsLoginResultChanged)
    Q_PROPERTY(int currentCourseNo READ currentCourseNo WRITE setCurrentCourseNo NOTIFY currentCourseNoChanged)
    Q_PROPERTY(int currentClipNo READ currentClipNo WRITE setCurrentClipNo NOTIFY currentClipNoChanged)
    Q_PROPERTY(int currentBoardNo READ currentBoardNo WRITE setCurrentBoardNo NOTIFY currentBoardNoChanged)
    Q_PROPERTY(int currentBoardArticleNo READ currentBoardArticleNo WRITE setCurrentBoardArticleNo NOTIFY currentBoardArticleNoChanged)
    Q_PROPERTY(int currentTableRecordNo READ currentTableRecordNo WRITE setCurrentTableRecordNo NOTIFY currentTableRecordNoChanged)
    Q_PROPERTY(int deliveryFlag READ deliveryFlag WRITE setDeliveryFlag NOTIFY deliveryFlagChanged)
    Q_PROPERTY(int myTotalPointCount READ myTotalPointCount WRITE setMyTotalPointCount NOTIFY myTotalPointCountChanged)
    Q_PROPERTY(int myTotalHavePoint READ myTotalHavePoint WRITE setMyTotalHavePoint NOTIFY myTotalHavePointChanged)
    Q_PROPERTY(int myTotalSumPoint READ myTotalSumPoint WRITE setMyTotalSumPoint NOTIFY myTotalSumPointChanged)
    Q_PROPERTY(int CRUDHandlerType READ CRUDHandlerType WRITE setCRUDHandlerType NOTIFY CRUDHandlerTypeChanged)
    Q_PROPERTY(int delivered READ delivered WRITE deliver NOTIFY deliveredChanged)
    Q_PROPERTY(int totalAlarmCount READ totalAlarmCount WRITE setTotalAlarmCount NOTIFY totalAlarmCountChanged)
    Q_PROPERTY(int nativeChanner READ nativeChanner WRITE setNativeChanner NOTIFY nativeChannerChanged)
    Q_PROPERTY(int requestNativeBackBehavior READ requestNativeBackBehavior WRITE setRequestNativeBackBehavior NOTIFY requestNativeBackBehaviorChanged)
    Q_PROPERTY(int videoStatus READ videoStatus WRITE setVideoStatus NOTIFY videoStatusChanged)

    Q_PROPERTY(QString error READ error WRITE setError NOTIFY errorChanged)
    Q_PROPERTY(AlarmPopup* alarm READ alarm WRITE setAlarm NOTIFY alarmChanged)
    Q_PROPERTY(QList<QObject*> categorylist READ categorylist NOTIFY categorylistChanged)

    Q_PROPERTY(QList<QObject*> list READ list NOTIFY listChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)

    Q_PROPERTY(QList<QObject*> dlist READ dlist NOTIFY dlistChanged)
    Q_PROPERTY(QList<QObject*> pagerlist READ pagerlist NOTIFY pagerlistChanged)
    Q_PROPERTY(QList<QObject*> tablist READ tablist  NOTIFY tablistChanged)
    Q_PROPERTY(QList<QObject*> imglist READ imglist NOTIFY imglistChanged)

    Q_PROPERTY(QList<QObject*> colorlist READ colorlist NOTIFY colorlistChanged)
    Q_PROPERTY(QList<QObject*> catelikelist READ catelikelist NOTIFY catelikelistChanged)
    Q_PROPERTY(QList<QObject*> catemyactylist READ catemyactylist NOTIFY catemyactylistChanged)
    Q_PROPERTY(QList<QObject*> catemysavelist READ catemysavelist NOTIFY catemysavelistChanged)

    Q_PROPERTY(QList<QObject*> homelist READ homelist NOTIFY homelistChanged)

    Q_PROPERTY(QString myimage READ myimage WRITE setMyImage NOTIFY myimageChanged)
    Q_PROPERTY(QString myname READ myname WRITE setMyName NOTIFY mynameChanged)
    Q_PROPERTY(QString myemail READ myemail WRITE setMyEmail NOTIFY myemailChanged)
    Q_PROPERTY(QList<QObject*> mycourselist READ mycourselist NOTIFY mycourselistChanged)  // depre.

    Q_PROPERTY(QDateTime startedSecTime READ startedSecTime NOTIFY startedSecTimeChanged)
    Q_PROPERTY(QString leftTime READ leftTime WRITE setLeftTime NOTIFY leftTimeChanged)

    Q_PROPERTY(QString messageStr READ messageStr WRITE setMessageStr NOTIFY messageStrChanged)


    //1-7. 로그인 //3-23. 다른 사용자 프로필보기
    Q_PROPERTY(User* user READ user WRITE setUser NOTIFY userChanged)

    //2-7. 마이페이지 탭 메인화면(나의수강강좌)
    Q_PROPERTY(QList<QObject*> myCourseList READ myCourseList WRITE setMyCourseList NOTIFY myCourseListChanged)
    Q_PROPERTY(QList<QObject*> completeCourseList READ completeCourseList WRITE setCompleteCourseList NOTIFY completeCourseListChanged) // depre.

    //2-8. 마이페이지 탭 메인화면(나의최근활동)

    Q_PROPERTY(QList<QObject*> recentLogList READ recentLogList WRITE setRecentLogList NOTIFY recentLogListChanged) /* Added By JHKim, When 2018.06.17. */

    //2-12. 2-13. 시스템 공지사항/질의사항 리스트보기, 상세보기

    Q_PROPERTY(QList<QObject*> noticeList READ noticeList WRITE setNoticeList NOTIFY noticeListChanged)
    Q_PROPERTY(QList<QObject*> noticeTopList READ noticeTopList WRITE setNoticeTopList NOTIFY noticeTopListChanged) /* Added By JHKim, When 2018.06.20. */
    Q_PROPERTY(Univ* noticeDetail READ noticeDetail WRITE setNoticeDetail NOTIFY noticeDetailChanged) /* Added By JHKim, When 2018.06.17. */

    //3-1. 홈 메인화면(과목리스트받아오기)
    Q_PROPERTY(QList<QObject*> bannerList READ bannerList WRITE setBannerList NOTIFY bannerListChanged) /* Added By JHKim, When 2018.06.17. */

    Q_PROPERTY(Univ* courseDetail READ courseDetail WRITE setCourseDetail NOTIFY courseDetailChanged) /* Added By JHKim, When 2018.06.17. */

    //3-2. 과목 상세보기(해당과목과 연결된 게시판)
    Q_PROPERTY(QList<QObject*> boardList READ boardList WRITE setBoardList NOTIFY boardListChanged)

    //3-12. delivery_flag만 따로
    Q_PROPERTY(QList<QObject*> clipList READ clipList WRITE setClipList NOTIFY clipListChanged)


    //3-13. 클립상세보기(학습페이지)

    /* Commented By JHKim, When 2018.06.17. */
    //    Q_PROPERTY(QString clipurl READ url WRITE setUrl NOTIFY urlChanged)
    //    Q_PROPERTY(int repleCount READ repleCount WRITE setRepleCount NOTIFY repleCountChanged)
    /* Added By JHKim, When 2018.06.17. */
    Q_PROPERTY(Univ* clipDetail READ clipDetail WRITE setClipDetail NOTIFY clipDetailChanged)
    Q_PROPERTY(QList<QObject*> quizList READ quizList WRITE setQuizList NOTIFY quizListChanged)

    //3-15. 해당클립공유하기
    Q_PROPERTY(QString clipHttpUrl READ clipHttpUrl WRITE setClipHttpUrl NOTIFY clipHttpUrlChanged)

    //3-17. 클립 댓글 리스트 불러오기
    Q_PROPERTY(QList<QObject*> repleList READ repleList WRITE setRepleList NOTIFY repleListChanged)

    //4-1. 검색 탭 메인화면

    Q_PROPERTY(QList<QObject*> searchLogList READ searchLogList WRITE setSearchLogList NOTIFY searchLogListChanged)
    Q_PROPERTY(QList<QObject*> searchCourseList READ searchCourseList WRITE setSearchCourseList NOTIFY searchCourseListChanged)
    Q_PROPERTY(QList<QObject*> searchClipList READ searchClipList WRITE setSearchClipList NOTIFY searchClipListChanged)

    //5-1. 좋아요 탭 메인화면-클립

    Q_PROPERTY(QList<QObject*> likeClipList READ likeClipList WRITE setLikeClipList NOTIFY likeClipListChanged)
    Q_PROPERTY(QList<QObject*> likeRepleList READ likeRepleList WRITE setLikeRepleList NOTIFY likeRepleListChanged)

    //6-1. 랭킹 탭 메인화면
    Q_PROPERTY(Rank* myRank READ myRank WRITE setMyRank NOTIFY myRankChanged)
    Q_PROPERTY(QList<QObject*> rankList READ rankList WRITE setRankList NOTIFY rankListChanged)

    //6-2. 적립내역 상세보기
    Q_PROPERTY(QList<QObject*> pointSaveList READ pointSaveList WRITE setPointSaveList NOTIFY pointSaveListChanged)

    //6-3. 소비내역 상세보기
    Q_PROPERTY(QList<QObject*> pointSpendList READ pointSpendList WRITE setPointSpendList NOTIFY pointSpendListChanged)

    //6-4. 이벤트 내용 리스트 보기
    Q_PROPERTY(QList<QObject*> eventList READ eventList WRITE setEventList NOTIFY eventListChanged)

    //6-5. 이벤트 내용 상세 보기
    Q_PROPERTY(Event* eventDetail READ eventDetail WRITE setEventDetail NOTIFY eventDetailChanged)



    Q_PROPERTY(QList<QObject*> fileStorage READ fileStorage WRITE setFileStorage NOTIFY fileStorageChanged)
    Q_PROPERTY(QList<QObject*> removedFileStorage READ removedFileStorage WRITE setRemovedFileStorage NOTIFY removedFileStorageChanged)



    Q_PROPERTY(QList<QObject*> alarmList READ alarmList WRITE setAlarmList NOTIFY alarmListChanged)

    Q_PROPERTY(Univ* noticePopup READ noticePopup)
    Q_PROPERTY(QList<QObject*> helpList READ helpList WRITE setHelpList NOTIFY helpListChanged)

    Q_PROPERTY(QList<QString> ampm READ ampm)
    Q_PROPERTY(bool secured READ secured WRITE secure NOTIFY securedChanged)

    Q_PROPERTY(bool requestedShrinkVideo READ requestedShrinkVideo WRITE requestShrinkVideo NOTIFY requestedShrinkVideoChanged)
    Q_PROPERTY(bool cantLoadContent READ cantLoadContent WRITE setCantLoadContent NOTIFY cantLoadContentChanged)


public:
    static Model* getInstance() {
        if (m_instance == nullptr)
            m_instance = new Model();
        return m_instance;
    }

    Q_INVOKABLE QString error() const { return m_error; }
    Q_INVOKABLE AlarmPopup* alarm() const { return m_alarm; }

    Q_INVOKABLE bool initializedSystem() const { return m_initializedSystem; }
    Q_INVOKABLE bool unvisibleWebView() const { return m_unvisibleWebView; }
    Q_INVOKABLE bool useDummy() const { return m_useDummy; }

    /* SYSTEM INFO */
    Q_INVOKABLE QList<QObject*> categorylist() const { return m_categorylist; }
    Q_INVOKABLE QList<QObject*> list() const { return m_list; }
    Q_INVOKABLE QString title() const { return m_title; }

    Q_INVOKABLE bool blockedDrawer()  const { return m_blockedDrawer; }
    Q_INVOKABLE bool openedDrawer()  const { return m_openedDrawer; }

    Q_INVOKABLE bool fullScreen()  const { return m_fullScreen; }
    Q_INVOKABLE bool showIndicator() const { return m_showIndicator; }
    Q_INVOKABLE QList<QObject*> dlist() const { return m_dlist; }
    Q_INVOKABLE QList<QObject*> pagerlist() const { return m_pagerlist; }
    Q_INVOKABLE QList<QObject*> tablist() const { return m_tablist; }

    Q_INVOKABLE QList<QObject*> catelikelist() const { return m_catelikelist; }
    Q_INVOKABLE QList<QObject*> catemyactylist() const { return m_catemyactylist; }
    Q_INVOKABLE QList<QObject*> catemysavelist() const { return m_catemysavelist; }
    Q_INVOKABLE QList<QObject*> colorlist() const { return m_colorlist; }
    Q_INVOKABLE QList<QObject*> imglist() const { return m_imglist; }
    //Q_INVOKABLE QList<QObject*> likeClipList() const { return m_likeClipList; }
    Q_INVOKABLE QList<QObject*> homelist() const { return m_homelist; }
    //Q_INVOKABLE QList<QObject*> clipList() const { return m_clipList; }
    Q_INVOKABLE int messageInt() { int temp = m_messageInt; m_messageInt = -1; return temp; }
    Q_INVOKABLE bool clicked() const { return m_clicked; }
    Q_INVOKABLE int homeCateAreaWidth() { return m_homeCateAreaWidth; }

    Q_INVOKABLE int myloginType() const { return m_myloginType; }
    Q_INVOKABLE QString myname() const { return m_myname; }
    Q_INVOKABLE QString myemail() const { return m_myemail; }
    Q_INVOKABLE QString myimage() const { return m_myimage; }
    Q_INVOKABLE QList<QObject*> mycourselist() const { return m_mycourselist; }

    Q_INVOKABLE bool checkedClause1() const { return m_checkedClause1; }
    Q_INVOKABLE bool checkedClause2() const { return m_checkedClause2; }
    Q_INVOKABLE bool checkedClause3() const { return m_checkedClause3; }
    Q_INVOKABLE bool checkedClause4() const { return m_checkedClause4; }
    Q_INVOKABLE int checkedSystem() const { return m_checkedSystem; }
    Q_INVOKABLE int certificated() const { return m_certificated; }
    Q_INVOKABLE int  duplicated() const { return m_duplicated; }
    Q_INVOKABLE bool needUpdateApp() const { return m_needUpdateApp; }
    Q_INVOKABLE bool needUpdateOS() const { return m_needUpdateOS; }

    Q_INVOKABLE bool runningTimeCounter() const { return m_runningTimeCounter; }
    Q_INVOKABLE QDateTime  startedSecTime() const { return m_startedSecTime; }
    Q_INVOKABLE QString leftTime() const { return m_leftTime; }

    Q_INVOKABLE QString messageStr() const { return m_messageStr; }

    //1-7. 로그인 //3-23. 다른 사용자 프로필보기
    Q_INVOKABLE User* user() const { return m_user; }

    //2-7. 마이페이지 탭 메인화면(나의수강강좌)-수강완료
    Q_INVOKABLE QList<QObject*> completeCourseList() const { return m_completeCourseList; }
    Q_INVOKABLE QList<QObject*> myCourseList() const { return m_myCourseList; }

    //2-8. 마이페이지 탭 메인화면(나의최근활동)
    Q_INVOKABLE int totalLogCount() const { return m_totalLogCount; } //2-12.
    Q_INVOKABLE QList<QObject*> recentLogList() const { return m_recentLogList; }

    //2-12. 2-13. 시스템 공지사항/질의사항 리스트보기, 상세보기
    Q_INVOKABLE int totalNoticeCount() const { return m_totalNoticeCount; }
    Q_INVOKABLE QList<QObject*> noticeList() const { return m_noticeList; }
    Q_INVOKABLE QList<QObject*> noticeTopList() const { return m_noticeTopList; } /* Added By JHKim, When 2018.06.20. */
    Q_INVOKABLE Univ* noticeDetail() const { return m_noticeDetail; } /* Added By JHKim, When 2018.06.17. */

    //3-1. 홈 메인화면(과목리스트받아오기)
    Q_INVOKABLE QList<QObject*> bannerList();
    Q_INVOKABLE int bannerCount() const { return m_bannerCount; }
    Q_INVOKABLE int totalCourseCount() const { return m_totalCourseCount; }
    Q_INVOKABLE Univ* courseDetail() { return m_courseDetail; }

    //3-2. 과목 상세보기(해당과목과 연결된 게시판)
    Q_INVOKABLE QList<QObject*> boardList() const { return m_boardList; }

    //3-12. delivery_flag만 따로
    Q_INVOKABLE QList<QObject*> clipList() const { return m_clipList; }

    //3-13. 클립상세보기(학습페이지)
    /* Commented By JHKim, When 2018.06.17. */
    //    Q_INVOKABLE QString url() const { return m_url; }
    //    Q_INVOKABLE int repleCount() const { return m_repleCount; }
    Q_INVOKABLE Univ* clipDetail() const { return m_clipDetail; }
    Q_INVOKABLE QList<QObject*> quizList() const { return m_quizList; }

    //3-15. 해당클립공유하기
    Q_INVOKABLE QString clipHttpUrl() const { return m_clipHttpUrl; }

    //3-17. 클립 댓글 리스트 불러오기
    Q_INVOKABLE QList<QObject*> repleList() const { return m_repleList; }

    //4-1. 검색 탭 메인화면
    Q_INVOKABLE int totalSearchCount() const { return m_totalSearchCount; }
    Q_INVOKABLE QList<QObject*> searchLogList() const { return m_searchLogList; }
    Q_INVOKABLE QList<QObject*> searchCourseList() const { return m_searchCourseList; }
    Q_INVOKABLE QList<QObject*> searchClipList() const { return m_searchClipList; }

    //5-1. 좋아요 탭 메인화면-클립
    Q_INVOKABLE int totalClipCount() const { return m_totalClipCount; }
    Q_INVOKABLE int totalRepleCount() const { return m_totalRepleCount; }
    Q_INVOKABLE QList<QObject*> likeClipList() const { return m_likeClipList; }
    Q_INVOKABLE QList<QObject*> likeRepleList() const { return m_likeRepleList; }

    //6-1. 랭킹 탭 메인화면
    Q_INVOKABLE QList<QObject*> rankList() const { return m_rankList; }
    Q_INVOKABLE Rank* myRank() const { return m_myRank; }

    //6-2. 적립내역 상세보기
    Q_INVOKABLE QList<QObject*> pointSaveList() const { return m_pointSaveList; }

    //6-3. 소비내역 상세보기
    Q_INVOKABLE QList<QObject*> pointSpendList() const { return m_pointSpendList; }

    //6-4. 이벤트 내용 리스트 보기
    Q_INVOKABLE QList<QObject*> eventList() const { return m_eventList; }

    //6-5. 이벤트 내용 상세 보기
    Q_INVOKABLE Event* eventDetail() const { return m_eventDetail; }

    Q_INVOKABLE int snsLoginResult() const { return m_snsLoginResult; }
    Q_INVOKABLE int currentCourseNo() const { return m_currentCourseNo; }
    Q_INVOKABLE int currentClipNo() const { return m_currentClipNo; }
    Q_INVOKABLE int currentBoardNo() const { return m_currentBoardNo; }
    Q_INVOKABLE int currentBoardArticleNo() const { return m_currentBoardArticleNo; }
    Q_INVOKABLE int currentTableRecordNo() const { return m_currentTableRecordNo; }

    Q_INVOKABLE int deliveryFlag() const { return m_deliveryFlag; } /* Added By JHKim, When 2018.06.20.*/

    Q_INVOKABLE int myTotalPointCount() const { return m_myTotalPointCount; }
    Q_INVOKABLE int myTotalHavePoint() const { return m_myTotalHavePoint; }
    Q_INVOKABLE int myTotalSumPoint() const { return m_myTotalSumPoint; }

    QList<QObject*> fileStorage() const { return m_fileStorage; }
    QList<QObject*> removedFileStorage() const { return m_removedFileStorage; }

    Q_INVOKABLE int CRUDHandlerType() const { return m_CRUDHandlerType; }

    Q_INVOKABLE int delivered() const { return m_delivered; }
    Q_INVOKABLE bool newAlarm() const { return m_newAlarm; }
    Q_INVOKABLE int totalAlarmCount() const { return m_totalAlarmCount; }
    Q_INVOKABLE QList<QObject*> alarmList() const { return m_alarmList; }

    Q_INVOKABLE Univ* noticePopup() const { return m_noticePopup; }
    Q_INVOKABLE QList<QObject*> helpList() const { return m_helpList; }

    Q_INVOKABLE QList<QString> ampm() const { return m_ampm; }
    Q_INVOKABLE bool viewOption() const { return m_viewOption; }

    Q_INVOKABLE int nativeChanner() { return m_nativeChanner; }
    Q_INVOKABLE int requestNativeBackBehavior() { return m_requestNativeBackBehavior; }

    Q_INVOKABLE bool forcedPortrait() { return m_forcedPortrait; }
    Q_INVOKABLE bool showedMyPage() { return m_showedMyPage; }
    Q_INVOKABLE bool popMyPage() { return m_popMyPage; }
    Q_INVOKABLE bool showedCommentViewer() { return m_showedCommentViewer; }

    Q_INVOKABLE int videoStatus() { return m_videoStatus; }
    Q_INVOKABLE bool forcedExit() { bool tmp = m_forcedExit; m_forcedExit = false; return tmp; }
    Q_INVOKABLE bool secured() { return m_secured; }

    Q_INVOKABLE bool requestedShrinkVideo() { return m_requestedShrinkVideo; }
    Q_INVOKABLE bool cantLoadContent() { return m_cantLoadContent; }


public slots:

    void initializeSystem(bool m) { m_initializedSystem = m; initializedSystemChanged(); }
    void setError(QString m) { m_error = m; emit errorChanged(); }
    void setAlarm(AlarmPopup* m) { m_alarm = m; emit alarmChanged(); }
    void setUnvisibleWebView(bool m) { m_unvisibleWebView = m; emit unvisibleWebViewChanged(); }
    void setUseDummy(bool m) { m_useDummy = m; emit useDummyChanged(); }
    void setCategoryList(QList<QObject*> m) { m_categorylist.clear(); m_categorylist = m; emit categorylistChanged(); }
    void setTitle(const QString m) { m_title = m; emit titleChanged(); }
    void setBlockedDrawer(const bool &m) { m_blockedDrawer = m; emit blockedDrawerChanged(); }
    void setOpenedDrawer(const bool &m) { m_openedDrawer = m; emit openedDrawerChanged(); }
    void setFullScreen(const bool &m) { m_fullScreen = m; emit fullScreenChanged(); }
    void setShowIndicator(const bool & m) { m_showIndicator = m; emit showIndicatorChanged(); }
    void addDummy(QObject* m) { m_dlist.append(m); emit dlistChanged();}
    void addPager(QObject* m) { m_pagerlist.append(m); emit pagerlistChanged(); }
    void addImage(QObject* m) { m_imglist.append(m); emit imglistChanged();}
    void addColor(QObject* m) { m_colorlist.append(m); emit colorlistChanged();}
    void addCategory(QObject* m) { m_categorylist.append(m); }
    void clearLikeClip() { m_likeClipList.clear(); }
    void setLikeDummy(int index) {

        Dummy* d = qobject_cast<Dummy*>(m_dlist[index]);
        bool like = d->myLike();
        d->isMyLike(like);

        if(like) d->setViewCount(d->viewCount() + 1);
        else d->setViewCount(d->viewCount() - 1);
    }
    void setLikeClip(int index) {
        Univ* d = qobject_cast<Univ*>(m_likeClipList[index]);
        bool like = d->like();
        d->setLike(like);

        if(like) d->setViewCount(d->viewCount() + 1);
        else d->setViewCount(d->viewCount() - 1);
    }
    void setMessageInt(int m) { m_messageInt = m; emit messageIntChanged(); }
    void setDummyList(QList<QObject*> m) { m_dlist.clear(); m_dlist = m; emit dlistChanged(); }
    void setPagerList(QList<QObject*> m) { m_pagerlist.clear(); m_pagerlist = m; emit pagerlistChanged(); }
    void setCategoryMyActyList(QList<QObject*> m) { m_catemyactylist.clear(); m_catemyactylist=m; emit catemyactylistChanged(); }
    void setCategoryMySaveList(QList<QObject*> m) { m_catemysavelist.clear(); m_catemysavelist=m; emit catemysavelistChanged(); }
    void setImageList(QList<QObject*> m) { m_imglist.clear(); m_imglist = m; emit imglistChanged(); }
    void setColorList(QList<QObject*> m) { m_colorlist.clear(); m_colorlist = m; emit colorlistChanged(); }
    void setMyLoginType(int m) { m_myloginType = m; emit myloginTypeChanged(); }
    void setMyName(QString m) { m_myname = m; emit mynameChanged(); }
    void setMyEmail(QString m) { m_myemail = m; emit myemailChanged(); }
    void setMyImage(QString m) { m_myimage = m; emit myimageChanged(); }
    void setHomeList(QList<QObject*> m) { m_homelist.clear(); m_homelist = m; emit homelistChanged(); }
    void appendHomeList(QList<QObject*> m)
    {
        m_homelist.append(m);
        emit homelistChanged();
    }

    QString getImgUrl(int id)
    {
        for(QObject* obj : m_imglist)
        {
            Image* img = qobject_cast<Image*>(obj);
            if(img->id() == id) return img->name();
        }
        return "";
    }

    QString getColor(int id)
    {
        for(QObject* obj : m_colorlist)
        {
            Color* cr = qobject_cast<Color*>(obj);
            if(cr->id() == id) return cr->code();
        }
        return "";
    }

    QString getCategory(int id)
    {
        for(QObject* obj : m_categorylist)
        {
            Category* ct = qobject_cast<Category*>(obj);
            if(ct->id() == id) return ct->name();
        }
        return "";
    }

    void click(bool m) { m_clicked = m; }
    void setHomeCateAreaWidth(int m) { m_homeCateAreaWidth = m; emit homeCateAreaWidthChanged(); }

    void setCheckedClause1(bool m) { m_checkedClause1 = m; emit checkedClause1Changed();}
    void setCheckedClause2(bool m) { m_checkedClause2 = m; emit checkedClause2Changed();}
    void setCheckedClause3(bool m) { m_checkedClause3 = m; emit checkedClause3Changed();}
    void setCheckedClause4(bool m) { m_checkedClause4 = m; emit checkedClause4Changed();}
    void setCheckedSystem(int m) { m_checkedSystem = m; emit checkedSystemChanged();}

    void selectCategory(QString m)
    {
        /* Clear. */
        for(QObject* o : m_categorylist)
        {
            Category* c = qobject_cast<Category*>(o);
            c->select(false);
        }

        /* All. */
        if(m.isEmpty())
        {
            if(m_categorylist.length() > 0)
            {
                Category* c = qobject_cast<Category*>(m_categorylist[0]);
                c->select(true);
                return;
            }
        }

        for(QObject* o : m_categorylist)
        {
            Category* c = qobject_cast<Category*>(o);
            c->select(false);
            if(c->id() == m.toInt())
            {
                //qDebug() << "Left ID: " << c->id() << ", Right ID: " << m;
                c->select(true);
                return;
            }
        }
    }

    void setCertificated(int m) { m_certificated = m; emit certificatedChanged(); }
    void setDuplicated(int m) { m_duplicated = m; emit duplicatedChanged(); }
    void setNeedUpdateApp(bool m) { m_needUpdateApp = m; emit needUpdateAppChanged(); }
    void setNeedUpdateOS(bool m) { m_needUpdateOS = m; emit needUpdateOSChanged(); }

    void setRunningTimeCounter(bool m) { m_runningTimeCounter = m; setStartedSecTime(); emit runningTimeCounterChanged();}
    void setStartedSecTime() { m_startedSecTime = QDateTime::currentDateTime(); emit startedSecTimeChanged(); }
    void setLeftTime(QString m) { m_leftTime = m; emit leftTimeChanged(); }

    void setMessageStr(QString m) { m_messageStr = m; emit messageStrChanged(); }

    //1-7. 로그인 //3-23. 다른 사용자 프로필보기
    void setUser(User* m) { m_user = m; emit userChanged(); }

    //2-7. 마이페이지 탭 메인화면(나의수강강좌)
    void setCompleteCourseList(QList<QObject*> m) { m_completeCourseList.clear(); m_completeCourseList = m; emit completeCourseListChanged(); }
    void setMyCourseList(QList<QObject*> m) { m_myCourseList.clear(); m_myCourseList = m; emit myCourseListChanged(); }

    //2-8. 마이페이지 탭 메인화면(나의최근활동)
    void setTotalLogCount(int m) { m_totalLogCount = m; emit totalLogCountChanged(); } //2-12.
    void setRecentLogList(QList<QObject*> m) { m_recentLogList.clear(); m_recentLogList = m; emit recentLogListChanged(); } /* Added By JHKim, When 2018.06.17. */
    void appendRecentLogList(QList<QObject*> m) { m_recentLogList.append(m); emit recentLogListChanged(); } /* Added By JHKim, When 2018.06.17. */

    //2-12. 2-13. 시스템 공지사항/질의사항 리스트보기, 상세보기
    void setTotalNoticeCount(int m) { m_totalNoticeCount = m; emit totalNoticeCountChanged(); }
    void setNoticeList(QList<QObject*> m) { m_noticeList.clear(); m_noticeList = m; emit noticeListChanged(); }
    void appendNoticeList(QList<QObject*> m) { m_noticeList.append(m); emit noticeListChanged(); }
    void removeNotice(int no, QString type)
    {
        if(!type.compare("push"))
        {
            int index = 0;
            for(QObject* o : m_noticeList)
            {
                Notification* n = qobject_cast<Notification*>(o);
                if(no == n->no())
                {
                    m_noticeList.removeAt(index);
                    emit noticeListChanged();
                    return;
                }
                index++;
            }
        }
    }
    void readNotice(int no, bool read)
    {
        int index = 0;
        for(QObject* o : m_noticeList)
        {
            Notification* n = qobject_cast<Notification*>(o);
            if(no == n->no())
            {
                n->setIsRead(read);
                emit noticeListChanged();
                return;
            }
            index++;
        }
    }

    void setNoticeTopList(QList<QObject*> m) { m_noticeTopList.clear(); m_noticeTopList = m; emit noticeTopListChanged(); }
    void setNoticeDetail(Univ* m) { m_noticeDetail = m; emit noticeDetailChanged(); } /* Added By JHKim, When 2018.06.17. */

    //3-1. 홈 메인화면(과목리스트받아오기)
    void setBannerList(QList<QObject*> m);

    /* Added By JHKim, When 2018.06.17. */
    void setBannerCount(int m) { m_bannerCount = m; emit bannerCountChanged(); }
    void setTotalCourseCount(int m) { m_totalCourseCount = m; emit totalCourseCountChanged(); }
    void setCourseDetail(Univ* m) { m_courseDetail = m; emit courseDetailChanged(); }
    //3-2. 과목 상세보기(해당과목과 연결된 게시판)
    void setBoardList(QList<QObject*> m) { m_boardList = m; emit boardListChanged(); }

    //3-12. delivery_flag만 따로
    void setClipList(QList<QObject*> m) { m_clipList = m; emit clipListChanged(); }

    //3-13. 클립상세보기(학습페이지)
    /* Added By JHKim, When 2018.06.17. */
    void setClipDetail(Univ* m) { m_clipDetail = m; emit clipDetailChanged(); }
    void setQuizList(QList<QObject*> m) { m_quizList.clear(); m_quizList = m; emit quizListChanged(); }

    //3-15. 해당클립공유하기
    void setClipHttpUrl(QString m) { m_clipHttpUrl = m; emit clipHttpUrlChanged(); }

    //3-17. 클립 댓글 리스트 불러오기
    void setRepleList(QList<QObject*> m) { m_repleList.clear(); m_repleList = m; emit repleListChanged(); }
    void clearRepleList() { m_repleList.clear(); emit repleListChanged(); }
    void appendRepleList(QList<QObject*> m) { m_repleList.append(m); emit repleListChanged(); }
    void insertRepleList(int index, QObject* o) { m_repleList.insert(index, o); emit repleListChanged(); }
    void deleteRepleList(int index) { m_repleList.removeAt(index); emit repleListChanged(); }

    //4-1. 검색 탭 메인화면
    void setSearchLogList(QList<QObject*> m) { m_searchLogList.clear(); m_searchLogList = m; emit searchLogListChanged(); }
    void setSearchCourseList(QList<QObject*> m) { m_searchCourseList.clear(); m_searchCourseList = m; emit searchCourseListChanged(); }
    void setSearchClipList(QList<QObject*> m) { m_searchClipList.clear();  m_searchClipList = m; emit searchClipListChanged(); }
    void appendSearchClipList(QList<QObject*> m) { m_searchClipList.append(m); emit searchClipListChanged(); }
    void setTotalSearchCount(int m) { m_totalSearchCount = m; emit totalSearchCountChanged(); }

    //5-1. 좋아요 탭 메인화면-클립
    void setTotalClipCount(int m) { m_totalClipCount = m; emit totalClipCountChanged(); }
    void setTotalRepleCount(int m) { m_totalRepleCount = m; emit totalRepleCountChanged();}
    void setLikeClipList(QList<QObject*> m) { m_likeClipList.clear();  m_likeClipList = m; emit likeClipListChanged(); }
    void appendLikeClipList(QList<QObject*> m) { m_likeClipList.append(m); emit likeClipListChanged(); }
    void setLikeRepleList(QList<QObject*> m) { m_likeRepleList.clear();  m_likeRepleList = m; emit likeRepleListChanged(); }
    void appendLikeRepleList(QList<QObject*> m) { m_likeRepleList.append(m); emit likeRepleListChanged(); }

    //6-1. 랭킹 탭 메인화면
    void setRankList(QList<QObject*> m) { m_rankList.clear();  m_rankList = m; emit rankListChanged(); }
    void setMyRank(Rank* m) { m_myRank = m; emit myRankChanged(); }

    //6-2. 적립내역 상세보기
    void setPointSaveList(QList<QObject*> m) { m_pointSaveList.clear();  m_pointSaveList = m; emit pointSaveListChanged(); }

    //6-3. 소비내역 상세보기
    void setPointSpendList(QList<QObject*> m) { m_pointSpendList.clear();  m_pointSpendList = m; emit pointSpendListChanged(); }

    //6-2. //6-3.
    void setMyTotalPointCount(int m) { m_myTotalPointCount = m; emit myTotalPointCountChanged(); }
    void setMyTotalHavePoint(int m) { m_myTotalHavePoint = m; emit myTotalHavePointChanged(); }
    void setMyTotalSumPoint(int m) { m_myTotalSumPoint = m; emit myTotalSumPointChanged(); }

    //6-4. 이벤트 내용 리스트 보기
    void setEventList(QList<QObject*> m) { m_eventList.clear(); m_eventList = m; emit eventListChanged(); }

    //6-5. 이벤트 내용 상세 보기
    void setEventDetail(Event* m) { m_eventDetail = m; emit eventDetailChanged(); }

    void setSnsLoginResult(int m) { m_snsLoginResult = m; emit snsLoginResultChanged(); }
    void setCurrentCourseNo(int m) { m_currentCourseNo = m; emit currentCourseNoChanged(); }
    void setCurrentClipNo(int m) { m_currentClipNo = m; emit currentClipNoChanged();}
    void setCurrentBoardNo(int m) { m_currentBoardNo = m; emit currentBoardNoChanged(); }
    void setCurrentBoardArticleNo(int m) { m_currentBoardArticleNo= m; emit currentBoardArticleNoChanged(); }
    void setCurrentTableRecordNo(int m) { m_currentTableRecordNo = m; emit currentTableRecordNoChanged(); }

    void clearHomeList() { m_homelist.clear(); m_homelist.clear(); emit homelistChanged(); }
    void clearBannerList() { m_bannerList.clear(); m_bannerList.clear(); emit bannerListChanged(); }
    void clearNoticeList() { m_noticeList.clear(); m_noticeTopList.clear(); emit noticeListChanged(); }
    void clearSearchLogList() { m_searchLogList.clear(); m_searchLogList.clear(); emit searchLogListChanged(); }
    void clearSearchClipList() { m_searchClipList.clear(); m_searchClipList.clear(); emit searchClipListChanged(); }
    void clearClipList() { m_clipList.clear(); emit clipListChanged(); }
    void clearMyCourseList() { m_myCourseList.clear(); emit myCourseListChanged(); }
    void clearRecentLogList() { m_recentLogList.clear(); emit recentLogListChanged(); }
    void clearPointSavedList() { m_pointSaveList.clear(); emit pointSaveListChanged(); }
    void clearPointSpentList() { m_pointSpendList.clear(); emit pointSpendListChanged(); }
    void clearLikeClipList() { m_likeClipList.clear(); emit likeClipListChanged(); }
    void clearLikeRepleList() { m_likeRepleList.clear(); emit likeRepleListChanged(); }
    void clearClipDetail()
    {
        //qDebug() << "clear clip detail.";
        m_clipDetail->setTitle("");
        m_clipDetail->setLinkUrl("");
        m_clipDetail->setRepleCount(0);
        m_clipDetail->setLike(0);

        setCurrentClipNo(0);
        setCurrentCourseNo(0);

        if(m_quizList.length() > 0)
        {
            for(QObject* obj : m_quizList)
            {
                Quiz* o = qobject_cast<Quiz*>(obj);
                o->clearExamples();
            }
        }
        m_quizList.clear();
    }
    void clearNoticeDetail()
    {
        m_noticeDetail->setTitle("");
        m_noticeDetail->setNickname("");
        m_noticeDetail->setWriteDate("");
        m_noticeDetail->setUserNo(0);
        m_noticeDetail->setViewCount(0);
        m_noticeDetail->setRepleCount(0);
        m_noticeDetail->setContents("");
        m_noticeDetail->clearFileList();
        m_noticeDetail->clearImageList();
        m_noticeDetail->setBoardArticleNo(0);
        m_noticeDetail->setBoardNo(0);
        m_noticeDetail->setAppliedImageUrl("");
        m_noticeDetail->setAppliedText("");

        setCurrentBoardNo(0);
        setCurrentBoardArticleNo(0);
    }
    void clearCourseDetail()
    {
        m_courseDetail->setServiceTitle("");
        m_courseDetail->setCourseImageUrl("");
        m_courseDetail->setShortDescription("");
        m_courseDetail->setDeliveryFlag(-1);

        setCurrentCourseNo(0);
    }

    void popFileStorage() { m_fileStorage.removeFirst(); emit fileStorageChanged(); }
    void popRemovedFileStorage() { m_removedFileStorage.removeFirst(); emit removedFileStorageChanged(); }

    int currentClipRepleListFilterType() const { return m_currentClipRepleFilterType; }
    void setCurrentClipRepleListFilterType(int m) {m_currentClipRepleFilterType = m; }

    void setDeliveryFlag(int m) { m_deliveryFlag = m; emit deliveryFlagChanged(); } /* Added By JHKim, When 2018.06.20.*/

    void copyToStorage(Univ* m)
    {
        m_fileStorage.clear();
        for(QObject* o : m->fileList())
        {
            m_fileStorage.append(o);
        }
        emit fileStorageChanged();
    }
    void setFileStorage(QList<QObject*> m) { m_fileStorage.clear(); m_fileStorage = m; emit fileStorageChanged(); }
    void setRemovedFileStorage(QList<QObject*> m) { m_removedFileStorage.clear(); m_fileStorage = m; emit fileStorageChanged(); }
    void addFile(QString fileName, QString fileUrl)
    {
        File* file = new File();
        file->setFileName(fileName);
        file->setFileUrl(fileUrl);

        QObject* o = qobject_cast<QObject*>(file);
        m_fileStorage.append(o);
        emit fileStorageChanged();
    }
    void replaceFile(QString fileName, QString fileUrl)
    {
        File* file = new File();
        file->setFileName(fileName);
        file->setFileUrl(fileUrl);

        QObject* o = qobject_cast<QObject*>(file);
        m_fileStorage.clear();
        m_fileStorage.append(o);
        emit fileStorageChanged();
    }
    void moveFileToRemoveQueue(int m)
    {
        QObject* o = m_fileStorage.at(m);
        File* u = qobject_cast<File*>(o);
        File* nf = new File();
        nf->setFileName(u->fileName());
        nf->setFileUrl(u->fileUrl());
        nf->setFileThumbNailUrl(u->fileThumbNailUrl());
        nf->setFileNo(u->fileNo());

        QObject* nfo = qobject_cast<QObject*>(nf);
        m_removedFileStorage.append(nfo);
        m_fileStorage.removeAt(m);
        emit fileStorageChanged();
    }
    void removeFile(int m)
    {
        m_fileStorage.removeAt(m);
        emit fileStorageChanged();
    }

    void removeFileQueue(int m)
    {
        m_removedFileStorage.removeAt(m);
        emit removedFileStorageChanged();
    }

    void clearFileStorage() { m_fileStorage.clear(); emit fileStorageChanged(); }
    void clearRemovedFileStorage() { m_removedFileStorage.clear(); emit removedFileStorageChanged(); }

    void setCRUDHandlerType(int m) { m_CRUDHandlerType = m; emit CRUDHandlerTypeChanged(); }

    void removeCurrentArticle()
    {
        int index = 0;
        for(QObject* o : m_noticeList)
        {
            Univ* u = qobject_cast<Univ*>(o);
            if(u->boardNo() == m_noticeDetail->boardNo() && u->boardArticleNo() == m_noticeDetail->boardArticleNo())
            {
                m_noticeList.removeAt(index);
                break;
            }
            index++;
        }

        emit noticeListChanged();
    }

    void deliver(int m) { m_delivered = m; emit deliveredChanged(); }
    void setNewAlarm(bool m) { m_newAlarm = m; emit newAlarmChanged(); }
    void setTotalAlarmCount(int m) { m_totalAlarmCount = m; emit totalAlarmCountChanged(); }
    void setAlarmList(QList<QObject*> m) { m_alarmList.clear(); m_alarmList = m; emit alarmListChanged(); }
    void appendAlarmList(QList<QObject*> m) { m_alarmList.append(m); emit alarmListChanged(); }
    bool deleteAlarm(int alarmNo)
    {
        int index = 0;
        for(QObject* o : m_alarmList)
        {
            Alarm* a = qobject_cast<Alarm*>(o);
            if(a->alarmNo() == alarmNo)
            {
                m_alarmList.removeAt(index);
                emit alarmListChanged();
                return true;
            }
            else index++;
        }
        return false;
    }
    void clearAlarmList() { m_alarmList.clear(); emit alarmListChanged(); }
    void setHelpList(QList<QObject*> m) { m_helpList.clear(); m_helpList = m; emit helpListChanged(); }
    void clearHelpList() { m_helpList.clear(); emit helpListChanged(); }

    void setViewOption(bool m) { m_viewOption = m; emit viewOptionChanged(); }

    void setNativeChanner(int m) { m_nativeChanner = m; /*qDebug() << "setNativeChanner: " << m;*/ emit nativeChannerChanged(); }
    void setRequestNativeBackBehavior(int m) { m_requestNativeBackBehavior = m; emit requestNativeBackBehaviorChanged(); }
    void forcePortrait(bool m) { m_forcedPortrait = m; emit forcedPortraitChanged(); }
    void showMyPage(bool m) { m_showedMyPage = m; emit showedMyPageChanged(); }
    void setPopMyPage(bool m) { m_popMyPage = m; emit popMyPageChanged(); }
    void setVideoStatus(int m) { m_videoStatus = m; emit videoStatusChanged(); }
    void showCommentViewer(bool m) { m_showedCommentViewer = m; emit showedCommentViewerChanged(); }

    void forceExit(bool m) { m_forcedExit = m; emit forcedExitChanged();}
    void secure(bool m) { m_secured = m; emit securedChanged(); }

    void requestShrinkVideo(bool m) { m_requestedShrinkVideo = m; emit requestedShrinkVideoChanged(); }

    void appendBannerList()
    {

    }

    bool setCantLoadContent(bool m) { m_cantLoadContent = m; emit cantLoadContentChanged(); }

signals:

    void initializedSystemChanged();
    void errorChanged();
    void alarmChanged();

    void unvisibleWebViewChanged();
    void useDummyChanged();

    void listChanged();
    void titleChanged();

    void blockedDrawerChanged();
    void openedDrawerChanged();
    void fullScreenChanged();
    void dlistChanged();
    void pagerlistChanged();
    void tablistChanged();
    void categorylistChanged();
    void colorlistChanged();
    void imglistChanged();
    void catelikelistChanged();
    void catemyactylistChanged();
    void catemysavelistChanged();
    //void likeClipListChanged();
    void messageIntChanged();
    void showIndicatorChanged();
    void clickedChanged();
    void homeCateAreaWidthChanged();
    void homelistChanged();
    //void clipListChanged();

    void myloginTypeChanged();
    void mynameChanged();
    void myemailChanged();
    void myimageChanged();
    void mycourselistChanged();

    void checkedClause1Changed();
    void checkedClause2Changed();
    void checkedClause3Changed();
    void checkedClause4Changed();
    void checkedSystemChanged();

    void certificatedChanged();
    void duplicatedChanged();
    void needUpdateAppChanged();
    void needUpdateOSChanged();

    void runningTimeCounterChanged();
    void startedSecTimeChanged();
    void leftTimeChanged();
    void messageStrChanged();
    //void ttChanged();

    //1-7. 로그인 //3-23. 다른 사용자 프로필보기
    void userChanged();

    //2-7. 마이페이지 탭 메인화면(나의수강강좌)
    void myCourseListChanged();
    void completeCourseListChanged();

    //2-8. 마이페이지 탭 메인화면(나의최근활동)
    void totalLogCountChanged(); //2-12.
    void recentLogListChanged(); /* Added By JHKim, When 2018.06.17. */

    //2-12. 2-13. 시스템 공지사항/질의사항 리스트보기, 상세보기
    void totalNoticeCountChanged();
    void noticeListChanged();
    void noticeTopListChanged();
    void noticeDetailChanged(); /* Added By JHKim, When 2018.06.17. */

    //3-1. 홈 메인화면(과목리스트받아오기)
    void bannerListChanged(); /* Added By JHKim, When 2018.06.17. */
    void bannerCountChanged();
    void totalCourseCountChanged();
    void courseDetailChanged();

    //3-2. 과목 상세보기(해당과목과 연결된 게시판)
    void boardListChanged();

    //3-12. delivery_flag만 따로
    void clipListChanged();

    //3-13. 클립상세보기(학습페이지)
    /* Added By JHKim, When 2018.06.17. */
    void clipDetailChanged();
    void quizListChanged();

    //3-15. 해당클립공유하기
    void clipHttpUrlChanged();

    //3-17. 클립 댓글 리스트 불러오기
    void repleListChanged();

    //4-1. 검색 탭 메인화면
    void totalSearchCountChanged();
    void searchLogListChanged();
    void searchCourseListChanged();
    void searchClipListChanged();

    //5-1. 좋아요 탭 메인화면-클립
    void totalClipCountChanged();
    void totalRepleCountChanged();
    void likeClipListChanged();
    void likeRepleListChanged();

    //6-1. 랭킹 탭 메인화면
    void rankListChanged();
    void myRankChanged();

    //6-2. 적립내역 상세보기
    void pointSaveListChanged();

    //6-3. 소비내역 상세보기
    void pointSpendListChanged();

    //6-2. //6-3.
    void myTotalPointCountChanged();
    void myTotalHavePointChanged();
    void myTotalSumPointChanged();

    //6-4. 이벤트 내용 리스트 보기
    void eventListChanged();

    //6-5. 이벤트 내용 상세 보기
    void eventDetailChanged();

    void snsLoginResultChanged();
    void currentCourseNoChanged();
    void currentClipNoChanged();
    void currentBoardNoChanged();
    void currentBoardArticleNoChanged();
    void currentTableRecordNoChanged();
    void deliveryFlagChanged();

    void fileStorageChanged();
    void removedFileStorageChanged();

    void CRUDHandlerTypeChanged();

    void imageListChanged();
    void fileListChanged();

    void deliveredChanged();
    void newAlarmChanged();
    void totalAlarmCountChanged();
    void alarmListChanged();

    void helpListChanged();
    void viewOptionChanged();

    void nativeChannerChanged();
    void requestNativeBackBehaviorChanged();
    void forcedPortraitChanged();
    void showedMyPageChanged();
    void popMyPageChanged();
    void showedCommentViewerChanged();

    void videoStatusChanged();
    void forcedExitChanged();
    void securedChanged();

    void requestedShrinkVideoChanged();
    void cantLoadContentChanged();

private:
    static Model* m_instance;
    Model()
    {
        m_tablist.append(new Tab(0, "Home", "../img/home_pink.png", "../img/home.png", "black", "white", false));
        m_tablist.append(new Tab(0, "Search", "../img/search_pink.png", "../img/search.png", "black", "white", false));
        m_tablist.append(new Tab(0, "Like", "../img/like_pink.png", "../img/like.png", "black", "white", false));

        m_tablist.append(new Tab(0, "Point", "../img/point_pink.png", "../img/point.png", "black", "white", false));
        m_tablist.append(new Tab(0, "Login", "../img/mypage_pink.png", "../img/mypage.png", "black", "white", false));

        m_catelikelist.append(new Category(1, "Clip"));
        m_catelikelist.append(new Category(2, "Comment"));

        m_catemyactylist.append(new Category(1, "MyListen", true));
        m_catemyactylist.append(new Category(2, "MyActivites"));

        m_catemysavelist.append(new Category(1, "Saved", true));
        m_catemysavelist.append(new Category(2, "Used"));

        m_noticeDetail = new Univ();
        m_courseDetail = new Univ();
        m_clipDetail = new Univ();

        m_user = new User();
        m_myRank = new Rank();
        m_noticePopup = new Univ();

        m_ampm.append("AM");
        m_ampm.append("PM");
    }

    QMutex m_mtx;

    QString m_error; /* 에러 메시지 */
    AlarmPopup* m_alarm; /* 단일 팝업창 */
    ClipViewer* m_clipViewer;

    bool m_initializedSystem = false;
    bool m_unvisibleWebView = false;
    bool m_useDummy = false;

    QList<QObject*> m_list;
    QString m_title = "TITLE";

    bool m_blockedDrawer = false;
    bool m_openedDrawer = false;
    bool m_fullScreen = false;
    bool m_showIndicator = false;
    QList<QObject*> m_dlist;
    QList<QObject*> m_pagerlist;
    QList<QObject*> m_tablist;
    QList<QObject*> m_categorylist;
    QList<QObject*> m_catelikelist;
    QList<QObject*> m_catemyactylist;
    QList<QObject*> m_catemysavelist;
    QList<QObject*> m_colorlist;
    QList<QObject*> m_imglist;
    //QList<QObject*> m_likeClipList;
    QList<QObject*> m_homelist;
    //QList<QObject*> m_clipList;
    int m_messageInt = -1;
    bool m_clicked = false;
    int m_homeCateAreaWidth = 0;

    int m_myloginType = 0; /* 0: email, 1: kakao, 2: facebook */
    QString m_myname = "noname";
    QString m_myemail = "example@example.com";
    QString m_myimage = "";
    QList<QObject*> m_mycourselist;

    bool m_checkedClause1 = false;
    bool m_checkedClause2 = false;
    bool m_checkedClause3 = false;
    bool m_checkedClause4 = false;
    int m_checkedSystem = ENums::NETWORK_RESULT::WAIT;

    int m_certificated = ENums::NETWORK_RESULT::WAIT;
    int m_duplicated = ENums::NETWORK_RESULT::WAIT;
    bool m_needUpdateApp = false;
    bool m_needUpdateOS = false;

    bool m_runningTimeCounter = false;
    QDateTime m_startedSecTime;
    QString m_leftTime = "02:30";

    QString m_messageStr;
    //Dummy* m_tt;

    //1-7. 로그인 //3-23. 다른 사용자 프로필보기
    User* m_user;

    //2-7. 마이페이지 탭 메인화면(나의수강강좌)
    QString m_id; //2-10.
    QList<QObject*> m_myCourseList;


    //2-7. 마이페이지 탭 메인화면(나의수강강좌)-수강완료
    QList<QObject*> m_completeCourseList;

    //2-8. 마이페이지 탭 메인화면(나의최근활동)
    int m_totalLogCount = 0; //2-12.
    QList<QObject*> m_recentLogList;/* Added By JHKim, When 2018.06.17. */


    //2-12. 2-13. 시스템 공지사항/질의사항 리스트보기, 상세보기
    int m_totalNoticeCount = 0;
    QList<QObject*> m_noticeList;
    QList<QObject*> m_noticeTopList; /* Added By JHKim, When 2018.06.20. */
    Univ* m_noticeDetail; /* Added By JHKim, When 2018.06.17. */

    //3-1. 홈 메인화면(과목리스트받아오기)
    QList<QObject*> m_bannerList; /* Added By JHKim, When 2018.06.17. */
    int m_bannerCount = 0;
    int m_totalCourseCount = 0;
    Univ* m_courseDetail;

    //3-2. 과목 상세보기(해당과목과 연결된 게시판)
    QList<QObject*> m_boardList;

    //3-12. delivery_flag만 따로
    QList<QObject*> m_clipList;

    //3-13. 클립상세보기(학습페이지)
    /* Commented By JHKim, When 2018.06.17. */
    //    QString m_url;
    //    int m_repleCount;
    /* Added By JHKim, When 2018.06.17. */
    Univ* m_clipDetail;
    QList<QObject*> m_quizList;

    //3-15. 해당클립공유하기
    QString m_clipHttpUrl;

    //3-17. 클립 댓글 리스트 불러오기
    QList<QObject*> m_repleList;

    //4-1. 검색 탭 메인화면
    int m_totalSearchCount = 0;
    QList<QObject*> m_searchLogList;
    QList<QObject*> m_searchCourseList;
    QList<QObject*> m_searchClipList;

    //5-1. 좋아요 탭 메인화면-클립
    int m_totalClipCount;
    int m_totalRepleCount;
    QList<QObject*> m_likeClipList;
    QList<QObject*> m_likeRepleList;

    //6-1. 랭킹 탭 메인화면
    QList<QObject*> m_rankList;
    Rank* m_myRank;

    //6-2. 적립내역 상세보기
    QList<QObject*> m_pointSaveList;

    //6-3. 소비내역 상세보기
    QList<QObject*> m_pointSpendList;

    //6-2. //6-3.
    int m_myTotalPointCount = 0;
    int m_myTotalHavePoint = 0;
    int m_myTotalSumPoint = 0;

    //6-4. 이벤트 내용 리스트 보기
    QList<QObject*> m_eventList;

    //6-5. 이벤트 내용 상세 보기
    Event* m_eventDetail;

    QList<QObject*> m_helpList;

    int m_snsLoginResult = ENums::NETWORK_RESULT::WAIT;
    int m_currentCourseNo;
    int m_currentClipNo;
    int m_currentBoardNo;
    int m_currentBoardArticleNo;
    int m_currentTableRecordNo;
    int m_currentClipRepleFilterType;

    int m_deliveryFlag;

    QList<QObject*> m_fileStorage;
    QList<QObject*> m_removedFileStorage;

    int m_CRUDHandlerType = 0;
    int m_delivered = 0;
    bool m_newAlarm = false;
    int m_totalAlarmCount = 0;
    QList<QObject*> m_alarmList;

    Univ* m_noticePopup;
    QList<QString> m_ampm;

    bool m_viewOption = false;
    int m_nativeChanner = 0;
    int m_requestNativeBackBehavior = ENums::ANDROID_BACK_BEHAVIOR_STATE::WAIT_BEHAVIOR;
    bool m_forcedPortrait = true;
    bool m_showedMyPage = false;
    bool m_popMyPage = false;
    bool m_showedCommentViewer = false;

    int m_videoStatus = -1;
    bool m_forcedExit = false;
    bool m_secured = false;

    bool m_requestedShrinkVideo = false;
    bool m_cantLoadContent = false;
};
