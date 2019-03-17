import QtQuick 2.9
import QtQuick.Controls 2.2
import "Resources.js" as R
import enums 1.0

PGPage {
    id: mainView
    visibleSearchBtn: false
    titleText: "이벤트"
    titleTextColor: "black"
    titleLineColor: "black"
    visibleBackBtn: true
    pageName: "EventList"

    property int itemHeight: R.dp(300)
    property int dLength : opt.ds ? 40 : md.noticeList.length
    property int noBoard : 3 /* 3: 과목 공지사항, 4: Q&A */

    Component.onCompleted:
    {
        if(opt.ds) return;
        dataGetter.running = true
    }

    onEvtInitData: md.clearNoticeList();

    Timer
    {
        id: dataGetter
        running: false
        repeat: false
        interval: 300
        onTriggered:
        {
            md.clearNoticeList();

            wk.getApplyEventList();
            wk.request();
        }
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

    CPNoData
    {
        id: noDataRect
        width: parent.width
        height: parent.height - mainView.heightStatusBar - R.height_titleBar - mainView.heightBottomArea
        y: mainView.heightStatusBar + R.height_titleBar
        visible: opt.ds ? true : (dLength === 0)
        showText: true
        message: opt.ds ? R.message_has_no_event_list : (wk.refreshWorkResult === ENums.FINISHED_EVENTLIST ? R.message_has_no_event_list : R.message_load_event_list)
        tMargin: R.dp(100)
    }

    ListModel
    {
        id: listModel
        ListElement
        {
            title: "이벤트 제목입니다."
            cash: 100
            imageUrl: "https://scontent-sjc3-1.cdninstagram.com/vp/eaf56aa30148a578e29d34631cb84968/5BB12F51/t51.2885-15/e35/26156236_123939068416546_2742507055683207168_n.jpg"
            startDate: "2018.12.02 00:00:00"
            endDate: "2018.12.30 00:00:00"
        }

        ListElement
        {
            title: "이벤트 제목입니다."
            cash: 200
            imageUrl: "http://kr.people.com.cn/NMediaFile/2017/0808/FOREIGN201708081338000326513010044.jpg"
            startDate: "2018.12.02 00:00:00"
            endDate: "2018.12.30 00:00:00"
        }

        ListElement
        {
            title: "이벤트 제목입니다."
            cash: 400
            imageUrl: "https://0.soompi.io/wp-content/uploads/2018/04/04033103/Song-Ji-Hyo1.jpg"
            startDate: "2018.12.02 00:00:00"
            endDate: "2018.12.30 00:00:00"
        }

        ListElement
        {
            title: "이벤트 제목입니다."
            cash: 9999
            imageUrl: "http://img.yonhapnews.co.kr/etc/inner/KR/2018/03/28/AKR20180328100900005_01_i.jpg"
            startDate: "2018.12.02 00:00:00"
            endDate: "2018.12.30 00:00:00"
        }

        ListElement
        {
            title: "이벤트 제목입니다.이벤트 제목입니다.이벤트 제목입니다.이벤트 제목입니다.이벤트 제목입니다.이벤트 제목입니다.이벤트 제목입니다."
            cash: 50
            imageUrl: "https://0.soompi.io/wp-content/uploads/2018/04/04033103/Song-Ji-Hyo1.jpg"
            startDate: "2018.12.02 00:00:00"
            endDate: "2018.12.30 00:00:00"
        }
    }

    Column
    {

        width: parent.width
        height: parent.height - mainView.heightStatusBar - R.height_titleBar - mainView.heightBottomArea
        y: mainView.heightStatusBar + R.height_titleBar

        Flickable
        {
            id: flick
            width: parent.width
            height: parent.height
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
//                        showMoreIndicator(ENums.WORKING_EVENTLIST);
                    }
                }
            }

            Column
            {
                id: mainColumn
                width: parent.width

                Repeater
                {
                    model: opt.ds ? listModel : dLength
                    Rectangle
                    {
                        width: parent.width
                        height: descColumn.height + R.dp(70)

                        Column
                        {
                            id: descColumn
                            width: parent.width - thumbnailImage.width - R.dp(50) - /*pointRect.width -*/ R.dp(70) - R.dp(80)
                            anchors
                            {
                                left: parent.left //pointRect.right
                                leftMargin: R.dp(60)
                                top: parent.top
                                topMargin: R.dp(50)
                            }

                            Item
                            {
                                id: txtContentsItem
                                width: parent.width
                                height: txtContents.height

                                CPText
                                {
                                    id: txtContents
                                    width: parent.width
                                    text: opt.ds ? title : md.noticeList[index].title
                                    font.pointSize: R.pt(45)

                                    anchors
                                    {
                                        left: parent.left
                                    }
                                }
                            }
                            LYMargin { height: R.dp(20) }

                            Item
                            {
                                width: parent.width
                                height: dateLb.height + pointLb.height + R.dp(60)

                                Rectangle
                                {
                                    id: dateLb
                                    width: R.dp(230)
                                    height: R.dp(70)
                                    color: R.color_bgColor001
                                    radius: 30
                                    CPText
                                    {
                                        text: "이벤트 기간"
                                        color: "white"
                                        font.pointSize: R.pt(35)
                                        width: parent.width
                                        height: parent.height
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                    }

                                    anchors
                                    {
                                        top: parent.top
                                        topMargin: R.dp(10)
                                        left: parent.left
                                    }
                                }

                                CPText
                                {
                                    id: dateTxt
                                    width: parent.width - thumbnailRect.width
                                    height: R.dp(70)
                                    font.pointSize: R.pt(35)
                                    color: R.color_gray87
                                    text: opt.ds ? "2018.03.02 ~ 2018.04.05" : md.noticeList[index].updateDate
                                    verticalAlignment: Text.AlignVCenter
                                    anchors
                                    {
                                        top: dateLb.top
                                        left: dateLb.right
                                        leftMargin: R.dp(20)
                                    }
                                }

                                Rectangle
                                {
                                    id: pointLb
                                    width: R.dp(220)
                                    height: R.dp(70)
                                    color: R.color_bgColor001
                                    radius: 30
                                    CPText
                                    {
                                        text: "소모 포인트"
                                        color: "white"
                                        font.pointSize: R.pt(35)
                                        width: parent.width
                                        height: parent.height
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                    }

                                    anchors
                                    {
                                        top: dateLb.bottom
                                        topMargin: R.dp(20)
                                        left: dateLb.left
                                    }
                                }

                                CPText
                                {
                                    id: pointTxt
                                    width: parent.width - R.dp(124) - R.dp(30)
                                    height: R.dp(70)
                                    font.pointSize: R.pt(35)
                                    color: R.color_gray87
                                    text: (opt.ds ? "500" : md.noticeList[index].point) + "pt."
                                    verticalAlignment: Text.AlignVCenter
                                    anchors
                                    {
                                        top: pointLb.top
                                        left: pointLb.right
                                        leftMargin: R.dp(20)
                                    }
                                }
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
                                    md.setCurrentBoardNo(md.noticeList[index].prizeNo);
                                    pushHomeStack("EventDetail");
                                }
                            }
                        }


                        Rectangle
                        {
                            id: thumbnailRect
                            width: opt.ds ? R.dp(250) : (md.noticeList[index].imageUrl === "" ? 0 : R.dp(250))
                            height: R.dp(250)
                            color: "transparent"
                            anchors
                            {
                                right: parent.right
                                rightMargin: R.dp(50)
                                verticalCenter: parent.verticalCenter
                            }

                            CPImage
                            {
                                id: thumbnailImage
                                width: parent.width
                                height: parent.height
                                source: opt.ds ? imageUrl : md.noticeList[index].imageUrl
                                fillMode: Image.PreserveAspectCrop
                            }

                            Rectangle
                            {
                                width: parent.width
                                height: parent.height
                                color: "transparent"


                                ColorAnimation on color{
                                    id: imgccc
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
                                        imgccc.running = true;
                                        showBigImage.source = showBigImage.source = R.startsWithAndReplace(md.noticeList[index].imageUrl, "https", "http");
                                        showBigImage.show();
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

//    CPFlickMoreIndicator
//    {
//        width: parent.width
//        height: R.dp(120)

//        condRun: ENums.WORKING_EVENTLIST
//        condStop: ENums.FINISHED_EVENTLIST

//        anchors.bottom: parent.bottom
//    }

    CPIMGView
    {
        id: showBigImage
        opacity: 0
        width: parent.width
        height: parent.height
        enabled: false
    }

    onEvtBehaviorAndroidBackButton:
    {
        if(showBigImage.opacity === 1.0)
        {
            showBigImage.hide();
            return;
        }
        else evtBack();
    }

}
