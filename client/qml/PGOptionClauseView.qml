import QtQuick 2.9
import QtQuick.Controls 1.4
import "Resources.js" as R
import enums 1.0

PGPage {
    id: mainView
    visibleBackBtn: true
    visibleSearchBtn: false
    titleLineColor: "black"
    titleTextColor: "black"
    color: "white"
    pageName: "OptionClauseView"

    useDefaultEvtBack: false
    onEvtBack:
    {
        if(opt.ds) return;
        popHomeStack();
    }

    Timer
    {
        running: opt.ds ? false : (md.requestNativeBackBehavior === ENums.REQUESTED_BEHAVIOR && compareCurrentPage(pageName))
        repeat: false
        interval: 100
        onTriggered:
        {
            md.setRequestNativeBackBehavior(ENums.WAIT_BEHAVIOR);
            if(closeWindowInMain()) return;
            evtBack();
        }
    }

    property string title: "이버봄 서비스 이용약관(필수)"
    property string contents: ""


    property int subTitleFontSize: R.pt(50)
    property int contentFontSize: R.pt(40)

    Rectangle
    {
        id: clauseRect
        width: parent.width
        height: mainView.height - mainView.heightStatusBar - mainView.heightBottomArea - R.height_titleBar
        y: mainView.heightStatusBar + R.height_titleBar

//        CPText
//        {
//            id: titleTxt
//            font.pointSize: subTitleFontSize
//            color: "black"
//            text: title
//            verticalAlignment: Text.AlignVCenter
//            anchors
//            {
//                top: parent.top
//                topMargin: R.dp(65)
//                left: parent.left
//                leftMargin: R.dp(65)
//            }
//        }

        Rectangle
        {
            width:  clauseRect.width - R.dp(130) //R.dp(1112)
            height: clauseRect.height - R.dp(135) // R.dp(645)
            border.width: R.height_line_1px
            border.color: R.color_gray87
            anchors
            {
                top: parent.top
                topMargin: R.dp(65)
                left: parent.left
                leftMargin: R.dp(65)
            }
            ScrollView
            {
                id: scv
                width: parent.width - R.dp(50)
                height: parent.height - R.dp(60) //R.dp(605)
                clip: true
                horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
                anchors
                {
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }

                CPText
                {
                    width: scv.width //- R.dp(20)
                    font.pointSize: contentFontSize
                    color: R.color_gray87
                    text: contents
                }
            }
        }
    }
}

