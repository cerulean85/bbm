import QtQuick 2.9
import QtQuick.Controls 2.2
import "Resources.js" as R
import enums 1.0

PGPage {
    id: mainView
    visibleSearchBtn: false
    titleText: ""
    titleTextColor: "black"
    titleLineColor: "black"
    visibleBackBtn: false
    color: "white"
    enabled: opt.ds ? true : false
    opacity: opt.ds ? 1 : 0

    onEvtBehaviorAndroidBackButton:
    {
        hideOpacityView();
    }

    Column
    {
        width: img.width
        anchors
        {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
        CPOSSpecifiedImage
        {
            id: img
            dWidth: mainView.width
            source: R.image("information_point")
        }

        Rectangle
        {
            width: img.width
            height: R.dp(100)
        }
    }

    MouseArea
    {
        anchors.fill: parent
        onClicked: hideOpacityView();
    }

    Rectangle
    {
        height: R.dp(150)
        width: R.dp(150)
        color: "transparent"
        y: mainView.heightStatusBar

        CPImage
        {
            width: R.dp(130)
            height: R.dp(130)
            source: R.image(R.btn_close_gray_image)
            anchors
            {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }
        }

        anchors
        {
            right: parent.right
        }

        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                colorAnimator11.running = true;
                hideOpacityView();
            }
        }

        ColorAnimation on color {
            id: colorAnimator11
            from: "#444444"
            to: "transparent"
            running: false
            duration: 100
        }
    }
}
