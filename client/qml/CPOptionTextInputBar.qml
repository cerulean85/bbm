import QtQuick 2.9
import QtQuick.Controls 2.2
import "Resources.js" as R
import enums 1.0

Rectangle
{
    id: mainView
    width: R.dp(1242)
    height: R.dp(160)

    property int titleWidth : R.dp(400)
    property string title: "notitle"
    property string placeholderText: "nocontents"
    property int maximumLength: 16
    property int echoMode: Text.Normal
    property alias text : textField.text
    property string current: ""
    property int inputMethodHints : Qt.ImhNone

    CPText
    {
        id: titleTxt
        text: mainView.title
        color: R.color_bgColor001
        font.pointSize: R.font_size_common_style_login
        width: titleWidth
        height: parent.height
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        anchors
        {
            left: parent.left
            leftMargin: R.dp(56)
        }
    }

    CPTextField
    {
        id: textField
        width: parent.width - titleWidth
        height: parent.height
        placeholderText: mainView.placeholderText
        font.pointSize: R.font_size_common_style_login
        text: current
        maximumLength: mainView.maximumLength
        echoMode: mainView.echoMode
        inputMethodHints: mainView.inputMethodHints
        anchors
        {
            left: titleTxt.right
        }
    }

}
