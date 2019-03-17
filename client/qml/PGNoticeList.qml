import QtQuick 2.9
import QtQuick.Controls 2.2
import "Resources.js" as R
import enums 1.0

PGPage {
    id: mainView
    visibleSearchBtn: false
    titleText: "공지사항"
    titleTextColor: "black"
    titleLineColor: "black"
    visibleBackBtn: true
    pageName: "NoticeList"

    property int itemHeight: R.dp(180)
    property int dLength : opt.ds ? 40 : md.noticeList.length
    property int noticeType : 0 /* 0: 공지사항, 1: 질의사항 */

    Component.onCompleted:
    {
        if(opt.ds) return;
        dataGetter.running = true
    }

    Timer
    {
        running: opt.ds ? false : (md.requestNativeBackBehavior === ENums.REQUESTED_BEHAVIOR && compareCurrentPage(pageName))
        repeat: false
        interval: 100
        onTriggered:
        {
            md.setRequestNativeBackBehavior(ENums.WAIT_BEHAVIOR);
            if(closeWindowInMain()) return;
            evtBack();
        }
    }

    Timer
    {
        id: dataGetter
        running: false
        repeat: false
        interval: 300
        onTriggered:
        {
            if(noticeType > 2)
            {
                R.log("[PGNoticeList.qml] No valid board type, at this page. Please check 'noticeType'");
                alarm("유효하지 않은 게시판입니다.");
                popHomeStack();
                return;
            }

            md.clearNoticeList();

            wk.getSystemNoticeList(noticeType, 1);
            wk.request();
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
        message: opt.ds ? R.message_has_no_article_list : (wk.refreshWorkResult === ENums.FINISHED_MAIN ? R.message_has_no_article_list : R.message_load_article_list)
        tMargin: R.dp(100)
    }

    Column
    {
        width: parent.width
        height: parent.height
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
                            font.pointSize: R.font_size_notice_list_common_title // R.pt(35)
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
                        font.pointSize: R.font_size_notice_list_common_date//R.pt(30)
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
                    font.pointSize: R.font_size_notice_list_common_date
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
                            pushNoticeDetailViewWithIndex(md.noticeTopList[index].boardNo, md.noticeTopList[index].boardArticleNo, index);
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
            contentHeight: itemHeight * dLength + settings.heightStatusBar + R.height_titleBar + R.dp(200)
            maximumFlickVelocity: R.flickVelocity(itemHeight * dLength)
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            onMovementEnded:
            {
                if(opt.ds) return;
                if(flick.atYEnd)
                {
                    if(dLength % 20 == 0 && dLength > 0)
                    {
                        showMoreIndicator(ENums.WORKING_SYSTEMNOTICE);
                        wk.getSystemNoticeList(noticeType, dLength / 20 + 1);
                        wk.request();
                    }
                }
            }

            Column
            {
                id: mainColumn
                width: parent.width
                height: itemHeight * dLength

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
                                    height: parent.height
                                    text: opt.ds ? ("untitled") + index : md.noticeList[index].title
                                    font.pointSize: R.font_size_notice_list_common_title
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
                                font.pointSize: R.font_size_notice_list_common_date
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
                            font.pointSize: R.font_size_notice_list_common_date
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
                                    pushNoticeDetailViewWithIndex(md.noticeList[index].boardNo, md.noticeList[index].boardArticleNo, index);
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

        condRun: ENums.WORKING_SYSTEMNOTICE
        condStop: ENums.FINISHED_SYSTEMNOTICE

        anchors.bottom: parent.bottom
        visible: dLength > 0
    }
}
