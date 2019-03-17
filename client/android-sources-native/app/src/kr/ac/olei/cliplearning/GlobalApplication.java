package com.codymonster.ibeobom;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.Signature;
import android.util.Base64;
import android.util.Log;
import android.support.multidex.MultiDex;

import com.kakao.auth.KakaoSDK;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import static com.kakao.util.helper.Utility.getPackageInfo;
import org.qtproject.qt5.android.bindings.QtApplication;
import com.codymonster.ibeobom.MultiDexApplication;

/**
 * Created by JHKim on 2018-01-13.
 */

public class GlobalApplication extends MultiDexApplication {
    private static GlobalApplication instance = null;
    private static volatile Activity currentActivity = null;

    public static GlobalApplication getInstance() { return instance; }

//    @Override
//    protected void attachBaseContext(Context base) {
//       super.attachBaseContext(base);
//       MultiDex.install(this);
//    }

    @Override
    public void onCreate() {
        super.onCreate();

        GlobalApplication.instance = this;
        KakaoSDK.init(new KakaoSDKAdapter());

//        Log.e("Key Hash : ", getKeyHash(this));
    }

    public static Activity getCurrentActivity() { return currentActivity; }

    public static void setCurrentAcitivity(Activity currentActivity) {
        GlobalApplication.currentActivity = currentActivity;
    }

    @Override
    public void onTerminate() {
        super.onTerminate();
        instance = null;
    }

    public  String getKeyHash(final Context context) {
        PackageInfo packageInfo = getPackageInfo(context, PackageManager.GET_SIGNATURES);
        if (packageInfo == null)
            return null;

        for (Signature signature : packageInfo.signatures) {
            try {
                MessageDigest md = MessageDigest.getInstance("SHA");
                md.update(signature.toByteArray());
                return Base64.encodeToString(md.digest(), Base64.NO_WRAP);
            } catch (NoSuchAlgorithmException e) {
                return "Unidentifiable";
            }
        }
        return null;
    }


}
