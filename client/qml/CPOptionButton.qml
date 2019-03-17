import QtQuick 2.9
import "Resources.js" as R
Rectangle
{
    width: parent.width
    height: R.dp(156)

    signal evtClicked();
    property string imageSource : R.image("setting_user")
    property string buttonName : "NoName"
    property bool hideGoButton : false

    CPImage
    {
        width: R.dp(85)
        height: R.dp(85)
        source: imageSource
        anchors
        {
            left: parent.left
            leftMargin: R.dp(56)
            verticalCenter: parent.verticalCenter
        }
    }

    CPImage
    {
        width: R.dp(28)
        height: R.dp(50)
        visible: !hideGoButton
        source: R.image("gray_go")
        anchors
        {
            right: parent.right
            rightMargin: R.dp(60)
            verticalCenter: parent.verticalCenter
        }
    }

    CPText
    {
        text:buttonName
        font.pointSize: R.pt(45)
        color: R.color_bgColor002
        height: parent.height
        verticalAlignment: Text.AlignVCenter
        anchors
        {
            left: parent.left
            leftMargin: R.dp(196)
        }
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

    ColorAnimation on color {
        id: colorAnimator
        from: R.color_bgColor003
        to: "white"
        running: false
        duration: 100
    }
}
