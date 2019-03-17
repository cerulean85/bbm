import QtQuick 2.9
import QtGraphicalEffects 1.0
import "Resources.js" as R

Rectangle
{
    id: mainView
    width: R.dp(1242)
    height: R.dp(2208)
    opacity: opt.ds ? 1 : 0
    enabled: opt.ds ? true : false
    color: "#aa000000"
    signal evtExit();

    property string source : ""
//        opt.ds ? "https://scontent-sjc3-1.cdninstagram.com/vp/eaf56aa30148a578e29d34631cb84968/5BB12F51/t51.2885-15/e35/26156236_123939068416546_2742507055683207168_n.jpg"
//               : md.noticePopup.imageUrl
//        opt.ds ?
//            "https://scontent-sjc3-1.cdninstagram.com/vp/eaf56aa30148a578e29d34631cb84968/5BB12F51/t51.2885-15/e35/26156236_123939068416546_2742507055683207168_n.jpg" :
//            md.noticePopup.imageUrl

    property int btnHeight: R.dp(180)
    property int btnFontSize: R.pt(50)

    signal evtClicked();

    MouseArea
    {
        anchors.fill: parent
    }

    Rectangle
    {
        width: parent.width - R.dp(200)
        height: img.status != Image.Ready ? mainView.height * 0.6 : (img.height + R.dp(200))
        anchors
        {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
        radius: 10

        CPOSSpecifiedImage
        {
            id: img
            dWidth: parent.width
            source: mainView.source
            visible: false
        }

        Rectangle
        {
            id: imgRect
            width: parent.width
            height: img.height
            radius: 10
            visible: false

            Rectangle
            {
                height: imgRect.radius
                anchors
                {
                    bottom: imgRect.bottom
                    left: imgRect.left
                    right: imgRect.right
                }
            }
        }

        OpacityMask {
            anchors.fill: img
            source: img
            maskSource: imgRect
        }

        CPMouseArea
        {
            anchors.fill: parent
            onEvtClicked:
            {
                md.setCurrentBoardNo(md.noticePopup.boardNo);
                md.setCurrentBoardArticleNo(md.noticePopup.boardArticleNo);
                mainView.evtClicked();
                hide();
            }
        }

        Rectangle
        {
            id: noShowBtn
            width: noShowCheck.width + noShowText.width + R.dp(50)
            height: btnHeight
            color: "transparent"
            anchors
            {
                left: parent.left
                leftMargin: R.dp(20)
                bottom: parent.bottom
            }

            CPCheckBox
            {
                id: noShowCheck
                width: R.dp(100)
                height: R.dp(100)
                checked: false
                anchors
                {
                    left: parent.left
                    leftMargin: R.dp(30)
                    verticalCenter: parent.verticalCenter
                }
                onEvtChecked:
                {

                }
            }

            CPText
            {
                id: noShowText
                height: parent.height
                text: "다시 보지 않기"
                font.pointSize: btnFontSize
                verticalAlignment: Text.AlignVCenter
                anchors
                {
                    left: noShowCheck.right
                    leftMargin: R.dp(20)
                }
            }

            CPMouseArea
            {
                width: parent.width
                height: parent.height
                onAnimation: false

                onEvtDS:
                {
                    if(opt.ds) noShowCheck.checked = !noShowCheck.checked;
                }

                onEvtClicked:
                {
                    noShowCheck.checked = !noShowCheck.checked;
                }
            }
        }

        Rectangle
        {
            id: closeBtn
            width: closeTxt.width + R.dp(100)
            height: btnHeight
            color: "transparent"
            anchors
            {
                right: parent.right
                bottom: parent.bottom
            }

            CPText
            {
                id: closeTxt
                height: parent.height
                text: "닫기"
                color: R.color_bgColor001
                font.pointSize: btnFontSize
                verticalAlignment: Text.AlignVCenter
                anchors
                {
                    right: parent.right
                    rightMargin: R.dp(50)
                }
            }

            CPMouseArea
            {
                width: parent.width
                height: parent.height
                onAnimation: false
                onEvtDS:
                {
                    hide();
                }
                onEvtClicked:
                {
                    if(noShowCheck.checked)
                    {
                        settings.setNoShowNoticePopupNo(md.noticePopup.popupNo);
                    }
                    hide();
                }
            }
        }
    }

    OpacityAnimator
    {
        id: offAnim
        target: mainView;
        from: 1;
        to: 0;
    }

    OpacityAnimator
    {
        id: onAnim
        target: mainView;
        from: 0;
        to: 1;
        duration: 500
    }

    function show()
    {
        onAnim.running = true;
        enabled = true;
    }

    function hide()
    {
        offAnim.running = true;
        enabled = false;
    }
}
