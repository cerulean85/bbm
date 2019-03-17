import QtQuick 2.9
import "Resources.js" as R

Rectangle
{
    width: R.dp(250)
    height: R.dp(250)
    color: "transparent"

    property string sourceImage : R.image("sns_kakao")
    property string name : "카카오톡"
    signal evtClicked();

    CPImage
    {
        id: snsImg
        width: R.dp(180)
        height: R.dp(180)
        source: sourceImage
        anchors
        {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: R.dp(10)
        }
    }

    CPText
    {
        width: parent.width
        height: R.dp(50)
        text: name
//        color: R.color_bgColor002
        font.pointSize: R.pt(50)
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors
        {
            top: snsImg.bottom
            topMargin: R.dp(10)
        }
    }

    Rectangle
    {
        width: parent.width
        height: parent.height
        color: "transparent"

        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
//                colorAnimator22.running = true;
                if(opt.ds) return;
                evtClicked();
            }
        }

        ColorAnimation on color {
            id: colorAnimator22
            from: "#aa000000"
            to: "transparent"
            running: false
            duration: 100
        }
    }

}
