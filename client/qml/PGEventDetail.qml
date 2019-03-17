import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import "Resources.js" as R
import enums 1.0

PGPage {

    id: mainView
    visibleSearchBtn: false
    titleText: "이벤트"
    titleTextColor: "black"
    titleLineColor: "black"
    visibleBackBtn: true
    pageName: "EventDetail"

    property int itemHeight: R.dp(180)
    //    property int dLength : opt.ds ? 10 : md.repleList.length

    property int prizeNo: opt.ds ? 0 : md.currentBoardNo
    property int selectedIndex: 0

    property bool visibleApplied: true

//    property int heightEventContents: 0
//    property int heightAppliedContents: 0

    onEvtInitData: {
        md.clearNoticeDetail();
    }

    function iniApplied()
    {
        if(hAppliedImage === 0)
            hAppliedImage = appliedImage.height;

        if(hAppliedText === 0)
            hAppliedText = appliedText.height;

        appliedImage.height = 0;
        appliedText.height = 0;
        lineMiddle.height = 0;
    }

    Component.onCompleted:
    {
        if(opt.ds) return;
        dataGetter.running = true

//        if(md.noticeDetail.appliedImageUrl === "")
//            iniApplied();
    }

    Timer
    {
        id: dataGetter
        running: false
        repeat: false
        interval: 300
        onTriggered:
        {
            if(prizeNo < 0)
            {
                alarm("해당 게시물이 존재하지 않습니다.");
                ap.setYMethod(mainView, "popHomeStack");
                return;
            }

            wk.getApplyEventDetail(prizeNo);
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

    Timer
    {
        running: opt.ds ? false : wk.getApplyEventDetailResult !== ENums.WAIT
        repeat: false
        interval: 300
        onTriggered:
        {
            if(wk.vGetApplyEventDetailResult() === ENums.NAGATIVE)
            {
                error();
                ap.setYMethod(mainView, "popHomeStack");
            }
        }
    }

    Column
    {
        id: titleColumn
        width: parent.width
        y: mainView.heightStatusBar + R.height_titleBar + R.dp(70)
        Item
        {
            width: parent.width
            height: R.dp(52)
            CPText
            {
                id: titleText
                width: parent.width - R.dp(124)
                height: parent.height
                font.pointSize: R.pt(60)
                text: opt.ds ? "이벤트 제목입니다." : md.noticeDetail.title
                anchors
                {
                    horizontalCenter: parent.horizontalCenter
                }
            }
        }

        LYMargin { height: R.dp(40) }
        Item
        {
            width: parent.width
            height: R.height_line_1px * 2
            LYMargin
            {
                width: parent.width - R.dp(62)*2
                height: parent.height
                color: R.color_bgColor002
                anchors
                {
                    horizontalCenter: parent.horizontalCenter
                }
            }
        }
        LYMargin { height: R.dp(20) }
        Item
        {
            width: parent.width
            height: dateLb.height + pointLb.height + stateLb.height + R.dp(60)

            Rectangle
            {
                id: dateLb
                width: R.dp(230)
                height: R.dp(80)
                color: R.color_bgColor001
                radius: 30
                CPText
                {
                    text: "이벤트 기간"
                    color: "white"
                    font.pointSize: R.pt(40)
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
                    leftMargin: R.dp(62)
                }
            }

            CPText
            {
                id: dateTxt
                width: parent.width - R.dp(124) - R.dp(30)
                height: R.dp(80)
                font.pointSize: R.pt(40)
                color: R.color_gray87
                text: opt.ds ? "2018.03.02 ~ 2018.04.05" : md.noticeDetail.updateDate
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
                height: R.dp(80)
                color: R.color_bgColor001
                radius: 30
                CPText
                {
                    text: "소모 포인트"
                    color: "white"
                    font.pointSize: R.pt(40)
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
                //                width: parent.width - R.dp(124) - R.dp(30)
                height: R.dp(80)
                font.pointSize: R.pt(40)
                color: R.color_gray87
                text: (opt.ds ? "3" : md.noticeDetail.point) + "pt."
                verticalAlignment: Text.AlignVCenter
                anchors
                {
                    top: pointLb.top
                    left: pointLb.right
                    leftMargin: R.dp(20)
                }
            }

            CPText
            {
                id: myPointTxt
                //                width: parent.width - R.dp(124) - R.dp(30)
                height: R.dp(80)
                font.pointSize: R.pt(40)
                color: R.color_gray87
                text: "(보유 포인트: <font color='#fa7070'>" + (opt.ds ? "300" : settings.totalHavePoint) + "pt.</font>)"
                verticalAlignment: Text.AlignVCenter
                anchors
                {
                    top: pointTxt.top
                    left: pointTxt.right
                    leftMargin: R.dp(10)
                }
            }



            Rectangle
            {
                id: stateLb
                width: R.dp(220)
                height: R.dp(80)
                color: R.color_bgColor001
                radius: 30
                CPText
                {
                    text: "진행 상태"
                    color: "white"
                    font.pointSize: R.pt(40)
                    width: parent.width
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }

                anchors
                {
                    top: pointLb.bottom
                    topMargin: R.dp(20)
                    left: pointLb.left
                }
            }

            CPText
            {
                id: stateTxt
                width: parent.width - R.dp(124) - R.dp(30)
                height: R.dp(80)
                font.pointSize: R.pt(40)
                color: R.color_gray87
                text:
                {
                    if(opt.ds) return "진행 중인 이벤트입니다.";
                    else
                    {
                        var state = md.noticeDetail.attendanceCode;
                        if(state === 0) return "진행 중인 이벤트입니다.";
                        else if(state === 1) return "보상이 완료된 이벤트입니다. (지급일: <font color='#fa7070'>'" + md.noticeDetail.writeDate + ")"
                        else return "-";
                    }
                }
                verticalAlignment: Text.AlignVCenter
                anchors
                {
                    top: stateLb.top
                    left: stateLb.right
                    leftMargin: R.dp(20)
                }
            }
        }
        LYMargin { height: R.dp(20) }

        Item
        {
            width: parent.width
            height: R.height_line_1px * 2
            LYMargin
            {
                width: parent.width - R.dp(62)*2
                height: parent.height
                color: R.color_bgColor002
                anchors
                {
                    horizontalCenter: parent.horizontalCenter
                }
            }
        }
        LYMargin { height: R.dp(20) }

        Rectangle
        {
            id: eventBtn
            width: parent.width - R.dp(124)
            height: R.dp(150)
            anchors.horizontalCenter: parent.horizontalCenter
            color: R.color_bgColor002

            CPText
            {
                text:
                {
                    if(opt.ds) return "이벤트 신청하기";
                    var state = md.noticeDetail.attendanceCode
                    switch(state)
                    {
                    case -2: return "이벤트 신청하기";
                    case -1: return "로그인이 필요합니다.";
                    case 0:
                        if(md.noticeDetail.appliedText === "" && md.noticeDetail.appliedImageUrl === "" ) return "신청이 완료된 이벤트입니다.";
                        else
                        {
                            if(visibleApplied)
                                return "이벤트 신청 내용 숨기기";
                            return "이벤트 신청 내용 보이기";
                        }

                    case 1: return "당첨된 이벤트입니다.";
                    case 2: return "미당첨된 이벤트입니다.";
                    }
                }
                color: "white"
                font.pointSize: R.pt(50)
                anchors
                {
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }
            }

            Rectangle
            {
                width: parent.width
                height: parent.height
                color: "transparent"

                ColorAnimation on color{
                    id: ccccc
                    from: "#44000000"
                    to: "transparent"
                    duration: 200
                    running: false
                }


                MouseArea
                {
                    anchors.fill: parent
                    enabled:
                    {
                        if(opt.ds) return true
                        var state = md.noticeDetail.attendanceCode
                        switch(state)
                        {
                        case -2: return true;
                        case -1: return true;
                        case 0:
                            if(md.noticeDetail.appliedText === "" && md.noticeDetail.appliedImageUrl === "" ) return false;
                            else return true;

                        case 1: return false;
                        case 2: return false;
                        }
                    }

                    onClicked:
                    {
//                        ccccc.running = true;
                        if(opt.ds)
                        {
                            spread();
                            return;
                        }


                        var state = md.noticeDetail.attendanceCode
                        switch(state)
                        {
                        case -2:

                            if(!logined())
                            {
                                alarmNeedLogin();
                                return;
                            }
                            tmEvtList.running = true;
                            break;

                        case -1:
                            alarmNeedLogin();
                            break;

                        case 0:
                            R.log("appliedImage.height: " + appliedImage.height);
                            visibleApplied = !visibleApplied;
                            spread();
                            break;
                        }
                    }
                }

                Timer
                {
                    id: tmEvtList
                    running: false
                    repeat: false
                    interval: 200
                    onTriggered:
                    {
                        if(!logined())
                        {
                            alarmNeedLogin();
                            return;
                        }

                        var prizeType = md.noticeDetail.prizeType
                        if(prizeType === 1) {
                            alarm2(R.message_apply_event);
                            ap.setYMethod(mainView, "apply");
                        } else {
                            pushHomeStack( "EventApplication", { "eventContents":md.noticeDetail.contents, "eventTitle":md.noticeDetail.title } );
                        }
                    }
                }

                Timer
                {
                    running: opt.ds ? false : (wk.setApplyEventResult === ENums.POSITIVE)
                    repeat: false
                    interval: 200
                    onTriggered:
                    {
                        alarm("이벤트 신청이 정상적으로 처리되었습니다.");
                        ap.setYMethod(mainView, "refresh");
                    }
                }
            }
        }
    }

    function refresh()
    {
        wk.vSetApplyEventResult();
        wk.getUserPoint();
        wk.getApplyEventDetail(mainView.prizeNo);
        wk.request();
    }

    Flickable
    {
        id: flick
        width: parent.width
        height: parent.height - mainView.heightStatusBar - R.height_titleBar - mainView.heightBottomArea - titleColumn.height
        contentWidth : parent.width
        contentHeight: appliedDetailBox.height + R.dp(300)
        clip: true

        boundsBehavior: Flickable.StopAtBounds
        anchors
        {
            top: titleColumn.bottom
            topMargin: R.dp(50)
        }

        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                R.hideKeyboard();
            }
        }

        Rectangle
        {
            id: appliedDetailBox
            width: parent.width
            height: lineTop.height + appliedImage.height + appliedText.height + lineMiddle.height + image.height + contentTxt.height

            Rectangle
            {
                id: lineTop
                width: parent.width - R.dp(124); height: (md.noticeDetail.appliedText === "" && md.noticeDetail.appliedImageUrl === "") ? 0 : applyTxt.height
                visible: !(md.noticeDetail.appliedText === "" && md.noticeDetail.appliedImageUrl === "")

                CPText
                {
                    id: applyTxt
                    text: "신청 내용"
                    font.pointSize: R.pt(45)
                    color: R.color_bgColor001
                    anchors
                    {
                        verticalCenter: parent.verticalCenter
                    }
                    verticalAlignment: Text.AlignVCenter
                }

                LYMargin
                {

                    width: parent.width - applyTxt.width - R.dp(20)
                    height: R.height_line_1px
                    color: R.color_bgColor002

                    anchors
                    {
                        verticalCenter: parent.verticalCenter;
                        left: applyTxt.right
                        leftMargin: R.dp(20)
                    }
                }

                anchors
                {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                }
            }

            CPImage
            {
                id: appliedImage
                width: parent.width - R.dp(124)
                source: opt.ds ? R.sample_image06 : R.startsWithAndReplace(md.noticeDetail.appliedImageUrl, "https", "http")
                anchors
                {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin: lineTop.height + (lineTop.height === 0 ? 0 : R.dp(20))
                }
            }

            CPText
            {
                id: appliedText
                text: opt.ds ? "이벤트 신청 상세 보기입니다!" : md.noticeDetail.appliedText
                width: parent.width - R.dp(124)
                font.pointSize: R.pt(45)
                anchors
                {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin: lineTop.height + (lineTop.height === 0 ? 0 : R.dp(20)) + appliedImage.height + (appliedImage.height === 0 ? 0 : R.dp(20))
                }
            }

            Rectangle
            {
                id: lineMiddle
                width: parent.width - R.dp(124); height: eventTxt.height

                CPText
                {
                    id: eventTxt
                    text: "이벤트 내용"
                    font.pointSize: R.pt(45)
                    color: R.color_bgColor001
                    anchors
                    {
                        verticalCenter: parent.verticalCenter
                    }
                    verticalAlignment: Text.AlignVCenter
                }

                LYMargin
                {

                    width: parent.width - eventTxt.width - R.dp(20)
                    height: R.height_line_1px
                    color: R.color_bgColor002

                    anchors
                    {
                        verticalCenter: parent.verticalCenter;
                        left: eventTxt.right
                        leftMargin: R.dp(20)
                    }
                }

                anchors
                {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin:
                    lineTop.height + (lineTop.height === 0 ? 0 : R.dp(20))
                  + appliedImage.height + (appliedImage.height === 0 ? 0 : R.dp(20))
                  + appliedText.height + (appliedText.height === 0 ? 0 : R.dp(20))
                  + R.dp(10)
                }
            }

            CPImage
            {
                id: image
                width: parent.width - R.dp(124)
                source: opt.ds ? R.sample_image07 : R.startsWithAndReplace(md.noticeDetail.imageUrl, "https", "http")
                anchors
                {
                    horizontalCenter: parent.horizontalCenter
                    top: lineMiddle.bottom
                    topMargin: R.dp(20)
                }
            }
            CPText
            {
                id: contentTxt
                text: opt.ds ? "내용입니당." : md.noticeDetail.contents
                width: parent.width - R.dp(124)
                font.pointSize: R.pt(45)
                anchors
                {
                    horizontalCenter: parent.horizontalCenter
                    top: image.bottom
                    topMargin: R.dp(20)
                }
            }
        }
    }

    function apply()
    {
        wk.setApplyEvent(mainView.prizeNo, "", "");
        wk.request();
    }

    function spread()
    {
        if(hAppliedImage === 0)
            hAppliedImage = appliedImage.height;

        if(hAppliedText === 0)
            hAppliedText = appliedText.height;

        if(hLineTop === 0)
            hLineTop = lineTop.height;

        if(appliedImage.height > 0) appliedImage.height = 0;
        else appliedImage.height = hAppliedImage;

        if(appliedText.height > 0) appliedText.height = 0;
        else appliedText.height = hAppliedText;


        if(lineTop.height > 0) {
            lineTop.height = 0;
            lineTop.visible = false;
        }
        else {

            if(md.noticeDetail.appliedText !== "" || md.noticeDetail.appliedImageUrl !== "")
            {
                lineTop.visible = true;
                lineTop.height = hLineTop;
            }
        }
    }

    property int hLineTop: 0
    property int hAppliedImage: 0;
    property int hAppliedText: 0;

}
