import QtQuick 2.11
import QtQuick.Controls 1.4
import QtQuick.Controls 2.4
import "Resources.js" as R
import enums 1.0

PGPage {

    id: mainView
    visibleSearchBtn: false
    titleText: "문의하기"
    titleTextColor: "black"
    titleLineColor: "black"
    visibleBackBtn: true

    property int itemHeight: R.dp(180)
    property int noCourse: opt.ds ? 0 : md.currentCourseNo
    pageName: "ContactUs"
    color: "white"

    CPTextButtonTrans
    {
        color: "white"
        width: R.height_titleBar + R.dp(100)
        height: R.height_titleBar - R.height_line_1px
        anchors
        {
            top: parent.top
            topMargin: opt.ds ? 0 : settings.heightStatusBar
            right: parent.right
        }

        subColor: "#44000000"
        btnName: "완료"
        pointSize: R.pt(50)
        onClick:
        {
            if(opt.ds) return
            alarm2( "글 작성을 완료하시겠습니까?");
            ap.setYMethod(mainView, "contact");
        }
    }

    function contact()
    {
        var title = titleText.text;
        if(title === "")
        {
            alarm("제목을 입력하세요.");
            return;
        }

        var contents = textArea.txt;
        if(contents === "" )
        {
            alarm("내용을 입력하세요.");
            return;
        }

        wk.setContactUS( "[이버봄 문의] " + titleText.text, "문의자 메일: " + settings.email + "\n\n" + textArea.txt);
        wk.request();
     }

    Timer
    {
        repeat: false
        interval: 200
        running: opt.ds ? false : wk.setContactUSResult !== ENums.WAIT
        onTriggered:
        {
            wk.vSetContactUSResult();
            alarm("문의가 정상적으로 접수되었습니다.");
            ap.setYMethod(mainView, "popHomeStack");
        }
    }

    Flickable
    {
        width: parent.width
        height: parent.height + (opt.ds ? 0 : - settings.heightStatusBar - R.height_titleBar)
        contentWidth : parent.width
        contentHeight: topArea.height + R.dp(300)
        clip: true

        boundsBehavior: Flickable.StopAtBounds
        y: opt.ds ? R.height_titleBar : (settings.heightStatusBar + R.height_titleBar)

        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                R.hideKeyboard();
            }
        }

        Column
        {
            id: topArea
            width: parent.width


            LYMargin { height: R.dp(80); }
            Item
            {
                width: parent.width
                height: R.dp(52)

                CPTextField
                {
                    id: titleText
                    width: parent.width - R.dp(124)
                    height: parent.height + R.dp(80)
                    placeholderText: "제목을 입력하세요."
                    text: ""
                    font.pointSize: R.pt(50)
                    anchors
                    {
                        horizontalCenter: parent.horizontalCenter
                    }
                }
            }

            LYMargin { height: R.dp(60) }
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

            LYMargin { height: R.dp(50) }

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
            LYMargin { height: R.dp(30) }

            CPTextArea
            {
                id: textArea
                width: parent.width - R.dp(30) * 2
                height: R.dp(500)
                anchors
                {
                    left: parent.left
                    leftMargin: R.dp(30)
                }
            }

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
            if(!hideAlarm()) evtBack();
        }
    }
}
