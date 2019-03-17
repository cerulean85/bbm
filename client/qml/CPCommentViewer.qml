import QtQuick 2.9
import enums 1.0
import "Resources.js" as R


PGPage {

    id: mainView
    titleText: ""
    titleLineColor: "black"
    visibleSearchBtn: false
    visibleBackBtn: false
    visibleTitleBar: false
    visible: false

    useDefaultEvtBack: false
    onEvtBack:
    {
        if(hideOpa())
        {
            md.setUnvisibleWebView(false);
            back();
        }
    }

    function back()
    {
        commentInputController.enabled = false;
        commentInputController.textAreaFocused = false;
        noDataRect.message = R.message_load_comment;
        md.showCommentViewer(false);
        md.clearRepleList();
        noDataRect.visible = true;
        mainView.visible = false;
        hideMoveView();
    }

    Timer
    {
        running: opt.ds ? false : md.showedCommentViewer
        repeat: false
        interval: 0
        onTriggered:
        {
            R.hideKeyboard();
            commentInputController.enabled = true;
            commentInputController.textAreaFocused = false;
            mainView.visible = true;
            showMoveView();
        }
    }

    LYMargin { width: parent.width; height: R.height_line_1px; color: "black" }

    property int noClip: opt.ds ? 0 : md.currentClipNo
    property bool showCommentsDate : true

    Rectangle
    {
        id: topArea
        width: parent.width
        height: R.dp(180)
        y: settings.heightStatusBar

        CPText
        {
            id: txt_comment
            text: "댓글(" + (opt.ds ? "30" : md.clipDetail.repleCount) + ")"
            font.pointSize: R.pt(45)
            anchors
            {
                left: parent.left
                leftMargin: R.dp(80)
                verticalCenter: parent.verticalCenter
            }
        }

        CPText
        {
            id:title_txt
            text: opt.ds ? "title" : md.clipDetail.title
            elide: Text.ElideRight
            font.pointSize: R.pt(45)
            maximumLineCount: 1
            width: topArea.width - txt_comment.width - xBtn.width - R.dp(80)
            horizontalAlignment: Text.AlignHCenter
            anchors
            {
                left: txt_comment.right
                right: xBtn.left
                verticalCenter: parent.verticalCenter
            }
        }

        Rectangle
        {
            id: xBtn
            width: R.dp(120)
            height: R.dp(120)
            color: "transparent"

            CPImage
            {
                width: R.dp(120)
                height: R.dp(120)
                source: R.image(R.btn_close_gray_image)
                anchors
                {
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }
            }

            anchors
            {
                right: parent.right
                rightMargin: R.dp(30)
                verticalCenter: parent.verticalCenter
            }

            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    evtBack();
                }
            }
        }

        LYMargin
        {
            width: parent.width
            height: R.height_line_1px * 3
            color: R.color_gray001
            anchors
            {
                bottom: parent.bottom
            }
        }
    }

    Rectangle
    {
        width: R.dp(180)
        height: R.dp(45)

        CPText
        {
            id: recentlyToggle
            width: parent.width
            height: parent.height
            text: "최신순"
            font.pointSize: R.pt(45)
            color: R.color_bgColor001
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
        anchors
        {
            right: likelyRect.left
            rightMargin: R.dp(40)
            top: topArea.bottom
            topMargin: R.dp(50)
        }

        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                R.hideKeyboard();
                if(!showCommentsDate)
                {
                    //                    md.clearRepleList();
                    showCommentsDate = true;
                    recentlyToggle.color = R.color_bgColor001;
                    likelyToggle.color = R.color_gray88;

                    recentlyList.visible = true;
                    likelyList.visible = false;

                    recentlyList.contentY = 0;
                    likelyList.contentY = 0;

                    wk.getClipRepleList(noClip, 0, 1);
                    wk.request();
                }
            }
        }
    }

    Rectangle
    {
        id: likelyRect
        width: R.dp(220)
        height: R.dp(45)

        CPText
        {
            id: likelyToggle
            width: parent.width
            height: parent.height
            text: "좋아요순"
            font.pointSize: R.pt(45)
            color: R.color_gray88
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
        }
        anchors
        {
            right: parent.right
            rightMargin: R.dp(74)
            top: topArea.bottom
            topMargin: R.dp(50)
        }

        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                R.hideKeyboard();

                if(showCommentsDate)
                {
                    //                    md.clearRepleList();
                    showCommentsDate = false;
                    recentlyToggle.color = R.color_gray88;
                    likelyToggle.color = R.color_bgColor001;

                    recentlyList.visible = false;
                    likelyList.visible = true;

                    recentlyList.contentY = 0;
                    likelyList.contentY = 0;

                    wk.getClipRepleList(noClip, 1, 1);
                    wk.request();
                }
            }
        }
    }

    LYMargin
    {
        id: line
        width: parent.width; height: R.height_line_1px * 3; color: R.color_gray001;
        anchors
        {
            top: likelyRect.bottom
            topMargin: R.dp(40)
        }
    }

    CPNoData
    {
        id: noDataRect
        width: parent.width
        height: parent.height - topArea.height - likelyRect.height - line.height - commentInputController.height - _line2.height
        anchors
        {
            top: line.bottom
        }

        visible: true
        showText: true
        message: R.message_load_comment
        tMargin: R.dp(100)
    }

    Timer
    {
        running: opt.ds ? false : (wk.refreshWorkResult === ENums.WORKING_CLIPCOMMENT)
        repeat: false
        interval: 200
        onTriggered:
        {
            wk.setRefreshWorkResult(ENums.NONE);
            noDataRect.visible = true;
            noDataRect.message = R.message_load_comment;
        }
    }

    Timer
    {
        running: opt.ds ? false : wk.refreshWorkResult === ENums.FINISHED_CLIPCOMMENT
        repeat: false
        interval: 200
        onTriggered:
        {
            wk.setRefreshWorkResult(ENums.NONE);
            if(md.repleList.length === 0)
            {
                noDataRect.visible = true;
                noDataRect.message = R.message_has_no_comment;
            } else noDataRect.visible = false;
        }
    }


    CPCommentsDrawer
    {
        id: recentlyList
        filterType: 0
        height: parent.height - topArea.height - likelyRect.height - line.height - commentInputController.height - _line2.height
        anchors
        {
            top: line.bottom
        }

        onShowModifyWindow:
        {
            commentModifyWindow.boardNo = recentlyList.selectedBoardNo;
            commentModifyWindow.boardArticleNo = recentlyList.selectedBoardArticleNo;
            commentModifyWindow.targetTxt = recentlyList.selectedTxt;
            commentModifyWindow.eventType = recentlyList.eventType;
            commentModifyWindow.show();
        }
    }

    CPCommentsDrawer
    {
        id: likelyList
        filterType: 1
        visible: false
        height: parent.height - topArea.height - likelyRect.height - line.height - commentInputController.height - _line2.height
        anchors
        {
            top: line.bottom
        }
        onShowModifyWindow:
        {
            commentModifyWindow.boardNo = likelyList.selectedBoardNo;
            commentModifyWindow.boardArticleNo = likelyList.selectedBoardArticleNo;
            //            commentModifyWindow.selectedIndex = likelyList.selectedIndex;
            commentModifyWindow.currentIndex = likelyList.selectedIndex;
            commentModifyWindow.targetTxt = likelyList.selectedTxt;
            commentModifyWindow.eventType = likelyList.eventType;
            commentModifyWindow.show();
        }
    }

    Rectangle
    {
        id: commentInputBox
        width: parent.width
        height: parent.height
        color: "transparent"

        Rectangle
        {

            id: opaRect
            width: parent.width
            height: parent.height
            color: "black"
            opacity: 0.5
            visible: false
            enabled: false

            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    hideOpa();
                }
            }
        }
    }

    CPCommentEditor
    {
        id: commentInputController
        width: parent.width
        height: R.dp(300)
        visible: true
        enabled: false;
        anchors
        {
            bottom: _line2.top
        }

        onEvtPressed:
        {
            opaRect.visible = true;
            opaRect.enabled = true;
        }

        onEvtGoToLogin:
        {
            back();
            md.setCRUDHandlerType(5);
        }

        onEvtClear:
        {
            opaRect.visible = false;
            opaRect.enabled = false;
        }
    }


    Timer
    {
        id: tmOpa
        running: false
        repeat: false
        interval: 500
        onTriggered:
        {
            opaRect.visible = true;
            opaRect.enabled = true;
        }
    }

    LYMargin
    {
        id: _line2
        width: parent.width
        height: R.height_line_1px
        color: "black"
        anchors
        {
            bottom: parent.bottom
        }
    }

    CPCommentModify
    {
        id: commentModifyWindow
        width: parent.width
        height: parent.height
        onClose:
        {
            commentModifyWindow.hide();
        }
    }

    function hideOpa()
    {
        if (Qt.inputMethod.visible)
        {
            Qt.inputMethod.commit();
            Qt.inputMethod.hide();

            opaRect.visible = false;
            opaRect.enabled = false;
            return false;
        }
        commentInputController.textClear();
        return true;
    }

    function isLogined()
    {
        if(!logined())
        {
            alarmNeedLogin();
            return false;
        }
        return true;
    }

}
