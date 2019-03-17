import QtQuick 2.11
import QtQuick.Controls 2.4
import "Resources.js" as R

Flickable
{
    id: flick
    width: parent.width
    height: R.dp(500)
    contentWidth : textArea.width
    contentHeight: textArea.height
    clip: true
    boundsBehavior: Flickable.StopAtBounds
    property alias txt: textArea.text
    property string holderText: "내용을 입력해 주세요."
    property int maxiumLineCount: 30

    TextArea
    {
        id: textArea
        text: ""
        placeholderText: holderText
        font.pointSize: R.pt(50)
        wrapMode: TextEdit.Wrap
        width: flick.width
        font.family: fontLoader.name
        inputMethodHints: (Qt.platform.os === R.os_name_android) ? Qt.ImhUrlCharactersOnly : Qt.ImhNone
        onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)

        onTextChanged:
        {
            if(textArea.lineCount > maxiumLineCount)
            {
                text = text.substring(0, text.length - 1);
                cursorPosition = text.length;
            }
        }
    }

    FontLoader
    {
        id: fontLoader
        source:R.system_font;
    }

    function setText(txt) { textArea.text = txt; }
    function ensureVisible(r)
    {
        if (contentY + height <= r.y + r.height)
            contentY = r.y+r.height;
    }
}
