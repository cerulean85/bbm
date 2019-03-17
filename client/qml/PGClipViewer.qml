import QtQuick 2.9
import "Resources.js" as R
import enums 1.0
import QtQuick.Controls 2.2
import QtWebView 1.1

PGPage
{
    id: mainView
    visibleSearchBtn: true
    searchImg: R.image("mypage")
    titleText: opt.ds ? "일러스트 기초" : md.clipDetail.title
    titleTextColor: "black"
    titleLineColor: "black"
    visibleBackBtn: true
    forceAlignHCenter: false
    pageName: "ClipViewer"

    property bool answered: false
    property int seconds: 0
    property bool hasQuiz: opt.ds ? true : (md.quizList.length > 0)

    property int noClip: opt.ds ? 0 : md.currentClipNo
    property int noCourse: opt.ds ? 0 : md.currentCourseNo
    property bool notified: false
    property string linkUrl: opt.ds ? "" : R.toHttp(md.clipDetail.linkUrl)

    property int openedWindow: ENums.CLOSED_ALL_WINDOW
    property int currentController: ENums.CONTROLLER_WINDOW
    property int listIndex: 0
    property string from: R.viewer_from_desk

    useDefaultEvtBack: false
    onEvtBack:
    {
        R.log("onEvtBack: back");

        clock.running = false;
        if(opt.ds) return;

        if(from === R.viewer_from_desk)
            md.clipList[listIndex].setViewCount(md.clipList[listIndex].viewCount+1);
        else if(from === R.viewer_from_like_clip)
            md.likeClipList[listIndex].setViewCount(md.likeClipList[listIndex].viewCount+1);
        else if(from === R.viewer_from_like_comment)
            md.likeRepleList[listIndex].setViewCount(md.likeRepleList[listIndex].viewCount+1);
        else if(from === R.viewer_from_search)
            md.searchClipList[listIndex].setViewCount(md.searchClipList[listIndex].viewCount+1);

        showContent(false, false);
        tmUpdateStudyTime.running = true;
        md.clearClipDetail();
        md.clearRepleList();
        md.setNativeChanner(0);
        clipViewer.setRunningDataGetter(false);
        clipViewer.setRefreshWebView(false);
        clipViewer.setLoadRefreshedWebView(false);
        popStack();
    }

    onEvtSearch:
    {
        md.setUnvisibleWebView(true);

        if(md.clipDetail.isVerticalVideo === 0) videoPlayer.pause();
        else videoPlayer_portrait.pause();

        showContent(false, false);
        showMyPage(true);

        if(!logined())
            md.setNativeChanner(0);
    }

    refreshByTitleButton: true
    onEvtRefreshByTitleButton: webView.reload();

    Timer
    {
        id: tmUpdateStudyTime
        running: false
        repeat: false
        interval: 200
        onTriggered:
        {
            wk.updateStudyTime(noClip, seconds);
            wk.request();
        }
    }

    Timer
    {
        id: clearModel
        running: false
        repeat: false
        interval: 300
        onTriggered:
        {
            md.clearClipDetail();
            clipViewer.setRunningDataGetter(false);
            clipViewer.setRefreshWebView(false);
            clipViewer.setLoadRefreshedWebView(false);
            popStack();
        }
    }

    function popStack()
    {
        popHomeStack();
        md.setNativeChanner(0);
    }

    function backBehaviroForAndroid()
    {
        md.setRequestNativeBackBehavior(ENums.WAIT_BEHAVIOR);

        if(md.fullScreen) return;
        if(openedWindow === ENums.CLOSED_ALL_WINDOW)
        {
            if(!showedAlarm())
            {
                if(closeWindowInMain()) return;
                evtBack();
            }
            else hideAlarmWindow();
        }
        else hideRegionAll(false);
    }

    onEvtBehaviorAndroidBackButton:
    {
        md.setRequestNativeBackBehavior(ENums.FINISHED_BEHAVIOR);
        backBehaviroForAndroid();
        return;
    }

    Timer
    {
        id: tmWhenClosedAllWindow
        running: opt.ds ? false : (md.requestNativeBackBehavior === ENums.REQUESTED_BEHAVIOR_WEBVIEW)
        repeat: false
        interval: 200
        onTriggered:
        {
            backBehaviroForAndroid();
        }
    }

    Component.onCompleted:
    {
        if(opt.ds) return;
        showIndicator(false);
        clipViewer.setRunningDataGetter(true);
        clock.running = true;
        //        np.execTimer(true);

        if(!isVideo() && Qt.platform.os === R.os_name_android)
            webView.url = "";
    }

    Timer
    {
        id: dataGetter
        running: opt.ds ? false : clipViewer.runningDataGetter
        repeat: false
        interval: opt.ds ? 300  : (notified ? 1500 : 300)
        onTriggered:
        {
            clipViewer.setRunningDataGetter(false);
            if(noCourse < 1 || noClip < 1)
            {
                //                R.log("Where: PGClipViewer.qml >> noCourse < 1 || noClip < 1");
                md.setCantLoadContent(true);
                popStack();
                return;
            }

            if(cmd.isOnline() === 2)
            {
                showContent(false, false);
                tmShowAlarm.running = true;
                return;
            }

            getClipDetailByPopButton();
        }
    }

    Timer
    {
        id: tmShowAlarm
        running: false
        repeat: false
        interval: 500
        onTriggered:
        {
            alarm("3G/LTE 네트워크 이용 시 데이터 이용료가 부과됩니다. 네트워크 환경을 확인해주세요.");
            ap.setYMethod(mainView, "getClipDetailByPopButton");
        }
    }

    function getClipDetailByPopButton()
    {
        tmGetClipDetail.running = true;
    }

    Timer
    {
        id: tmGetClipDetail
        running: false
        repeat: false
        interval: 300
        onTriggered:
        {
            if(notified) wk.getClipDetailForDelivery(noClip, noCourse);
            else wk.getClipDetail(noClip, noCourse);

            wk.request();
        }
    }

    //    TimerloadingChanged(WebViewLoadRequest loadRequest)
    //    {
    //        id: reload
    //        running: true
    //        repeat: true
    //        interval: 2000
    //        onTriggered:
    //        {
    //            R.log("Check Webview status : ");

    //        }
    //    }

    Timer
    {
        running: opt.ds ? false : settings.logined
        repeat: false
        interval: 200
        onTriggered:
        {
            wk.getClipSharing(noClip);
            wk.request();
        }
    }

    Timer
    {
        running: opt.ds ? false : (wk.getClipDetailResult === ENums.POSITIVE)
        repeat: false
        onTriggered:
        {
            wk.vGetClipDetailResult();
            showContent(true, false);

            if(!isVideo() && Qt.platform.os === R.os_name_android)
                webView.url = linkUrl;
        }
    }

    Timer
    {
        id: clock
        running: false
        repeat: true
        interval: 1000
        onTriggered:
        {
            seconds = seconds + 1;
            //R.log("Listenning.... " + seconds);
        }
    }

    property int heightRowItem: R.dp(570)
    property int widthRowItem: R.dp(512)
    property int dLength : opt.ds ? 40 : md.clipList.length
    property int rowItemLength : (dLength / 2 + (dLength % 2 == 1 ? 1 : 0))

    //    property bool showCommentsDate : true
    //    property bool showedCommentWindow : false
    property bool showedQuizWindow : false

    Rectangle
    {
        y: settings.heightStatusBar + R.height_titleBar
        width: parent.width
        height: R.dp(10)
        color: "white"
    }

    Rectangle
    {
        y: settings.heightStatusBar + R.height_titleBar
        width: (webView.loadProgress===100) ? 0 : (parent.width * (webView.loadProgress / 100.0))
        height: R.dp(10)
        color: R.color_bgColor001
    }

    PGVideoPlayerLandscape
    {
        id: videoPlayer
        y: md.fullScreen ? 0 : settings.heightStatusBar + R.height_titleBar + R.dp(10)
        z: md.fullScreen ? 9999 : 0
        url: opt.ds ? "" : linkUrl
        visible: false
        enabled: false
    }

    PGVideoPlayerPortrait
    {
        id: videoPlayer_portrait
        y: md.fullScreen ? 0 : settings.heightStatusBar + R.height_titleBar + R.dp(10)
        z: md.fullScreen ? 9999 : 0
        url: opt.ds ? "" : linkUrl
        visible: false //opt.ds ? false : isVideo()
        enabled: false //opt.ds ? false : isVideo()
    }

    Rectangle
    {
        id: opacityWindow
        width:parent.width
        height: parent.height - mainView.heightBottomArea
        color: "black"
        opacity: 0
        enabled: false

        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                R.hideKeyboard();
                hideRegionAll(true);
            }
        }
    }

    Rectangle
    {
        id: quizWindow
        width: parent.width
        height: R.dp(1088)

        LYMargin { width: parent.width; height: R.height_line_1px; color: "black" }
        y: parent.height
        MouseArea { anchors.fill: parent }

        Column
        {
            width: parent.width
            height: parent.height - R.height_line_1px
            LYMargin { width: parent.width; height: R.height_line_1px; color: "black" }

            LYMargin { height: R.dp(100) }

            Rectangle
            {
                width: parent.width
                height: R.dp(950)

                CPText
                {
                    id: questionTxt
                    width: parent.width - R.dp(140)
                    text: "Q " + (opt.ds ? "01. 펜툴의 단축키는?" : (md.quizList.length > 0 ? md.quizList[0].quizText : "퀴즈가 존재하지 않습니다."))
                    font.pointSize: R.pt(50)
                    anchors
                    {
                        left: parent.left
                        leftMargin: R.dp(70)
                    }
                }

                Rectangle
                {
                    id: examplesBox
                    width: parent.width
                    height: opt.ds ? R.dp(400) : R.dp(130) * md.quizList.length

                    anchors
                    {
                        top: questionTxt.bottom
                        topMargin: R.dp(30)
                    }

                    Column
                    {
                        width: parent.width
                        height: parent.height

                        Repeater
                        {
                            model : opt.ds ? 5 : (md.quizList.length > 0 ? (md.quizList[0].examples.length) : 0)

                            Column
                            {
                                width: parent.width
                                height: R.dp(130)
                                Rectangle
                                {
                                    width: parent.width
                                    height: R.dp(110)

                                    Rectangle
                                    {
                                        width: parent.width - R.dp(140)
                                        height: parent.height
                                        anchors
                                        {
                                            left: parent.left
                                            leftMargin: R.dp(70)
                                        }

                                        Rectangle
                                        {
                                            id: radioBox
                                            width: R.dp(50)
                                            height: R.dp(50)
                                            radius: 20
                                            border.width: R.height_line_1px
                                            border.color: R.color_bgColor001
                                            color: "white"

                                            CPImage
                                            {
                                                width: R.dp(50)
                                                height: R.dp(50)
                                                source: R.image("check_mark")
                                                visible: opt.ds ?  true :( md.quizList[0].examples[index].selected > 0 ? true : false)
                                            }

                                            anchors
                                            {
                                                verticalCenter: parent.verticalCenter
                                            }

                                        }

                                        CPText
                                        {
                                            text: (index+1) + "번. " + (opt.ds ? "Ctrl + A" : md.quizList[0].examples[index].example)
                                            width: parent.width
                                            height: parent.height
                                            verticalAlignment: Text.AlignVCenter
                                            font.pointSize: R.font_size_common_style_login
                                            anchors
                                            {
                                                left: radioBox.right
                                                leftMargin: R.dp(20)
                                            }
                                        }

                                        ColorAnimation on color {
                                            id: selectionExam
                                            from: R.color_grayE1
                                            to: "white"
                                            running: false
                                            duration: 100
                                        }

                                        MouseArea
                                        {
                                            anchors.fill: parent
                                            onClicked:
                                            {
                                                R.hideKeyboard();

                                                selectionExam.running = true
                                                showWindow(ENums.WINDOW_ANSWER, true);

                                                if(opt.ds) return;

                                                if(!isLogined(false)) return;

                                                if(md.quizList.length > 0)
                                                {
                                                    md.quizList[0].select(index);

                                                    if(!answered)
                                                    {
                                                        answered = true;
                                                        wk.setQuiz(md.quizList[0].quizNo, md.quizList[0].quizType, md.quizList[0].examples[index].exampleNo, noClip, noCourse);
                                                        wk.request();
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                LYMargin { height: R.dp(20) }
                            }
                        }
                    }
                }
            }
        }
    }

    Rectangle
    {
        id: answerWindow
        width: parent.width
        height: columnAnswer.height + (opt.ds ? R.dp(140) : (md.quizList.length > 0 ? R.dp(140) : 0))
        color: R.color_bgColor002
        y: parent.height

        Column
        {
            id: columnAnswer
            width: parent.width - R.dp(140)
            anchors
            {
                left: parent.left
                leftMargin: R.dp(70)
                top: parent.top
                topMargin: R.dp(70)
            }
            CPText
            {
                id: answerTxt
                font.pointSize: R.font_size_common_style_login
                text: "정답: " + (opt.ds ? "1번" : (md.quizList.length > 0 ? (md.quizList[0].answerNo + "번") : "없음"))
            }
            CPText
            {
                id: descTxt
                width: parent.width
                visible: opt.ds ? true : (md.quizList.length > 0 ? (md.quizList[0].description === "" ? false : true) : false)
                font.pointSize: R.font_size_common_style_login
                text: "해설: " + (opt.ds ? "정답은 아무것도 아닙니다!" : (md.quizList.length > 0 ? (md.quizList[0].description === "" ? "" : md.quizList[0].description) : ""))
            }
        }

        Rectangle
        {
            width: R.dp(180)
            height: R.dp(180)
            color: "transparent"

            CPImage
            {
                width: R.dp(110)
                height: R.dp(110)
                source: R.image(R.btn_close_gray_image)
                anchors
                {
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }
            }

            anchors
            {
                right: parent.right
                top: parent.top
            }

            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    R.hideKeyboard();

                    colorAnimator2.running = true;

                    showWindow(ENums.WINDOW_ANSWER, false);
                }
            }

            ColorAnimation on color {
                id: colorAnimator2
                from: "#44000000"
                to: "transparent"
                running: false
                duration: 100
            }
        }
    }

    Rectangle
    {
        id: windowController
        width: parent.width
        height: R.dp(144)
        anchors
        {
            bottom: parent.bottom
            bottomMargin: mainView.heightBottomArea
            left: parent.left
        }

        CPClipViewerButton
        {
            buttonName: "  댓글 " + (opt.ds ? "1" : md.clipDetail.repleCount)
            txtWidth: R.dp(200)
            needLogin: false
            onEvtClicked:
            {
                executeComment.running = true;
            }

            Timer
            {
                id: executeComment
                running: false
                repeat: false
                interval: 200
                onTriggered:
                {
                    showContent(false, false);
                    showWindow(ENums.WINDOW_QUIZ, false);
                    showController(ENums.CONTROLLER_WINDOW, true);
                    md.showCommentViewer(true);

                    if(opt.ds) return;
                    repleListGetter.running = true;
                }
            }

            anchors
            {
                left: parent.left
                bottom: parent.bottom
            }
        }

        Timer
        {
            id: repleListGetter
            running: false
            repeat: false
            interval: 300
            onTriggered:
            {
                wk.getClipRepleList(noClip, 0, 1);
                wk.request();
            }
        }

        CPClipViewerButton
        {
            buttonName: hasQuiz ? "퀴즈" : "수강완료"
            txtWidth: hasQuiz ? R.dp(130) : R.dp(230)
            txtColor: R.color_bgColor001
            imageSource: hasQuiz ? R.image("class_quiz") : R.image("finished")

            onEvtClicked:
            {
                executeQuiz.running = true;
            }

            Timer
            {
                id: executeQuiz
                running: false
                repeat: false
                interval: 200
                onTriggered:
                {
                    if(opt.ds)
                    {
                        showWindow(ENums.WINDOW_QUIZ, true);
                        showWindow(ENums.WINDOW_OPACITY, true);
                        return;
                    }

                    showContent(false, false);

                    if(!isLogined(true))
                    {
                        ap.setNMethod(mainView, "hideAlarmWindow");
                        return;
                    }
                    R.log("If logined check the user no >> " + settings.noUser);

                    if(!hasQuiz)
                    {
                        alarm2(R.message_question_finish_clip);
                        ap.setYMethod(mainView, "setUnitComplete");
                        ap.setNMethod(mainView, "hideAlarmWindow");
                        return;
                    }

                    if(!showedQuizWindow)
                    {
                        R.log("Spread Quiz area.");
                        showWindow(ENums.WINDOW_QUIZ, true);
                        showWindow(ENums.WINDOW_OPACITY, true);
                        return;
                    }
                    R.log("Don't spread Quiz area.");
                }
            }

            anchors
            {
                right: buttonShare.left
                rightMargin: R.dp(10)
                bottom: parent.bottom
            }
        }

        CPClipViewerButton
        {
            id: buttonShare
            buttonName: "공유"
            txtWidth: R.dp(130)
            imageSource: R.image("class_share")
            onEvtClicked:
            {
                if(!isLogined(true))
                {
                    return;
                }

                executeShare.running = true;
            }

            Timer
            {
                id: executeShare
                running: false
                repeat: false
                interval: 200
                onTriggered:
                {
                    showWindow(ENums.WINDOW_SHARE, true);
                    showContent(false, false);
                }
            }

            anchors
            {
                right: buttonLike.left
                rightMargin: R.dp(10)
                bottom: parent.bottom
            }
        }

        CPClipViewerButton
        {
            id: buttonLike
            buttonName: "좋아요"
            txtWidth: R.dp(180)
            selected: opt.ds ? true : md.clipDetail.like
            imageSource: selected ? R.image("mypage_like_pink") : R.image("mypage_like")
            onEvtClicked:
            {
                if(!isLogined(true))
                {
                    R.log("[Like] Please login to use this function.");
                    return;
                }
                R.log("If logined check the user no >> " + settings.noUser);

                R.log("Pressed the like button.");
                R.log("noCourse: " + noCourse);
                wk.setClipLike(noCourse, noClip, !buttonLike.selected);
                wk.request();
            }
            anchors
            {
                right: parent.right
                rightMargin: R.dp(20)
                bottom: parent.bottom
            }
        }

        Timer
        {
            running: opt.ds ? false : wk.setClipLikeResult !== ENums.WAIT
            repeat: false
            interval: 100
            onTriggered:
            {

                var type = wk.vSetClipLikeResult();
                if(type === ENums.POSITIVE)
                    buttonLike.selected = !buttonLike.selected;
                else error();
            }
        }

        LYMargin { width: parent.width; height: R.height_line_1px; color: "black" }
    }

    CPSNSSelector
    {
        id: shareWindow
        width: parent.width
        height: parent.height
        onEvtCmdKakao: {
            showContent(true, true);
            cmd.shareKakao();
        }
        onEvtCmdFacebook: {
            showContent(true, true);
            cmd.shareFacebook();
        }
        onEvtFunc: showContent(true, true);
    }

    WebView
    {
        id: webView
        y: settings.heightStatusBar + R.height_titleBar + R.dp(10)
        url: opt.ds ? "" : (!isVideo() ? linkUrl : "")
        visible: false
        //enabled: true
        width: 0 //opt.ds ? 0 : (!isVideo()?mainView.width:0)
        onLoadingChanged:
        {
            if(loadRequest.status !== WebView.LoadStartedStatus)
            {
                alarmShutter.running = true;
            }
        }
    }

    Timer
    {
        id: webViewRefresher
        running: opt.ds ? false : clipViewer.refreshWebView
        repeat: false
        interval: 0
        onTriggered:
        {
            R.log("wevViewRefresheLoader, refresh for hide webview!!");
            clipViewer.setRefreshWebView(false);
            showContent(false, false);
            clipViewer.setLoadRefreshedWebView(true);
        }
    }

    Timer
    {
        id: alarmShutter
        running: false
        repeat: true
        interval: 200
        onTriggered:
        {
            if(webView.loadProgress === 100)
            {
                alarmShutter.running = false;
                hideAlarm();
            }
        }
    }

    Timer
    {
        id: webViewRefreshLoader
        running: opt.ds ? false : (clipViewer.loadRefreshedWebView && webView.loadProgress === 100)
        repeat: false
        interval: 0
        onTriggered:
        {
            clipViewer.setLoadRefreshedWebView(false);
            showContent(true, false);
            R.log("wevViewRefresheLoader, showWebView!!");
        }
    }

    OpacityAnimator
    {
        id: onOpacityWindow
        target: opacityWindow;
        to: 0.5;
        duration: 500
        running: false
    }

    OpacityAnimator
    {
        id: offOpacityWindow
        target: opacityWindow;
        to: 0;
        duration: 500
        running: false
    }

    PropertyAnimation
    {
        id: onQuizWindow;
        target: quizWindow;
        property: "y";
        to: R.dp(996) + mainView.heightBottomArea
        duration: 300
    }

    PropertyAnimation
    {
        id: offQuizWindow;
        target: quizWindow;
        property: "y";
        to: mainView.height
        duration: 300
    }

    PropertyAnimation
    {
        id: onAnswerWindow;
        target: answerWindow
        property: "y";
        to: mainView.height  - (answerWindow.height + R.dp(144) + mainView.heightBottomArea)
        duration: 300
    }

    PropertyAnimation
    {
        id: offAnswerWindow
        target: answerWindow
        property: "y"
        to: mainView.height
        duration: 300
    }

    Timer
    {
        id: onContentSync
        running: false
        repeat: false
        interval: 500
        onTriggered:
        {
            if(opt.ds) return;
            showContent(true, false);
        }
    }

    function showContent(show, sync)
    {
        if(sync && show)
        {
            onContentSync.running = true;
            return;
        }

        if(show) onContent();
        else
        {
            if(isVideo())
            {
                //                videoPlayer.pause();
                //                commentInputController.textClear();
            }
            else
            {
                R.log("Hide the webView.");
                md.setUnvisibleWebView(true);
                webView.width = 0;
                webView.height = 0;
                webView.visible = false;
                //                commentInputController.textClear();
            }
        }
    }

    function onContent()
    {
        if(isVideo())
        {
            if(md.clipDetail.isVerticalVideo === 0)
            {
                videoPlayer.visible = true;
                videoPlayer.enabled = true;
                videoPlayer.width = mainView.width;

                videoPlayer_portrait.visible = false;
                videoPlayer_portrait.enabled = false;
                videoPlayer_portrait.width = 0;
            }
            else
            {
                videoPlayer.visible = false;
                videoPlayer.enabled = false;
                videoPlayer.width = 0;

                videoPlayer_portrait.visible = true;
                videoPlayer_portrait.enabled = true;
                videoPlayer_portrait.width = mainView.width;
            }


            //videoPlayer.pause();
        }

        else
        {
            webView.width = mainView.width;
            webView.height = mainView.height - mainView.heightStatusBar - mainView.heightBottomArea - R.height_titleBar - windowController.height - R.dp(10)
            webView.visible = true;
        }
    }

    function showController(type, show)
    {
        switch(type)
        {
            //        case ENums.CONTROLLER_COMMENT_INPUT:
            //            commentInputController.visible = show;
            //            commentInputController.enabled = show;
            //            commentInputController.textClear();
            //            break;
        case ENums.CONTROLLER_WINDOW:
            windowController.visible = show;
            break;
        }
    }

    function showWindow(type, show)
    {
        if(type !== ENums.WINDOW_OPACITY && show) openedWindow = type;

        switch(type)
        {
        case ENums.WINDOW_SHARE:
            shareWindow.showInst(show);
            break;

        case ENums.WINDOW_ANSWER:
            answerWindow.enabled = show;
            if(show) onAnswerWindow.running = true;
            else offAnswerWindow.running = true;
            break;

            //        case ENums.WINDOW_COMMENT:
            //            showedCommentWindow = show;
            //            if(show) onCommentWindow.running = true;
            //            else
            //            {
            //                offCommentWindow.running = true;
            //                tmClearReple.running = true;
            //            }
            //            break;

        case ENums.WINDOW_QUIZ:
            showedQuizWindow = show;
            quizWindow.enabled = show;
            if(show) onQuizWindow.running = true;
            else offQuizWindow.running = true;
            break;

        case ENums.WINDOW_OPACITY:
            opacityWindow.enabled = show;
            if(show) onOpacityWindow.running = true;
            else offOpacityWindow.running = true;
            break;
        }
    }

    Timer
    {
        id: tmClearReple
        running: false
        repeat: false
        interval: 300
        onTriggered:
        {
            md.clearRepleList();
        }
    }

    function hideRegionAll(sync)
    {
        showWindow(ENums.WINDOW_COMMENT, false)
        showWindow(ENums.WINDOW_QUIZ, false);
        showWindow(ENums.WINDOW_ANSWER, false);
        showWindow(ENums.WINDOW_SHARE, false);
        showWindow(ENums.WINDOW_OPACITY, false);
        showController(ENums.CONTROLLER_COMMENT_INPUT, false)
        showController(ENums.CONTROLLER_WINDOW, true);

        openedWindow = ENums.CLOSED_ALL_WINDOW;

        showContent(true, sync);
    }

    function hideAlarmWindow()
    {
        ap.setVisible(false);
        hideRegionAll(false);
    }

    function isVideo()
    {
        var u = linkUrl.substring(linkUrl.length-4, linkUrl.length);
        if(u === ".mp4") return true;
        return false;
    }

    function isLogined(isShowWebView)
    {
        if(opt.ds) return;
        if(!logined())
        {
            showContent(false, false);
            alarmNeedLoginFromClipViewer();

            if(isShowWebView)
                ap.setNMethod(mainView, "onContent");

            return false;
        }
        return true;
    }

    onEvtBeforeGoToLogin:
    {
        showWindow(ENums.WINDOW_OPACITY, false);
        showWindow(ENums.WINDOW_COMMENT, false);
        showWindow(ENums.WINDOW_QUIZ, false);
        showWindow(ENums.WINDOW_ANSWER, false);

        showController(ENums.CONTROLLER_COMMENT_INPUT, false);
        showController(ENums.CONTROLLER_WINDOW, true);

        md.setUnvisibleWebView(true);
    }

    Timer
    {
        running: opt.ds ? false : !md.unvisibleWebView
        repeat: false
        interval: 200
        onTriggered:
        {
            if(linkUrl === "") return;
            else
            {
                showContent(true, false);
            }
        }
    }

    Timer
    {
        running: opt.ds ? false : (md.CRUDHandlerType === 4)
        repeat: false
        interval: 300
        onTriggered:
        {
            md.setCRUDHandlerType(0);
            mainView.forceActiveFocus();
        }
    }

    Timer
    {
        running: opt.ds ? false : (md.CRUDHandlerType === 5)
        repeat: false
        interval: 300
        onTriggered:
        {
            md.setCRUDHandlerType(0);
            alarmNeedLoginFromClipViewer();
        }
    }

    function setUnitComplete()
    {
        wk.setUnitComplete(noClip, noCourse);
        wk.request();
    }

    Timer
    {
        running: opt.ds ? false :(wk.setUnitCompleteResult === ENums.POSITIVE)
        repeat: false
        interval: 300
        onTriggered:
        {
            wk.vSetUnitCompleteResult();
            alarm(R.message_notice_finished_clip);
            ap.setYMethod(mainView, "showContentAfterCompletion");
//            md.setNativeChanner(11);
        }
    }

    function showContentAfterCompletion()
    {
        showContent(true, true);
    }
}
