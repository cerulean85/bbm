import QtQuick 2.9
import "Resources.js" as R

Rectangle
{
    property bool selected : false
    width: R.dp(146)
    height: R.dp(84)
    color: selected ? R.color_bgColor001 : R.color_gray001;
    radius: 50


    Rectangle
    {
        id: circle
        width: R.dp(70)
        height: R.dp(70)
        radius: 100
        x: selected ? R.dp(68) : R.dp(8)
        anchors
        {
            top: parent.top
            topMargin: R.dp(6)
//            verticalCenter: parent.verticalCenter
        }
    }

    PropertyAnimation { id: toggleOn;
                        target: circle;
                        property: "x";
                        to: R.dp(68);
                        duration: 200 }
    ColorAnimation on color {
        id: toggleOnColor
        from: R.color_gray001
        to: R.color_bgColor001
        running: false
        duration: 200
    }

    PropertyAnimation { id: toggleOff;
                        target: circle;
                        property: "x";
                        to: R.dp(8);
                        duration: 200 }
    ColorAnimation on color {
        id: toggleOffColor
        from: R.color_bgColor001
        to: R.color_gray001
        running: false
        duration: 200
    }

    MouseArea
    {
        anchors.fill: parent
        onClicked:
        {
            selected = !selected;
            if(selected)
            {
                onToggle();
            }
            else
            {
                offToggle();
            }
        }
    }

    function onToggle()
    {
        toggleOn.running = true;
        toggleOnColor.running = true;
    }

    function offToggle()
    {
        toggleOff.running = true;
        toggleOffColor.running = true;
    }
}
