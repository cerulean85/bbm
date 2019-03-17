import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "Resources.js" as R

Rectangle
{
    id: checkBox
    width: R.dp(50)
    height: R.dp(50)
    color: "transparent"

    property bool checked : false
    signal evtChecked();

    Rectangle
    {
        width: parent.width - R.dp(30)
        height: parent.height - R.dp(30)
        border.width: R.height_line_1px
        border.color: R.color_gray88
        color: "transparent"
        anchors
        {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
        CPImage
        {
            width: parent.width
            height: parent.height
            source: R.image("check_mark")
            visible: checked
        }
    }

    Rectangle
    {
        width: parent.width
        height: parent.height
        color: "transparent"

        ColorAnimation on color {
            id: colorAnimaton
            running: false
            from: "#44000000"
            to: "transparent"
            duration: 300
        }

        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                colorAnimaton.running = true;
                evtChecked();
            }
        }
    }
}
