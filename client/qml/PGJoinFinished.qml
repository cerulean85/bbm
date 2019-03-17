import QtQuick 2.9
import QtQuick.Controls 2.2
import "Resources.js" as R
import enums 1.0

PGPage
{
    id: mainView
    visibleSearchBtn: false
    titleText: "회원가입"
    titleTextColor: "black"
    titleLineColor: "black"
    visibleBackBtn: false

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
                    currentStage: 4
                    anchors { verticalCenter: parent.verticalCenter }
                }
            }
            LYMargin { width: parent.width; height: R.dp(19); color: R.color_gray001 }

            LYMargin { width: parent.width; height: R.dp(200); }
            LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_bgColor001 }

            Rectangle
            {
                width: parent.width
                height: R.dp(371)
                CPText
                {
                    width: parent.width
                    height: R.dp(200)
                    text: "가입이 완료되었습니다!"
                    font.pointSize: R.pt(63)
                    color: R.color_bgColor001
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    anchors
                    {
                        verticalCenter: parent.verticalCenter
                        horizontalCenter: parent.horizontalCenter
                    }
                }
            }
            LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_bgColor001 }
            LYMargin { width: parent.width; height: R.dp(38) }

            CPTextButton
            {
                id: btnGoHome
                name: "홈으로 가기"
                pointSize: R.pt(45)
                onClick:
                {
                    if(opt.ds) return;

                    wk.login();
                    wk.request();

                    clearStack();
                }
            }

//            Timer
//            {
//                running: opt.ds ? false :   wk.loginResult !== ENums.WAIT
//                repeat: false
//                onTriggered:
//                {
//                    md.setShowIndicator(false);
//                    switch(wk.vLoginResult())
//                    {
//                    case ENums.NAGATIVE:
//                    case ENums.NOT_OPENED:
//                        alarm(settings.errorMessage);
//                        ap.setYMethod(mainView, "clearStack");
//                        break;
//                    case ENums.POSITIVE:
//                        clearStack();
//                        break;

//                    }
//                }
//            }

            OpacityAnimator {
                id:fadeoutAnimator
                target: mainView;
                from: 1;
                to: 0;
                duration: 300
                running: false
            }
        }
    }


    onHandleLoginResult:
    {
        md.setShowIndicator(false);
        switch(wk.vLoginResult())
        {
        case ENums.NAGATIVE:
        case ENums.NOT_OPENED:
            alarm(settings.errorMessage);
            ap.setYMethod(mainView, "clearStack");
            break;
        case ENums.POSITIVE:
            clearStack();
            break;

        }
    }

    Timer
    {
        id: popInvoker
        running: false
        repeat: false
        interval: 300
        onTriggered:
        {
            clearUserStack();
        }
    }


    function clearStack()
    {
        fadeoutAnimator.running = true;
        popInvoker.running = true;
    }
}
