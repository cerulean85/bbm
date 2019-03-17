import QtQuick 2.9
import "Resources.js" as R
import enums 1.0

Rectangle
{
    id: mainView
    color: "transparent"

    width: opt.ds ? R.dp(1242) : appWindow.width
    height: opt.ds ? R.dp(2208) : appWindow.height

    property string selectedFilePath: ""
    property string selectedFileName: ""
    property bool directUpload: true
    property bool enabledToHandle : false
    property bool showBasic: true
    signal evtCallback();

    Component.onCompleted:
    {
        //        showOpRect.running = true;
//        show();
    }

    Rectangle
    {
        id:opRect
        width: parent.width
        height: parent.height
        color: "transparent"

        ColorAnimation on color
        {
            id: showOpRect
            from: "transparent"
            to: "#44000000"
            duration: 100
            running: false
        }


        ColorAnimation on color
        {
            id: hideOpRect
            from: "#44000000"
            to: "transparent"
            duration: 100
            running: false
        }

        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                hide();
            }
        }
    }

    property int heightBtn: R.dp(190)
    property int marginBtnSide: R.dp(30)
    property int marginBetweenBtn : R.height_line_1px * 2
    Column
    {
        id: btnArea
        width: parent.width - marginBtnSide * 2
        anchors
        {
            left: parent.left
            leftMargin: marginBtnSide
        }

        y: mainView.height//parent.height - albumBtn.height - cameraBtn.height - baseBtn.height - cancelBtn.height - albumMargin.height -  cameraMargin.height - baseMargin.height - cancelMargin.height

        Rectangle
        {
            id: albumBtn
            width: parent.width
            height: heightBtn
            color:"white"
            radius: 10

            CPText
            {
                text: "앨범에서 가져오기"
                color: "#2f7ddf"
                font.pointSize: R.pt(65)
                width: parent.width
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }


            ColorAnimation on color{
                id: albumColorChanger
                running: false
                from: R.color_grayCF
                to: "white"
                duration: 200
            }

            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    albumColorChanger.running = true;
                    tmHide.running = true;
                    tmOpenAlbum.running = true;
                }
            }

            Timer
            {
                id: tmOpenAlbum
                running: false
                repeat: false
                interval: 300
                onTriggered:
                {
                    if(opt.ds) return;
                    openAlbum();
                }
            }
        }
        LYMargin { id: albumMargin; height: marginBetweenBtn }

        Rectangle
        {
            id: cameraBtn
            width: parent.width
            height: heightBtn
            color:"white"
            radius: 10

            CPText
            {
                text: "카메라로 찍기"
                color: "#2f7ddf"
                font.pointSize: R.pt(65)
                width: parent.width
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            ColorAnimation on color{
                id: cameraColorChanger
                running: false
                from: R.color_grayCF
                to: "white"
                duration: 200
            }

            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    cameraColorChanger.running = true;
                    tmHide.running = true;
                    tmOpenCamera.running = true;
                }
            }

            Timer
            {
                id: tmOpenCamera
                running: false
                repeat: false
                interval: 300
                onTriggered:
                {
                    if(opt.ds) return;
                    openCamera();
                }
            }
        }
        LYMargin {
            id: cameraMargin;
            height: showBasic ? marginBetweenBtn : 0
        }

        Rectangle
        {
            id: baseBtn
            width: parent.width
            height: showBasic ? heightBtn : 0
            color:"white"
            radius: 10

            CPText
            {
                text: "기본 이미지로 설정"
                color: "#2f7ddf"
                font.pointSize: R.pt(65)
                width: parent.width
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            ColorAnimation on color{
                id: baseColorChanger
                running: false
                from: R.color_grayCF
                to: "white"
                duration: 200
            }

            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    baseColorChanger.running = true;
                    tmUseBaseImage.running = true;
                    tmHide.running = true;
                }
            }

            Timer
            {
                id: tmUseBaseImage
                running: false
                repeat: false
                interval: 200
                onTriggered:
                {
                    useBaseImage();
                }
            }
        }
        LYMargin
        {
            id: baseMargin;
            height: marginBtnSide
        }

        Rectangle
        {
            id: cancelBtn
            width: parent.width
            height: heightBtn
            color:"white"
            radius: 10

            CPText
            {
                text: "취소하기"
                color: "#2f7ddf"
                font.pointSize: R.pt(65)
                width: parent.width
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            ColorAnimation on color{
                id: cancelColorChanger
                running: false
                from: R.color_grayCF
                to: "white"
                duration: 200
            }

            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    cancelColorChanger.running = true;
                    tmHide.running = true;
                }
            }
        }
        LYMargin { id: cancelMargin; height: marginBtnSide }
    }

    PropertyAnimation
    {
        id: moveUp
        running: false
        target: btnArea
        property: "y"
        to: mainView.height - btnArea.height
        duration: 200
    }

    PropertyAnimation
    {
        id: moveDown
        running: false
        target: btnArea
        property: "y"
        to: mainView.height
        duration: 200
    }

    function hide()
    {
        moveDown.running = true;
        fadeOut.running = true;
        mainView.enabled = false;
    }

    function show()
    {
        showOpRect.running = true;
        upBtnArea.running = true;
        mainView.enabled = true;
    }

    Timer
    {
        id: upBtnArea
        running: false
        repeat: false
        interval: 200
        onTriggered:
        {
            moveUp.running = true;
        }
    }

    Timer
    {
        id: fadeOut
        running: false
        repeat: false
        interval: 200
        onTriggered:
        {
            hideOpRect.running = true;
        }
    }

    Timer
    {
        id: tmHide
        running: false
        repeat: false
        interval: 300
        onTriggered:
        {
            hide();
        }
    }

    CPImagePicker
    {
        id: picker
        onPick:
        {
            R.log("### FILE UPLOAD RESULT 333##");
            R.log("## 1. ORIGIN FILE PATH > " + filePath);
            if(opt.ds) return;

            var selectedPath = filePath;
            var resizedPath = cmd.getProfileImage(selectedPath);
            R.log("## 2. SELECTED FILE PATH > " + selectedPath);
            R.log("## 3. RESIZED  FILE PATH > " + resizedPath);

            if(resizedPath === "") return;

            selectedFilePath = resizedPath;

            var splitedPaths = resizedPath.split('/');
            selectedFileName = splitedPaths[splitedPaths.length-1];
            R.log("## 4. SELECTED FILE NAME > " + selectedFileName);

            md.setShowIndicator(true);

            if(directUpload)
            {
                wk.uploadImageFile(resizedPath);
                wk.request();
            }

            evtCallback();
        }
    }

    function useBaseImage()
    {
        mainView.selectedFilePath = "";
        mainView.selectedFileName = "";

        settings.setProfileImage("");
        settings.setThumbnailImage("");

        wk.updateUserProfile(true);
        wk.request();
    }

    Timer
    {
        running: opt.ds ? false : (wk.uploadResult !== ENums.WAIT) && mainView.enabledToHandle
        repeat: false
        onTriggered:
        {
            md.setShowIndicator(false);
            if(wk.volUploadResult() === ENums.POSITIVE)
            {
                wk.updateUserProfile(true);
                wk.request();
                return;
            }
            mainView.enabledToHandle = false
        }
    }

    function openAlbum()
    {
        md.setShowIndicator(true);
        picker.openAlbum();
    }
    function openCamera()
    {
        md.setShowIndicator(true);
        picker.openCamera();
    }

}
