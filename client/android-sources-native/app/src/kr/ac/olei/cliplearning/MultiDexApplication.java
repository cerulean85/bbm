package com.codymonster.ibeobom;

import android.app.Application;
import android.content.Context;
import android.support.multidex.MultiDex;

import org.qtproject.qt5.android.bindings.QtApplication;

public class MultiDexApplication extends Application {
    public MultiDexApplication() {
    }

    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        MultiDex.install(this);
    }
}
