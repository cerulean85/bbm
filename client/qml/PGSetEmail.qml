import QtQuick 2.9
import QtQuick.Controls 2.2
import "Resources.js" as R
import enums 1.0

PGPage {

    id: mainView
    visibleSearchBtn: false
    titleText: "이메일 설정"
    titleTextColor: "black"
    titleLineColor: "black"
    visibleBackBtn: true
//    pageName: "SetEmail"
    property string currentEmail: ""
    function setCurrentEmail(email)
    {
        currentEmail = email;
    }

    onEvtBack:
    {
        hideMoveView();
        md.setPopMyPage(true);
    }

//    Timer
//    {
//        running: opt.ds ? false : (md.requestNativeBackBehavior === ENums.REQUESTED_BEHAVIOR && compareCurrentPage(pageName))
//        repeat: false
//        interval: 100
//        onTriggered:
//        {
//            md.setRequestNativeBackBehavior(ENums.WAIT_BEHAVIOR);
//            if(!hideAlarm()) evtBack();
//        }
//    }

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
                id: targetTxt
                width: mainView.width
                titleWidth: R.dp(400)
                title: "이메일"
                placeholderText: "변경할 이메일을 입력하세요."
                current: opt.ds ? "" : currentEmail
                maximumLength: 50
            }
            LYMargin { height: R.height_line_1px; width: parent.width; color: R.color_bgColor001 }
            LYMargin { height: R.dp(39) }
            CPTextButton
            {
                name: "이메일 변경하기"
                pointSize: R.font_size_common_style_login
                onClick:
                {
                    if(targetTxt.text === currentEmail)
                    {
                        alarm("현재 이메일과 동일합니다.");
                        return;
                    }

                    /* 이메일 체크 */
                    var checkEmail = cmd.checkEmail(targetTxt.text);
                    switch(checkEmail)
                    {
                    case ENums.WRONG_FORM:

                        alarm("이메일 형식이 잘못되었습니다.");
                        return;

                    case ENums.WRONG_LENGTH:

                        alarm("이메일은 10~50자까지 입력가능합니다.");
                        return;

                    case ENums.ALL_RIGHT:

                        md.setShowIndicator(true);
                        settings.setEmail(targetTxt.text);
                        wk.updateUserProfile(false);
                        wk.request();
                        break;

                    }
                }
            }
        }
    }
}
