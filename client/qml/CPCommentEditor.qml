import QtQuick 2.9
import QtQuick.Controls 2.2
//import QtQuick.Controls 1.4
import enums 1.0
import "Resources.js" as R

Rectangle
{
    id: inputComment
    visible: opt.ds ? true : false
    width: parent.width
    height: R.dp(215)
//    anchors
//    {
//        bottom: parent.bottom
//    }

    property int boardNo : opt.ds ? 0 : md.currentClipNo
    property alias commentStr: commentField.text
    signal evtGoToLogin();
    signal evtPressed();
    signal evtClear();

    property alias textAreaFocused : commentField.focus

    property string deskText: !settings.logined ? "로그인 후 이용가능합니다." : "부적절한 글은 삭제될 수 있습니다."

    Component.onCompleted:
    {
        R.hideKeyboard();
    }

    Rectangle
    {
        id: commentFieldRect
        width: parent.width - confirmButton.width - R.dp(10)
        height: parent.height - R.dp(10)

//        anchors
//        {
//            left: parent.left
//            leftMargin: R.dp(10)
//        }

        ScrollView
        {
            id: scv
            width: commentFieldRect.width
            height: parent.height
            clip: true

            TextArea
            {
                id: commentField
                placeholderText: deskText
                font.pointSize: R.pt(50)
                wrapMode: TextEdit.Wrap
                width: scv.width - R.dp(200)
                height: scv.height * 10
                font.family: fontLoader.name
                padding: R.dp(30)
                focus: false
                onPressed:
                {
                    evtPressed();
                    commentField.padding = R.dp(30)
                }
            }

            FontLoader {
                id: fontLoader
                source:R.system_font;
            }

        }

    }


    Rectangle
    {
        id: confirmButton
        width: R.dp(275)
        height: parent.height
        color: R.color_bgColor001
        anchors
        {
            right: parent.right
        }

        CPText
        {
            font.pointSize: R.pt(50)
            width: parent.width
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            text: "확인"
            color: "white"
        }

        ColorAnimation on color {
            id: commentInputAnimator
            from: R.color_bgColor003
            to: R.color_bgColor001
            running: false
            duration: 100
        }

        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                R.hideKeyboard();

                var targetText = commentField.text;
                commentField.text = "";
                commentField.padding = R.dp(30)
//                commentField.placeholderText = deskText;
                commentInputAnimator.running = true

                if(opt.ds) return;

//                if(!settings.logined)
//                {
//                    evtGoToLogin();
                    //                    alarmNeedLogin();
//                    alarm2(R.message_need_login);
//                    ap.setYMethod(inputComment, "goToLogin");
//                    return;
//                }

                if(targetText === "")
                {
                    alarm("내용을 입력하세요.");
                    return;
                }


                wk.setClipReple(boardNo, targetText, "", "", "");
                wk.request();
            }
        }

        Timer
        {
            running: opt.ds ? false : wk.setClipRepleResult !== ENums.WAIT
            repeat: false
            interval: 100
            onTriggered:
            {
                var type = wk.volSetClipRepleResult();
                if(type === ENums.NAGATIVE) error();
                textClear();
            }
        }
    }

    LYMargin { width: parent.width; height: R.height_line_1px * 3; color: R.color_gray001 }

    function textClear()
    {
        R.hideKeyboard();
        evtClear();
        commentField.text = "";
    }

    MouseArea
    {
        anchors.fill: parent
        enabled: !settings.logined
        onClicked:
        {
            evtGoToLogin();
        }
    }
}
