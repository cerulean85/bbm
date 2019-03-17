import QtQuick 2.11
import "Resources.js" as R

CPImage
{
    property int dWidth: 0
    width: dWidth
    sourceSize.width: Qt.platform.os === R.os_name_android ? dWidth : 0
}
