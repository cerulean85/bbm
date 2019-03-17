import QtQuick 2.9
import "Resources.js" as R

Rectangle
{
    property int txtWidth: R.dp(160)
    property string txtColor: "black"
    property string buttonName : ""
    property string imageSource : ""
    property string foregroundColor : "white"
    property string backgroundColor : R.color_bgColor003
    property bool selected : false
    property bool needLogin : true

    width: txtWidth + R.dp(60) + R.dp(30)
    height: parent.height

    signal evtClicked();
    Row
    {
        width: parent.width
        height: parent.height

        LYMargin { width: R.dp(10) }
        CPText
        {
            id: buttonText
            text: buttonName
            font.pointSize: R.pt(45)
            width: txtWidth
            height: parent.height
            color: txtColor
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
        Item
        {
            id: buttonImage
            width: R.dp(60)
            height: parent.height

            CPImage
            {
                width: parent.width
                height: R.dp(60)
                source: imageSource
                anchors
                {
                    verticalCenter: parent.verticalCenter
                }
            }
        }
        LYMargin { width: R.dp(20) }
    }

    MouseArea
    {
        anchors.fill: parent
        onClicked:
        {
//            selected = !selected;
            colorAnimator.running = true;
            if(opt.ds) {
                evtClicked();
                return;
            }

            evtClicked();
        }
    }

    ColorAnimation on color {
        id: colorAnimator
        from: backgroundColor
        to: foregroundColor
        running: false
        duration: 100
    }
}
