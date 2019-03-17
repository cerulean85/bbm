import QtQuick 2.9
import QtQuick.Controls 2.2
import "Resources.js" as R

Rectangle
{
    width: parent.width
    height: R.dp(100)
    property int no: 1
    property int circleWidth: R.dp(30)
    property int circleheight: R.dp(30)
    property int lineWidth: parent.width * 0.25 //R.dp(280)
    property int circleBorderWidth: R.dp(5)
//    property int textHeight: R.dp(50)
//    property int textWidth: R.dp(200)
    property int stageCount: 4
    property int currentStage: 1
    property int textInterval: opt.ds ? R.dp(140) : (Qt.platform.os == "android" ? R.dp(90) : R.dp(400))

    Row
    {
        id: circleArea
        width: circleWidth * stageCount + lineWidth * (stageCount - 1)
        height: circleheight + R.dp(10)
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle
        {
            id: circle1
            radius: 10
            width: circleWidth
            height: circleheight
            color: currentStage==1 ? R.color_bgColor001 : "transparent"
            border.color: R.color_bgColor001
            border.width: circleBorderWidth
        }

        Rectangle
        {
            width: lineWidth
            height:circleheight
            LYMargin
            {
                width: parent.width
                height: circleBorderWidth
                color: R.color_bgColor001
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Rectangle
        {
            id: circle2
            radius: 10
            width: circleWidth
            height: circleheight
            color: currentStage==2 ? R.color_bgColor001 : "transparent"
            border.color: R.color_bgColor001
            border.width: circleBorderWidth
        }

        Rectangle
        {
            width: lineWidth
            height:circleheight
            LYMargin
            {
                width: parent.width
                height: circleBorderWidth
                color: R.color_bgColor001
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Rectangle
        {
            id: circle3
            radius: 10
            width: circleWidth
            height: circleheight
            color: currentStage==3 ? R.color_bgColor001 : "transparent"
            border.color: R.color_bgColor001
            border.width: circleBorderWidth
        }

        Rectangle
        {
            width: lineWidth
            height:circleheight
            LYMargin
            {
                width: parent.width
                height: circleBorderWidth
                color: R.color_bgColor001
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Rectangle
        {
            id: circle4
            radius: 10
            width: circleWidth
            height: circleheight
            color: currentStage==4 ? R.color_bgColor001 : "transparent"
            border.color: R.color_bgColor001
            border.width: circleBorderWidth
        }
    }

    CPText
    {
        id: text1
        text: "약관동의"
        font.pointSize: R.pt(35)
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: R.color_gray87
        anchors
        {
            top: circleArea.bottom
            left: circleArea.left
            leftMargin: -text1.width*0.5 + R.dp(15)
        }
    }

    CPText
    {
        id: text2
        text: "본인인증"
        font.pointSize: R.pt(35)
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: R.color_gray87
        anchors
        {
            top: circleArea.bottom
            left: circleArea.left
            leftMargin: lineWidth + circleWidth -text1.width*0.5 + R.dp(15)
        }
    }

    CPText
    {
        id: text3
        text: "정보입력"
        font.pointSize: R.pt(35)
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: R.color_gray87
        anchors
        {
            top: circleArea.bottom
            left: circleArea.left
            leftMargin: (lineWidth + circleWidth) * 2 -text1.width*0.5 + R.dp(15)
        }
    }

    CPText
    {
        id: text4
        text: "가입완료"
        font.pointSize: R.pt(35)
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: R.color_gray87
        anchors
        {
            top: circleArea.bottom
            left: circleArea.left
            leftMargin: (lineWidth + circleWidth) * 3 -text1.width*0.5 + R.dp(15)
        }
    }
}
