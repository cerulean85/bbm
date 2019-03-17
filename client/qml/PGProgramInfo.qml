import QtQuick 2.9
//import QtQuick.Controls 2.2
//import QtQuick.Layouts 1.3
//import QtGraphicalEffects 1.0
import "Resources.js" as R
import enums 1.0

PGPage {
    id: mainView
    visibleBackBtn: true
    visibleSearchBtn: false
    titleText: "프로그램 정보"
    titleTextColor: "black"
    titleLineColor: "black"
    pageName: "ProgramInfo"
    Component.onCompleted:
    {
        if(opt.ds) return;
    }

    property int widthCategoryArea: contentcRect.width * 0.5
    property int heightCategoryArea: R.dp(137)

    property int dlength : opt.ds ? 25 : md.mycourselist.length
    property int actyLength : 40
    property int itemHeight : R.dp(350)
    property int itemActyHeight : R.dp(136)

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

    Rectangle
    {
        id: contentcRect
        width: parent.width
        height: mainView.height - mainView.heightStatusBar - mainView.heightBottomArea - R.height_titleBar
        color: R.color_grayED
        y: mainView.heightStatusBar + R.height_titleBar

        Column
        {
            id: mainColumn
            width: parent.width
            height: contentcRect.height

            Rectangle
            {
                id: metaRect
                width: parent.width
                height: R.dp(700)
                color: "white"

                CPImage
                {
                    width: R.dp(335)
                    height: R.dp(433)
                    source: R.image("information")
                    anchors
                    {
                        verticalCenter: parent.verticalCenter
                        horizontalCenter: parent.horizontalCenter
                    }
                }

            }

            Rectangle
            {
                width: parent.width
                height: mainColumn.height - metaRect.height - R.dp(20)

                Column
                {
                    width: parent.width
                    height: parent.height
                    LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_bgColor001; }
                    CPProfileButton
                    {
                        height: R.dp(178)
                        title: "현재 버전"
                        hideGoButton: true
                        enabled: false
                        contents: ""

                        CPText
                        {
                            font.pointSize: R.font_size_common_style_login
                            height: parent.height
                            text: opt.ds ? "v1.1.1" : ("v"+settings.versCurrentApp)
                            color: R.color_gray87
                            verticalAlignment: Text.AlignVCenter
                            anchors
                            {
                                right: parent.right
                                rightMargin: R.margin_common
                            }
                        }
                    }
                    LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_bgColor001; }
                    CPProfileButton
                    {
                        height: R.dp(178)
                        title: R.txt_title_clause1
                        contents: ""
                        onEvtClicked:
                        {
                            pushHomeStack("OptionClauseView", { "title": "이버봄 서비스" + R.txt_title_clause1, "titleText" : R.txt_title_clause1, "contents": R.txt_clause1 });
                        }
                    }
                    LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_bgColor001; }
                    CPProfileButton
                    {
                        height: R.dp(178)
                        title: R.txt_title_clause2
                        contents: ""
                        onEvtClicked:
                        {
                            pushHomeStack("OptionClauseView", { "title": R.txt_title_clause2, "titleText" : R.txt_title_clause2, "contents": R.txt_clause2 });
                        }
                    }
                    LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_bgColor001; }
                    CPProfileButton
                    {
                        height: R.dp(178)
                        title: R.txt_title_clause3
                        contents: ""
                        onEvtClicked:
                        {
                            pushHomeStack("OptionClauseView", { "title": R.txt_title_clause3, "titleText" : R.txt_title_clause3, "contents": R.txt_clause3 });
                        }
                    }
                    LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_bgColor001; }
//                    CPProfileButton
//                    {
//                        height: R.dp(178)
//                        title: "개인정보 취급방침"
//                        contents: ""
//                        onEvtClicked:
//                        {
//                            pushHomeStack("OptionClauseView", { "titleText" : "이벤트 프로모션 알림 수신" });
//                        }
//                    }
//                    LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_bgColor001; }
                }
            }
        }
    }
}
