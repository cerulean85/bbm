import QtQuick 2.7
import "Resources.js" as R

Rectangle
{
    width: opt.ds ? R.dp(1242) : appWindow.width
    height: opt.ds ? R.dp(2208) : appWindow.height
    visible: true
    opacity: 1
    color: "white"

    Rectangle
    {
        width: parent.height
        height: parent.height
        color: R.color_bgColor003
        rotation:50
        x: -parent.height * 0.56
        y: parent.height * 0.42
    }

    Item
    {
        id: basePoint
        width: 1
        height: 1
        anchors
        {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
    }
    CPImage
    {
        width: R.dp(335)
        height: R.dp(433)
        source: R.image("information")
        anchors
        {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
    }

    CPText
    {
        id: msgInfo
        text: "업데이트 확인중..."
        font.pointSize: R.pt(30)
        visible: false
        anchors
        {
            bottom: parent.bottom
            bottomMargin: R.dp(105)
            horizontalCenter: parent.horizontalCenter
        }
    }

    CPText
    {
        id: versionTxt
        text: opt.ds ? "현재 1.1.1 ver" : "ver " + settings.versServer
        font.pointSize: R.pt(40)
        visible: false
        anchors
        {
            bottom: msgInfo.top
            bottomMargin: R.dp(10)
            horizontalCenter: parent.horizontalCenter
        }
    }
}
