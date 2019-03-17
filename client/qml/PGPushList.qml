import QtQuick 2.9
import QtQuick.Controls 2.2
import "Resources.js" as R
import enums 1.0

PGPage {
    id: mainView
    visibleSearchBtn: false
    titleText: "알림"
    titleTextColor: "black"
    titleLineColor: "black"
    visibleBackBtn: true

    color: "white"

    property int itemHeight: R.dp(180)
    property int dLength : opt.ds ? 40 : md.alarmList.length
    property int prevLength : dLength
    property int noticeType : 0 /* 0: 공지사항, 1: 질의사항 */
    property int selectedIndex: 0

    useDefaultEvtBack: false
    onEvtInitData: md.clearAlarmList();
    onEvtBack:
    {
        evtInitData();
        hideMoveView();
    }

    Component.onCompleted:
    {
        if(opt.ds) return;
        md.setNewAlarm(false);
    }

    function getAlarmList()
    {
        dataGetter.running = true;
    }

    function showMoveView()
    {
        showAnim.running = true;
    }

    function hideMoveView()
    {
        hideAmin.running = true;
    }

    PropertyAnimation
    {
        id: showAnim;
        target: mainView
        property: "x";
        to: 0
        running: false
        duration: 200
    }

    PropertyAnimation
    {
        id: hideAmin;
        target: mainView
        property: "x";
        to: -(opt.ds ? R.dp(1242) : appWindow.width)
        running: false
        duration: 200
    }

    Timer
    {
        id: dataGetter
        running: false
        repeat: false
        interval: 300
        onTriggered:
        {
            md.clearAlarmList();

            wk.getMyAlarmList(1);
            wk.request();
        }
    }

    CPNoData
    {
        id: noDataRect
        width: parent.width
        height: parent.height - mainView.heightStatusBar - R.height_titleBar - mainView.heightBottomArea
        y: mainView.heightStatusBar + R.height_titleBar
        visible: opt.ds ? true : (dLength === 0)
        showText: true
        message: opt.ds ? R.message_has_no_alarm_list : (wk.refreshWorkResult === ENums.FINISHED_PUSHNOTICE ? R.message_has_no_alarm_list : R.message_load_alarm_list)
        tMargin: R.dp(100)
    }

    Column
    {
        width: parent.width
        height: parent.height
        y: mainView.heightStatusBar + R.height_titleBar

        Flickable
        {
            id: flick
            width: parent.width
            height: parent.height - mainView.heightStatusBar - R.height_titleBar - mainView.heightBottomArea
            contentWidth : parent.width
            contentHeight: mainColumn.height
            maximumFlickVelocity: R.flickVelocity(mainColumn.height)
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            onMovementEnded:
            {
                if(opt.ds) return;
                if(flick.atYEnd)
                {
                    if(dLength % 20 == 0 && dLength > 0)
                    {
                        showMoreIndicator(ENums.WORKING_PUSHNOTICE);
                        wk.getMyAlarmList(dLength / 20 + 1);
                        wk.request();
                    }
                }
            }

            Column
            {
                id: mainColumn
                width: parent.width
                height: itemHeight * dLength

                ListModel
                {
                    id: listModel
                    ListElement
                    {
                        title: "밤하늘의 별을 세어보다 뜬금없이 너의 모습이 떠올랐다. 서늘한 밤바람에 추울만도 하지만 네 미소를 생각하니 그저 따뜻하기만 하였다. "
                        writeDate: "날짜"
                        folded: true
                    }
                    ListElement
                    {
                        title: "제목"
                        writeDate: "날짜"
                        folded: true
                    }
                    ListElement
                    {
                        title: "제목"
                        writeDate: "날짜"
                        folded: true
                    }
                    ListElement
                    {
                        title: "제목"
                        writeDate: "날짜"
                        folded: true
                    }
                    ListElement
                    {
                        title: "제목"
                        writeDate: "날짜"
                        folded: true
                    }
                    ListElement
                    {
                        title: "제목"
                        writeDate: "날짜"
                        folded: true
                    }
                }

                Repeater
                {
                    model: opt.ds ? listModel : dLength
                    Rectangle
                    {
                        id: behindRect
                        width: parent.width
                        height: frontRect.height

//                        Rectangle
//                        {
//                            id: showRect
//                            width: R.dp(200)
//                            height: parent.height
//                            color: R.color_bgColor001

//                            CPText
//                            {
//                                text: "보기"
//                                color: "white"
//                                font.pointSize: R.font_size_common_button
//                                anchors
//                                {
//                                    verticalCenter: parent.verticalCenter
//                                    horizontalCenter: parent.horizontalCenter
//                                }
//                            }

//                            CPMouseArea
//                            {
//                                anchors.fill: parent
//                                onEvtClicked:
//                                {
//                                    selectedIndex = index;
//                                    navi();
//                                }
//                            }

//                            anchors
//                            {
//                                right: parent.right
//                            }
//                        }

                        Rectangle
                        {
                            id: removeRect
                            width: R.dp(200)
                            height: parent.height
                            color: R.color_bgColor001

                            CPText
                            {
                                text: "삭제"
                                color: "white"
                                font.pointSize: R.font_size_common_button
                                anchors
                                {
                                    verticalCenter: parent.verticalCenter
                                    horizontalCenter: parent.horizontalCenter
                                }
                            }

                            CPMouseArea
                            {
                                anchors.fill: parent
                                onEvtUIThreadWork:
                                {
                                    moveright.duration = 150;
                                    moveright.running = true;
                                }

                                onEvtClicked:
                                {
                                    prevLength = dLength;
                                    selectedIndex = index;
                                    alarm2("선택한 항목을 삭제하시겠습니까?");
                                    ap.setYMethod(mainView, "removePushItem");

                                }
                            }

                            Timer
                            {
                                running: prevLength > dLength
                                repeat: false
                                interval: 200
                                onTriggered:
                                {
                                    md.setShowIndicator(false);
                                }
                            }

                            anchors
                            {
                                right: parent.right//readRect.left
                            }
                        }

                        Rectangle
                        {
                            id: frontRect
                            width: parent.width
                            height: frontColumn.height + R.dp(80)
                            //                            color: "#55000000"

                            CPImage
                            {
                                id: finishedImage
                                width: R.dp(60)
                                height: R.dp(60)
                                visible: false
//                                source: opt.ds ? R.image("finished_gray") : (md.noticeList[index].isRead ? R.image("finished") : R.image("finished_gray"))
                                anchors
                                {
                                    verticalCenter: parent.verticalCenter
                                    left: parent.left
                                    leftMargin: R.margin_common
                                }
                            }

                            Column
                            {
                                id: frontColumn
                                width: parent.width
                                height: contentsItem.height + dateItem.height
                                anchors
                                {
                                    left: parent.left //finishedImage.right
                                    leftMargin: R.margin_common //* 0.5
                                    verticalCenter: parent.verticalCenter
                                }

                                Item
                                {
                                    id: contentsItem
                                    width: txtContents.width
                                    height: txtContents.height
                                    CPText
                                    {
                                        id: txtContents
                                        width: frontRect.width - R.margin_common * 4.5
                                        text: opt.ds ? title + index : md.alarmList[index].description
                                        font.pointSize: R.font_size_list_title
                                    }
                                }
                                LYMargin { height: R.dp(5) }
                                Item
                                {
                                    id: dateItem
                                    width: txtDate.width
                                    height: txtDate.height
                                    CPText
                                    {
                                        id: txtDate
                                        width: frontRect.width - R.margin_common * 2
                                        color: R.color_gray87//"gray"
                                        text: opt.ds ? writeDate : md.alarmList[index].writeDate
                                        font.pointSize: R.font_size_date
                                    }
                                }
                            }

                            Rectangle
                            {
                                color: "transparent"
                                anchors.fill: parent

                                ColorAnimation on color
                                {
                                    id: colorAnimation
                                    from: "#44000000"
                                    to: "transparent"
                                    duration: 200
                                    running: false
                                }
                            }

                            MouseArea
                            {
                                anchors.fill: parent
                                drag.target: frontRect
                                drag.axis: Drag.XAxis
                                drag.minimumX: - (/*showRect.width + */removeRect.height /*+ readRect.width*/)//rect.x === 0 ? -R.dp(400) : 0
                                drag.maximumX: 0//-R.dp(400)//rect.x === 0 ? 0 : -R.dp(400)

                                onReleased:
                                {
                                    var foldedState = opt.ds ? folded : md.alarmList[index].folded;
//                                    var leftCond = frontRect.x < -(showRect.width * 0.8);
                                    if(foldedState /*&& leftCond*/)
                                    {
                                        moveleft.running = true;
                                        if(opt.ds) folded = false;
                                        else md.alarmList[index].fold(false);
                                        return;
                                    }
                                    else
                                    {
                                        if(opt.ds) folded = true;
                                        else md.alarmList[index].fold(true);
                                        moveright.running = true;
                                    }
                                }

//                                onClicked:
//                                {
//                                    colorAnimation.running = true;
//                                    if(opt.ds) return;
//                                    tmNavi.running = true;
//                                }
                            }

                            Rectangle
                            {
                                id: arrowRect
                                width: parent.height - R.dp(40)
                                height: parent.height - R.dp(40)
                                color: "transparent"

                                CPImage
                                {
                                    id: arrowImg
                                    source: R.image("button_go")
                                    rotation: frontRect.x === - (/*showRect.width +*/ removeRect.width /*+ readRect.width */) ?  180 : 0
                                    width: R.dp(50)
                                    height: R.dp(50)
                                    anchors
                                    {
                                        verticalCenter: parent.verticalCenter
                                        horizontalCenter: parent.horizontalCenter
                                    }
                                }
                                anchors
                                {
                                    verticalCenter: parent.verticalCenter
                                    right: parent.right
                                    rightMargin: R.dp(20)
                                }

                                PropertyAnimation
                                {
                                    id: moveleft;
                                    target: frontRect;
                                    running: false
                                    property: "x";
                                    to: - (/*showRect.width +*/ removeRect.width /*+ readRect.width */ )
                                    duration: 200
                                }

                                PropertyAnimation
                                {
                                    id: moveright;
                                    target: frontRect;
                                    running: false
                                    property: "x";
                                    to: 0
                                    duration: 200
                                }

                                MouseArea
                                {
                                    anchors.fill: parent
                                    onClicked:
                                    {
                                        if(frontRect.x === 0) moveleft.running = true
                                        else moveright.running = true
                                    }
                                }
                            }
                        }

                        LYMargin
                        {
                            color: R.color_gray87
                            width: parent.width; height: R.height_line_1px
                            anchors
                            {
                                bottom: parent.bottom
                            }
                        }
                    }
                }
            }
        }
    }

    CPFlickMoreIndicator
    {
        width: parent.width
        height: R.dp(120)

        condRun: ENums.WORKING_PUSHNOTICE
        condStop: ENums.FINISHED_PUSHNOTICE

        anchors.bottom: parent.bottom
        visible: dLength > 0
    }

    function removePushItem()
    {
        tmRemovePushItem.running = true;
    }

    Timer
    {
        id: tmRemovePushItem
        running: false
        repeat: false
        interval: 200
        onTriggered:
        {
            wk.deleteMyAlarm(md.alarmList[selectedIndex].alarmNo);
            wk.request();
        }

    }

    function navi()
    {
//        cmd.readPushItem(md.noticeList[selectedIndex].no, true);
//        tmNavi.running = true;
    }

//    Timer
//    {
//        id: tmNavi
//        running: false
//        repeat: false
//        interval: 200
//        onTriggered:
//        {
//            var type = md.alarmList[selectedIndex].type;
//            switch(type)
//            {
//            case 1:
//            case 2:
//                pushHomeStack("ClipViewer");
//                break;
//            case 3:
//                pushHomeStack("NoticeDetail");
//                break;
//            case 4:
//                pushHomeStack("EventDetail");
//                break;
//            default: break;
//            }
//        }
//    }
}
