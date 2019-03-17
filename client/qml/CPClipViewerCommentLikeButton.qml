import QtQuick 2.9
import "Resources.js" as R

Rectangle
{
    property bool selected: false
    property int likeCount: 202
    signal evtClicked();
    color: "transparent"

    width: R.dp(200)
    height: R.dp(150)



    CPImage
    {
        id: img
        width: R.dp(60)
        height: R.dp(60)
        source: selected ? R.image("mypage_like_pink") : R.image("mypage_like")
        anchors
        {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: R.dp(20)
        }
    }

    CPText
    {
        id: txt
        text: likeCount
        height: R.dp(40)
        font.pointSize: R.pt(40)
        verticalAlignment: Text.AlignVCenter
        anchors
        {
            top: img.bottom
            topMargin: R.dp(10)
            horizontalCenter: parent.horizontalCenter
        }
    }


    ColorAnimation on color {
        id: colorAnimator
        from: R.color_bgColor003
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
            if(opt.ds) return;
            evtClicked();
        }
    }
}
