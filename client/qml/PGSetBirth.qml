import QtQuick 2.9
import QtQuick.Controls 2.2
import "Resources.js" as R
import enums 1.0

PGPage {

    id: mainView
    visibleSearchBtn: false
    titleText: "생일 설정"
    titleTextColor: "black"
    titleLineColor: "black"
    visibleBackBtn: true

    property string currentBirth: ""
    function setCurrentBirth(birth)
    {
        currentBirth = birth;
    }

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
                id: targetTxt
                width: mainView.width
                titleWidth: R.dp(400)
                title: "생년월일"
                placeholderText: "ex) 19950619"
                current: opt.ds ? "" : R.replaceAll(currentBirth, "-")
                maximumLength: 8
                inputMethodHints: Qt.ImhDigitsOnly
            }
            LYMargin { height: R.height_line_1px; width: parent.width; color: R.color_bgColor001 }
            LYMargin { height: R.dp(39) }
            CPTextButton
            {
                name: "생년월일 변경하기"
                pointSize: R.font_size_common_style_login
                onClick:
                {
                    if(targetTxt.text === R.replaceAll(currentBirth, "-"))
                    {
                        alarm("현재 생년월일과 동일합니다.");
                        return;
                    }

                    /* 생년월일 체크 */
                    var checkBirth = cmd.checkBirth(targetTxt.text);
                    switch(checkBirth)
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


                    case ENums.ALL_RIGHT:

                        md.setShowIndicator(true);
                        settings.setBirth(targetTxt.text);
                        wk.updateUserProfile(false);
                        wk.request();
                        break;

                    }
                }
            }
        }
    }
}
