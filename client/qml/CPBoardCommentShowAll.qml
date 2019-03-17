import QtQuick 2.9
import "Resources.js" as R
import QtQuick.Controls 2.2
import enums 1.0

Rectangle
{
    property string targetTxt: ""
    property int currentIndex: 0
    signal close();

    id: mainView

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
                text: "전문보기"

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
                        hide();
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
                    text: targetTxt
                    readOnly: true
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
        id: mainViewUp;
        target: mainView
        property: "opacity";
        to: 1
        duration: 300
    }

    PropertyAnimation
    {
        id: mainViewDown
        target: mainView
        property: "opacity"
        to: 0
        duration: 300
    }

    function show()
    {
        mainView.enabled = true;
        mainViewUp.running = true;
    }

    function hide()
    {
        mainView.enabled = false;
        mainViewDown.running = true;
    }
}
