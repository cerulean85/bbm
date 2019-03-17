package com.codymonster.ibeobom;

import android.content.Context;
import android.content.Intent;
import android.support.v4.content.LocalBroadcastManager;

public class GcmCommon
{
    public static final String PACKAGE_NAME = "com.codymonster.ibeobom";
    public static final String DISPLAY_MESSAGE_ACTION = "com.codymonster.ibeobom.gcm.DISPLAY_MESSAGE";
    public static final String EXTRA_MESSAGE = "message";
    public static final String EXTRA_MESSAGE_TYPE = "message_type";
    public static final String REGISTRATION_ID = "regId";
    public static final String GCM_SERVICE_STATE = "gcm_state";
    public static final String GCM_DATA_OBJECT = "gcm_data_object";
    public static final int GCM_SERVICE_REGISTERED = 1;
    public static final int GCM_SERVICE_UNREGISTERED = 2;
    public static final int GCM_SERVICE_RECEIVE_MESSSAGE = 3;
    public static final int GCM_SERVICE_DELETED_MESSAGE = 4;
    public static final int GCM_SERVICE_ERROR = 5;
    public static final int GCM_SERVICE_RECOVERABLE_ERROR = 6;

    public static final String GCM_PARAM_TYPE = "type";
    public static final String GCM_PARAM_MESSAGE = "message";
    public static final String GCM_PARAM_SHOW = "show";

    static public void processMessage(Context context, GcmMessage data, int gcmServiceState)
    {
        Intent intent = new Intent(DISPLAY_MESSAGE_ACTION);
        intent.putExtra(GCM_SERVICE_STATE, gcmServiceState);
        intent.putExtra(GCM_DATA_OBJECT, data);
        LocalBroadcastManager.getInstance(context).sendBroadcast(intent);
//        context.sendBroadcast(intent);
    }
}
