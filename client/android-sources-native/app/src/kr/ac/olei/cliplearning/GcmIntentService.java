package com.codymonster.ibeobom;

import java.util.*;
import java.net.URL;
import java.io.IOException;
import java.net.MalformedURLException;

import android.app.*;
import android.app.ActivityManager.*;
import android.content.Intent;
import android.app.IntentService;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.PendingIntent.CanceledException;
import android.content.*;
import android.media.*;
import android.net.*;
import android.os.*;
import android.support.v4.app.*;
import android.util.Log;
import android.view.*;
import android.widget.*;
import android.os.Bundle;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import org.json.JSONObject;
import org.json.JSONException;
import com.google.android.gms.gcm.GoogleCloudMessaging;
import com.google.android.gms.common.GooglePlayServicesUtil;
import android.telecom.ConnectionRequest;
import android.app.NotificationChannel;
import android.os.Build;
import android.support.v4.app.JobIntentService;


public class GcmIntentService extends JobIntentService
{

    public static final int NOTIFICATION_ID = 1;
    private NotificationManager mNotificationManager;
    NotificationCompat.Builder builder;

    public static void enqueueWork(Context context, Intent work) {
        enqueueWork(context, GcmIntentService.class, NOTIFICATION_ID, work);
    }

    @Override
    protected void onHandleWork(Intent intent)
    {
        onHandleIntent(intent);
    }

    private void onHandleIntent(Intent intent) {

        Bundle extras = intent.getExtras();
        GoogleCloudMessaging gcm = GoogleCloudMessaging.getInstance(this);
        String messageType = gcm.getMessageType(intent);

        if (!extras.isEmpty()) {
            for (String key : extras.keySet())
            {
//                Log.d("Bundle Debug", key + " = \"" + extras.get(key) + "\"");
            }
            if (GoogleCloudMessaging.MESSAGE_TYPE_MESSAGE.equals(messageType))
            {
                String typeStr = extras.getString("type");
                if(typeStr == null || typeStr.length() <= 0) typeStr = "0";
                int type = Integer.valueOf(typeStr);

                String no1Str = extras.getString("course_no");
                if(no1Str == null || no1Str.length() <= 0) no1Str = "0";
                int no1 = Integer.valueOf(no1Str);

                String no2Str = extras.getString("lesson_subitem_no");
                if(no2Str == null || no2Str.length() <= 0) no2Str = "0";
                int no2 = Integer.valueOf(no2Str);

                String message = extras.getString("msg");
                if(message == null) message="";

                String title = extras.getString("title");
                if(title == null) title="이버봄 알림";

                Context ctx = getApplicationContext();
//                Log.i("GcmIntentService", "isRunning >> " + isRunning(ctx));
                GcmMessage gcmMessage = new GcmMessage(type, message, no1, no2);
//                gcmMessage.running = isRunning(ctx);

                Intent nintent = new Intent(this, MainActivity.class);
                nintent.putExtra("gcm_message", gcmMessage);
                nintent.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP | Intent.FLAG_ACTIVITY_CLEAR_TOP);

                PendingIntent contentIntent = PendingIntent.getActivity(this, 0, nintent, PendingIntent.FLAG_UPDATE_CURRENT);
                mNotificationManager = (NotificationManager) this.getSystemService(Context.NOTIFICATION_SERVICE);

                NotificationCompat.Builder mBuilder;
                if(Build.VERSION.SDK_INT >= 26)
                {
                    NotificationChannel channel = new NotificationChannel("cliplearning", "cliplearning", NotificationManager.IMPORTANCE_DEFAULT);
                    mNotificationManager.createNotificationChannel(channel);
                    mBuilder = new NotificationCompat.Builder(this, channel.getId());
                }
                else
                {
                    mBuilder = new NotificationCompat.Builder(this);
                }

                mBuilder.setSmallIcon(R.drawable.ic_launcher_round)
                        .setContentTitle(title)
                        .setTicker(gcmMessage.message)
                        .setDefaults(Notification.DEFAULT_SOUND)
                        .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                        .setAutoCancel(true)
                        .setStyle(new NotificationCompat.BigTextStyle().bigText(gcmMessage.message))
                        .setContentText(gcmMessage.message)
                        .setContentIntent(contentIntent);
                mNotificationManager.notify(NOTIFICATION_ID, mBuilder.build());
            }
        }
        // Release the wake lock provided by the WakefulBroadcastReceiver.
        GcmBroadcastReceiver.completeWakefulIntent(intent);
    }

}
