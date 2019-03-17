import QtQuick 2.9
import "Resources.js" as R
import QtQuick.Controls 2.2
import enums 1.0

Rectangle
{
    property int targetUserNo: 0
    property alias commentStr: commentField.text

    id: mainVew

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
                text: "프로필 신고하기";

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
                    width: parent.width + R.dp(40)
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

                        if(targetUserNo == settings.noUser)
                        {
                            alarm("본인을 신고할 수 없습니다.");
                            return;
                        }

                        commentField.placeholderText = "신고 사유를 입력해주세요.";
                        commentInputAnimator.running = true

                        if(opt.ds) return;

                        if(commentField.text === "")
                        {
                            alarm("신고 사유를 입력해주세요.");
                            return;
                        }

                        wk.setUserProfileReport(targetUserNo, commentField.text);
                        wk.request();
                        hide();
                    }
                }
            }

        }

        Timer
        {
            running: opt.ds ? false : wk.setUserProfileReportResult != ENums.WAIT
            repeat: false
            interval: 100
            onTriggered:
            {
                commentField.text = "";
                var type = wk.volSetUserProfileReportResult()
                if(type == ENums.POSITIVE)
                {
                    alarm("신고가 접수되었습니다.");
                }
                else error();
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
                    placeholderText: "신고 사유를 입력해주세요.";
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
    PropertyAnimation
    {
        id: mainVewUp;
        target: mainVew
        property: "opacity";
        to: 1
        duration: 300
    }

    PropertyAnimation
    {
        id: mainVewDown
        target: mainVew
        property: "opacity"
        to: 0
        duration: 300
    }

    function show()
    {
        mainVew.enabled = true;
        mainVewUp.running = true;
    }

    function hide()
    {
        mainVew.enabled = false;
        mainVewDown.running = true;
    }

    function textClear()
    {
        commentField.text = "";
    }
}
