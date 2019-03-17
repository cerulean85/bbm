import QtQuick 2.11

Rectangle
{
    id: mainView
    color: "transparent"

    signal evtUIThreadWork();
    signal evtClicked();
    signal evtDS();

    property bool onAnimation: true

    ColorAnimation on color
    {
        id: colorAnimation
        from: "#44000000"
        to: "transparent"
        duration: 200
        running: false
    }

    MouseArea
    {
        anchors.fill: parent
        onClicked:
        {
            colorAnimation.running = onAnimation;
            if(opt.ds)
            {
                evtDS();
                return;
            }

            evtUIThreadWork();
            tm.running = true;
        }
    }

    Timer
    {
        id: tm
        running: false
        repeat: false
        interval: 200
        onTriggered: evtClicked();
    }
}
