import QtQuick 2.9
import "Resources.js" as R

Rectangle
{
    id: shareRect

    width: R.dp(1242)
    height: R.dp(2208)

    color: "#aa000000"
    opacity: opt.ds ? 1 :0
    enabled: opt.ds ? true : false

    signal evtFunc();
    signal evtCmdKakao()
    signal evtCmdFacebook();

    MouseArea
    {
        anchors.fill: parent
        onClicked:
        {
            shareRect.enabled = false;
            shareRectDown.running = true;
            evtFunc();
        }
    }

    Rectangle
    {
        width: parent.width - R.dp(280)
        height: R.dp(500)
        anchors
        {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }

        Column
        {
            width: parent.width
            height: parent.height
            Rectangle
            {
                id: titleRect
                width: parent.width
                height: R.dp(150)
                color: R.color_bgColor001

                CPText
                {
                    width: parent.width
                    height: parent.height
                    font.pointSize: R.pt(45)
                    text: "SNS 공유하기"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: "white"
                }

                MouseArea
                {
                    anchors.fill: parent
                }

                Rectangle
                {
                    height: parent.height
                    width: parent.height
                    color: "transparent"
                    CPImage
                    {
                        width: R.dp(110)
                        height: R.dp(110)
                        source: R.image(R.btn_close_gray_image)
                        anchors
                        {
                            verticalCenter: parent.verticalCenter
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                    anchors
                    {
                        right: parent.right
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked:
                        {
                            colorAnimator11.running = true;
                            show(false);
                            evtFunc();
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
            }

            Rectangle
            {

                width: parent.width
                height: parent.height - titleRect.height

                Item
                {
                    id: basePos
                    width: 1; height: 1
                    anchors
                    {
                        verticalCenter: parent.verticalCenter
                        horizontalCenter: parent.horizontalCenter

                    }
                }

                CPSNSButton2
                {
                    sourceImage : R.image("sns_kakao")
                    name : "카카오톡"
                    anchors
                    {
                        verticalCenter: parent.verticalCenter
                        right: basePos.left
                        rightMargin: R.dp(80)
                    }
                    onEvtClicked:
                    {
                        show(false);
                        tmExecKakao.running = true;
                    }
                }

                CPSNSButton2
                {
                    sourceImage : R.image("sns_facebook")
                    name : "페이스북"
                    anchors
                    {
                        verticalCenter: parent.verticalCenter
                        left: basePos.right
                        leftMargin: R.dp(80)
                    }
                    onEvtClicked:
                    {
                        show(false);
                        tmExecFacebook.running = true;

                    }
                }
            }
        }
    }

    Timer
    {
        id: tmExecKakao
        running: false
        repeat: false
        interval: 500
        onTriggered: evtCmdKakao();
    }

    Timer
    {
        id: tmExecFacebook
        running: false
        repeat: false
        interval: 500
        onTriggered: evtCmdFacebook();
    }


    PropertyAnimation
    {
        id: shareRectUp;
        target: shareRect
        property: "opacity";
        to: 1
        duration: 300
    }

    PropertyAnimation
    {
        id: shareRectDown
        target: shareRect
        property: "opacity"
        to: 0
        duration: 300
    }

//    function show()
//    {
//        shareRect.enabled = true;
//        shareRectUp.running = true;
//    }

//    function hide()
//    {
//        shareRect.enabled = false;
//        shareRectDown.running = true;
//    }

    function show(visible)
    {
        if(visible)
        {
            shareRect.enabled = true;
            shareRectUp.running = true;
        }
        else
        {
            shareRectDown.running = true;
            shareRect.enabled = false;
        }
    }

    function showInst(visible)
    {
        if(visible)
        {
            shareRect.enabled = true;
            shareRectUp.running = true;
        }
        else
        {
            shareRect.opacity = 0;
            shareRect.enabled = false;
        }
    }

}
