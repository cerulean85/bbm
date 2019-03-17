import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import "Resources.js" as R

Rectangle
{
    id: clauseRect
    width: R.dp(1242)
    height: R.dp(950)

    signal evtClicked();

    property bool necessary: false
    property int clauseOrder: 1
    property int subTitleFontSize: R.pt(40)
    property int contentFontSize: R.pt(40)

    property string title: "이버봄 서비스 이용약관(필수)"
    property string contents: ""

    property string applymsg: "서비스 이용약관에 동의합니다."

    Column
    {
        width: parent.width
        height: clauseRect.height

        LYMargin { height: R.dp(75); }

        Row
        {
            LYMargin { width: R.dp(65) }
            CPText
            {
                font.pointSize: subTitleFontSize
                color: "black"
                text: title
                verticalAlignment: Text.AlignVCenter
            }
            LYMargin { width: R.dp(10) }
            CPText
            {
                font.pointSize: subTitleFontSize
                color: necessary ? R.color_bgColor001 : "black"
                text: necessary ? "(필수)" : "(선택)"
                verticalAlignment: Text.AlignVCenter
            }
        }
        LYMargin { height: R.dp(20);}

        Row
        {
            LYMargin { width: R.dp(65) }
            Rectangle
            {
                width: clauseRect.width - R.dp(130) //R.dp(1112)
                height: R.dp(645)
                border.width: R.height_line_1px
                border.color: R.color_gray87

                ScrollView
                {
                    width: clauseRect.width - R.dp(190) //R.dp(1052)
                    height: R.dp(605)
                    clip: true
                    horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
                    anchors
                    {
                        verticalCenter: parent.verticalCenter
                        horizontalCenter: parent.horizontalCenter
                    }

                    CPText
                    {
                        width: clauseRect.width - R.dp(190)
                        //                            height: txt.height
                        font.pointSize: contentFontSize
                        color: R.color_gray87
                        text: contents

                    }
                }
            }
        }
        Row
        {
            LYMargin { width: R.dp(65) }
            Rectangle
            {
                width: clauseCheckTxt.width + chBox.width + R.dp(100)
                height: R.dp(150)
                color:"transparent"
                CPCheckBox
                {
                    id: chBox
                    width: R.dp(100)
                    height: R.dp(100)
                    checked:
                    {
                        if(opt.ds) return true;

                        switch(clauseOrder)
                        {
                        case 1: return md.checkedClause1;
                        case 2: return md.checkedClause2;
                        case 3: return md.checkedClause3;
                        case 4: return md.checkedClause4;
                        }
                        return false;
                    }
                    onEvtChecked:
                    {
                        if(opt.ds) return;

                        switch(clauseOrder)
                        {
                        case 1: md.setCheckedClause1(!md.checkedClause1); break;
                        case 2: md.setCheckedClause2(!md.checkedClause2); break;
                        case 3: md.setCheckedClause3(!md.checkedClause3); break;
                        case 4: md.setCheckedClause4(!md.checkedClause4); break;
                        }
                    }
                    anchors
                    {
                        verticalCenter: parent.verticalCenter
                    }
                }

                CPText
                {
                    id: clauseCheckTxt
                    text: applymsg
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: subTitleFontSize
                    color: R.color_gray87
                    anchors
                    {
                        left: chBox.right
                        leftMargin: R.dp(20)
                    }
                }

                ColorAnimation on color {
                    id: colorAnimator
                    from: R.color_gray001
                    to: "white"
                    running: false
                    duration: 100
                }

                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        colorAnimator.running = true;
                        if(opt.ds)
                        {
                            chBox.checked = !chBox.checked;
                            return;
                        }
                        evtClicked();
                    }

                }
            }
        }
    }
}
