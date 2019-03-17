#ifndef MAINACTIVITY_JNI_H
#define MAINACTIVITY_JNI_H

#include <jni.h>
#include "../src/native_app.h"

extern "C"
{
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_resume(JNIEnv *env, jobject obj);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_pause(JNIEnv *env, jobject obj);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_loginFinished(JNIEnv *env, jobject obj, jboolean isSuccess, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_logoutFinished(JNIEnv *env, jobject obj, jboolean isSuccess);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyTokenInfo(JNIEnv *env, jobject obj, jboolean isSuccess, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_withdrawFinished(JNIEnv *env, jobject obj, jboolean isSuccess);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_inviteFinished(JNIEnv *env, jobject obj, jboolean isSuccess);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notificated(JNIEnv *env, jobject obj, jint type, jstring message, jint no1, jint no2);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_readNotice(JNIEnv *env, jobject obj, jint no);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_setNativeChanner(JNIEnv *env, jobject obj, jint channer);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_setRequestNativeBackBehavior(JNIEnv *env, jobject obj);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_forcePortrait(JNIEnv *env, jobject obj, jboolean m);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_setVideoStatus(JNIEnv *env, jobject obj, jint status);
  JNIEXPORT bool JNICALL Java_com_codymonster_ibeobom_MainActivity_checkSignature(JNIEnv *env, jobject obj, jstring sig);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_exitFromUI(JNIEnv *env, jobject obj);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifySecured(JNIEnv *env, jobject obj);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndLoginResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndLogoutResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndJoinResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndGetCourseDetailResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndCertificateResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndCheckCertificationSMSResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndDuplicateIDResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndDuplicateNicknameResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndWithdrawResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndSetPushStatusResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndFindIDResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndFindPasswordResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndUpdatePasswordResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndGetMyPageCourseResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndGetMyPageLogResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndSetPushDateTimeResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndGetUserProfileResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndUpdateUserProfileResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndGetSystemNoticeListResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndGetSystemNoticeDetailResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndUploadImageFileResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndUploadFileResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndDeleteFileResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndGetMainResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndGetCourseBoardListResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndGetCourseBoardDetailResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndSetCourseBoardArticleResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndSetCourseBoardArticleRepleResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndUpdateCourseBoardArticleResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndUpdateCourseBoardArticleRepleResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndDeleteCourseBoardArticleResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndDeleteCourseBoardArticleRepleResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndSetBoardReportResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndGetClipListResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndGetClipDetailResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndGetClipDetailForDeliveryResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndSetQuizResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndGetClipSharingResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndSetClipLikeResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndGetClipRepleListResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndSetClipRepleResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndSetClipRepleReportResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndSetClipRepleLikeResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndUpdateClipResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndDeleteClipResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndGetOtherUserProfileResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndSetUserProfileReportResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndUpdateStudyTimeResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndSetDeliveryServiceResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndSetUnitCompleteResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndGetSearchMainResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndGetClipLikeListResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndGetRepleLikeListResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndGetRankingMainResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndGetSavingDetailResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndGetSpendingDetailResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndGetApplyEventListResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndGetApplyEventDetailResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndSetApplyEventResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndGetUserPointResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndGetMyAlarmListResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndDeleteMyAlarmResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndGetSystemFAQListResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndGetSystemFAQDetailResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndGetSystemInfoResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndSetPushkeyResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndSetContactUSResult(JNIEnv *env, jobject obj, jstring result);
  JNIEXPORT void JNICALL Java_com_codymonster_ibeobom_MainActivity_notifyAndSetDeliveryServiceConfirmResult(JNIEnv *env, jobject obj, jstring result);

//  JNIEXPORT void JNICALL
//  Java_com_rena_focustimer_MainActivity_backPressed(JNIEnv *env, jobject obj);

//  JNIEXPORT void JNICALL
//  Java_com_rena_focustimer_MainActivity_updateUser(JNIEnv *env, jobject obj,
//                                               jstring media, jstring userKey, jstring userName, jstring userProfileImage);

//  JNIEXPORT void JNICALL
//  Java_com_rena_focustimer_MainActivity_loginMediaFinished(JNIEnv *env, jobject obj,
//                                                  jboolean isSuccess);
//  JNIEXPORT void JNICALL
//  Java_com_rena_focustimer_MainActivity_logoutMediaFinished(JNIEnv *env, jobject obj,
//                                                  jboolean isSuccess);

//  JNIEXPORT void JNICALL
//  Java_com_rena_focustimer_MainActivity_gcmReceivedNotice(JNIEnv *env, jobject obj, jint type, jstring msg);

//	JNIEXPORT void JNICALL
//    Java_com_rena_focustimer_MainActivity_openUrlFinished(JNIEnv *env, jobject obj, jboolean isSuccess);
}


#endif // MAINACTIVITY_JNI_H

