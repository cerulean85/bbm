import QtQuick 2.11
import "Resources.js" as R

Rectangle
{
    id: mainView
    property alias txt: textArea.txt
    property string holderText: "내용을 입력해주세요."
    height: R.dp(700)

    CPTextArea
    {
        id: textArea
        width: parent.width - (Qt.platform.os === R.os_name_android  ? R.dp(60) : R.dp(40))
        height: parent.height
        maxiumLineCount: 10
        holderText: mainView.holderText
        anchors
        {
            top: parent.top
            topMargin: R.dp(30)
            horizontalCenter: parent.horizontalCenter
        }
    }

    function setText(str) { textArea.setText(str); }
}
