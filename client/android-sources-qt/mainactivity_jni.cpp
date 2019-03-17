#include "mainactivity_jni.h"
//#include "../src/native_app.h"


void Java_com_codymonster_ibeobom_MainActivity_resume(JNIEnv *env, jobject obj)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        app = NativeApp::getInstance();
        app->resume();
    }
}

void Java_com_codymonster_ibeobom_MainActivity_pause(JNIEnv *env, jobject obj)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        app = NativeApp::getInstance();
        app->pause();
    }
}

void Java_com_codymonster_ibeobom_MainActivity_loginFinished(JNIEnv *env, jobject obj, jboolean isSuccess, jstring result)
{
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){

        const char * qresult = env->GetStringUTFChars(result, NULL);
        app->notifyLoginResult(isSuccess, qresult);
    }
}

void Java_com_codymonster_ibeobom_MainActivity_logoutFinished(JNIEnv *env, jobject obj, jboolean isSuccess)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){

        app->notifyLogoutResult(isSuccess);
    }
}

void Java_com_codymonster_ibeobom_MainActivity_withdrawFinished(JNIEnv *env, jobject obj, jboolean isSuccess)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        app->notifyWithdrawResult(isSuccess);
    }
}


void Java_com_codymonster_ibeobom_MainActivity_inviteFinished(JNIEnv *env, jobject obj, jboolean isSuccess)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        app->notifyInviteResult(isSuccess);
    }
}

void Java_com_codymonster_ibeobom_MainActivity_notifyTokenInfo(JNIEnv *env, jobject obj, jboolean isSuccess, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        const char* qresult = env->GetStringUTFChars(result, NULL);
        app->notifyTokenInfo(isSuccess, qresult);
    }
}

 void Java_com_codymonster_ibeobom_MainActivity_notificated(JNIEnv *env, jobject obj, jint type, jstring message, jint no1, jint no2)
{
     Q_UNUSED(env)
     Q_UNUSED(obj)

     NativeApp* app = NativeApp::getInstance();
     if(app)
     {
         const char* qmessage = env->GetStringUTFChars(message, NULL);
         app->notifyNotificated((int)type, qmessage, (int)no1, (int)no2, true);
     }
}

void Java_com_codymonster_ibeobom_MainActivity_readNotice(JNIEnv *env, jobject obj, jint no)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        app = NativeApp::getInstance();
        app->readNotice((int)no);
    }
}

void Java_com_codymonster_ibeobom_MainActivity_setNativeChanner(JNIEnv *env, jobject obj, jint channer)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        app->setNativeChanner((int) channer);
    }
}

void Java_com_codymonster_ibeobom_MainActivity_setRequestNativeBackBehavior(JNIEnv *env, jobject obj)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        app->setRequestNativeBackBehavior();
    }
}

void Java_com_codymonster_ibeobom_MainActivity_forcePortrait(JNIEnv *env, jobject obj, jboolean m)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        app->forcePortrait(m);
    }
}

void Java_com_codymonster_ibeobom_MainActivity_setVideoStatus(JNIEnv *env, jobject obj, jint status)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        app->setVideoStatus((int) status);
    }
}

bool Java_com_codymonster_ibeobom_MainActivity_checkSignature(JNIEnv *env, jobject obj, jstring sig)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(sig, 0));
        app->checkSignature(qstr);
    }
}

void Java_com_codymonster_ibeobom_MainActivity_exitFromUI(JNIEnv *env, jobject obj)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        app->exitFromUI();
    }
}

void Java_com_codymonster_ibeobom_MainActivity_notifySecured(JNIEnv *env, jobject obj)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        app->notifySecured();
    }
}

void Java_com_codymonster_ibeobom_MainActivity_notifyAndLoginResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndLoginResult(qstr);
    }
}

void Java_com_codymonster_ibeobom_MainActivity_notifyAndJoinResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndJoinResult(qstr);
    }
}

void Java_com_codymonster_ibeobom_MainActivity_notifyAndLogoutResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndLogoutResult(qstr);
    }
}

void Java_com_codymonster_ibeobom_MainActivity_notifyAndGetCourseDetailResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndGetCourseDetailResult(qstr);
    }
}

void Java_com_codymonster_ibeobom_MainActivity_notifyAndCertificateResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifiyAndCertificateResult(qstr);
    }
}

void Java_com_codymonster_ibeobom_MainActivity_notifyAndCheckCertificationSMSResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndCheckCertificationSMSResult(qstr);
    }
}

void Java_com_codymonster_ibeobom_MainActivity_notifyAndDuplicateIDResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndDuplicateIDResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndDuplicateNicknameResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndDuplicateNicknameResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndWithdrawResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndWithdrawResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndSetPushStatusResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndSetPushStatusResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndFindIDResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndFindIDResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndFindPasswordResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndFindPasswordResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndUpdatePasswordResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndUpdatePasswordResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndGetMyPageCourseResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndGetMyPageCourseResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndGetMyPageLogResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndGetMyPageLogResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndSetPushDateTimeResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndSetPushDateTimeResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndGetUserProfileResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndGetUserProfileResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndUpdateUserProfileResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndUpdateUserProfileResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndGetSystemNoticeListResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndGetSystemNoticeListResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndGetSystemNoticeDetailResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndGetSystemNoticeDetailResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndUploadImageFileResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndUploadImageFileResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndUploadFileResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndUploadFileResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndDeleteFileResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndDeleteFileResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndGetMainResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndGetMainResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndGetCourseBoardListResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndGetCourseBoardListResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndGetCourseBoardDetailResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndGetCourseBoardDetailResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndSetCourseBoardArticleResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndSetCourseBoardArticleResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndSetCourseBoardArticleRepleResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndSetCourseBoardArticleRepleResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndUpdateCourseBoardArticleResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndUpdateCourseBoardArticleResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndUpdateCourseBoardArticleRepleResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndUpdateCourseBoardArticleRepleResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndDeleteCourseBoardArticleResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndDeleteCourseBoardArticleResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndDeleteCourseBoardArticleRepleResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndDeleteCourseBoardArticleRepleResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndSetBoardReportResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndSetBoardReportResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndGetClipListResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndGetClipListResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndGetClipDetailResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndGetClipDetailResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndGetClipDetailForDeliveryResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndGetClipDetailForDeliveryResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndSetQuizResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndSetQuizResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndGetClipSharingResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndGetClipSharingResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndSetClipLikeResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndSetClipLikeResult(qstr);
    }
}

void Java_com_codymonster_ibeobom_MainActivity_notifyAndGetClipRepleListResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndGetClipRepleListResult(qstr);
    }
}

void Java_com_codymonster_ibeobom_MainActivity_notifyAndSetClipRepleResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndSetClipRepleResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndSetClipRepleReportResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndSetClipRepleReportResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndSetClipRepleLikeResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndSetClipRepleLikeResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndUpdateClipResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndUpdateClipResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndDeleteClipResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndDeleteClipResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndGetOtherUserProfileResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndGetOtherUserProfileResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndSetUserProfileReportResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndSetUserProfileReportResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndUpdateStudyTimeResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndUpdateStudyTimeResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndSetDeliveryServiceResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndSetDeliveryServiceResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndSetUnitCompleteResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndSetUnitCompleteResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndGetSearchMainResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndGetSearchMainResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndGetClipLikeListResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndGetClipLikeListResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndGetRepleLikeListResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndGetRepleLikeListResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndGetRankingMainResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndGetRankingMainResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndGetSavingDetailResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndGetSavingDetailResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndGetSpendingDetailResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndGetSpendingDetailResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndGetApplyEventListResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndGetApplyEventListResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndGetApplyEventDetailResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndGetApplyEventDetailResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndSetApplyEventResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndSetApplyEventResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndGetUserPointResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndGetUserPointResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndGetMyAlarmListResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndGetMyAlarmListResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndDeleteMyAlarmResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndDeleteMyAlarmResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndGetSystemFAQListResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndGetSystemFAQListResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndGetSystemFAQDetailResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndGetSystemFAQDetailResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndGetSystemInfoResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndGetSystemInfoResult(qstr);
    }
}
void Java_com_codymonster_ibeobom_MainActivity_notifyAndSetPushkeyResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndSetPushkeyResult(qstr);
    }
}

void Java_com_codymonster_ibeobom_MainActivity_notifyAndSetContactUSResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndSetContactUSResult(qstr);
    }
}

void Java_com_codymonster_ibeobom_MainActivity_notifyAndSetDeliveryServiceConfirmResult(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    NativeApp* app = NativeApp::getInstance();
    if(app){
        QString qstr(env->GetStringUTFChars(result, 0));
        app->notifyAndSetDeliveryServiceConfirmResult(qstr);
    }
}

//void Java_com_codymonster_ibeobom_MainActivity_setVideoStatus(JNIEnv *env, jobject obj, jint status)
//{
//    Q_UNUSED(env)
//    Q_UNUSED(obj)

//    NativeApp* app = NativeApp::getInstance();
//    if(app){
//        app->setVideoStatus((int) status);
//    }
//}

//void Java_org_koreatech_trizcartoon_MainActivity_backPressed(JNIEnv *env, jobject obj)
//{
//  Q_UNUSED(env)
//  Q_UNUSED(obj)

//  if(native){
//    NativeApp* app = native;
//    app->backPressed();
//  }
//}

//void Java_org_koreatech_trizcartoon_MainActivity_updateUser(JNIEnv *env, jobject obj,
//                                                                    jstring media, jstring userKey, jstring userName, jstring userProfileImage )
//{
//    Q_UNUSED(env)
//    Q_UNUSED(obj)

//    //int newAmount = (int) value;
//    //int oldMoney = MainAppInterface::instance()->facebookHashKey();
//    //MainAppInterface::instance()->setFacebookHashKey(oldMoney + newAmount);
//    const char * mediaChar = env->GetStringUTFChars(media, NULL);
//    const char * userKeyChar = env->GetStringUTFChars(userKey, NULL);
//    const char * userNameChar = env->GetStringUTFChars(userName, NULL);
//    const char * userProfileImageChar = env->GetStringUTFChars(userProfileImage, NULL);

//    NativeApp* app = native;
//    app->setUserData(QString(mediaChar == NULL ? "": mediaChar),
//                         QString(userKeyChar == NULL ? "": userKeyChar),
//                         QString(userNameChar == NULL ? "": userNameChar),
//                         QString(userProfileImageChar == NULL ? "": userProfileImageChar));
//}

//void Java_org_koreatech_trizcartoon_MainActivity_loginMediaFinished(JNIEnv *env, jobject obj,
//                                                                        jboolean isSuccess)
//{
//    Q_UNUSED(env)
//    Q_UNUSED(obj)

//    //int newAmount = (int) value;
//    //int oldMoney = MainAppInterface::instance()->facebookHashKey();
//    //MainAppInterface::instance()->setFacebookHashKey(oldMoney + newAmount);
//    MainAppInterface* mainApp = app;
//    mainApp->setLoginMediaFinished(isSuccess);
//}


//void Java_org_koreatech_trizcartoon_MainActivity_logoutMediaFinished(JNIEnv *env, jobject obj,
//                                                                        jboolean isSuccess)
//{
//    Q_UNUSED(env)
//    Q_UNUSED(obj)

//    //int newAmount = (int) value;
//    //int oldMoney = MainAppInterface::instance()->facebookHashKey();
//    //MainAppInterface::instance()->setFacebookHashKey(oldMoney + newAmount);
//    MainAppInterface* mainApp = app;
//    mainApp->setLogoutMediaFinished(isSuccess);
//}

//void Java_org_koreatech_trizcartoon_MainActivity_gcmReceivedNotice(JNIEnv *env, jobject obj, jint type, jstring msg)
//{
//  Q_UNUSED(env)
//  Q_UNUSED(obj)

//  const char * msgChar = env->GetStringUTFChars(msg, NULL);
//  MainAppInterface* mainApp = app;
//  mainApp->gcmReceivedNotice((int)type, QString(msgChar == NULL ? "": msgChar));
//}

//void  Java_org_koreatech_trizcartoon_MainActivity_openUrlFinished(JNIEnv *env, jobject obj, jboolean isSuccess)
//{
//	Q_UNUSED(env)
//	Q_UNUSED(obj)

//	MainAppInterface* mainApp = app;
//	mainApp->setOpenUrlFinished(isSuccess);
//}
