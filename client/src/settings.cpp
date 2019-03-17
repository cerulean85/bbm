#include "settings.h"
#include "native_app.h"
#include <QDebug>
#include <QMutexLocker>

Settings* Settings::m_instance = nullptr;
Settings::Settings(QObject *parent) : QObject(parent)
{
    m_app = NativeApp::getInstance();
}
Settings::~Settings()
{

}

void Settings::setValue(QString key, int value) {  m_setting.setValue(key, value); }
void Settings::setValue(QString key, QString value) {  m_setting.setValue(key, value); }
void Settings::setValue(QString key, bool value) { m_setting.setValue(key, value); }
void Settings::setValue(QString key, float value) {  m_setting.setValue(key, value); }

bool    Settings::autoLogin()  const { return valueBool("maintain_login"); }
bool    Settings::logined()        const { return valueBool("is_logined"); }
int     Settings::noUser()         const { return valueInt("no_user"); }
QString Settings::id()             const { return m_app->decrypted(valueStr("id")); }
QString Settings::password()       const { return m_app->decrypted(valueStr("password")); }
QString Settings::nickName()       const { return valueStr("nickname"); }
QString Settings::name()           const { return m_app->decrypted(valueStr("name")); }
QString Settings::email()          const { return m_app->decrypted(valueStr("email")); }
QString Settings::birth()          const { return m_app->decrypted(valueStr("birth")); }
QString Settings::pushkey()        const { return valueStr("pushkey"); }
QString Settings::nativePushkey()  const { return valueStr("native_pushkey"); }
QString Settings::phone()          const { return m_app->decrypted(valueStr("phone")); }
QString Settings::deviceId()       const { return m_app->decrypted(valueStr("device_id")); }
QString Settings::deviceName()     const { return m_app->decrypted(valueStr("device_name")); }

QString Settings::accessToken()    const { return m_app->decrypted(valueStr("access_token")); }
QString Settings::refreshToken()   const { return m_app->decrypted(valueStr("refresh_token")); }
QString Settings::thumbnailImage() const
{
    QString url = m_app->decrypted(valueStr("thumbnail_image"));
    #if defined(Q_OS_ANDROID)
    if(url.startsWith("https")) url = url.replace(0, 5, "http");
    #endif
    return url;
}
QString Settings::profileImage()   const
{
    QString url = m_app->decrypted(valueStr("profile_image"));
    #if defined(Q_OS_ANDROID)
    if(url.startsWith("https")) url = url.replace(0, 5, "http");
    #endif
    return url;
}

int     Settings::gender()         const { return valueInt("gender"); }
int     Settings::osType()         const { return valueInt("os_type"); }
QString Settings::osName()         const
{
    int type = osType();
    switch(type)
    {
    case ENums::OS_TYPE::_ANDROID: return "Android";
    case ENums::OS_TYPE::IOS: return "iOS";
    default: return "undefined";
    }
    return "undefined";
}

int     Settings::snsType()        const { return valueInt("sns_type"); }
QString Settings::pushTime()        const { return valueStr("push_time"); }
int Settings::pushStatus()         const { return valueInt("push_status"); }
int Settings::pushType()           const { return valueInt("push_type"); }
QString Settings::errorMessage()   const { return valueStr("error_message"); }
QString   Settings::versServer()     const { return valueStr("version_server"); }
float   Settings::versOS()     const { return valueFloat("version_os"); }
QString Settings::versCurrentApp()     const { return valueStr("version_current_app"); }
QString Settings::eventUrl()       const { return valueStr("event_url"); }
int Settings::eventType()          const { return valueInt("event_type"); }
int Settings::eventScore()         const { return valueInt("event_score"); }
QString Settings::eventImageUrl()      const
{
    QString url = valueStr("event_image_url");
    #if defined(Q_OS_ANDROID)
    if(url.startsWith("https")) url = url.replace(0, 5, "http");
    #endif
    return url;
}
QString Settings::eventDesc()          const { return valueStr("event_desc"); }
int Settings::roleCode()         const { return valueInt("role_code"); }
int Settings::totalHavePoint()         const { return valueInt("total_have_point"); }
int Settings::totalHavePointCount()   const { return valueInt("total_have_point_count");}
int Settings::totalSumPoint()         const { return valueInt("total_sum_point"); }
QString Settings::recentDate()      const { return valueStr("recent_date"); }
QString Settings::joinDate()      const { return valueStr("join_date"); }
int Settings::blocked()      const { return valueInt("blocked"); }
QString Settings::inviteUrl() const
{
    QString url = "http://mobile01.e-koreatech.ac.kr";
//    #if defined(Q_OS_ANDROID)
//    url = "https://play.google.com/store/apps/details?id=com.codymonster.ibeobom";
//    #elif defined(Q_OS_IOS)
//    url = "https://itunes.apple.com/app/id1412494874";
//    #endif
    return url;
//    return valueStr("invite_url").isEmpty() ? "http://portal.e-koreatech.ac.kr" : valueStr("invite_url");
}
int Settings::pushTimeAMPM() const { return valueInt("push_time_ampm"); }
int Settings::pushTimeHour() const { return valueInt("push_time_hour"); }
int Settings::pushTimeMinutes() const { return valueInt("push_time_minutes"); }
int Settings::heightStatusBar() const { return valueInt("height_status_bar"); }
int Settings::heightBottomArea() const { return valueInt("height_bottom_area"); }
int Settings::fontSizeDeliveryBtn() const { return valueInt("font_size_delivery_btn"); }
int Settings::noShowNoticePopupNo() const { return valueInt("no_show_notice_popup_no"); }
bool Settings::hideGuide() const { return valueBool("hide_guide"); }
void Settings::clearUser()
{
    setAutoLogin(false);
    setLogined(false);
    setNoUser(0);
    setId("");
    setPassword("");
    setName("");
    setNickName("");
    setBirth("");
    setGender(0);
    setPhone("");
    setSnsType(0);
    setPushType(0);
    setPushStatus(0);
    setPushTime("");
    setEmail("");
    setAccessToken("");
    setRefreshToken("");
    setThumbnailImage("");
    setProfileImage("");
    setEventUrl("");
    setEventType(0);
    setEventScore(0);
    setEventImageUrl("");
    setEventDesc("");
    setRoleCode(0);
    setTotalHavePoint(0);
    setTotalHavePointCount(0);
    setTotalSumPoint(0);
    setRecentDate("");
    setBlocked(0);
    setInviteUrl("");
}

void Settings::setAutoLogin(const bool &m) { setValue("maintain_login", m); emit autoLoginChanged(); }
void Settings::setLogined(const bool &m)      { setValue("is_logined", m); emit loginedChanged(); }
void Settings::setNoUser(const int &m)        { setValue("no_user", m); emit noUserChanged(); }
void Settings::setId(const QString m)         { setValue("id", m_app->encrypted(m)); emit idChanged(); }
void Settings::setPassword(const QString m)   { setValue("password", m_app->encrypted(m)); emit passwordChanged(); }
void Settings::setName(const QString m)       { setValue("name",  m_app->encrypted(m.toUtf8())); emit nameChanged(); }
void Settings::setNickName(const QString m)   { setValue("nickname", m); emit nickNameChanged(); }
void Settings::setBirth(const QString m)      { setValue("birth", m_app->encrypted(m)); emit birthChanged(); }
void Settings::setDeviceId(const QString m)   { setValue("device_id", m_app->encrypted(m)); emit deviceIdChanged(); }
void Settings::setDeviceName(const QString m) { setValue("device_name", m_app->encrypted(m)); emit deviceNameChanged(); }
void Settings::setPhone(const QString m)      { setValue("phone", m_app->encrypted(m)); emit phoneChanged(); }
void Settings::setPushkey(const QString &m)   { setValue("pushkey", m); emit pushkeyChanged(); }
void Settings::setEmail(const QString &m)     { setValue("email", m_app->encrypted(m)); emit emailChanged(); }
void Settings::setNativePushkey(const QString &m)   { setValue("native_pushkey", m); emit nativePushkeyChanged(); }
void Settings::setGender(const int &m)        { setValue("gender", m); emit genderChanged(); }
void Settings::setOsType(const int m)         { setValue("os_type", m); emit osTypeChanged(); }
void Settings::setSnsType(const int &m)       { setValue("sns_type", m); emit snsTypeChanged(); }
void Settings::setPushType(const int &m)       { setValue("push_type", m); emit pushTypeChanged(); }
void Settings::setPushTime(const QString &m)       { setValue("push_time", m); emit pushTimeChanged(); }
void Settings::setPushStatus(const int &m)   { setValue("push_status", m); emit pushStatusChanged(); }
void Settings::setAccessToken(const QString &m)  { setValue("access_token", m_app->encrypted(m)); emit accessTokenChanged(); }
void Settings::setRefreshToken(const QString &m) { setValue("refresh_token", m_app->encrypted(m)); emit refreshTokenChanged(); }
void Settings::setThumbnailImage(const QString &m) { setValue("thumbnail_image", m_app->encrypted(m)); emit thumbnailImageChanged(); }
void Settings::setProfileImage(const QString &m) { setValue("profile_image", m_app->encrypted(m)); emit profileImageChanged(); }
void Settings::setErrorMessage(const QString &m) { setValue("error_message", m); emit errorMessageChanged(); }
void Settings::setVersServer(const QString &m)  { setValue("version_server", m); emit versServerChanged(); }
void Settings::setVersOS(const float &m)  { setValue("version_os", m); emit versOSChanged(); }
void Settings::setVersCurrentApp(const QString &m)  { setValue("version_current_app", m); emit versCurrentAppChanged(); }
void Settings::setEventUrl(const QString &m)  { setValue("event_url", m); emit eventUrlChanged(); }
void Settings::setEventType(const int &m)     { setValue("event_type", m); emit eventTypeChanged(); }
void Settings::setEventScore(const int &m)    { setValue("event_score", m); emit eventScoreChanged(); }
void Settings::setEventImageUrl(const QString &m) { setValue("event_image_url", m); emit eventImageUrlChanged(); }
void Settings::setEventDesc(const QString &m) { setValue("event_desc", m); emit eventDescChanged(); }
void Settings::setRoleCode(const int &m) { setValue("role_code", m); emit roleCodeChanged(); }
void Settings::setTotalHavePoint(const int &m) { setValue("total_have_point", m); emit totalHavePointChanged();}
void Settings::setTotalHavePointCount(const int m) { setValue("total_have_point_count", m); emit totalHavePointCountChanged(); }
void Settings::setTotalSumPoint(const int m) { setValue("total_sum_point", m); emit totalSumPointChanged(); }
void Settings::setRecentDate(const QString m) { setValue("recent_date", m); emit recentDateChanged(); }
void Settings::setJoinDate(const QString m) { setValue("join_date", m); emit joinDateChanged(); }
void Settings::setBlocked(const int m) { setValue("blocked", m); emit blockedChanged(); }
void Settings::setInviteUrl(const QString m) { setValue("invite_url", m); emit inviteUrlChanged(); }
void Settings::setPushTimeAMPM(int m) { setValue("push_time_ampm", m); emit pushTimeAMPMChanged(); }
void Settings::setPushTimeHour(int m) { setValue("push_time_hour", m); emit pushTimeHourChanged();}
void Settings::setPushTimeMinutes(int m) { setValue("push_time_minutes", m); emit pushTimeMinutesChanged();}
void Settings::setHeightStatusBar(int m) { setValue("height_status_bar", m); emit heightStatusBarChanged(); }
void Settings::setHeightBottomArea(int m) { setValue("height_bottom_area", m); emit heightBottomAreaChanged(); }
void Settings::setFontSizeDeliveryBtn(int m) { setValue("font_size_delivery_btn", m); emit fontSizeDeliveryBtnChanged(); }
void Settings::setNoShowNoticePopupNo(int m) { setValue("no_show_notice_popup_no", m); emit noShowNoticePopupNoChanged();}
void Settings::setHideGuide(bool m) { setValue("hide_guide", m); emit hideGuideChanged(); }
