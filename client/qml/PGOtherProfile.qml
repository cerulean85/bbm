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
    titleText: "프로필 보기"
    titleTextColor: "black"
    titleLineColor: "black"
    pageName: "OtherProfile"

    property int targetUserNo: 0

    Component.onCompleted:
    {
        if(opt.ds) return;
        getDataTimer.running = true;
    }

    Timer
    {
        id: getDataTimer
        running: false
        repeat: false
        interval: 300
        onTriggered:
        {
            wk.getOtherUserProfile(targetUserNo);
            wk.request();
        }
    }

    property int widthCategoryArea: contentcRect.width * 0.5
    property int heightCategoryArea: R.dp(137)

    property int actyLength : 40
    property int itemHeight : R.dp(350)
    property int itemActyHeight : R.dp(136)

    Rectangle
    {
        id: contentcRect
        width: parent.width
        height: parent.height - mainView.heightStatusBar - mainView.heightBottomArea - R.height_titleBar
        color: R.color_grayED
        y: mainView.heightStatusBar + R.height_titleBar

        Column
        {
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

                    sourceImage :
                        opt.ds ?
                            "https://scontent-sjc3-1.cdninstagram.com/vp/eaf56aa30148a578e29d34631cb84968/5BB12F51/t51.2885-15/e35/26156236_123939068416546_2742507055683207168_n.jpg"
                          : R.startsWithAndReplace((md.user.profileImage === "" ? md.user.profileImage : md.user.profileThumbNailUrl), "https", "http")


                    anchors
                    {
                        bottom: basePoint.top
                        bottomMargin: R.dp(-130)
                        horizontalCenter: parent.horizontalCenter
                    }

                    onEvtClicked:
                    {
                        if(profileImg.sourceImage == "")
                        {
                            alarm("프로필 이미지가 존재하지 않습니다.");
                            return;
                        }
                        showBigImage.source = R.startsWithAndReplace(md.user.profileImage, "https", "http");
                        showBigImage.show();
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
                            imgSelector.enabled = true;
                            imgSelector.enabledToHandle = true;
                            if(opt.ds) return;

                        }
                    }
                }

                CPText
                {
                    id: nameTxt
                    text: opt.ds ? "관리자" : md.user.nickName
                    font.pointSize: R.pt(35)
                    anchors
                    {
                        top: profileImg.bottom
                        topMargin: R.dp(20)
                        horizontalCenter: parent.horizontalCenter
                    }
                }

                Item
                {
                    width: snsImage.width //+ emailTxt.width

                    CPImage
                    {
                        id: snsImage
                        width: snsImage === "" ? 0 : R.dp(50)
                        height: snsImage === "" ? 0 : R.dp(50)
                        visible: false
                        source:
                        {
                            var type = opt.ds ? ENums.KAKAO : md.user.snsType;
                            //                            R.log(ENums.KAKAO);
                            switch(type)
                            {
                            case ENums.KAKAO: return R.image("sns_kakao");
                            case ENums.FACEBOOK: return R.image("sns_facebook");
                            }
                            return "";
                        }
                    }

                    anchors
                    {
                        left: nameTxt.right
                        leftMargin: R.dp(20)
                        top: nameTxt.top
                    }
                }

                CPTextButton
                {
                    name: "신고하기"
                    visible: opt.ds ? true : (targetUserNo !== settings.noUser)
                    width: R.dp(300)
                    height: R.dp(150)
                    color: "transparent"
                    subColor: R.color_gray001
                    txtColor: R.color_bgColor001
                    pointSize: R.pt(50)
                    underline: true
                    anchors
                    {
                        top: parent.top
                        right: parent.right
                    }
                    onClick:
                    {
                        reportProfile.show();
                    }
                }
            }
            LYMargin { height: R.dp(20)}

            Rectangle
            {
                width: parent.width
                height: contentcRect.height

                Column
                {
                    width: parent.width
                    height: parent.height
                    CPProfileButton
                    {
                        height: R.dp(178)
                        title: "이름"
                        contents: opt.ds ? "김딸깍" : md.user.name
                        enabled: false
                        hideGoButton: true
                    }
                    LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_bgColor001; }
                    CPProfileButton
                    {
                        height: R.dp(178)
                        title: "점수"
                        contents: (opt.ds ? "100" : md.user.score) + "점"
                        enabled: false
                        hideGoButton: true
                    }
                    LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_bgColor001; }
                    CPProfileButton
                    {
                        height: R.dp(178)
                        title: "최근접속"
                        contents: opt.ds ? "1999.09.09." : md.user.recentDate
                        enabled: false
                        hideGoButton: true
                    }
                    LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_bgColor001; }
                }
            }
        }
    }

    CPReportProfile
    {
        id: reportProfile
        targetUserNo: mainView.targetUserNo
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

    PGIMGMethodSelector
    {
        id: imgSelector
        enabled: false
    }

    onEvtBehaviorAndroidBackButton:
    {
        if(reportProfile.opacity === 1.0)
        {
            reportProfile.hide();
            return;
        }
        else if(showBigImage.opacity === 1.0)
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

    Timer
    {
        running: opt.ds ? false : (md.requestNativeBackBehavior === ENums.REQUESTED_BEHAVIOR && compareCurrentPage(pageName))
        repeat: false
        interval: 100
        onTriggered:
        {
            md.setRequestNativeBackBehavior(ENums.WAIT_BEHAVIOR);
            if(closeWindowInMain()) return;
            evtBehaviorAndroidBackButton();
        }
    }
}
