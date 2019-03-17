import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import "Resources.js" as R
import enums 1.0

PGPage {
    id: mainView
    visibleSearchBtn: false
    titleText: "설정"
    titleLineColor: "black"
    titleTextColor: "black"
    titleBgColor: "white"
    color: R.color_gray001

    useDefaultEvtBack: false
    onEvtBack:
    {
        if(opt.ds) return;
        //        movePage.running = true;
        //        clearView.running = true;
        hideView();
    }

    onEvtBehaviorAndroidBackButton:
    {
        if(shareRect.opacity === 1.0)
        {
            shareRect.show(false);
            return;
        }
        else if(timeRect.opacity === 1.0)
        {
            timeRect.hide();
            return;
        }
        else if(withdrawReason.opacity === 1.0)
        {
            withdrawReason.hide();
            return;
        }
        else
        {
            evtBack();
        }
    }

    Timer
    {
        id: clearView
        running: false
        repeat: false
        interval: 500
        onTriggered: hideView(); //popHomeStack();
    }

    Component.onCompleted:
    {
        if(opt.ds) return;
    }

    ScrollView
    {
        width: parent.width
        height: parent.height - mainView.heightStatusBar - mainView.heightBottomArea - R.height_titleBar
        y: mainView.heightStatusBar + R.height_titleBar
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        clip: true

        Rectangle
        {
            width: mainView.width
            height:R.dp(67) * 3 + R.dp(156) * 11 + R.dp(200) + R.dp(100)
            color: R.color_gray001
            Column
            {
                width: parent.width
                height: parent.height

                LYMargin { width: parent.width; height: R.dp(33); color: R.color_gray001 }
                LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_gray87}

                Rectangle
                {
                    width: parent.width
                    height: R.dp(156) * 2 + R.height_line_1px * 3
                    color: "white"

                    Column
                    {
                        width: parent.width
                        height: parent.height

                        CPOptionButton
                        {
                            imageSource: R.image("setting_user");
                            buttonName: "프로필"
                            onEvtClicked:
                            {
                                if(!logined())
                                {
                                    alarmNeedLoginShowImmediate();
                                    return;
                                }

                                profileUpdator.running = true;
                                myProfile.showMoveView();
                            }

                            Timer
                            {
                                id: profileUpdator
                                running: false
                                repeat: false
                                interval: 300
                                onTriggered:
                                {
                                    wk.getUserProfile();
                                    wk.request();
                                }
                            }
                        }

                        Item
                        {
                            width: parent.width
                            height: R.height_line_1px

                            LYMargin
                            {
                                width: parent.width - R.dp(196)
                                height: R.height_line_1px
                                color: R.color_gray87
                                anchors
                                {
                                    right: parent.right
                                }
                            }
                        }

                        CPOptionButton
                        {
                            imageSource: R.image("setting_account");
                            buttonName: "계정"
                            onEvtClicked:
                            {
                                if(!logined())
                                {
                                    alarmNeedLoginShowImmediate();
                                    return;
                                }

                                pushHomeStack("SetAccount", { });
                            }
                        }
                    }
                }
                LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_gray87}
                LYMargin { width: parent.width; height: R.dp(33); color: R.color_gray001 }
                LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_gray87}
                Rectangle
                {
                    width: parent.width
                    height: R.dp(156) + selectionTime.height + infoBox.height + R.height_line_1px * 3
                    color: "white"

                    Column
                    {
                        width: parent.width
                        height: parent.height

                        CPOptionButton
                        {
                            id: pushToggle
                            imageSource: R.image("setting_alarm");
                            buttonName: "푸시알림"
                            hideGoButton: true

                            CPToggleButton
                            {
                                id: pushBtn
                                selected: opt.ds ? true : settings.pushStatus
                                enabled: false
                                anchors
                                {
                                    right: parent.right
                                    rightMargin: R.dp(45)
                                    verticalCenter: parent.verticalCenter
                                }
                            }
                            onEvtClicked:
                            {
                                if(!logined())
                                {
                                    alarmNeedLoginShowImmediate();
                                    return;
                                }

                                wk.setPushStatus(pushBtn.selected ? 0: 1); /* 선택 -> 취소(0), 취소-> 선택(1) */
                                wk.request();
                            }

                            Timer
                            {
                                running: opt.ds ? false : wk.setPushStatusResult !== ENums.WAIT
                                repeat: false
                                interval: 300
                                onTriggered:
                                {
                                    R.log("setPushStatusResult : " + wk.setPushStatusResult);
                                    if(wk.volSetPushStatusResult() === ENums.POSITIVE)
                                    {
                                        pushBtn.selected = !pushBtn.selected;
                                        if(pushBtn.selected) {
                                            pushBtn.onToggle();
                                            settings.setPushStatus(1);
                                        }
                                        else {
                                            pushBtn.offToggle();
                                            settings.setPushStatus(0);
                                        }
                                    } else error();
                                }
                            }
                        }



                        Item
                        {
                            width: parent.width
                            height: R.height_line_1px

                            LYMargin
                            {
                                width: parent.width - R.dp(196)
                                height: R.height_line_1px
                                color: R.color_gray87
                                anchors
                                {
                                    right: parent.right
                                }
                            }
                        }
                        Item
                        {
                            id: infoBox
                            width: parent.width
                            height: infoTxt.height + R.dp(100)


                            Row
                            {
                                width: parent.width
                                height: parent.height
                                LYMargin { width: R.dp(66); }
                                CPText
                                {
                                    id: infoTxt
                                    width: parent.width - R.dp(120)
                                    text: "푸시알림 설정 시 학습에 대한 푸시 알림을 정기적으로 받아볼 수 있습니다.
푸시알림 수신을 거부하고 싶으시다면 해당 토글버튼을 비활성화 해주세요."
                                    color: R.color_gray87
                                    font.pointSize: R.pt(40)
                                    anchors
                                    {
                                        verticalCenter: parent.verticalCenter
                                    }
                                }
                            }
                        }
                        LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_gray87}
                        Rectangle
                        {
                            id: selectionTime
                            width: parent.width
                            height: pushBtn.selected ? R.dp(156) : 0
                            visible: pushBtn.selected
                            CPText
                            {
                                text:"딜리버리 서비스 받는 시각"
                                font.pointSize: R.pt(40)
                                color: R.color_bgColor002
                                height: parent.height
                                verticalAlignment: Text.AlignVCenter
                                anchors
                                {
                                    left: parent.left
                                    leftMargin: R.dp(56)
                                }
                            }

                            CPText
                            {
                                text: opt.ds ? "오후 11:00" :
                                               (settings.pushTimeAMPM == 0 ? "오전 " : "오후 ")
                                               + strHour(settings.pushTimeHour) + ":" + strMinutes(settings.pushTimeMinutes*30)
                                font.pointSize: R.pt(40)
                                color: R.color_gray88
                                height: parent.height
                                verticalAlignment: Text.AlignVCenter
                                anchors
                                {
                                    right: parent.right
                                    rightMargin: R.dp(56)
                                }
                            }

                            MouseArea
                            {
                                anchors.fill: parent
                                onClicked:
                                {
                                    colorAnimator.running = true;
                                    timeRect.show();
                                }
                            }

                            Timer
                            {
                                running: opt.ds ? false : wk.setPushDatetimeResult !== ENums.WAIT
                                repeat: false
                                interval: 300
                                onTriggered:
                                {
                                    R.log("setPushDatetime: " + wk.setPushDatetimeResult);
                                    if(wk.volSetPushDatetimeResult() !== ENums.POSITIVE) error();
                                }
                            }

                            ColorAnimation on color {
                                id: colorAnimator
                                from: R.color_bgColor003
                                to: "white"
                                running: false
                                duration: 100
                            }
                        }
                    }
                }
                LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_gray87; visible: pushBtn.selected}
                LYMargin { width: parent.width; height: R.dp(33); color: R.color_gray001 }
                LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_gray87}
                Rectangle
                {
                    width: parent.width
                    height: R.dp(156) * 3 + R.height_line_1px * 5
                    color: "white"

                    Column
                    {
                        width: parent.width
                        height: parent.height

                        CPOptionButton
                        {
                            imageSource: R.image("setting_notice");
                            buttonName: "공지사항"
                            onEvtClicked:
                            {
                                pushHomeStack("NoticeList", { "noticeType": 0});
                            }
                        }

                        Item
                        {
                            width: parent.width
                            height: R.height_line_1px

                            LYMargin
                            {
                                width: parent.width - R.dp(196)
                                height: R.height_line_1px
                                color: R.color_gray87
                                anchors
                                {
                                    right: parent.right
                                }
                            }
                        }

                        CPOptionButton
                        {
                            imageSource: R.image("setting_que")
                            buttonName: "도움말"
                            onEvtClicked:
                            {
                                pushHomeStack("HelpList");
                            }
                        }

                        Item
                        {
                            width: parent.width
                            height: R.height_line_1px

                            LYMargin
                            {
                                width: parent.width - R.dp(196)
                                height: R.height_line_1px
                                color: R.color_gray87
                                anchors
                                {
                                    right: parent.right
                                }
                            }
                        }

                        CPOptionButton
                        {
                            imageSource: R.image("setting_info")
                            buttonName: "프로그램 정보"
                            onEvtClicked:
                            {
                                pushHomeStack("ProgramInfo", { });
                            }
                        }
                    }
                }
                LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_gray87}
                LYMargin { width: parent.width; height: R.dp(33); color: R.color_gray001 }
                LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_gray87}
                Rectangle
                {
                    width: parent.width
                    height: lastRect.height //R.dp(156) * 4 + R.height_line_1px * 6
                    color: "white"

                    Column
                    {
                        id: lastRect
                        width: parent.width

                        CPOptionButton
                        {
                            imageSource: ""
                            buttonName: "친구초대"
                            onEvtClicked:
                            {
                                shareRect.show(true);
                            }
                        }

                        Item
                        {
                            width: parent.width
                            height: R.height_line_1px

                            LYMargin
                            {
                                width: parent.width - R.dp(196)
                                height: R.height_line_1px
                                color: R.color_gray87
                                anchors
                                {
                                    right: parent.right
                                }
                            }
                        }

                        CPOptionButton
                        {
                            imageSource: ""
                            buttonName: opt.ds ? "로그아웃" : (!logined() ? "로그인" : "로그아웃")
                            onEvtClicked:
                            {
                                if(logined())
                                {
                                    ap.setVisible(true);
                                    ap.setMessage("로그아웃 하시겠습니까?");
                                    ap.setButtonCount(2);
                                    ap.setYMethod(mainView, "logout");
                                    ap.setYButtonName("예");
                                    ap.setNButtonName("아니오");
                                }
                                else
                                {
                                    showIndicator(true);
                                    pushUserStack("LoginDesk", { }, StackView.PushTransition);
                                }
                            }
                        }

                        Timer
                        {
                            running: opt.ds ? false : (wk.logoutResult !== ENums.WAIT)
                            repeat: false
                            onTriggered:
                            {
                                md.setShowIndicator(false);
                                if(wk.volLogoutResult() === ENums.POSITIVE)
                                {
                                    alarm("로그아웃에 성공하였습니다.");
                                    ap.setYMethod(mainView, "hideMoveView");
                                } else error();
                            }
                        }

                        Item
                        {
                            width: parent.width
                            height: R.height_line_1px

                            LYMargin
                            {
                                width: parent.width - R.dp(196)
                                height: R.height_line_1px
                                color: R.color_gray87
                                anchors
                                {
                                    right: parent.right
                                }
                            }
                        }

                        CPOptionButton
                        {
                            imageSource: ""
                            buttonName: "회원탈퇴"
                            width: opt.ds ? parent.width : (logined() ? parent.width : 0)
                            visible: opt.ds ? true : (logined() ? true:false)
                            onEvtClicked:
                            {
                                if(logined())
                                {
                                    showReasonWindow();
                                }
                                else
                                {
                                    alarmNeedLoginShowImmediate();
                                }

                            }
                        }

                        Item
                        {
                            width: opt.ds ? parent.width : (logined() ? parent.width : 0)
                            height: R.height_line_1px

                            LYMargin
                            {
                                width: parent.width - R.dp(196)
                                height: R.height_line_1px
                                color: R.color_gray87
                                anchors
                                {
                                    right: parent.right
                                }
                            }
                        }

                        CPOptionButton
                        {
                            imageSource: ""
                            buttonName: "문의하기"
                            onEvtClicked:
                            {
//                                np.sendMail(R.adminEmail, "[" + settings.nickName + "] 제목을 입력하세요.", "내용을 입력하세요.");
                                if(!logined())
                                {
                                    alarmNeedLoginShowImmediate();
                                    return;
                                }
                                pushHomeStack("ContactUs");
                            }
                        }

                        Timer
                        {
                            running: opt.ds ? false : (wk.withdrawResult !== ENums.WAIT)
                            repeat: false
                            onTriggered:
                            {
                                md.setShowIndicator(false);
                                if(wk.volWithdrawResult() === ENums.POSITIVE)
                                {
                                    alarm("회원탈퇴가 정상적으로 처리되었습니다.");
                                    ap.setYMethod(mainView, "hideMoveView");
                                } else error();
                            }
                        }
                    }
                }
                LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_gray87}
            }
        }
    }

    CPSNSSelector
    {
        id: shareRect
        width: parent.width
        height: parent.height
        onEvtCmdKakao: cmd.inviteKakao();
        onEvtCmdFacebook: cmd.inviteFacebook();
    }

    CPTimeSelector
    {
        id: timeRect
        width: parent.width
        height: parent.height
        opacity: 0
    }

    CPWithdrawReason
    {
        id: withdrawReason
        width: parent.width
        height: parent.height
        onEvtWithdraw:
        {
            alarm2("회원탈퇴를 계속 진행하시겠습니까?");
            ap.setYMethod(mainView, "withdraw");
        }
    }

    function logout()
    {
        md.setShowIndicator(true);
        switch(settings.snsType)
        {
        case ENums.KAKAO:
        {
            cmd.logoutKakao();
            break;
        }
        case ENums.FACEBOOK:
        {
            cmd.logoutFacebook();
            break;
        }
        }
        wk.logout();
        wk.request();
    }

    function showReasonWindow()
    {
        withdrawReason.show();
    }

    function withdraw()
    {
        withdrawReason.hide();
        md.setShowIndicator(true);
        switch(settings.snsType)
        {
        case ENums.KAKAO:
        {
            cmd.withdrawKakao();
            break;
        }
        case ENums.FACEBOOK:
        {
            cmd.withdrawFacebook();
            break;
        }
        }
        wk.withdraw(withdrawReason.reason);
        wk.request();
    }

    function contact(title, contents)
    {

    }

    function strHour(data)
    {
        data = data+1;
        return data.toString().length < 2 ? "0" + data : data;
    }
    function strMinutes(data)
    {
        return data.toString().length < 2 ? "0" + data : data;
    }

    function showView()
    {
        showMoveView();
        mainView.visible = true;
    }
    function hideView()
    {
        hideMoveView();
        tmHideView.running = true;
    }

    Timer
    {
        id: tmHideView
        running: false
        repeat: false
        interval: 500
        onTriggered: mainView.visible = false;
    }
}
