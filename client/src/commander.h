#ifndef COMMANDER_H
#define COMMANDER_H

#include <QObject>
#include "native_app.h"
#include "imagepicker.h"
#include <QTextCodec>
#include <QTextEncoder>

class Settings;
class DBManager;
class Me;
class Commander : public QObject
{
    Q_OBJECT

public:
    static Commander* getInstance()
    {
        if (m_instance == nullptr)
            m_instance = new Commander();
        return m_instance;
    }

public slots:

    void joinSNS();

    void joinKakao();

    void loginKakao();
    void logoutKakao();
    void withdrawKakao();
    void inviteKakao();
    void shareKakao();

	void loginFacebook();
	void logoutFacebook();
	void withdrawFacebook();
    void inviteFacebook();
    void shareFacebook();

    void setStatusBarColor(QString color);

    void onLoginSuccess(const char* result);
    void onLoginFailed(const char* result);

    void onLogoutSuccess();
    void onLogoutFailed();

    void onWithdrawSuccess();
    void onWithdrawFailed();

    void onInviteSuccess();
    void onInviteFailed();

    int isOnline();
    bool isInstalledApp(QString nameOrScheme);
    float versionOS();

    bool needUpdate();
    QString getDeviceId();


    void openImagePicker();
    void openImageCamera();
    void clearImagePickerSlots();

    void onImagePickerResult(QString imagePath);
    QString resizeImage(QString path, int width=1024, int height=1024);
    QString getProfileImage(QString path);
    QString getProfileThumbImage(QString path);

    void dbReadAll();
    void readAdditionPushItems();
    void removePushItem(int no);
    void readPushItem(int no, bool read);
    void processNotifyResult(int type, QString message, int no1, int no2, bool isRead);

//    void readPushParamNo(int pushType, int deliveryType);

    void exit();

    QString currency(int number) { return QString("%L1").arg(number); }

    int checkID(QString id);
    int checkPass(QString pass);
    int checkNickname(QString nickname);
    int checkPhone(QString phone);
    int checkEmail(QString email);
    int checkBirth(QString birth);

    qint64 getLeftTime();

    void toast(QString message);
    void execTimer(bool state);
    int getTimerSec();

    void readSearchLogAll();
    void removeSearchLog(int row);
    void updateSearchLog(QString keyword);
    void updateSearchLogDate(int row);
    void removeSearchLogAll();

    QString readText();

signals:
    void imagePathChanged(QString imagePath);
    void imagePickerResult(QString imagePath, QString imageName);

private:
    Commander(QObject *parent = NULL);
    ~Commander();

    NativeApp* app;
    static Commander* m_instance;

    Settings* m_settings;
    Me* me;
    DBManager* m_dbms;

    ImagePicker* m_picker = nullptr;
    void empty() { }

    void message(QString msg);
};

#endif // COMMANDER_H
