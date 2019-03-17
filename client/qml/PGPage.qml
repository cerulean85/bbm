import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import "Resources.js" as R

PGProto {
    id: paper
    property string name : ""
    property bool visibleBackBtn : true
    property string backImg : R.image("back")
    property bool visibleSearchBtn : true
    property string searchImg : R.image("setting")
    property string titleText : opt.ds ? R.string_title : md.title
    property string titleBgColor : "transparent"//R.color_appTitlebar
    property string titleTextColor : R.color_appTitleText
    property string titleLineColor : R.color_theme01
    property int leftBtnWidth: R.dp(30)
    property int rightBtnMargin: R.dp(30)
    property int leftBtnHeight: R.dp(56)
    property int leftBtnMargin : R.dp(30)
    property int titleType : 0 /* 0: text, 1: image */
    property string colorBottomArea: "white"

    signal evtInitData();

    property bool useDefaultEvtBack: true
    signal evtBack(); onEvtBack:
    {
        if(useDefaultEvtBack)
        {
            evtInitData();
            popHomeStack();
        }
    }

    signal evtSearch();
    signal evtBehaviorAndroidBackButton();
    signal evtRefreshByTitleButton();
    property int comboToClose : 0
    property int validSecToClose : 0
    property bool useExitMethodByAndroidBackButton: false

    property int heightStatusBar: opt.ds ? R.dp(30) : settings.heightStatusBar
    property int heightBottomArea: opt.ds ? R.dp(44) : settings.heightBottomArea

    property bool titleBarVisible: true
    property string colorStatusBar: R.color_appTitlebar
    property bool showNewAlarm: false
    property bool forceAlignHCenter: true
    property int  forecedRightPaddingToAlignHCenter: 0
    property bool refreshByTitleButton: false
    property bool visibleTitleBar: true

    width: opt.ds ? R.dp(1242) : appWindow.width
    height: opt.ds ? R.dp(2208) : appWindow.height

    Component.onCompleted:
    {
        if(opt.ds) return;

        /* Android - to handel Back Button. */
        paper.forceActiveFocus();
    }

    color: "white"

    PropertyAnimation
    {
        id: showMoveAnim;
        target: paper
        property: "x";
        to: 0
        running: false
        duration: 200
    }

    PropertyAnimation
    {
        id: hideMoveAmin;
        target: paper
        property: "x";
        to: opt.ds ? R.dp(1242) : appWindow.width
        running: false
        duration: 200
    }

    PropertyAnimation
    {
        id: showOpacityAnim;
        target: paper
        property: "opacity";
        to: 1
        duration: 200
    }

    PropertyAnimation
    {
        id: hideOpacityAnim
        target: paper
        property: "opacity"
        to: 0
        duration: 200
    }

    function showMoveView() { paper.visible = true; showMoveAnim.running = true; }
    function hideMoveView() { hideMoveAmin.running = true; hideAnim.running = true; }
    Timer
    {
        id: hideAnim
        running: false
        repeat: false
        interval: 500
        onTriggered: paper.visible = false;
    }
    function showOpacityView() { paper.enabled = true; showOpacityAnim.running = true; }
    function hideOpacityView() { paper.enabled = false; hideOpacityAnim.running = true; }

//    Keys.onBackPressed:
//    {
//        R.log("Keys.onBackPressed");
//        if(useExitMethodByAndroidBackButton)
//        {
//            exitMethodByAndroidBackButton();
//        }
//        else
//        {
//            if (Qt.inputMethod.visible)
//            {
//                Qt.inputMethod.hide();
//                Qt.inputMethod.commit();
//                //                return;
//            }
//            else if(ap.visible)
//            {
//                if(compareCurrentPage("ClipViewer")) return;
//                ap.setVisible(false);
//                ap.invokeNMethod();
//                //                return;
//            }
//            else
//            {
//                evtBehaviorAndroidBackButton();
//            }
//        }
//    }

    function exitMethodByAndroidBackButton()
    {
        if(comboToClose == 0)
        {
            cmd.toast("한번 더 누르면 앱을 종료합니다.");
            comboToClose = 1;
        }
        else if(comboToClose == 1)
        {
            if(validSecToClose <= 3000) comboToClose = 2;
            else
            {
                validSecToClose = 0;
                comboToClose = 0;
            }
        }
    }

    Timer
    {
        running: comboToClose == 2
        repeat: false
        interval: 100
        onTriggered:
        {
            R.log("Wait the flag 'comboToClose'");
            validSecToClose = 0;
            comboToClose = 0;
            close();
        }
    }

    Timer
    {
        running: comboToClose == 1
        repeat: true
        interval: 200
        onTriggered:
        {
            validSecToClose = validSecToClose + 200;
            if(validSecToClose >= 3000)
            {
                comboToClose = 0;
                validSecToClose = 0;
            }
        }
    }

    MouseArea
    {
        anchors.fill: parent
        onClicked: R.hideKeyboard();
    }

    Column
    {
        width: parent.width
        height: paper.heightStatusBar + R.height_titleBar
        visible: visibleTitleBar

        Rectangle
        {
            id: bgStatusBar
            color: colorStatusBar
            width: parent.width
            height: paper.heightStatusBar
        }


        Rectangle
        {
            id: titleBar
            height: R.height_titleBar - R.height_line_1px
            width: parent.width
            color: titleBgColor
            visible: titleBarVisible


            CPImageButton
            {
                id : btnBack
                width: parent.height + leftBtnMargin
                height: parent.height
                widthImage: leftBtnWidth
                heightImage: leftBtnHeight
                sourceImage: backImg
                visible: visibleBackBtn
                useEffectClick: false
                color: "transparent"
                onEvtClicked:
                {
                    if(opt.ds) return;
                    evtBack();
                }
            }

            Rectangle
            {
                width: R.dp(15)
                height: R.dp(15)
                color: R.color_bgColor001
                radius: 50
                visible: opt.ds ? false : (md.newAlarm && showNewAlarm)
                anchors
                {
                    left: parent.left
                    leftMargin: R.dp(60)
                    top: parent.top
                    topMargin: R.dp(30)
                }
            }

            Rectangle
            {
                width:
                {
                    var w = parent.width - btnBack.width;
                    if(!forceAlignHCenter)
                    {
                        if(forecedRightPaddingToAlignHCenter > 0) return w - forecedRightPaddingToAlignHCenter;
                    }
                    return w  - btnSearch.width;
                }
                height: parent.height
                color: "transparent"

                Flickable
                {
                    id: scv
                    width: !forceAlignHCenter ? (titleTxt.width < parent.width ? titleTxt.width : parent.width) : 0
                    height: parent.height
                    contentWidth: titleTxt.width
                    contentHeight: parent.height
                    enabled: titleType != 1
                    boundsBehavior: Flickable.StopAtBounds
                    clip: true

                    Rectangle
                    {
                        id: titleRect
                        width: !forceAlignHCenter ? titleTxt.width : 0
                        height: parent.height
                        color: "transparent"

                        CPText
                        {
                            id: titleTxt
                            elide: Text.ElideNone
                            height: titleRect.height
                            text: titleText
                            color: titleTextColor
                            font.pointSize: R.pt(56)
                            maximumLineCount: 1
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment : Text.AlignHCenter
                        }

                        MouseArea
                        {
                            enabled: refreshByTitleButton
                            width: scv.width
                            height: titleRect.height
                            anchors
                            {
                                horizontalCenter: parent.horizontalCenter
                            }

                            onClicked: evtRefreshByTitleButton()
                        }
                    }

                    anchors
                    {
                        horizontalCenter: parent.horizontalCenter
                    }
                }

                CPText
                {
                    width: forceAlignHCenter ? parent.width : 0
                    height: parent.height
                    text: titleText
                    color: titleTextColor
                    horizontalAlignment : Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: R.pt(56)
                    maximumLineCount: 1
                }

                CPImage
                {
                    id: img
                    width: R.dp(356)
                    height: R.dp(66)
                    fillMode: Image.PreserveAspectFit
                    visible: titleType == 1
                    source: R.image("logo_font")
                    anchors
                    {
                        horizontalCenter: parent.horizontalCenter
                        verticalCenter: parent.verticalCenter
                    }
                }

                anchors
                {
                    left: btnBack.right
                    bottom: parent.bottom
                }
            }

            CPImageButton
            {
                id : btnSearch
                anchors
                {
                    right: parent.right
                }

                width: parent.height + rightBtnMargin
                height: parent.height
                widthImage: R.dp(78)
                heightImage: R.dp(78)
                sourceImage: searchImg
                visible: visibleSearchBtn
                useEffectClick: false
                onEvtClicked: evtSearch();
            }
        }

        CPHLine { color: titleLineColor }
    }

    //    OpacityAnimator {
    //        id:fadeinAnimator
    //        target: alarmPopup;
    //        from: 0;
    //        to: 1;
    //        duration: 500
    //        running: opt.ds ? false : ap.visible
    //    }

    //    OpacityAnimator {
    //        id:fadeoutAnimator
    //        target: alarmPopup;
    //        from: 1;
    //        to: 0;
    //        duration: 500
    //        running: opt.ds ? false : ap.visible
    //    }

    CPToast
    {
        id: toastPopup
        z: 9999
        anchors
        {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: R.dp(150)
        }
    }

    Rectangle
    {
        id: bottomArea
        width: parent.width
        height: opt.ds ? R.dp(44) : settings.heightBottomArea
        color: colorBottomArea
        anchors
        {
            bottom: parent.bottom
            left: parent.left
        }

        //        Rectangle
        //        {
        //            width: R.dp(500)
        //            height: R.dp(10)
        //            color: "black"
        //            anchors
        //            {
        //                verticalCenter: parent.verticalCenter
        //                horizontalCenter: parent.horizontalCenter
        //            }
        //        }
    }

    function toast(message)
    {
        toastPopup.show(message);
    }

    function closeWindowInMain()
    {
        if(showedAlarm())
        {
            R.log("@showedAlarm")
            hideAlarm();
        }
        else if(showBigImage.opacity === 1.0)
        {
            R.log("@showedBigImage")
            showBigImage.hide();
        }
        else if(mainImgSelector.enabled === true)
        {
            R.log("@ImgSelector")
            mainImgSelector.hide();
        }
        else if(setEmail.x  === 0)
        {
            R.log("@showedEmail")
            setEmail.hideMoveView();
        }
        else if(setBirth.x  === 0)
        {
            R.log("@showedBirth")
            setBirth.hideMoveView();
        }
        else if(setGender.x === 0)
        {
            R.log("@showedGender")
            setGender.hideMoveView();
        }
        else if(setName.x === 0)
        {
            R.log("@showedName")
            setName.hideMoveView();
        }
        else if(myProfile.x === 0)
        {
            R.log("@showedProfile")
            myProfile.hideMoveView();
        }
        else if(commentWindow.x === 0)
        {
            R.log("@commentWindow");
            commentWindow.evtBack();

            if(compareCurrentPage("ClipViewer"))
                md.setUnvisibleWebView(false);
        }

        else if(showedMyPage())
        {
            R.log("@showedMyPage")
            hideMyPage();

            if(compareCurrentPage("ClipViewer"))
                md.setUnvisibleWebView(false);
        }
        else
        {
            R.log("Anything showed.");
            return false;
        }
        return true;
    }
}
