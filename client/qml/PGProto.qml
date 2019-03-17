import QtQuick 2.11
import QtQuick.Controls 2.2
import "Resources.js" as R
import enums 1.0
Rectangle
{
    id: proto
    property int currentIndex: opt.ds ? 0 : pm.length();
    property bool useToMoveByPush: true
    property string pageName: ""
    color: "transparent"

    function enrollPageAtHomeStack(namePage)
    {
        pm.push(namePage, R.name_stack_home);
    }

    function pushHomeStack(namePage, params, transition)
    {
        if(opt.ds) return;
        if(pm.compareCurrentPage(namePage)) return;

        enrollPageAtHomeStack(namePage);
        homeStackView.push(Qt.createComponent("PG"+namePage+".qml"), params, transition);

        var currentPageName = pm.top() ? pm.item.namePage : "";

        R.log("After pushed, top page: " + currentPageName);
        printPageInfo();
    }

    function pushNoticeDetailView(boardNo, boardArticleNo)
    {
        if(opt.ds) return;
        md.setCurrentBoardNo(boardNo);
        md.setCurrentBoardArticleNo(boardArticleNo);
        pushHomeStack("NoticeDetail");
    }

    function pushNoticeDetailViewWithIndex(boardNo, boardArticleNo, index)
    {
        if(opt.ds) return;
        md.setCurrentBoardNo(boardNo);
        md.setCurrentBoardArticleNo(boardArticleNo);
        pushHomeStack("NoticeDetail", {"listIndex": index});
    }

    function pushCourseNoticeDetailView(boardNo, boardArticleNo)
    {
        if(opt.ds) return;
        md.setCurrentBoardNo(boardNo);
        md.setCurrentBoardArticleNo(boardArticleNo);
        pushHomeStack("CourseNoticeDetail");
    }

    function pushCourseNoticeDetailViewWithIndex(boardNo, boardArticleNo, index)
    {
        if(opt.ds) return;
        md.setCurrentBoardNo(boardNo);
        md.setCurrentBoardArticleNo(boardArticleNo);
        pushHomeStack("CourseNoticeDetail", {"listIndex": index});
    }

//    property int stackTransition: StackView.PushTransition

    property int listIndex: 0
    property string viewerFrom: R.viewer_from_desk
    function pushClipViewer(clipNo, courseNo, index, from)
    {
        if(opt.ds) return;
        md.setCurrentClipNo(clipNo);
        md.setCurrentCourseNo(courseNo);
        md.setNativeChanner(11);

//        stackTransition = transition;
        tmPushClipViewer.running = true;
        //pushHomeStack("ClipViewer", {}, transition);

        listIndex = index;
        viewerFrom = from;
    }

    Timer
    {
        id: tmPushClipViewer
        running: false
        repeat: false
        interval: 200
        onTriggered:
        {
            pushHomeStack("ClipViewer", {"listIndex":listIndex, "from": viewerFrom}, StackView.PushTransition);
        }
    }

    function pushUserStack(namePage, params, transition)
    {
        if(opt.ds) return;
        if(pm.compareCurrentPage(namePage)) return;

        pm.push(namePage, R.name_stack_user);
        userStackView.push(Qt.createComponent("PG"+namePage+".qml"), params, transition);

        var currentPageName = pm.top() ? pm.item.namePage : "";
        R.log("After pushed, top page: " + currentPageName);
        printPageInfo();
    }

    function compareCurrentPage(namePage) { return pm.compareCurrentPage(namePage); }

    function setErrorMessage(message)
    {
        md.setError(message);
    }

    function hasNoArticle()
    {
        ap.setVisible(true);
        ap.setMessage(md.error);
        ap.setYButtonName("확인");
        ap.setButtonCount(1);
        ap.setYMethod(mainView, "popHomeStack");
    }

    function popHomeStack()
    {
        if(opt.ds) return;
        pm.pop();
        homeStackView.pop();

        var currentPageName = pm.top() ? pm.item.namePage : "";
        R.log("After popped, top page: " + currentPageName);
        printPageInfo();
    }

    function popUserStack()
    {
        if(opt.ds) return;
        pm.pop();
        userStackView.pop();

        var currentPageName = pm.top() ? pm.item.namePage : "";
        R.log("After popped, top page: " + currentPageName);
        printPageInfo();
    }

    function clearUserStack()
    {
        if(opt.ds) return;
        pm.clear(R.name_stack_user);
        userStackView.clear();
    }

    function alarm(message)
    {
        ap.setVisible(true);
        ap.setMessage(message);
        ap.setYButtonName("확인");
        ap.setButtonCount(1);
        ap.setYMethod(mainView, "empty");
    }

    function hideAlarm()
    {
        if(ap.visible)
        {
            ap.setVisible(false);
            ap.setYMethod(mainView, "empty");
            return true;
        }
        return false;
    }

    function showedAlarm() { return ap.visible }

    function alarm2(message)
    {
        ap.setVisible(true);
        ap.setMessage(message);
        ap.setYButtonName("예");
        ap.setNButtonName("아니오");
        ap.setButtonCount(2);
        ap.setNMethod(mainView, "empty");
    }

    function error()
    {
        ap.setVisible(true);
        ap.setMessage(md.error);
        ap.setYButtonName("확인");
        ap.setButtonCount(1);
        ap.setYMethod(mainView, "empty");
    }
    function empty(){}

    signal evtBeforeGoToLogin();
    function goToLogin()
    {
        evtBeforeGoToLogin();
        R.hideKeyboard();
        pushUserStack("LoginDesk", { }, StackView.PushTransition);
    }

    function alarmNeedLogin()
    {
        alarm2(R.message_need_login);
        ap.setYMethod(proto, "goToLogin");
    }

    function alarmNeedLoginFromClipViewer()
    {
        alarm2(R.message_need_login);
        ap.setYMethod(proto, "goToLoginAndSetChannel");
    }

    function goToLoginAndSetChannel()
    {
        md.setNativeChanner(0);
        goToLogin();
    }

    function goToLoginShowImmediate()
    {
        evtBeforeGoToLogin();
        R.hideKeyboard();
        pushUserStack("LoginDesk", { }, StackView.Immediate);
    }

    function alarmNeedLoginShowImmediate()
    {
        alarm2(R.message_need_login);
        ap.setYMethod(proto, "goToLoginShowImmediate");
    }

    function logined()
    {
        if(settings.logined) return true;
        return false;
    }

    function matchPrevPage(namePage)
    {
        return pm.comparePrevPage(namePage);
    }

    function printPageInfo() { pm.printPageInfo(); }

    function showMoreIndicator(type)
    {
        wk.setRefreshWorkResult(type);
    }

    function showIndicatorIni(type)
    {
        wk.setRefreshWorkResult(type);
    }

    function setMainTabName(name) { pm.setMainTabName(name) }
    function getMainTabName() { return pm.getMainTabName(); }

    function setLikeTabName(name) { pm.setLikeTabName(name) }
    function getLikeTabName() { return pm.getLikeTabName(); }

    function showIndicator(show) { md.setShowIndicator(show); }
    function showMyPage(show)
    {
        if(logined())
        {
            if(show) tmGetMyCourse.running = true;

            md.showMyPage(show);
        }
        else
        {
            showIndicator(true);
            tmGoToLoginDesk.running = true;
        }
    }
    Timer
    {
        id: tmGetMyCourse
        running: false
        repeat: false
        interval: 500
        onTriggered:
        {
            wk.getMyPageCourse();
            wk.request();
        }
    }

    function showedMyPage() {   return md.showedMyPage }
    function hideMyPage() { md.showMyPage(false); }
    Timer
    {
        id: tmGoToLoginDesk
        running: false
        repeat: false
        interval: 200
        onTriggered: pushUserStack("LoginDesk", { }, StackView.PushTransition);
    }

    signal handleLoginResult();
    Timer
    {
        running: opt.ds ? false : wk.loginResult !== ENums.WAIT
        repeat: false
        interval: 300
        onTriggered:
        {
            md.setShowIndicator(false);

            var topPageName = pm.top() ? pm.item.namePage : "";

            var type = wk.vLoginResult();
            if(topPageName === "Main")
            {
                if(type === ENums.POSITIVE) /* When Succeded to login. */
                {
                    var mainTabName = getMainTabName();
                    if(mainTabName === "Like")
                    {
                        var likeTabName = getLikeTabName();
                        if(likeTabName === "Clip") wk.getClipLikeList(1);
                        else if(likeTabName === "Reple") wk.getRepleLikeList(1);
                    }
                    else if(mainTabName === "Point") wk.getRankingMain();
                    else if(mainTabName === "Home")
                    {

                        wk.getMain(1, "");
                    }
                    wk.request();
                }
                /* When Failed to login by Email, it's processed at the networker. */
                else if(type === ENums.NAGATIVE) /* When Failed to login by SNS. */
                {
                    error();
                    settings.clearUser();
//                    wk.getMain(1, "");
//                    wk.request();
                }

                md.setShowIndicator(false);
            }

            else if(topPageName === "LoginDesk")
            {
                switch(settings.snsType)
                {
                case ENums.SELF:
                    if(type === ENums.POSITIVE)
                    {
                        if(matchPrevPage("ClipViewer"))
                        {
                            R.log("If navigated from 'PGClipViewer.qml', the variable 'loginin' would be set to the false to show the webview.");
                            md.setNativeChanner(11);
                            md.setUnvisibleWebView(false);
                        }
                        md.setShowIndicator(false);
                        clearUserStack();
                    }
                    break;
                case ENums.KAKAO:
                case ENums.FACEBOOK:
                    if(type === ENums.POSITIVE)
                    {
                        if(matchPrevPage("ClipViewer"))
                        {
                            R.log("If navigated from 'PGClipViewer.qml', the variable 'loginin' would be set to the false to show the webview.");
                            md.setNativeChanner(11);
                            md.setUnvisibleWebView(false);
                        }
                        md.setShowIndicator(false);
                        clearUserStack();
                    }
                    else
                    {
                        if(settings.id === "")
                        {
                            alarm("SNS로그인에 실패하였습니다.");
                            return;
                        }

                        md.setShowIndicator(true);
                        ap.setVisible(false);
                        ap.setMessage("SNS 회원가입을 진행합니다.");
                        pushUserStack("JoinClause");
                    }
                    break;
                }
            }

            else if(topPageName === "JoinFinished")
            {
                handleLoginResult();
            }

            //            handleLoginResult();
        }
    }

    Timer
    {
        id: operatorMovePageByPush
        running: opt.ds ? false : (useToMoveByPush && (md.delivered > 0))
        repeat: false
        interval: opt.ds ? 200 : (np.isRunning()  ? 100 : 1000)
        onTriggered:
        {
            clearUserStack();
            var pushType = md.delivered;
            switch(pushType)
            {
            case 1:
            case 2:
                if(pm.compareCurrentPage("ClipViewer"))
                {
                    //                    R.log("if(pm.compareCurrentPage(ClipViewer))");
                    clipViewer.setRefreshWebView(true);
                    clipViewer.setRunningDataGetter(true);
                    break;
                }
                md.setNativeChanner(11);
                pushHomeStack("ClipViewer", { "notified": true, "from": "push" });
                break;
            case 3: break;
            }
            md.deliver(0);
            md.setShowIndicator(false);
        }
    }

    Timer
    {
        running: opt.ds ? false : (wk.sessionState === ENums.NEED_BUT_UNCONNECTED)
        repeat: false
        interval: 300
        onTriggered:
        {
            wk.setSessionState(ENums.SESSION_WAIT);
            if(md.initializedSystem === true)
                alarmNeedLogin();
        }
    }

    Timer
    {
        running: opt.ds ? false : (wk.sessionState === ENums.NEED_AND_CONNECTED)
        repeat: false
        interval: 300
        onTriggered:
        {
            wk.setSessionState(ENums.SESSION_WAIT);
            wk.clearDelayedHosts();
            wk.request();
        }
    }
}
