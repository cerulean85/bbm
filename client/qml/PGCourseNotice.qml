import QtQuick 2.9
import QtQuick.Controls 2.2
import "Resources.js" as R
import enums 1.0

PGPage {
    id: mainView
    visibleSearchBtn: false
    titleText: "과정 공지사항"
    titleTextColor: "black"
    titleLineColor: "black"
    visibleBackBtn: true
    forceAlignHCenter: false
    pageName: "CourseNotice"

    property int itemHeight: R.dp(180)
    property int dLength : opt.ds ? 40 : md.noticeList.length
    property int noBoard : 3 /* 3: 과목 공지사항, 4: Q&A */
    property bool enableWrite: false
    forecedRightPaddingToAlignHCenter: enableWrite ? /*R.dp(100)*/ qBtn.width : 0

    onEvtInitData:
    {
        md.clearNoticeList();
        md.clearRepleList();
    }

    Component.onCompleted:
    {
        if(opt.ds) return;
        dataGetter.running = true
        tmIndicate.running = true
    }

    Timer
    {
        id: tmIndicate
        running: false
        repeat: false
        interval: 500
        onTriggered: showIndicator(false);
    }

    Timer
    {
        running: opt.ds ? false : (md.requestNativeBackBehavior === ENums.REQUESTED_BEHAVIOR && compareCurrentPage(pageName))
        repeat: false
        interval: 100
        onTriggered:
        {
            md.setRequestNativeBackBehavior(ENums.WAIT_BEHAVIOR);

            if(courseQuestionNew.x === 0)
            {
               courseQuestionNew.evtBehaviorAndroidBackButton();
                return;
            }

            if(closeWindowInMain()) return;
            evtBack();

        }
    }

    Timer
    {
        id: dataGetter
        running: false
        repeat: false
        interval: 500
        onTriggered:
        {
            if(noBoard < 1)
            {
                R.log("Where: PGCourseNotice.qml >> noBoard < 0");
                alarm("해당 게시물이 존재하지 않습니다.");
                ap.setYMethod(mainView, "popHomeStack");
                return;
            }

            md.clearNoticeList();

            wk.getCourseBoardList(1, noBoard);
            wk.request();
        }
    }

    CPTextButtonTrans
    {
        id: qBtn
        color: "white"
        width: R.height_titleBar + R.dp(150)
        height: R.height_titleBar - R.height_line_1px
        anchors
        {
            top: parent.top
            topMargin: settings.heightStatusBar
            right: parent.right
        }
        visible: enableWrite
        subColor: "white"//"#eeeeee"
        btnName: "질문하기"
        pointSize: R.pt(50)
        onClick:
        {
            if(opt.ds) return;

            if(!logined())
            {
                alarmNeedLogin();
                return;
            }

            courseQuestionNew.showMoveView();
            //            pushHomeStack("CourseQuestionNew", { "noBoard": noBoard, "editType": 0 }, StackView.PushTransition);
        }
    }

    CPNoData
    {
        id: noDataRect
        width: parent.width
        height: parent.height - mainView.heightStatusBar - R.height_titleBar - mainView.heightBottomArea
        y: mainView.heightStatusBar + R.height_titleBar
        visible: opt.ds ? true : (dLength === 0)
        showText: true
        message: opt.ds ? R.message_has_no_article_list : (wk.refreshWorkResult === ENums.FINISHED_COURENOTICE ? R.message_has_no_article_list : R.message_load_article_list)
        tMargin: R.dp(100)
    }

    Column
    {

        width: parent.width
        height: parent.height - mainView.heightStatusBar - R.height_titleBar - mainView.heightBottomArea
        visible: dLength > 0
        y: mainView.heightStatusBar + R.height_titleBar
        Repeater
        {
            model: opt.ds ? 3 : md.noticeTopList.length

            Rectangle
            {
                width: parent.width
                height: itemHeight
                color: R.color_bgColor002

                Column
                {
                    width: parent.width
                    height: parent.height

                    Item
                    {
                        width: parent.width - R.dp(80)
                        height: itemHeight * 0.5
                        anchors
                        {
                            left: parent.left
                            leftMargin: R.dp(40)
                        }

                        CPText
                        {
                            id: topTxtContents
                            //                            width: parent.width
                            height: parent.height
                            text: opt.ds ? "2018년도 이러닝 콘텐츠 개발 내용 전문가11 2차 모집 공고" : md.noticeTopList[index].title
                            font.pointSize: R.font_size_notice_list_common_title//R.pt(45)
                            color: "white"
                            verticalAlignment: Text.AlignBottom
                        }

                        CPImage
                        {
                            width: R.dp(50)
                            height: R.dp(50)
                            source: R.image("new");
                            visible: false
                            anchors
                            {
                                left: topTxtContents.right
                                leftMargin: R.dp(10)
                                bottom: topTxtContents.bottom
                                bottomMargin: R.dp(5)
                            }
                        }
                    }
                    LYMargin { height: R.dp(5) }
                    CPText
                    {
                        id: topTxtDate
                        width: parent.width - R.dp(80)
                        height: itemHeight * 0.5 - R.dp(2) - R.dp(5)
                        color: R.color_gray001//"gray"
                        text: opt.ds ? "2018.01.03" : md.noticeTopList[index].writeDate
                        font.pointSize: R.font_size_notice_list_common_date //R.pt(40)
                        verticalAlignment: Text.AlignTop
                        anchors
                        {
                            left: parent.left
                            leftMargin: R.dp(40)
                        }
                    }
                }

                CPText
                {
                    id: topTxtView
                    width: R.dp(300)
                    color: R.color_gray001//"gray"
                    text: "조회수: " + (opt.ds ? "untitled" : md.noticeTopList[index].viewCount)
                    font.pointSize: R.font_size_notice_list_common_date //R.pt(40)
                    verticalAlignment: Text.AlignTop
                    horizontalAlignment: Text.AlignRight
                    anchors
                    {
                        right: parent.right
                        rightMargin: R.dp(42)
                        bottom: parent.bottom
                        bottomMargin: R.dp(30)
                    }
                }

                LYMargin
                {
                    color: R.color_gray87
                    width: parent.width; height: R.height_line_1px
                    anchors
                    {
                        bottom: parent.bottom
                    }
                }

                Rectangle
                {
                    width: parent.width
                    height: parent.height
                    color: "transparent"


                    ColorAnimation on color {
                        id: cc1
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
                            cc1.running = true;
                            if(opt.ds) return;
                            tt1.running = true;
                        }
                    }

                    Timer
                    {
                        id: tt1
                        running: false
                        repeat: false
                        interval: 300
                        onTriggered:
                        {
                            pushCourseNoticeDetailViewWithIndex(mainView.noBoard, md.noticeTopList[index].boardArticleNo, index);
                        }
                    }
                }
            }
        }

        Flickable
        {
            id: flick
            width: parent.width
            height: parent.height - (itemHeight * md.noticeTopList.length)
            contentWidth : parent.width
            contentHeight: mainColumn.height + R.dp(200)
            maximumFlickVelocity: R.flickVelocity(mainColumn.height)
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            onMovementEnded:
            {
                if(opt.ds) return;
                if(flick.atYEnd)
                {
                    if(dLength % 20 == 0 && dLength > 0)
                    {
                        showMoreIndicator(ENums.WORKING_COURSENOTICE);
                        wk.getCourseBoardList(dLength / 20 + 1, noBoard);
                        wk.request();
                    }
                }

                R.log("flick.contentY: " + flick.contentY);
            }

            Column
            {
                id: mainColumn
                width: parent.width

                Repeater
                {
                    model: dLength
                    Rectangle
                    {
                        width: parent.width
                        height: itemHeight

                        Column
                        {
                            width: parent.width
                            height: itemHeight

                            Item
                            {
                                width: parent.width - R.dp(80)
                                height: itemHeight * 0.5
                                anchors
                                {
                                    left: parent.left
                                    leftMargin: R.dp(40)
                                }

                                CPText
                                {
                                    id: txtContents
                                    //                            width: parent.width
                                    height: parent.height
                                    text: opt.ds ? ("untitled") + index : md.noticeList[index].title
                                    font.pointSize: R.font_size_notice_list_common_title//R.pt(45)
                                    verticalAlignment: Text.AlignBottom
                                }

                                CPImage
                                {
                                    width: R.dp(50)
                                    height: R.dp(50)
                                    source: R.image("new");
                                    visible: false
                                    anchors
                                    {
                                        left: txtContents.right
                                        leftMargin: R.dp(10)
                                        bottom: txtContents.bottom
                                        bottomMargin: R.dp(5)
                                    }
                                }
                            }
                            LYMargin { height: R.dp(5) }
                            CPText
                            {
                                id: txtDate
                                width: parent.width - R.dp(80)
                                height: itemHeight * 0.5 - R.dp(2) - R.dp(5)
                                color: R.color_gray87//"gray"
                                text: opt.ds ? "untitled" : md.noticeList[index].writeDate
                                font.pointSize: R.font_size_notice_list_common_date//R.pt(40)
                                verticalAlignment: Text.AlignTop
                                anchors
                                {
                                    left: parent.left
                                    leftMargin: R.dp(40)
                                }
                            }
                        }

                        CPText
                        {
                            id: txtView
                            width: R.dp(300)
                            color: R.color_gray87//"gray"
                            text: "조회수: " + (opt.ds ? "untitled" : md.noticeList[index].viewCount)
                            font.pointSize: R.font_size_notice_list_common_date //R.pt(40)
                            verticalAlignment: Text.AlignTop
                            horizontalAlignment: Text.AlignRight
                            anchors
                            {
                                right: parent.right
                                rightMargin: R.dp(42)
                                bottom: parent.bottom
                                bottomMargin: R.dp(30)
                            }
                        }

                        LYMargin
                        {
                            color: R.color_gray87
                            width: parent.width; height: R.height_line_1px
                            anchors
                            {
                                bottom: parent.bottom
                            }
                        }

                        Rectangle
                        {
                            width: parent.width
                            height: parent.height
                            color: "transparent"


                            ColorAnimation on color {
                                id: cc2
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
                                    cc2.running = true;
                                    if(opt.ds) return;
                                    tt2.running = true;
                                }
                            }

                            Timer
                            {
                                id: tt2
                                running: false
                                repeat: false
                                interval: 300
                                onTriggered:
                                {
                                    pushCourseNoticeDetailViewWithIndex(mainView.noBoard, md.noticeList[index].boardArticleNo, index);
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

        condRun: ENums.WORKING_COURSENOTICE
        condStop: ENums.FINISHED_COURENOTICE

        anchors.bottom: parent.bottom

        visible: dLength > 0
    }

    Timer
    {
        running: opt.ds ? false : (md.CRUDHandlerType === 1)
        repeat: false
        interval: 300
        onTriggered:
        {
            md.setCRUDHandlerType(0);
            wk.getCourseBoardList(1, noBoard);
            pushHomeStack("CourseNoticeDetail", { "noBoard": md.noticeDetail.boardNo, "noBoardArticle": md.noticeDetail.boardArticleNo })
        }
    }

    Timer
    {
        running: opt.ds ? false : (md.CRUDHandlerType === 2)
        repeat: false
        interval: 300
        onTriggered:
        {
            md.setCRUDHandlerType(0);
            md.removeCurrentArticle();
        }
    }

    PGCourseQuestionNew
    {
        id: courseQuestionNew
        noBoard: mainView.noBoard
        editType: 0
        name: "CourseNotice"
        x: opt.ds ? R.dp(1242) : appWindow.width
    }


//    MouseArea
//    {
//        width: parent.width * 0.2
//        height: parent.height
//        y: mainView.heightStatusBar + R.height_titleBar
//        drag.target: mainView
//        drag.axis: Drag.XAxis
//        drag.minimumX: 0
//        drag.maximumX: parent.width * 0.2
//        onPositionChanged:
//        {
////            R.log("Positioned mouseX: " + mouseX);
//        }
//        onReleased:
//        {
//            R.log("Released mouseX: " + mouseX);
//            if(mouseX >= R.dp(200)) evtBack();
//            else comebackX.running = true;
//        }
//    }

//    PropertyAnimation
//    {
//        id: comebackX;
//        target: mainView
//        property: "x";
//        to: 0
//        running: false
//        duration: 50
//    }
}
