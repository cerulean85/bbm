import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "Resources.js" as R
import enums 1.0

PGPage {
    id: mainView
    visibleBackBtn: true
    visibleSearchBtn: false
    titleText: "포인트 내역"
    titleTextColor: "black"
    titleLineColor: "black"
    pageName: "PointHistory"
    useDefaultEvtBack: false
    onEvtBack:
    {
        md.clearPointSavedList();
        md.clearPointSpentList();

        clearView.running = true;
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

    Component.onCompleted:
    {
        if(opt.ds) return;

        clearCategoryButtons();
        md.catemysavelist[0].select(true);

        savedDataGetter.running = true;
    }

    Timer
    {
        id: savedDataGetter
        running: false
        repeat: false
        interval: 300
        onTriggered:
        {
            wk.getSavingDetail(1);
            wk.request();
        }
    }

    Timer
    {
        id: spentDataGetter
        running: false
        repeat: false
        interval: 300
        onTriggered:
        {
            wk.getSpendingDetail(1);
            wk.request();
        }
    }

    Timer
    {
        id: clearView
        running: false
        repeat: false
        interval: 100
        onTriggered:
        {
            popHomeStack();
        }
    }

    property int widthCategoryArea: topRect.width * 0.5
    property int heightCategoryArea: R.dp(137)

    property int savedLength : opt.ds ? 25 : md.pointSaveList.length
    property int savedItemHeight : R.dp(185)

    property int usedLength : opt.ds ? 25 : md.pointSpendList.length
    property int usedItemHeight : R.dp(185)

    property int selectedCategoryNo : 0

    Rectangle
    {
        id: topRect
        width: parent.width
        height: parent.height - mainView.heightStatusBar - mainView.heightBottomArea - R.height_titleBar
        color: R.color_grayED
        y: mainView.heightStatusBar + R.height_titleBar

        Rectangle
        {
            id: header
            width: parent.width
            height: R.dp(438)

            Column
            {
                width: parent.width
                height: parent.height

                LYMargin { height: R.dp(90) }
                Item
                {
                    width: parent.width
                    height: R.dp(115)
                    Item
                    {
                        width: R.dp(826)
                        height: R.dp(115)
                        anchors.horizontalCenter: parent.horizontalCenter

                        Rectangle
                        {
                            x: R.dp(7)
                            y: R.dp(7)
                            width: R.dp(816)
                            height: R.dp(105)
                            radius: 50
                            color: R.color_bgColor003
                        }
                        Rectangle
                        {
                            width: R.dp(816)
                            height: R.dp(105)
                            radius: 50
                            color: R.color_bgColor002

                            CPText
                            {
                                height: parent.height
                                text: selectedCategoryNo==0 ? "총 적립 포인트" : "총 소모 포인트"
                                font.pointSize: R.pt(40)
                                color: "white"
                                verticalAlignment: Text.AlignVCenter
                                anchors
                                {
                                    left : parent.left
                                    leftMargin : R.dp(50)
                                }
                            }

                            CPText
                            {
                                height: parent.height
                                text: (opt.ds ? "200" : md.myTotalSumPoint) + "pt."
                                font.pointSize: R.pt(40)
                                color: "white"
                                verticalAlignment: Text.AlignVCenter
                                anchors
                                {
                                    right : parent.right
                                    rightMargin : R.dp(50)
                                }
                            }
                        }
                    }
                }

                LYMargin { height: R.dp(35) }
                Item
                {
                    width: parent.width
                    height: R.dp(125)
                    Item
                    {
                        width: R.dp(826)
                        height: R.dp(125)
                        anchors.horizontalCenter: parent.horizontalCenter

                        Rectangle
                        {
                            x: R.dp(7)
                            y: R.dp(2)
                            width: R.dp(816)
                            height: R.dp(115)
                            radius: 50
                            color: R.color_bgColor003
                        }
                        Rectangle
                        {
                            width: R.dp(816)
                            height: R.dp(105)
                            radius: 50
                            color: R.color_bgColor001

                            CPText
                            {
                                height: parent.height
                                text: "보유 포인트"
                                font.pointSize: R.pt(45)
                                color: "white"
                                verticalAlignment: Text.AlignVCenter
                                anchors
                                {
                                    left : parent.left
                                    leftMargin : R.dp(50)
                                }
                            }

                            CPText
                            {
                                height: parent.height
                                text: (opt.ds ? "200" : md.myTotalHavePoint) + "pt."
                                font.pointSize: R.pt(45)
                                color: "white"
                                verticalAlignment: Text.AlignVCenter
                                anchors
                                {
                                    right : parent.right
                                    rightMargin : R.dp(50)
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle
        {
            width: parent.width
            height: topRect.height - header.height - R.dp(20)
            anchors
            {
                top: header.bottom
                topMargin: R.dp(20)
            }

            Column
            {
                id: tabRegion
                width: parent.width
                height: parent.height

                Rectangle
                {
                    id: categoryRect
                    width: parent.width
                    height: heightCategoryArea
                    color: "white"
                    Row
                    {
                        width: parent.width
                        height: parent.height
                        Repeater
                        {
                            model: opt.ds ? 2 : md.catemysavelist.length

                            Rectangle
                            {
                                width: widthCategoryArea; height: heightCategoryArea
                                color:"transparent"

                                Column
                                {
                                    width: widthCategoryArea; height: parent.height;
                                    LYMargin { height: R.dp(20)}
                                    CPText
                                    {
                                        font.pointSize: R.pt(45)
                                        //                                            font.bold: true
                                        width: widthCategoryArea
                                        height: heightCategoryArea - R.dp(20) - R.dp(6)
                                        text:
                                        {
                                            if(opt.ds) return "Untitled";

                                            if(index == 0) return "적립 내역";
                                            else return "사용 내역";
                                        }
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        color: "black"
                                    }
                                    Rectangle
                                    {
                                        width: widthCategoryArea; height: R.dp(6);
                                        color: opt.ds ? R.color_bgColor001 : (md.catemysavelist[index].selected ? R.color_theme01 : "#f5f6f6");
                                    }
                                }
                                MouseArea
                                {
                                    anchors.fill: parent
                                    onClicked:
                                    {
                                        if(opt.ds) return;
                                        if(md.catemysavelist[index].selected) return;

                                        clearCategoryButtons();
                                        md.catemysavelist[index].select(true);
                                        selectedCategoryNo = index;
                                        wk.setRefreshWorkResult(ENums.WORKING_HISTORY);

                                        if(index == 0)
                                        {
                                            mySavedRigion.visible = true;
                                            myUsedRigion.visible = false;
                                            md.clearPointSpentList();
                                            savedDataGetter.running = true;
                                        }
                                        else
                                        {
                                            mySavedRigion.visible = false;
                                            myUsedRigion.visible = true;
                                            md.clearPointSavedList();
                                            spentDataGetter.running = true;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                Rectangle
                {
                    id: marginRect2
                    width:parent.width
                    height:R.dp(10)
                    color:R.color_gray001
                }

                OpacityAnimator
                {
                    target: mySavedRigion;
                    from: 0;
                    to: 1;
                    duration: 500
                    running: mySavedRigion.visible
                }

                OpacityAnimator
                {
                    target: myUsedRigion;
                    from: 0;
                    to: 1;
                    duration: 500
                    running: myUsedRigion.visible
                }

                OpacityAnimator
                {
                    target: mySavedRigion;
                    from: 1;
                    to: 0;
                    running: !mySavedRigion.visible
                }

                OpacityAnimator
                {
                    target: myUsedRigion;
                    from: 1;
                    to: 0;
                    running: !myUsedRigion.visible
                }

                CPNoData
                {
                    width: parent.width
                    height: parent.height - heightCategoryArea - R.dp(10)
                    visible: opt.ds ? false : (savedLength == 0 && selectedCategoryNo == 0)
                    showText: true
                    message: opt.ds ? R.message_has_no_history_list : (wk.refreshWorkResult === ENums.FINISHED_HISTORY ? R.message_has_no_history_list : R.message_load_history_list)
                }

                CPNoData
                {
                    width: parent.width
                    height: parent.height - heightCategoryArea - R.dp(10)
                    visible: opt.ds ? false : (usedLength == 0 && selectedCategoryNo == 1)
                    showText: true
                    message: opt.ds ? R.message_has_no_history_list : (wk.refreshWorkResult === ENums.FINISHED_HISTORY ? R.message_has_no_history_list : R.message_load_history_list)
                }

                ListModel
                {
                    id: pointListModel
                    ListElement
                    {
                        point: 100
                        date: "2018-05-12 12:11:11"
                        type: 11
                        contents: "니ㅏㅇ러ㅣ나어린어ㅣㅏㄴ어핀아ㅓ패ㅑㄴ어패냐어패ㅑ넝패ㅑ젇패ㅑㅓㅈㄷ패ㅑㅓㅈㄷ패ㅑㅓㅈ대ㅑ펒대ㅑ퍼재ㅑㄷ퍼ㅐ쟈더패쟏런ㄹ야ㅓㅐㄴㅇ러ㅏㅐㄴㅇ랴ㅓㅐㄴㅇ랴ㅓㅐㅇㄴ러ㅐㅇㄹ내ㅑㅓㅇ입니다."
                    }
                    ListElement
                    {
                        point: 5000
                        date: "2018-05-12 12:11:11"
                        type: 12
                        contents: "니ㅏㅇ러ㅣ나어린어ㅣㅏ"
                    }
                    ListElement
                    {
                        point: 100
                        date: "2018-05-12 12:11:11"
                        type: 13
                        contents: "니ㅏㅇ러ㅣ나어린어ㅣㅏㄴ어핀아ㅓ패ㅑㄴ어패냐어패ㅑ넝패ㅑ젇패ㅑㅓㅈㄷ패ㅑㅓㅈㄷ패ㅑㅓㅈ대ㅑ펒대ㅑ퍼재ㅑㄷ퍼ㅐ쟈더패쟏런ㄹ야ㅓㅐㄴㅇ러ㅏㅐㄴㅇ랴ㅓㅐㄴㅇ랴ㅓㅐㅇㄴ러ㅐㅇㄹ내ㅑㅓㅇ입니다."
                    }
                    ListElement
                    {
                        point: 100
                        date: "2018-05-12 12:11:11"
                        type: 21
                        contents: "니ㅏㅇ러ㅣ나어린어ㅣㅏㄴ어핀아ㅓ패ㅑㄴ어패냐어패ㅑ넝패ㅑ젇패ㅑㅓㅈㄷ패ㅑㅓㅈㄷ패ㅑㅓㅈ대ㅑ펒대ㅑ퍼재ㅑㄷ퍼ㅐ쟈더패쟏런ㄹ야ㅓㅐㄴㅇ러ㅏㅐㄴㅇ랴ㅓㅐㄴㅇ랴ㅓㅐㅇㄴ러ㅐㅇㄹ내ㅑㅓㅇ입니다."
                    }
                    ListElement
                    {
                        point: 100
                        date: "2018-05-12 12:11:11"
                        type: 22
                        contents: "니ㅏㅇ러ㅣ나어린어ㅣㅏㄴ어핀아ㅓ패ㅑㄴ어패냐어패ㅑ넝패ㅑ젇패ㅑㅓㅈㄷ패ㅑㅓㅈㄷ패ㅑㅓㅈ대ㅑ펒대ㅑ퍼재ㅑㄷ"
                    }
                    ListElement
                    {
                        point: 100
                        date: "2018-05-12 12:11:11"
                        type: 31
                        contents: "니ㅏㅇ러ㅣ나어린어ㅣㅏㄴ어핀아ㅓ패ㅑㄴ어패냐어패ㅑ넝패ㅑ젇패ㅑㅓㅈㄷ패ㅑㅓㅈㄷ패ㅑㅓㅈ대ㅑ펒대ㅑ퍼재ㅑㄷ퍼ㅐ쟈더패쟏런ㄹ야ㅓㅐㄴㅇ러ㅏㅐㄴㅇ랴ㅓㅐㄴㅇ랴ㅓㅐㅇㄴ러ㅐㅇㄹ내ㅑㅓㅇ입니다."
                    }
                }

                Flickable
                {
                    id: mySavedRigion
                    width: parent.width
                    height: parent.height - heightCategoryArea - R.dp(10)
                    contentWidth: parent.width
                    contentHeight: /*savedItemHeight * savedLength*/ savedHistory.height  + R.dp(300)
                    maximumFlickVelocity: R.flickVelocity(savedHistory.height) //savedItemHeight * savedLength
                    clip: true
                    visible: opt.ds ? false : (savedLength > 0)
                    opacity: 0
                    boundsBehavior: Flickable.StopAtBounds
                    onMovementEnded:
                    {
                        if(opt.ds) return;
                        if(mySavedRigion.atYEnd)
                        {
                            if(savedLength % 20 == 0 && savedLength > 0)
                            {
                                wk.getSavingDetail(savedLength / 20 + 1);
                                wk.request();
                            }
                        }
                    }

                    Column
                    {
                        id: savedHistory
                        width: parent.width
                        //                            height: savedItemHeight * savedLength

                        Repeater
                        {
                            model : opt.ds ? pointListModel : savedLength

                            Column
                            {
                                width: parent.width
                                //                                    height: savedItemHeight

                                Rectangle
                                {
                                    width: parent.width
                                    height: savedItemPoint.height + savedItemTitle.height + R.dp(100) //+ savedItemHeight - R.height_line_1px
                                    color: "white"

                                    CPImage
                                    {
                                        id: savedItemType
                                        width: R.dp(60)
                                        height: R.dp(60)
                                        source:
                                        {
                                            var savedType = opt.ds ? type : md.pointSaveList[index].type
                                            switch(savedType)
                                            {
                                            case 11: return R.image("mypage_log_best"); /* 우수 댓글 포인트 */
                                            case 12: return R.image("mypage_log_like"); /* 좋아요 받은 사람 포인트 */
                                            case 13: return R.image("mypage_log_best");  /* 주간 좋아요 베스트 */
                                            case 21: return R.image("finished"); /* 과목 수강완료 포인트 */
                                            case 22: return R.image("finished"); /* 클립 수강완료 포인트 */
                                            case 31: return R.image("mypage_log_event");
                                            default: return R.image("mypage_log_etc");
                                            }
                                        }
                                        anchors
                                        {
                                            left: parent.left
                                            leftMargin: R.dp(70)
                                            verticalCenter: parent.verticalCenter
                                        }
                                    }

                                    CPText
                                    {
                                        id: savedItemPoint
                                        text: opt.ds ? ("[" + point + " POINT 적립]") : ("[" + md.pointSaveList[index].score+" POINT 적립]")
                                        font.pointSize: R.pt(35)
                                        color: R.color_bgColor001
                                        anchors
                                        {
                                            top: parent.top
                                            topMargin: R.dp(50)
                                            left: savedItemType.right
                                            leftMargin: R.dp(30)
                                        }
                                    }

                                    CPText
                                    {
                                        id: savedItemTitle
                                        width: parent.width - R.dp(230)
                                        //                                            height: R.dp(40)
                                        text: opt.ds ? (contents) : ("[" + md.pointSaveList[index].score+"pt.]" + md.pointSaveList[index].comment)
                                        font.pointSize: R.pt(35)
                                        anchors
                                        {
                                            top: savedItemPoint.bottom
                                            topMargin: R.dp(10)
                                            left: savedItemType.right
                                            leftMargin: R.dp(30)
                                        }
                                    }


                                    CPText
                                    {
                                        id: savedItemDate
                                        text: (opt.ds ? date : md.pointSaveList[index].date)
                                        font.pointSize: R.pt(35)
                                        color: R.color_gray87
                                        anchors
                                        {
                                            top: parent.top
                                            topMargin: R.dp(50)
                                            left: savedItemPoint.right
                                            leftMargin: R.dp(20)
                                        }

                                    }
                                }

                                LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_gray87 }
                            }


                        }
                    }

                }


                Flickable
                {
                    id: myUsedRigion
                    width: parent.width
                    height: parent.height - heightCategoryArea - R.dp(10)
                    contentWidth: parent.width
                    contentHeight: usedList.height  + R.dp(300)
                    maximumFlickVelocity: R.flickVelocity(usedList.height) //usedItemHeight * usedLength
                    clip: true
                    visible: opt.ds ? true : (usedLength > 0)
                    opacity: 0
                    boundsBehavior: Flickable.StopAtBounds
                    onMovementEnded:
                    {
                        if(opt.ds) return;
                        if(myUsedRigion.atYEnd)
                        {
                            if(usedLength % 20 == 0 && usedLength > 0)
                            {
                                wk.getSpendingDetail(usedLength / 20 + 1);
                                wk.request();
                            }
                        }
                    }

                    Column
                    {
                        id: usedList
                        width: parent.width

                        Repeater
                        {
                            model : opt.ds ? pointListModel : usedLength

                            Column
                            {
                                width: parent.width

                                Rectangle
                                {
                                    width: parent.width
                                    height: usedItemPoint.height + usedItemTitle.height + R.dp(100)
                                    color: "white"

                                    Item
                                    {
                                        id: usedItemBase
                                        width: 1; height: 1;
                                        anchors
                                        {
                                            verticalCenter: parent.verticalCenter
                                            horizontalCenter: parent.horizontalCenter
                                        }
                                    }

                                    CPImage
                                    {
                                        id: usedItemType
                                        width: R.dp(60)
                                        height: R.dp(60)
                                        source:
                                        {
                                            var savedType = opt.ds ? type : md.pointSpendList[index].type
                                            switch(savedType)
                                            {
                                            case 11: return R.image("write_article"); /* 우수 댓글 포인트 */
                                            case 21: return R.image("eye"); /* 과목 수강완료 포인트 */
                                            default: return R.image("mypage_log_etc");
                                            }
                                        }
                                        anchors
                                        {
                                            left: parent.left
                                            leftMargin: R.dp(70)
                                            verticalCenter: parent.verticalCenter
                                        }
                                    }

                                    CPText
                                    {
                                        id: usedItemPoint
                                        text: opt.ds ? ("[" + point + " POINT 소모]") : ("[" + md.pointSpendList[index].score+" POINT 소모]")
                                        font.pointSize: R.pt(35)
                                        color: R.color_bgColor001
                                        anchors
                                        {
                                            top: parent.top
                                            topMargin: R.dp(50)
                                            left: usedItemType.right
                                            leftMargin: R.dp(30)
                                        }
                                    }

                                    CPText
                                    {
                                        id: usedItemTitle
                                        width: parent.width - R.dp(230)
                                        text: opt.ds ? (contents) : ("[" + md.pointSpendList[index].score+"pt.]" + md.pointSpendList[index].comment)
                                        font.pointSize: R.pt(35)
                                        anchors
                                        {
                                            top: usedItemPoint.bottom
                                            topMargin: R.dp(10)
                                            left: usedItemType.right
                                            leftMargin: R.dp(30)
                                        }
                                    }


                                    CPText
                                    {
                                        id: usedItemDate
                                        text: (opt.ds ? date : md.pointSpendList[index].date)
                                        font.pointSize: R.pt(35)
                                        color: R.color_gray87
                                        anchors
                                        {
                                            top: parent.top
                                            topMargin: R.dp(50)
                                            left: usedItemPoint.right
                                            leftMargin: R.dp(20)
                                        }

                                    }
                                }

                                LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_gray87 }
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

        condRun: ENums.WORKING_HISTORY
        condStop: ENums.FINISHED_HISTORY

        anchors.bottom: parent.bottom

        visible:
        {
            if(mySavedRigion.visible && savedLength === 0) return false;
            else if(myUsedRigion.visible && usedLength === 0) return false;
            return true;
        }
    }

    function clearCategoryButtons()
    {
        for(var i=0; i<md.catemysavelist.length; i++)
        {
            md.catemysavelist[i].select(false);
        }
    }
}
