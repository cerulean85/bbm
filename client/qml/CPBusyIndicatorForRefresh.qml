import QtQuick 2.11
import "Resources.js" as R
import enums 1.0

Rectangle
{
    id: mainView

    property bool rRunning: false
    visible: rRunning
    enabled: rRunning
    z: 8000

    Rectangle
    {
        width: R.dp(200)
        height: R.dp(200)
        color: "transparent"

        CPBusyIndicator
        {
            id: refreshIndicator
            width: parent.width
            bLength: 22
            height: parent.height
            running: rRunning
        }
        anchors
        {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: -mainView.height * 0.5
        }
    }
}
