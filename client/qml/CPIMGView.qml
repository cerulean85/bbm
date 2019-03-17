import QtQuick 2.9
import "Resources.js" as R

Rectangle
{
    id: mainView
    width: R.dp(1242)
    height: R.dp(2208)
    color: "#aa000000"
    enabled: false
    opacity: opt.ds ? 1 : 0
    signal evtExit();

    property string source :
    opt.ds ?
    "https://scontent-sjc3-1.cdninstagram.com/vp/eaf56aa30148a578e29d34631cb84968/5BB12F51/t51.2885-15/e35/26156236_123939068416546_2742507055683207168_n.jpg" :
    settings.thumbnailImage

    MouseArea
    {
        anchors.fill: parent
    }

    CPImage
    {
        width: parent.width
        height: parent.height - (closeRect.height * 2)
        source: mainView.source
        anchors
        {
            top: closeRect.bottom
        }
    }

    Rectangle
    {
        id: closeRect
        width: R.dp(200)
        height: R.dp(200)
        color: "transparent"
        anchors
        {
            right: parent.right
            top: parent.top
        }

        CPImage
        {
            width: R.dp(130)
            height: R.dp(130)
            source: R.image(R.btn_close_white_image)
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

            ColorAnimation on color {
                id: colorAnimator
                from: R.color_gray87
                to: "transparent"
                running: false
                duration: 100
            }
            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    colorAnimator.running = true;
                    hide();
                }
            }
        }
    }

    OpacityAnimator
    {
        id: offAnim
        target: mainView;
        from: 1;
        to: 0;
    }

    OpacityAnimator
    {
        id: onAnim
        target: mainView;
        from: 0;
        to: 1;
        duration: 500
    }

    function show()
    {
        if(mainView.source === "") return;
        onAnim.running = true;
        enabled = true;
    }

    function hide()
    {
        offAnim.running = true;
        enabled = false;
    }
}
