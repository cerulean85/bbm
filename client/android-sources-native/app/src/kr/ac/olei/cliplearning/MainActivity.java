package com.codymonster.ibeobom;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.ActivityManager;
import android.app.ActivityManager.RunningAppProcessInfo;
import android.content.SharedPreferences;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.BroadcastReceiver;
import android.os.Build;
import android.os.Bundle;
import android.os.AsyncTask;
import android.os.Environment;
import android.view.Window;
import android.view.WindowManager;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.net.Uri;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.provider.MediaStore;
import android.Manifest;
import android.widget.Toast;
import android.support.v4.content.FileProvider;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import com.google.android.gms.ads.identifier.AdvertisingIdClient;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.common.GooglePlayServicesNotAvailableException;
import com.google.android.gms.common.GooglePlayServicesRepairableException;
import com.google.android.gms.gcm.GoogleCloudMessaging;
import com.kakao.auth.ApiResponseCallback;
import com.kakao.auth.AuthService;
import com.kakao.auth.ISessionCallback;
import com.kakao.auth.Session;
import com.kakao.auth.network.response.AccessTokenInfoResponse;
import com.kakao.network.ErrorResult;
import com.kakao.usermgmt.UserManagement;
import com.kakao.usermgmt.callback.UnLinkResponseCallback;
import com.kakao.usermgmt.callback.MeResponseCallback;
import com.kakao.usermgmt.callback.LogoutResponseCallback;
import com.kakao.usermgmt.response.model.UserProfile;
import com.kakao.kakaolink.v2.KakaoLinkService;
import com.kakao.kakaolink.v2.KakaoLinkResponse;
import com.kakao.util.exception.KakaoException;
import com.kakao.util.helper.log.Logger;
import com.kakao.util.KakaoParameterException;
import com.kakao.network.callback.ResponseCallback;
import com.kakao.message.template.FeedTemplate;
import com.kakao.message.template.LinkObject;
import com.kakao.message.template.ContentObject;
import com.facebook.AccessToken;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookSdk;
import com.facebook.GraphRequest;
import com.facebook.GraphResponse;
import com.facebook.HttpMethod;
import com.facebook.appevents.AppEventsLogger;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;
import com.facebook.Profile;
import com.facebook.share.ShareApi;
import com.facebook.share.Sharer;
import com.facebook.share.model.ShareLinkContent;
import com.facebook.share.widget.ShareDialog;
import org.json.JSONObject;
import org.json.JSONException;
import java.util.ArrayList;
import java.util.List;
import java.util.Arrays;
import java.util.Date;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.view.ViewGroup.LayoutParams;
import android.graphics.Color;
import android.view.View;
import java.lang.Thread;
import java.lang.Runnable;
import java.util.TimerTask;
import java.util.Timer;
import android.content.res.Resources;
import java.io.UnsupportedEncodingException;
import org.apache.commons.lang3.StringEscapeUtils;
import java.io.InputStream;
import android.os.StrictMode;
import android.view.KeyEvent;
import android.content.pm.ActivityInfo;
import android.graphics.Rect;
import java.io.FileOutputStream;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.lang.OutOfMemoryError;
import java.io.IOException;
import android.media.ExifInterface;
import android.graphics.Bitmap;
import android.graphics.Matrix;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.BitmapFactory;
import android.graphics.Bitmap.Config;
import android.graphics.BitmapFactory.Options;
import android.os.Handler;
import android.os.Message;
import com.codymonster.ibeobom.RSA;

import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import android.util.Base64;
import java.security.MessageDigest;
import android.content.pm.Signature;
import java.io.ByteArrayOutputStream;
import java.io.BufferedReader;
import java.io.FileReader;
import android.os.AsyncTask;
import android.content.ContentValues;
import com.codymonster.ibeobom.RequestHttpURLConnection;
import android.content.SharedPreferences;
import android.content.ContentValues;
import android.support.v4.content.LocalBroadcastManager;

import java.io.FileNotFoundException;
import java.lang.SecurityException;
import java.lang.IllegalArgumentException;

import android.support.multidex.MultiDex;

public class MainActivity extends org.qtproject.qt5.android.bindings.QtActivity
{
    /* Multidex support */
     @Override
     protected void attachBaseContext(Context base) {
         super.attachBaseContext(base);
         MultiDex.install(this);
     }

    private native void resume();
    private native void pause();
    private native void setNativeChanner(int channer);
    private native void setRequestNativeBackBehavior();
    private native void loginFinished(boolean isSuccess, String result);
    private native void logoutFinished(boolean isSuccess);
    private native void withdrawFinished(boolean isSuccess);
    private native void inviteFinished(boolean isSuccess);
    private native void notifyTokenInfo(boolean isSuccess, String result);
    private native void readNotice(int no);
    private native void notificated(int type, String message, int no1, int no2);
    private native void forcePortrait(boolean state);
    private native void setVideoStatus(int status);
    private native boolean checkSignature(String sig);
    private native void exitFromUI();
    private native void notifySecured();

    private native void notifyAndLoginResult(String result);
    private native void notifyAndLogoutResult(String result);
    private native void notifyAndJoinResult(String result);
    private native void notifyAndCertificateResult(String result);
    private native void notifyAndDuplicateIDResult(String result);
    private native void notifyAndDuplicateNicknameResult(String result);
    private native void notifyAndWithdrawResult(String result);
    private native void notifyAndSetPushStatusResult(String result);
    private native void notifyAndFindIDResult(String result);
    private native void notifyAndFindPasswordResult(String result);
    private native void notifyAndUpdatePasswordResult(String result);
    private native void notifyAndGetMyPageCourseResult(String result);
    private native void notifyAndGetMyPageLogResult(String result);
    private native void notifyAndSetPushDateTimeResult(String result);
    private native void notifyAndGetUserProfileResult(String result);
    private native void notifyAndUpdateUserProfileResult(String result);
    private native void notifyAndGetSystemNoticeListResult(String result);
    private native void notifyAndGetSystemNoticeDetailResult(String result);
    private native void notifyAndCheckCertificationSMSResult(String result);
    private native void notifyAndUploadImageFileResult(String result);
    private native void notifyAndUploadFileResult(String result);
    private native void notifyAndDeleteFileResult(String result);
    private native void notifyAndGetMainResult(String result);
    private native void notifyAndGetCourseDetailResult(String result);
    private native void notifyAndGetCourseBoardListResult(String result);
    private native void notifyAndGetCourseBoardDetailResult(String result);
    private native void notifyAndSetCourseBoardArticleResult(String result);
    private native void notifyAndSetCourseBoardArticleRepleResult(String result);
    private native void notifyAndUpdateCourseBoardArticleResult(String result);
    private native void notifyAndUpdateCourseBoardArticleRepleResult(String result);
    private native void notifyAndDeleteCourseBoardArticleResult(String result);
    private native void notifyAndDeleteCourseBoardArticleRepleResult(String result);
    private native void notifyAndSetBoardReportResult(String result);
    private native void notifyAndGetClipListResult(String result);
    private native void notifyAndGetClipDetailResult(String result);
    private native void notifyAndGetClipDetailForDeliveryResult(String result);
    private native void notifyAndSetQuizResult(String result);
    private native void notifyAndGetClipSharingResult(String result);
    private native void notifyAndSetClipLikeResult(String result);
    private native void notifyAndGetClipRepleListResult(String result);
    private native void notifyAndSetClipRepleResult(String result);
    private native void notifyAndSetClipRepleReportResult(String result);
    private native void notifyAndSetClipRepleLikeResult(String result);
    private native void notifyAndUpdateClipResult(String result);
    private native void notifyAndDeleteClipResult(String result);
    private native void notifyAndGetOtherUserProfileResult(String result);
    private native void notifyAndSetUserProfileReportResult(String result);
    private native void notifyAndUpdateStudyTimeResult(String result);
    private native void notifyAndSetDeliveryServiceResult(String result);
    private native void notifyAndSetDeliveryServiceConfirmResult(String result);
    private native void notifyAndSetUnitCompleteResult(String result);
    private native void notifyAndGetSearchMainResult(String result);
    private native void notifyAndGetClipLikeListResult(String result);
    private native void notifyAndGetRepleLikeListResult(String result);
    private native void notifyAndGetRankingMainResult(String result);
    private native void notifyAndGetSavingDetailResult(String result);
    private native void notifyAndGetSpendingDetailResult(String result);
    private native void notifyAndGetApplyEventListResult(String result);
    private native void notifyAndGetApplyEventDetailResult(String result);
    private native void notifyAndSetApplyEventResult(String result);
    private native void notifyAndGetUserPointResult(String result);
    private native void notifyAndGetMyAlarmListResult(String result);
    private native void notifyAndDeleteMyAlarmResult(String result);
    private native void notifyAndGetSystemFAQListResult(String result);
    private native void notifyAndGetSystemFAQDetailResult(String result);
    private native void notifyAndGetSystemInfoResult(String result);
    private native void notifyAndSetPushkeyResult(String result);
    private native void notifyAndSetContactUSResult(String result);

    private static final int PLAY_SERVICES_RESOLUTION_REQUEST = 9000;
    private static final String PROPERTY_REG_ID = "registration_id";
    private static final String PROPERTY_APP_VERSION = "appVersion";
    private static final String TAG = "CLIP LEARNING LOG MESSAGE";

    private String mSenderID = "841388040800";
    private Context mContext;
    private String mRegID;
    private Window mWindow;
    private RSA mRSA = null;

    public enum LoginType
    {
        NONE(0), EMAIL(1), KAKAO(2), FACEBOOK(3);
        private int value;
        private LoginType(int value) { this.value = value; }
        public int getValue() {  return this.value; }
    }
    private LoginType requestedSNSType = LoginType.NONE;
    private GoogleCloudMessaging mGcm;
    private SessionCallback mSessionCallback;
    private CallbackManager mCallbackManager;
    private GcmMessage mGCMCommonMessage = null;

    private static final String ROOT_PATH = Environment.getExternalStorageDirectory() + "";
    private String[] RootFilesPath = new String[]{
        ROOT_PATH + "/system/bin/su",
        ROOT_PATH + "/system/xbin/su",
        ROOT_PATH + "/sbin/su",
        ROOT_PATH + "/system/su",
        ROOT_PATH + "/system/bin/.ext/.su",
        ROOT_PATH + "/system/usr/su-backup",
        ROOT_PATH + "/system/xbin/mu",
        ROOT_PATH + "/system/app/SuperUser.apk",
        ROOT_PATH + "/system/app/su.apk",
        ROOT_PATH + "/system/app/Spapasu.apk",
        ROOT_PATH + "/data/data/com.noshufou.android.su"
    };

    private boolean checkRooting() {

        try {
            Runtime.getRuntime().exec("su");
            return true;
        } catch (IOException e) {

            File[] rootingFiles = new File[RootFilesPath.length];
            for(int i=0 ; i < RootFilesPath.length; i++){
               rootingFiles[i] = new File(RootFilesPath[i]);
            }

            boolean result = false;
            for(File f : rootingFiles) {
                if(f != null && f.exists() && f.isFile()){
                    result = true;
                } else {
                    result = false;
                }
            }
            return result;
        }
    }

    private String getSignature()
    {
        PackageManager pm = mContext.getPackageManager();
        String packageName = mContext.getPackageName();
        String cert = null;
        try {
            PackageInfo packageInfo = pm.getPackageInfo(packageName, PackageManager.GET_SIGNATURES);
            Signature certSignature = packageInfo.signatures[0];
            MessageDigest msgDigest = MessageDigest.getInstance("SHA-256");
            msgDigest.update(certSignature.toByteArray());
            cert = Base64.encodeToString(msgDigest.digest(), Base64.DEFAULT);
            return cert;

        } catch(PackageManager.NameNotFoundException e) {
            System.out.println("An error has occured.");

        } catch(NoSuchAlgorithmException e) {
            System.out.println("An error has occured.");

        }
        return "";
    }

    private void printSignature(String type)
    {
        PackageManager pm = mContext.getPackageManager();
        String packageName = mContext.getPackageName();
        String cert = "";
        try {
            PackageInfo packageInfo = pm.getPackageInfo(packageName, PackageManager.GET_SIGNATURES);
            Signature certSignature = packageInfo.signatures[0];
            MessageDigest msgDigest = MessageDigest.getInstance(type);
            msgDigest.update(certSignature.toByteArray());
            cert = Base64.encodeToString(msgDigest.digest(), Base64.NO_WRAP);

        } catch(PackageManager.NameNotFoundException e) {
            printd("KeyHash: None");
//            System.out.println("An error has occured.");
            return;

        } catch(NoSuchAlgorithmException e) {
//            System.out.println("An error has occured.");
            printd("KeyHash: None");
            return;

        }
        printd("KeyHash: " + cert);
    }

    private void checkAndExit(String message, int mSec)
    {
        toast(message);
        Runnable mRunnable = new Runnable() {
            @Override
            public void run() {
                exitApp();
            }
        };
        Handler mHandler = new Handler();
        mHandler.postDelayed(mRunnable, mSec);
    }

    private void initialize()
    {
        if(checkPlayServices()) {
            mGcm = GoogleCloudMessaging.getInstance(this);
            mRegID = getRegistrationId(mContext);
            printd("Registration ID: " + mRegID);
            if (mRegID.isEmpty()) {
                registerInBackground();
            }
        } else {
            printd("No valid Google Play Services APK found.");
        }

        mSessionCallback = new SessionCallback();
        Session.getCurrentSession().addCallback(mSessionCallback);

        AppEventsLogger.activateApp(getApplication());
        mCallbackManager = CallbackManager.Factory.create();

        mWindow = this.getWindow();

        Intent intent = getIntent();
        if(intent==null) return;

        Bundle extras = intent.getExtras();
        if(extras != null)
        {
            if(extras.containsKey("gcm_message"))
                mGCMCommonMessage = (GcmMessage) intent.getSerializableExtra("gcm_message");
        }

        StrictMode.VmPolicy.Builder builder = new StrictMode.VmPolicy.Builder();
        StrictMode.setVmPolicy(builder.build());
    }

    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        mContext = getApplicationContext();

        printSignature("SHA");

        /* Check Rooting. */
        if(checkRooting()) checkAndExit("루팅폰에서는 앱을 이용하실 수 없습니다.", 500);
        //////////////////////////////////////////////////////////////////////////////////////////////////

        /* Check Online, Integrity */
        if(isOnline() > 0) (new IntegrityCheckTask()).execute();
        else checkAndExit("네트워크가 연결되어 있지 않습니다. 네트워크 상태를 확인해주세요.", 500);
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////

//        if(verifyGoogleInstaller(mContext))
//            checkAndExit("앱 설치 경로가 올바르지 않습니다.", 500);

        checkPermissions();

//        setFocusableInTouchMode(true);

//        SharedPreferences pref = getSharedPreferences("pref", MODE_PRIVATE);
//        boolean installed = pref.getBoolean("app-installed", false);
//        if(!installed)
//        {
//            SharedPreferences.Editor editor = pref.edit();
//            editor.putBoolean("app-installed", true);
//            editor.commit();
//        }
    }

    public void setPublicKey(String key)
    {
        if(mRSA==null) mRSA = new RSA();
        mRSA.setPublicKey(key);
    }
    public void setPrivateKey(String key)
    {
        if(mRSA==null) mRSA = new RSA();
        mRSA.setPrivateKey(key);
    }

    public String encrypted(String str)
    {
        return str;
//        return mRSA.encrypted(str);
    }

    public String decrypted(String str)
    {
        return str;
//        return mRSA.decrypted(str);
    }


    @Override
    public void onResume()
    {
        super.onResume();
        checkPlayServices();

        if(pausedByButton)
        {
            setOrientation(currentOrientationType);  // return the current orientation.
            pausedByButton = false;
        }
    }


    @Override
    public void onStart()
    {
        super.onStart();
    }

    @Override
    public void onStop() { super.onStop(); }

    private boolean runOnApp = false;
    private boolean pausedByButton = false;
    @Override
    protected void onUserLeaveHint() {
        super.onUserLeaveHint();

        if(!runOnApp)
        {
            runOnApp = true;
            return;
        }

        pausedByButton = true;
    }

    @Override
    protected void onPause()
    {
        if(pausedByButton)
        {
            setVideoStatus(0);
            currentOrientationType = orientationType; // save the current orientation.
            setOrientation(0); //  force the portrait.
            try {
                printd("재생 중인 비디오를 정지합니다.");
                Thread.sleep(3000);
            } catch(InterruptedException e) {
                printd("재생 중인 비디오를 정지할 수 없습니다.");
            }
        }

        super.onPause();
    }

    @Override
    protected void onDestroy()
    {
        super.onDestroy();
        Session.getCurrentSession().removeCallback(mSessionCallback);
    }

    @Override
    public void onNewIntent(Intent intent)
    {
        super.onNewIntent(intent);
        if(intent == null) return;

        Bundle extras = intent.getExtras();
        if(extras != null)
        {
            if(extras.containsKey("gcm_message"))
            {
                mGCMCommonMessage = (GcmMessage) intent.getSerializableExtra("gcm_message");
                notifyResult();
            }
        }
    }

    public void notifyResult()
    {
        if(mGCMCommonMessage != null)
        {
            printd("GCMessage Type: " + intToStr(mGCMCommonMessage.type) + ", no1: " + intToStr(mGCMCommonMessage.no1) + ", no2: " + intToStr(mGCMCommonMessage.no2));
            notificated(mGCMCommonMessage.type, mGCMCommonMessage.message, mGCMCommonMessage.no1, mGCMCommonMessage.no2);
        }
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {

        if( event.getAction() == KeyEvent.ACTION_DOWN) {

            if(keyCode == KeyEvent.KEYCODE_BACK)
            {
                setRequestNativeBackBehavior();
                return false;
            }
        }


        return super.onKeyDown( keyCode, event );
    }

    private String mStatusBarColor;
    public void setStatusBarColor(String color)
    {
        mStatusBarColor = color;
        new Thread(new Runnable()
        {
            @Override
            public void run()
            {
                runOnUiThread(new Runnable()
                {
                    @Override
                    public void run()
                    {
                        if (Build.VERSION.SDK_INT >= 23)
                        {
                            mWindow.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
                            mWindow.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
                            mWindow.setStatusBarColor(Color.parseColor(mStatusBarColor));
                            mWindow.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR);
                        }
                    }
                });
            }
        }).start();
    }

    private boolean isFullMode = false;
    private boolean isShowStatusbar = false;
    public void showStatusBar(boolean state)
    {
        isShowStatusbar = state;
        new Thread(new Runnable()
        {
            @Override
            public void run()
            {
                runOnUiThread(new Runnable()
                {
                    @Override
                    public void run()
                    {
                        if(isShowStatusbar)
                        {
                            isFullMode = false;
                            View decorView = getWindow().getDecorView();
                            int uiOptions = View.SYSTEM_UI_FLAG_VISIBLE;
                            decorView.setSystemUiVisibility(uiOptions);

                            if (Build.VERSION.SDK_INT >= 23)
                            {
                                mWindow.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
                                mWindow.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
                                mWindow.clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
                                mWindow.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION);
                                mWindow.setStatusBarColor(Color.parseColor(mStatusBarColor));
                                mWindow.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR);
                            }
                        }
                        else
                        {
                            isFullMode = true;
                            View decorView = getWindow().getDecorView();
                            int uiOptions = View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                                            | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                                            | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                                            | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                                            | View.SYSTEM_UI_FLAG_FULLSCREEN
                                            | View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY;

                            decorView.setSystemUiVisibility(uiOptions);

                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT)
                            {
                                mWindow.addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION);
                                mWindow.addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
                            }
                        }
                    }
                });
            }
        }).start();
    }



    private int orientationType = 0;
    private int currentOrientationType = 0;
    public void setOrientation(int type)
    {
        orientationType = type;
        new Thread(runOrientation()).start();
//        new Thread(new Runnable()
//        {
//            @Override
//            public void run()
//            {
//                runOnUiThread(new Runnable()
//                {
//                    @Override
//                    public void run()
//                    {
//                        if(orientationType==1) {
//                            setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
//                            forcePortrait(false);
//                        }
//                        else {
//                            setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
//                            forcePortrait(true);
//                        }
//                    }
//                });
//            }
//        }).start();
    }

    private Timer oriTmr = new Timer();
    private void returnOrientationOnTimer()
    {
//        oriTmr.schedule(new TimerTask()
//        {
//            @Override
//            public void run()
//            {
//                setOrientation(currentOrientationType);
//                oriTmr.cancel();
//            }
//        }, 1000, 0);
    }

    private Runnable runOrientation()
    {
        return (new Runnable()
        {
            @Override
            public void run()
            {
                runOnUiThread(new Runnable()
                {
                    @Override
                    public void run()
                    {
                        if(orientationType==1) {
                            setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
                            forcePortrait(false);
                        }
                        else {
                            setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
                            forcePortrait(true);
                        }
                    }
                });
            }
        });
    }

    private int m_sec = 0;
    private Timer mTimer;
    public void execTimer(boolean state)
    {
        if(state)
        {
            printd("Timer's called.");
            m_sec = 0;
            mTimer = new Timer();
            mTimer.schedule(new TimerTask()
            {
                @Override
                public void run()
                {
                    m_sec++;
                    printd("Timer's running, " + intToStr(m_sec) + "(s).");
                }
            }, 0, 1000);
        }
        else
        {
            m_sec = 0;
            mTimer.cancel();
        }
    }

    public void checkStatusBar(boolean check)
    {
        mTimer = new Timer();
        if(check)
        {
            mTimer.schedule(new TimerTask()
            {
                @Override
                public void run()
                {
//                    try{
                        new Thread(new Runnable()
                        {
                            @Override
                            public void run()
                            {
                                runOnUiThread(new Runnable()
                                {
                                    @Override
                                    public void run()
                                    {
                                        if(isFullMode && isStatusBarVisible())
                                            mWindow.addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
                                    }
                                });
                            }
                        }).start();
//                    } catch(Exception e) {
//                        mTimer.cancel();
//                    }
                }
            }, 0, 1000);
        }
        else
        {
            mTimer.cancel();
        }
    }

    public int getTimerSec() { return m_sec; }
    public int getStatusBarHeight()
    {
        int height = 0;
        Resources myResources = getResources();
        int idStatusBarHeight = myResources.getIdentifier("status_bar_height", "dimen", "android");
        if (idStatusBarHeight > 0) height = getResources().getDimensionPixelSize(idStatusBarHeight);
        return height;
    }

    public int versionSDK() { return Build.VERSION.SDK_INT; }
    public String appVersionName()
    {
        try {
            PackageInfo packageInfo = mContext.getPackageManager().getPackageInfo(mContext.getPackageName(), 0);
            return packageInfo.versionName;
        } catch (PackageManager.NameNotFoundException e) {
            throw new RuntimeException("Could not get package name: " + e);
        }
        }
    public String getDeviceId()
    {
        String deviceId = "";
        final TelephonyManager tm = (TelephonyManager) getApplicationContext().getSystemService(Context.TELEPHONY_SERVICE);
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            String imei = tm.getImei();
            deviceId = imei == null? tm.getMeid() : imei;
        } else {
            deviceId = tm.getDeviceId();
        }

        return deviceId;
    }
    public String getDeviceName()
    {
        return Build.MODEL;
    }
    public String getPushkey()
    {
        return mRegID;
    }

    public void exitApp()
    {
        moveTaskToBack(true);
        finish();
        android.os.Process.killProcess(android.os.Process.myPid());
    }
    public void openMarket()
    {
        Intent i = new Intent(Intent.ACTION_VIEW);
        i.setData(Uri.parse("market://details?id="+mContext.getPackageName()));
        startActivity(i);

    }

    public void sendMail(String destination, String title, String contents)
    {
        Intent email = new Intent(Intent.ACTION_SEND);
        email.setType("plain/text");
        String[] address = {destination};
        email.putExtra(Intent.EXTRA_EMAIL, address);
        email.putExtra(Intent.EXTRA_SUBJECT, title);
        email.putExtra(Intent.EXTRA_TEXT, contents);
        startActivity(email);
    }

    public boolean isStatusBarVisible()
    {
        Rect rectangle = new Rect();
        mWindow.getDecorView().getWindowVisibleDisplayFrame(rectangle);
        int statusBarHeight = rectangle.top;
        return statusBarHeight != 0;
    }


    public boolean isInstalledApp(String nameOrScheme)
    {
        boolean isSuccess = false;
        try {
            PackageInfo pi = mContext.getPackageManager().getPackageInfo(nameOrScheme, PackageManager.GET_ACTIVITIES);
            isSuccess = true;
        } catch (PackageManager.NameNotFoundException e) {
            isSuccess = false;
        }
        return isSuccess;
    }

    public int isOnline()
    {
        ConnectivityManager connectivityManager =
                (ConnectivityManager) getSystemService(CONNECTIVITY_SERVICE);
        NetworkInfo networkInfo = connectivityManager.getActiveNetworkInfo();

        if(networkInfo != null)
        {
            if(networkInfo.isConnected())
            {
                if(networkInfo.getType() == ConnectivityManager.TYPE_WIFI) return 1;
                else if(networkInfo.getType() == ConnectivityManager.TYPE_MOBILE) return 2;
            }
        }
        return 0;
    }

    public boolean needUpdate()
    {
        return false;
    }
    public boolean isRunning()
    {
        ActivityManager am = (ActivityManager) mContext.getSystemService(Context.ACTIVITY_SERVICE);
        List<RunningAppProcessInfo> procInfos = am.getRunningAppProcesses();
        for(int i=0; i<procInfos.size(); i++)
        {
            if(procInfos.get(i).processName.equals(mContext.getPackageName())) return true;
        }
        return false;
    }
    public String convertToUnicode(String contents)
    {
        return contents;
    }

    public String convertFromUnicode(String contents)
    {
        contents = StringEscapeUtils.unescapeJava(contents);
        return contents;
    }

    private String toastMessage;
    public void toast(String message)
    {
        toastMessage = message;
        new Thread(new Runnable()
        {
            @Override
            public void run()
            {
                runOnUiThread(new Runnable()
                {
                    @Override
                    public void run()
                    {
                        Toast.makeText(mContext, toastMessage, Toast.LENGTH_SHORT).show();
                    }
                });
           }
        }).start();
    }

    private String getRegistrationId(Context context) {
        final SharedPreferences prefs = getGCMPreferences(context);
        String registrationId = prefs.getString(PROPERTY_REG_ID, "");
        if (registrationId.isEmpty())  return "";

        int registeredVersion = prefs.getInt(PROPERTY_APP_VERSION, Integer.MIN_VALUE);
        int currentVersion = getAppVersion(context);
        if (registeredVersion != currentVersion) return "";
        return registrationId;
    }

    private SharedPreferences getGCMPreferences(Context context) {
        return getSharedPreferences(MainActivity.class.getSimpleName(),
                Context.MODE_PRIVATE);
    }

    private static int getAppVersion(Context context) {
        try {
            PackageInfo packageInfo = context.getPackageManager()
                    .getPackageInfo(context.getPackageName(), 0);
            return packageInfo.versionCode;
        } catch (PackageManager.NameNotFoundException e) {
            throw new RuntimeException("Could not get package name: " + e);
        }
    }

    private boolean checkPlayServices() {

        int resultCode = GoogleApiAvailability.getInstance().isGooglePlayServicesAvailable(this);

        if (resultCode != ConnectionResult.SUCCESS) {
            if (GooglePlayServicesUtil.isUserRecoverableError(resultCode)) {
                GooglePlayServicesUtil.getErrorDialog(resultCode, this, PLAY_SERVICES_RESOLUTION_REQUEST).show();
            } else {
                finish();
            }
            return false;
        }
        return true;
    }

    private void registerInBackground() {
        new AsyncTask<Void, Void, String>() {
            @Override
            protected String doInBackground(Void... params) {
                String msg = "";
                try {
                    if (mGcm == null) {
                        mGcm = GoogleCloudMessaging.getInstance(mContext);
                    }

                    mRegID = mGcm.register(mSenderID);
                    sendRegistrationIdToBackend();
                    storeRegistrationId(mContext, mRegID);
                } catch (IOException ex) {
                    msg = "Error :" + ex.getMessage();
                }
                return msg;
            }

            @Override
            protected void onPostExecute(String msg) {


            }

        }.execute(null, null, null);
    }

    private void storeRegistrationId(Context context, String regid) {
        final SharedPreferences prefs = getGCMPreferences(context);
        int appVersion = getAppVersion(context);
        SharedPreferences.Editor editor = prefs.edit();
        editor.putString(PROPERTY_REG_ID, regid);
        editor.putInt(PROPERTY_APP_VERSION, appVersion);
        editor.commit();
    }

    private void sendRegistrationIdToBackend() { }

    public void loginKakao()
    {
        requestedSNSType = LoginType.KAKAO;
        new KaKaoLoginControl(MainActivity.this).call();
    }

    public void logoutKakao()
    {
        UserManagement.getInstance().requestLogout(new LogoutResponseCallback() {
            @Override
            public void onCompleteLogout() {
                logoutFinished(true);
            }
        });
    }

    public void withdrawKakao()
    {
        UserManagement.getInstance().requestUnlink(new UnLinkResponseCallback() {
            @Override
            public void onFailure(ErrorResult errorResult) {
                withdrawFinished(false);
            }

            @Override
            public void onSessionClosed(ErrorResult errorResult) {
                withdrawFinished(false);
            }

            @Override
            public void onNotSignedUp() {

            }

            @Override
            public void onSuccess(Long result) {
                withdrawFinished(true);
            }
        });
    }

    public void inviteKakao(String senderId, String image, String title, String desc, String link)
    {
        FeedTemplate params = FeedTemplate
                .newBuilder(ContentObject.newBuilder(title,
                image,
                LinkObject.newBuilder().setWebUrl(link)
                        .setMobileWebUrl(link).build())
                .setDescrption(desc)
                .build())
                .build();

        KakaoLinkService.getInstance().sendDefault(this, params, new ResponseCallback<KakaoLinkResponse>() {
            @Override
            public void onFailure(ErrorResult errorResult) {



            }

            @Override
            public void onSuccess(KakaoLinkResponse result) { }
        });

    }

    public void shareKakao(String senderId, String image, String title, String desc, String link)
    {

        String templateId = "10611";

        Map<String, String> templateArgs = new HashMap<String, String>();
        templateArgs.put("IMAGE", image);
        templateArgs.put("TITLE", title);
        templateArgs.put("DESCRIPTION", link);

        KakaoLinkService.getInstance().sendCustom(this, templateId, templateArgs, new ResponseCallback<KakaoLinkResponse>() {
                @Override
                public void onFailure(ErrorResult errorResult) { }

                @Override
                public void onSuccess(KakaoLinkResponse result) { }
            });
    }

    private class SessionCallback implements ISessionCallback {
        @Override
        public void onSessionOpened() {
            List<String> propertyKeys = new ArrayList<String>();
            propertyKeys.add("kaccount_email");
            propertyKeys.add("nickname");
            propertyKeys.add("profile_image");
            propertyKeys.add("thumbnail_image");

            UserManagement.getInstance().requestMe(new MeResponseCallback() {
                @Override
                public void onFailure(ErrorResult errorResult)
                {
                    String message = "failed to get use rinfo. msg=" + errorResult;

                    String result = "";
                    JSONObject jObj = new JSONObject();
                    try {
                        jObj.put("is_logined", 0);
                        jObj.put("error_message", message);
                        result = jObj.toString();
                    } catch (JSONException e) {
                        System.out.println("An error has occured.");
                    }

                    loginFinished(true, result);
                }

                @Override
                public void onSessionClosed(ErrorResult errorResult)
                {
                    String message = "failed to get use rinfo. msg=" + errorResult;

                    String result = "";
                    JSONObject jObj = new JSONObject();
                    try {
                        jObj.put("is_logined", 0);
                        jObj.put("error_message", message);
                        result = jObj.toString();
                    } catch (JSONException e) {
                        System.out.println("An error has occured.");
                    }

                    loginFinished(true, result);
                }

                @Override
                public void onNotSignedUp()
                {

                }

                @Override
                public void onSuccess(UserProfile userProfile)
                {
                    requestAccessTokenInfo();

                    String result = "";
                    JSONObject jUserProfile = new JSONObject();
                    try {
                        jUserProfile.put("is_logined", 1);
                        jUserProfile.put("id", String.valueOf(userProfile.getId()));
                        jUserProfile.put("nickname", userProfile.getNickname());
                        jUserProfile.put("email", userProfile.getEmail());
                        jUserProfile.put("thumbnail_image", userProfile.getThumbnailImagePath());
                        jUserProfile.put("profile_image", userProfile.getProfileImagePath());
                        result = jUserProfile.toString();
                    } catch (JSONException e) {
                        System.out.println("An error has occured.");
                    }

                    loginFinished(true, result);
                }
            }, propertyKeys, false);
        }

        private void requestAccessTokenInfo()
        {
            AuthService.getInstance().requestAccessTokenInfo(new ApiResponseCallback<AccessTokenInfoResponse>() {
                @Override
                public void onSessionClosed(ErrorResult errorResult) {

                    String message = "failed to get access token info. msg=" + errorResult;
                    notifyTokenInfo(false, message);
                }

                @Override
                public void onNotSignedUp() {
                    // not happened
                }

                @Override
                public void onFailure(ErrorResult errorResult) {
                    String message = "failed to get token info. msg=" + errorResult;
                    notifyTokenInfo(false, message);
                }

                @Override
                public void onSuccess(AccessTokenInfoResponse accessTokenInfoResponse) {
                    long userId = accessTokenInfoResponse.getUserId();
                    long expiresInMilis = accessTokenInfoResponse.getExpiresInMillis();
                    Logger.d("this access token expires after " + expiresInMilis + " milliseconds.");
                    notifyTokenInfo(true, Long.toString(userId));
                }
            });
        }

        @Override
        public void onSessionOpenFailed(KakaoException exception) {
            if(exception != null) {
                Logger.e(exception);
            }
            loginFinished(false, "Can't Open Failed.");
        }
    }

    public void loginFacebook()
    {
//        AccessToken token = AccessToken.getCurrentAccessToken();
//        if(token != null) {
//            String result = "";
//            JSONObject jUserProfile = new JSONObject();
//            try {
//                jUserProfile.put("is_logined", 1);
//                result = jUserProfile.toString();
//            } catch (JSONException e) {
//                toast("로그인을 진행할 수 없습니다.");
//                return;
//            }

//            loginFinished(true, result);
//            return;
//        }

        requestedSNSType = LoginType.FACEBOOK;
        List<String> permissionNeeds= Arrays.asList(/*"user_photos, publish_actions", */"email", "public_profile");
        LoginManager.getInstance().logInWithReadPermissions(MainActivity.this, permissionNeeds);
        LoginManager.getInstance().registerCallback(mCallbackManager, new
                FacebookCallback<LoginResult>() {
                    @Override
                    public void onSuccess(LoginResult loginResult) {
                        GraphRequest graphRequest = GraphRequest.newMeRequest(loginResult.getAccessToken(), new GraphRequest.GraphJSONObjectCallback() {
                            @Override
                            public void onCompleted(JSONObject object, GraphResponse response) {
                                printd("result" + object.toString());

                                String result = "";
                                JSONObject jUserProfile = new JSONObject();
                                try {
//                                    jUserProfile.put("is_logined", false);
                                    jUserProfile.put("is_logined", 1);
                                    jUserProfile.put("id", object.getString("id"));
                                    jUserProfile.put("nickname", object.getString("name"));
                                    jUserProfile.put("email", object.getString("email"));

                                    String profile_image;
                                    Profile profile = Profile.getCurrentProfile();
                                    if(profile != null)
                                    {
                                        Uri ppUri = profile.getProfilePictureUri(200, 200);
                                        if(ppUri != null)
                                        {
                                            profile_image = ppUri.toString();
                                            jUserProfile.put("thumbnail_image", profile_image);
                                            jUserProfile.put("profile_image", profile_image);
                                        }
                                    }

                                    result = jUserProfile.toString();
                                    loginFinished(true, result);

                                } catch (JSONException e) {
//                                    e.printStackTrace();
                                    loginFinished(false, "Can't Open Failed.");
                                }
                            }
                        });

                        Bundle parameters = new Bundle();
                        parameters.putString("fields", "id,name,email,gender,birthday");
                        graphRequest.setParameters(parameters);
                        graphRequest.executeAsync();
                    }

                    @Override
                    public void onCancel() {

                    }

                    @Override
                    public void onError(FacebookException error) {

                        String result = "";
                        JSONObject jUserProfile = new JSONObject();
                        try {
                            jUserProfile.put("is_logined", 1);
                            jUserProfile.put("error_message", error.toString());
                            result = jUserProfile.toString();
                        } catch (JSONException e) {
                            toast("로그인을 진행할 수 없습니다.");
                        }

                        loginFinished(false, result);
                    }
                });
    }

    public void logoutFacebook()
    {
        LoginManager.getInstance().logOut();

        AccessToken token = AccessToken.getCurrentAccessToken();
        boolean isSuccess = true;
        if(token != null)
            isSuccess = false;

        logoutFinished(isSuccess);
    }

    public void withdrawFacebook()
    {
        new GraphRequest(
            AccessToken.getCurrentAccessToken(),
            "/me/permissions",
            null,
            HttpMethod.DELETE,
            new GraphRequest.Callback() {
                public void onCompleted(GraphResponse response) {

                    try {
                        boolean isSuccess = response.getJSONObject().getBoolean("success");
                        withdrawFinished(isSuccess);

                        if(isSuccess)
                            logoutFacebook();

                    } catch (JSONException e) {
                        System.out.println("An error has occured.");
                        printd("Facebook : Error fetching JSON");
                    }
                }
            }
        ).executeAsync();
    }

    public void inviteFacebook(String senderId, String image, String title, String desc, String link) {

        ShareLinkContent content = new ShareLinkContent.Builder()
            .setContentUrl(Uri.parse(link))
            .setQuote(desc)
            .build();

        ShareDialog shareDialog = new ShareDialog(this);
        shareDialog.show(content, ShareDialog.Mode.AUTOMATIC);
    }

    public void shareFacebook(String senderId, String image, String title, String desc, String link) {

        ShareLinkContent content = new ShareLinkContent.Builder()
            .setContentUrl(Uri.parse(link))
            .setQuote(desc)
            .build();

        ShareDialog shareDialog = new ShareDialog(this);
        shareDialog.show(content, ShareDialog.Mode.AUTOMATIC);
    }


    public void inviteSMS(String message)
    {
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.putExtra("sms_body", message);
        intent.setType("vnd.android-dir/mms-sms");
        startActivity(intent);
    }

    public void inviteEmail(String message)
    {
        Intent intent = new Intent(Intent.ACTION_SEND);
        intent.putExtra(Intent.EXTRA_TEXT, message);
        intent.setType("message/rfc822");
        startActivity(Intent.createChooser(intent, "Email"));
    }

    public Intent createPickImageAlbumIntent(){
        Intent intent = new Intent(Intent.ACTION_PICK);
        intent.setType("image/*");
        return intent;
    }

    private static final int PICK_FROM_CAMERA = 1;
    private static final int PICK_FROM_ALBUM = 2;
    private static final int CROP_FROM_CAMERA = 3;
    private static final int MULTIPLE_PERMISSIONS = 101;

    private String[] allowedPermissions = { Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.CAMERA, Manifest.permission.READ_PHONE_STATE };
    private boolean checkPermissions() {
        int result;
        List<String> permissionList = new ArrayList<>();
        for (String pm : allowedPermissions) {
            result = ContextCompat.checkSelfPermission(this, pm);
            if (result != PackageManager.PERMISSION_GRANTED) {
                permissionList.add(pm);
            }
        }
        if (!permissionList.isEmpty()) {
            ActivityCompat.requestPermissions(this, permissionList.toArray(new String[permissionList.size()]), MULTIPLE_PERMISSIONS);
            return false;
        }
        return true;
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults) {
        switch (requestCode) {
            case MULTIPLE_PERMISSIONS: {
                if (grantResults.length > 0) {
                    for (int i = 0; i < permissions.length; i++) {
                        for(int j = 0; j < allowedPermissions.length; j++) {
                            if (permissions[i].equals(allowedPermissions[j])) {
                                if (grantResults[i] != PackageManager.PERMISSION_GRANTED) {
                                    showNoPermissionToastAndFinish();
                                }
                                break;
                            }
                        }
                    }
                } else {
                    showNoPermissionToastAndFinish();
                }
                return;
            }
        }
    }

    private void showNoPermissionToastAndFinish() {
        toast("원활한 이용을 위는 [설정] > [애플리케이션] > [이버봄]에서 권한 허용을 하시기 바랍니다.");
//        finish();
    }
    private String cameraImagePath;
    public String getCameraImagePath() { return cameraImagePath; }

    private String mImageCaptureName;
    private String currentPhotoPath;
    private File createImageFile() throws IOException {
       // Create an image file name
       String timeStamp = (new SimpleDateFormat("yyyyMMdd").format(new Date())) + "_" + (new SimpleDateFormat("HHmmss").format(new Date()));
       File storageDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM);
       File image = new File(storageDir, timeStamp + ".jpg");
       return image;
    }

    private Uri photoUri;
    public Intent createPickImageCameraIntent(/*String imageFilePath*/){

        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        String state = Environment.getExternalStorageState();
        if(Environment.MEDIA_MOUNTED.equals(state))
        {
            if(intent.resolveActivity(getPackageManager()) != null)
            {
                File photoFile = null;
                try {
                    photoFile = createImageFile();
                    cameraImagePath = photoFile.getAbsolutePath();
                } catch (IOException e) {
                    toast("이미지를 처리하는 중 오류가 발생하였습니다. 잠시 후 다시 시도해주세요.");
                }

                if (photoFile != null) {
                    photoUri = FileProvider.getUriForFile(this, "com.codymonster.ibeobom.provider", photoFile);
                    intent.putExtra(MediaStore.EXTRA_OUTPUT, photoUri);
                }
            }
        }
        return intent;
    }

    public Intent createPickVideoAlbumIntent() {
        Intent intent = new Intent(Intent.ACTION_PICK, android.provider.MediaStore.Video.Media.EXTERNAL_CONTENT_URI);
        intent.setType("video/*");
        return intent;
    }

    public Intent createCropImageIntent(String srcImageFilePath, String dstImageFilePath/*, int maxSize*/){
        Uri srcImageUri = Uri.fromFile(new java.io.File(srcImageFilePath));
        Uri dstImageUri = Uri.fromFile(new java.io.File(dstImageFilePath));
        Intent intent = new Intent("com.android.camera.action.CROP");
        intent.setDataAndType(srcImageUri, "image/*");
        intent.putExtra("aspectX", 1);
        intent.putExtra("aspectY", 1);
        intent.putExtra("output", dstImageUri);
        return intent;
    }

    public void showMediaFileToGallery(String filePath){
      try {
          LocalBroadcastManager.getInstance(this).sendBroadcast(new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, Uri.parse(filePath)));
      }
      catch (NullPointerException e){
          System.out.println("An error has occured.");
      }
    }

    public String getPathFromAlbumImageUri(Uri imageUri){
        String[] filePathColumn = {android.provider.MediaStore.Images.Media.DATA};

        android.database.Cursor cursor = getContentResolver().query(
            imageUri, filePathColumn, null, null, null);
        if(cursor != null)
        {
          cursor.moveToFirst();

          int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
          String imageFilePath = cursor.getString(columnIndex);
          cursor.close();

          return imageFilePath;
        }
        return "";
    }

    public String getPathFromAlbumVideoUri(Uri imageUri){
        String[] filePathColumn = {android.provider.MediaStore.Images.Media.DATA};

        android.database.Cursor cursor = getContentResolver().query(
            imageUri, filePathColumn, null, null, null);
        if(cursor != null)
        {
          int column_index = cursor.getColumnIndexOrThrow(android.provider.MediaStore.Video.Media.DATA);
          cursor.moveToFirst();
          String videoFilePath = cursor.getString(column_index);
          cursor.close();

          return videoFilePath;
        }
        return "";
    }

    public String getRotatedImage(String originFilePath, String tempFilePath){
        ExifInterface ei;
        String resultPath = originFilePath;
        Bitmap targetBitmap = null;
        Bitmap modifiedBitmap = null;
        try
        {
            String fileExtension = originFilePath.substring(originFilePath.lastIndexOf(".") + 1, originFilePath.length()).toLowerCase();
            if(fileExtension.equalsIgnoreCase("jpg") || fileExtension.equalsIgnoreCase("jpeg"))
            {
                ei = new ExifInterface(originFilePath);
                int orientation = ei.getAttributeInt(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_NORMAL);

                int rotation = 0;
                if(orientation == ExifInterface.ORIENTATION_ROTATE_90) rotation = 90;
                else if(orientation == ExifInterface.ORIENTATION_ROTATE_180)  rotation = 180;
                else if(orientation == ExifInterface.ORIENTATION_ROTATE_270)  rotation = 270;

                if(rotation != 0)
                {
                    BitmapFactory.Options options = new BitmapFactory.Options();
                    options.inPreferredConfig = Bitmap.Config.RGB_565;
                    if(originFilePath.isEmpty()) return "";

                    int downsampleBy = 1;
                    while (true) {
                        options.inSampleSize = downsampleBy++;
                        try {
                            targetBitmap = BitmapFactory.decodeFile(originFilePath, options);
                            if(targetBitmap == null) return originFilePath;
                            else break;
                        } catch (OutOfMemoryError e) {
                            // Ignore.  Try again.
                            System.out.println("An error has occured.");

                        } catch (IllegalArgumentException e) {
                            System.out.println("An error has occured.");
                            if(targetBitmap != null) {
                                targetBitmap.recycle(); targetBitmap = null;
                            }
                            resultPath = originFilePath;
                            break;
                        }
                    }

                    Matrix m = new Matrix();
                    if(m != null && targetBitmap != null)
                    {
                        m.setRotate(rotation, (float) targetBitmap.getWidth() / 2, (float) targetBitmap.getHeight() / 2);
                        modifiedBitmap = Bitmap.createBitmap(targetBitmap, 0, 0, targetBitmap.getWidth(), targetBitmap.getHeight(), m, true);

                        FileOutputStream out = null;
                        try {
                            out = new FileOutputStream(tempFilePath);
                            if(modifiedBitmap != null) modifiedBitmap.compress(CompressFormat.JPEG, 80, out);
                            resultPath = tempFilePath;
                        } catch(FileNotFoundException e) {
                            System.out.println("An error has occured.");
                            resultPath = originFilePath;
                        } catch(SecurityException e) {
                            System.out.println("An error has occured.");
                            resultPath = originFilePath;
                        } finally {
                            if(out != null)
                            {
                                try {
                                    out.close();
                                } catch(IOException e) {
                                    System.out.println("An error has occured.");
                                }
                            }
                        }
                    }
                }
            }
        } catch (IOException e) {
            System.out.println("An error has occured.");
            resultPath = originFilePath;
        } finally {
            if(targetBitmap != null) {
                targetBitmap.recycle(); targetBitmap = null;
            }

            if(modifiedBitmap != null) {
                modifiedBitmap.recycle(); modifiedBitmap = null;
            }
        }

        return resultPath;
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        switch(requestedSNSType)
        {
            case NONE:
            case EMAIL:
                break;
            case KAKAO:
            {
                if(Session.getCurrentSession().handleActivityResult(requestCode, resultCode, data))
                    return;
                break;
            }
            case FACEBOOK:
            {
                mCallbackManager.onActivityResult(requestCode, resultCode, data);
                break;
            }
        }

        requestedSNSType = LoginType.NONE;

    }

    private void printd(String message)
    {
        //if wanna show log, resolve comment.
        Log.d(TAG, message);
    }
    private String intToStr(int num) { return String.valueOf(num); }

    public boolean verifyGoogleInstaller(Context context) {
        final String installer = context.getPackageManager().getInstallerPackageName(context.getPackageName());
        return installer != null && installer.startsWith("com.android.vending");
    }

    public class IntegrityCheckTask extends AsyncTask<Void, Void, String> {
        private String url = "https://mobile01.e-koreatech.ac.kr/getSecurityInfo";
        private ContentValues values = new ContentValues();

        @Override
        protected String doInBackground(Void... params) {

//            values.put("os_type", 0);
//            RequestHttpURLConnection requestHttpURLConnection = new RequestHttpURLConnection();
//            return requestHttpURLConnection.request(url, values);
            return "";
        }

        @Override
        protected void onPostExecute(String result) {
            super.onPostExecute(result);

//            try {
//                 JSONObject o = new JSONObject(result);
//                 boolean isOpen = o.optBoolean("is_open");
//                 boolean isSuccess = o.optBoolean("is_success");
//                 if(!isOpen || !isSuccess) {
//                    checkAndExit("서버에 연결할 수 없습니다.", 1000);
//                    return;
//                }

//                String privateKey = o.optString("rsa_private_key").replace("\\n", "\n");

//                if(privateKey.isEmpty())
//                {
//                    checkAndExit("인증키가 유효하지 않습니다.", 1000);
//                    return;
//                }
//                else setPrivateKey(privateKey);

//                String publicKey = o.optString("rsa_public_key").replace("\\n", "\n");
//                if(publicKey.isEmpty())
//                {
//                    checkAndExit("인증키가 유효하지 않습니다.", 1000);
//                    return;
//                }
//                else setPublicKey(publicKey);

//                String sigServed = o.optString("android_signature").trim();
//                if(sigServed.isEmpty())
//                {
//                    checkAndExit("서명이 유효하지 않습니다.", 1000);
//                    return;
//                } else {
//                    String sigDevice = getSignature().trim();
//                    printd("Served Signature: " + sigServed + ", Device Signature: " + sigDevice + "\n\n**AAA");

//                    /* Check the Application integrity. */
//                    boolean validSign = false;
//                    if(sigServed.equals(sigDevice)) validSign = true;
//                    ///////////////////////////////////////////////////////////////////////////

//                    if(!validSign) checkAndExit("서명이 유효하지 않습니다.", 1000);
//                    else {
                        mSystemSecured = true;
                        initialize();
//                    }
//                }

//             } catch(JSONException e) {
//                checkAndExit("인증이 유효하지 않습니다.", 1000);
//                return;
//             }
        }
    }

    private String sessionValue;
    private boolean mSystemSecured = false;
    public boolean isSystemSecured() { return mSystemSecured; }
    public void setSystemSecured(boolean sec) { mSystemSecured = sec; }

    private ContentValues mContentValues = new ContentValues();
    public class NetWorker extends AsyncTask<Void, Void, String>
    {
        private RequestHttpURLConnection requestHttpURLConnection;
        private String url = "https://mobile01.e-koreatech.ac.kr/";
        private String methodName = "";
        private String mFilePath = "";
        public NetWorker(String m)
        {
            url = url+m; methodName = m;
        }
        public NetWorker(String m, String f)
        {
            url = url+m; methodName = m;
            mFilePath = f;
        }

        @Override
        protected String doInBackground(Void... params) {

            printd("Called Where : " + url);

            requestHttpURLConnection = new RequestHttpURLConnection();
            if(methodName.equals("login")) requestHttpURLConnection.requestCookieValue(true);
            else requestHttpURLConnection.setCookie(sessionValue);

            if(mFilePath.isEmpty()) return requestHttpURLConnection.request(url, mContentValues);
            else return requestHttpURLConnection.requestFile(url, mContentValues, mFilePath);
        }

        @Override
        protected void onPostExecute(String result)
        {
            super.onPostExecute(result);
            Bundle data = new Bundle();
            data.putString("method_name", methodName);
            data.putString("result", result);
            data.putString("session_value", requestHttpURLConnection.cookie());

            Message msg = new Message();
            msg.setData(data);
            netHandler.sendMessage(msg);
        }
    }

    Handler netHandler = new Handler()
    {
        @Override
        public void handleMessage(Message msg)
        {
            String result = msg.getData().getString("result");
            String methodName = msg.getData().getString("method_name");

            if(methodName.equals("login"))
            {
                sessionValue = msg.getData().getString("session_value");
                notifyAndLoginResult(result);
            }
            else if(methodName.equals("join")) notifyAndJoinResult(result);
            else if(methodName.equals("certification")) notifyAndCertificateResult(result);
            else if(methodName.equals("duplicateID")) notifyAndDuplicateIDResult(result);
            else if(methodName.equals("duplicateNickname")) notifyAndDuplicateNicknameResult(result);
            else if(methodName.equals("withdraw")) notifyAndWithdrawResult(result);
            else if(methodName.equals("setPushStatus")) notifyAndSetPushStatusResult(result);
            else if(methodName.equals("findUserID")) notifyAndFindIDResult(result);
            else if(methodName.equals("findUserPassword")) notifyAndFindPasswordResult(result);
            else if(methodName.equals("logout")) notifyAndLogoutResult(result);
            else if(methodName.equals("updateUserPassword")) notifyAndUpdatePasswordResult(result);
            else if(methodName.equals("getMyPageCourse")) notifyAndGetMyPageCourseResult(result);
            else if(methodName.equals("getMyPageLog")) notifyAndGetMyPageLogResult(result);
            else if(methodName.equals("setPushDatetime")) notifyAndSetPushDateTimeResult(result);
            else if(methodName.equals("getUserProfile")) notifyAndGetUserProfileResult(result);
            else if(methodName.equals("updateUserProfile")) notifyAndUpdateUserProfileResult(result);
            else if(methodName.equals("getSystemNoticeList")) notifyAndGetSystemNoticeListResult(result);
            else if(methodName.equals("getSystemNoticeDetail")) notifyAndGetSystemNoticeDetailResult(result);
            else if(methodName.equals("checkCertificationSMS")) notifyAndCheckCertificationSMSResult(result);
            else if(methodName.equals("uploadImageFile")) notifyAndUploadImageFileResult(result);
            else if(methodName.equals("uploadFile")) notifyAndUploadFileResult(result);
            else if(methodName.equals("deleteFile")) notifyAndDeleteFileResult(result);
            else if(methodName.equals("getMain")) notifyAndGetMainResult(result);
            else if(methodName.equals("getCourseDetail")) notifyAndGetCourseDetailResult(result);
            else if(methodName.equals("getCourseBoardList")) notifyAndGetCourseBoardListResult(result);
            else if(methodName.equals("getCourseBoardDetail")) notifyAndGetCourseBoardDetailResult(result);
            else if(methodName.equals("setCourseBoardArticle")) notifyAndSetCourseBoardArticleResult(result);
            else if(methodName.equals("updateCourseBoardArticle")) notifyAndUpdateCourseBoardArticleResult(result);
            else if(methodName.equals("deleteCourseBoardArticle")) notifyAndDeleteCourseBoardArticleResult(result);
            else if(methodName.equals("setCourseBoardArticleReple")) notifyAndSetCourseBoardArticleRepleResult(result);
            else if(methodName.equals("updateCourseBoardArticleReple")) notifyAndUpdateCourseBoardArticleRepleResult(result);
            else if(methodName.equals("deleteCourseBoardArticleReple")) notifyAndDeleteCourseBoardArticleRepleResult(result);
            else if(methodName.equals("setBoardReport")) notifyAndSetBoardReportResult(result);
            else if(methodName.equals("getClipList")) notifyAndGetClipListResult(result);
            else if(methodName.equals("getClipDetail")) notifyAndGetClipDetailResult(result);
            else if(methodName.equals("getClipDetailForDelivery")) notifyAndGetClipDetailForDeliveryResult(result);
            else if(methodName.equals("setQuiz")) notifyAndSetQuizResult(result);
            else if(methodName.equals("getClipSharing")) notifyAndGetClipSharingResult(result);
            else if(methodName.equals("setClipLike")) notifyAndSetClipLikeResult(result);
            else if(methodName.equals("getClipRepleList")) notifyAndGetClipRepleListResult(result);
            else if(methodName.equals("setClipReple")) notifyAndSetClipRepleResult(result);
            else if(methodName.equals("updateClip")) notifyAndUpdateClipResult(result);
            else if(methodName.equals("deleteClip")) notifyAndDeleteClipResult(result);
            else if(methodName.equals("setClipRepleReport")) notifyAndSetClipRepleReportResult(result);
            else if(methodName.equals("setClipRepleLike")) notifyAndSetClipRepleLikeResult(result);
            else if(methodName.equals("getOtherUserProfile")) notifyAndGetOtherUserProfileResult(result);
            else if(methodName.equals("setUserProfileReport")) notifyAndSetUserProfileReportResult(result);
            else if(methodName.equals("updateStudyTime")) notifyAndUpdateStudyTimeResult(result);
            else if(methodName.equals("setDeliveryService")) notifyAndSetDeliveryServiceResult(result);
            else if(methodName.equals("setUnitComplete")) notifyAndSetUnitCompleteResult(result);
            else if(methodName.equals("setDeliveryServiceConfirm")) notifyAndSetDeliveryServiceConfirmResult(result);
            else if(methodName.equals("getSearchMain")) notifyAndGetSearchMainResult(result);
            else if(methodName.equals("getClipLikeList")) notifyAndGetClipLikeListResult(result);
            else if(methodName.equals("getRepleLikeList")) notifyAndGetRepleLikeListResult(result);
            else if(methodName.equals("getRankingMain")) notifyAndGetRankingMainResult(result);
            else if(methodName.equals("getSavingDetail")) notifyAndGetSavingDetailResult(result);
            else if(methodName.equals("getSpendingDetail")) notifyAndGetSpendingDetailResult(result);
            else if(methodName.equals("getApplyEventList")) notifyAndGetApplyEventListResult(result);
            else if(methodName.equals("getApplyEventDetail")) notifyAndGetApplyEventDetailResult(result);
            else if(methodName.equals("setApplyEvent")) notifyAndSetApplyEventResult(result);
            else if(methodName.equals("getUserPoint")) notifyAndGetUserPointResult(result);
            else if(methodName.equals("getMyAlarmList")) notifyAndGetMyAlarmListResult(result);
            else if(methodName.equals("deleteMyAlarm")) notifyAndDeleteMyAlarmResult(result);
            else if(methodName.equals("getSystemFAQList")) notifyAndGetSystemFAQListResult(result);
            else if(methodName.equals("getSystemFAQDetail")) notifyAndGetSystemFAQDetailResult(result);
            else if(methodName.equals("getSystemInfo")) notifyAndGetSystemInfoResult(result);
            else if(methodName.equals("setPushkey")) notifyAndSetPushkeyResult(result);
            else if(methodName.equals("setContactUS")) notifyAndSetContactUSResult(result);
        }
    };

    public void loginAnd(String id, String pass, String snsType)
    {
        mContentValues.clear();
        mContentValues.put("id", id);
        mContentValues.put("password", pass);
        mContentValues.put("id_type", snsType);
        (new NetWorker("login")).execute();
    }

    public void joinAnd(String id, String pass, String name,
                        String nickname, String birth, String gender,
                        String phone, String osType, String deviceID,
                        String deviceName, String snsType, String pushKey,
                        String email, String snsAccessToken, String snsRefreshToken,
                        String agreeUse, String agreeUserInfo, String agreeThird, String agreeEvent)
    {
        mContentValues.clear();
        mContentValues.put("id", id);
        mContentValues.put("password", pass);
        mContentValues.put("name", name);
        mContentValues.put("nickname", nickname);
        mContentValues.put("birth", birth);
        mContentValues.put("gender", gender);
        mContentValues.put("phone", phone);
        mContentValues.put("os_type", osType);
        mContentValues.put("device_id", deviceID);
        mContentValues.put("device_name", deviceName);
        mContentValues.put("sns_type", snsType);
        mContentValues.put("pushkey", pushKey);
        mContentValues.put("email", email);
        mContentValues.put("sns_access_token", snsAccessToken);
        mContentValues.put("sns_refresh_token", snsRefreshToken);
        mContentValues.put("agree_use", agreeUse);
        mContentValues.put("agree_user_info", agreeUserInfo);
        mContentValues.put("agree_third", agreeThird);
        mContentValues.put("agree_event", agreeEvent);
        (new NetWorker("join")).execute();
    }

    public void certificate(String phone)
    {
        mContentValues.clear();
        mContentValues.put("phone", phone);
        (new NetWorker("certification")).execute();
    }

    public void duplicateID(String id)
    {
        mContentValues.clear();
        mContentValues.put("id", id);
        (new NetWorker("duplicateID")).execute();
    }

    public void duplicateNickname(String nickname)
    {
        mContentValues.clear();
        mContentValues.put("nickname", nickname);
        (new NetWorker("duplicateNickname")).execute();
    }

    public void logoutAnd()
    {
        mContentValues.clear();
        (new NetWorker("logout")).execute();
    }

    public void withdrawAnd(String comment)
    {
        mContentValues.clear();
        mContentValues.put("comment", comment);
        (new NetWorker("withdraw")).execute();
    }

    public void setPushStatus(String pushStatus)
    {
        mContentValues.clear();
        mContentValues.put("push_status", pushStatus);
        (new NetWorker("setPushStatus")).execute();
    }

    public void findID(String name, String birth, String phone)
    {
        mContentValues.clear();
        mContentValues.put("name", name);
        mContentValues.put("birth", birth);
        mContentValues.put("phone", phone);
        (new NetWorker("findUserID")).execute();
    }

    public void findPassword(String id, String email)
    {
        mContentValues.clear();
        mContentValues.put("user_id", id);
        mContentValues.put("email", email);
        (new NetWorker("findUserPassword")).execute();
    }

    public void updatePassword(String oldPass, String newPass)
    {
        mContentValues.clear();
        mContentValues.put("old_password", oldPass);
        mContentValues.put("password", newPass);
        (new NetWorker("updateUserPassword")).execute();
    }

    public void getMyPageCourse()
    {
        mContentValues.clear();
        (new NetWorker("getMyPageCourse")).execute();
    }

    public void getMyPageLog(String pageNo)
    {
        mContentValues.clear();
        mContentValues.put("now_page", pageNo);
        (new NetWorker("getMyPageLog")).execute();
    }

    public void setPushDateTime(String time)
    {
        mContentValues.clear();
        mContentValues.put("push_time", time);
        (new NetWorker("setPushDatetime")).execute();
    }

    public void getUserProfile()
    {
        mContentValues.clear();
        (new NetWorker("getUserProfile")).execute();
    }

    public void updateUserProfile(String profileImage, String profileThumbUrl, String name, String birth, String gender, String email, String isImageFileModify)
    {
        mContentValues.clear();
        mContentValues.put("profile_image", profileImage);
        mContentValues.put("profile_thumbnail_url", profileThumbUrl);
        mContentValues.put("name", name);
        mContentValues.put("birth", birth);
        mContentValues.put("gender", gender);
        mContentValues.put("email", email);
        mContentValues.put("is_image_file_modify", isImageFileModify);
        (new NetWorker("updateUserProfile")).execute();
    }

    public void getSystemNoticeList(String noticeType, String pageNo)
    {
        mContentValues.clear();
        mContentValues.put("notice_type", noticeType);
        mContentValues.put("now_page", pageNo);
        (new NetWorker("getSystemNoticeList")).execute();
    }

    public void getSystemNoticeDetail(String boardArticleNo, String boardNo)
    {
        mContentValues.clear();
        mContentValues.put("board_article_no", boardArticleNo);
        mContentValues.put("board_no", boardNo);
        (new NetWorker("getSystemNoticeDetail")).execute();
    }

    public void uploadImageFile(String filename, String filepath)
    {
        mContentValues.clear();
        mContentValues.put("file_name", filename);
        (new NetWorker("uploadImageFile", filepath)).execute();
    }

    public void uploadFile(String filename, String boardArticleNo, String boardNo, String filepath)
    {
        mContentValues.clear();
        mContentValues.put("file_name", filename);
        mContentValues.put("board_article_no", boardArticleNo);
        mContentValues.put("board_no", boardNo);
        (new NetWorker("uploadFile", filepath)).execute();
    }

    public void _deleteFile(String fileNo)
    {
        mContentValues.clear();
        mContentValues.put("file_no", fileNo);
        (new NetWorker("deleteFile")).execute();
    }

    public void getMain(String nowPage, String categoryNo)
    {
        printd("Called getMain" + nowPage);
        mContentValues.clear();
        mContentValues.put("now_page", nowPage);
        mContentValues.put("category_no", categoryNo);
        (new NetWorker("getMain")).execute();
    }

    public void getCourseDetail(String courseNo)
    {
        mContentValues.clear();
        mContentValues.put("course_no", courseNo);
        (new NetWorker("getCourseDetail")).execute();
    }

    public void getCourseBoardList(String nowPage, String boardNo)
    {
        mContentValues.clear();
        mContentValues.put("board_no", boardNo);
        mContentValues.put("now_page", nowPage);
        (new NetWorker("getCourseBoardList")).execute();
    }

    public void getCourseBoardDetail(String nowPage, String boardNo, String boardArticleNo)
    {
        mContentValues.clear();
        mContentValues.put("board_no", boardNo);
        mContentValues.put("board_article_no", boardArticleNo);
        mContentValues.put("now_page", nowPage);
        (new NetWorker("getCourseBoardDetail")).execute();
    }

    public void setCourseBoardArticle(String boardNo, String title, String contents)
    {
        mContentValues.clear();
        mContentValues.put("board_no", boardNo);
        mContentValues.put("title", title);
        mContentValues.put("contents", contents);
        (new NetWorker("setCourseBoardArticle")).execute();
    }

    public void setCourseBoardArticleReple(String boardNo, String boardArticleNo, String contents)
    {
        mContentValues.clear();
        mContentValues.put("board_no", boardNo);
        mContentValues.put("board_article_no", boardArticleNo);
        mContentValues.put("contents", contents);
        (new NetWorker("setCourseBoardArticleReple")).execute();
    }

    public void updateCourseBoardArticle(String boardNo, String boardArticleNo, String title, String contents)
    {
        mContentValues.clear();
        mContentValues.put("board_no", boardNo);
        mContentValues.put("board_article_no", boardArticleNo);
        mContentValues.put("title", title);
        mContentValues.put("contents", contents);
        (new NetWorker("updateCourseBoardArticle")).execute();
    }

    public void updateCourseBoardArticleReple(String repleNo, String contents)
    {
        mContentValues.clear();
        mContentValues.put("reple_no", repleNo);
        mContentValues.put("contents", contents);
        (new NetWorker("updateCourseBoardArticleReple")).execute();
    }

    public void deleteCourseBoardArticle(String boardNo, String boardArticleNo)
    {
        mContentValues.clear();
        mContentValues.put("board_no", boardNo);
        mContentValues.put("board_article_no", boardArticleNo);
        (new NetWorker("deleteCourseBoardArticle")).execute();
    }

    public void deleteCourseBoardArticleReple(String repleNo)
    {
        mContentValues.clear();
        mContentValues.put("reple_no", repleNo);
        (new NetWorker("deleteCourseBoardArticleReple")).execute();
    }

    public void setBoardReport(String boardNo, String boardArticleNo, String repleNo, String reportType, String reason)
    {
        mContentValues.clear();
        mContentValues.put("board_no", boardNo);
        mContentValues.put("board_article_no", boardArticleNo);
        mContentValues.put("reple_no", repleNo);
        mContentValues.put("report_type", reportType);
        mContentValues.put("reason", reason);
        (new NetWorker("setBoardReport")).execute();
    }

    public void getClipList(String courseNo)
    {
        mContentValues.clear();
        mContentValues.put("course_no", courseNo);
        (new NetWorker("getClipList")).execute();
    }

    public void getClipDetail(String lessonSubNo, String courseNo)
    {
        mContentValues.clear();
        mContentValues.put("course_no", courseNo);
        mContentValues.put("lesson_subitem_no", lessonSubNo);
        (new NetWorker("getClipDetail")).execute();
    }

    public void getClipDetailForDelivery(String lessonSubNo, String courseNo)
    {
        mContentValues.clear();
        mContentValues.put("course_no", courseNo);
        mContentValues.put("lesson_subitem_no", lessonSubNo);
        (new NetWorker("getClipDetailForDelivery")).execute();
    }

    public void setQuiz(String quizNo, String answerType, String examleNo, String lessonSubitemNo, String courseNo)
    {
        mContentValues.clear();
        mContentValues.put("quiz_no", quizNo);
        mContentValues.put("answer_type", answerType);
        mContentValues.put("example_no", examleNo);
        mContentValues.put("lesson_subitem_no", lessonSubitemNo);
        mContentValues.put("course_no", courseNo);
        (new NetWorker("setQuiz")).execute();
    }

    public void getClipSharing(String lessonSubitemNo)
    {
        mContentValues.clear();
        mContentValues.put("lesson_subitem_no", lessonSubitemNo);
        (new NetWorker("getClipSharing")).execute();
    }

    public void setClipLike(String courseNo, String lessonSubitemNo, String isLike)
    {
        mContentValues.clear();
        mContentValues.put("course_no", courseNo);
        mContentValues.put("lesson_subitem_no", lessonSubitemNo);
        mContentValues.put("is_like", isLike);
        (new NetWorker("setClipLike")).execute();
    }

    public void getClipRepleList(String lessonSubitemNo, String filterType, String nowPage)
    {
        mContentValues.clear();
        mContentValues.put("filter_type", filterType);
        mContentValues.put("lesson_subitem_no", lessonSubitemNo);
        mContentValues.put("now_page", nowPage);
        (new NetWorker("getClipRepleList")).execute();
    }

    public void setClipReple(String lessonSubitemNo, String contents, String unitAttachFileName, String unitAttachImageUrl, String unitAttachThumbnailUrl)
    {
        mContentValues.clear();
        mContentValues.put("lesson_subitem_no", lessonSubitemNo);
        mContentValues.put("contents", contents);
        mContentValues.put("unit_attach_file_name", unitAttachFileName);
        mContentValues.put("unit_attach_image_url", unitAttachImageUrl);
        mContentValues.put("unit_attach_thumbnail_url", unitAttachThumbnailUrl);
        (new NetWorker("setClipReple")).execute();
    }

    public void setClipRepleReport(String boardArticleNo, String boardNo, String reason)
    {
        mContentValues.clear();
        mContentValues.put("board_article_no", boardArticleNo);
        mContentValues.put("reason", reason);
        mContentValues.put("board_no", boardNo);
        (new NetWorker("setClipRepleReport")).execute();
    }

    public void setClipRepleLike(String boardArticleNo, String boardNo, String isLike)
    {
        mContentValues.clear();
        mContentValues.put("board_article_no", boardArticleNo);
        mContentValues.put("board_no", boardNo);
        mContentValues.put("is_like", isLike);
        (new NetWorker("setClipRepleLike")).execute();
    }

    public void updateClip(String boardArticleNo, String boardNo, String contents, String modifyFile, String unitAttachFileName, String unitAttachImageUrl, String unitAttachThumbnailUrl)
    {
        mContentValues.clear();
        mContentValues.put("board_article_no", boardArticleNo);
        mContentValues.put("board_no", boardNo);
        mContentValues.put("contents", contents);
        mContentValues.put("modify_file", modifyFile);
        mContentValues.put("unit_attach_file_name", unitAttachFileName);
        mContentValues.put("unit_attach_image_url", unitAttachImageUrl);
        mContentValues.put("unit_attach_thumbnail_url", unitAttachThumbnailUrl);
        (new NetWorker("updateClip")).execute();
    }

    public void deleteClip(String boardArticleNo, String boardNo)
    {
        mContentValues.clear();
        mContentValues.put("board_article_no", boardArticleNo);
        mContentValues.put("board_no", boardNo);
        (new NetWorker("deleteClip")).execute();
    }

    public void getOtherUserProfile(String targetUserNo)
    {
        mContentValues.clear();
        mContentValues.put("target_user_no", targetUserNo);
        (new NetWorker("getOtherUserProfile")).execute();
    }

    public void setUserProfileReport(String targetUserNo, String reason)
    {
        mContentValues.clear();
        mContentValues.put("target_user_no", targetUserNo);
        mContentValues.put("reason", reason);
        (new NetWorker("setUserProfileReport")).execute();
    }

    public void updateStudyTime(String lessonSubitemNo, String studyTime)
    {
        mContentValues.clear();
        mContentValues.put("lesson_subitem_no", lessonSubitemNo);
        mContentValues.put("study_time", studyTime);
        (new NetWorker("updateStudyTime")).execute();
    }

    public void setDeliveryService(String courseNo)
    {
        mContentValues.clear();
        mContentValues.put("course_no", courseNo);
        (new NetWorker("setDeliveryService")).execute();
    }

    public void setUnitComplete(String lessonSubmitNo, String courseNo)
    {
        mContentValues.clear();
        mContentValues.put("lesson_subitem_no", lessonSubmitNo);
        mContentValues.put("course_no", courseNo);
        (new NetWorker("setUnitComplete")).execute();
    }

    public void setDeliveryServiceConfirm(String courseNo)
    {
        mContentValues.clear();
        mContentValues.put("course_no", courseNo);
        (new NetWorker("setDeliveryServiceConfirm")).execute();
    }

    public void getSearchMain(String nowPage, String searchKeyword, String searchType)
    {
        mContentValues.clear();
        mContentValues.put("now_page", nowPage);
        mContentValues.put("search_keyword", searchKeyword);
        mContentValues.put("search_tyep", searchType);
        (new NetWorker("getSearchMain")).execute();
    }

    public void getClipLikeList(String nowPage)
    {
        mContentValues.clear();
        mContentValues.put("now_page", nowPage);
        (new NetWorker("getClipLikeList")).execute();
    }

    public void getRepleLikeList(String nowPage)
    {
        mContentValues.clear();
        mContentValues.put("now_page", nowPage);
        (new NetWorker("getRepleLikeList")).execute();
    }

    public void getRankingMain()
    {
        mContentValues.clear();
        (new NetWorker("getRankingMain")).execute();
    }

    public void getSavingDetail(String nowPage)
    {
        mContentValues.clear();
        mContentValues.put("now_page", nowPage);
        (new NetWorker("getSavingDetail")).execute();
    }

    public void getSpendingDetail(String nowPage)
    {
        mContentValues.clear();
        mContentValues.put("now_page", nowPage);
        (new NetWorker("getSpendingDetail")).execute();
    }

    public void getApplyEventList()
    {
        mContentValues.clear();
        (new NetWorker("getApplyEventList")).execute();
    }

    public void getApplyEventDetail(String prizeNo)
    {
        mContentValues.clear();
        mContentValues.put("prize_no", prizeNo);
        (new NetWorker("getApplyEventDetail")).execute();
    }

    public void setApplyEvent(String prizeNo, String appliedText, String appliedImageUrl)
    {
        mContentValues.clear();
        mContentValues.put("prize_no", prizeNo);
        mContentValues.put("apply_prize_text", appliedText);
        mContentValues.put("apply_prize_image", appliedImageUrl);
        (new NetWorker("setApplyEvent")).execute();
    }

    public void getUserPoint()
    {
        mContentValues.clear();
        (new NetWorker("getUserPoint")).execute();
    }

    public void getMyAlarmList(String nowPage)
    {
        mContentValues.clear();
        mContentValues.put("now_page", nowPage);
        (new NetWorker("getMyAlarmList")).execute();
    }

    public void deleteMyAlarm(String alarmNo)
    {
        mContentValues.clear();
        mContentValues.put("alarm_no", alarmNo);
        (new NetWorker("deleteMyAlarm")).execute();
    }

    public void getSystemFAQList()
    {
        mContentValues.clear();
        (new NetWorker("getSystemFAQList")).execute();
    }

    public void getSystemFAQDetail(String faqNo)
    {
        mContentValues.clear();
        mContentValues.put("faq_no", faqNo);
        (new NetWorker("getSystemFAQDetail")).execute();
    }

    public void getSystemInfo()
    {
        printd("Called getSystemInfo");
        mContentValues.clear();
        (new NetWorker("getSystemInfo")).execute();
    }

    public void setPushkey(String devceID, String osType, String deviceName, String pushkey)
    {
        mContentValues.clear();
        mContentValues.put("device_id", devceID);
        mContentValues.put("os_type", osType);
        mContentValues.put("device_name", deviceName);
        mContentValues.put("pushkey", pushkey);
        (new NetWorker("setPushkey")).execute();
    }

    public void checkCertificationSMS(String phone, String nums)
    {
        mContentValues.clear();
        mContentValues.put("phone", phone);
        mContentValues.put("unique_number", nums);
        (new NetWorker("checkCertificationSMS")).execute();
    }

    public void setContactUS(String email, String contents, String title, String courseNo)
    {
        mContentValues.clear();
        mContentValues.put("email", email);
        mContentValues.put("contents", contents);
        mContentValues.put("title", title);
        mContentValues.put("course_no", courseNo);
        (new NetWorker("setContactUS")).execute();
    }
}
