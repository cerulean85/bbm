import QtQuick 2.9
import "Resources.js" as R

Rectangle
{
    id: item
    property string contents: ""
    property int fontSize: R.pt(20)
    property string textColor: "black"
    property alias textWidth: textView.width
//    color: "yellow"
    width: textMetrics.width

    Text {
        id: textView
        wrapMode: Text.Wrap
        elide: Text.ElideRight
        font.pointSize: fontSize
        text: textMetrics.text
        width: textMetrics.width //+ R.dp(40)
        height: item.height
        color: textColor
        verticalAlignment: Text.AlignVCenter
//        horizontalAlignment: Text.AlignHCenter
    }

    TextMetrics
    {
        id: textMetrics
        text: contents
        font.pointSize: fontSize
        font.family: fontLoader.name
    }

    FontLoader {
        id: fontLoader
        source:R.system_font;
    }
}
