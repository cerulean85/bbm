import QtQuick 2.0
import "Resources.js" as R
Rectangle
{
    width: R.height_line_1px
    height: R.height_line_1px
    color: "transparent"

    MouseArea
    {
        anchors.fill: parent
        onClicked:
        {
            R.hideKeyboard();
        }
    }
}
