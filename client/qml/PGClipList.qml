import QtQuick 2.9
import "Resources.js" as R
import QtQuick.Controls 2.2
import enums 1.0

PGPage
{
    id: mainView
    titleText: opt.ds ? "일러스트 기초" : md.courseDetail.serviceTitle
    titleTextColor: "black"
    titleLineColor: "black"
    visibleBackBtn: true
    visibleSearchBtn: true
    searchImg: R.image("mypage")
    forceAlignHCenter: false
    colorBottomArea: R.color_bgColor001
    pageName: "ClipList"

    onEvtSearch: showMyPage(true);

    onEvtInitData: md.clearClipList();
    Component.onCompleted:
    {
        if(opt.ds) return;
        dataGetter.running = true
        printPageInfo();
    }

    Timer
    {
        id: dataGetter
        running: false
        repeat: false
        interval: 300
        onTriggered:
        {
            if(md.courseDetail.courseNo < 0)
            {
                R.log("Where: PGClipList.qml >> courseNo < 0");
                popHomeStack();
            }
            wk.getClipList(md.courseDetail.courseNo);
            wk.request();
        }
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

    Timer
    {
        running: opt.ds ? false : (md.cantLoadContent === true)
        repeat: false
        onTriggered:
        {
            md.setCantLoadContent(false);

            alarm(R.message_cant_load_content);
            ap.setYMethod(mainView, "empty");

        }
    }

    property int itemMargin: R.dp(50)
    property int widthRowItem: (mainView.width - itemMargin * 3) * 0.5//R.dp(512)
    property int heightRowItem: widthRowItem + R.dp(120)//R.dp(600)
    property int heightImageView: widthRowItem - R.dp(96)//R.dp(28)
    property int dLength : opt.ds ? 40 : md.clipList.length
    property int rowItemLength : (dLength / 2 + (dLength % 2 == 1 ? 1 : 0))
    property bool enabledDelivery: opt.ds ? false : (md.courseDetail.deliveryFlag < 1 ? true : false)

    CPNoData
    {
        id: noDataRect
        width: parent.width
        height: parent.height - mainView.heightStatusBar - R.height_titleBar - mainView.heightBottomArea
        y: mainView.heightStatusBar + R.height_titleBar
        visible: opt.ds ? true : (dLength === 0)
        showText: true
        message: opt.ds ? R.message_has_no_clip_list : (wk.refreshWorkResult === ENums.FINISHED_CLIPLIST ? R.message_has_no_clip_list : R.message_load_clip_item_list)
        tMargin: R.dp(100)
    }

    Flickable
    {
        id: flick
        width: mainView.width
        height: parent.height - mainView.heightStatusBar - R.height_titleBar - mainView.heightBottomArea - deliveryButton.height
        contentWidth : mainView.width
        contentHeight: mainColumn.height  + deliveryButton.height //+ R.height_titleBar + deliveryButton.height + settings.heightStatusBar
        maximumFlickVelocity: R.flickVelocity(mainColumn.height)
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        y: (opt.ds ? R.dp(44) : settings.heightStatusBar) + R.height_titleBar

        Column
        {
            id: mainColumn
            width: parent.width

            LYMargin { height: itemMargin }
            Repeater
            {
                model: rowItemLength

                Row
                {
                    width: mainColumn.width

                    LYMargin { width: itemMargin }

                    /* 왼쪽 리스트 아이템 */
                    Rectangle
                    {
                        width: widthRowItem
                        height: columnLeft.height + R.dp(70)

                        Column
                        {
                            id: columnLeft
                            width: parent.width
                            visible: (2 * index) >= dLength ? false : true

                            Rectangle
                            {
                                id: imageView1
                                width: parent.width
                                height: heightImageView //- R.dp(96)//R.dp(388)
                                color: R.color_gray001

                                CPImageView
                                {
                                    id: thumbLeft
                                    width: parent.width
                                    height: parent.height
                                    animateCond:
                                    {
                                        if(index < 5) return true;
                                        else
                                        {
                                            if(opacityValue < 0.5 ) return (flick.contentY > R.dp(800) + heightRowItem * (index-5))
                                            return false;
                                        }
                                    }
                                    src :
                                    {
                                        var correctIndex = 2*index;
                                        if(correctIndex >= dLength) return "";
                                        return opt.ds ? R.image("no_image") : md.clipList[correctIndex].imageUrl
                                    }
                                }

                                Rectangle
                                {
                                    width: R.dp(80)
                                    height: R.dp(80)
                                    color: "transparent"

                                    anchors
                                    {
                                        top: parent.top
                                        topMargin: R.dp(20)
                                        right: parent.right
                                        rightMargin: R.dp(20)
                                    }

                                    CPImage
                                    {
                                        width: parent.width
                                        height: parent.height
                                        source:
                                        {
                                            var correctIndex = 2 * index;
                                            if(correctIndex >= dLength || !logined()) return "";
                                            return (md.clipList[correctIndex].attendanceCode===1 ? R.image("finished") : "");
                                        }
                                    }
                                }
                            }

                            LYMargin { height: R.dp(24) }
                            Rectangle
                            {
                                width: parent.width
                                height: titleTxt1.height + R.dp(40) + R.dp(20) //heightRowItem - imageView1.height
                                color: "transparent"

                                CPText
                                {
                                    id: titleTxt1
                                    text:
                                    {
                                        var correctIndex = 2 * index;
                                        if(correctIndex >= dLength) return "";
                                        return opt.ds ? "하늘이 노오랗게 물들 즈음에, 너는 지금 어디 있을까? 그리고 나는 또 그 때 어디에서 너를 그리워하고 있을까?" : md.clipList[correctIndex].title
                                    }
                                    font.pointSize: R.pt(40)
                                    width: widthRowItem // - R.dp(132) //R.dp(380)
//                                    height: parent.height
                                    anchors
                                    {
                                        left: parent.left
                                        top: parent.top
                                    }
                                    maximumLineCount: 3
                                }

                                /* 조회수 */
                                CPText
                                {
                                    id: viewCount1
                                    text:
                                    {
                                        if(opt.ds) return "조회수 200000";
                                        var correctIndex = 2*index;
                                        if(correctIndex >= dLength) return "";
                                        return "조회수 " + md.clipList[correctIndex].viewCount
                                    }
                                    font.pointSize: R.pt(30)
                                    color: R.color_gray88
                                    anchors
                                    {
                                        left: parent.left
                                        top: titleTxt1.bottom
                                        topMargin: R.dp(20)
                                    }
                                    horizontalAlignment: Text.AlignRight
                                }

                                /* 좋아요 */
                                Item
                                {
                                    width: R.dp(150)
                                    height: R.dp(40)

                                    anchors
                                    {
                                        top: titleTxt1.bottom
                                        topMargin: R.dp(20)
                                        right: parent.right
                                        rightMargin: R.dp(30)
                                    }

                                    /* 좋아요 텍스트 */
                                    CPText
                                    {
                                        id: likeCount1
                                        text:
                                        {
                                            var correctIndex = 2*index;
                                            if(correctIndex >= dLength) return "";
                                            return opt.ds ? "352" : md.clipList[correctIndex].likeCount
                                        }
                                        color: R.color_gray88
                                        font.pointSize: R.pt(30)
                                        anchors
                                        {
                                            verticalCenter: parent.verticalCenter
                                            right: parent.right
                                        }
                                        verticalAlignment: Text.AlignVCenter
                                    }

                                    /* 좋아요 이미지 */
                                    CPImage
                                    {
                                        width: R.dp(40)
                                        height: R.dp(40)
                                        source: R.image("mypage_like_pink")
                                        anchors
                                        {
                                            verticalCenter: parent.verticalCenter
                                            right: likeCount1.left
                                            rightMargin: R.dp(15)
                                        }
                                    }
                                }
                            }
                        }

                        Rectangle
                        {
                            width: parent.width + R.dp(40)
                            height: parent.height - R.dp(20)
                            anchors
                            {
                                left: parent.left
                                leftMargin: R.dp(-20)
                                top: parent.top
                                topMargin: R.dp(-20)
                            }
                            color: "transparent"

                            ColorAnimation on color {
                                id: colorAnimator1
                                from: "#44000000"
                                to: "transparent"
                                running: false
                                duration: 100
                            }

                            MouseArea
                            {
                                anchors.fill: parent
                                onClicked:
                                {
                                    var correctIndex = 2*index;
                                    if(correctIndex >= dLength) return;

//                                    colorAnimator1.running = true;
                                    if(opt.ds) return;
                                    showIndicator(true);
                                    goToViewerLeft.running = true;
                                }
                            }

                            Timer
                            {
                                id: goToViewerLeft
                                running: false
                                repeat: false
                                interval: 300
                                onTriggered:
                                {
                                    var correctIndex = 2*index;
                                    var clipNo = md.clipList[correctIndex].lessonSubitemNo;
                                    var courseNo = md.courseDetail.courseNo
                                    pushClipViewer(clipNo, courseNo, correctIndex, R.viewer_from_desk);
                                }
                            }
                        }
                    }
                    LYMargin { width: itemMargin }

                    /* 오른쪽 리스트 아이템 */
                    Rectangle
                    {
                        width: widthRowItem
                        height: columnRight.height + R.dp(70)

                        Column
                        {
                            id: columnRight
                            width: parent.width
//                            height: parent.height
                            visible: (2 * index + 1) >= dLength ? false : true

                            Rectangle
                            {
                                id: imageView2
                                width: parent.width
                                height: heightImageView  //- R.dp(96)//R.dp(388)
                                color: R.color_gray001

                                CPImageView
                                {
                                    width: parent.width
                                    height: parent.height
                                    animateCond:
                                    {
                                        if(index < 5) return true;
                                        else
                                        {
                                            if(opacityValue < 0.5 ) return (flick.contentY > R.dp(800) + heightRowItem * (index-5))
                                            return false;
                                        }
                                    }
                                    src :
                                    {
                                        var correctIndex = 2*index+1;
                                        if(correctIndex >= dLength) return "";
                                        return opt.ds ? R.image("no_image") : md.clipList[correctIndex].imageUrl
                                    }
                                }

                                Rectangle
                                {
                                    width: R.dp(80)
                                    height: R.dp(80)
                                    color: "transparent"

                                    anchors
                                    {
                                        top: parent.top
                                        topMargin: R.dp(20)
                                        right: parent.right
                                        rightMargin: R.dp(20)
                                    }

                                    CPImage
                                    {
                                        width: parent.width
                                        height: parent.height
                                        source:
                                        {
                                            var correctIndex = 2*index+1;
                                            if(correctIndex >= dLength || !logined()) return "";
                                            return (md.clipList[correctIndex].attendanceCode===1 ? R.image("finished") : "");
                                        }
                                    }
                                }
                            }

                            LYMargin { height: R.dp(24) }
                            Rectangle
                            {
                                width: parent.width
                                height: titleTxt.height + R.dp(40) + R.dp(20) //heightRowItem - imageView1.height
                                color: "transparent"

                                /* 제목 */
                                CPText
                                {
                                    id: titleTxt
                                    text:
                                    {
                                        var correctIndex = 2*index+1;
                                        if(correctIndex >= dLength) return "";
                                        return opt.ds ? "Untitled12312312312" : md.clipList[correctIndex].title
                                    }
                                    font.pointSize: R.pt(40)
                                    width: widthRowItem  //- R.dp(132) //R.dp(380)
//                                    height: heightRowItem - imageView2.height
                                    maximumLineCount: 3
                                    anchors
                                    {
                                        left: parent.left
                                        top: parent.top
                                    }
                                }

                                /* 조회수 */
                                CPText
                                {
                                    id: viewCount
                                    text:
                                    {
                                        var correctIndex = 2*index+1;
                                        if(correctIndex >= dLength) return "";
                                        return "조회수 " + (opt.ds ? "20000" : md.clipList[correctIndex].viewCount)
                                    }
                                    font.pointSize: R.pt(30)
                                    color: R.color_gray88
                                    anchors
                                    {
                                        left: parent.left
                                        top: titleTxt.bottom
                                        topMargin: R.dp(20)
                                    }
                                    horizontalAlignment: Text.AlignRight
                                }

                                Item
                                {
                                    width: R.dp(150)
                                    height: R.dp(40)

                                    anchors
                                    {
                                        top: titleTxt.bottom
                                        topMargin: R.dp(20)
                                        right: parent.right
                                        rightMargin: R.dp(30)
                                    }

                                    /* 좋아요 텍스트 */
                                    CPText
                                    {
                                        id: likeCount
                                        text:
                                        {
                                            var correctIndex = 2*index+1;
                                            if(correctIndex >= dLength) return "";
                                            return opt.ds ? "352" : md.clipList[correctIndex].likeCount
                                        }
                                        color: R.color_gray87
                                        font.pointSize: R.pt(30)
                                        anchors
                                        {
                                            verticalCenter: parent.verticalCenter
                                            right: parent.right
                                        }
                                    }

                                    /* 좋아요 이미지 */
                                    CPImage
                                    {
                                        width: R.dp(40)
                                        height: R.dp(40)
                                        source: R.image("mypage_like_pink")
                                        anchors
                                        {
                                            verticalCenter: parent.verticalCenter
                                            right: likeCount.left
                                            rightMargin: R.dp(15)
                                        }
                                    }
                                }
                            }
                        }

                        Rectangle
                        {
                            width: parent.width + R.dp(40)
                            height: parent.height - R.dp(20)
                            anchors
                            {
                                left: parent.left
                                leftMargin: R.dp(-20)
                                top: parent.top
                                topMargin: R.dp(-20)
                            }
                            color: "transparent"

                            ColorAnimation on color {
                                id: colorAnimator2
                                from: "#44000000"
                                to: "transparent"
                                running: false
                                duration: 100
                            }
                            MouseArea
                            {
                                anchors.fill: parent
                                onClicked:
                                {
                                    var correctIndex = 2*index+1;
                                    if(correctIndex >= dLength) return;

                                    if(opt.ds) return;
                                    showIndicator(true);
                                    goToViewerRight.running = true;

                                }
                            }

                            Timer
                            {
                                id: goToViewerRight
                                running: false
                                repeat: false
                                interval: 300
                                onTriggered:
                                {
                                    var correctIndex = 2*index+1;
                                    var clipNo = md.clipList[correctIndex].lessonSubitemNo;
                                    var courseNo = md.courseDetail.courseNo;
                                    pushClipViewer(clipNo, courseNo, correctIndex, R.viewer_from_desk);
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    CPTextButton
    {
        id: deliveryButton
        name: opt.ds ? "딜리버리 신청하기" : (md.courseDetail.deliveryFlag < 1 ? "딜리버리 서비스 신청" : "딜리버리 서비스 이용 중인 강좌입니다.")
        pointSize: opt.ds ? R.pt(45) : settings.fontSizeDeliveryBtn
        anchors
        {
            bottom: parent.bottom
            bottomMargin: opt.ds? R.dp(44) : settings.heightBottomArea
        }
        width: parent.width
        height: R.dp(160)
        //        visible: md.courseDetail.deliveryFlag < 1 ? true : false
        enabled: md.courseDetail.deliveryFlag < 1 ? true : false
        onClick:
        {
            if(opt.ds) return;

            if(!logined())
            {
                alarmNeedLogin();
                return;
            }

//            showIndicator(true);
            enrollDelivery();
        }
    }

    Timer
    {
        running: opt.ds ? false : wk.setDeliveryServiceResult !== ENums.WAIT
        repeat: false
        interval: 100
        onTriggered:
        {
            showIndicator(false);
            if(wk.volSetDeliveryServiceResult() === ENums.POSITIVE)
            {
                var message = "";
                if(md.deliveryFlag === 1)
                {
                    alarm("딜리버리 서비스 신청을 완료하였습니다.");
                    disableDeliveryButton();
                    return;
                }
                else if(md.deliveryFlag === 4)
                {
                    alarm("딜리버리 서비스 신청을 완료하였습니다. 첫 클립부터 딜리버리 됩니다.")
                    disableDeliveryButton();
                    return;
                }
                else if(md.deliveryFlag === 5 || md.deliveryFlag === 6)
                {
                    ap.setVisible(true);
                    ap.setMessage("기존에 딜리버리 신청한 과목이 있습니다. 이 과목으로 딜리버리 신청을 하시겠습니까?");
                    ap.setButtonCount(2);
                    ap.setYButtonName("예");
                    ap.setNButtonName("아니오");
                    ap.setYMethod(mainView, "confirmDelivery");
                    return;
                }
                else alarm("알 수 없는 오류가 발생하였습니다.");
            } else error();
        }
    }

    Timer
    {
        running: opt.ds ? false : wk.setDeliveryServiceConfirmResult !== ENums.WAIT
        repeat: false
        onTriggered:
        {
            showIndicator(false);
            if(wk.volSetDeliveryServiceConfirmResult() === ENums.POSITIVE)
            {
                alarm("딜리버리 신청을 완료하였습니다.");
                disableDeliveryButton();
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
            mainView.forceActiveFocus();
        }
    }

    function enrollDelivery()
    {
        wk.setPushkey();
        wk.setDeliveryService(md.courseDetail.courseNo);
        wk.request();
    }

    function confirmDelivery()
    {
        showIndicator(true);
        wk.setPushkey();
        wk.setDeliveryServiceConfirm(md.courseDetail.courseNo);
        wk.request();
    }

    function disableDeliveryButton()
    {
        //                deliveryButton.visible = false;
        deliveryButton.enabled = false;
        deliveryButton.name = "딜리버리 서비스 이용 중인 강좌입니다."
    }
}
