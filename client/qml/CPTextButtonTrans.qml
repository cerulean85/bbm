import QtQuick 2.0
import "Resources.js" as R
CPTextButton
{
    color : "transparent"
    property string btnName : "noname"
    property string fontColor : R.color_bgColor001

    name : btnName
    pointSize : R.pt(45)
    subColor: R.color_bgColor002
    txtColor: fontColor
}
