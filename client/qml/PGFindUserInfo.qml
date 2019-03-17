import QtQuick 2.9
import QtQuick.Controls 2.2
import "Resources.js" as R
import enums 1.0

PGPage {
    id: mainView
    visibleSearchBtn: false
    titleText: "아이디/비밀번호 찾기"
    titleTextColor: "black"
    titleLineColor: "black"
    visibleBackBtn: true
    pageName: "FindUserInfo"

    useDefaultEvtBack: false
    onEvtBack: popUserStack();

    width: opt.ds ? R.dp(1242) : appWindow.width
    height: opt.ds ? R.dp(2208) : appWindow.height

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

            LYMargin { height: R.dp(33); width: parent.width; color: R.color_gray001; }
            LYMargin { height: R.dp(30); width: parent.width; }
            Item
            {
                width: parent.width
                height: R.dp(50)

                CPText
                {
                    width: parent.width - R.dp(120)
                    height: R.dp(50)
                    color: R.color_bgColor001
                    text: "SNS 계정 회원은 해당 서비스를 이용할 수 없습니다."
                    font.pointSize: R.font_size_common_style_login
                    anchors
                    {
                        left: parent.left
                        leftMargin: R.dp(60)
                    }
                }
            }

            Rectangle
            {
                width: parent.width
                height: R.dp(160)

                Row
                {
                    width: parent.width
                    height: R.dp(160)

                    LYMargin { width: R.dp(53) }
                    CPText
                    {
                        text: "이름"
                        color: R.color_bgColor001
                        font.pointSize: R.font_size_common_style_login
                        width: R.dp(300)
                        height: R.dp(160)
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                    }

                    LYMargin { width: R.dp(10) }
                    CPTextField
                    {
                        id: nameTxt
                        width: R.dp(800)
                        height: R.dp(160)
                        placeholderText: "이름을 입력하세요."
                        font.pointSize: R.font_size_common_style_login
                        maximumLength: 30
                    }
                }
            }
            LYMargin { height: R.height_line_1px; width: parent.width; color: R.color_bgColor001 }
            Rectangle
            {
                width: parent.width
                height: R.dp(160)

                Row
                {
                    width: parent.width
                    height: R.dp(160)

                    LYMargin { width: R.dp(53) }
                    CPText
                    {
                        text: "생년월일"
                        color: R.color_bgColor001
                        font.pointSize: R.font_size_common_style_login
                        width: R.dp(300)
                        height: R.dp(160)
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                    }

                    LYMargin { width: R.dp(10) }
                    CPTextField
                    {
                        id: birthTxt
                        width: R.dp(600)
                        height: R.dp(182)
                        placeholderText: "ex) 19950619"
                        font.pointSize: R.font_size_common_style_login
                        maximumLength: 8
                        inputMethodHints: Qt.ImhDigitsOnly
                    }
                }
            }
            LYMargin { height: R.height_line_1px; width: parent.width; color: R.color_bgColor001 }
            Rectangle
            {
                width: parent.width
                height: R.dp(160)

                Row
                {
                    width: parent.width
                    height: R.dp(160)

                    LYMargin { width: R.dp(53) }
                    CPText
                    {
                        text: "휴대폰 번호"
                        color: R.color_bgColor001
                        font.pointSize: R.font_size_common_style_login
                        width: R.dp(300)
                        height: R.dp(160)
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                    }

                    LYMargin { width: R.dp(10) }
                    CPTextField
                    {
                        id: phoneTxt
                        width: R.dp(600)
                        height: R.dp(182)
                        placeholderText: "휴대폰 번호 입력 (-제외)"
                        font.pointSize: R.font_size_common_style_login
                        maximumLength: 11
                        inputMethodHints: Qt.ImhDigitsOnly
                    }
                }
            }
            LYMargin { height: R.height_line_1px; width: parent.width; color: R.color_bgColor001 }
            CPTextButton
            {
                name: "아이디 찾기"
                pointSize: R.pt(45)
                onClick:
                {
                    /* 이름 체크 */
                    switch(cmd.checkNickname(nameTxt.text))
                    {
                    case ENums.WRONG_FORM:
                        alarm("이름에는 특수문자를 사용할 수 없습니다.");
                        return;
                    case ENums.WRONG_LENGTH:
                        alarm("이름은 2~30자까지 가능합니다.");
                        return;
                    }

                    /* 생년월일 체크 */
                    switch(cmd.checkBirth(birthTxt.text))
                    {
                    case ENums.WRONG_FORM:
                        alarm("생년월일에는 숫자만 사용가능합니다.");
                        return;

                    case ENums.WRONG_LENGTH:
                        alarm("8자로 된 생년월일을 입력해야 합니다.");
                        return;

                    case ENums.WRONG_BIRTH:
                        alarm("유효하지 않은 생년월일입니다.");
                        return;
                    }

                    /* 휴대폰 번호 체크 */
                    if(cmd.checkPhone(phoneTxt.text) !== ENums.ALL_RIGHT)
                    {
                        alarm("잘못된 번호를 입력하였습니다.");
                        return;
                    }

                    md.setShowIndicator(true);
                    wk.findID(nameTxt.text, birthTxt.text, phoneTxt.text);
                    wk.request();
                }
            }

            Timer
            {
                running: opt.ds ? false : wk.findIDResult !== ENums.WAIT
                repeat: false
                onTriggered:
                {
                    md.setShowIndicator(false);
                    if(wk.vFindIDResult() === ENums.POSITIVE)
                        alarm("찾으신 아이디는 " + md.messageStr + "입니다.");
                }
            }

            LYMargin { height: R.dp(63); width: parent.width; color: R.color_gray001; }
            LYMargin { height: R.dp(30); width: parent.width; }
            Rectangle
            {
                width: parent.width
                height: R.dp(160)

                Row
                {
                    width: parent.width
                    height: R.dp(160)

                    LYMargin { width: R.dp(53) }
                    CPText
                    {
                        text: "아이디"
                        color: R.color_bgColor001
                        font.pointSize: R.font_size_common_style_login
                        width: R.dp(300)
                        height: R.dp(160)
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                    }

                    LYMargin { width: R.dp(10) }
                    CPTextField
                    {
                        id: idTxt
                        width: R.dp(800)
                        height: R.dp(160)
                        placeholderText: "이메일을 입력하세요."
                        font.pointSize: R.font_size_common_style_login
                        maximumLength: 50
                    }
                }
            }
            LYMargin { height: R.height_line_1px; width: parent.width; color: R.color_bgColor001 }
            Rectangle
            {
                width: parent.width
                height: R.dp(160)

                Row
                {
                    width: parent.width
                    height: R.dp(160)

                    LYMargin { width: R.dp(53) }
                    CPText
                    {
                        text: "이메일"
                        color: R.color_bgColor001
                        font.pointSize: R.font_size_common_style_login
                        width: R.dp(300)
                        height: R.dp(160)
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                    }

                    LYMargin { width: R.dp(10) }
                    CPTextField
                    {
                        id: emailTxt
                        width: R.dp(800)
                        height: R.dp(182)
                        placeholderText: "가입 당시 입력한 이메일을 입력하세요."
                        font.pointSize: R.font_size_common_style_login
                        maximumLength: 50
                    }
                }
            }
            LYMargin { height: R.height_line_1px; width: parent.width; color: R.color_bgColor001 }
            CPTextButton
            {
                name: "비밀번호 찾기"
                pointSize: R.font_size_common_style_login
                onClick:
                {
                    /* 아이디 체크 */
                    switch(cmd.checkEmail(idTxt.text))
                    {
                    case ENums.WRONG_FORM:
                        alarm("아이디는 이메일 형식이어야 합니다.");
                        return;
                    case ENums.WRONG_LENGTH:
                        alarm("아이디는 10~50자까지 사용가능합니다.");
                        return;
                    }

                    /* 이메일 체크 */
                    switch(cmd.checkEmail(emailTxt.text))
                    {
                    case ENums.WRONG_FORM:
                        alarm("이메일 형식이 잘못되었습니다.");
                        return;
                    case ENums.WRONG_LENGTH:
                        alarm("이메일은 10~80자까지 입력가능합니다.");
                        return;
                    }

                    md.setShowIndicator(true);
                    wk.findPassword(idTxt.text, emailTxt.text);
                    wk.request();
                }
            }
            Timer
            {
                running: opt.ds ? false : wk.findPasswordResult !== ENums.WAIT
                repeat: false
                onTriggered:
                {
                    md.setShowIndicator(false);
                    if(wk.vFindPasswordResult() === ENums.POSITIVE)
                    {
                        alarm("입력한 이메일로 초기화된 비밀번호가 전송되었습니다.");
                    }
                }
            }
        }
    }
}
