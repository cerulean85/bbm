import QtQuick 2.9
import QtGraphicalEffects 1.0
import "Resources.js" as R
Rectangle {
    id: mainView
    width: R.dp(180)
    height: R.dp(180)

    signal evtClicked();
    property string sourceImage : ""
//    opt.ds ? "https://scontent-sjc3-1.cdninstagram.com/vp/eaf56aa30148a578e29d34631cb84968/5BB12F51/t51.2885-15/e35/26156236_123939068416546_2742507055683207168_n.jpg" : settings.thumbnailImage
    property bool enabledModify: true
    color: "transparent"

    CPImage
    {
        id: userImg
        source: R.image("user")
        width: parent.width - R.dp(5)
        height: parent.height - R.dp(5)
        anchors
        {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
    }

    CPImage
    {
        id: target
        source: sourceImage
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectCrop
        //        sourceSize: Qt.size(parent.width, parent.height)
        anchors
        {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
        smooth: true
        visible: false
    }


    CPImage
    {
        id: mask
        //        sourceSize: Qt.size(parent.width, parent.height)
        width: parent.width
        height: parent.height
        source: R.image("circle")

        anchors
        {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
        smooth: true
        visible: false
    }

    OpacityMask {
        anchors.fill: target
        source: target
        maskSource: mask
    }

    Rectangle
    {
        width: parent.width
        height: parent.height
        color:"transparent"
        radius: parent.width * 0.5

        ColorAnimation on color {
            id: colorAnimator
            from: "#44000000"//R.color_gray001
            to: "transparent"
            running: false
            duration: 500
        }

        MouseArea
        {
            anchors.fill: parent
            enabled: enabledModify
            onClicked:
            {
                colorAnimator.running = true;
                if(opt.ds) return;
                evtClicked();
            }
        }
    }
}
