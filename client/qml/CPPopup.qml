import QtQuick 2.0
import QtQuick.Controls 1.4
import "Resources.js" as R
Rectangle
{
    id: rect
    signal evtYes()
    signal evtNo()

    property int buttonCount : opt.ds ? 2  : ap.buttonCount

    width: R.design_size_width
    height: R.design_size_height
    color: "#44000000"
    visible: opt.ds ? true : ap.visible


    MouseArea
    {
        width: parent.width
        height: parent.height
        onClicked:
        {
            rect.visible = false
        }
    }

    Rectangle
    {
        id: popup
        width: rect.width - R.dp(280)
        height: R.dp(500)
        color: "transparent"

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
                id: messageRect
                height: R.dp(360)
                width: parent.width
                border.width: R.dp(2)
                border.color: "#f5f6f6"
                color: "white"

                CPText
                {
                    width: parent.width
                    height: R.dp(80)
                    anchors
                    {
                        verticalCenter: parent.verticalCenter
                        horizontalCenter: parent.horizontalCenter
                    }

                    text: opt.ds ? "메세지를 입력하세요." : ap.message
                    color: "black"
                    horizontalAlignment : Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: R.pt(18)
                }
            }

            Rectangle
            {
                id: btnRect
                width: parent.width
                height: R.dp(140)

                Row
                {
                    width: parent.width
                    height: R.dp(140)

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
                            font.pointSize: R.pt(16)
                            text: "아니오"
                        }

                        MouseArea
                        {
                            anchors.fill: parent
                            onClicked:
                            {
                                R.log("CLOSED POPUP.");
                                rect.visible = false;
                                evtNo();
                            }
                        }
                    }

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
                            font.pointSize: R.pt(16)
                            text: buttonCount > 1 ? "예" : "확인"
                        }

                        MouseArea
                        {
                            anchors.fill: parent
                            onClicked:
                            {
                                R.log("CLOSED POPUP.");
                                rect.visible = false;
                                evtYes();
                            }
                        }
                    }
                }
            }
        }
    }
}
