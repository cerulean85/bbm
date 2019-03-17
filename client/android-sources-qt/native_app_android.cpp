#include <QAndroidJniEnvironment>
#include <QAndroidJniObject>
#include <QtAndroid>
#include <QDebug>
#include <QDir>
#include "../src/native_app.h"
#include "../src/model.h"

QString NativeApp::getDeviceId()
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    QAndroidJniObject result = activity.callObjectMethod<jstring>("getDeviceId");

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        qCritical("Something Was Wrong!!");
        return "";
    }
    return result.toString();
}

QString NativeApp::getDeviceName()
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    QAndroidJniObject result = activity.callObjectMethod<jstring>("getDeviceName");

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        qCritical("Something Was Wrong!!");
        return "";
    }
    return result.toString();
}

QString NativeApp::getPushkey()
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    QAndroidJniObject result = activity.callObjectMethod<jstring>("getPushkey");

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        qCritical("Something Was Wrong!!");
        return "";
    }
    return result.toString();
}

bool NativeApp::needUpdate()
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    jboolean jresult = activity.callMethod<jboolean>("needUpdate", "()Z");

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        qCritical("Something Was Wrong!!");
        return "";
    }
    return (bool)jresult;
}
QString NativeApp::getPhoneNumber()
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    QAndroidJniObject result = activity.callObjectMethod<jstring>("getPhoneNumber");

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        qCritical("Something Was Wrong!!");
        return "";
    }
    return result.toString();
}

float NativeApp::versionOS()
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    jint result = activity.callMethod<jint>("versionSDK", "()I");

    QAndroidJniEnvironment env;
    if(env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        qCritical("Something Was Wrong!!!");
        return false;
    }
    return (float)result;
}

QString NativeApp::appVersionName()
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    QAndroidJniObject result = activity.callObjectMethod<jstring>("appVersionName");

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        qCritical("Something Was Wrong!!");
        return "";
    }
    return result.toString();
}

bool NativeApp::isInstalledApp(QString nameOrScheme)
{
    QAndroidJniObject jsNameOrScheme = QAndroidJniObject::fromString(nameOrScheme);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    jboolean jresult = activity.callMethod<jboolean>("isInstalledApp", "(Ljava/lang/String;)Z", jsNameOrScheme.object<jstring>());

    QAndroidJniEnvironment env;
    if(env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        qCritical("Something Was Wrong!!!");
        return false;
    }
    return (bool)jresult;
}

int NativeApp::isOnline()
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    jint jresult = activity.callMethod<jint>("isOnline", "()I");

    QAndroidJniEnvironment env;
    if(env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        qCritical("Something Was Wrong!!!");
        return false;
    }
    return (int)jresult;
}

void NativeApp::joinKakao()
{

}

void NativeApp::loginKakao()
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("loginKakao", "()V");

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}

void NativeApp::logoutKakao()
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("logoutKakao", "()V");

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}

void NativeApp::withdrawKakao()
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("withdrawKakao", "()V");

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}

void NativeApp::inviteKakao(QString senderId, QString image, QString title, QString desc, QString link)
{
    QAndroidJniObject idStr = QAndroidJniObject::fromString(senderId);
    QAndroidJniObject imageStr = QAndroidJniObject::fromString(image);
    QAndroidJniObject titleStr = QAndroidJniObject::fromString(title);
    QAndroidJniObject descStr = QAndroidJniObject::fromString(desc);
    QAndroidJniObject linkStr = QAndroidJniObject::fromString(link);

    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("inviteKakao", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V",
                              idStr.object<jstring>(), imageStr.object<jstring>(), titleStr.object<jstring>(), descStr.object<jstring>(), linkStr.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}

void NativeApp::shareKakao(QString senderId, QString image, QString title, QString desc, QString link)
{
    QAndroidJniObject idStr = QAndroidJniObject::fromString(senderId);
    QAndroidJniObject imageStr = QAndroidJniObject::fromString(image);
    QAndroidJniObject titleStr = QAndroidJniObject::fromString(title);
    QAndroidJniObject descStr = QAndroidJniObject::fromString(desc);
    QAndroidJniObject linkStr = QAndroidJniObject::fromString(link);

    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("shareKakao", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V",
                              idStr.object<jstring>(), imageStr.object<jstring>(), titleStr.object<jstring>(), descStr.object<jstring>(), linkStr.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}

void NativeApp::loginFacebook()
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("loginFacebook", "()V");

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}

void NativeApp::logoutFacebook()
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("logoutFacebook", "()V");

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}

void NativeApp::withdrawFacebook()
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("withdrawFacebook", "()V");

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}

void NativeApp::inviteFacebook(QString senderId, QString image, QString title, QString desc, QString link)
{
    QAndroidJniObject idStr = QAndroidJniObject::fromString(senderId);
    QAndroidJniObject imageStr = QAndroidJniObject::fromString(image);
    QAndroidJniObject titleStr = QAndroidJniObject::fromString(title);
    QAndroidJniObject descStr = QAndroidJniObject::fromString(desc);
    QAndroidJniObject linkStr = QAndroidJniObject::fromString(link);

    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("inviteFacebook", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V",
                              idStr.object<jstring>(), imageStr.object<jstring>(), titleStr.object<jstring>(), descStr.object<jstring>(), linkStr.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}
void NativeApp::shareFacebook(QString senderId, QString image, QString title, QString desc, QString link)
{
    QAndroidJniObject idStr = QAndroidJniObject::fromString(senderId);
    QAndroidJniObject imageStr = QAndroidJniObject::fromString(image);
    QAndroidJniObject titleStr = QAndroidJniObject::fromString(title);
    QAndroidJniObject descStr = QAndroidJniObject::fromString(desc);
    QAndroidJniObject linkStr = QAndroidJniObject::fromString(link);

    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("inviteFacebook", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V",
                              idStr.object<jstring>(), imageStr.object<jstring>(), titleStr.object<jstring>(), descStr.object<jstring>(), linkStr.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}

void NativeApp::setStatusBarColor(QString colorString)
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("setStatusBarColor", "(Ljava/lang/String;)V",
                              QAndroidJniObject::fromString(colorString).object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}

void NativeApp::exitApp()
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("exitApp", "()V");

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}

void NativeApp::openMarket()
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("openMarket", "()V");

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}

void NativeApp::sendMail(QString destination, QString title, QString contents)
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("sendMail", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V",
                              QAndroidJniObject::fromString(destination).object<jstring>(),
                              QAndroidJniObject::fromString(title).object<jstring>(),
                              QAndroidJniObject::fromString(contents).object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}


void NativeApp::toast(QString message)
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("toast", "(Ljava/lang/String;)V",
                              QAndroidJniObject::fromString(message).object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}

void NativeApp::execTimer(bool state)
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("execTimer", "(Z)V", state);

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}

int NativeApp::getTimerSec()
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    jint jresult = activity.callMethod<jint>("getTimerSec", "()I");

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }

    return (int)jresult;
}


int NativeApp::getStatusBarHeight()
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    jint jresult = activity.callMethod<jint>("getStatusBarHeight", "()I");

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }

    return (int)jresult;
}

bool NativeApp::isRunning()
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    jboolean jresult = activity.callMethod<jboolean>("isRunning", "()Z");

    QAndroidJniEnvironment env;
    if(env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        qCritical("Something Was Wrong!!!");
        return false;
    }
    return (bool)jresult;
}

void NativeApp::bringNotifyResult()
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("notifyResult", "()V");

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}

QString NativeApp::convertToUnicode(QString contents)
{
    QAndroidJniObject jContents = QAndroidJniObject::fromString(contents);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    QAndroidJniObject result = activity.callObjectMethod("convertToUnicode", "(Ljava/lang/String;)Ljava/lang/String;", jContents.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return "";
    }

    return result.toString();
}

QString NativeApp::convertFromUnicode(QString contents)
{
    QAndroidJniObject jContents = QAndroidJniObject::fromString(contents);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    QAndroidJniObject result = activity.callObjectMethod("convertFromUnicode", "(Ljava/lang/String;)Ljava/lang/String;", jContents.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return "";
    }

    return result.toString();
}

void NativeApp::showStatusBar(bool isShow)
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("showStatusBar", "(Z)V", isShow);

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}

void NativeApp::setOrientation(int type)
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("setOrientation", "(I)V", type);

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}

void NativeApp::checkStatusBar(bool check)
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("checkStatusBar", "(Z)V", check);

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}

QString NativeApp::encrypted(QString str)
{
    QAndroidJniObject jStr = QAndroidJniObject::fromString(str);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    QAndroidJniObject result = activity.callObjectMethod("encrypted", "(Ljava/lang/String;)Ljava/lang/String;", jStr.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return "";
    }
    return result.toString();
}

QString NativeApp::decrypted(QString str)
{
    QAndroidJniObject jStr = QAndroidJniObject::fromString(str);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    QAndroidJniObject result = activity.callObjectMethod("decrypted", "(Ljava/lang/String;)Ljava/lang/String;", jStr.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return "";
    }
    return result.toString();
}

bool NativeApp::isSystemSecured()
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    jboolean jresult = activity.callMethod<jboolean>("isSystemSecured", "()Z");

    QAndroidJniEnvironment env;
    if(env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        qCritical("Something Was Wrong!!!");
        return false;
    }

    bool result = (bool)jresult;
    if(result)
    {
        activity = QtAndroid::androidActivity();
        activity.callMethod<void>("setSystemSecured", "(Z)V", false);

        QAndroidJniEnvironment env;
        if (env->ExceptionCheck())
        {
            env->ExceptionDescribe();
            env->ExceptionClear();
        }
        return true;
    }
    else return false;
}

void NativeApp::andLogin(QString id, QString pass, QString snsType)
{
    QAndroidJniObject jId = QAndroidJniObject::fromString(id);
    QAndroidJniObject jPass = QAndroidJniObject::fromString(pass);
    QAndroidJniObject jSnsType = QAndroidJniObject::fromString(snsType);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("loginAnd", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", jId.object<jstring>(), jPass.object<jstring>(), jSnsType.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}

void NativeApp::andCheckCertificationSMS(QString phone, QString nums)
{
    QAndroidJniObject jPhone = QAndroidJniObject::fromString(phone);
    QAndroidJniObject jNums = QAndroidJniObject::fromString(nums);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("checkCertificationSMS", "(Ljava/lang/String;Ljava/lang/String;)V", jPhone.object<jstring>(), jNums.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}

void NativeApp::andJoin(QString id, QString pass, QString name,
                                 QString nickname, QString birth, QString gender,
                                 QString phone, QString osType, QString deviceID,
                                 QString deviceName, QString snsType, QString pushKey,
                                 QString email, QString snsAccessToken, QString snsRefreshToken,
                                 QString agreeUse, QString agreeUserInfo, QString agreeThird, QString agreeEvent)
{
    QAndroidJniObject jId = QAndroidJniObject::fromString(id);
    QAndroidJniObject jPass = QAndroidJniObject::fromString(pass);
    QAndroidJniObject jName = QAndroidJniObject::fromString(name);
    QAndroidJniObject jNickname = QAndroidJniObject::fromString(nickname);
    QAndroidJniObject jBirth = QAndroidJniObject::fromString(birth);
    QAndroidJniObject jGender = QAndroidJniObject::fromString(gender);
    QAndroidJniObject jPhone = QAndroidJniObject::fromString(phone);
    QAndroidJniObject jOsType = QAndroidJniObject::fromString(osType);
    QAndroidJniObject jDeviceID = QAndroidJniObject::fromString(deviceID);
    QAndroidJniObject jDeviceName = QAndroidJniObject::fromString(deviceName);
    QAndroidJniObject jSnsType = QAndroidJniObject::fromString(snsType);
    QAndroidJniObject jPushKey = QAndroidJniObject::fromString(pushKey);
    QAndroidJniObject jEmail = QAndroidJniObject::fromString(email);
    QAndroidJniObject jSnsAccessToken = QAndroidJniObject::fromString(snsAccessToken);
    QAndroidJniObject jSnsRefreshToken = QAndroidJniObject::fromString(snsRefreshToken);
    QAndroidJniObject jAgreeUse = QAndroidJniObject::fromString(agreeUse);
    QAndroidJniObject jAgreeUserInfo = QAndroidJniObject::fromString(agreeUserInfo);
    QAndroidJniObject jAgreeThird = QAndroidJniObject::fromString(agreeThird);
    QAndroidJniObject jAgreeEvent = QAndroidJniObject::fromString(agreeEvent);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("joinAnd",
                              "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V",
                              jId.object<jstring>(), jPass.object<jstring>(), jName.object<jstring>(),
                              jNickname.object<jstring>(), jBirth.object<jstring>(),  jGender.object<jstring>(),
                              jPhone.object<jstring>(), jOsType.object<jstring>(),  jDeviceID.object<jstring>(),
                              jDeviceName.object<jstring>(), jSnsType.object<jstring>(), jPushKey.object<jstring>(),
                              jEmail.object<jstring>(), jSnsAccessToken.object<jstring>(),  jSnsRefreshToken.object<jstring>(),
                              jAgreeUse.object<jstring>(), jAgreeUserInfo.object<jstring>(), jAgreeThird.object<jstring>(), jAgreeEvent.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}
void NativeApp::andCertificate(QString phone)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(phone);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("certificate", "(Ljava/lang/String;)V", jP1.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}
void NativeApp::andDuplicateID(QString id)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(id);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("duplicateID", "(Ljava/lang/String;)V", jP1.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}
void NativeApp::andDuplicateNickname(QString nickname)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(nickname);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("duplicateNickname", "(Ljava/lang/String;)V", jP1.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}
int NativeApp::andLogout()
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("logoutAnd", "()V");

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
int NativeApp::andWithdraw(QString comment)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(comment);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("withdrawAnd", "(Ljava/lang/String;)V", jP1.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
void NativeApp::andSetPushStatus(QString pushStatus)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(pushStatus);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("setPushStatus", "(Ljava/lang/String;)V", jP1.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}
void NativeApp::andFindID(QString name, QString birth, QString phone)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(name);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(birth);
    QAndroidJniObject jP3 = QAndroidJniObject::fromString(phone);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("findID", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", jP1.object<jstring>(), jP2.object<jstring>(), jP3.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}
void NativeApp::andFindPassword(QString id, QString email)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(id);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(email);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("findPassword", "(Ljava/lang/String;Ljava/lang/String;)V", jP1.object<jstring>(), jP2.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}
int NativeApp::andUpdatePassword(QString oldPass, QString newPass)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(oldPass);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(newPass);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("updatePassword", "(Ljava/lang/String;Ljava/lang/String;)V", jP1.object<jstring>(), jP2.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
int NativeApp::andGetMyPageCourse()
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("getMyPageCourse", "()V");

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
int NativeApp::andGetMyPageLog(QString pageNo)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(pageNo);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("getMyPageLog", "(Ljava/lang/String;)V", jP1.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
int NativeApp::andSetPushDateTime(QString time)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(time);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("setPushDateTime", "(Ljava/lang/String;)V", jP1.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
int NativeApp::andGetUserProfile()
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("getUserProfile", "()V");

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
int NativeApp::andUpdateUserProfile(QString profileImage, QString profileThumbUrl, QString name, QString birth, QString gender, QString email, QString isImageFileModify)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(profileImage);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(profileThumbUrl);
    QAndroidJniObject jP3 = QAndroidJniObject::fromString(name);
    QAndroidJniObject jP4 = QAndroidJniObject::fromString(birth);
    QAndroidJniObject jP5 = QAndroidJniObject::fromString(gender);
    QAndroidJniObject jP6 = QAndroidJniObject::fromString(email);
    QAndroidJniObject jP7 = QAndroidJniObject::fromString(isImageFileModify);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("updateUserProfile", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V",
                              jP1.object<jstring>(),
                              jP2.object<jstring>(),
                              jP3.object<jstring>(),
                              jP4.object<jstring>(),
                              jP5.object<jstring>(),
                              jP6.object<jstring>(),
                              jP7.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
void NativeApp::andGetSystemNoticeList(QString noticeType, QString pageNo)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(noticeType);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(pageNo);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("getSystemNoticeList", "(Ljava/lang/String;Ljava/lang/String;)V", jP1.object<jstring>(),  jP2.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}
void NativeApp::andGetSystemNoticeDetail(QString boardArticleNo, QString boardNo)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(boardArticleNo);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(boardNo);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("getSystemNoticeDetail", "(Ljava/lang/String;Ljava/lang/String;)V", jP1.object<jstring>(), jP2.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}
void NativeApp::andUploadImageFile(QString filename, QString fileurl)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(filename);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(fileurl);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("uploadImageFile", "(Ljava/lang/String;Ljava/lang/String;)V", jP1.object<jstring>(), jP2.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}
void NativeApp::andUploadFile(QString filename, QString boardArticleNo, QString boardNo, QString fileurl)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(filename);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(boardArticleNo);
    QAndroidJniObject jP3 = QAndroidJniObject::fromString(boardNo);
    QAndroidJniObject jP4 = QAndroidJniObject::fromString(fileurl);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("uploadFile", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V",
                              jP1.object<jstring>(), jP2.object<jstring>(), jP3.object<jstring>(), jP4.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}
void NativeApp::andDeleteFile(QString fileNo)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(fileNo);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("_deleteFile", "(Ljava/lang/String;)V", jP1.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}
void NativeApp::andGetMain(QString nowPage, QString categoryNo)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(nowPage);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(categoryNo);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("getMain", "(Ljava/lang/String;Ljava/lang/String;)V", jP1.object<jstring>(), jP2.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}

int NativeApp::andGetCourseDetail(QString courseNo)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(courseNo);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("getCourseDetail", "(Ljava/lang/String;)V", jP1.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}

int NativeApp::andGetCourseBoardList(QString nowPage, QString boardNo)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(nowPage);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(boardNo);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("getCourseBoardList", "(Ljava/lang/String;Ljava/lang/String;)V", jP1.object<jstring>(), jP2.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
int NativeApp::andGetCourseBoardDetail(QString nowPage, QString boardNo, QString boardArticleNo)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(nowPage);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(boardNo);
    QAndroidJniObject jP3 = QAndroidJniObject::fromString(boardArticleNo);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("getCourseBoardDetail", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", jP1.object<jstring>(), jP2.object<jstring>(), jP3.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
int NativeApp::andSetCourseBoardArticle(QString boardNo, QString title, QString contents)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(boardNo);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(title);
    QAndroidJniObject jP3 = QAndroidJniObject::fromString(contents);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("setCourseBoardArticle", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", jP1.object<jstring>(), jP2.object<jstring>(), jP3.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
int NativeApp::andSetCourseBoardArticleReple(QString boardNo, QString boardArticleNo, QString contents)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(boardNo);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(boardArticleNo);
    QAndroidJniObject jP3 = QAndroidJniObject::fromString(contents);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("setCourseBoardArticleReple", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", jP1.object<jstring>(), jP2.object<jstring>(), jP3.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
int NativeApp::andUpdateCourseBoardArticle(QString boardNo, QString boardArticleNo, QString title, QString contents)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(boardNo);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(boardArticleNo);
    QAndroidJniObject jP3 = QAndroidJniObject::fromString(title);
    QAndroidJniObject jP4 = QAndroidJniObject::fromString(contents);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("updateCourseBoardArticle", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", jP1.object<jstring>(), jP2.object<jstring>(), jP3.object<jstring>(), jP4.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
int NativeApp::andUpdateCourseBoardArticleReple(QString repleNo, QString contents)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(repleNo);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(contents);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("updateCourseBoardArticleReple", "(Ljava/lang/String;Ljava/lang/String;)V", jP1.object<jstring>(), jP2.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
int NativeApp::andDeleteCourseBoardArticle(QString boardNo, QString boardArticleNo)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(boardNo);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(boardArticleNo);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("deleteCourseBoardArticle", "(Ljava/lang/String;Ljava/lang/String;)V", jP1.object<jstring>(), jP2.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
int NativeApp::andDeleteCourseBoardArticleReple(QString repleNo)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(repleNo);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("deleteCourseBoardArticleReple", "(Ljava/lang/String;)V", jP1.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
int NativeApp::andSetBoardReport(QString boardNo, QString boardArticleNo, QString repleNo, QString reportType, QString reason)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(boardNo);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(boardArticleNo);
    QAndroidJniObject jP3 = QAndroidJniObject::fromString(repleNo);
    QAndroidJniObject jP4 = QAndroidJniObject::fromString(reportType);
    QAndroidJniObject jP5 = QAndroidJniObject::fromString(reason);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("setBoardReport", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V",
                              jP1.object<jstring>(), jP2.object<jstring>(), jP3.object<jstring>(), jP4.object<jstring>(), jP5.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
int NativeApp::andGetClipList(QString courseNo)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(courseNo);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("getClipList", "(Ljava/lang/String;)V", jP1.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
int NativeApp::andGetClipDetail(QString lessonSubNo, QString courseNo)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(lessonSubNo);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(courseNo);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("getClipDetail", "(Ljava/lang/String;Ljava/lang/String;)V", jP1.object<jstring>(), jP2.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
int NativeApp::andGetClipDetailForDelivery(QString lessonSubNo, QString courseNo)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(lessonSubNo);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(courseNo);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("getClipDetailForDelivery", "(Ljava/lang/String;Ljava/lang/String;)V", jP1.object<jstring>(), jP2.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
int NativeApp::andSetQuiz(QString quizNo, QString answerType, QString exampleNo, QString lessonSubitemNo, QString courseNo)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(quizNo);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(answerType);
    QAndroidJniObject jP3 = QAndroidJniObject::fromString(exampleNo);
    QAndroidJniObject jP4 = QAndroidJniObject::fromString(lessonSubitemNo);
    QAndroidJniObject jP5 = QAndroidJniObject::fromString(courseNo);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("setQuiz", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V",
                              jP1.object<jstring>(), jP2.object<jstring>(), jP3.object<jstring>(), jP4.object<jstring>(), jP5.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
void NativeApp::andGetClipSharing(QString lessonSubitemNo)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(lessonSubitemNo);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("getClipSharing", "(Ljava/lang/String;)V", jP1.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}
int NativeApp::andSetClipLike(QString courseNo, QString lessonSubitemNo, QString isLike)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(courseNo);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(lessonSubitemNo);
    QAndroidJniObject jP3 = QAndroidJniObject::fromString(isLike);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("setClipLike", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", jP1.object<jstring>(), jP2.object<jstring>(), jP3.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
void NativeApp::andGetClipRepleList(QString lessonSubitemNo, QString filterType, QString nowPage)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(lessonSubitemNo);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(filterType);
    QAndroidJniObject jP3 = QAndroidJniObject::fromString(nowPage);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("getClipRepleList", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", jP1.object<jstring>(), jP2.object<jstring>(), jP3.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}
int NativeApp::andSetClipReple(QString boardNo, QString contents, QString unitAttachFileName, QString unitAttachImageUrl, QString unitAttachThumbnailUrl)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(boardNo);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(contents);
    QAndroidJniObject jP3 = QAndroidJniObject::fromString(unitAttachFileName);
    QAndroidJniObject jP4 = QAndroidJniObject::fromString(unitAttachImageUrl);
    QAndroidJniObject jP5 = QAndroidJniObject::fromString(unitAttachThumbnailUrl);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("setClipReple", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V",
                              jP1.object<jstring>(), jP2.object<jstring>(), jP3.object<jstring>(), jP4.object<jstring>(), jP5.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
int NativeApp::andSetClipRepleReport(QString boardArticleNo, QString boardNo, QString reason)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(boardArticleNo);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(boardNo);
    QAndroidJniObject jP3 = QAndroidJniObject::fromString(reason);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("setClipRepleReport", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", jP1.object<jstring>(), jP2.object<jstring>(), jP3.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
int NativeApp::andSetClipRepleLike(QString boardArticleNo, QString boardNo, QString isLike)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(boardArticleNo);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(boardNo);
    QAndroidJniObject jP3 = QAndroidJniObject::fromString(isLike);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("setClipRepleLike", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", jP1.object<jstring>(), jP2.object<jstring>(), jP3.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
int NativeApp::andUpdateClip(QString boardArticleNo, QString boardNo, QString contents, QString modifyFile, QString unitAttachFileName, QString unitAttachImageUrl, QString unitAttachThumbnailUrl)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(boardArticleNo);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(boardNo);
    QAndroidJniObject jP3 = QAndroidJniObject::fromString(contents);
    QAndroidJniObject jP4 = QAndroidJniObject::fromString(modifyFile);
    QAndroidJniObject jP5 = QAndroidJniObject::fromString(unitAttachFileName);
    QAndroidJniObject jP6 = QAndroidJniObject::fromString(unitAttachImageUrl);
    QAndroidJniObject jP7 = QAndroidJniObject::fromString(unitAttachThumbnailUrl);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("updateClip", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V",
                              jP1.object<jstring>(), jP2.object<jstring>(), jP3.object<jstring>(), jP4.object<jstring>(), jP5.object<jstring>(), jP6.object<jstring>(), jP7.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
int NativeApp::andDeleteClip(QString boardArticleNo, QString boardNo)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(boardArticleNo);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(boardNo);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("deleteClip", "(Ljava/lang/String;Ljava/lang/String;)V", jP1.object<jstring>(), jP2.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
void NativeApp::andGetOtherUserProfile(QString targetUserNo)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(targetUserNo);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("getOtherUserProfile", "(Ljava/lang/String;)V", jP1.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}
int NativeApp::andSetUserProfileReport(QString targetUserNo, QString reason)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(targetUserNo);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(reason);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("setUserProfileReport", "(Ljava/lang/String;Ljava/lang/String;)V", jP1.object<jstring>(), jP2.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
int NativeApp::andUpdateStudyTime(QString lessonSubitemNo, QString studyTime)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(lessonSubitemNo);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(studyTime);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("updateStudyTime", "(Ljava/lang/String;Ljava/lang/String;)V", jP1.object<jstring>(), jP2.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
int NativeApp::andSetDeliveryService(QString courseNo)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(courseNo);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("setDeliveryService", "(Ljava/lang/String;)V", jP1.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
int NativeApp::andSetUnitComplete(QString lessonSubmitNo, QString courseNo)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(lessonSubmitNo);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(courseNo);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("setUnitComplete", "(Ljava/lang/String;Ljava/lang/String;)V", jP1.object<jstring>(), jP2.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
int NativeApp::andSetDeliveryServiceConfirm(QString courseNo)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(courseNo);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("setDeliveryServiceConfirm", "(Ljava/lang/String;)V", jP1.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
void NativeApp::andGetSearchMain(QString nowPage, QString searchKeyword, QString searchType)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(nowPage);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(searchKeyword);
    QAndroidJniObject jP3 = QAndroidJniObject::fromString(searchType);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("getSearchMain", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", jP1.object<jstring>(), jP2.object<jstring>(), jP3.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}
void NativeApp::andGetClipLikeList(QString nowPage)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(nowPage);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("getClipLikeList", "(Ljava/lang/String;)V", jP1.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}
void NativeApp::andGetRepleLikeList(QString nowPage)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(nowPage);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("getRepleLikeList", "(Ljava/lang/String;)V", jP1.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}
void NativeApp::andGetRankingMain()
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("getRankingMain", "()V");

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}
void NativeApp::andGetSavingDetail(QString nowPage)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(nowPage);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("getSavingDetail", "(Ljava/lang/String;)V", jP1.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}
void NativeApp::andGetSpendingDetail(QString nowPage)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(nowPage);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("getSpendingDetail", "(Ljava/lang/String;)V", jP1.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}
void NativeApp::andGetApplyEventList()
{

    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("getApplyEventList", "()V");

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}
void NativeApp::andGetApplyEventDetail(QString prizeNo)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(prizeNo);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("getApplyEventDetail", "(Ljava/lang/String;)V", jP1.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}
int NativeApp::andSetApplyEvent(QString prizeNo, QString appliedText, QString appliedImageUrl)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(prizeNo);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(appliedText);
    QAndroidJniObject jP3 = QAndroidJniObject::fromString(appliedImageUrl);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("setApplyEvent", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", jP1.object<jstring>(), jP2.object<jstring>(), jP3.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
int NativeApp::andGetUserPoint()
{

    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("getUserPoint", "(Ljava/lang/String;)V");

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
int NativeApp::andGetMyAlarmList(QString nowPage)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(nowPage);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("getMyAlarmList", "(Ljava/lang/String;)V", jP1.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
int NativeApp::andDeleteMyAlarm(QString alarmNo)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(alarmNo);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("deleteMyAlarm", "(Ljava/lang/String;)V", jP1.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
void NativeApp::andGetSystemFAQList()
{

    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("getSystemFAQList", "()V");

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}
void NativeApp::andGetSystemFAQDetail(QString faqNo)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(faqNo);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("getSystemFAQDetail", "(Ljava/lang/String;)V", jP1.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}
void NativeApp::andGetSystemInfo()
{

    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("getSystemInfo", "()V");

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}
void NativeApp::andSetPushkey(QString devceID, QString osType, QString deviceName, QString pushkey)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(devceID);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(osType);
    QAndroidJniObject jP3 = QAndroidJniObject::fromString(deviceName);
    QAndroidJniObject jP4 = QAndroidJniObject::fromString(pushkey);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("setPushkey", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V",
                              jP1.object<jstring>(), jP2.object<jstring>(), jP3.object<jstring>(), jP4.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}
int NativeApp::andSetContactUS(QString email, QString contents, QString title, QString courseNo)
{
    QAndroidJniObject jP1 = QAndroidJniObject::fromString(email);
    QAndroidJniObject jP2 = QAndroidJniObject::fromString(contents);
    QAndroidJniObject jP3 = QAndroidJniObject::fromString(title);
    QAndroidJniObject jP4 = QAndroidJniObject::fromString(courseNo);
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("setContactUS", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", jP1.object<jstring>(), jP2.object<jstring>(), jP3.object<jstring>(), jP4.object<jstring>());

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return 0;
    }
    return 1;
}
