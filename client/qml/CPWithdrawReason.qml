import QtQuick 2.9
import QtQuick.Controls 2.2
import "Resources.js" as R
//import QtQuick.Controls 1.4
import enums 1.0

Rectangle
{
    property int repleNo: 0
    property int currentIndex: 0
    property alias reason: articleArea.txt
    signal close();
    signal evtWithdraw();

    id: reasonRect

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
        height: titleRect.height + articleArea.height + confirmRect.height
        anchors
        {
            horizontalCenter: parent.horizontalCenter
            //            verticalCenter: parent.verticalCenter
            bottom: basePos.bottom
            bottomMargin: R.dp(-300)
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
                text: "회원탈퇴 사유";
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

                        commentInputAnimator.running = true

                        if(opt.ds) return;

                        if(articleArea.txt === "")
                        {
                            alarm("내용을 입력해주세요.");
                            return;
                        }

                        R.log("articleArea.text > " + articleArea.txt);

                        evtWithdraw();

//                        hide();
                    }
                }

                Timer
                {
                    running: opt.ds ? false : wk.updateCourseBoardArticleRepleResult === ENums.POSITIVE
                    repeat: false
                    interval: 300
                    onTriggered:
                    {
                        wk.setSetUserProfileReportResult(ENums.WAIT);
                        hide();
                    }
                }
            }
        }

        CPTextAreaToModifyArticle
        {
            id: articleArea
            width: parent.width - R.dp(140)
            holderText: "탈퇴 사유를 입력해주세요."
            anchors
            {
                top: titleRect.bottom
                left: titleRect.left
            }
        }
    }

    PropertyAnimation
    {
        id: reasonWindowUp;
        target: reasonRect
        property: "opacity";
        to: 1
        duration: 300
    }

    PropertyAnimation
    {
        id: reasonWindowDown
        target: reasonRect
        property: "opacity"
        to: 0
        duration: 300
    }

    function show()
    {
        reasonRect.enabled = true;
        reasonWindowUp.running = true;
        articleArea.setText("");
    }

    function hide()
    {
        reasonRect.enabled = false;
        reasonWindowDown.running = true;
        textClear();
    }

    function textClear()
    {
        articleArea.setText("");
    }

}
