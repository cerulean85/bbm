import QtQuick 2.9
import "Resources.js" as R
import enums 1.0
import QtQuick.Controls 2.2


Rectangle
{
    property string targetTxt: ""
    property int boardNo: 0
    property int boardArticleNo: 0
    property int repleNo: 0
    property alias commentStr: articleArea.txt
    property int reportType: 0 /* 0: article, 1: comment */
    property int currentIndex: 0
    signal close();

    id: reportRect

    width: R.dp(1242)
    height: R.dp(2208)
    color: "#aa000000"
    opacity: 0
    enabled: false

    MouseArea
    {
        anchors.fill: parent
        onClicked:
        {
            hide();
        }
    }

    Item
    {
        id: basePos
        width: 1
        height: 1
        anchors
        {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
    }
    Item
    {
        id: editor
        width: parent.width
        height: titleRect.height + articleArea.height + confirmRect.height
        anchors
        {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
            //            bottom: basePos.bottom
            //            bottomMargin: R.dp(-300)
        }

        Rectangle
        {
            id: titleRect
            width: articleArea.width
            height: R.dp(160)
            color: R.color_bgColor001
            anchors
            {
                horizontalCenter: parent.horizontalCenter
            }

            MouseArea
            {
                anchors.fill: parent
            }

            CPText
            {
                width: parent.width
                height: parent.height
                font.pointSize: R.pt(60)
                text: "신고하기";
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: "white"
            }

            Rectangle
            {
                height: parent.height
                width: parent.height
                color: "transparent"
                CPImage
                {
                    width: R.dp(130)
                    height: R.dp(130)
                    source: R.image(R.btn_close_gray_image)
                    anchors
                    {
                        verticalCenter: parent.verticalCenter
                        horizontalCenter: parent.horizontalCenter
                    }
                }
                anchors
                {
                    left: parent.left
                }

                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        colorAnimator11.running = true;
                        hide();
                    }
                }

                ColorAnimation on color {
                    id: colorAnimator11
                    from: R.color_bgColor001
                    to: "transparent"
                    running: false
                    duration: 100
                }
            }

            Rectangle
            {
                id: confirmRect
                width: parent.height + R.dp(50) //fontMetrics.height * txt.lineCount + R.dp(30)
                height: parent.height
                color: "transparent"


                anchors
                {
                    right: parent.right
                }

                CPText
                {
                    id: txt
                    font.pointSize: R.pt(60)
                    width: parent.width + R.dp(20)
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: "확인"
                    color: "white"
                }

                //                FontMetrics {
                //                    id: fontMetrics
                //                    font.pointSize: R.pt(50)
                //                }

                ColorAnimation on color {
                    id: commentInputAnimator
                    from: R.color_bgColor001
                    to: "transparent"
                    running: false
                    duration: 300
                }

                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        R.hideKeyboard();
                        commentInputAnimator.running = true;

                        if(articleArea.txt === "")
                        {
                            alarm("신고 사유를 입력하세요.");
                        }
                        else
                        {
                            ap.setVisible(true);
                            ap.setMessage("계속 진행하시겠습니까?");
                            ap.setYButtonName("예");
                            ap.setNButtonName("아니오");
                            ap.setButtonCount(2);
                            ap.setYMethod(reportRect, "report");
                            ap.setNMethod(reportRect, "empty");
                        }
                    }
                }
            }
        }

        CPTextAreaToModifyArticle
        {
            id: articleArea
            width: parent.width - R.dp(140)
            holderText: "신고 사유를 입력해주세요."
            anchors
            {
                top: titleRect.bottom
                left: titleRect.left
            }
        }
    }

    PropertyAnimation
    {
        id: reportRectUp;
        target: reportRect
        property: "opacity";
        to: 1
        duration: 300
    }

    PropertyAnimation
    {
        id: reportRectDown
        target: reportRect
        property: "opacity"
        to: 0
        duration: 300
    }

    function show()
    {
        reportRect.enabled = true;
        reportRectUp.running = true;
        articleArea.setText(targetTxt);
    }

    function hide()
    {
        reportRect.enabled = false;
        reportRectDown.running = true;
        textClear();
    }

    function textClear()
    {
        targetTxt = "";
        articleArea.setText(targetTxt);
    }

    Timer
    {
        running: opt.ds ? false : (wk.setBoardReportResult === ENums.POSITIVE)
        repeat: false
        interval: 300
        onTriggered:
        {
            wk.volSetBoardReportResult();
            alarm(R.message_enrolled_alarm);
            hide();
        }
    }

    function alarm(message)
    {
        ap.setVisible(true);
        ap.setMessage(message);
        ap.setYButtonName("확인");
        ap.setButtonCount(1);
        ap.setYMethod(reportRect, "empty");
    }

    function report()
    {
        wk.setBoardReport(boardNo, boardArticleNo, repleNo, reportType, articleArea.txt);
        wk.request();
    }

    function empty(){ }
}
