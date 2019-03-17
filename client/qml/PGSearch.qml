import QtQuick 2.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import "Resources.js" as R
import enums 1.0

PGProto
{
    id: mainView
    useToMoveByPush: false
    //    color: R.color_gray001

    property int heightSearchBar: R.dp(200)
    property int heightKeywordBox: R.dp(350)
    property int heightBetweenMargin: R.dp(5)
    property int heightSearchedItem: R.height_course_list_thumb + R.dp(260)

    property int heightListItemImg : R.height_course_list_thumb + R.height_line_1px
    property int heightListItemLb : R.dp(300)
    property int heightListItem : heightListItemImg + heightListItemLb

    property int lineCountKeyword : opt.ds ? Math.ceil(listModel.count / 3) : Math.ceil(md.searchLogList.length / 3)

    MouseArea
    {
        anchors.fill: parent
    }

    Component.onCompleted:
    {
        hideSearchIcon();

        if(opt.ds) return;
        cmd.readSearchLogAll();
    }

    function hideSearchIcon()
    {
        searchImg.visible = false;
        backRect.visible = true;
        showOpa.running = true;
        closeRect.visible = true;
        opaRect.enabled = true;
        showkeywordFlick.running = true;
        keywordFlick.enabled = true;
    }

    function showSearchIcon()
    {
        R.hideKeyboard();
        searchImg.visible = true;
        closeRect.visible = false;
        backRect.visible = false;
        hideOpa.running = true;
        opaRect.enabled = false;
        hidekeywordFlick.running = true;
        keywordFlick.enabled = false;
    }

    function clearSearchBarTextAndLeave()
    {
        searchTxt.text = "";
        searchTxt.leaveFocus();
    }

    Column
    {
        id: searchBox
        width: parent.width
        LYMargin
        {
            id: tmg1
            width: mainView.width
            height: heightBetweenMargin
            color: R.color_bgColor002//"white"
        }

        Rectangle
        {
            id: searchBar
            width: parent.width
            height: heightSearchBar
            color: R.color_bgColor002

            Rectangle
            {
                width: searchBar.width - R.dp(80)
                height: searchBar.height - R.dp(60)

                radius: 100
                border.width: R.dp(4)
                border.color: R.color_bgColor002
                anchors
                {
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }

                CPImage
                {
                    id: searchImg
                    width: R.dp(80)
                    height: R.dp(80)
                    source: R.image("search_coral")
                    anchors
                    {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: R.dp(60)
                    }
                }

                Rectangle
                {
                    id: backRect
                    width: R.dp(80)
                    height: R.dp(80)
                    visible: false
                    color: "transparent"

                    CPImage
                    {
                        id: backImg
                        width: parent.width //R.dp(80)
                        height: parent.height //R.dp(80)
                        source: R.image("search_back")
                    }
                    anchors
                    {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: R.dp(50)
                    }

                    Rectangle
                    {
                        width: parent.width
                        height: parent.height
                        color: "transparent"


                        ColorAnimation on color{
                            id: bcccc
                            from: "#44000000"
                            to: "transparent"
                            duration: 200
                            running: false
                        }

                        MouseArea
                        {
                            anchors.fill: parent
                            onClicked:
                            {
                                bcccc.running = true;
                                showSearchIcon();
                                clearSearchBarTextAndLeave();
                            }
                        }
                    }
                }

                Rectangle
                {
                    id: closeRect
                    width: R.dp(80)
                    height: R.dp(80)
                    visible: false
                    color: "transparent"

                    CPImage
                    {
                        id: closeImg
                        width: parent.width //R.dp(80)
                        height: parent.height //R.dp(80)
                        source: R.image("search_close")
                    }
                    anchors
                    {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: R.dp(50)
                    }

                    Rectangle
                    {
                        width: parent.width
                        height: parent.height
                        color: "transparent"


                        ColorAnimation on color{
                            id: bccccc
                            from: "#44000000"
                            to: "transparent"
                            duration: 200
                            running: false
                        }

                        MouseArea
                        {
                            anchors.fill: parent
                            onClicked:
                            {
                                searchTxt.text = "";
                            }
                        }
                    }
                }

                CPTextField
                {
                    id: searchTxt
                    width: parent.width - searchImg.width - closeRect.width - R.dp(60)  - R.dp(60) - R.dp(40) //- searchButton.width
                    height: parent.height - R.dp(20)
                    placeholderText: "검색어를 입력하세요."
                    font.pointSize: R.pt(45)
                    anchors
                    {
                        verticalCenter: parent.verticalCenter
                        left: searchImg.right
                        leftMargin: R.dp(10)
                    }

                    onEvtPressed:
                    {
                        if(searchImg.visible)
                        {
                            hideSearchIcon();

                            if(opt.ds) return;
                            cmd.readSearchLogAll();
                        }
                    }

                    onEvtSearch:
                    {
                        R.log("done!");
                    }

                    onEvtAccepted:
                    {
                        if(searchTxt.text === "")
                        {
                            alarm("검색어를 입력하세요.");
                            //                            searchTxt.allowedLeaveFocus = false;
                            return;
                        }

                        //                        searchTxt.allowedLeaveFocus = true;
                        showSearchIcon();
                        if(opt.ds) return;

                        wk.getSearchMain(1, searchTxt.text, 0);
                        wk.request();
                    }
                }

                Timer
                {
                    running: opt.ds ? false : wk.getSearchMainResult === ENums.POSITIVE
                    repeat: false
                    interval: 200
                    onTriggered:
                    {
                        wk.vGetSearchMainResult();
                        cmd.updateSearchLog(searchTxt.text);
                        if(md.searchClipList.length === 0)
                        {
                            noDataRect.visible = true;
                            flick.visible = false;
                        }
                        else
                        {
                            noDataRect.visible = false;
                            flick.visible = true;
                        }
                    }
                }
            }
        }



        LYMargin
        {
            id: tmg2
            width: parent.width
            height: heightBetweenMargin
            color: R.color_grayCF
        }
    }

    Rectangle
    {
        id: noDataRect
        width: parent.width
        height: mainView.height - searchBox.height
        color: "white"
        visible: false

        Item
        {
            id: centerPoint
            width: 1
            height: 1
            anchors
            {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }
        }

        CPImage
        {
            width: R.dp(300)
            height: R.dp(300)
            fillMode: Image.PreserveAspectFit
            source: R.image("no_page")
            anchors
            {
                bottom: centerPoint.bottom
                horizontalCenter: parent.horizontalCenter
            }
        }

        CPText
        {
            text: "검색 결과가 존재하지 않습니다."
            font.pointSize: R.pt(45)
            anchors
            {
                top: centerPoint.top
                topMargin: R.dp(50)
                horizontalCenter: parent.horizontalCenter
            }
        }
        anchors
        {
            top: searchBox.bottom
        }
    }

    Flickable
    {
        id: flick
        width: parent.width
        height: mainView.height - searchBox.height
        contentWidth : parent.width
        contentHeight: mainColumn.height
        maximumFlickVelocity: R.flickVelocity(mainColumn.height)
        clip: true

        onMovementEnded:
        {
            if(opt.ds) return;
            if(flick.atYEnd)
            {
                var length = md.searchClipList.length;
                if(length % 20 == 0 && length > 0)
                {
                    showMoreIndicator(ENums.WORKING_MAIN);
                    wk.getSearchMain(length / 20 + 1, searchTxt.text, 0);
                    wk.request();
                }
            }
        }

        Column
        {
            id: mainColumn
            width: parent.width
            Repeater
            {
                model: opt.ds ? 5 : md.searchClipList.length
                Rectangle
                {
                    id: mainItem
                    width: parent.width
                    height: thumbnail.height + textBox.height
                    color: "white"

                    CPImageView
                    {
                        id: thumbnail
                        width: parent.width
                        height: heightListItemImg
                        animateCond:
                        {
                            if(index < 2) return true;
                            else
                            {
                                /* FOR REFRESH. */
                                if(!opt.ds && md.searchClipList[index].showed) {
                                    injectedOpacityValue = 1.0;
                                    return false;
                                }
                                if(opacityValue < 0.5 ) return (flick.contentY > R.dp(200) + mainItem.height * (index-2))
                                return false;
                            }
                        }
                        enabled: false
                        src : opt.ds ? "http://kr.people.com.cn/NMediaFile/2017/0808/FOREIGN201708081338000326513010044.jpg"
                                     : md.searchClipList[index].imageUrl
                    }

                    Rectangle
                    {
                        id: textBox
                        width: parent.width
                        height: titleTxt.height + R.dp(50) + keywordTxt.height + R.dp(10) + likeItem.height + R.dp(80)
                        y: heightListItemImg
                        color: "white"

                        CPText
                        {
                            id: titleTxt
                            text: opt.ds ? "Text" : md.searchClipList[index].title
                            width: parent.width - R.dp(120)
                            font.pointSize: R.font_size_2grid_title
                            color: "black"
                            anchors
                            {
                                left: parent.left
                                leftMargin: R.dp(60)
                                top: parent.top
                                topMargin: R.dp(50)
                            }
                        }

                        CPText
                        {
                            id: keywordTxt
                            text: opt.ds ? "키워드" : md.searchClipList[index].keyword
                            width: parent.width - R.dp(120)
                            font.pointSize: R.font_size_2grid_keyword
                            color: R.color_gray87
                            anchors
                            {
                                left: titleTxt.left
                                top: titleTxt.bottom
                                topMargin: R.dp(10)
                            }
                        }

                        Item
                        {
                            id: likeItem
                            height: R.dp(60)
                            width: likeImg.width + likeCountTxt.width

                            CPImage
                            {
                                id: likeImg
                                width: parent.height
                                height: parent.height
                                source: R.image("mypage_log_like")
                            }

                            CPText
                            {
                                id: likeCountTxt
                                height: R.dp(60)
                                font.pointSize: R.pt(35)
                                text: opt.ds ? 500 : md.searchClipList[index].likeCount
                                verticalAlignment: Text.AlignVCenter
                                anchors
                                {
                                    left: likeImg.right
                                    leftMargin: R.dp(20)
                                }
                            }
                            anchors
                            {
                                left: keywordTxt.left
                                top: keywordTxt.bottom
                                topMargin: R.dp(30)
                            }
                        }

                        Item
                        {
                            id: commentItem
                            height: R.dp(60)
                            width: commentImg.width + commentCountTxt.width

                            CPImage
                            {
                                id: commentImg
                                width: parent.height
                                height: parent.height
                                source: R.image("mypage_log_pink")
                            }

                            CPText
                            {
                                id: commentCountTxt
                                height: R.dp(60)
                                font.pointSize: R.pt(35)
                                text: opt.ds ? 500 : md.searchClipList[index].repleCount
                                verticalAlignment: Text.AlignVCenter
                                anchors
                                {
                                    left: commentImg.right
                                    leftMargin: R.dp(20)
                                }
                            }
                            anchors
                            {
                                left: likeItem.right
                                leftMargin: R.dp(100)
                                top: keywordTxt.bottom
                                topMargin: R.dp(30)
                            }
                        }

                        CPText
                        {
                            id: viewLb
                            font.pointSize: R.font_size_2grid_view_count
                            height: R.dp(60)
                            color: R.color_gray87
                            text: "조회수: " +  (opt.ds ? 500 : md.searchClipList[index].viewCount)
                            verticalAlignment: Text.AlignVCenter
                            anchors
                            {
                                right: parent.right
                                rightMargin: R.dp(60)
                                bottom: commentItem.bottom
                                //                                    left: parent.left
                                //                                    leftMargin: R.dp(60)
                                //                                    top: keywordTxt.bottom
                                //                                    topMargin: R.dp(10)
                            }
                        }
                    }



                    Rectangle
                    {
                        id: aniRect2
                        anchors.fill: parent
                        color: "transparent"

                        ColorAnimation on color
                        {
                            from: "#44000000"
                            to: "transparent"
                            duration: 200
                            running: false
                            id: ccccccc
                        }
                        MouseArea
                        {
                            anchors.fill: parent
                            onClicked:
                            {
                                ccccccc.running = true;
                                if(opt.ds) return;
//                                showIndicator(true);
                                tmGoToViewer.running = true;
                            }
                        }

                        Timer
                        {
                            id: tmGoToViewer
                            running: false
                            repeat: false
                            interval: 200
                            onTriggered:
                            {
                                var courseNo = md.searchClipList[index].courseNo;
                                var clipNo = md.searchClipList[index].lessonSubitemNo;
                                pushClipViewer(clipNo, courseNo, index, R.viewer_from_search)
                            }
                        }
                    }

                    LYMargin
                    {
                        width: parent.width
                        height: R.height_boundary
                        color: R.color_gray001
                        visible: index !==  ((opt.ds ? 5 : md.searchClipList.length) - 1)
                        anchors
                        {
                            bottom: parent.bottom
                        }
                    }
                }
            }
        }
        anchors
        {
            top: searchBox.bottom
        }
    }


    Rectangle
    {
        id: opaRect
        width: parent.width
        height: parent.height
        opacity: 0
        color: "#44000000"

        y: heightBetweenMargin + heightSearchBar

        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                //                showSearchIcon();
                //                clearSearchBarTextAndLeave();
            }
        }
    }

    Flickable
    {
        id: keywordFlick
        width: parent.width
        height:
        opt.ds ? R.dp(150) * lineCountKeyword : mainView.height - searchBox.height
//                 (md.searchLogList.length > 0 ?  kRect.height : nRect.height)
        contentWidth: parent.width
        contentHeight: (opt.ds ? nRect.height : (md.searchLogList.length > 0 ? kRect.height + (lineCountKeyword > 7 ? appWindow.height*0.4 : 0) : nRect.height))
        maximumFlickVelocity: R.flickVelocity(kRect.height)
        boundsBehavior: Flickable.StopAtBounds
        clip: true
        opacity: 0

        anchors
        {
            top: searchBox.bottom
        }

        Rectangle
        {
            id: nRect
            width: parent.width
            visible: md.searchLogList.length === 0
            height: opt.ds ? mainView.height - searchBox.height : (md.searchLogList.length == 0 ? (mainView.height - searchBox.height) : 0)

            CPText
            {
                font.pointSize: R.pt(50)
                text: "검색 기록이 없습니다."
                anchors
                {
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }
            }
        }

        Rectangle
        {
            id: kRect
            //            visible: false
            width: parent.width
            height: searchedResultRect.height + columnKeyword.height
            color: "transparent"

            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    //                    showSearchIcon();
                    //                    clearSearchBarTextAndLeave();
                }
            }

            Rectangle
            {
                id: searchedResultRect
                width: parent.width
                height: searchedResultTxt.height + R.dp(60)

                CPText
                {
                    id: searchedResultTxt
                    text: "검색기록(" + (opt.ds ? listModel.count : md.searchLogList.length) + ")"
                    color: R.color_bgColor001
                    font.pointSize: R.pt(40)
                    anchors
                    {
                        left: parent.left
                        leftMargin: R.dp(30)
                        verticalCenter: parent.verticalCenter
                    }
                }

                LYMargin
                {
                    id: line
                    width: parent.width - searchedResultTxt.width - removeBtn.width - closeBtn.width - R.dp(100)// - R.dp(100)
                    height: R.height_line_1px
                    color: R.color_bgColor001
                    anchors
                    {
                        left: searchedResultTxt.right
                        leftMargin: R.dp(10)
                        verticalCenter: parent.verticalCenter
                    }
                }

                Rectangle
                {
                    id: removeBtn
                    height: parent.height - R.dp(20)
                    width: txtRemove.width + R.dp(40)
                    color: R.color_bgColor002
                    anchors
                    {
                        right: closeBtn.left
                        rightMargin: R.dp(20)
                        verticalCenter: parent.verticalCenter
                    }

                    CPText
                    {
                        id: txtRemove
                        text:"기록 삭제"
                        color:"white"
                        font.pointSize: R.pt(40)
                        anchors
                        {
                            verticalCenter: parent.verticalCenter
                            horizontalCenter: parent.horizontalCenter
                        }
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: cmd.removeSearchLogAll()
                    }
                }

                Rectangle
                {
                    id: closeBtn
                    height: parent.height - R.dp(20)
                    width: removeBtn.width
                    color: R.color_bgColor002
                    anchors
                    {
                        right: parent.right
                        rightMargin: R.dp(20)
                        verticalCenter: parent.verticalCenter
                    }

                    CPText
                    {
                        id: txtClose
                        text:"닫기"
                        color:"white"
                        font.pointSize: R.pt(40)
                        anchors
                        {
                            verticalCenter: parent.verticalCenter
                            horizontalCenter: parent.horizontalCenter
                        }
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked:
                        {
//                            hidekeywordFlick.running = true;
                            showSearchIcon();
                        }
                    }
                }
            }

            Column
            {
                id: columnKeyword
                anchors
                {
                    top: searchedResultRect.bottom
                    topMargin: R.dp(5)
                }

                Repeater
                {
                    model: lineCountKeyword

                    Rectangle
                    {
                        width: keywordFlick.width
                        height: R.dp(150)
                        color: "transparent"

                        CPKeywordButton
                        {
                            id: leftItemKeyword
                            width: (parent.width - R.dp(10)) / 3
                            height: parent.height - R.dp(5)
                            dIndex: (3 * index)
                            dCount: opt.ds ? listModel.count : md.searchLogList.length
                            keyword: opt.ds ?
                                         listModel.get(dIndex).tag :
                                         (dIndex < md.searchLogList.length ? md.searchLogList[dIndex].keyword : "")
                            onEvtShowSearcIcon:
                            {
                                searchTxt.text = leftItemKeyword.keyword;
                                showSearchIcon();
                            }
                            anchors.left: parent.left
                        }

                        CPKeywordButton
                        {
                            id: middelItemKeyword
                            width: (parent.width - R.dp(10)) / 3
                            height: parent.height - R.dp(5)
                            dIndex: (3 * index + 1)
                            dCount: opt.ds ? listModel.count : md.searchLogList.length
                            keyword: opt.ds ?
                                         listModel.get(dIndex).tag :
                                         (dIndex < md.searchLogList.length ? md.searchLogList[dIndex].keyword : "")
                            onEvtShowSearcIcon:
                            {
                                searchTxt.text = middelItemKeyword.keyword;
                                showSearchIcon();
                            }
                            anchors
                            {
                                left: leftItemKeyword.right
                                leftMargin: R.dp(5)
                            }
                        }

                        CPKeywordButton
                        {
                            id: rightItemKeyword
                            width: (parent.width - R.dp(10)) / 3
                            height: parent.height - R.dp(5)
                            dIndex: (3 * index + 2)
                            dCount: opt.ds ? listModel.count : md.searchLogList.length
                            keyword: opt.ds ?
                                         listModel.get(dIndex).tag :
                                         (dIndex < md.searchLogList.length ? md.searchLogList[dIndex].keyword : "")
                            onEvtShowSearcIcon:
                            {
                                searchTxt.text = rightItemKeyword.keyword;
                                showSearchIcon();
                            }
                            anchors
                            {
                                left: middelItemKeyword.right
                                leftMargin: R.dp(5)
                            }
                        }
                    }
                }
            }
        }
    }

    OpacityAnimator
    {
        id: hidekeywordFlick
        target: keywordFlick;
        from: 1;
        to: 0;
        duration: 300
        running: false
    }

    OpacityAnimator
    {
        id: showkeywordFlick
        target: keywordFlick;
        from: 0;
        to: 1;
        duration: 500
        running: false
    }


    OpacityAnimator
    {
        id: hideOpa
        target: opaRect;
        from: 1;
        to: 0;
        duration: 300
        running: false
    }

    OpacityAnimator
    {
        id: showOpa
        target: opaRect;
        from: 0;
        to: 1;
        duration: 300
        running: false
    }

    ListModel
    {
        id: listModel
        ListElement
        {
            tag: "도레미파솔라시도"
            //colorName: getColorRandomly()
            rowNumber: 0
        }

        ListElement
        {
            tag: "도레미파솔라시도"
            //colorName: getColorRandomly()
            rowNumber: 0
        }

        ListElement
        {
            tag: "도레미파솔라시도"
            //colorName: getColorRandomly()
            rowNumber: 1
        }

        ListElement
        {
            tag: "기계"
            //colorName: getColorRandomly()
            rowNumber: 1
        }

        ListElement
        {
            tag: "납땜하는 방법"
            //colorName: getColorRandomly()
            rowNumber: 1
        }

        ListElement
        {
            tag: "CSS & HTML"
            //colorName: getColorRandomly()
            rowNumber: 2
        }

        ListElement
        {
            tag: "CSS & HTML"
            //colorName: getColorRandomly()
            rowNumber: 2
        }

        ListElement
        {
            tag: "아두이노"
            //colorName: getColorRandomly()
            rowNumber: 2
        }

        ListElement
        {
            tag: "일러스트레이터"
            //colorName: getColorRandomly()
            rowNumber: 2
        }

        ListElement
        {
            tag: "autodesk 3dmas"
            //colorName: getColorRandomly()
            rowNumber: 3
        }

        ListElement
        {
            tag: "인디자인"
            //colorName: getColorRandomly()
            rowNumber: 4
        }

        ListElement
        {
            tag: "인디자인"
            //colorName: getColorRandomly()
            rowNumber: 4
        }

        ListElement
        {
            tag: "인디자인"
            //colorName: getColorRandomly()
            rowNumber: 4
        }

        ListElement
        {
            tag: "인디자인"
            //colorName: getColorRandomly()
            rowNumber: 4
        }
        ListElement
        {
            tag: "인디자인"
            //colorName: getColorRandomly()
            rowNumber: 4
        }
        ListElement
        {
            tag: "222인디자인"
            //colorName: getColorRandomly()
            rowNumber: 4
        }
    }



    function charByteSize(ch) {
        if (ch === null || ch.length === 0) {
            return 0;
        }

        var charCode = ch.charCodeAt(0);

        if (charCode <= 0x00007F) {
            return 1;
        } else return 2;
        //      if (charCode <= 0x00007F) {
        //        return 1;
        //      } else if (charCode <= 0x0007FF) {
        //        return 2;
        //      } else if (charCode <= 0x00FFFF) {
        //        return 3;
        //      } else {
        //        return 4;
        //      }
    }



    // 문자열을 UTF-8로 변환했을 경우 차지하게 되는 byte 수를 리턴한다.
    function stringByteSize(str) {
        //        return str.replace(/[\0-\x7f]|([0-\u07ff]|(.))/g,"$&$1$2").length;

        if (str === null || str.length === 0) {
            return 0;
        }
        var size = 0;

        for (var i = 0; i < str.length; i++) {
            size += charByteSize(str.charAt(i));
        }
        return size;
    }

    Keys.onBackPressed:
    {
        if (Qt.inputMethod.visible)
        {
            Qt.inputMethod.hide();
            return;
        }
        else if(ap.visible)
        {
            ap.setVisible(false);
            ap.invokeNMethod();
            return;
        }
        else if(!searchImg.visible)
        {
            hideSearchIcon();
        }

    }
}
