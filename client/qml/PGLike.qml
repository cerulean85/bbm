import QtQuick 2.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import "Resources.js" as R
import enums 1.0

PGProto
{
    id: rectMain
    useToMoveByPush: false
    width: opt.ds ? R.dp(1242) : appWindow.width
    height: opt.ds ? R.dp(2208) : appWindow.height

    property int dClipLength : opt.ds ? 20 : (md.likeClipList.length)
    property int dRepleLength : opt.ds ? 20 : (md.likeRepleList.length)
    property int widthListItem : R.dp(1080)
    property int widthCategoryArea: rectMain.width * 0.5
    property int heightListItemImg : R.height_course_list_thumb
    property int heightListItemLb : R.dp(120)
    property int heightCategoryArea: R.dp(137)
    property int heightScvPadding: R.dp(10)
    property int heightListItem : heightListItemImg + heightListItemLb
    property int heightRepleListItem : R.dp(450)
    property int selectedCategoryNo: 0
    property int selectedIndex: 0

    Timer
    {
        id: clipLikeDataGetter
        running: false
        repeat: false
        interval: 300
        onTriggered:
        {
            wk.getClipLikeList(1);
            wk.request();
        }
    }

    function getClipLikeData()
    {
        wk.setRefreshWorkResult(ENums.NONE);
        clipLikeDataGetter.running = true;
    }

    Timer
    {
        id: repleLikeDataGetter
        running: false
        repeat: false
        interval: 300
        onTriggered:
        {
            wk.getRepleLikeList(1);
            wk.request();
        }
    }

    Rectangle
    {
        id: scvPadding
        width: parent.width
        height: heightScvPadding
        color: "#f5f6f6"//R.color_theme01
        z: 3
    }


    ScrollView
    {
        id: scvCategory
        width: parent.width
        height: heightCategoryArea
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        y: heightScvPadding
        z: 3

        Rectangle
        {
            width: widthCategoryArea * (opt.ds ? 2 : md.catelikelist.length)
            height: heightCategoryArea
            color: "white"
            Row
            {
                width: parent.width
                height: parent.height
                Repeater
                {
                    model: opt.ds ? 2 : md.catelikelist.length

                    Rectangle
                    {
                        width: widthCategoryArea; height: heightCategoryArea;
                        color:"transparent"

                        Column
                        {
                            width: widthCategoryArea; height: parent.height;
                            LYMargin { height: R.dp(10)}
                            CPText
                            {
                                font.pointSize: R.font_size_category_button
                                width: widthCategoryArea
                                height: heightCategoryArea - R.dp(20) - R.dp(6)
                                text:
                                {
                                    if(opt.ds) return "Untitled";

                                    if(index == 0) return "클립별";
                                    else return "댓글별";
                                }
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                color: "black"
                            }
                            Rectangle
                            {
                                width: widthCategoryArea; height: R.dp(6);
                                color: opt.ds ? R.color_bgColor001 : (md.catelikelist[index].selected ? R.color_theme01 : "#f5f6f6");
                            }
                            LYMargin { height: R.dp(10)}
                        }
                        MouseArea
                        {
                            anchors.fill: parent
                            onClicked:
                            {
                                if(opt.ds) return;

                                if(md.catelikelist[index].selected) return;

                                clearCategoryButtons();
                                md.catelikelist[index].select(true);
                                selectedCategoryNo = index;

                                wk.setRefreshWorkResult(ENums.NONE);
                                if(index == 0)
                                {
                                    flickClipLike.visible = true;
                                    flickRepleLike.visible = false;
                                    md.clearLikeRepleList();
                                    clipLikeDataGetter.running = true;
                                    setLikeTabName("Clip");
                                }
                                else
                                {
                                    flickClipLike.visible = false;
                                    flickRepleLike.visible = true;
                                    md.clearLikeClipList();
                                    repleLikeDataGetter.running = true;
                                    setLikeTabName("Reple");
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    CPNoData
    {
        width: parent.width
        height: parent.height //- heightCategoryArea - R.dp(10)
        visible: opt.ds ? false : (dClipLength == 0 && selectedCategoryNo == 0)
        showText: true
        message: opt.ds ? R.message_has_no_clip_list : (wk.refreshWorkResult !== ENums.FINISHED_MAIN ? R.message_load_clip_item_list : R.message_has_no_clip_list)
    }

    CPNoData
    {
        width: parent.width
        height: parent.height //- heightCategoryArea - R.dp(10)
        visible: opt.ds ? false : (dRepleLength == 0 && selectedCategoryNo == 1)
        showText: true
        message: opt.ds ? R.message_has_no_comment : (wk.refreshWorkResult !== ENums.FINISHED_MAIN ? R.message_load_comment : R.message_has_no_comment)
    }

    Timer
    {
        running: opt.ds ? false : (wk.setClipLikeResult !== ENums.WAIT)
        repeat: false
        interval: 300
        onTriggered:
        {
            var result = wk.vSetClipLikeResult();
            if(result === ENums.NAGATIVE) error();
        }
    }

    Flickable
    {
        id: flickClipLike
        anchors.fill: parent
        contentWidth : parent.width
        contentHeight: heightCategoryArea + heightScvPadding + heightListItem * dClipLength + settings.heightStatusBar + R.height_titleBar
        maximumFlickVelocity: R.flickVelocity(heightListItem * dClipLength)
        visible: opt.ds ? false : (dClipLength > 0)
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        z: 2

        onMovementEnded:
        {
            if(opt.ds) return;
            if(flickClipLike.atYEnd)
            {
                if(dClipLength % 20 == 0 && dClipLength > 0)
                {
                    showMoreIndicator(ENums.WORKING_MAIN);
                    wk.getClipLikeList(dClipLength / 20 + 1);
                    wk.request();
                }
            }
        }

        Column
        {
            id: mainColumn
            width: parent.width
            height: flickClipLike.height

            Rectangle
            {
                width: parent.width
                height: heightCategoryArea + heightScvPadding
                color: "transparent"
            }

            Rectangle {

                id: rectList
                width: parent.width
                height: dClipLength == 0 ? parent.height : heightListItem * dClipLength
                color: "transparent"

                Column
                {
                    width: parent.width
                    height: heightListItem * dClipLength
                    Repeater
                    {
                        id: rt
                        model: dClipLength
                        Rectangle
                        {
                            width: parent.width
                            height: heightListItem
                            color: "transparent"

                            CPImageView
                            {
                                width: parent.width
                                height: heightListItemImg
                                animateCond:
                                {
                                    if(index < 5) return true;
                                    else
                                    {
                                        /* FOR REFRESH. */
                                        if(!opt.ds && md.likeClipList[index].showed) {
                                            injectedOpacityValue = 1.0;
                                            return false;
                                        }
                                        if(opacityValue < 0.5 ) return (flickClipLike.contentY > R.dp(200) + heightListItem * (index-5))
                                        return false;
                                    }
                                }
                                src : opt.ds ? "../img/no_image.png" : (md.likeClipList[index].thumbnailUrl === "" ? "" : /*"image://async/"+*/md.likeClipList[index].thumbnailUrl)
                            }

                            Rectangle
                            {
                                width: parent.width
                                height: heightListItemLb
                                y: heightListItemImg
                                color: "white"

                                CPText
                                {
                                    text:
                                    {
                                        if(opt.ds) return "[cateogory]  " + (index+1) + ". untitled";
                                        else return md.likeClipList[index].title
                                    }
                                    font.pointSize: R.pt(45)
                                    color: "black"
                                    anchors
                                    {
                                        left: parent.left
                                        leftMargin: R.dp(20)
                                        top: parent.top
                                        topMargin: R.dp(20)

                                    }
                                }

                                CPText
                                {
                                    text: "조회수" + (opt.ds ? "999" : md.likeClipList[index].viewCount)
                                    font.pointSize: R.pt(40)
                                    color: "gray"
                                    anchors
                                    {
                                        right: parent.right
                                        rightMargin: R.dp(20)
                                        top: parent.top
                                        topMargin: R.dp(25)
                                    }
                                }
                            }


                            CPMouseArea
                            {
                                width: parent.width
                                height: parent.height

                                onEvtClicked:
                                {
                                    var courseNo = md.likeClipList[index].courseNo;
                                    var clipNo = md.likeClipList[index].lessonSubitemNo;
                                    R.log("course No: " + courseNo + ", clip No: " + clipNo);
                                    pushClipViewer(clipNo, courseNo, index, R.viewer_from_like_clip);


                                }
                            }

                            Rectangle
                            {
                                width: R.dp(150)
                                height: R.dp(150)
                                color: "transparent"

                                anchors
                                {
                                    right: parent.right
                                    rightMargin: R.dp(0)
                                    top: parent.top
                                    topMargin: R.dp(0)
                                }

                                Item
                                {
                                    id: basePos
                                    width: 1; height: 1;
                                    anchors
                                    {
                                        verticalCenter: parent.verticalCenter
                                        horizontalCenter: parent.horizontalCenter
                                    }
                                }

                                Rectangle
                                {
                                    id: likeIcon
                                    width: R.dp(80)
                                    height: R.dp(80)
                                    color: "transparent"

                                    anchors
                                    {
                                        horizontalCenter: parent.horizontalCenter
                                        top: basePos.top
                                        topMargin: R.dp(-50)
                                    }
                                    CPImage
                                    {
                                        id: likeImg
                                        width: parent.width
                                        height: parent.height
                                        source: opt.ds ? R.image("mypage_like") : (md.likeClipList[index].selected ? R.image("mypage_like_pink") : R.image("mypage_like"))
                                        anchors
                                        {
                                            horizontalCenter: parent.horizontalCenter
                                            verticalCenter: parent.verticalCenter
                                        }
                                    }
                                }

                                CPText
                                {
                                    id: likeTxt
                                    width: parent.width
                                    color: "black"
                                    text: opt.ds ? "999" : md.likeClipList[index].likeCount
                                    font.pointSize: R.pt(40)
                                    visible: false
                                    horizontalAlignment: Text.AlignHCenter
                                    anchors
                                    {
                                        top: likeIcon.bottom
                                        //                                        topMargin: R.dp(-20)
                                    }
                                }

                                CPMouseArea
                                {
                                    width: parent.width + R.dp(100)
                                    height: parent.height + R.dp(100)
                                    onAnimation: false

                                    onEvtClicked:
                                    {
                                        if(opt.ds)
                                        {
                                            likeImg.source = R.image("mypage_like_pink");
                                            return;
                                        }
                                        selectedIndex = index;
                                        var currentSelected = md.likeClipList[index].selected;
                                        md.likeClipList[selectedIndex].select(!currentSelected);
                                        wk.setClipLike(md.likeClipList[index].courseNo, md.likeClipList[index].lessonSubitemNo, !currentSelected);
                                        wk.request();
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Flickable
    {
        id: flickRepleLike
        anchors.fill: parent
        contentWidth : parent.width
        contentHeight: heightCategoryArea + heightScvPadding + /* heightRepleListItem * dRepleLength*/repleListView.height + settings.heightStatusBar + R.height_titleBar
        maximumFlickVelocity: R.flickVelocity(heightListItem * dRepleLength)
        clip: true
        visible: opt.ds ? true : (dRepleLength > 0)
        boundsBehavior: Flickable.StopAtBounds
        z: 2

        onMovementEnded:
        {
            if(opt.ds) return;
            if(flickClipLike.atYEnd)
            {
                if(dRepleLength % 20 == 0 && dRepleLength > 0)
                {
                    showMoreIndicator(ENums.WORKING_MAIN);
                    wk.getRepleLikeList(dRepleLength / 20 + 1);
                    wk.request();
                }
            }
        }

        Column
        {
            width: parent.width
            height: flickRepleLike.height

            Rectangle
            {
                width: parent.width
                height: heightCategoryArea + heightScvPadding
                color: "transparent"
            }

            Rectangle {

                width: parent.width
                height: dRepleLength == 0 ? parent.height :repleListView.height // heightRepleListItem * dRepleLength
                color: "transparent"

                ListModel
                {
                    id: commentList

                    ListElement {
                        title: "인공지능"
                        contents: "인공지능이 시나 소설을 쓰고,  영화 시나리오를 완성하며, 신문기사를 작성하고, 그림이나 작곡에 도전하는 건 SF적 상상이 아니라 일상의 일부다. 인공지능이 시인, 소설가, 화가, 작곡가의 밥그릇을 위협하고, 의사, 변호사, 대학교수, 건축가, 프로그래머의 일자리를 빼앗아갈 날도 멀지 않았다."
                        nickname: "작가미상"
                        viewCount: "12225"
                        likeCount: "555"
                    }
                    ListElement {
                        title: "배달피자"
                        contents: "누르지 않을거라고 수없이 다짐했는데..."
                        nickname: "킹콩떡볶이"
                        viewCount: "150"
                        likeCOunt: "222"
                    }
                    ListElement
                    {
                        title: "커피"
                        contents: "커피에 설탕을 넣고 크림을 넣었는데 맛이 싱겁네요. 아~! 그대 생각을 빠뜨렸군요."
                        nickname: "윤보영"
                        viewCount: "9999"
                        likeCount: "3544"
                    }
                }


                Column
                {
                    id: repleListView
                    width: parent.width
                    //                    height: heightRepleListItem * dRepleLength
                    Repeater
                    {
                        model: opt.ds ? commentList : md.likeRepleList.length
                        Rectangle
                        {

                            width: repleListView.width
                            height: R.dp(150) + repleTitleTxt.height + repleContentsTxt.height + repleCountsTxt.height
                            color: "transparent"

                            CPText
                            {
                                id: repleTitleTxt
                                width: parent.width - R.dp(100)
                                anchors
                                {
                                    top: parent.top
                                    topMargin: R.dp(50)
                                    left: parent.left
                                    leftMargin: R.dp(50)
                                }
                                text: "[" + (opt.ds ? title : md.likeRepleList[index].title) + "]"
                                font.pointSize: R.pt(45)
                            }

                            CPText
                            {
                                id: repleContentsTxt
                                width: parent.width - R.dp(250)
                                anchors
                                {
                                    top: repleTitleTxt.bottom
                                    topMargin: R.dp(20)
                                    left: repleTitleTxt.left
                                }
                                text: opt.ds ? contents : md.likeRepleList[index].contents
                                font.pointSize: R.pt(40)
                                maximumLineCount: 3
                                color: R.color_gray87
                            }

                            CPText
                            {
                                id: repleCountsTxt
                                width: parent.width - R.dp(250)
                                anchors
                                {
                                    top: repleContentsTxt.bottom
                                    topMargin: R.dp(20)
                                    left: repleContentsTxt.left
                                }
                                text: opt.ds ? ("작성자: " + nickname + " | 조회수: " + viewCount) : ("작성자: " + md.likeRepleList[index].nickname + "| 조회수: " + md.likeRepleList[index].viewCount);
                                font.pointSize: R.pt(40)
                                color: R.color_bgColor001
                            }

                            Rectangle
                            {
                                width: parent.width
                                height: parent.height
                                color: "transparent"

                                ColorAnimation on color {
                                    id: cc1
                                    running: false
                                    from: "#44000000"
                                    to: "transparent"
                                    duration: 200
                                }

                                MouseArea
                                {
                                    anchors.fill: parent
                                    onClicked:
                                    {
                                        cc1.running = true;

                                        if(opt.ds) return;

                                        goToViewer2.running = true;
                                    }
                                }

                                Timer
                                {
                                    id: goToViewer2
                                    running: false
                                    repeat: false
                                    interval: 300
                                    onTriggered:
                                    {
                                        var courseNo = md.likeRepleList[index].courseNo;
                                        var clipNo = md.likeRepleList[index].lessonSubitemNo;
                                        pushClipViewer(clipNo, courseNo, index, R.viewer_from_like_comment);
                                    }
                                }
                            }

                            Rectangle
                            {
                                width: R.dp(150)
                                height: R.dp(150)
                                color: "transparent"

                                anchors
                                {
                                    right: parent.right
                                    rightMargin : R.dp(50)
                                    verticalCenter: parent.verticalCenter
                                }

                                Item
                                {
                                    id: basePos2
                                    width: 1; height: 1;
                                    anchors
                                    {
                                        verticalCenter: parent.verticalCenter
                                        horizontalCenter: parent.horizontalCenter
                                    }
                                }

                                Rectangle
                                {
                                    id: likeIcon2
                                    width: R.dp(80)
                                    height: R.dp(80)
                                    color: "transparent"

                                    anchors
                                    {
                                        horizontalCenter: parent.horizontalCenter
                                        top: basePos2.top
                                        topMargin: R.dp(-50)
                                    }
                                    CPImage
                                    {
                                        id: likeImg2
                                        width: parent.width
                                        height: parent.height
                                        source: opt.ds ? R.image("mypage_like") : (md.likeRepleList[index].selected ? R.image("mypage_like_pink") : R.image("mypage_like"))
                                        anchors
                                        {
                                            horizontalCenter: parent.horizontalCenter
                                            verticalCenter: parent.verticalCenter
                                        }
                                    }
                                }

                                CPText
                                {
                                    width: parent.width
                                    color: "black"
                                    text: opt.ds ? "999" : md.likeRepleList[index].likeCount
                                    font.pointSize: R.pt(40)
                                    horizontalAlignment: Text.AlignHCenter
                                    anchors
                                    {
                                        top: likeIcon2.bottom
                                        //                                        topMargin: R.dp(-20)
                                    }
                                }

                                Timer
                                {
                                    running: opt.ds ? false : (wk.setClipRepleLikeResult !== ENums.WAIT)
                                    repeat: false
                                    interval: 300
                                    onTriggered:
                                    {
                                        var result = wk.volSetClipRepleLikeResult();
                                        if(result === ENums.POSITIVE)
                                        {
                                            var currentSelected = md.likeRepleList[index].selected;
                                            md.likeRepleList[index].select(!currentSelected);
                                        }
                                        else if(result === ENums.NAGATIVE) error();
                                    }
                                }

                                CPMouseArea
                                {
                                    width: parent.width
                                    height: parent.height

                                    onEvtClicked:
                                    {
                                        if(opt.ds)
                                        {
                                            likeImg2.source = R.image("mypage_like_pink");
                                            return;
                                        }

                                        var currentSelected = md.likeRepleList[index].selected;
                                        md.setCurrentClipNo(0); /* Block current clip refresh. */
                                        wk.setClipRepleLike(md.likeRepleList[index].boardArticleNo, md.likeRepleList[index].boardNo, !currentSelected);
                                        wk.request();
                                    }
                                }
                            }


                            LYMargin
                            {
                                width: parent.width; height: R.height_line_1px * 2;
                                color: R.color_gray001
                                anchors.bottom: parent.bottom
                            }
                        }
                    }
                }
            }
        }
    }


    function clearLikeClipListButton()
    {

        for(var i=0; i<md.likeClipList.length; i++)
        {
            md.likeClipList[i].click(false);
        }
    }

    function clearLikeRepleListButton()
    {

        for(var i=0; i<md.likeRepleList.length; i++)
        {
            md.likeRepleList[i].click(false);
        }
    }


    function clearCategoryButtons()
    {
        for(var i=0; i<md.catelikelist.length; i++)
        {
            md.catelikelist[i].select(false);
        }
    }

}

