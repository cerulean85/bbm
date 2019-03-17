import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import "Resources.js" as R
TextField
{

    height: 200
    signal evtBack();
    signal evtSearch();
    signal evtPressed();
    signal evtAccepted();

    activeFocusOnPress: false
    maximumLength: 50
    placeholderText: "검색어를 입력하세요."
    font.pointSize: R.pt(18)
    color: "black"

//    property bool allowedLeaveFocus: true

    background: Rectangle {
        border.color: "white"
    }

    font.family: fontLoader.name
    FontLoader {
        id: fontLoader
        source:R.system_font;
    }

    onPressed:
    {
        activeFocusOnPress = true
        focus = true
        evtPressed();
    }

    onAccepted:
    {
        evtAccepted();
        leaveFocus();
    }

    onEditingFinished:
    {
        evtSearch();
        leaveFocus();
    }

    Keys.onBackPressed:
    {
        evtBack();
        leaveFocus()
    }

    function leaveFocus()
    {
        focus = false;
        activeFocusOnPress = false
    }
}
