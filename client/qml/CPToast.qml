import QtQuick 2.7
import "Resources.js" as R
Rectangle
{

    id: toast
    property string message: opt.ds ? "samplesssamplesssamplesssamplesssamplesssamplesssamplesssampless" : ""
    property int minContentWidth: R.design_size_width * 0.6
    property int midContentWidth: R.design_size_width * 0.7

    width: toastMsg.width * 1.2
    height: toastMsg.contentHeight + R.dp(100)
    color: R.color_toast
    radius: 100
    opacity: 0

    CPText
    {
        id: toastMsg
        text: message
        color: "white"
        font.pointSize: R.pt(18)

        width: midContentWidth

        horizontalAlignment: lineCount == 1 ? Text.AlignHCenter : Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        anchors
        {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
    }

    Component.onCompleted:
    {
        if(toastMsg.contentWidth < minContentWidth)
            toastMsg.width = minContentWidth
    }



    OpacityAnimator {
        id: toastFadeoutAnimator
        target: toast;
        from: 1;
        to: 0;
        duration:500
        running: false
    }

    Timer
    {
        id: toastFadeoutTimer
        interval:1500
        repeat: false
        onTriggered:{
            toastFadeoutAnimator.running = true;
        }
    }


    function show(msg)
    {
        toast.message = msg;
        toastFadeoutAnimator.running = true;
        toastFadeoutTimer.start();
    }
}
