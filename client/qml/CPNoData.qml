import QtQuick 2.9
import "Resources.js" as R

Rectangle
{
    id: noDataRect
    width: R.dp(1242)
    height: R.dp(2208)

    signal evtClicked()

    property int tMargin : 0
    property bool showText: false
    property string message: R.message_no_data
    //        color: R.color_gray001

    Item
    {
        id: centerPoint
        width: 1
        height: 1
        anchors
        {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
    }

    CPImage
    {
        width: R.dp(300)
        height: R.dp(300)
        visible: !showText
        fillMode: Image.PreserveAspectFit
        source: !showText ? R.image("no_page") : ""
        anchors
        {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
    }

    CPImage
    {
        width: R.dp(300)
        height: R.dp(300)
        visible: showText
        fillMode: Image.PreserveAspectFit
        source: showText ? R.image("no_page") : ""
        anchors
        {
            bottom: centerPoint.bottom
            bottomMargin: R.dp(50) - tMargin
            horizontalCenter: parent.horizontalCenter
        }
    }

    CPText
    {
        text: message
        font.pointSize: R.pt(45)
        color: "black"
        visible: showText
        anchors
        {
            top: centerPoint.top
            topMargin: tMargin
            horizontalCenter: parent.horizontalCenter
        }
    }

    MouseArea
    {
        anchors.fill: parent
        onClicked:
        {
            if(opt.ds) return;

//            if(!cmd.isOnline())
//            {
//                ap.setVisible(true);
//                ap.setMessage("네트워크가 연결되어 있지 않습니다. 네트워크 상태를 확인해주세요.");
//                ap.setButtonCount(2);
//                ap.setYMethod(appWindow, "yes");
//                ap.setNMethod(appWindow, "no");
//                ap.setYButtonName("예");
//                ap.setNButtonName("아니오");
//                return;
//            }

            evtClicked();
            wk.request();

        }
    }
}
