import QtQuick 2.9
import "Resources.js" as R
Rectangle
{
    width: parent.width
    height: R.dp(156)

    signal evtClicked();
    property string title: "Untitled"
    property string contents : "NoName"
    property bool hideGoButton : false

    Item
    {
        id: titleBox
        width: R.dp(300)
        height: parent.height
        CPText
        {

            height: parent.height
            color: R.color_bgColor001
            font.pointSize: R.font_size_common_style_login
            text: title
            verticalAlignment: Text.AlignVCenter
            anchors
            {
                left: parent.left
                leftMargin: R.dp(56)
            }
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
        font.pointSize: R.font_size_common_style_login
        height: parent.height
        text: contents
        color: R.color_gray87
        verticalAlignment: Text.AlignVCenter
        anchors
        {
            left: titleBox.right
        }
    }

    MouseArea
    {
        anchors.fill: parent
        onClicked:
        {
            colorAnimator.running = true;
            if(opt.ds) return;
            invoker.running = true;
        }
    }

    ColorAnimation on color {
        id: colorAnimator
        from: R.color_bgColor003
        to: "white"
        running: false
        duration: 300
    }

    Timer
    {
        id: invoker
        running: false
        repeat: false
        interval: 300
        onTriggered: evtClicked();
    }
}
