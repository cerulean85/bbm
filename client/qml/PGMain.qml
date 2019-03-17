import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import "Resources.js" as R
import enums 1.0

PGPage {
    id: mainView
    visibleBackBtn: true
    backImg: R.image("alarm")
    leftBtnWidth: R.dp(100)
    leftBtnHeight: R.dp(78)
    leftBtnMargin: R.dp(70)
    rightBtnMargin: R.dp(70)
    visibleSearchBtn: true
    titleText: "<font color='" + R.color_theme01 +"'>CLIP</font>" +"<font color='black'> LEARNING</font>"
    titleBgColor: "transparent"
    pageName: "Main"

    property bool initTab1 : false
    property bool initTab2 : false
    property bool initTab3 : false
    property bool initTab4 : false
    property int tLength : opt.ds ? 5 : md.tablist.length
    property int currentTab : 0

    property int categoryCount : opt.ds ? 7 : md.categorylist.length
    property int heightCategoryArea: R.dp(100)
    property int widthCategoryArea: opt.ds ? mainView.width : R.dp(100)

    onEvtBehaviorAndroidBackButton:
    {
        if(closeWindowInMain()) return;

        if(alarmList.x === 0)
        {
            if(!hideAlarm()) alarmList.hideMoveView();
        }
        else if(option.x === 0)
        {
            if(!hideAlarm()) option.evtBehaviorAndroidBackButton();
        }
        else if(pointInformation.opacity === 1.0)
        {
            pointInformation.hideOpacityView();
        }
        else exitMethodByAndroidBackButton();
    }

    Timer
    {
        running: opt.ds ? false : wk.updateUserProfileResult !== ENums.WAIT
        repeat: false
        onTriggered:
        {
            md.setShowIndicator(false);
            var result = wk.vUpdateUserProfileResult();
            if(result === ENums.POSITIVE)
            {
                alarm("성공적으로 변경되었습니다");
                ap.setYMethod(mainView, "evtBehaviorAndroidBackButton");
            }
            else if(result === ENums.PICKER)
            {
//                alarm("성공적으로 변경되었습니다");
                settings.setProfileImage(mainImgSelector.selectedFilePath);
                settings.setThumbnailImage(mainImgSelector.selectedFilePath);
                md.setShowIndicator(false);
            }
            else error();
        }
    }

    Component.onCompleted:
    {
        enrollPageAtHomeStack("Main");
        loader.sourceComponent = componentHome;
        if(!opt.ds)
        {
            md.tablist[0].select(true);
            setMainTabName("Home");
        }
//        ggg.running = true;
    }

    Timer
    {
        id: ggg
        running: false
        repeat: false
        interval: 10000
        onTriggered:
        {
            loader.sourceComponent = componentHome;
            if(!opt.ds)
            {
                md.tablist[0].select(true);
                setMainTabName("Home");
            }
        }

    }

    useDefaultEvtBack: false
    onEvtBack:
    {
        if(logined())
        {
            alarmList.getAlarmList();
            alarmList.showMoveView();
        }
        else alarmNeedLogin();
    }

    onEvtSearch:
    {
        if(currentTab == 3)
        {
            pointInformation.showOpacityView();
            return;
        }

        md.setViewOption(true);
        option.showView();
        //        pushHomeStack("Option", { }, StackView.PushTransition);
    }

    Timer
    {
        running: opt.ds ? false : (md.requestNativeBackBehavior === ENums.REQUESTED_BEHAVIOR && compareCurrentPage("Main"))
        repeat: false
        interval: 300
        onTriggered:
        {
            md.setRequestNativeBackBehavior(ENums.WAIT_BEHAVIOR);
            evtBehaviorAndroidBackButton();
        }
    }

    Loader
    {
        id: loader
        width: mainView.width
        height: mainView.height - R.height_tabBar - R.height_titleBar - mainView.heightBottomArea - mainView.heightStatusBar
    }

    Component
    {
        id: componentHome
        PGHome
        {
            width: loader.width
            height: loader.height
            y: mainView.heightStatusBar + R.height_titleBar

            Component.onCompleted:
            {
                mainView.titleType = 1;
                mainView.titleText = ""
                mainView.titleLineColor = R.color_theme01
                mainView.searchImg = R.image("setting")
                mainView.titleBarVisible = true;
                mainView.colorStatusBar = "white";
                mainView.showNewAlarm = true;
                if(opt.ds) return;

                cmd.setStatusBarColor("white");
                np.bringNotifyResult();
            }
        }
    }

    Component
    {
        id: componentSearch
        PGSearch
        {
            width: loader.width
            height: loader.height + R.height_titleBar
            y: mainView.heightStatusBar//+ heightCategoryArea

            Component.onCompleted:
            {
                loader.height = mainView.height - R.height_tabBar - mainView.heightBottomArea - mainView.heightStatusBar;
                mainView.titleType = 0;
                mainView.titleText = "<font color='black'>검색</font>"
                mainView.titleLineColor = "black"
                mainView.searchImg = R.image("setting")
                mainView.titleBarVisible = false;
                mainView.colorStatusBar = R.color_bgColor002;
                mainView.showNewAlarm = false;
                if(opt.ds) return;
                cmd.setStatusBarColor(R.color_bgColor002);
            }
        }
    }

    Component
    {
        id: componentTabPoint
        PGPointDesk
        {
            width: loader.width
            height: loader.height
            y: mainView.heightStatusBar + R.height_titleBar //+ heightCategoryArea

            Component.onCompleted:
            {
                mainView.titleType = 0;
                mainView.titleText = "<font color='black'>포인트</font>"
                mainView.titleLineColor = "white"
                mainView.searchImg = R.image("que")
                mainView.titleBarVisible = true;
                mainView.colorStatusBar = "white";
                mainView.showNewAlarm = true;
                if(opt.ds) return;
                cmd.setStatusBarColor("white");

            }
        }
    }

    Component
    {
        id: componentLike
        PGLike
        {
            id: likeTab
            width: loader.width
            height: loader.height
            y: mainView.heightStatusBar + R.height_titleBar //+ heightCategoryArea

            Component.onCompleted:
            {
                mainView.titleType = 0;
                mainView.titleText = "<font color='black'>좋아요</font>"
                mainView.titleLineColor = "black"
                mainView.searchImg = R.image("setting")
                mainView.titleBarVisible = true;
                mainView.colorStatusBar = "white";
                mainView.showNewAlarm = true;
                if(opt.ds) return;
                cmd.setStatusBarColor("white");

                R.log("clearComponent PGLIKE.");
                likeTab.clearCategoryButtons();
                md.catelikelist[0].select(true);

                likeTab.getClipLikeData();
                setLikeTabName("Clip");
            }
        }
    }

    Rectangle
    {
        id: tabRect
        width: parent.width
        height: R.height_tabBar

        anchors
        {
            bottom: parent.bottom
            bottomMargin: opt.ds ? R.dp(44) : settings.heightBottomArea
        }

        Column
        {
            width: parent.width
            height: parent.height

            Rectangle
            {
                id: line
                width: parent.width
                height: Qt.platform.os === "ios" ? 1 : R.dp(4)
                color:R.color_gray001
            }

            Row
            {
                width: parent.width
                height: R.height_tabBar - line.height

                Repeater
                {
                    model: tLength
                    CPButtonToggleTab
                    {
                        width: parent.width / tLength
                        height: R.height_tabBar - line.height
                        title:
                        {
                            if(opt.ds) return "untitled"
                            switch(index)
                            {
                            case 0: return "홈";
                            case 1: return "검색";
                            case 2: return "좋아요";
                            case 3: return "포인트";
                            case 4: return settings.logined ? "마이페이지" : "로그인";
                            }
                        }
                        fontSize: R.pt(30)
                        iconWidth: R.dp(90)
                        iconHeight: R.dp(90)
                        heightTextArea: R.dp(30)
                        releasedColor: "black"
                        pressedColor: R.color_theme01
                        spacingValue: R.dp(12)
                        selected:
                        {
                            if(opt.ds) return false;
                            return md.tablist[index].selected;
                        }
                        onEvtSelect:
                        {

                            if(opt.ds) return;

                            wk.setRefreshWorkResult(ENums.NONE);
                            switch(index)
                            {
                            case 0:
                                clearAll();
                                md.selectCategory("");
                                selectedHomeTab.run = true;
                                tmMoveToHome.run = true;
                                setMainTabName("Home");
                                break;
                            case 1:
                                clearAll();
                                loader.sourceComponent = componentSearch;
                                setMainTabName("Search");
                                break;
                            case 2:
                                if(!logined())
                                {
                                    alarmNeedLogin();
                                    return;
                                }
                                clearAll();
                                loader.sourceComponent = componentLike;
                                setMainTabName("Like");
                                break;
                            case 3:
                                clearAll();
                                loader.sourceComponent = componentTabPoint;
                                setMainTabName("Point");
                                break;
                            case 4:
                                showMyPage(true);
                                break;
                            }

                            if(index != 4)
                            {
                                for(var i=0; i<md.tablist.length; i++)
                                {
                                    md.tablist[i].select(false);
                                }
                                md.tablist[index].select(true);
                                currentTab = index;
                            }
                        }

                        pressedSource:
                        {
                            if(!opt.ds) return md.tablist[index].pressedImg;

                            switch(index)
                            {
                            case 0: return R.image("home_pink");
                            case 1: return R.image("search_pink");
                            case 2: return R.image("like_pink");
                            case 3: return R.image("point_pink");
                            case 4: return R.image("mypage_pink");
                            default: return R.image("noitem_pressed_24dp");
                            }
                        }
                        releasedSource:
                        {
                            if(!opt.ds) return md.tablist[index].releasedImg;

                            switch(index)
                            {
                            case 0: return R.image("home");
                            case 1: return R.image("search");
                            case 2: return R.image("like");
                            case 3: return R.image("point");
                            case 4: return R.image("mypage");
                            default: return R.image("noitem_released_24dp");
                            }
                        }
                    }
                }
            }
        }
    }

    CPFlickMoreIndicator
    {
        width: parent.width
        height: R.dp(120)

        condRun: ENums.WORKING_MAIN
        condStop: ENums.FINISHED_MAIN

        anchors
        {
            bottom: parent.bottom
            bottomMargin: R.height_tabBar + mainView.heightBottomArea
        }
    }

    CPTimer
    {
        id: tmMoveToHome
        tmInterval: 200
        onEvtTriggered:
        {
            loader.sourceComponent = componentHome;
        }
    }

    CPTimer
    {
        id: selectedHomeTab
        onEvtTriggered:
        {
            wk.getMain(1, "");
            wk.request();
            loader.sourceComponent = componentHome;
        }
    }

    function clearAll()
    {
        if(opt.ds) return;
        //        md.clearBannerList();
        //        md.clearHomeList();
        md.clearSearchClipList();
        md.clearLikeClipList();
        md.clearLikeRepleList();
    }

    CPEventPopup
    {
        id: eventPopup
        width: parent.width
        height: parent.height
        onEvtClicked: tmGoToNoticeDetail.run = true;
        source: opt.ds ? "" : R.startsWithAndReplace(md.noticePopup.imageUrl, "https", "http")
    }

    CPTimer
    {
        run: md.checkedSystem === ENums.POSITIVE
        tmInterval: 800
        onEvtTriggered:
        {
            if((md.noticePopup.popupNo !== settings.noShowNoticePopupNo) && (md.noticePopup.popupNo > 0))
            {
                eventPopup.show();
            }
        }
    }

    CPTimer
    {
        id: tmGoToNoticeDetail
        onEvtTriggered: pushHomeStack("NoticeDetail");
    }

    PGPushList
    {
        id: alarmList
        x: -(opt.ds ? R.dp(1242) : appWindow.width)
    }

    PGOption
    {
        id: option
        visible: false
        x: (opt.ds ? R.dp(1242) : appWindow.width)
    }

    PGPointInformation
    {
        id: pointInformation
    }

    Timer
    {
        running: opt.ds ? false : (md.cantLoadContent === true)
        repeat: false
        onTriggered:
        {
            md.setCantLoadContent(false);

            alarm(R.message_cant_load_content);
            ap.setYMethod(mainView, "empty");
        }
    }

    PGGuide
    {
        id: guideView
        enabled: false //opt.ds ? false : !settings.hideGuide
        visible: false //opt.ds ? false : !settings.hideGuide
    }
}
