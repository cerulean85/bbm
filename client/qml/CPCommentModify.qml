import QtQuick 2.9
import "Resources.js" as R
import QtQuick.Controls 2.2
import enums 1.0

Rectangle
{
    property string targetTxt: ""
    property int boardNo: 0
    property int boardArticleNo: 0
    property alias commentStr: commentField.text
    property int eventType: ENums.UPDATE
    property int currentIndex: 0
    signal close();

    id: modifyRect

    width: R.dp(1242)
    height: R.dp(2208)
    color: "#aa000000"
    opacity: opt.ds ? 1 : 0
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
        height: titleRect.height + txtRect.height + confirmRect.height
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
            width: txtRect.width
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
                text:
                {
                    switch(eventType)
                    {
                    case ENums.UPDATE: return "댓글 수정하기";
                    case ENums.SHOW_ALL: return "전문보기";
                    case ENums.REPORT: return "신고하기";
                    }
                    return "제목";
                }

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
                    duration: 100
                }

                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        R.hideKeyboard();

                        commentField.placeholderText = "내용을 입력해 주세요.";
                        commentInputAnimator.running = true

                        if(opt.ds) return;

                        if(eventType === ENums.UPDATE ) /* 댓글수정 */
                        {
                            md.repleList[currentIndex].setContents(commentField.text);
                            wk.updateClip(boardArticleNo, boardNo, commentField.text, 0, "", "", "");
                            wk.request();
                            hide();
                        }
                        else if(eventType === ENums.REPORT) /* 댓글신고 */
                        {
                            ap.setVisible(true);
                            ap.setMessage("계속 진행하시겠습니까?");
                            ap.setYButtonName("예");
                            ap.setNButtonName("아니오");
                            ap.setButtonCount(2);
                            ap.setYMethod(modifyRect, "report");
                            ap.setNMethod(modifyRect, "empty");
                        }
                    }
                }
            }

        }

        Rectangle
        {
            id: txtRect
            width: parent.width - R.dp(140)
            height: R.dp(800)
            anchors
            {
                top: titleRect.bottom
                horizontalCenter: parent.horizontalCenter
            }

            ScrollView
            {
                id: scv
                width: parent.width
                height: parent.height
                clip: true

                TextArea {
                    id: commentField
                    placeholderText: {
                        if(eventType === ENums.REPORT) return "신고 사유를 입력해주세요.";
                        else return "내용을 입력해 주세요."
                    }
                    text: eventType === ENums.REPORT ? "" : targetTxt
                    readOnly: eventType === ENums.SHOW_ALL
                    font.pointSize: R.pt(50)
                    wrapMode: TextEdit.Wrap
                    width: scv.width
                    height: scv.height * 10
                    font.family: fontLoader.name
                    padding: R.dp(30)
                }

                FontLoader {
                    id: fontLoader
                    source:R.system_font;
                }
            }
        }
    }

    Timer
    {
        running: opt.ds ? false : wk.setClipRepleReportResult === ENums.POSITIVE
        repeat: false
        interval: 100
        onTriggered:
        {
            wk.volSetClipRepleReportResult();
            commentField.text = "";
            alarm(R.message_enrolled_alarm);
            hide();
        }
    }

    PropertyAnimation
    {
        id: modifyRectUp;
        target: modifyRect
        property: "opacity";
        to: 1
        duration: 300
    }

    PropertyAnimation
    {
        id: modifyRectDown
        target: modifyRect
        property: "opacity"
        to: 0
        duration: 300
    }

    function show()
    {
        modifyRect.enabled = true;
        modifyRectUp.running = true;
    }

    function hide()
    {
        modifyRect.enabled = false;
        modifyRectDown.running = true;
    }

    function textClear()
    {
        commentField.text = "";
    }

    function alarm(message)
    {
        ap.setVisible(true);
        ap.setMessage(message);
        ap.setYButtonName("확인");
        ap.setButtonCount(1);
        ap.setYMethod(modifyRect, "empty");
    }

    function report()
    {
        wk.setClipRepleReport(boardArticleNo, boardNo, commentField.text);
        wk.request();
    }

    function empty(){ }
}
