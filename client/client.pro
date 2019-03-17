QT += quick quickcontrols2 network qml gui-private sql webview multimedia multimediawidgets
CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.x
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    src/commander.h \
    src/dbmanager.h \
    src/display_information.h \
    src/imagebinaryloader.h \
    src/imagepicker.h \
    src/imageresponseprovider.h \
    src/model.h \
    src/native_app.h \
    src/networker.h \
    src/option.h \
    src/settings.h \
    src/enums.h \
    src/page_manager.h

SOURCES += \
    src/commander.cpp \
    src/dbmanager.cpp \
    src/display_information.cpp \
    src/imagebinaryloader.cpp \
    src/imagepickerinterface.cpp \
    src/main.cpp \
    src/native_app.cpp \
    src/networker.cpp \
    src/settings.cpp \
    src/ini.cpp \
    src/model.cpp

RESOURCES += \
    qml.qrc \
    font.qrc \
    img.qrc

android {
    QT += androidextras

    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android-sources-native/app

    SOURCES += $$files(android-sources-qt/*.cpp)
    HEADERS += $$files(android-sources-qt/*.h)
}

ios {
    OBJECTIVE_SOURCES += \
        $$files(ios-sources-native/*.h) \
        $$files(ios-sources-native/*.m) \
        $$files(ios-sources-native/*.mm) \

    assets_catalogs.files = $$files($$PWD/ios-sources-native/*.xcassets)\
                            $$PWD/ios-sources-native/SplashLaunchScreen.xib
    QMAKE_BUNDLE_DATA += assets_catalogs
    QMAKE_INFO_PLIST = $$PWD/ios-sources-native/info.plist

    LIBS += -framework MobileCoreServices
    LIBS += -framework SystemConfiguration
    LIBS += -framework UserNotifications

    #KAKAOTALK
    LIBS += -F$$PWD/ioslib/KakaoSDK \
            -framework KakaoLink \
            -framework KakaoCommon \
            -framework KakaoMessageTemplate \
            -framework KakaoOpenSDK
#    LIBS += -force_load /Users/jhkim/Desktop/mobile.cliplearning/client_mobile/cliplearning/ios-libraries/KakaoSDK/KakaoOpenSDK.framework/KakaoOpenSDK
#    LIBS += -force_load ($$PWD/ioslib/KakaoSDK/KakaoOpenSDK.framework/KakaoOpenSDK)
#    LIBS += -force_load ($(BUILT_PRODUCTS_DIR)/ioslib/KakaoSDK/KakaoOpenSDK.framework/KakaoOpenSDK)
#    LIBS += -force_load ($(SRCROOT)/KakaoOpenSDK.framework/KakaoOpenSDK)
    LIBS += -force_load $(PROJECT_DIR)/KakaoOpenSDK.framework/KakaoOpenSDK

    #FACEBOOK
    LIBS += -F$$PWD/ioslib/FacebookSDK \
            -framework FBSDKCoreKit \
            -framework FBSDKLoginKit \
            -framework FBSDKShareKit \
            -framework Bolts
}

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    img/splash.jpg \
    android-sources-native/app/src/com/codymonster/ibeobom/KaKaoLoginControl.java \
    android-sources-native/app/src/com/codymonster/ibeobom/KakaoSDKAdapter.java \
    android-sources-native/app/src/com/codymonster/ibeobom/KakaoSignupActivity.java \
    android-sources-native/app/res/drawable/splash_background.xml \
    android-sources-native/app/src/com/codymonster/ibeobom/RSA.java \
    android-sources-native/app/src/com/codymonster/ibeobom/RequestHttpURLConnection.java \
    android-sources-native/app/src/com/codymonster/ibeobom/MultiDexApplication.java \
    android-sources-native/app/src/com/codymonster/ibeobom/MultiDexApplication.java

#ANDROID
DISTFILES += $$files(android-sources-native/app/*.*)
DISTFILES += $$files(android-sources-native/app/src/com/codymonster/ibeobom/*.*)
#DISTFILES += $$files(android-sources-native/libs/*.*)
DISTFILES += $$files(android-sources-native/app/res/*.*)
DISTFILES += $$files(android-sources-native/app/res/layout/*.*)
DISTFILES += $$files(android-sources-native/app/res/values/*.*)
DISTFILES += $$files(android-sources-native/app/res/xml/*.*)
DISTFILES += $$files(android-sources-native/app/res/values-ko/*.*)
DISTFILES += $$files(android-sources-native/app/res/drawable/*.*)
DISTFILES += $$files(android-sources-native/app/res/drawable-v24/*.*)
DISTFILES += $$files(android-sources-native/app/res/mipmap-anydpi-v26/*.*)
DISTFILES += $$files(android-sources-native/app/res/mipmap-hdpi/*.*)
DISTFILES += $$files(android-sources-native/app/res/mipmap-mdpi/*.*)
DISTFILES += $$files(android-sources-native/app/res/mipmap-xhdpi/*.*)
DISTFILES += $$files(android-sources-native/app/res/mipmap-xxhdpi/*.*)
DISTFILES += $$files(android-sources-native/app/res/mipmap-xxxhdpi/*.*)

#IOS
DISTFILES += $$files(ios-sources-native/*.*)
DISTFILES += $$files(ios-sources-native/Images.xcassets/*.*)
DISTFILES += $$files(ios-sources-native/Images.xcassets/AppIcon.appiconset/*.*)
DISTFILES += $$files(ios-sources-native/Images.xcassets/LaunchImage.launchimage/*.*)
DISTFILES += $$files(ios-sources-native/Images.xcassets/Default.png)
DISTFILES += $$files(ios-sources-native/Images.xcassets/Default-586@2x.png)
DISTFILES += $$files(ios-sources-native/Images.xcassets/Default-667@2x.png)
DISTFILES += $$files(ios-sources-native/Images.xcassets/Default-736h@3x.png)
DISTFILES += $$files(ios-sources-native/Images.xcassets/Default@2x.png)
DISTFILES += $$files(ios-sources-native/Images.xcassets/Default.png)
