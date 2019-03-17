import QtQuick 2.9
import "Resources.js" as R
import enums 1.0

Flickable
{
    property int maximumHeightRowItem: R.dp(550)
    property int dLength : opt.ds ? 10 : md.repleList.length
    id: flick
    width: opt.ds ? R.dp(1242) : parent.width
    height: R.dp(1200)
    clip: true
    contentWidth : opt.ds ? R.dp(1242) : parent.width
    contentHeight: mainColumn.height + R.dp(200)
    boundsBehavior: Flickable.StopAtBounds
    maximumFlickVelocity: R.flickVelocity(mainColumn.height)
    property int selectedBoardNo : 0
    property int selectedBoardArticleNo : 0

    property int selectedIndex: 0
    property string selectedTxt: ""
    property int eventType: 0

    property int filterType: 0

    //    property alias selectedTxt: selectedTxt
    signal showModifyWindow();

    onMovementEnded:
    {
        if(opt.ds) return;
        if(flick.atYEnd)
        {
            if(dLength % 20 == 0 && dLength > 0)
            {
//                showMoreIndicator(ENums.WORKING_CLIPCOMMENT);
                wk.getClipRepleList(md.currentClipNo, filterType, dLength / 20 + 1);
                wk.request();
            }
        }
    }

    MouseArea
    {
        anchors.fill: parent
        onClicked:
        {
            R.hideKeyboard();
        }
    }

    Column
    {
        id: mainColumn
        width: parent.width
        Repeater
        {
            id: repeater
            model: dLength

            Column
            {
                width: parent.width
                height: itemContainer.height
                Rectangle
                {
                    id: itemContainer
                    width: parent.width
                    height: itemCol.height

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked:
                        {
                            R.hideKeyboard();
                        }
                    }

                    Column
                    {
                        id: itemCol
                        width: parent.width
                        height: itemBox.height + R.dp(140) + bottomLine.height

                        LYMargin { height: R.dp(80) }

                        Rectangle
                        {
                            id: itemBox
                            width: parent.width
                            height: nickLikelyTxtRect.height + timeTxt.height + contentsTxt.height + R.dp(50)//R.dp(250)

                            Rectangle
                            {
                                width: R.dp(10)
                                height: R.dp(10)
                                color: "black"
                                radius: 50
                                anchors
                                {
                                    left:parent.left
                                    leftMargin: R.dp(104)
                                }
                                visible: opt.ds ? true : (md.repleList[index].userNo === settings.noUser?true:false)
                            }

                            MouseArea
                            {
                                anchors.fill: parent
                                onClicked:
                                {
                                    R.hideKeyboard();
                                }
                            }

                            CPImage
                            {
                                id: bestImg
                                width: opt.ds ? R.dp(75) : (md.repleList[index].good === 0 ? 0 : R.dp(75))
                                height: R.dp(40)
                                source: R.image("best")
                                anchors
                                {
                                    left: parent.left
                                    leftMargin: R.dp(255)
                                    top: parent.top
                                    topMargin: R.dp(10)
                                }
                            }

                            Rectangle
                            {
                                id: nickLikelyTxtRect
                                width: nickLikelyTxt.width
                                height: nickLikelyTxt.height

                                CPText
                                {
                                    id: nickLikelyTxt
                                    text: opt.ds ? ("꾸러기케로로 // " + index) : md.repleList[index].nickname
                                    font.pointSize: R.pt(45)
                                    //                                    font.bold: true
                                }
                                anchors
                                {
                                    left: bestImg.right
                                    leftMargin: bestImg.width > 0 ? R.dp(10) : 0
                                }

                                ColorAnimation on color {
                                    id: colorAnimator333
                                    from: R.color_gray001
                                    to: "transparent"
                                    running: false
                                    duration: 100
                                }

                                /* 사용자 프로필 보기 */
                                MouseArea
                                {
                                    anchors.fill: parent
                                    onClicked:
                                    {
                                        R.hideKeyboard();
                                        colorAnimator333.running = true;
                                        if(opt.ds) return;
                                        selectedIndex = index;
                                        showProfile.running = true;
                                    }
                                }
                            }

                            CPText
                            {
                                id: timeTxt
                                height: R.dp(80)
                                text: opt.ds ? "3분 전" : md.repleList[index].updateDate
                                font.pointSize: R.pt(40)
                                color: R.color_gray87
                                verticalAlignment: Text.AlignVCenter
                                anchors
                                {
                                    left: bestImg.left
                                    top: nickLikelyTxtRect.bottom
                                }
                            }

                            Rectangle
                            {
                                id: contentsRect
                                width: parent.width - R.dp(340)
                                height: fontMetrics.height * contentsTxt.lineCount
                                color: "transparent"

                                CPText
                                {
                                    id: contentsTxt
                                    width: parent.width
                                    text:
                                        opt.ds ?
                                            fontMetrics.height + "//" + contentsTxt.lineCount +"//" + contentsRect.height + "//11좋아요>..가나다라자차카타파하 도레미파솔라시도시라솔파미레도 하하하하하하하하히히히히. 지나가던 나그네가 강변에 앉이 있는 노인에게 해변으로 가는 길을 물었더니, 노인은 자기도 모른다며 성을 냈어요."
                                          : md.repleList[index].contents
                                    font.pointSize: R.pt(40)
                                    maximumLineCount: 3
                                }

                                FontMetrics {
                                    id: fontMetrics
                                    font.pointSize: R.pt(40)
                                }

                                anchors
                                {
                                    left: profileImg.left
                                    top: timeTxt.bottom
                                    topMargin: R.dp(20)
                                }

                                ColorAnimation on color {
                                    id: colorAnimator111
                                    from: R.color_gray001
                                    to: "transparent"
                                    running: false
                                    duration: 100
                                }

                                /* 전문보기/댓글수정하기 */
                                MouseArea
                                {
                                    anchors.fill: parent
                                    onClicked:
                                    {
                                        colorAnimator111.running = true;
                                        R.hideKeyboard();
                                        R.log("show the comment modify window.");
                                        selectedTxt = contentsTxt.text;
                                        selectedIndex = index;
                                        selectedBoardNo = md.repleList[index].boardNo;
                                        selectedBoardArticleNo = md.repleList[index].boardArticleNo;
                                        eventType = opt.ds ? ENums.UPDATE : (settings.noUser == md.repleList[index].userNo ? ENums.UPDATE : ENums.SHOW_ALL); /* 0:댓글수정, 1:전문보기 */
                                        showModifyWindow();
                                    }
                                }
                            }

                            /* 신고/삭제하기 버튼 : 로그인 필요 */
                            CPTextButton
                            {
                                id: funcBtn
                                width: R.dp(200)
                                height: R.dp(80)
                                color: "transparent"
                                subColor: R.color_gray001
                                txtColor: R.color_bgColor001
//                                visible: md.repleList[index].userNo > 0
                                name: opt.ds ? "신고하기" : (md.repleList[index].userNo === settings.noUser ? "삭제하기" : "신고하기")
                                pointSize: R.pt(40)
                                onClick:
                                {
                                    R.log("신고하기")
                                    if(opt.ds) return;

                                    if(!isLogined(false)) return;

                                    selectedBoardNo = md.repleList[index].boardNo;
                                    selectedBoardArticleNo = md.repleList[index].boardArticleNo;
                                    selectedIndex = index;
                                    if(md.repleList[index].userNo === settings.noUser)
                                    {
                                        R.log("댓글 삭제하기");
                                        ap.setVisible(true);
                                        ap.setMessage("댓글을 삭제하시겠습니까?");
                                        ap.setYButtonName("예");
                                        ap.setNButtonName("아니오");
                                        ap.setButtonCount(2);
                                        ap.setYMethod(flick, "deleteComment");
                                    }
                                    else
                                    {
                                        R.log("댓글 신고하기");
                                        eventType = ENums.REPORT; /* 댓글신고 */
                                        showModifyWindow();
                                    }
                                }
                                anchors
                                {
                                    left: timeTxt.right
                                    leftMargin: R.dp(20)
                                    bottom: timeTxt.bottom
                                }
                            }

                            CPProfileImage
                            {
                                id: profileImg
                                width: R.dp(112)
                                height: R.dp(112)
                                sourceImage: opt.ds ? R.image("user") : R.toHttp(md.repleList[index].profileThumbNailUrl)
                                anchors
                                {
                                    left: parent.left
                                    leftMargin: R.dp(112)
                                }
                            }

                            /* 좋아요 버튼 */
                            CPClipViewerCommentLikeButton
                            {
                                id: likeButton
                                visible: opt.ds ? true : (md.repleList[index].userNo > 0)
                                selected: opt.ds ? true : md.repleList[index].like
                                likeCount: opt.ds ? 202 : md.repleList[index].likeCount
                                anchors
                                {
                                    right: parent.right
                                    rightMargin: R.dp(50)
                                    verticalCenter: parent.verticalCenter
                                }
                                onEvtClicked:
                                {
                                    if(opt.ds)
                                    {
                                        selected = !selected;
                                        return;
                                    }

                                    if(!isLogined(false)) return;

                                    if(settings.noUser === md.repleList[index].userNo)
                                    {
                                        alarm("본인의 글에 좋아요할 수 없습니다.");
                                        return;
                                    }


                                    selectedBoardNo = md.repleList[index].boardNo;
                                    selectedBoardArticleNo = md.repleList[index].boardArticleNo;
                                    selectedIndex = index;
                                    R.log("[LIKE BUTTON]Confirm the clicked INDEX to like >> " + index);
                                    wk.setClipRepleLike(selectedBoardArticleNo, selectedBoardNo, !likeButton.selected);
                                    wk.request();
                                }
                            }
                            LYMargin {
                                id: bottomLine
                                width: parent.width; height: R.height_line_1px; color: R.color_grayE1
                                anchors
                                {
                                    bottom: parent.bottom
                                    bottomMargin: R.dp(-60)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Timer
    {
        running: opt.ds ? false : (wk.setClipRepleLikeResult !== ENums.WAIT)
        repeat: false
        interval: 300
        onTriggered:
        {

            var type = wk.volSetClipRepleLikeResult();
            if(type === ENums.NAGATIVE)
            {
                R.log("[LIKE TIMER]Confirm the result NAGATIVE.");
                error();
            }
            else if(type === ENums.POSITIVE)
            {
                R.log("[LIKE TIMER]Confirm the result POSITIVE.");
                //                var currentLike = md.repleList[selectedIndex].like;
                //                md.repleList[selectedIndex].setLike(!currentLike);

                //                if(currentLike) //true->false
                //                    md.repleList[selectedIndex].setLikeCount(md.repleList[selectedIndex].likeCount-1);
                //                else    //false->true
                //                    md.repleList[selectedIndex].setLikeCount(md.repleList[selectedIndex].likeCount+1);
            }
        }
    }

    Timer
    {
        id: showProfile
        running: false
        repeat: false
        interval: 300
        onTriggered:
        {
            if(md.repleList[selectedIndex].userNo < 1)
            {
                ap.setVisible(true);
                ap.setMessage(R.message_withdraw_user);
                ap.setYButtonName("확인");
                ap.setButtonCount(1);
                ap.setYMethod(flick, "empty");
                return;
            }
            R.log("SHOW PROFILE.");
            R.log("DEBUG >> selectedIndex :" + selectedIndex);
            R.log("DEBUG >> " + md.repleList[selectedIndex].userNo);
            pushHomeStack("OtherProfile", { "targetUserNo": md.repleList[selectedIndex].userNo });
        }
    }

    OpacityAnimator
    {
        target: flick;
        from: 1;
        to: 0;
        running: !flick.visible
    }

    OpacityAnimator
    {
        target: flick;
        from: 0;
        to: 1;
        duration: 500
        running: flick.visible
    }

    function empty(){}
    function deleteComment()
    {
        R.log("댓글 삭제하기~");
        selectedBoardNo = md.repleList[selectedIndex].boardNo;
        selectedBoardArticleNo = md.repleList[selectedIndex].boardArticleNo;
        wk.deleteClip(selectedBoardArticleNo, selectedBoardNo);
        wk.request();
    }
}

