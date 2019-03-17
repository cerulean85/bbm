#pragma once
#include <QSettings>
#include <QObject>
#include "enums.h"
#include <QMutex>

class NativeApp;
class Settings : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool autoLogin READ autoLogin WRITE setAutoLogin NOTIFY autoLoginChanged)
    Q_PROPERTY(bool logined READ logined WRITE setLogined NOTIFY loginedChanged)
    Q_PROPERTY(int noUser READ noUser WRITE setNoUser NOTIFY noUserChanged)
    Q_PROPERTY(QString id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(QString password READ password WRITE setPassword)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString nickName READ nickName WRITE setNickName NOTIFY nickNameChanged)
    Q_PROPERTY(QString birth READ birth WRITE setBirth NOTIFY birthChanged)
    Q_PROPERTY(int gender READ gender WRITE setGender NOTIFY genderChanged)
    Q_PROPERTY(QString phone READ phone WRITE setPhone NOTIFY phoneChanged)
    Q_PROPERTY(int osType READ osType WRITE setOsType NOTIFY osTypeChanged)
    Q_PROPERTY(QString osName READ osName)
    Q_PROPERTY(QString deviceId READ deviceId WRITE setDeviceId NOTIFY deviceIdChanged)
    Q_PROPERTY(QString deviceName READ deviceName WRITE setDeviceName NOTIFY deviceNameChanged)
    Q_PROPERTY(int snsType READ snsType WRITE setSnsType NOTIFY snsTypeChanged)
    Q_PROPERTY(QString pushkey READ pushkey WRITE setPushkey NOTIFY pushkeyChanged)
    Q_PROPERTY(QString nativePushkey READ nativePushkey WRITE setNativePushkey NOTIFY nativePushkeyChanged)
    Q_PROPERTY(int pushStatus READ pushStatus WRITE setPushStatus NOTIFY pushStatusChanged)
    Q_PROPERTY(int pushType READ pushType WRITE setPushType NOTIFY pushTypeChanged)
    Q_PROPERTY(QString pushTime READ pushTime WRITE setPushTime NOTIFY pushTimeChanged)
    Q_PROPERTY(QString email READ email WRITE setEmail NOTIFY emailChanged)
    Q_PROPERTY(QString accessToken READ accessToken WRITE setAccessToken NOTIFY accessTokenChanged)
    Q_PROPERTY(QString refreshToken READ refreshToken WRITE setRefreshToken NOTIFY refreshTokenChanged)
    Q_PROPERTY(QString thumbnailImage READ thumbnailImage WRITE setThumbnailImage NOTIFY thumbnailImageChanged)
    Q_PROPERTY(QString profileImage READ profileImage WRITE setProfileImage NOTIFY profileImageChanged)
    Q_PROPERTY(QString errorMessage READ errorMessage WRITE setErrorMessage NOTIFY errorMessageChanged)
    Q_PROPERTY(QString versServer READ versServer WRITE setVersServer NOTIFY versServerChanged)
    Q_PROPERTY(float   versOS READ versOS WRITE setVersOS NOTIFY versOSChanged)
    Q_PROPERTY(QString versCurrentApp READ versCurrentApp WRITE setVersCurrentApp NOTIFY versCurrentAppChanged)
    Q_PROPERTY(QString eventUrl READ eventUrl WRITE setEventUrl NOTIFY eventUrlChanged)
    Q_PROPERTY(int eventType     READ eventType     WRITE setEventType      NOTIFY eventTypeChanged)
    Q_PROPERTY(int eventScore    READ eventScore    WRITE setEventScore     NOTIFY eventScoreChanged)
    Q_PROPERTY(QString eventImageUrl READ eventImageUrl WRITE setEventImageUrl  NOTIFY eventImageUrlChanged)
    Q_PROPERTY(QString eventDesc     READ eventDesc     WRITE setEventDesc      NOTIFY eventDescChanged)
    Q_PROPERTY(int roleCode     READ roleCode     WRITE setRoleCode      NOTIFY roleCodeChanged)
    Q_PROPERTY(int totalHavePoint READ totalHavePoint WRITE setTotalHavePoint NOTIFY totalHavePointChanged) //6-2. 사용자가 보유한 총 포인트. Defined By Shin.
    Q_PROPERTY(int totalHavePointCount READ totalHavePointCount WRITE setTotalHavePointCount NOTIFY totalHavePointCountChanged) //6-2. 포인트 적립 건수. Defined By Shin.
    Q_PROPERTY(int totalSumPoint READ totalSumPoint WRITE setTotalSumPoint NOTIFY totalSumPointChanged) //6-2. 사용자가 적립한 총 포인트. Defined By Shin.
    Q_PROPERTY(QString recentDate READ recentDate WRITE setRecentDate NOTIFY recentDateChanged)
    Q_PROPERTY(QString joinDate READ joinDate WRITE setJoinDate NOTIFY joinDateChanged)
    Q_PROPERTY(int blocked READ blocked WRITE setBlocked NOTIFY blockedChanged)
    Q_PROPERTY(QString inviteUrl     READ inviteUrl     WRITE setInviteUrl      NOTIFY inviteUrlChanged)

    Q_PROPERTY(int pushTimeAMPM     READ pushTimeAMPM WRITE setPushTimeAMPM NOTIFY pushTimeAMPMChanged)
    Q_PROPERTY(int pushTimeHour     READ pushTimeHour WRITE setPushTimeHour NOTIFY pushTimeHourChanged)
    Q_PROPERTY(int pushTimeMinutes READ pushTimeMinutes WRITE setPushTimeMinutes NOTIFY pushTimeMinutesChanged)

    Q_PROPERTY(int heightStatusBar READ heightStatusBar WRITE setHeightStatusBar NOTIFY heightStatusBarChanged)
    Q_PROPERTY(int heightBottomArea READ heightBottomArea WRITE setHeightBottomArea NOTIFY heightBottomAreaChanged)
    Q_PROPERTY(int fontSizeDeliveryBtn READ fontSizeDeliveryBtn WRITE setFontSizeDeliveryBtn NOTIFY fontSizeDeliveryBtnChanged)
    Q_PROPERTY(int noShowNoticePopupNo READ noShowNoticePopupNo WRITE setNoShowNoticePopupNo NOTIFY noShowNoticePopupNoChanged)

    Q_PROPERTY(bool hideGuide READ hideGuide WRITE setHideGuide NOTIFY hideGuideChanged)

public:
    static Settings* getInstance()
    {
        if (m_instance == nullptr) {
            m_instance = new Settings();
        }
        return m_instance;
    }

    QMutex m_mtx;
    
    void setValue(QString key, int value);
    void setValue(QString key, QString value);
    void setValue(QString key, bool value);
    void setValue(QString key, float value);

    Q_INVOKABLE bool    autoLogin()  const;
    Q_INVOKABLE bool    logined()        const;
    Q_INVOKABLE int     noUser()         const;
    Q_INVOKABLE QString id()             const;
    Q_INVOKABLE QString password()       const;
    Q_INVOKABLE QString name()           const;
    Q_INVOKABLE QString nickName()       const;
    Q_INVOKABLE QString birth()          const;
    Q_INVOKABLE int     gender()         const;
    Q_INVOKABLE QString phone()          const;
    Q_INVOKABLE int     osType()         const;
    Q_INVOKABLE QString osName()         const;
    Q_INVOKABLE QString deviceId()       const;
    Q_INVOKABLE QString deviceName()     const;
    Q_INVOKABLE int     snsType()        const;
    Q_INVOKABLE QString pushkey()        const;
    Q_INVOKABLE QString nativePushkey()  const;
    Q_INVOKABLE QString pushTime()       const;
    Q_INVOKABLE int pushStatus()         const;
    Q_INVOKABLE int pushType()           const;
    Q_INVOKABLE QString email()          const;
    Q_INVOKABLE QString accessToken()    const;
    Q_INVOKABLE QString refreshToken()   const;
    Q_INVOKABLE QString thumbnailImage() const;
    Q_INVOKABLE QString profileImage()   const;
    Q_INVOKABLE QString errorMessage()   const;
    Q_INVOKABLE QString versServer()     const;
    Q_INVOKABLE float   versOS()         const;
    Q_INVOKABLE QString versCurrentApp() const;
    Q_INVOKABLE QString eventUrl()       const;
    Q_INVOKABLE int eventType()          const;
    Q_INVOKABLE int eventScore()         const;
    Q_INVOKABLE QString eventImageUrl()  const;
    Q_INVOKABLE QString eventDesc()      const;
    Q_INVOKABLE int roleCode()           const;
    Q_INVOKABLE int totalHavePoint()     const;
    Q_INVOKABLE int totalHavePointCount() const;
    Q_INVOKABLE int totalSumPoint()      const;
    Q_INVOKABLE QString recentDate()     const;
    Q_INVOKABLE QString joinDate()       const;
    Q_INVOKABLE int blocked()            const;
    Q_INVOKABLE QString inviteUrl()      const;
    Q_INVOKABLE int pushTimeAMPM()       const;
    Q_INVOKABLE int pushTimeHour()       const;
    Q_INVOKABLE int pushTimeMinutes()    const;
    Q_INVOKABLE int heightStatusBar()    const;
    Q_INVOKABLE int heightBottomArea()   const;
    Q_INVOKABLE int fontSizeDeliveryBtn() const;
    Q_INVOKABLE int noShowNoticePopupNo() const;
    Q_INVOKABLE bool hideGuide()         const;
    Q_INVOKABLE void clearUser();

public slots:
    int     valueInt(QString key)  const { return m_setting.value(key).toInt(); }
    QString valueStr(QString key)  const { return m_setting.value(key).toString(); }
    bool    valueBool(QString key) const { return m_setting.value(key).toBool(); }
    float     valueFloat(QString key)  const { return m_setting.value(key).toFloat(); }

    void setAutoLogin(const bool &m);
    void setLogined(const bool &m);
    void setNoUser(const int &m);
    void setId(const QString m);
    void setPassword(const QString m);
    void setName(const QString m);
    void setNickName(const QString m);
    void setBirth(const QString m);
    void setGender(const int &m);
    void setPhone(const QString m);
    void setOsType(const int m);
    void setDeviceId(const QString m);
    void setDeviceName(const QString m);
    void setSnsType(const int &m);
    void setPushType(const int &m);
    void setPushTime(const QString &m);
    void setPushkey(const QString &m);
    void setNativePushkey(const QString &m);
    void setPushStatus(const int &m);
    void setEmail(const QString &m);
    void setAccessToken(const QString &m);
    void setRefreshToken(const QString &m);
    void setThumbnailImage(const QString &m);
    void setProfileImage(const QString &m);
    void setErrorMessage(const QString &m);
    void setVersServer(const QString &m);
    void setVersOS(const float &m);
    void setVersCurrentApp(const QString &m);
    void setEventUrl(const QString &m);
    void setEventType(const int &m);
    void setEventScore(const int &m);
    void setEventImageUrl(const QString &m);
    void setEventDesc(const QString &m);
    void setRoleCode(const int &m);
    void setTotalHavePoint(const int &m);
    void setTotalHavePointCount(const int m);
    void setTotalSumPoint(const int m);
    void setRecentDate(const QString m);
    void setJoinDate(const QString m);
    void setBlocked(const int m);
    void setInviteUrl(const QString m);
    void setPushTimeAMPM(int m);
    void setPushTimeHour(int m);
    void setPushTimeMinutes(int m);
    void setHeightStatusBar(int m);
    void setHeightBottomArea(int m);
    void setFontSizeDeliveryBtn(int m);
    void setNoShowNoticePopupNo(int m);
    void setHideGuide(bool m);

signals:
    void autoLoginChanged();
    void loginedChanged();
    void noUserChanged();
    void idChanged();
    void passwordChanged();
    void nameChanged();
    void nickNameChanged();
    void birthChanged();
    void genderChanged();
    void phoneChanged();
    void osTypeChanged();
    void deviceIdChanged();
    void deviceNameChanged();
    void snsTypeChanged();
    void pushkeyChanged();
    void pushStatusChanged();
    void pushTypeChanged();
    void pushTimeChanged();
    void emailChanged();
    void accessTokenChanged();
    void refreshTokenChanged();
    void thumbnailImageChanged();
    void profileImageChanged();
    void errorMessageChanged();
    void versServerChanged();
    void versOSChanged();
    void versCurrentAppChanged();
    void eventUrlChanged();
    void eventTypeChanged();
    void eventScoreChanged();
    void eventImageUrlChanged();
    void eventDescChanged();
    void roleCodeChanged();
    void totalHavePointChanged();
    void totalHavePointCountChanged();
    void totalSumPointChanged();
    void recentDateChanged();
    void joinDateChanged();
    void blockedChanged();
    void inviteUrlChanged();
    void pushTimeAMPMChanged();
    void pushTimeHourChanged();
    void pushTimeMinutesChanged();
    void nativePushkeyChanged();
    void heightStatusBarChanged();
    void heightBottomAreaChanged();
    void fontSizeDeliveryBtnChanged();
    void noShowNoticePopupNoChanged();
    void hideGuideChanged();

private:
    Settings(QObject *parent = NULL);
    ~Settings();

    QSettings m_setting;
    static Settings* m_instance;

    NativeApp* m_app;
};
