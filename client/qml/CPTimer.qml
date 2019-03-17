import QtQuick 2.11

Item
{
    id: item
    property bool run: false
    property int tmInterval: 200
    signal evtTriggered();
    Timer {
        running: opt.ds ? false : run
        repeat: false
        interval: tmInterval
        onTriggered:
        {
            evtTriggered();
            item.run = false;
        }
    }
}
