import QtQuick 2.9
import QtQuick.Controls 2.2
import "Resources.js" as R
import enums 1.0

PGPage {
    id: mainView
    name: "loginDesk"
    visibleSearchBtn: false
    titleText: "로그인"
    titleTextColor: "black"
    titleLineColor: "black"
    visibleBackBtn: true
    pageName: "LoginDesk"
    property string from: "home"
    color: "white"

    useDefaultEvtBack: false
    onEvtBack:
    {
        if(matchPrevPage("ClipViewer"))
        {
            md.setNativeChanner(11);
            md.setUnvisibleWebView(false);
        }

        movePage.running = true //!matchPrevPage("Option");
        clearView.running = true;
    }

    PropertyAnimation
    {
        id: movePage;
        target: mainView;
        running: false
        property: "x";
        to: appWindow.width
        duration: 200
    }

    Timer
    {
        id: clearView
        running: false
        repeat: false
        interval: 500
        onTriggered: clearUserStack();
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

    Component.onCompleted:
    {
        if(opt.ds) return;

        md.setCheckedClause1(false);
        md.setCheckedClause2(false);
        md.setCheckedClause3(false);
        md.setCheckedClause4(false);

        showIndicator(false);
    }

    property string dummyID : R.dummyID
    property string dummyPass : R.dummyPass

    Rectangle
    {
        width: parent.width
        height: parent.height - mainView.heightStatusBar - mainView.heightBottomArea - R.height_titleBar
        color: "white"
        y: mainView.heightStatusBar + R.height_titleBar

        Column
        {
            width: parent.width
            height: parent.height

            LYMargin {
                height: R.dp(15);
                width: parent.width;
                color: "white"
                //R.color_gray001
            }

            Rectangle
            {
                width: parent.width
                height: R.dp(200)
                color: "white" //R.color_gray001

                Rectangle
                {
                    width: parent.width //- R.dp(40)
                    height: R.dp(160) + R.dp(6)
//                    color: R.color_bgColor001
                    anchors
                    {
                        horizontalCenter: parent.horizontalCenter
                        verticalCenter: parent.verticalCenter
                    }
                    border.width: R.height_line_1px
                    border.color: R.color_bgColor001


                    LYMargin
                    {
                        id: padd1
                        width: R.dp(46)
                        height: R.dp(156)
                        color: "white"
                        anchors
                        {
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                            leftMargin: R.dp(4)
                        }
                    }
                    LYMargin
                    {
                        id: padd2
                        width: R.dp(46)
                        height: R.dp(156)
                        color: "white"
                        anchors
                        {
                            verticalCenter: parent.verticalCenter
                            right: parent.right
                            rightMargin: R.dp(4)
                        }
                    }
                    CPTextField
                    {
                        id: idTxt
                        width: parent.width - padd1.width - padd2.width
                        height: R.dp(156)
                        placeholderText: "아이디 (이메일 형식)"
                        text: dummyID
                        font.pointSize: R.font_size_common_style_login
                        maximumLength: 50

                        anchors
                        {
                            left: padd1.right
                            verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }

            Rectangle
            {
                width: parent.width
                height: R.dp(180)
                color: "white" //R.color_gray001

                Rectangle
                {
                    width: parent.width //- R.dp(40)
                    height: R.dp(160) + R.dp(6)
//                    color: R.color_bgColor001
                    anchors
                    {
                        horizontalCenter: parent.horizontalCenter
                        verticalCenter: parent.verticalCenter
                    }
                    border.width: R.height_line_1px
                    border.color: R.color_bgColor001


                    LYMargin
                    {
                        id: padd3
                        width: R.dp(46)
                        height: R.dp(156)
                        color: "white"
                        anchors
                        {
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                            leftMargin: R.dp(4)
                        }
                    }
                    LYMargin
                    {
                        id: padd4
                        width: R.dp(46)
                        height: R.dp(156)
                        color: "white"
                        anchors
                        {
                            verticalCenter: parent.verticalCenter
                            right: parent.right
                            rightMargin: R.dp(4)
                        }
                    }
                    CPTextField
                    {

                        id: passTxt
                        width: parent.width - padd1.width - padd2.width
                        height: R.dp(156)
                        placeholderText: "비밀번호 (" + R.message_form_password + ")"
                        text: dummyPass
                        font.pointSize: R.font_size_common_style_login
                        maximumLength: 16
                        echoMode: TextInput.Password
                        anchors
                        {
                            left: padd3.right
                            verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }

            LYMargin
            {
                height: R.dp(20);
                width: parent.width;
                color: "white" //R.color_gray001
            }
            Rectangle
            {
                width: parent.width
                height: btnLogin.height
                color: "white" //R.color_gray001

                CPTextButton
                {
                    id: btnLogin
                    name: "로그인"
                    pointSize: R.font_size_common_style_login
                    width: parent.width //- R.dp(40)
                    anchors
                    {
                        horizontalCenter: parent.horizontalCenter
                    }


                    onClick:
                    {
                        R.log("onClicked");

                        switch(cmd.checkEmail(idTxt.text.trim()))
                        {
                        case ENums.WRONG_FORM:

                            alarm("아이디는 이메일 형식이어야 합니다.")
                            return;

                        case ENums.WRONG_LENGTH:

                            alarm("아이디는 10~50자까지 사용가능합니다.")
                            return;

                        }

                        /* 비밀번호 체크 */
                        var checkPass = cmd.checkPass(passTxt.text);
                        switch(checkPass)
                        {
                        case ENums.NO_SMALL: //R.log("NO SMALL"); break;
                        case ENums.NO_CAPITAL: //R.log("NO CAPITAL"); break;
                        case ENums.NO_NUMBER: //R.log("NO NUMBER"); break;
                        case ENums.NO_KOREAN: //R.log("NO KOREAN"); break;
                        case ENums.NO_SPECIAL_CHAR: //R.log("NO SPECIAL CHAR")
                            alarm(R.message_check_password_expression);
                            return;

                        case ENums.WRONG_LENGTH:

                            alarm(R.message_check_password_length);
                            return;

                        }

                        md.setShowIndicator(true);
                        settings.setId(idTxt.text.trim());
                        settings.setPassword(passTxt.text);
                        settings.setSnsType(ENums.SELF);
                        wk.login();
                        wk.request();
                    }
                }
            }

            Rectangle
            {
                width: parent.width
                height: R.dp(200)
                color: "white" //R.color_gray001


                Rectangle
                {
                    width: deskTxt.width + imgBox.width + R.dp(50)
                    height: parent.height
                    color: "white" //R.color_gray001
                    anchors
                    {
                        right: parent.right
                    }


                    Rectangle
                    {
                        id: imgBox
                        width: R.dp(130)
                        height: R.dp(130)
                        color: "white" //R.color_gray001

                        CPImage
                        {
                            id: img
                            width: parent.width - R.dp(50)
                            height: parent.height  - R.dp(50)
                            source: opt.ds ? R.image("finished_gray") : (settings.autoLogin ? R.image("finished") : R.image("finished_gray"))
                            anchors
                            {
                                verticalCenter: parent.verticalCenter
                                horizontalCenter: parent.horizontalCenter
                            }
                        }
                        anchors
                        {
                            verticalCenter: parent.verticalCenter
                        }
                    }

                    CPText
                    {
                        id: autoTxt
                        height: R.dp(120) //parent.height
                        font.pointSize: R.pt(45)
                        text: "자동으로 로그인하기";
                        verticalAlignment: Text.AlignBottom
                        horizontalAlignment: Text.AlignRight
                        anchors
                        {
                            top: parent.top
                            topMargin: -R.dp(10)
                            left: imgBox.right
                            leftMargin: R.dp(7)
                        }
                    }

                    CPText
                    {
                        id: deskTxt
                        height: R.dp(80) //parent.height
                        font.pointSize: R.pt(30)
                        text: "앱 실행 시 자동으로 로그인합니다.";
                        verticalAlignment: Text.AlignTop
                        horizontalAlignment: Text.AlignRight
                        anchors
                        {
                            bottom: parent.bottom
                            bottomMargin: R.dp(5)
                            left: imgBox.right
                            leftMargin: R.dp(7)
                        }
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked:
                        {
                            if(opt.ds) return;
                            settings.setAutoLogin(!settings.autoLogin);
                        }
                    }
                }

                CPHLine
                {
                    width: parent.width - R.dp(40)
                    height: R.height_line_1px
                    color: R.color_gray87
                    anchors
                    {
                        bottom: parent.bottom
                        horizontalCenter: parent.horizontalCenter
                    }
                }
            }



            Rectangle
            {
                width: parent.width
                height: R.dp(140)
                color: "transparent"



                Rectangle
                {
                    id: emallJoinBox
                    width: emailTxt.width
                    height: parent.height

                    CPText
                    {
                        id: emailTxt
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: R.font_size_common_style_login - R.pt(5)
                        text: "이메일로 가입하기"
                        color: R.color_gray87
                    }
                    anchors
                    {
                        right: parent.right
                        rightMargin: R.dp(27)
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked:
                        {
                            settings.setSnsType(ENums.SELF);
                            pushUserStack("JoinClause");
                            //                        userStackView.push(Qt.createComponent("PGJoinClause.qml"), { });
                        }
                    }
                }

                Rectangle
                {
                    id: centerLine
                    width: R.height_line_1px * 2
                    height: parent.height * 0.3
                    anchors
                    {
                        right: emallJoinBox.left
                        rightMargin: R.dp(40)
                        verticalCenter: parent.verticalCenter
                    }
                    color: R.color_gray87
                }

                Rectangle
                {
                    id: idFindBox
                    width: findTxt.width
                    height: parent.height

                    CPText
                    {
                        id: findTxt
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: R.font_size_common_style_login - R.pt(5)
                        text: "아이디/비밀번호 찾기"
                        color: R.color_gray87
                    }
                    anchors
                    {
                        right: centerLine.left
                        rightMargin: R.dp(40)
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked:
                        {
                                                        pushUserStack("FindUserInfo");
                                                        //                        userStackView.push(Qt.createComponent("PGFindUserInfo.qml"), { });
                        }
                    }
                }
            }


            LYMargin { height: R.dp(224) }
            Rectangle
            {
                width: parent.width
                height: R.dp(80)
                color: "transparent"
                anchors
                {
                    left: parent.left
                    leftMargin: R.dp(38)
                }

                CPText
                {
                    text: "SNS 로그인"
                    color: R.color_gray87
                    font.pointSize: R.font_size_common_style_login
                }
            }

            CPHLine { }
            //            LYMargin { height: R.dp(53) }

            Rectangle
            {
                id: btnRect
                width: parent.width
                height: R.dp(200)

                Item
                {
                    width: fbBtn.width + kakaoBtn.width + (btnRect.width - (fbBtn.width + kakaoBtn.width)) / 3
                    height: parent.height
                    anchors
                    {
                        verticalCenter: parent.verticalCenter
                        horizontalCenter: parent.horizontalCenter
                    }

                    CPSNSButton
                    {
                        id: fbBtn
                        sourceImage: R.image("sns_facebook")
                        name: "페이스북 로그인"
                        onEvtClicked:
                        {
                            md.setShowIndicator(true);
                            cmd.loginFacebook();
                        }
                    }

                    CPSNSButton
                    {
                        id: kakaoBtn
                        sourceImage: R.image("sns_kakao")
                        name: "카카오톡 로그인"
                        onEvtClicked:
                        {
                            md.setShowIndicator(true);
                            cmd.loginKakao();
                        }
                        anchors
                        {
                            verticalCenter: parent.verticalCenter
                            left: fbBtn.right
                            leftMargin: (btnRect.width - (fbBtn.width + kakaoBtn.width)) / 3
                        }
                    }
                }
            }

            CPHLine { }
        }
    }

    onEvtBehaviorAndroidBackButton:
    {
        R.log("????#");
        if(Qt.platform.os === R.os_name_android) md.setCRUDHandlerType(4);
        evtBack();
    }

    /* When acceessed from PGClipViewer.qml, be set the logining variable as false to control the webview. */
    //    function fromViewer()
    //    {
    //        if(from === "viewer")
    //        {
    //            R.log("If navigated from " + from + ", the variable 'loginin' would be set to the false to show the webview.");
    //            md.setUnvisibleWebView(false);
    //        }
    //    }
}
