import QtQuick 2.9
import QtQuick.Controls 2.2
import "Resources.js" as R
import enums 1.0

PGPage {

    id: mainView
    visibleSearchBtn: false
    titleText: "성별 설정"
    titleTextColor: "black"
    titleLineColor: "black"
    visibleBackBtn: true
//    pageName: "SetGender"

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
            Rectangle
            {
                width: parent.width
                height: R.dp(160)
                CPText
                {
                    id: genderTxt
                    text: "성별"
                    color: R.color_bgColor001
                    font.pointSize: R.font_size_common_style_login
                    width: R.dp(400)
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    anchors
                    {
                        left: parent.left
                        leftMargin: R.dp(56)
                    }
                }
                CPGenderSelector
                {
                    id: target
                    width: parent.width - genderTxt.width
                    _selectedSex: opt.ds ? 0 : settings.gender
                    anchors
                    {
                        left: genderTxt.right
                    }
                }
            }
            LYMargin { height: R.height_line_1px; width: parent.width; color: R.color_bgColor001 }
            LYMargin { height: R.dp(39) }
            CPTextButton
            {
                name: "성별 변경하기"
                pointSize: R.font_size_common_style_login
                onClick:
                {
                    if(target.selectedSex === settings.gender)
                    {
                        alarm("현재 성별과 동일합니다.");
                        return;
                    }

                    md.setShowIndicator(true);
                    settings.setGender(target.selectedSex);
                    wk.updateUserProfile(false);
                    wk.request();
                }
            }
        }
    }
}
