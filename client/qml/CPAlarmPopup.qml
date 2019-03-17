import QtQuick 2.0
import QtQuick.Controls 1.4
import "Resources.js" as R
import enums 1.0
Rectangle
{
    id: rect
    signal evtYes()
    signal evtNo()

    property int buttonCount : opt.ds ? 2 : ap.buttonCount
    property string message : opt.ds ? "" : ap.message
    property string yButtonName: opt.ds ? "예" : ap.yButtonName
    property string nButtonName: opt.ds ? "아니오" : ap.nButtonName
    property bool visibled: opt.ds ? false : ap.visible

    width: R.design_size_width
    height: R.design_size_height
    color: "#aa000000"
    //    visible: opt.ds ? false : ap.visible
    opacity: 0
    enabled: visibled

    //    Timer
    //    {
    //        running: opt.ds ? true : md.checkedSystem == ENums.NAGATIVE
    //        repeat: false
    //        onTriggered:
    //        {
    //            visible = true;
    //        }
    //    }

    MouseArea
    {
        anchors.fill: parent
        //        onClicked:
        //        {
        //            rect.visible = false
        //        }
    }

    Rectangle
    {
        id: popup
        width: rect.width - R.dp(280)
        height: R.dp(500)
        color: "transparent"
        radius: 10

        anchors
        {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }

        Column
        {
            width: parent.width
            height: parent.height

            Rectangle
            {
                id: msgRect
                height: R.dp(340)
                width: parent.width
                border.width: R.dp(2)
                border.color: "#f5f6f6"
                color: "white"


                CPText
                {
                    id: txtArea
                    width: parent.width - R.dp(100)
                    anchors
                    {
                        verticalCenter: parent.verticalCenter
                        horizontalCenter: parent.horizontalCenter
                    }

                    text: opt.ds ? "메시지를 입력하세요." : message
                    color: "black"
                    horizontalAlignment : Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: R.pt(50)
                    lineHeight: 1.2
                }
            }

            Rectangle
            {
                id: btnRect
                width: parent.width
                height: R.dp(160)

                Row
                {
                    width: parent.width
                    height: R.dp(160)

                    Rectangle
                    {
                        id: btnYes
                        width: buttonCount > 1 ? parent.width * 0.5 : parent.width
                        height: parent.height
                        color: R.color_bgColor001

                        CPText
                        {
                            width: parent.width
                            height: parent.height
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            color: "white"
                            font.pointSize: R.pt(55)
                            text: opt.ds ? (buttonCount > 1 ? "예" : "확인") : yButtonName;
                        }

                        MouseArea
                        {
                            anchors.fill: parent
                            onClicked:
                            {
                                R.log("Closed Popup at YES.");
                                if(opt.ds)
                                {
                                    rect.visible = false;
                                    return;
                                }

                                ap.setVisible(false);
                                ap.invokeYMethod();
                            }
                        }
                    }

                    Rectangle
                    {
                        id: btnNo
                        width: buttonCount > 1 ? parent.width * 0.5 : 0
                        height: parent.height
                        color: R.color_bgColor002

                        CPText
                        {
                            width: parent.width
                            height: parent.height
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            color: "white"
                            font.pointSize: R.pt(55)
                            text: opt.ds ? "아니오" : nButtonName;
                        }

                        MouseArea
                        {
                            anchors.fill: parent
                            onClicked:
                            {
                                R.log("Closed Popup at NO.");

                                if(opt.ds)
                                {
                                    rect.visible = false;
                                    return;
                                }

                                ap.setVisible(false);
                                ap.invokeNMethod();
                            }
                        }
                    }
                }
            }
        }
    }
}
