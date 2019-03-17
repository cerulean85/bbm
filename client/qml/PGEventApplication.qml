import QtQuick 2.11
import QtQuick.Controls 1.4
import QtQuick.Controls 2.4
import "Resources.js" as R
import enums 1.0

PGPage {

    id: mainView
    visibleSearchBtn: false
    titleText: "이벤트 신청하기"
    titleTextColor: "black"
    titleLineColor: "black"
    property int prizeType: opt.ds ? 1 : md.noticeDetail.prizeType
    visibleBackBtn: true

    property int itemHeight: R.dp(180)

    /* 1:일반이벤트, 2:텍스트입력만받음, 3:이미지입력만받음, 4:이미지와텍스트입력모두받음 */
    property int noPrize: md.noticeDetail.prizeNo

    property int selectedIndex: 0

    property string eventTitle: "이벤트 제목"
    property string eventContents: "이벤트 내용"
    property bool visibleFileAttachRegion: opt.ds ? true : (prizeType > 2)
    property bool visibleTextRegion: opt.ds ? true : (prizeType !== 3)

    function initialize()
    {
        if(opt.ds) return;
        md.clearFileStorage();
    }

    Component.onCompleted: initialize();
    onEvtInitData: {
        md.noticeDetail.setAppliedText("");
        md.noticeDetail.setAppliedImageUrl("");
    }

    CPTextButtonTrans
    {
        color: "white"
        width: R.height_titleBar + R.dp(100)
        height: R.height_titleBar - R.height_line_1px
        anchors
        {
            top: parent.top
            topMargin: settings.heightStatusBar
            right: parent.right
        }

        subColor: "#44000000"
        btnName: "완료"
        pointSize: R.pt(50)
        onClick:
        {
            if(opt.ds) return
            alarm2("이벤트를 신청하겠습니까?");
            ap.setYMethod(mainView, "upload");
        }
    }

    Flickable
    {
        width: parent.width
        height: parent.height - mainView.heightStatusBar - R.height_titleBar
        contentWidth : parent.width
        contentHeight: topArea.height + R.dp(300)
        clip: true

        boundsBehavior: Flickable.StopAtBounds
        y: mainView.heightStatusBar + R.height_titleBar

        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                R.hideKeyboard();
            }
        }

        Column
        {
            id: topArea
            width: parent.width

            LYMargin { height: R.dp(50) }

            Rectangle
            {
                id: attachRect
                width: parent.width; height: attachTxt.height
                visible: visibleFileAttachRegion

                CPText
                {
                    id: attachTxt
                    text: "첨부 파일(" + (opt.ds ? fileList.count : md.fileStorage.length) + ")"
                    font.pointSize: R.pt(45)
                    color: R.color_bgColor001
                    anchors
                    {
                        left: parent.left
                        leftMargin: R.dp(62)
                        verticalCenter: parent.verticalCenter
                    }
                    verticalAlignment: Text.AlignVCenter
                }

                LYMargin
                {
                    id: line1
                    height: R.height_line_1px; width: parent.width - attachTxt.width - R.dp(124) - R.dp(20)
                    color: R.color_bgColor001;
                    anchors
                    {
                        verticalCenter: parent.verticalCenter;
                        left: attachTxt.right
                        leftMargin: R.dp(20)
                    }
                }
            }

            Item
            {
                width: parent.width
                height: R.dp(350)
                visible: visibleFileAttachRegion

                Rectangle
                {
                    id: plusButton
                    width: R.dp(300)
                    height: R.dp(300)
                    border.width: R.height_line_1px
                    border.color: R.color_bgColor001
                    //                    color: R.color_gray001

                    anchors
                    {
                        left: parent.left
                        leftMargin: R.dp(62)
                        top: parent.top
                        topMargin: R.dp(20)
                    }

                    CPImage
                    {
                        width: parent.width * 0.6
                        height: parent.height * 0.6
                        source: R.image("file_plus")
                        anchors
                        {
                            verticalCenter: parent.verticalCenter
                            horizontalCenter: parent.horizontalCenter
                        }
                    }

                    CPMouseArea
                    {
                        width: parent.width
                        height: parent.height
                        onEvtClicked:
                        {
                            R.hideKeyboard();
                            imgSelector.show();
                            imgSelector.enabled = true;
                            imgSelector.enabledToHandle = true;
                        }
                    }
                }

                Flickable
                {
                    id: gallaryScv
                    width: parent.width - R.dp(124) - R.dp(300)
                    height: R.dp(300)
                    contentWidth: addedFilesView.width
                    contentHeight: R.dp(300)
                    clip: true

                    anchors
                    {
                        left: plusButton.right
                        leftMargin: R.dp(10)
                        top: parent.top
                        topMargin: R.dp(20)
                    }

                    Item
                    {
                        id: addedFilesView
                        width: addedFiles.width + R.dp(500)
                        height: R.dp(300)

                        Row
                        {
                            id: addedFiles
                            height: R.dp(300)
                            spacing: R.dp(10)

                            Repeater
                            {
                                model: opt.ds ? fileList : md.fileStorage.length
                                Rectangle
                                {
                                    width: R.dp(300)
                                    height: R.dp(300)
                                    border.width: R.height_line_1px * 1
                                    border.color: "black"
                                    color: R.color_gray001

                                    Item
                                    {
                                        id: basePos
                                        width: 1; height: 1;
                                        anchors
                                        {
                                            verticalCenter: parent.verticalCenter
                                            horizontalCenter: parent.horizontalCenter
                                        }
                                    }

                                    CPImage
                                    {
                                        id: noImage
                                        width: parent.width * 0.5
                                        height: parent.height * 0.5
                                        source: R.image("file")
                                        anchors
                                        {
                                            bottom: basePos.bottom
                                            bottomMargin: R.dp(-50)
                                            horizontalCenter: parent.horizontalCenter
                                        }
                                    }

                                    CPText
                                    {
                                        width: parent.width - R.dp(60)
                                        maximumLineCount: 1
                                        font.pointSize: R.pt(35)
                                        text: opt.ds ? fileName : md.fileStorage[index].fileName
                                        anchors
                                        {
                                            horizontalCenter: parent.horizontalCenter
                                            top: noImage.bottom
                                            topMargin: R.dp(20)

                                        }
                                    }

                                    CPImage
                                    {
                                        id: thumb
                                        width: parent.width - R.height_line_1px* 8
                                        height: parent.height - R.height_line_1px * 8
                                        source: opt.ds ? fileUrl : R.startsWithAndReplace(md.fileStorage[index].fileUrl, "https", "http")
                                        fillMode: Image.PreserveAspectCrop
                                        anchors
                                        {
                                            verticalCenter: parent.verticalCenter
                                            horizontalCenter: parent.horizontalCenter
                                        }

                                        Rectangle
                                        {
                                            width: parent.width
                                            height: parent.height
                                            color: "transparent"

                                            ColorAnimation on color{
                                                id: ccc2
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
                                                    ccc2.running = true
                                                    showBigImage.source = R.startsWithAndReplace((opt.ds ? fileUrl : md.fileStorage[index].fileUrl), "https", "http");
                                                    showBigImage.show();
                                                }
                                            }
                                        }
                                    }

                                    Rectangle
                                    {
                                        width: R.dp(100)
                                        height: R.dp(100)
                                        color: "#44000000"
                                        radius: 50

                                        anchors
                                        {
                                            top: parent.top
                                            topMargin: R.dp(10)
                                            right: parent.right
                                            rightMargin: R.dp(10)
                                        }


                                        ColorAnimation on color{
                                            id: ccc
                                            running: false
                                            from: "transparent"
                                            to: "#44000000"
                                            duration: 200
                                        }

                                        CPImage
                                        {
                                            width: R.dp(80)
                                            height: R.dp(80)
                                            source: R.image(R.btn_close_gray_image)
                                            anchors
                                            {
                                                verticalCenter: parent.verticalCenter
                                                horizontalCenter: parent.horizontalCenter
                                            }
                                        }
                                        MouseArea
                                        {
                                            anchors.fill: parent
                                            onClicked:
                                            {
                                                ccc.running = true
                                                selectedIndex = index;
                                                alarm2("선택한 이미지를 삭제하시겠습니까?");
                                                ap.setYMethod(mainView, "deleteImage");
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Item
            {
                width: parent.width
                height: R.height_line_1px * 2
                visible: visibleFileAttachRegion

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
            LYMargin
            {
                visible: visibleFileAttachRegion
                height: R.dp(50)
            }

            Rectangle
            {
                width: parent.width;
                height: attachTxt.height
                visible: visibleTextRegion

                CPText
                {
                    id: applyTxt2
                    text: "신청 내용"
                    font.pointSize: R.pt(45)
                    color: R.color_bgColor001
                    anchors
                    {
                        left: parent.left
                        leftMargin: R.dp(62)
                        verticalCenter: parent.verticalCenter
                    }
                    verticalAlignment: Text.AlignVCenter
                }

                LYMargin
                {
                    id: line3
                    height: R.height_line_1px; width: parent.width - applyTxt2.width - R.dp(124) - R.dp(20)
                    color: R.color_bgColor001;
                    anchors
                    {
                        verticalCenter: parent.verticalCenter;
                        left: applyTxt2.right
                        leftMargin: R.dp(20)
                    }
                }
            }
            LYMargin
            {
                visible: visibleTextRegion
                height: R.dp(10)
            }
            CPTextArea
            {
                id: textArea
                width: parent.width - R.dp(50) * 2
                height: R.dp(500)
                visible: visibleTextRegion
                anchors
                {
                    left: parent.left
                    leftMargin: R.dp(50)
                }
            }

            Item
            {
                width: parent.width
                height: R.height_line_1px * 2
                visible: visibleTextRegion
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

            LYMargin
            {
                visible: visibleTextRegion
                height: R.dp(50)
            }

            Rectangle
            {

                width: parent.width; height: attachTxt.height
                CPText
                {
                    id: applyTxt
                    text: "이벤트 내용"
                    font.pointSize: R.pt(45)
                    color: R.color_bgColor001
                    anchors
                    {
                        left: parent.left
                        leftMargin: R.dp(62)
                        verticalCenter: parent.verticalCenter
                    }
                    verticalAlignment: Text.AlignVCenter
                }

                LYMargin
                {
                    id: line2
                    height: R.height_line_1px; width: parent.width - applyTxt.width - R.dp(124) - R.dp(20)
                    color: R.color_bgColor001;
                    anchors
                    {
                        verticalCenter: parent.verticalCenter;
                        left: applyTxt.right
                        leftMargin: R.dp(20)
                    }
                }
            }

            LYMargin { height: R.dp(20) }
            CPImage
            {
                id: image
                width: parent.width - R.dp(124)
                source: opt.ds ? R.sample_image07 : md.noticeDetail.imageUrl
                anchors
                {
                    horizontalCenter: parent.horizontalCenter
                }
            }
            LYMargin { height: R.dp(20) }
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
                        text: opt.ds ? "내용입니당." : md.noticeDetail.contents
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
        }
    }

    CPIMGView
    {
        id: showBigImage
        opacity: 0
        width: parent.width
        height: parent.height
        enabled: false
    }

    PGIMGMethodSelector
    {
        id: imgSelector
        enabled: false
        directUpload: false
        width: parent.width
        height: parent.height
        showBasic:false
        onEvtCallback:
        {
            md.setShowIndicator(false);
            R.log("[PGCourseQuestionNew] selectedFileName: " + imgSelector.selectedFileName +", selectedFilePath: " + imgSelector.selectedFilePath);
            md.replaceFile(imgSelector.selectedFileName, imgSelector.selectedFilePath);
        }
    }

    onEvtBehaviorAndroidBackButton:
    {
        if(showBigImage.opacity === 1.0)
        {
            showBigImage.hide();
            return;
        }
        else if(imgSelector.enabled)
        {
            imgSelector.hide();
            return;
        }
        else evtBack();
    }

    function deleteImage()
    {
        md.clearFileStorage();
    }

    function upload()
    {
        fileUploader.running = true;
    }

    function empty()
    {

    }

    Timer
    {
        id: fileUploader
        running: false
        repeat: false
        interval: 300
        onTriggered:
        {
//            if(!compareCurrentPage(name)) return;

            switch(prizeType)
            {
            case 2:

                if(checkText())
                    eventApplier.running = true
                break;

            case 3:

                if(checkImage())
                    uploadImageFile();
                break;

           case 4:

               if(checkText() && checkImage())
                   uploadImageFile();
               break;
            }
        }
    }

    Timer
    {
        id: eventApplier
        running: opt.ds ? false : (wk.uploadResult === ENums.POSITIVE)
        repeat: false
        interval: 300
        onTriggered:
        {
//            if(!compareCurrentPage(name)) return;

            md.setShowIndicator(false);
            wk.volUploadResult();

            applier.running = true;
        }
    }

    Timer
    {
        id:applier
        running: false
        repeat: false
        interval: 200
        onTriggered:
        {
            wk.setApplyEvent(noPrize, textArea.txt, md.noticeDetail.appliedImageUrl);
            wk.request();
        }
    }

    Timer
    {
        running: opt.ds ? false : (wk.setApplyEventResult === ENums.NAGATIVE)
        repeat: false
        interval: 300
        onTriggered:
        {
            wk.vSetApplyEventResult();
            ap.setYMethod(mainView, "canceled");
        }
    }

    Timer
    {
        running: opt.ds ? false : (wk.setApplyEventResult === ENums.POSITIVE)
        repeat: false
        interval: 300
        onTriggered:
        {
            wk.vSetApplyEventResult();
            ap.setYMethod(mainView, "update");
        }
    }

    function checkText()
    {
        if(textArea.txt === "")
        {
            alarm("신청 내용을 입력하세요.");
            ap.setYMethod(mainView, "empty");
            return false;
        }
        return true;
    }

    function checkImage()
    {
        if(md.fileStorage.length < 1)
        {
            alarm("파일을 첨부하세요.");
            ap.setYMethod(mainView, "empty");
            return false;
        }
        return true;
    }

    function uploadImageFile()
    {
        var fileUrl = md.fileStorage[0].fileUrl;
        wk.uploadImageFile(fileUrl, 1);
        wk.request();
    }

    function canceled()
    {
        ap.setYMethod(mainView, "empty");
        md.noticeDetail.setAppliedImageUrl("");
        md.noticeDetail.setAppliedText("");
        md.clearFileStorage();
        evtBack();
    }

    Timer
    {
        id: updator
        running: false
        repeat: false
        interval: 200
        onTriggered:
        {
            wk.getApplyEventDetail(noPrize);
            wk.request();
            evtBack();
        }
    }

    function update()
    {
        updator.running = true;
    }
}
