import QtQuick 2.9
import QtQuick.Controls 2.2
//import QtQuick.Layouts 1.3
//import QtGraphicalEffects 1.0
import "Resources.js" as R
import enums 1.0

PGPage {
    id: mainView
    visibleBackBtn: true
    visibleSearchBtn: false
    titleText: "프로필 수정"
    titleTextColor: "black"
    titleLineColor: "black"

    property int widthCategoryArea: contentcRect.width * 0.5
    property int heightCategoryArea: R.dp(137)

    property int dlength : opt.ds ? 25 : md.mycourselist.length
    property int actyLength : 40
    property int itemHeight : R.dp(350)
    property int itemActyHeight : R.dp(136)

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
                height: R.dp(582)
                color: "white"

                Item
                {
                    id: basePoint
                    width: 1
                    height: 1
                    anchors
                    {
                        verticalCenter: parent.verticalCenter
                        horizontalCenter: parent.horizontalCenter
                    }
                }


                CPProfileImage
                {
                    id: profileImg
                    width: R.dp(302)
                    height: R.dp(302)
                    sourceImage: R.startsWithAndReplace(settings.profileImage, "https", "http")

                    anchors
                    {
                        bottom: basePoint.top
                        bottomMargin: R.dp(-100)
                        horizontalCenter: parent.horizontalCenter
                    }

                    onEvtClicked:
                    {
                        mainImgSelector.show();
                        mainImgSelector.enabledToHandle = true;
                    }
                }

                Rectangle
                {
                    id: editBtnRect
                    width: R.dp(100)
                    height: R.dp(100)
                    color: "transparent"
                    radius: parent.width * 0.5
                    anchors
                    {
                        bottom: profileImg.bottom
                        right: profileImg .right
                    }

                    CPImage
                    {
                        width: parent.width - R.dp(20)
                        height: parent.height - R.dp(20)
                        source: R.image("edit")
                        anchors
                        {
                            verticalCenter: parent.verticalCenter
                            horizontalCenter: parent.horizontalCenter
                        }

                    }

                    ColorAnimation on color {
                        id: colorAnimator
                        from: "#44000000"//R.color_gray001
                        to: "transparent"
                        running: false
                        duration: 500
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked:
                        {
                            colorAnimator.running = true;
                            mainImgSelector.show();
                            mainImgSelector.enabledToHandle = true;
                            if(opt.ds) return;

                        }
                    }
                }

                CPText
                {
                    id: nameTxt
                    text: opt.ds ? "관리자" : settings.name
                    font.pointSize: R.font_size_common_style_login
                    anchors
                    {
                        top: profileImg.bottom
                        topMargin: R.dp(20)
                        horizontalCenter: parent.horizontalCenter
                    }
                }

                CPText
                {
                    text: opt.ds ? "example@example.com" : settings.email
                    font.pointSize: R.font_size_common_style_login
                    anchors
                    {
                        top: nameTxt.bottom
                        horizontalCenter: parent.horizontalCenter
                    }
                }
            }
            LYMargin { height: R.dp(20)}

            Rectangle
            {
                width: parent.width
                height: mainColumn.height - metaRect.height - R.dp(20)

                Column
                {
                    width: parent.width
                    height: parent.height
                    CPProfileButton
                    {
                        height: R.dp(178)
                        title: "닉네임"
                        hideGoButton: true
                        enabled: false
                        contents: opt.ds ? "닉네임!!" : settings.nickName
                        onEvtClicked:
                        {
                            stackView.push(Qt.createComponent("PGSetNickname.qml"), StackView.PushTransition);
//                            pushHomeStack("SetNickname", { });
                        }
                    }
                    LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_bgColor001; }
                    CPProfileButton
                    {
                        height: R.dp(178)
                        title: "이름"
                        contents: opt.ds ? "홍길동" : settings.name
                        onEvtClicked:
                        {
                            setName.showMoveView();
                            setName.setCurrentName(settings.name);
//                            stackView.push(Qt.createComponent("PGSetName.qml"), StackView.PushTransition);
                        }
                    }
                    LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_bgColor001; }
                    CPProfileButton
                    {
                        height: R.dp(178)
                        title: "이메일"
                        contents: opt.ds ? "example@example.com" : settings.email
                        onEvtClicked:
                        {
                            setEmail.showMoveView();
                            setEmail.setCurrentEmail(settings.email)
//                            stackView.push(Qt.createComponent("PGSetEmail.qml"), StackView.PushTransition);
                        }
                    }
                    LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_bgColor001; }
                    CPProfileButton
                    {
                        height: R.dp(178)
                        title: "생년월일"
                        contents: opt.ds ? "1999.09.09." : R.replaceAll(settings.birth, "-")
                        onEvtClicked:
                        {
                            setBirth.showMoveView();
//                            setBirth.setCurrentBirth(settings.birth);
//                            stackView.push(Qt.createComponent("PGSetBirth.qml"), StackView.PushTransition);
                        }
                    }
                    LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_bgColor001; }
                    CPProfileButton
                    {
                        height: R.dp(178)
                        title: "성별"
                        contents: opt.ds ? "남자" : settings.gender === 0 ? "남자" : "여자"
                        onEvtClicked:
                        {
                            setGender.showMoveView();
//                            stackView.push(Qt.createComponent("PGSetGender.qml"), StackView.PushTransition);
                        }
                    }
                    LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_bgColor001; }
                }
            }
        }
    }

    Timer
    {
        running: opt.ds ? false : md.popMyPage===true
        repeat: false
        interval: 200
        onTriggered:
        {
            md.setPopMyPage(false);
            stackView.clear();
        }
    }

//    StackView
//    {
//        id: stackView
//        width: parent.width
//        height: parent.height
//    }

//    CPIMGView
//    {
//        id: showBigImage
//        opacity: 0
//        width: parent.width
//        height: parent.height
//    }

//    PGIMGMethodSelector
//    {
//        id: imgSelector
//        enabled: false
//        width: parent.width
//        height: parent.height
//    }

    useDefaultEvtBack: false
    onEvtBack: hideMoveView();

//    onEvtBehaviorAndroidBackButton:
//    {
//        if(showBigImage.opacity === 1.0)
//        {
//            showBigImage.hide();
//            return;
//        }
//        else if(imgSelector.enabled)
//        {
//            imgSelector.hide();
//            return;
//        }
//        else
//        {
//            popHomeStackOnlyName();
////            evtBack();
//        }
//    }

//    Timer
//    {
//        running: opt.ds ? false : (md.requestNativeBackBehavior === ENums.REQUESTED_BEHAVIOR && compareCurrentPage(pageName))
//        repeat: false
//        interval: 100
//        onTriggered:
//        {
//            md.setRequestNativeBackBehavior(ENums.WAIT_BEHAVIOR);
//            if(!hideAlarm()) evtBehaviorAndroidBackButton();
//        }
//    }
}
