import QtQuick 2.9
import QtQuick.Controls 2.2
import "Resources.js" as R
import enums 1.0

PGPage {

    id: mainView
    visibleSearchBtn: false
    titleText: "닉네임 설정"
    titleTextColor: "black"
    titleLineColor: "black"
    visibleBackBtn: true
    pageName: "SetNickname"

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
                title: "닉네임"
                placeholderText: "변경할 닉네임을 입력하세요."
                current: opt.ds ? "" : settings.nickName
                maximumLength: 30
            }
            LYMargin { height: R.height_line_1px; width: parent.width; color: R.color_bgColor001 }
            LYMargin { height: R.dp(39) }
            CPTextButton
            {
                name: "닉네임 변경하기"
                pointSize: R.font_size_common_style_login
                onClick:
                {
                    if(targetTxt.text === settings.nickName)
                    {
                        alarm("현재 닉네임과 동일합니다.");
                        return;
                    }

                    switch(cmd.checkNickname(targetTxt.text))
                    {
                    case ENums.NO_SPECIAL_CHAR:
                        alarm("닉네임에는 특수문자를 사용할 수 없습니다.")("확인");
                        break;

                    case ENums.NO_KOREAN_INITIAL:
                        alarm("닉네임에는 한글 초성을 사용할 수 없습니다.")
                        break;

                    case ENums.WRONG_LENGTH:
                        alarm("닉네임은 2~30자까지 사용가능합니다.")
                        break;

                    case ENums.ALL_RIGHT:
                        md.setShowIndicator(true);
                        settings.setNickName(targetTxt.text);
                        wk.updateUserProfile(false);
                        wk.request();
                        break;
                    }
                }
            }
        }
    }
}
