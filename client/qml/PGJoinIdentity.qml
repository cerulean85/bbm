import QtQuick 2.9
import QtQuick.Controls 2.2
import "Resources.js" as R
import enums 1.0

PGPage {

    id: mainView
    visibleSearchBtn: false
    titleText: "회원가입"
    titleTextColor: "black"
    titleLineColor: "black"
    titleBgColor: "transparent"
    visibleBackBtn: true
    pageName: "JoinIdentity"

    useDefaultEvtBack: false
    onEvtBack:
    {
        offTimer();
        popUserStack();
    }

    Timer
    {
        running: opt.ds ? false : (md.requestNativeBackBehavior === ENums.REQUESTED_BEHAVIOR && compareCurrentPage(pageName))
        repeat: false
        interval: 100
        onTriggered:
        {
            md.setRequestNativeBackBehavior(ENums.WAIT_BEHAVIOR);
            if(!hideAlarm()) evtBack();
        }
    }

    Component.onCompleted:
    {
        if(opt.ds) return;
        md.setLeftTime("02:30");
    }

    property bool enabledNext: false

    Rectangle
    {
        width: parent.width
        height: parent.height - mainView.heightStatusBar - mainView.heightBottomArea - R.height_titleBar
        color: "white"
        y: mainView.heightStatusBar + R.height_titleBar

        Column
        {
            width: parent.width
            height: parent.height

            Rectangle
            {
                width: parent.width
                height: R.dp(377)

                CPJoinMarker
                {
                    id: joinMaker
                    currentStage: 2
                    anchors { verticalCenter: parent.verticalCenter }
                }
            }
            LYMargin { width: parent.width; height: R.dp(19); color: R.color_gray001 }
            LYMargin { width: parent.width; height: R.dp(63); }

            Rectangle
            {
                width: parent.width
                height: R.dp(100)
                anchors
                {
                    left: parent.left
                    leftMargin: R.dp(63)
                }

                CPText
                {
                    text: "휴대폰 번호를 입력해 주세요. (-제외 숫자만 입력)"
                    color: R.color_bgColor001
                    font.pointSize: R.pt(35)
                }
            }
            LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_bgColor001 }

            Rectangle
            {
                width: parent.width - R.dp(53)
                height: R.dp(182)
                anchors
                {
                    left: parent.left
                    leftMargin: R.dp(53)
                }
                CPTextField
                {
                    id: phoneNums
                    width: parent.width - R.dp(300) - R.dp(53) //R.dp(500)
                    height: R.dp(150)
                    placeholderText: "휴대폰 번호 입력"
                    font.pointSize: R.font_size_common_style_login
                    inputMethodHints: Qt.ImhDigitsOnly
                    maximumLength: 11
                    anchors
                    {
                        bottom: parent.bottom
                        bottomMargin: R.dp(0)
                    }
                }

                CPTextButton
                {
                    name: "인증번호 요청"
                    width: R.dp(300)
                    pointSize: R.font_size_common_style_login
                    onClick:
                    {
                        if(phoneNums.text === "")
                        {
                            alarm("휴대폰 번호를 입력해주세요.");
                            return;
                        }

                        if(cmd.checkPhone(phoneNums.text) === ENums.ALL_RIGHT)
                        {
                            onTimer();
                            md.setShowIndicator(true);
                            wk.certificate(phoneNums.text);
                            wk.request();
                        }
                        else
                        {
                            alarm("잘못된 번호를 입력하였습니다.");
                        }
                    }

                    anchors
                    {
                        right: parent.right
                        rightMargin: R.dp(53)
                        verticalCenter: parent.verticalCenter
                    }
                }
            }

            LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_bgColor001 }
            LYMargin { width: parent.width; height: R.dp(50) }

            Rectangle
            {
                width: parent.width - R.dp(126)
                height: R.dp(100)
                anchors
                {
                    left: parent.left
                    leftMargin: R.dp(63)
                }

                CPTextField
                {
                    id: certificatedNums
                    anchors
                    {
                        left: parent.left
                        bottom: parent.bottom
                    }
                    width: parent.width * 0.5
                    height: parent.height
                    enabled: false
                    placeholderText: "인증번호를 입력해 주세요."
                    inputMethodHints: Qt.ImhDigitsOnly
                    font.pointSize: R.pt(40)
                    maximumLength: 6
                    color: "black"
                }

                LYMargin
                {
                    height: parent.height;
                    color: R.color_bgColor001
                    anchors
                    {
                        right: parent.right
                        rightMargin: R.dp(350)
                    }
                }
                CPText
                {
                    width: R.dp(300)
                    height: parent.height
                    anchors
                    {
                        right: parent.right
                    }
                    color: R.color_gray88
                    text: "남은 시간 " + (opt.ds ? "00:00" : md.leftTime)
                    font.pointSize: R.pt(40)
                    verticalAlignment: Text.AlignVCenter
                }

                Timer
                {
                    id: timeCounter
                    running: opt.ds ? false : md.runningTimeCounter
                    repeat: true
                    interval: 1000
                    onTriggered:
                    {

                        if(cmd.getLeftTime() < 0)
                        {
                            offTimer();
                            alarm("제한 시간이 지났습니다. \n인증번호를 다시 요청해주세요.");

                            certificatedNums.text = "";
                            certificatedNums.enabled = false;
                        }
                    }
                }
            }
            LYMargin { width: parent.width; height: R.dp(10) }
            LYMargin
            {
                width: parent.width - R.dp(126);
                height: R.height_line_1px;
                color: R.color_bgColor001
                anchors
                {
                    left: parent.left
                    leftMargin: R.dp(63)
                }
            }

            LYMargin { width: parent.width; height: R.dp(52) }

            CPTextButton
            {
                name: "인증하기"
                pointSize: R.pt(45)
                visible: opt.ds ? true : wk.certificatedResult !== ENums.POSITIVE
                enabled: opt.ds ? false : certificatedNums.text.length == 6
                onClick:
                {
                    if(opt.ds) return;

                    wk.checkCertificationSMS(phoneNums.text, certificatedNums.text);
                    wk.request();

                    md.setShowIndicator(true);
                }

                color: opt.ds ? R.color_grayE1 : ( certificatedNums.text.length == 6 ?  R.color_bgColor001 : R.color_grayE1 )
                subColor: opt.ds ? R.color_bgColor003 : ( certificatedNums.text.length == 6 ?  R.color_bgColor002 : R.color_bgColor003 )
            }

            CPTextButton
            {
                name: "다음"
                pointSize: R.pt(45)
                visible: opt.ds ? true : enabledNext//wk.certificatedResult == ENums.POSITIVE
                onClick:
                {
                    next();
                }

                color: opt.ds ? R.color_grayE1 : R.color_bgColor001
                subColor: opt.ds ? R.color_bgColor003 : R.color_bgColor002
            }
        }

        Timer
        {
            running: opt.ds ? false : wk.certificatedResult !== ENums.WAIT
            repeat: false
            onTriggered:
            {
                md.setShowIndicator(false);
                var type = wk.volCertificatedResult();
                switch(type)
                {
                case ENums.POSITIVE:
                    alarm("정상적으로 처리되었습니다.");
                    ap.setYMethod(mainView, "next");
                    enabledNext = true;
                    break;
                }
            }
        }

        Timer
        {
            running: opt.ds ? false : wk.sentPhoneResult !== ENums.WAIT
            repeat: false
            onTriggered:
            {
                if(wk.vSentPhoneResult() === ENums.POSITIVE)
                {
                    alarm("인증번호가 발송되었습니다. \n제한시간 이내에 입력해주세요.");
                    certificatedNums.text = "";
                    certificatedNums.enabled = true;
                }
            }
        }
    }

    function next()
    {
        offTimer();
        if(settings.snsType === ENums.SELF) pushUserStack("JoinSetInfo");
        else pushUserStack("JoinSetInfoSNS");
    }

    function onTimer()
    {
//        cmd.execTimer(true);
        md.setRunningTimeCounter(true);
    }

    function offTimer()
    {
//        cmd.execTimer(false);
        md.setRunningTimeCounter(false);
    }
}
