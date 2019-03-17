import QtQuick 2.9
import "Resources.js" as R

Rectangle
{
    id : btnRect

    width: R.dp(100)
    height: R.dp(100)

    signal evtClicked();
    property bool visibled : true
    property int widthImage : R.dp(78)
    property int heightImage : R.dp(78)
    property string sourceImage : R.image("no_image")
    property bool useEffectClick: true
    z: 8000

    CPImage
    {
        width: widthImage
        height: heightImage
        source: sourceImage
        anchors
        {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
    }
    MouseArea
    {
        anchors.fill: parent
        onClicked:
        {
            if(useEffectClick) colorAnimator.running = true;
            behavior.running = true;
        }
    }
    ColorAnimation on color {
        id: colorAnimator
        from: R.color_grayE1
        to: "transparent"
        running: false
        duration: 100
    }

    Timer
    {
        id: behavior
        running: false
        repeat: false
        interval: 200
        onTriggered:
        {
            R.hideKeyboard();

            if(opt.ds) return;
            evtClicked();
        }
    }
}
