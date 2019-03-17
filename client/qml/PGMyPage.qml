import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "Resources.js" as R
import enums 1.0

PGPage {
    id: mainView
    visibleBackBtn: true
    visibleSearchBtn: false
    titleText: "마이페이지"
    titleTextColor: "black"
    titleLineColor: "black"
    visible: false

    useDefaultEvtBack: false
    onEvtBack:
    {
        if(opt.ds) return;
        if(compareCurrentPage("ClipViewer")) md.setUnvisibleWebView(false);
        md.showMyPage(false);
        tmBack.running = true;
    }

    Component.onCompleted:
    {
        enrollPageAtHomeStack(pageName);
    }

    //    PropertyAnimation
    //    {
    //        id: movePage;
    //        target: mainView;
    //        running: false
    //        property: "x";
    //        to: parent.width;
    //        duration: 200
    //    }

    Timer
    {
        running: opt.ds ? false : md.showedMyPage
        repeat: false
        interval: 0
        onTriggered:
        {
            tmInit.running = true;
            mainView.visible = true;
            showMoveView();
        }
    }

    Timer
    {
        id: tmHideView
        running: false
        repeat: false
        interval: 500
        onTriggered: mainView.visible = false
    }

    Timer
    {
        running: opt.ds ? false : !md.showedMyPage
        repeat: false
        interval: 0
        onTriggered:
        {
            hideMoveView();
            tmHideView.running = true;
        }
    }

    Timer
    {
        id: tmInit
        running: false
        interval: 200
        onTriggered: initialize();
    }

    Timer
    {
        id: tmBack
        running: false
        repeat: false
        interval: 200
        onTriggered:
        {
            md.clearRecentLogList();
            md.clearMyCourseList();
        }
    }

    function initialize()
    {
        if(opt.ds) return;

        clearCategoryButtons();
        md.catemyactylist[0].select(true);
    }

    property int widthCategoryArea: contentcRect.width * 0.5
    property int heightCategoryArea: R.dp(137)

    property int dlength : opt.ds ? 10 : md.myCourseList.length
    property int actyLength : opt.ds ? 10 : md.recentLogList.length
    property int itemHeight : R.dp(270)
    property int itemActyHeight : R.dp(200)

    Rectangle
    {
        id: contentcRect
        width: parent.width
        height: parent.height - mainView.heightStatusBar - mainView.heightBottomArea - R.height_titleBar
        //        color: R.color_grayED
        y: mainView.heightStatusBar + R.height_titleBar

        Column
        {
            width: parent.width
            height: contentcRect.height

            Rectangle
            {
                id: metaRect
                width: parent.width
                height: R.dp(176) + R.dp(200)
                color: "white"

                Column
                {
                    width: parent.width
                    height: parent.height

                    Rectangle
                    {
                        width: parent.width
                        height: R.dp(120)

                        CPTextButton
                        {
                            name: "프로필 수정"
                            width: R.dp(300)
                            height: parent.height
                            color: "transparent"
                            subColor: R.color_gray001
                            txtColor: R.color_bgColor001
                            pointSize: R.pt(50)
                            underline: true
                            onClick:
                            {
                                if(opt.ds) return;
                                goProfileModify.running = true;
                            }

                            anchors
                            {
                                top: parent.top
                                right: parent.right
                            }
                        }

                        Timer
                        {
                            id: goProfileModify
                            running: false
                            repeat: false
                            interval: 100
                            onTriggered:
                            {
                                if(opt.ds) return;
                                wk.getUserProfile();
                                wk.request();

                                myProfile.showMoveView();
                            }
                        }
                    }

                    Row
                    {
                        width: parent.width
                        height: R.dp(176)

                        LYMargin{ width: R.dp(70) }
                        CPProfileImage
                        {
                            id: profileImg
                            width: R.dp(178)
                            height: R.dp(178)
                            sourceImage: R.startsWithAndReplace(settings.profileImage, "https", "http")
                            onEvtClicked:
                            {
                                showBigImage.source = R.startsWithAndReplace(settings.profileImage, "https", "http");
                                showBigImage.show();
                            }
                        }
                        LYMargin{ width: R.dp(30) }
                        Rectangle
                        {
                            width: parent.width - R.dp(346)
                            height: R.dp(176)

                            Item
                            {
                                id: basePoint
                                width: 1; height: 1
                                anchors
                                {
                                    verticalCenter: parent.verticalCenter
                                }
                            }

                            CPText
                            {
                                text: opt.ds ? "관리자" : settings.nickName
                                font.pointSize: R.pt(48)
                                anchors
                                {
                                    bottom: basePoint.top
                                }
                            }
                            CPText
                            {
                                text: opt.ds ? "example@example.com" : settings.email
                                font.pointSize: R.pt(48)
                                anchors
                                {
                                    top: basePoint.bottom
                                }
                            }
                        }
                    }
                    LYMargin { height: R.dp(150) }
                }
            }

            Rectangle
            {
                id: marginRect1
                width:parent.width
                height:R.height_line_1px * 2
                color:"transparent"
            }

            Rectangle
            {
                id: categoryRect
                width: parent.width
                height: heightCategoryArea
                color: "white"
                Row
                {
                    width: parent.width
                    height: parent.height
                    Repeater
                    {
                        model: opt.ds ? 2 : md.catemyactylist.length

                        Rectangle
                        {
                            width: widthCategoryArea; height: heightCategoryArea
                            color:"transparent"

                            Column
                            {
                                width: widthCategoryArea; height: parent.height;
                                LYMargin { height: R.dp(20)}
                                CPText
                                {
                                    font.pointSize: R.pt(45)
                                    //                                    font.bold: true
                                    width: widthCategoryArea
                                    height: heightCategoryArea - R.dp(20) - R.dp(6)
                                    text:
                                    {
                                        if(opt.ds) return "Untitled";

                                        if(index == 0) return "나의 수강 강좌";
                                        else return "나의 최근 활동";
                                    }
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    color: "black"
                                }
                                Rectangle
                                {
                                    width: widthCategoryArea; height: R.dp(6);
                                    color: opt.ds ? R.color_bgColor001 : (md.catemyactylist[index].selected ? R.color_theme01 : "#f5f6f6");
                                }
                            }
                            MouseArea
                            {
                                anchors.fill: parent
                                onClicked:
                                {
                                    if(opt.ds) return;
                                    if(md.catemyactylist[index].selected) return;

                                    clearCategoryButtons();
                                    md.catemyactylist[index].select(true);

                                    md.clearRecentLogList();
                                    md.clearMyCourseList();

                                    if(index == 0)
                                    {
                                        myListenCourse.visible = true;
                                        myRecentlyActy.visible = false;

                                        wk.getMyPageCourse();
                                        wk.request();
                                    }
                                    else
                                    {
                                        myListenCourse.visible = false;
                                        myRecentlyActy.visible = true;

                                        wk.getMyPageLog();
                                        wk.request();
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Rectangle
            {
                id: marginRect2
                width:parent.width
                height:R.dp(10)
                color:"transparent"
            }

            OpacityAnimator
            {
                target: myListenCourse;
                from: 0;
                to: 1;
                duration: 500
                running: myListenCourse.visible
            }

            OpacityAnimator
            {
                target: myRecentlyActy;
                from: 0;
                to: 1;
                duration: 500
                running: myRecentlyActy.visible
            }

            OpacityAnimator
            {
                target: myListenCourse;
                from: 0;
                to: 1;
                duration: 500
                running: myListenCourse.visible
            }
            OpacityAnimator
            {
                target: myRecentlyActy;
                from: 1;
                to: 0;
                running: !myRecentlyActy.visible
            }

            CPNoData
            {
                width: parent.width
                height: parent.height - metaRect.height - marginRect1.height - marginRect2.height - categoryRect.height + R.height_titleBar - R.dp(200)
                visible: (myListenCourse.visible && dlength == 0) || (myRecentlyActy.visible && actyLength == 0)
                showText: true
                message:
                {
                    if(wk.refreshWorkResult !== ENums.FINISHED_MYPAGE)
                        return "데이터를 불러오는 중입니다.";

                    if(myListenCourse.visible && dlength == 0)
                        return "수강 이력이 없습니다.";
                    else if(myRecentlyActy.visible && actyLength == 0)
                        return "최근 활동 이력이 없습니다.";
                    return "";
                }

            }

            Flickable
            {
                id: myListenCourse
                width: parent.width
                height: dlength == 0 ? 0 : contentcRect.height - metaRect.height - marginRect1.height - marginRect2.height - categoryRect.height + R.height_titleBar
                contentWidth : parent.width
                contentHeight: mainColumn.height + R.dp(300)
                maximumFlickVelocity: R.flickVelocity(itemHeight * dlength)
                clip: true
                visible: true
                opacity: 0
                boundsBehavior: Flickable.StopAtBounds

                Column
                {
                    id: mainColumn
                    width: parent.width
                    spacing: R.height_line_1px

                    Repeater
                    {
                        model: dlength

                        Rectangle
                        {
                            width: parent.width
                            height: itemHeight
                            color: "white"

                            Item
                            {
                                id: itemBasePoint
                                width: 1; height: 1;
                                anchors
                                {
                                    verticalCenter: parent.verticalCenter
                                    horizontalCenter: parent.horizontalCenter
                                }
                            }

                            CPText
                            {
                                id: itemTitle
                                width: parent.width - finishCourseRect.width - R.dp(140)
                                maximumLineCount: 1
                                text: opt.ds? ("SAMPLE" + index) : md.myCourseList[index].serviceTitle
                                font.pointSize: R.pt(45)
                                anchors
                                {
                                    bottom: itemBasePoint.top
//                                    bottomMargin: R.dp(10)
                                    left: parent.left
                                    leftMargin: R.dp(70)
                                }
                            }

                            Rectangle
                            {
                                width: parent.width - R.dp(140)
                                height: R.dp(37)
                                color: R.color_grayED
                                anchors
                                {
                                    top: itemTitle.bottom
                                    topMargin: R.dp(52)
                                    left: parent.left
                                    leftMargin: R.dp(70)
                                }
                            }

                            Rectangle
                            {
                                width: (parent.width - R.dp(140)) * (opt.ds ? 0.5 : md.myCourseList[index].studentProgress * 0.01)
                                height: R.dp(37)
                                color: R.color_bgColor001
                                anchors
                                {
                                    top: itemTitle.bottom
                                    topMargin: R.dp(52)
                                    left: parent.left
                                    leftMargin: R.dp(70)
                                }
                            }

                            CPImage
                            {
                                id: arrowImg
                                source: R.image("button_go")
                                width: opt.ds ? R.dp(50) : (md.myCourseList[index].studentProgress === 100 ? 0 : R.dp(50))
                                height: R.dp(50)
                                anchors
                                {
                                    bottom: itemTitle.bottom
                                    //                                    topMargin: R.dp(5)
                                    right: parent.right
                                    rightMargin: R.dp(80)
                                }
                            }

                            CPText
                            {
                                id: itemProgress
                                text: opt.ds? "50%" : (md.myCourseList[index].studentProgress.toString() + "%")
                                font.pointSize: R.pt(35)
                                visible: opt.ds ? true : (md.myCourseList[index].studentProgress < 100)
                                anchors
                                {
                                    bottom: arrowImg.bottom
//                                    bottomMargin: R.dp(30)
                                    right: arrowImg.left
                                    rightMargin: R.dp(28)
                                }
                            }

                            Rectangle
                            {
                                id: finishCourseRect
                                color: R.color_bgColor001
                                width: R.dp(220)
                                height: R.dp(80)
                                radius: 50
                                visible : opt.ds ? false : (md.myCourseList[index].studentProgress === 100 ? true : false)

                                CPText
                                {
                                    text: "수강완료"
                                    color: "white"
                                    font.pointSize: R.pt(40)
                                    anchors
                                    {
                                        verticalCenter: parent.verticalCenter
                                        horizontalCenter: parent.horizontalCenter
                                    }
                                }

                                anchors
                                {
                                    bottom: itemTitle.bottom
                                    right: parent.right
                                    rightMargin: R.dp(80)
                                }
                            }

                            LYMargin
                            {
                                width: /*(index === dlength-1) ? 0 : */parent.width - R.dp(100)
                                height: R.height_line_1px
                                color: R.color_bgColor001
                                anchors
                                {
                                    bottom: parent.bottom
                                    left: parent.left
                                    leftMargin: R.dp(50)
                                }
                            }

                            Rectangle
                            {
                                width: parent.width
                                height: parent.height
                                color: "transparent"

                                ColorAnimation on color {
                                    id: cccc
                                    running: false
                                    from: "#44000000"
                                    to: "transparent"
                                    duration: 200
                                }

                                MouseArea
                                {
                                    anchors.fill: parent
                                    onClicked:
                                    {
                                        cccc.running = true;
                                        if(opt.ds) return;
                                        goToViewer.running = true;
                                    }
                                }

                                Timer
                                {
                                    id: goToViewer
                                    running: false
                                    repeat: false
                                    interval: 300
                                    onTriggered:
                                    {
                                        showMyPage(false);
                                        while(homeStackView.depth > 1)
                                        {
                                            popHomeStack();
                                        }
                                        md.setNativeChanner(0);
                                        pushHomeStack("CourseDesk", { "from": "mypage", "courseNo": md.myCourseList[index].courseNo });
                                    }
                                }
                            }
                        }
                    }
                }
            }

            ListModel
            {
                id: commentList
                ListElement
                {
                    type: 2100
                    contents: "클립 수강 완료"
                    date: "2010-02-02 11:12:13"
                }

                ListElement
                {
                    type: 2200
                    contents: "과목 수강 완료"
                    date: "2010-02-02 11:12:13"
                }

                ListElement
                {
                    type: 3000
                    contents: "게시글(유닛댓글) 좋아요"
                    date: "2010-02-02 11:12:13"
                }

                ListElement
                {
                    type: 3100
                    contents: "우수댓글 선정"
                    date: "2010-02-02 11:12:13"
                }

                ListElement
                {
                    type: 3200
                    contents: "일반 게시글 작성"
                    date: "2010-02-02 11:12:13"
                }

                ListElement
                {
                    type: 3300
                    contents: "게시글 작성"
                    date: "2010-02-02 11:12:13"
                }

                ListElement
                {
                    type: 3400
                    contents: "댓글 작성"
                    date: "2010-02-02 11:12:13"
                }

                ListElement
                {
                    type: 3500
                    contents: "이벤트 신청"
                    date: "2010-02-02 11:12:13"
                }
            }

            Flickable
            {
                id: myRecentlyActy
                width: parent.width
                height: actyLength == 0 ? 0 : contentcRect.height - metaRect.height - marginRect1.height - marginRect2.height - categoryRect.height + R.height_titleBar
                contentWidth : parent.width
                contentHeight: logRect.height + R.dp(300)
                maximumFlickVelocity: R.flickVelocity(logRect.height)
                clip: true
                visible: false
                opacity: 0
                boundsBehavior: Flickable.StopAtBounds

                onMovementEnded:
                {
                    if(opt.ds) return;
                    if(myRecentlyActy.atYEnd)
                    {
                        if(actyLength % 20 == 0 && actyLength > 0)
                        {
                            wk.getMyPageLog(actyLength / 20 + 1);
                            wk.request();
                        }
                    }
                }

                Column
                {
                    id: logRect
                    width: parent.width
                    //                    height: itemActyHeight * actyLength
                    spacing: R.height_line_1px

                    Repeater
                    {
                        model: opt.ds ? commentList : actyLength

                        Column
                        {
                            width: parent.width
                            height: logItem.height
                            Rectangle
                            {
                                id: logItem
                                width: parent.width
                                height: actyContent.height  + R.dp(60)
                                color: "white"

                                CPImage
                                {
                                    id: actyTypes
                                    width: R.dp(60)
                                    height: R.dp(60)
                                    source:
                                    {
                                        var code = opt.ds ? type : md.recentLogList[index].logCode;
                                        switch(code)
                                        {
                                        case 2100: /* 클립 수강 완료 */
                                        case 2200: /* 과목 수강 완료 */
                                            return R.image("finished");
                                        case 3000: /* 게시글(유닛댓글) 좋아요 */
                                            return R.image("mypage_log_like");
                                        case 3100: /* 우수댓글 선정 */
                                            return R.image("mypage_log_best");
                                        case 3200: /* 일반 게시글 작성 */
                                        case 3300: /* 게시글 작성 */
                                            return R.image("write_article");
                                        case 3400: /* 댓글 작성 */
                                            return R.image("comment_small");
                                        case 3500: /* 이벤트 신청 */
                                            return R.image("write_article");
                                        default:
                                            return R.image("mypage_log_etc");
                                        }
                                    }
                                    anchors
                                    {
                                        left: parent.left
                                        leftMargin: R.dp(60)
                                        verticalCenter: parent.verticalCenter
                                    }
                                }

                                CPText
                                {
                                    id: actyContent
                                    width: parent.width - R.dp(200)
                                    text: opt.ds? ("[" + date + "] " + contents) : ("[" + md.recentLogList[index].logDate + "]  " +md.recentLogList[index].logText)
                                    lineHeight: 1.2
                                    font.pointSize: R.pt(40)
                                    anchors
                                    {
                                        left: actyTypes.right
                                        leftMargin: R.dp(40)
                                        verticalCenter: parent.verticalCenter
                                    }
                                }
                            }

                            LYMargin
                            {
                                width: parent.width - R.dp(100)
                                height: R.height_line_1px
                                color: R.color_bgColor001
                                anchors
                                {
                                    left: parent.left
                                    leftMargin: R.dp(50)
                                }
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

        condRun: ENums.WORKING_MYPAGE
        condStop: ENums.FINISHED_MYPAGE

        anchors.bottom: parent.bottom

        visible:
        {
            if(myListenCourse.visible && dlength === 0) return false;
            else if(myRecentlyActy.visible && actyLength === 0) return false;
            return true;
        }
    }

//    onEvtBehaviorAndroidBackButton:
//    {
//        if(showBigImage.opacity === 1.0)
//        {
//            showBigImage.hide();
//            return;
//        }
//        else if(myProfile.x === 0)
//        {
//            R.log("myProfile.hideMoveView()");
//            myProfile.hideMoveView();
//            return;
//        }
//        else
//        {
//            evtBack();
//            return;
//        }
//    }

    function clearCategoryButtons()
    {
        for(var i=0; i<md.catemyactylist.length; i++)
        {
            md.catemyactylist[i].select(false);
        }
    }
}
