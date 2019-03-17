import QtQuick 2.9
import QtQuick.Controls 2.2
import "Resources.js" as R
import enums 1.0

PGPage {

    id: mainView
    visibleSearchBtn: false
    titleText: "계정 설정"
    titleTextColor: "black"
    titleLineColor: "black"
    visibleBackBtn: true
    pageName: "SetAccount"

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
                        width: R.dp(393)
                        height: R.dp(160)
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                    }

                    LYMargin { width: R.dp(10) }
                    Rectangle
                    {
                        width: parent.width - R.dp(53) - R.dp(393) - R.dp(10)
                        height: R.dp(160)

                        CPText
                        {
                            id: idTxt
                            height: R.dp(160)
                            font.pointSize: R.font_size_common_style_login
                            color: R.color_gray87
                            text:
                            {
                                if(opt.ds) return "easfafaxample@example.com"

                                switch(settings.snsType)
                                {
                                case ENums.SELF: return settings.id;
                                case ENums.KAKAO: return "카카오톡 계정으로 로그인됨"
                                case ENums.FACEBOOK: return "페이스북 계정으로 로그인됨"
                                }
                            }
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignRight
                            anchors
                            {
                                right: parent.right
                                rightMargin: R.dp(53)
                            }
                        }

                        CPImage
                        {
                            id: snsImg
                            width: R.dp(80)
                            height: R.dp(80)
                            source:
                            {
                                if(opt.ds) return R.image("sns_kakao");

                                switch(settings.snsType)
                                {
                                case ENums.SELF: return "";
                                case ENums.KAKAO: return R.image("sns_kakao");
                                case ENums.FACEBOOK: return R.image("sns_facebook");
                                }
                            }

                            anchors
                            {
                                verticalCenter: parent.verticalCenter
                                right: idTxt.left
                                rightMargin: R.dp(30)
                            }
                        }
                    }
                }
            }
            LYMargin { height: R.height_line_1px; width: parent.width; color: R.color_bgColor001 }
            Rectangle
            {
                width: parent.width
                height: R.dp(160)
                visible:
                {
                    if(opt.ds) return true;

                    switch(settings.snsType)
                    {
                    case ENums.KAKAO:
                    case ENums.FACEBOOK:
                        return false;
                    default: return true;
                    }
                }

                Row
                {
                    width: parent.width
                    height: R.dp(160)

                    LYMargin { width: R.dp(53);}
                    CPText
                    {
                        text: "비밀번호 변경"
                        color: R.color_bgColor001
                        font.pointSize: R.font_size_common_style_login
                        width: R.dp(393)
                        height: R.dp(160)
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                    }

                    Item
                    {
                        width: parent.width - R.dp(53) - R.dp(393)
                        height: R.dp(160)
                        CPImage
                        {
                            width: R.dp(28)
                            height: R.dp(50)
                            source: R.image("gray_go")
                            anchors
                            {
                                right: parent.right
                                rightMargin: R.dp(60)
                                verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                }

                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        colorAnimator.running = true;

                        if(opt.ds) return;
                        pushHomeStack("SetPassword", { });
                    }
                }

                ColorAnimation on color {
                    id: colorAnimator
                    from: R.color_bgColor003
                    to: "white"
                    running: false
                    duration: 100
                }

                LYMargin
                {
                    height: R.height_line_1px;
                    width: parent.width;
                    color: R.color_bgColor001
                    anchors
                    {
                        bottom: parent.bottom
                    }
                }
            }

        }
    }
}
