import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.10
import "Resources.js" as R
import enums 1.0

ApplicationWindow {
    id: appWindow
    visible: true
    /* If no has Qt.Window, the keyboard wouldn't be showed.  */
    flags:  (Qt.Window | Qt.MaximizeUsingFullscreenGeometryHint)

    Component.onCompleted:
    {
        if(opt.ds) return;
        cmd.setStatusBarColor(R.color_bgColor001);

        if(cmd.isOnline() === 0)
        {
            md.setError("네트워크가 연결되어 있지 않습니다. 네트워크 상태를 확인해주세요.");
            md.setCheckedSystem(ENums.NOT_OPENED);
            return;
        }
    }

    Timer
    {
        id: pushingServToCheckSecured
        running: opt.ds ? false : true
        repeat: true
        interval: 300
        onTriggered:
        {
            var state = np.isSystemSecured();
            if(state===true)
            {
                R.log("Stopped Pushing..");
                pushingServToCheckSecured.stop();
                wk.getSystemInfo();
                wk.request();
            }
        }
    }

    Timer
    {
        running: opt.ds ? false : wk.getSystemInfoResult !== ENums.WAIT
        repeat: false
        interval: 200
        onTriggered:
        {
            var result = wk.vGetSystemInfoResult()
            if(result === ENums.POSITIVE)
            {
                np.removeBadge();

                var deviceName = np.getDeviceName();
                if(Qt.platform.os === R.os_name_ios)
                {
                    if(deviceName === "iPhone X" || deviceName === "iPhone XR" || deviceName === "iPhone XS" || deviceName === "iPhone XS Max")
                    {
                        settings.setHeightStatusBar(R.dp(70));
                        settings.setHeightBottomArea(R.dp(44));
                        settings.setFontSizeDeliveryBtn(R.pt(60));
                    }
                    else
                    {
                        settings.setHeightStatusBar(R.dp(60));
                        settings.setHeightBottomArea(R.dp(0));
                        settings.setFontSizeDeliveryBtn(R.pt(45));
                    }
                }

                if(settings.snsType === ENums.SELF)
                {
                    if(settings.id !== "" && settings.autoLogin) wk.login();
                    else wk.getMain(1, "");
                }
                else
                {
                    if(settings.id !== "" && settings.autoLogin) wk.login();
                    else wk.getMain(1, "");
                }

//                if(settings.id !== "" && settings.autoLogin /* && settings.snsType !== ENums.SELF*/)
//                {
//                    wk.login();
//                }
//                else wk.getMain(1, "");
                wk.request();

            }
            else alarmAboutError(md.error, "exitApp");
        }
    }

    StackView
    {
        id: homeStackView
        anchors.fill: parent
        initialItem: PGMain
        {
            width: parent.width
            height: parent.height
        }
    }

    Timer
    {
        id: updatorApp
        running: opt.ds? false : md.needUpdateApp
        onTriggered:
        {
            var error = "최신 버전(v"+settings.versServer + ")의 앱으로 업데이트 후 이용가능합니다.";
            alarmAboutError(error, "openMarket");
        }
    }

    Timer
    {
        id: updatorOS
        running: opt.ds? false : md.needUpdateOS
        onTriggered:
        {
            var error = "지원하지 않는 " + settings.osName + " 버전입니다.\nOS업그레이드 후 이용가능합니다.\n(현재버전:v" + cmd.versionOS() + ", 지원버전:v"+settings.versOS.toFixed(0) + "이상)";
            alarmAboutError(error, "exitApp");
        }
    }

    Timer
    {
        id: exitor
        running: false
        repeat: false
        interval: 1000
        onTriggered:
        {
            exitApp();
        }
    }

    function openMarket()
    {
        np.openMarket();

        if(Qt.platform.os === R.os_name_ios)
            exitor.running = true;
    }
    function exitApp() { cmd.exit(); }
    function empty() {}

    Timer
    {
        id: ctrlUserStack_hide
        running: userStackView.depth === 0
        repeat: false
        interval: 500
        onTriggered:
        {
            userStackView.visible = false;
        }
    }

    Timer
    {
        id: ctrlUserStack_show
        running: userStackView.depth > 0
        repeat: false
        interval: 0
        onTriggered:
        {
            userStackView.visible = true
        }
    }

    StackView
    {
        id: userStackView
        width: parent.width
        height: parent.height
        visible: false
        //        initialItem: Rectangle
        //        {
        //            color: "black"
        //        }
    }

    PGSplash
    {
        id: splashView
        enabled: opt.ds ? true : md.checkedSystem !== ENums.POSITIVE
    }

    Timer
    {
        running: opt.ds ? false : md.forcedExit === true
        repeat: false
        interval: 200
        onTriggered:
        {
            exitApp();
        }
    }

    Timer
    {
        id: systemChecker_notOpened
        running: opt.ds ? false : md.checkedSystem === ENums.NOT_OPENED
        repeat: false
        onTriggered:
        {
            alarmAboutError(md.error, "exitApp");
        }
    }

    Timer
    {
        id: systemChecker_positive
        running: opt.ds ? false : md.checkedSystem === ENums.POSITIVE
        repeat: false
        onTriggered:
        {
            R.log("SYSTEM OK.");
            splashView.visible = false
            alarmPopup.width = appWindow.width;
            var osType = Qt.platform.os;
            var osVersion = cmd.versionOS();
            var minversOS = settings.versOS;
            if ((osType === "android" && osVersion < minversOS) || (osType ==="ios" && osVersion < minversOS))
            {
                cmd.exit();
                return;
            }
        }
    }

    property bool doQuit: false
    Timer
    {
        id: doQuitControl
        interval:1500
        repeat: false
        onTriggered: {
            doQuit = false
        }
    }

    PGMyPage
    {
        id: myPage
        x: (opt.ds ? R.dp(1242) : appWindow.width)
    }

    PGMyProfile
    {
        id: myProfile
        x: (opt.ds ? R.dp(1242) : appWindow.width)
        visible: false
    }

    PGSetBirth
    {
        id: setBirth
        x: (opt.ds ? R.dp(1242) : appWindow.width)
        visible: false
    }

    PGSetEmail
    {
        id: setEmail
        x: (opt.ds ? R.dp(1242) : appWindow.width)
        visible: false
    }

    PGSetGender
    {
        id: setGender
        x: (opt.ds ? R.dp(1242) : appWindow.width)
        visible: false
    }

    PGSetName
    {
        id: setName
        x: (opt.ds ? R.dp(1242) : appWindow.width)
        visible: false
    }

    CPCommentViewer
    {
        id: commentWindow
        x: (opt.ds ? R.dp(1242) : appWindow.width)
        visible: false
    }

    PGIMGMethodSelector
    {
        id: mainImgSelector
        enabled: false
        width: parent.width
        height: parent.height
    }

    CPIMGView
    {
        id: showBigImage
        opacity: 0
        width: parent.width
        height: parent.height
    }

    CPAlarmPopup
    {
        id: alarmPopup
        width: 0//parent.width
        height: parent.height
        z: 9998
    }

    OpacityAnimator {
        id:fadeinAnimator
        target: alarmPopup;
        from: 0;
        to: 1;
        duration: 200
        running: opt.ds ? false : ap.visible
    }

    OpacityAnimator {
        id:fadeoutAnimator
        target: alarmPopup;
        from: 1;
        to: 0;
        duration: 200
        running: opt.ds ? false : !ap.visible
    }


    Rectangle
    {
        id: busyArea
        width: parent.width
        height: parent.height
        color: "black"
        opacity: 0.7
        visible: opt.ds ? false : md.showIndicator
        z: 9999

        Column
        {
            width: R.dp(300)
            height: R.dp(300)
            anchors
            {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }
            CPBusyIndicator
            {
                id: busyIndi
                width: parent.width
                height: parent.height
                visible: opt.ds ? false : md.showIndicator
            }
            LYMargin {
                height: R.dp(100)
            }
        }

        MouseArea
        {
            id: ma
            width: parent.width
            height: parent.height
        }
    }

    function cantLoadContent()
    {
        alarm("콘텐츠를 불러올 수 없습니다.");
        ap.setYMethod(mainView, "empty");
    }

    function alarmAboutError(msg, funcName)
    {
        alarmPopup.width = appWindow.width;
        ap.setVisible(true);
        ap.setMessage(msg);
        ap.setYButtonName("확인");
        ap.setButtonCount(1);
        ap.setYMethod(appWindow, funcName);
    }
}

