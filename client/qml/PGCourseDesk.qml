import QtQuick 2.9
import QtQuick.Controls 2.2
import "Resources.js" as R
import enums 1.0

PGPage
{
    id: mainView
    visibleSearchBtn: true
    searchImg: R.image("mypage")
    titleText: opt.ds ? "일러스트 기초" : md.courseDetail.serviceTitle
    titleTextColor: "black"
    titleLineColor: "black"
    visibleBackBtn: true
    forceAlignHCenter: false
    pageName: "CourseDesk"
    property string from : "undefined"
    property int courseNo: 0
    property int listIndex: 0

    onEvtInitData:
    {
        md.homelist[listIndex].setViewCount(md.homelist[listIndex].viewCount+1);
        md.clearCourseDetail();
    }

    Component.onCompleted:
    {
        if(opt.ds) return;
        dataGetter.running = true;
        printPageInfo();
    }

    onEvtSearch: showMyPage(true);

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
            if(courseNo < 1)
            {
                R.log("Where: PGCourseDesk.qml >> courseNo < 1");
                popHomeStack();
                return;
            }

            wk.getCourseDetail(courseNo);
            wk.request();
        }
    }

    Column
    {
        id: mainColumn
        width: parent.width
        y: mainView.heightStatusBar + R.height_titleBar

        LYMargin { width: parent.width; height: R.dp(19); color: R.color_gray001 }
        LYMargin { width: parent.width; height: R.height_line_1px; color: "black" }

        Rectangle
        {
            width: parent.width
            height: R.height_course_list_thumb //R.dp(790)
            color: R.color_gray001

            CPImageView
            {
                id: thumbnail
                width: parent.width
                height: parent.height
                animateCond: thumbnail.imageLoadState == Image.Ready
                src : opt.ds ? R.image("no_image") : md.courseDetail.courseImageUrl
            }
        }
        LYMargin { width: parent.width; height: R.height_line_1px; color: "black" }

        LYMargin { width: parent.width; height: R.dp(30) }
        Row
        {
            width: parent.width
            height: R.dp(160)
            LYMargin { width: R.dp(30) }
            CPTextButton
            {
                name: "강의목록"
                width: parent.width - R.dp(30) * 2
                pointSize: R.pt(45)
                onClick:
                {
                    if(opt.ds) return;

                    pushHomeStack("ClipList", { "enabledDelivery": true });
                }
            }
            LYMargin { width: R.dp(30) }
        }
        LYMargin { width: parent.width; height: R.dp(30) }
        Row
        {
            width: parent.width
            height: R.dp(160)
            LYMargin { width: R.dp(30) }
            CPTextButton
            {
                name: "Q & A"
                width: parent.width - R.dp(30) * 2 - R.height_line_1px
                height: parent.height
                pointSize: R.pt(45)
                color: "white"
                subColor: R.color_gray001
                txtColor: "black"
                border.width: R.height_line_1px
                border.color: "black"
                onClick:
                {
                    if(opt.ds) return;
                    showIndicator(true);
                    md.clearNoticeList();
                    pushHomeStack("CourseNotice",
                                  {
                                      "noBoard": md.boardList.length > 0 ? md.boardList[1].boardNo : 0,
                                                                           "titleText": (md.boardList.length > 0 ? md.boardList[1].title : ""),
                                                                           "enableWrite": md.boardList.length > 0 ? (md.boardList[1].writableStudent > 0 ? true : false) : false
                                  });

                }
            }
            LYMargin { width: R.dp(30) }
        }
        LYMargin { width: parent.width; height: R.dp(35) }

        Rectangle
        {
            width: parent.width; height: applyTxt.height
            LYMargin
            {
                id: line1
                height: R.height_line_1px; width: parent.width - R.dp(30) * 2
                color: R.color_bgColor001;
                anchors
                {
                    verticalCenter: parent.verticalCenter;
                    left: parent.left
                    leftMargin: R.dp(30)
                }
            }

            Rectangle
            {
                width: applyTxt.width + R.dp(80)
                height: applyTxt.height
                anchors
                {
                    horizontalCenter: parent.horizontalCenter
                }

                CPText
                {
                    id: applyTxt
                    text: "강의 소개"
                    font.pointSize: R.pt(45)
                    color: R.color_bgColor001
                    verticalAlignment: Text.AlignVCenter
                    anchors
                    {
                        horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        }
        LYMargin { width: parent.width; height: R.dp(30) }

    }

    Flickable
    {
        id: flick
        width: parent.width
        height: parent.height - (mainColumn.height + mainView.heightStatusBar + R.height_titleBar) - R.dp(20)
        contentWidth : parent.width
        contentHeight: detailRegion.height + R.dp(200)
        maximumFlickVelocity: R.flickVelocity(detailRegion.height)
        clip: true
        y: mainColumn.height + mainView.heightStatusBar + R.height_titleBar

        Rectangle
        {
            id: detailRegion
            width: parent.width - R.dp(50) * 2
            height: descTxt.height
            anchors
            {
                horizontalCenter: parent.horizontalCenter
            }

            CPText
            {
                id: descTxt
                width: parent.width
                font.pointSize: R.pt(48)
                lineHeight: 1.1
                text: opt.ds ?
                          "일러스트를 다루기 위한 가장 기본적인 부분을 다루는 강좌입니다.
심화 과정을 다루고 있지는 않으나 심화 과정을 원하시는 분은 일러스트 심화 강좌를 봐주시면 됩니다.
일러스트를 다루기 위한 가장 기본적인 부분을 다루는 강좌입니다.
심화 과정을 다루고 있지는 않으나 심화 과정을 원하시는 분은 일러스트 심화 강좌를 봐주시면 됩니다.
일러스트를 다루기 위한 가장 기본적인 부분을 다루는 강좌입니다.
심화 과정을 다루고 있지는 않으나 심화 과정을 원하시는 분은 일러스트 심화 강좌를 봐주시면 됩니다.
일러스트를 다루기 위한 가장 기본적인 부분을 다루는 강좌입니다.
심화 과정을 다루고 있지는 않으나 심화 과정을 원하시는 분은 일러스트 심화 강좌를 봐주시면 됩니다.
일러스트를 다루기 위한 가장 기본적인 부분을 다루는 강좌입니다.
심화 과정을 다루고 있지는 않으나 심화 과정을 원하시는 분은 일러스트 심화 강좌를 봐주시면 됩니다.
일러스트를 다루기 위한 가장 기본적인 부분을 다루는 강좌입니다.
심화 과정을 다루고 있지는 않으나 심화 과정을 원하시는 분은 일러스트 심화 강좌를 봐주시면 됩니다."


                        :
                          md.courseDetail.shortDescription
            }
        }
    }

    //    Timer
    //    {
    //        running: opt.ds ? false : matchPrevPage(pageName)
    //        interval: 30
    //        onTriggered:
    //    }
}
