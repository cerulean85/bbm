package com.codymonster.ibeobom;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.kakao.auth.ApiResponseCallback;
import com.kakao.auth.AuthService;
import com.kakao.auth.network.response.AccessTokenInfoResponse;
import com.kakao.network.ErrorResult;
import com.kakao.usermgmt.UserManagement;
import com.kakao.usermgmt.callback.MeResponseCallback;
import com.kakao.usermgmt.response.model.UserProfile;
import com.kakao.util.helper.log.Logger;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by JHKim on 2018-01-13.
 */

public class KakaoSignupActivity extends Activity {

    @Override
    protected void onCreate(final Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestMe();
    }

    protected void requestMe() {
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
                Logger.d(message);
                redirectLoginActivity();;
            }

            @Override
            public void onSessionClosed(ErrorResult errorResult)
            {
                Logger.d("ErrorResult : " + errorResult);
                redirectLoginActivity();
            }

            @Override
            public void onNotSignedUp()
            {
                showSignUp();
            }

            @Override
            public void onSuccess(UserProfile userProfile)
            {
                requestAccessTokenInfo();
//                Logger.d("UserProfile : " + userProfile);
//                Log.d("user", userProfile.toString());


                redirectMainAcitivity();
            }
        }, propertyKeys, false);
    }

    protected void showSignUp()
    {
        redirectMainAcitivity();
    }

    private void redirectMainAcitivity() {
        startActivity(new Intent(this, MainActivity.class));
        finish();
    }

    protected void redirectLoginActivity() {
//        final Intent intent = new Intent(this, KakaoLoginActivity.class);
//        intent.setFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION);
//        startActivity(intent);
        finish();
    }
    private void requestAccessTokenInfo() {
        AuthService.getInstance().requestAccessTokenInfo(new ApiResponseCallback<AccessTokenInfoResponse>() {
            @Override
            public void onSessionClosed(ErrorResult errorResult) {
                redirectLoginActivity();
            }

            @Override
            public void onNotSignedUp() {
                // not happened
            }

            @Override
            public void onFailure(ErrorResult errorResult) {
//                Logger.e("failed to get access token info. msg=" + errorResult);
            }

            @Override
            public void onSuccess(AccessTokenInfoResponse accessTokenInfoResponse) {
//                long userId = accessTokenInfoResponse.getUserId();
//                Logger.d("this access token is for userId=" + userId);

//                long expiresInMilis = accessTokenInfoResponse.getExpiresInMillis();
//                Logger.d("this access token expires after " + expiresInMilis + " milliseconds.");
            }
        });
    }
}
