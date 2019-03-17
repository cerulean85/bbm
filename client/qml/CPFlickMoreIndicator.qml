import QtQuick 2.9
import "Resources.js" as R
import enums 1.0

Rectangle
{
    id: refreshIndicatorView
    visible: refreshIndicator.running
    enabled: refreshIndicator.running
    z: 8000
    color: "transparent"

    property int condRun: ENums.WORKING_MAIN
    property int condStop: ENums.FINISHED_MAIN

    Rectangle
    {
        width: R.dp(200)
        height: R.dp(200)
        color: "transparent"

        anchors
        {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: -refreshIndicatorView.height * 0.5
        }

        CPBusyIndicator
        {
            id: refreshIndicator
            width: parent.width
            bLength: 22
            height: parent.height
            running: opt.ds ? true : (wk.refreshWorkResult === condRun)
        }

        Timer
        {
            running: opt.ds ? false : (wk.refreshWorkResult === condStop)
            interval: R.timer_interval_net
            onTriggered: wk.vRefreshWorkResult();
        }
    }
}
