import QtQuick 2.9
import QtQuick.Controls 2.2
import "Resources.js" as R
import enums 1.0

PGPage {
    id: mainView
    visibleSearchBtn: false
    titleText: "비밀번호 변경"
    titleTextColor: "black"
    titleLineColor: "black"
    visibleBackBtn: true
    pageName: "SetPassword"

    onEvtBack:
    {
        hideMoveView();
        md.setPopMyPage(true);
    }

    Timer
    {
        running: opt.ds ? false : (md.requestNativeBackBehavior === ENums.REQUESTED_BEHAVIOR && compareCurrentPage(pageName))
        repeat: false
        interval: 100
        onTriggered:
        {
            md.setRequestNativeBackBehavior(ENums.WAIT_BEHAVIOR);
            if(!hideAlarm()) evtBack();
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

            LYMargin { height: R.dp(66); width: parent.width; color: R.color_gray001; }
            LYMargin { height: R.height_line_1px; width: parent.width; color: R.color_bgColor001 }

            CPOptionTextInputBar
            {
                id: oldPass
                width: mainView.width
                titleWidth: R.dp(400)
                title: "기존 비밀번호"
                placeholderText: "기존의 비밀번호를 입력하세요."
                maximumLength: 16
                echoMode: TextInput.Password
            }

            LYMargin { height: R.height_line_1px; width: parent.width; color: R.color_bgColor001 }
            CPOptionTextInputBar
            {
                id: newPass
                width: mainView.width
                titleWidth: R.dp(400)
                title: "새로운 비밀번호"
                placeholderText: "새로운 비밀번호를 입력하세요."//R.message_form_password
                maximumLength: 16
                echoMode: TextInput.Password
            }
            LYMargin { height: R.height_line_1px; width: parent.width; color: R.color_bgColor001 }
            CPOptionTextInputBar
            {
                id: newRePass
                width: mainView.width
                titleWidth: R.dp(400)
                title: "비밀번호 확인"
                placeholderText: R.message_retyping_password
                maximumLength: 16
                echoMode: TextInput.Password
            }
            LYMargin { height: R.height_line_1px; width: parent.width; color: R.color_bgColor001 }
            LYMargin { height: R.dp(39) }
            CPTextButton
            {
                name: "비밀번호 변경하기"
                pointSize: R.font_size_common_style_login
                onClick:
                {
                    /* 기존 비밀번호 체크 */
                    switch(cmd.checkPass(oldPass.text))
                    {
                    case ENums.NO_SMALL:
                    case ENums.NO_CAPITAL:
                    case ENums.NO_NUMBER:
                    case ENums.NO_KOREAN:
                    case ENums.NO_SPECIAL_CHAR:
                        alarm(R.message_check_password_expression);
                        return;
                    case ENums.WRONG_LENGTH:
                        alarm(R.message_check_password_length);
                        return;
                    }

                    /* 새로운 비밀번호 체크 */
                    switch(cmd.checkPass(newPass.text))
                    {
                    case ENums.NO_SMALL:
                    case ENums.NO_CAPITAL:
                    case ENums.NO_NUMBER:
                    case ENums.NO_KOREAN:
                    case ENums.NO_SPECIAL_CHAR:
                        alarm("변경할 " + R.message_check_password_expression);
                        return;
                    case ENums.WRONG_LENGTH:
                        alarm("변경할 " + R.message_check_password_length);
                        return;
                    }

                    /* 비밀번호 체크 */
                    if(newPass.text !== newRePass.text)
                    {
                        alarm("변경할 비밀번호 확인이 틀렸습니다.\n비밀번호 확인을 다시 입력하세요.");
                        return;
                    }

                    md.setShowIndicator(true);
                    wk.updatePassword(oldPass.text, newPass.text);
                    wk.request();
                }
            }

            Timer
            {
                running: opt.ds ? false : wk.updatePasswordResult !== ENums.WAIT
                repeat: false
                onTriggered:
                {
                    md.setShowIndicator(false);
                    if(wk.vUpdatePasswordResult() === ENums.POSITIVE)
                    {
                        alarm("비밀번호가 정상적으로 변경되었습니다.");
                        ap.setYMethod(mainView, "popHomeStack");
                    } else error();
                }
            }
        }
    }
}
