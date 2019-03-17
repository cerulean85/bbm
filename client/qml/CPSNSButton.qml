import QtQuick 2.9
import "Resources.js" as R

Rectangle
{
    id: mainBox

    signal evtClicked();
    property string sourceImage : R.image("no_image")
    property string name : "페이스북으로 로그인"
    width: image.width + btnName.width + R.dp(60)
    height: R.dp(200)

    CPImage
    {
        id: image
        source: sourceImage
        width: R.dp(112)
        height: R.dp(112)
        anchors
        {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: R.dp(20)
        }
    }

    CPText
    {
        id: btnName
        height: parent.height
        text: name
        font.pointSize: R.font_size_common_style_login
        color: R.color_gray87
        verticalAlignment: Text.AlignVCenter
        anchors
        {
            left: image.right
            leftMargin: R.dp(20)
        }
    }

    MouseArea
    {
        anchors.fill: parent
        onClicked:
        {

//            colorAnimator.running = true;
            behavior.running = true;
        }
    }
    ColorAnimation on color {
        id: colorAnimator
        from: R.color_grayE1
        to: "white"
        running: false
        duration: 100
    }

    Timer
    {
        id: behavior
        running: false
        repeat: false
        interval: 200
        onTriggered:
        {
            R.hideKeyboard();

            if(opt.ds) return;
            evtClicked();
        }
    }
}
