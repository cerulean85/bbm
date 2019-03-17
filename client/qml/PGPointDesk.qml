import QtQuick 2.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtQml 2.2
import "Resources.js" as R

PGProto
{
    id: rectMain
    width: opt.ds ? R.dp(1242) : appWindow.width
    height: opt.ds ? R.dp(2208) : appWindow.height
    color: "#f5f6f6"
    useToMoveByPush: false

    property int heightRowItem : R.dp(112)
    property int dLength : opt.ds ? 100 : md.rankList.length
    property int txtFontSize: R.pt(35)

    property int tableWidth: rectMain.width // - R.dp(80)
    property double col1Rate: 0.14
    property double col2Rate: 0.22
    property double col3Rate: 0.16
    property double col4Rate: 0.16
    property double col5Rate: 0.16
    property double col6Rate: 0.16


    Component.onCompleted:
    {
        if(opt.ds) return;
        dataGetter.running = true;
    }

    Timer
    {
        id: dataGetter
        running: false
        repeat: false
        interval: 300
        onTriggered:
        {
            wk.getRankingMain();
            wk.request();
        }
    }

    Column
    {
        id: mainColumn
        width: parent.width
        height: parent.height

        LYMargin
        {
            width: parent.width
            height: R.height_line_1px * 2
            color: R.color_gray001
        }

        Rectangle
        {
            id: myPointRect
            width: parent.width
            height: R.dp(235)

            CPProfileImage
            {
                id: userImg
                width: R.dp(140)
                height: R.dp(140)
                enabled: false
                anchors
                {
                    left: parent.left
                    leftMargin: R.dp(73)
                    verticalCenter: parent.verticalCenter
                }
                sourceImage: R.startsWithAndReplace(settings.profileImage, "https", "http")
            }

            CPText
            {
                id: ptTxt
                text: (opt.ds ? "100" : (logined() ? settings.totalHavePoint:"0")) + "pt."
                height: R.dp(50)
                font.pointSize: R.pt(50)
                //                font.bold: true
                anchors
                {
                    top: userImg.top
                    topMargin: R.dp(10)
                    left: userImg.right
                    leftMargin: R.dp(20)
                }
            }
            CPText
            {
                text: (opt.ds || logined()) ? "보유한 포인트로 이벤트 신청을 해보세요!" : "로그인 해주세요."
                height: R.dp(50)
                color: R.color_bgColor002
                font.pointSize: R.pt(40)
                anchors
                {
                    top: ptTxt.bottom
                    topMargin: R.dp(20)
                    left: userImg.right
                    leftMargin: R.dp(20)
                }
            }

            Rectangle
            {
                width: R.dp(120)
                height: R.dp(120)
                color: "transparent"
                anchors
                {
                    right: parent.right
                    rightMargin: R.dp(45)
                    verticalCenter: parent.verticalCenter
                }
                CPImage
                {
                    width: R.dp(80)
                    height: R.dp(80)
                    source: R.image("point_go")
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
                height: parent.height
                color: "transparent"

                ColorAnimation on color{
                    id:cccc
                    running: false
                    from: "#44000000"
                    to: "transparent"
                    duration: 200
                }

                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
//                        cccc.running = true;
                        if(opt.ds) return;

                        if(logined()) naviHistory.running = true
                        else
                        {
                            showIndicator(true);
                            pushUserStack("LoginDesk", {}, StackView.PushTransition);
                        }
                    }
                }

                Timer
                {
                    id: naviHistory
                    running: false
                    repeat: false
                    interval: 200
                    onTriggered:
                    {
                        pushHomeStack("PointHistory");
                    }
                }
            }
        }


        Rectangle
        {
            id: eventBtn
            width: parent.width //- R.dp(64)
            height: R.dp(150)
            anchors.horizontalCenter: parent.horizontalCenter
            color: R.color_bgColor002

            //                            CPImage
            //                            {
            //                                id: eventImg
            //                                width: parent.width
            //                                height: parent.height
            //                                source: R.image("event")
            //                            }

            CPText
            {
                text: "이벤트 신청하기"
                color: "white" //R.color_bgColor002
                font.pointSize: R.pt(50)
                //                                font.bold: true
                anchors
                {
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }
            }

            Rectangle
            {
                width: parent.width
                height: parent.height
                color: "transparent"
                //                                radius: 50

                ColorAnimation on color{
                    id: ccccc
                    from: "#44000000"
                    to: "transparent"
                    duration: 200
                    running: false
                }


                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        R.log("이벤트 신청!!")
                        ccccc.running = true;
                        if(!logined())
                        {
                            alarmNeedLogin();
                            return;
                        }

                        if(opt.ds) return;
                        tmEvtList.running = true;
                    }
                }

                Timer
                {
                    id: tmEvtList
                    running: false
                    repeat: false
                    interval: 200
                    onTriggered:
                    {
                        pushHomeStack("EventList", {});
                    }
                }
            }
        }

        Rectangle
        {
            id: notitledRect
            width: parent.width
            height: parent.height - myPointRect.height- R.dp(20)*2

            Column
            {
                id: notitledColumn
                width: parent.width
                height: parent.height
                Column
                {
                    id: metaBox
                    width: parent.width

                    LYMargin
                    {
                        id: margin2
                        width: parent.width
                        height: R.dp(20)
                        color: "#f5f6f6"//R.color_theme01
                    }

                    LYMargin { height: R.dp(50) }
                    CPText
                    {
                        id: txt1
                        text: "이달의 랭킹 Top 100"
                        width: parent.width
                        font.pointSize: R.pt(45)
                        horizontalAlignment: Text.AlignHCenter
                    }

                    LYMargin { height: R.dp(10) }
                    CPText
                    {
                        id: desc
                        width: parent.width
                        text: "(랭킹은 학습자가 항목별로 받은 점수를 근거로 집계됩니다.)"
                        font.pointSize: R.pt(25)
                        color: R.color_gray87
                        horizontalAlignment: Text.AlignHCenter
                    }
                    LYMargin { height: R.dp(10) }
                    CPText
                    {
                        id: txt2
                        text: opt.ds ? "2018.05.01. ~ 2018.05.31." : md.myRank.startDate + " ~ " + md.myRank.endDate
                        width: parent.width
                        color: R.color_bgColor001
                        font.pointSize: R.pt(40)
                        horizontalAlignment: Text.AlignHCenter
                    }
                    LYMargin { height: R.dp(30) }
                    LYMargin
                    {
                        width: parent.width
                        height: R.height_line_1px
                        color: R.color_gray001
                    }

                    Rectangle
                    {
                        id: header
                        width: parent.width
                        height: R.dp(130)

                        Row
                        {
                            width: parent.width
                            height: parent.height

                            //                            LYMargin {width: R.dp(98) }
                            Item
                            {
                                width: tableWidth * col1Rate
                                height: parent.height

                                CPText
                                {
                                    height: parent.height
                                    text: "등수"
                                    color: R.color_gray88
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pointSize: txtFontSize
                                    anchors.horizontalCenter:parent.horizontalCenter
                                }
                            }

                            Item
                            {
                                width: tableWidth * col2Rate
                                height: parent.height

                                CPText
                                {
                                    height: parent.height
                                    text: "닉네임"
                                    color: R.color_gray88
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pointSize: txtFontSize
                                    anchors
                                    {
                                        horizontalCenter: parent.horizontalCenter
                                    }
                                }
                            }

                            Item
                            {
                                width: tableWidth * col3Rate
                                height: parent.height
                                CPText
                                {
                                    height: parent.height
                                    text: "과목"
                                    color: R.color_gray88
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pointSize: txtFontSize
                                    anchors
                                    {
                                        horizontalCenter: parent.horizontalCenter
                                    }
                                }
                            }

                            Item
                            {
                                width: tableWidth * col4Rate
                                height: parent.height

                                CPText
                                {
                                    height: parent.height
                                    text: "소셜"
                                    color: R.color_gray88
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pointSize: txtFontSize
                                    anchors
                                    {
                                        horizontalCenter: parent.horizontalCenter
                                    }
                                }
                            }

                            Item
                            {
                                width: tableWidth * col5Rate
                                height: parent.height
                                CPText
                                {
                                    height: parent.height
                                    text: "기타"
                                    color: R.color_gray88
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pointSize: txtFontSize
                                    anchors
                                    {
                                        horizontalCenter: parent.horizontalCenter
                                    }
                                }
                            }

                            Item
                            {
                                width: tableWidth * col6Rate
                                height: parent.height

                                CPText
                                {
                                    height: parent.height
                                    text: "합"
                                    color: R.color_gray88
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pointSize: txtFontSize
                                    anchors
                                    {
                                        horizontalCenter: parent.horizontalCenter
                                    }
                                }
                            }
                        }
                    }

                    Rectangle
                    {
                        id: myInfo
                        width: parent.width
                        height: heightRowItem
                        color: R.color_bgColor001

                        Row
                        {
                            width: parent.width
                            height: parent.height

                            Item
                            {
                                width: tableWidth * col1Rate
                                height: parent.height
                                CPText
                                {
                                    height: parent.height
                                    color: "white"
                                    text: opt.ds ? "24등" : ((md.myRank.rankNo === 999 || !logined()) ? "-" : (md.myRank.rankNo + "등"))
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pointSize: txtFontSize
                                    anchors.horizontalCenter:parent.horizontalCenter
                                }
                            }

                            Item
                            {
                                width: metaBox.width * col2Rate
                                height: parent.height

                                CPText
                                {
                                    height: parent.height
                                    color: "white"
                                    text: opt.ds ? "꾸러기케로로" : (md.myRank.nickname === "" ? "-" : md.myRank.nickname)
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pointSize: txtFontSize
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }

                            CPText
                            {
                                width: metaBox.width * col3Rate
                                height: parent.height
                                color: "white"
                                text: opt.ds ? "20000" : cmd.currency(md.myRank.courseScore)
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                font.pointSize: txtFontSize
                            }

                            CPText
                            {
                                width: metaBox.width * col4Rate
                                height: parent.height
                                color: "white"
                                text: opt.ds ? "5000" : cmd.currency(md.myRank.socialScore)
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                font.pointSize: txtFontSize
                            }

                            CPText
                            {
                                width: metaBox.width * col5Rate
                                height: parent.height
                                color: "white"
                                text: opt.ds ? "10" : cmd.currency(md.myRank.etcScore)
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                font.pointSize: txtFontSize
                            }

                            CPText
                            {
                                width: metaBox.width * col6Rate
                                height: parent.height
                                color: "white"
                                text: opt.ds ? "250" : cmd.currency(md.myRank.totalScore)
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                font.pointSize: txtFontSize
                            }
                        }
                    }
                }

                Flickable
                {
                    id: flick
                    width: parent.width
                    height: parent.height - metaBox.height - R.height_tabBar
                    contentWidth: parent.width
                    contentHeight: rankColumn.height + R.height_tabBar
                    maximumFlickVelocity: R.flickVelocity(rankColumn.height)
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds
                    z: 2

                    Column
                    {
                        id: rankColumn
                        width: parent.width

                        Repeater
                        {
                            model: dLength

                            Column
                            {
                                width: parent.width
                                height: heightRowItem

                                Rectangle
                                {
                                    width: parent.width
                                    height: heightRowItem - R.height_line_1px
                                    Row
                                    {
                                        width: parent.width
                                        height: parent.height
                                        anchors
                                        {
                                            horizontalCenter: parent.horizontalCenter
                                        }

                                        Item
                                        {
                                            width: tableWidth * col1Rate
                                            height: parent.height

                                            CPText
                                            {
                                                height: parent.height - R.dp(20)
                                                text: (opt.ds ? (index+1) : md.rankList[index].rankNo) + "등"
                                                verticalAlignment: Text.AlignBottom
                                                horizontalAlignment: Text.AlignHCenter
                                                font.pointSize: txtFontSize
                                                anchors.horizontalCenter:parent.horizontalCenter
                                            }
                                        }

                                        Item
                                        {
                                            width: tableWidth * col2Rate
                                            height: parent.height
                                            CPText
                                            {
                                                height: parent.height - R.dp(20)
                                                text: opt.ds ? "꾸러기케로로" : md.rankList[index].nickname
                                                verticalAlignment: Text.AlignBottom
                                                horizontalAlignment: Text.AlignHCenter
                                                maximumLineCount: 1
                                                font.pointSize: txtFontSize
                                                anchors.horizontalCenter: parent.horizontalCenter
                                            }
                                        }

                                        Item
                                        {
                                            width: tableWidth * col3Rate
                                            height: parent.height
                                            CPText
                                            {
                                                width: metaBox.width * col3Rate
                                                height: parent.height - R.dp(20)
                                                text: opt.ds ? "20,000" : cmd.currency(md.rankList[index].courseScore)
                                                verticalAlignment: Text.AlignBottom
                                                horizontalAlignment: Text.AlignHCenter
                                                font.pointSize: txtFontSize
                                            }
                                        }

                                        Item
                                        {
                                            width: tableWidth * col4Rate
                                            height: parent.height
                                            CPText
                                            {
                                                width: metaBox.width * col4Rate
                                                height: parent.height - R.dp(20)
                                                text: opt.ds ? "5,000" : cmd.currency(md.rankList[index].socialScore)
                                                verticalAlignment: Text.AlignBottom
                                                horizontalAlignment: Text.AlignHCenter
                                                font.pointSize: txtFontSize
                                            }
                                        }

                                        Item
                                        {
                                            width: tableWidth * col5Rate
                                            height: parent.height
                                            CPText
                                            {
                                                height: parent.height - R.dp(20)
                                                text: opt.ds ?  "10" : cmd.currency(md.rankList[index].etcScore)
                                                verticalAlignment: Text.AlignBottom
                                                horizontalAlignment: Text.AlignHCenter
                                                font.pointSize: txtFontSize
                                                anchors.horizontalCenter: parent.horizontalCenter
                                            }
                                        }

                                        Item
                                        {
                                            width: tableWidth * col6Rate
                                            height: parent.height
                                            CPText
                                            {
                                                height: parent.height - R.dp(20)
                                                text: opt.ds ? "250" : cmd.currency(md.rankList[index].totalScore)
                                                verticalAlignment: Text.AlignBottom
                                                horizontalAlignment: Text.AlignHCenter
                                                font.pointSize: txtFontSize
                                                anchors.horizontalCenter: parent.horizontalCenter
                                            }
                                        }
                                    }
                                }

                                Row
                                {
                                    width: parent.width
                                    height: R.height_line_1px
                                    LYMargin { width: R.dp(40) }

                                    LYMargin
                                    {
                                        width: parent.width - R.dp(40)*2;
                                        height: R.height_line_1px;
                                        color: R.color_gray88
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Timer
    {
        running: opt.ds ? false : (md.CRUDHandlerType === 4)
        repeat: false
        interval: 300
        onTriggered:
        {
            md.setCRUDHandlerType(0);
            rectMain.forceActiveFocus();
        }
    }
}

