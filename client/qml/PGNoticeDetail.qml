import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import "Resources.js" as R
import enums 1.0

PGPage {
    id: mainView
    visibleSearchBtn: false
    titleText: "공지사항"
    titleTextColor: "black"
    titleLineColor: "black"
    visibleBackBtn: true
    pageName: "NoticeDetail"

    property int itemHeight: R.dp(180)
    //    property int dLength : opt.ds ? 10 : md.repleList.length

    property int noBoard: opt.ds ? 0 : md.currentBoardNo
    property int noBoardArticle:  opt.ds ? 0 : md.currentBoardArticleNo

    property int heightImageRect: 0
    property int hieghtFileRect: 0

    property int selectedRepleNo: 0
    property int selectedBoardNo: 0
    property int selectedBoardArticleNo: 0

    property int heightFlick: 0
    property int noticeType: 0 /* 0: 시스템 공지사항, 1: 시스템 질의사항. */

    property int listIndex: 0

    onEvtInitData:
    {
        md.noticeList[listIndex].setViewCount(md.noticeList[listIndex].viewCount+1);
        md.clearNoticeDetail();
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
        dataGetter.running = true
    }

    Timer
    {
        id: dataGetter
        running: false
        repeat: false
        interval: 300
        onTriggered:
        {
            if(noBoard < 1 || noBoardArticle < 1)
            {
                setErrorMessage(R.message_has_no_article);
                hasNoArticle();
                return;
            }

            wk.getSystemNoticeDetail(noBoardArticle, noBoard);
            wk.request();
        }
    }

    Timer
    {
        running: opt.ds ? false : wk.getSystemNoticeDetailResult !== ENums.WAIT
        repeat: false
        interval: 300
        onTriggered:
        {
            if(wk.volGetSystemNoticeDetailResult() === ENums.NAGATIVE) hasNoArticle();
        }
    }

    Flickable
    {
        id: recentlyList
        width: parent.width
        height: parent.height - mainView.heightStatusBar - mainView.heightBottomArea - R.height_titleBar
        contentWidth : parent.width
        contentHeight: topArea.height+ inputComment.height + R.dp(300)
        clip: true

        boundsBehavior: Flickable.StopAtBounds
        y: mainView.heightStatusBar + R.height_titleBar

        Column
        {
            id: topArea
            width: parent.width

            LYMargin { height: R.dp(118); }
            Item
            {
                width: parent.width
                height: R.dp(52)
                CPText
                {
                    id: titleText
                    width: parent.width - R.dp(124)
                    height: parent.height
                    font.pointSize: R.pt(60)
                    text: opt.ds ? "안녕하세요 도라에몽입니다." : md.noticeDetail.title
                    anchors
                    {
                        horizontalCenter: parent.horizontalCenter
                    }
                }
            }

            LYMargin { height: R.dp(40) }
            Item
            {
                width: parent.width
                height: R.height_line_1px * 2
                LYMargin
                {
                    width: parent.width - R.dp(62)*2
                    height: parent.height
                    color: R.color_bgColor002
                    anchors
                    {
                        horizontalCenter: parent.horizontalCenter
                    }
                }
            }
            LYMargin { height: R.dp(20) }
            Item
            {
                width: parent.width
                height: R.dp(52)
                CPText
                {
                    id: articleInfo1
                    width: parent.width - R.dp(124)
                    height: parent.height
                    font.pointSize: R.pt(35)
                    color: R.color_gray87
                    text: opt.ds ? "도라에몽 | 2018-03-02 18:06:22" : (md.noticeDetail.nickname + " | " + md.noticeDetail.writeDate)
                    anchors
                    {
                        horizontalCenter: parent.horizontalCenter
                    }
                }


                CPTextButton
                {
                    id: boardReportBtn
                    width: R.dp(220)
                    height: R.dp(80)
                    color: "transparent"
                    subColor: R.color_gray001
                    txtColor: R.color_bgColor001
                    visible: (noticeType > 0) && (md.repleList[index].userNo > 0) && (md.noticeDetail.userNo > 0)
                    name: "신고하기"
                    pointSize: R.pt(40)
                    onClick:
                    {
                        if(!isLogined()) return;
                    }
                    anchors
                    {
                        right: parent.right
                        rightMargin: R.dp(62)
                    }
                }

                Row
                {
                    anchors
                    {
                        right: parent.right
                        rightMargin: R.dp(62)
                    }
                    visible: (noticeType > 0) && (opt.ds ? true : ((settings.noUser === md.noticeDetail.userNo) &&  (md.noticeDetail.userNo > 0)))
                    CPTextButton
                    {
                        id: boardModifyBtn
                        width: R.dp(150)
                        height: R.dp(80)
                        color: "transparent"
                        subColor: R.color_gray001
                        txtColor: R.color_bgColor001
                        name: "수정"
                        pointSize: R.pt(40)
                        onClick:
                        {
                            if(!isLogined()) return;
                        }
                        anchors
                        {
                            right: boardReportBtn.left
                        }
                    }
                    LYMargin { width: R.dp(10) }
                    CPText
                    {
                        text: "|"
                        height: R.dp(80)
                        font.pointSize: R.pt(40)
                        color: R.color_bgColor001
                        verticalAlignment: Text.AlignVCenter
                    }
                    LYMargin { width: R.dp(10) }
                    CPTextButton
                    {
                        id: boardRemoveBtn
                        width: R.dp(140)
                        height: R.dp(80)
                        color: "transparent"
                        subColor: R.color_gray001
                        txtColor: R.color_bgColor001
                        name: "삭제"
                        pointSize: R.pt(40)
                        onClick:
                        {
                            if(!isLogined()) return;
                        }
                        anchors
                        {
                            right: boardReportBtn.left
                        }
                    }
                }

            }
            Item
            {
                width: parent.width
                height: R.dp(52)
                CPText
                {
                    id: articleInfo2
                    width: parent.width - R.dp(124)
                    height: parent.height
                    font.pointSize: R.pt(35)
                    color: R.color_gray87
                    text: opt.ds ? "조회수 57122 | 댓글수 1824" : "조회수 " + (md.noticeDetail.viewCount+1) //+ " | 댓글수 " + md.noticeDetail.repleCount)
                    anchors
                    {
                        horizontalCenter: parent.horizontalCenter
                    }
                }
            }
            LYMargin { height: R.dp(72) }
            Row
            {
                id: row1
                width: parent.width
                height: contentTxt.height
                Item
                {
                    width: parent.width
                    height: contentTxt.height


                    CPText
                    {
                        id: contentTxt
                        text: opt.ds ? contentTxt.height + " 내용입니당."
                                     : md.noticeDetail.contents
                        width: parent.width - R.dp(124)
                        font.pointSize: R.pt(45)
                        anchors
                        {
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }

            ListModel
            {
                id: fileList

                ListElement {
                    fileUrl: "https://scontent-sjc3-1.cdninstagram.com/vp/eaf56aa30148a578e29d34631cb84968/5BB12F51/t51.2885-15/e35/26156236_123939068416546_2742507055683207168_n.jpg"
                    fileName: "송지효 사진1.png"
                }
                ListElement {
                    fileUrl: "http://kr.people.com.cn/NMediaFile/2017/0808/FOREIGN201708081338000326513010044.jpg"
                    fileName: "ㄴㅁㅇ리ㅏㅓㅁㄴ이런미앎닐ㅇㄴㅁㅇ리ㅓㅁㄴ이라송지효 사진2291fflflqwlqwf.png"
                }
                ListElement {
                    fileUrl: "https://0.soompi.io/wp-content/uploads/2018/04/04033103/Song-Ji-Hyo1.jpg"
                    fileName: "sdvsdv송지효 사진3.png"
                }
                ListElement {
                    fileUrl: "http://img.yonhapnews.co.kr/etc/inner/KR/2018/03/28/AKR20180328100900005_01_i.jpg"
                    fileName: "vdvvv송지효 사진4.png"
                }
                ListElement {
                    fileUrl: "https://0.soompi.io/wp-content/uploads/2018/04/04033103/Song-Ji-Hyo1.jpg"
                    fileName: "송지으아하아흐아하아랒다ㅐㅑㅐㄴ아래ㅏㄴㅇ래ㅏ효sd 사진5.png"
                }
            }

            ListModel
            {
                id: imageList

                ListElement {
                    fileUrl: "https://scontent-sjc3-1.cdninstagram.com/vp/eaf56aa30148a578e29d34631cb84968/5BB12F51/t51.2885-15/e35/26156236_123939068416546_2742507055683207168_n.jpg"
                    fileName: "송지효 사진1.png"
                }
                ListElement {
                    fileUrl: "http://kr.people.com.cn/NMediaFile/2017/0808/FOREIGN201708081338000326513010044.jpg"
                    fileName: "송지효 사진2.png"
                }
                ListElement {
                    fileUrl: "https://0.soompi.io/wp-content/uploads/2018/04/04033103/Song-Ji-Hyo1.jpg"
                    fileName: "송지효 사진3.png"
                }
                ListElement {
                    fileUrl: "http://img.yonhapnews.co.kr/etc/inner/KR/2018/03/28/AKR20180328100900005_01_i.jpg"
                    fileName: "송지효 사진4.png"
                }
                ListElement {
                    fileUrl: "https://0.soompi.io/wp-content/uploads/2018/04/04033103/Song-Ji-Hyo1.jpg"
                    fileName: "송지효 사진5.png"
                }
            }

            ListModel
            {
                id: commentList

                ListElement {
                    nickname: "송지효짱"
                    writeDate: "2018.05.11 13:11:00"
                    contents: "https://scontent-sjc3-1.cdninstagram.com/vp/eaf56aa30148a578e29d34631cb84968/5BB12F51/t51.2885-15/e35/26156236_123939068416546_2742507055683207168_n.jpg"
                    profile: "https://scontent-sjc3-1.cdninstagram.com/vp/eaf56aa30148a578e29d34631cb84968/5BB12F51/t51.2885-15/e35/26156236_123939068416546_2742507055683207168_n.jpg"

                }
                ListElement {
                    nickname: "송지효짱2"
                    writeDate: "2018.05.11 13:11:00"
                    contents: "http://kr.people.com.cn/NMediaFile/2017/0808/FOREIGN201708081338000326513010044.jpg"
                    profile: "http://kr.people.com.cn/NMediaFile/2017/0808/FOREIGN201708081338000326513010044.jpg"
                }
                ListElement {
                    nickname: "송지효짱3"
                    writeDate: "2018.05.11 13:11:00"
                    contents: "https://0.soompi.io/wp-content/uploads/2018/04/04033103/Song-Ji-Hyo1.jpg"
                    profile: "https://0.soompi.io/wp-content/uploads/2018/04/04033103/Song-Ji-Hyo1.jpg"
                }
                ListElement {
                    nickname: "송지효짱4"
                    writeDate: "2018.05.11 13:11:00"
                    contents: "http://img.yonhapnews.co.kr/etc/inner/KR/2018/03/28/AKR20180328100900005_01_i.jpg"
                    profile: "http://img.yonhapnews.co.kr/etc/inner/KR/2018/03/28/AKR20180328100900005_01_i.jpg"
                }
                ListElement {
                    nickname: "송지효짱5"
                    writeDate: "2018.05.11 13:11:00"
                    contents: "https://0.soompi.io/wp-content/uploads/2018/04/04033103/Song-Ji-Hyo1.jpg"
                    profile: "https://0.soompi.io/wp-content/uploads/2018/04/04033103/Song-Ji-Hyo1.jpg"
                }
            }

            Column
            {
                id: imageRect
                width: parent.width

                Repeater
                {
                    model: opt.ds ? imageList : md.noticeDetail.imageList.length

                    Column
                    {
                        width: imageRect.width
                        height: imageView.height + R.dp(20)

                        LYMargin { height: R.dp(20) }
                        Item
                        {
                            id: imageView
                            width: parent.width
                            height: img.height
                            visible: opt.ds ? true : md.noticeDetail.imageList.length > 0
                            enabled: opt.ds ? true : md.noticeDetail.imageList.length > 0

                            CPOSSpecifiedImage
                            {
                                id: img
                                dWidth: parent.width - R.dp(124)
                                source: opt.ds ? fileUrl : md.noticeDetail.imageList[index].fileUrl
                                anchors
                                {
                                    horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }
                    }
                }
            }

            LYMargin { height: R.dp(60) }

            Rectangle
            {
                id: attachRect
                width: parent.width; height: attachTxt.height
                CPText
                {
                    id: attachTxt
                    //                    height: parent.height
                    text: "첨부파일(" + (opt.ds ? fileList.count : md.noticeDetail.fileList.length) + ")"
                    font.pointSize: R.pt(45)
                    color: R.color_bgColor001
                    anchors
                    {
                        left: parent.left
                        leftMargin: R.dp(62)
                    }
                    verticalAlignment: Text.AlignVCenter
                }

                LYMargin
                {
                    id: line1
                    height: R.dp(10); width: parent.width - attachTxt.width - R.dp(124)
                    color: R.color_gray001;
                    anchors
                    {
                        verticalCenter: parent.verticalCenter;
                        left: attachTxt.right
                        leftMargin: R.dp(20)
                    }
                }
            }

            Rectangle
            {
                id: fileNoRect
                width: parent.width
                height: opt.ds ? (fileList.count === 0 ? tttx.height + R.dp(30) : 0) : (md.noticeDetail.fileList.length === 0 ? tttx.height + R.dp(30) : 0)

                CPText
                {
                    id: tttx
                    font.pointSize: R.pt(40)
                    visible: opt.ds ? (fileList.count === 0) : (md.noticeDetail.fileList.length === 0)
                    text: "첨부파일이 없습니다."
                    color: R.color_gray87
                    anchors
                    {
                        verticalCenter: parent.verticalCenter
                        horizontalCenter: parent.horizontalCenter
                    }
                }
            }

            Column
            {
                id: fileRect
                width: parent.width
                visible: opt.ds ? (fileList.count > 0) : (md.noticeDetail.fileList.length > 0)

                LYMargin { height: R.dp(30) }
                Repeater
                {
                    model: opt.ds ? fileList : md.noticeDetail.fileList.length

                    Column
                    {
                        width: fileRect.width

                        Rectangle
                        {
                            id: fileView
                            width: parent.width - R.dp(280)
                            height: R.dp(120)
                            color: "transparent"
                            visible: opt.ds ? true : md.noticeDetail.fileList.length > 0
                            enabled: opt.ds ? true : md.noticeDetail.fileList.length > 0

                            Row
                            {
                                width: parent.width
                                height: parent.height

                                LYMargin { width: R.dp(62) }
                                CPImage
                                {
                                    width: R.dp(60)
                                    height: R.dp(80)
                                    source: R.image("file")
                                }

                                LYMargin { width: R.dp(20) }

                                CPText
                                {
                                    text: opt.ds ? fileName : md.noticeDetail.fileList[index].fileName
                                    width: parent.width - R.dp(80)
                                    height: R.dp(80)
                                    font.pointSize: R.pt(35)
                                    maximumLineCount: 1
                                    verticalAlignment: Text.AlignVCenter
                                }

                                Rectangle
                                {
                                    width: R.dp(80)
                                    height: R.dp(80)

                                }
                            }

                            ColorAnimation on color {
                                id: colorAnimator
                                from: R.color_bgColor003
                                to: "#44000000"
                                running: false
                                duration: 300
                            }
                        }
                    }
                }
            }

            LYMargin { height: R.dp(30) }

            Rectangle
            {
                id: ccoommRectTTT
                width: parent.width; height: ccoommTxt.height
                visible: noticeType==0 ? false : true

                CPText
                {
                    id: ccoommTxt
                    //                    height: parent.height
                    text: "댓글(" + (opt.ds ? commentList.count : md.repleList.length) + ")"
                    font.pointSize: R.pt(45)
                    color: R.color_bgColor001
                    anchors
                    {
                        left: parent.left
                        leftMargin: R.dp(62)
                    }
                    verticalAlignment: Text.AlignVCenter
                }

                LYMargin
                {
                    id: line22
                    height: R.dp(10); width: parent.width - ccoommTxt.width - R.dp(124)
                    color: R.color_gray001;
                    anchors
                    {
                        verticalCenter: parent.verticalCenter;
                        left: ccoommTxt.right
                        leftMargin: R.dp(20)
                    }
                }
            }

            Rectangle
            {
                id: ccommNoRect
                width: parent.width
                height: opt.ds ? (commentList.count === 0 ? tttx.height + R.dp(30) : 0) : (md.repleList.length === 0 ? tttx.height + R.dp(30) : 0)
                visible: noticeType==0 ? false : true

                CPText
                {
                    id: ttttx
                    font.pointSize: R.pt(40)
                    visible: opt.ds ? (commentList.count === 0) : (md.repleList.length === 0)
                    text: "댓글이 없습니다."
                    color: R.color_gray87
                    anchors
                    {
                        verticalCenter: parent.verticalCenter
                        horizontalCenter: parent.horizontalCenter
                    }
                }
            }

            Column
            {
                id: ccommRect
                width: parent.width
                visible: (opt.ds ? (commentList.count > 0) : (md.repleList.length > 0)) && (noticeType !== 0)

                Repeater
                {
                    id: repeater
                    model: opt.ds ? commentList : md.repleList.length

                    Column
                    {
                        width: parent.width
                        height: commentItem.height

                        Rectangle
                        {
                            id: commentItem
                            width: parent.width
                            height: itemCol.height

                            Column
                            {
                                id: itemCol
                                width: parent.width

                                LYMargin { height: R.dp(50) }
                                Rectangle
                                {
                                    id: itemBox
                                    width: parent.width
                                    height: myProfileImage.height + timeTxt.height + contentsRect.height

                                    CPProfileImage
                                    {
                                        id: myProfileImage
                                        width: R.dp(112)
                                        height: R.dp(112)
                                        sourceImage: opt.ds ? R.image("user") : R.startsWithAndReplace(md.repleList[index].fileList[0].fileUrl, "https", "http")
                                        anchors
                                        {
                                            left: parent.left
                                            leftMargin: R.dp(84)
                                        }
                                    }

                                    /* 내 댓글일 때 표시. */
                                    Rectangle
                                    {
                                        id: myMarkView
                                        width: R.dp(10)
                                        height: R.dp(10)
                                        color: "black"
                                        radius: 50
                                        anchors
                                        {
                                            left: parent.left
                                            leftMargin: R.dp(74)
                                        }
                                        visible: opt.ds ? true : (md.repleList[index].userNo === settings.noUser?true:false)
                                    }

                                    CPImage
                                    {
                                        id: bestImg
                                        width: opt.ds ? R.dp(75) : (md.repleList[index].good === 0 ? 0 : R.dp(75))
                                        height: R.dp(40)
                                        source: R.image("best")
                                        anchors
                                        {
                                            left: parent.left
                                            leftMargin: R.dp(255)
                                            top: parent.top
                                            topMargin: R.dp(10)
                                        }
                                    }

                                    /* 닉네임. */
                                    Item
                                    {
                                        id: nicknameView
                                        width: nickRecentlyTxt.width
                                        height: nickRecentlyTxt.height
                                        anchors
                                        {
                                            left: bestImg.right
                                            leftMargin: bestImg.width > 0 ? R.dp(10) : 0
                                        }

                                        CPText
                                        {
                                            id: nickRecentlyTxt
                                            text: opt.ds ? ("꾸러기케로로롱 // " + index) : md.repleList[index].nickname
                                            font.pointSize: R.pt(45)
                                            //                                            font.bold: true
                                        }

                                        Rectangle
                                        {
                                            width: parent.width
                                            height: parent.height
                                            color: "transparent"


                                            ColorAnimation on color {
                                                id: ccc1
                                                running: false
                                                from: "#44000000"
                                                to: "transparent"
                                                duration: 300
                                            }

                                            MouseArea
                                            {
                                                anchors.fill: parent
                                                onClicked:
                                                {
                                                    R.hideKeyboard();
                                                    ccc1.running = true;
                                                    if(opt.ds) return;

                                                    showProfile.running = true;
                                                }
                                            }
                                        }
                                    }

                                    CPText
                                    {
                                        id: timeTxt
                                        height: R.dp(80)
                                        text: opt.ds ? "3분 전" : md.repleList[index].writeDate
                                        font.pointSize: R.pt(40)
                                        color: R.color_gray87
                                        verticalAlignment: Text.AlignVCenter
                                        anchors
                                        {
                                            left: bestImg.left
                                            top: nicknameView.bottom
                                        }
                                    }

                                    CPTextButton
                                    {
                                        id: funcBtn
                                        width: R.dp(200)
                                        height: R.dp(80)
                                        color: "transparent"
                                        subColor: R.color_gray001
                                        txtColor: R.color_bgColor001
                                        visible: md.repleList[index].userNo > 0
                                        name: opt.ds ? "신고하기" : (md.repleList[index].userNo === settings.noUser ? "삭제하기" : "신고하기")
                                        pointSize: R.pt(40)
                                        onClick:
                                        {
                                            if(!isLogined()) return;

                                            selectedRepleNo        = md.repleList[index].repleNo;
                                            selectedBoardNo        = md.repleList[index].boardNo;
                                            selectedBoardArticleNo = md.repleList[index].boardArticleNo;

                                            if(md.repleList[index].userNo === settings.noUser)
                                            {
                                                R.log("댓글 삭제하기");
                                                ap.setVisible(true);
                                                ap.setMessage("댓글을 삭제하시겠습니까?");
                                                ap.setYButtonName("예");
                                                ap.setNButtonName("아니오");
                                                ap.setButtonCount(2);
                                                ap.setYMethod(flick, "deleteComment");
                                            }
                                            else
                                            {
                                                commentReport.show();
                                            }
                                        }
                                        anchors
                                        {
                                            left: timeTxt.right
                                            leftMargin: R.dp(20)
                                            bottom: timeTxt.bottom
                                        }
                                    }

                                    Rectangle
                                    {
                                        id: contentsRect
                                        width: parent.width - R.dp(340)
                                        height: fontMetrics.height * contentsTxt.lineCount
                                        color: "transparent"

                                        CPText
                                        {
                                            id: contentsTxt
                                            width: parent.width
                                            text:
                                                opt.ds ?
                                                    contents
                                                  : md.repleList[index].contents
                                            font.pointSize: R.pt(40)
                                            maximumLineCount: 3
                                        }

                                        FontMetrics {
                                            id: fontMetrics
                                            font.pointSize: R.pt(40)
                                        }

                                        anchors
                                        {
                                            left: nicknameView.left
                                            top: timeTxt.bottom
                                            topMargin: R.dp(20)
                                        }

                                        ColorAnimation on color {
                                            id: colorAnimator111
                                            from: R.color_gray001
                                            to: "transparent"
                                            running: false
                                            duration: 100
                                        }

                                        /* 전문보기/댓글수정하기 */
                                        MouseArea
                                        {
                                            anchors.fill: parent
                                            onClicked:
                                            {
                                                R.hideKeyboard();
                                                colorAnimator111.running = true;

                                                if(opt.ds || settings.noUser === md.repleList[index].userNo)
                                                {
                                                    commentShowAll.targetTxt = commentList.get(index).contents;
                                                    commentShowAll.show();
                                                }
                                                else
                                                {
                                                    commentModify.targetTxt = commentList.get(index).contents;
                                                    commentModify.show();
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            LYMargin {
                                id: bottomLine
                                width: parent.width; height: R.height_line_1px; color: R.color_grayE1
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
    }

    Rectangle
    {
        id: inputComment
        width: parent.width
        height: R.dp(215)
        visible: noticeType == 0 ? false : true
        anchors
        {
            bottom: parent.bottom
        }

        Rectangle
        {
            id: commentFieldRect
            width: parent.width - confirmButton.width
            height: parent.height

            CPTextField
            {
                id: commentField
                width: commentFieldRect.width
                height: parent.height
                placeholderText: "내용을 입력해 주세요."
                font.pointSize: R.pt(45)
                anchors
                {
                    left: parent.left
                    leftMargin: R.dp(50)
                }
            }
        }

        Rectangle
        {
            id: confirmButton
            width: R.dp(275)
            height: parent.height
            color: R.color_bgColor001
            anchors
            {
                right: parent.right
            }

            CPText
            {
                font.pointSize: R.pt(45)
                width: parent.width
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: "확인"
                color: "white"
            }

            ColorAnimation on color {
                id: commentInputAnimator
                from: R.color_bgColor003
                to: R.color_bgColor001
                running: false
                duration: 100
            }

            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    commentField.text = "";
                    commentInputAnimator.running = true
                }
            }
        }

        LYMargin { width: parent.width; height: R.height_line_1px*4; color: R.color_gray001 }
    }

    CPBoardCommentShowAll
    {
        id: commentShowAll
        width: parent.width
        height: parent.height
    }

    CPBoardCommentModify
    {
        id: commentModify
        width: parent.width
        height: parent.height
    }

    CPBoardCommentReport
    {
        id:commentReport
        width: parent.width
        height: parent.height
    }

    CPIMGView
    {
        id: showBigImage
        opacity: 0
        width: parent.width
        height: parent.height
    }

    Timer
    {
        id: showProfile
        running: false
        repeat: false
        interval: 300
        onTriggered:
        {
            if(md.repleList[selectedIndex].userNo < 1)
            {
                alarm(R.message_withdraw_user);
                return;
            }
            pushHomeStack("OtherProfile", { "targetUserNo": md.repleList[selectedIndex].userNo });
        }
    }

    onEvtBehaviorAndroidBackButton:
    {
        if(commentShowAll.opacity === 1.0)
        {
            commentShowAll.hide();
            return;
        }
        else if(commentModify.opacity === 1.0)
        {
            commentModify.hide();
            return;
        }
        else if(commentReport.opacity === 1.0)
        {
            commentReport.hide();
            return;
        }
        else if(showBigImage.opacity === 1.0)
        {
            showBigImage.hide();
            return;
        }
        else evtBack();
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

    function isLogined()
    {
        if(!logined())
        {
            alarmNeedLogin();
            return false;
        }
        return true;
    }

    function deleteComment()
    {
        R.log("댓글 삭제하기~");
        selectedBoardNo = md.repleList[selectedIndex].boardNo;
        selectedBoardArticleNo = md.repleList[selectedIndex].boardArticleNo;
        wk.deleteClip(selectedBoardArticleNo, selectedBoardNo);
        wk.request();
    }
}
