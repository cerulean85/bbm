import QtQuick 2.9
import QtQuick.Controls 1.4
import "Resources.js" as R

Rectangle
{
    id: btnRect
    width: parent.width
    height: R.dp(160)
    color: R.color_bgColor001

    property string name: "로그인"
    property int pointSize: R.pt(17)
    property string subColor : R.color_bgColor002
    property string txtColor : "white"
    property int alignHorizon : Text.AlignHCenter
    property int txtLeftMargn : R.dp(0)
    property int txtRightMargn : R.dp(0)
    property bool underline: false
    property bool bold: false
    property int leftTxtWidth: leftTxt.width
    property int rightTxtWidth: rightTxt.width
    property int leftTxtHeight: leftTxt.height
    property int rightTxtHeight: rightTxt.height
//    property alias txtWidth : leftTxt.width == 0 ? rightTxt.width : leftTxt.width

    signal click()

    CPText
    {
        id: leftTxt
        width: parent.width
        height: parent.height
        visible: alignHorizon != Text.AlignRight
        horizontalAlignment: alignHorizon
        verticalAlignment: Text.AlignVCenter
        font.underline: underline
        font.bold: bold
        text: name
        color: txtColor
        font.pointSize: pointSize
        anchors
        {
            left: parent.left
            leftMargin: txtLeftMargn

        }
    }

    CPText
    {
        id: rightTxt
        width: parent.width
        height: parent.height
        visible: alignHorizon == Text.AlignRight
        horizontalAlignment: alignHorizon
        verticalAlignment: Text.AlignVCenter
        font.underline: underline
        font.bold: bold
        text: name
        color: txtColor
        font.pointSize: pointSize
        anchors
        {
            right: parent.right
            rightMargin: txtRightMargn

        }
    }

    Timer
    {
        id: behavior
        running: false
        repeat: false
        interval: 100
        onTriggered:
        {
            R.hideKeyboard();

            if(opt.ds) return;
            click();
        }
    }

    MouseArea
    {
        anchors.fill: parent
        onClicked:
        {
            colorAnimator.running = true;
            behavior.running = true;
        }
    }


    ColorAnimation on color {
        id: colorAnimator
        from: subColor
        to: btnRect.color
        running: false
        duration: 100
    }
}
