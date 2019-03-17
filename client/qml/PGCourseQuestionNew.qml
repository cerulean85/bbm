import QtQuick 2.11
import QtQuick.Controls 1.4
import QtQuick.Controls 2.4
import "Resources.js" as R
import enums 1.0

PGPage {

    id: mainView
    visibleSearchBtn: false
    titleText: "질문하기"
    titleTextColor: "black"
    titleLineColor: "black"
    property int editType: 0 /* 0: 추가, 1: 수정 */
    visibleBackBtn: true

    property int itemHeight: R.dp(180)

    property int noBoard: 0
    property int noBoardArticle: 0
    property int selectedIndex: 0

    useDefaultEvtBack: false
    onEvtBack:
    {
        var neededClear = needClear();
        if(neededClear === true)
        {
            alarm2(R.message_cancel_write_article);
            ap.setYMethod(mainView, "clearView");
        }
        else clearView();
    }


    function initialize()
    {
        if(opt.ds) return;

        R.log("[PGCourseQuestionNew.qml]  editType: " + editType + ", Board No: " + noBoard + ", Board Article No: " + noBoardArticle + " contents: " + md.noticeDetail.contents);

        if(editType == 0) md.clearFileStorage();
        else
        {
            md.copyToStorage(md.noticeDetail);
            titleText.text = md.noticeDetail.title;
            textArea.setText(md.noticeDetail.contents);
        }

    }

    Component.onCompleted: initialize();

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


//            if(titleText.text.indexOf("&") !== -1)
//            {
//                alarm("사용할 수 없는 특수문자가 포함되어 있습니다.(&)  " + textArea.text.indexOf("&"))
//                return;
//            }

            alarm2( (editType === 0 ? "새 글 작성" : "글 수정") + "을 완료하시겠습니까?");
            ap.setYMethod(mainView, "upload");
        }
    }

    Flickable
    {
        width: parent.width
        height: parent.height - settings.heightStatusBar - R.height_titleBar
        contentWidth : parent.width
        contentHeight: topArea.height + R.dp(300)
        clip: true

        boundsBehavior: Flickable.StopAtBounds
        y: settings.heightStatusBar + R.height_titleBar

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


            LYMargin { height: R.dp(80); }
            Item
            {
                width: parent.width
                height: R.dp(52)

                CPTextField
                {
                    id: titleText
                    width: parent.width - R.dp(124)
                    height: parent.height + R.dp(80)
                    placeholderText: "제목을 입력하세요."
                    text: ""
                    font.pointSize: R.pt(50)
                    anchors
                    {
                        horizontalCenter: parent.horizontalCenter
                    }
                }
            }

            LYMargin { height: R.dp(60) }
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

            LYMargin { height: R.dp(50) }

            Rectangle
            {
                id: attachRect
                width: parent.width; height: attachTxt.height
                CPText
                {
                    id: attachTxt
                    //                    height: parent.height
                    text: "이미지(" + (opt.ds ? fileList.count : md.fileStorage.length) + ")"
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
                                        source: opt.ds ? fileUrl : R.toHttp(md.fileStorage[index].fileUrl)
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
            LYMargin { height: R.dp(30) }

            CPTextArea
            {
                id: textArea
                width: parent.width - R.dp(50) * 2
                height: R.dp(500)
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
            md.addFile(imgSelector.selectedFileName, imgSelector.selectedFilePath);
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
        md.moveFileToRemoveQueue(selectedIndex);
    }

    function upload()
    {
        if(editType == 0)
        {
            wk.setCourseBoardArticle(noBoard, titleText.text, textArea.txt);
        }
        else
        {
            R.log("textArea.txt: " + textArea.txt);
            wk.updateCourseBoardArticle(noBoard, noBoardArticle, selectedIndex, titleText.text, textArea.txt);
        }
        wk.request();
    }

    Timer
    {
        running: opt.ds ? false : (wk.createArticleResult === ENums.POSITIVE)
        repeat: false
        interval: 300
        onTriggered:
        {
            if(!compareCurrentPage(name)) return;

            R.log("Delete Files.");
            wk.changeCreateArticleResult(ENums.WAIT);

            /* FILTER NO SAVED FILE AT SERVER. */
            var idx = 0;
            var fileNo;
            while(idx < md.removedFileStorage.length)
            {
                fileNo = md.removedFileStorage[idx].fileNo;
                if(fileNo === 0) md.removeFileQueue(idx);
                else idx++;
            }

            /* DELETE FILE AT SERVER.  */
            for(var i=0; i < md.removedFileStorage.length; i++)
            {
                fileNo = md.removedFileStorage[i].fileNo;
                wk.deleteFile(fileNo);
            }

            if(md.removedFileStorage.length === 0)
                wk.setDeleteFileResult(ENums.POSITIVE);
            else wk.request();
        }
    }

    Timer
    {
        running: opt.ds ? false : (wk.deleteFileResult === ENums.POSITIVE)
        repeat: false
        interval: 300
        onTriggered:
        {
            if(!compareCurrentPage(name)) return;

            R.log("Start Upload Files. : " + editType);
            wk.volDeleteFileResult();

            /* FILTER NO SAVED FILE AT SERVER. */
            var idx = 0;
            var fileNo;
            while(idx < md.fileStorage.length)
            {
                fileNo = md.fileStorage[idx].fileNo;
                if(fileNo !== 0) md.removeFile(idx);
                else idx++;
            }

            R.log("File Storage Count: " + md.fileStorage.length);
            for(var i=0; i < md.fileStorage.length; i++)
            {
                fileNo = md.fileStorage[i].fileNo;

                var fileUrl = md.fileStorage[i].fileUrl;
                wk.uploadFile(fileUrl, md.noticeDetail.boardNo, md.noticeDetail.boardArticleNo);
            }

            if(md.fileStorage.length === 0)
                wk.setUploadResult(ENums.POSITIVE);
            else wk.request();
        }
    }

    Timer
    {
        running: opt.ds ? false : (wk.uploadResult === ENums.POSITIVE)
        repeat: false
        interval: 300
        onTriggered:
        {
            if(!compareCurrentPage(name)) return;

            md.setShowIndicator(false);
            wk.volUploadResult();
            if(editType==0) md.setCRUDHandlerType(1);
            else md.setCRUDHandlerType(3);

            R.log("Finished Upload/.");
            clearView();
        }
    }

    function needClear()
    {
        Qt.inputMethod.commit();
        if(titleText.text !== "" || textArea.txt !== "" || md.fileStorage.length > 0) return true;
        else return false;
    }

    function clearView()
    {
        mainView.hideMoveView();
        titleText.text = "";
        md.clearFileStorage()
        textArea.setText("");
    }

    function setText()
    {
        textArea.setText(md.noticeDetail.contents);
    }
}
