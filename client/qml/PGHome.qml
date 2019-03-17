import QtQuick 2.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import "Resources.js" as R
import enums 1.0

PGProto
{
    id: mainRect
    useToMoveByPush: false
    width: opt.ds ? R.dp(1242) : appWindow.width
    height: opt.ds ? R.dp(2208) : appWindow.height

    property string selectedCategoryId: ""

    property int widthListItem : R.dp(1080)
    property int widthCategoryArea: opt.ds ? mainRect.width : R.dp(100)
    property int heightListItemImg : R.height_course_list_thumb + R.height_line_1px
    property int heightListItemLb : R.dp(180)

    property int heightViewPager : R.dp(500)
    property int heightScvPadding: R.dp(16)
    property int heightCategoryArea: R.dp(100)
    property int heightListItem : heightListItemImg + heightListItemLb

    property int countCategory : opt.ds ? 7 : md.categorylist.length
    property int countPage : opt.ds ? contactModel.count : md.bannerList.length
    property int sizeCourse : opt.ds ? 0 : md.homelist.length
    property int sizeBanner: opt.ds ? contactModel.count : md.bannerList.length
    property int sizeDisplayedItem: sizeCourse + sizeBanner

    ListModel
    {
        id: contactModel
        ListElement {
            imgPath: "../img/no_image.png"
        }
        ListElement {
            imgPath: "../img/no_image.png"
        }
        ListElement {
            imgPath: "../img/no_image.png"
        }
        ListElement {
            imgPath: "../img/no_image.png"
        }
    }

    CPNoData
    {
        id: noDataRect
        width: parent.width
        height: parent.height
        visible: opt.ds ? true : (sizeDisplayedItem === 0)
        showText: true
        message: opt.ds ? R.message_has_no_course_list : ((md.initializedSystem || wk.refreshWorkResult === ENums.FINISHED_MAIN) ? R.message_has_no_course_list : R.message_load_main_item_list)
        tMargin: R.dp(100)
    }

    property int detectCount: 0
    Timer
    {
        id: dataSupervisor
        running: true
        repeat: true
        interval: 3000
        onTriggered:
        {
            if(cmd.isOnline() === 0)
            {
                dataSupervisor.running = false;
                detectCount = 0;
                return;
            }

            if(detectCount > 5)
            {
                detectCount = 0;
                dataSupervisor.running = false;
            }
            else detectCount++;

            if(sizeBanner === 0 || sizeCourse === 0 || sizeDisplayedItem === 0)
            {
                wk.getMain(1, "");
                wk.request();

                detectCount = 0;
                dataSupervisor.running = false;
            }
        }
    }

    Flickable
    {
        id: flick
        width: parent.width
        height: parent.height
        visible: opt.ds ? false : (sizeDisplayedItem !== 0)
        contentWidth : parent.width
        contentHeight: R.dp(100) + R.height_titleBar + (opt.ds ? R.dp(30) : settings.heightStatusBar) + heightViewPager + /*heightCategoryArea*/ + heightScvPadding + (heightListItem * sizeCourse) + R.dp(32)
        maximumFlickVelocity: R.flickVelocity(mainColumn.height)

        onMovementEnded:
        {
            if(opt.ds) return;
            if(flick.atYEnd)
            {
                if(sizeCourse % 20 == 0 && sizeCourse > 0)
                {
                    showMoreIndicator(ENums.WORKING_MAIN);
                    wk.getMain(sizeCourse/20 + 1, selectedCategoryId);
                    wk.request();
                }
            }
        }

        clip: true
        boundsBehavior: Flickable.StopAtBounds

        Column
        {
            id: mainColumn
            width: parent.width
            height: flick.height

            Rectangle
            {
                id: viewPager
                width: R.width_banner_thumb
                height: R.height_banner_thumb
                color: R.color_gray001


                CPImage
                {
                    width: R.dp(300)
                    height: R.dp(300)
                    fillMode: Image.PreserveAspectFit
                    visible: opt.ds ? true : (sizeBanner === 0)
                    source: R.image("no_image")
                    anchors
                    {
                        verticalCenter: parent.verticalCenter
                        horizontalCenter: parent.horizontalCenter
                    }
                }

                PathView {
                    id: pathView
                    anchors.fill: parent
                    model: opt.ds ? contactModel : sizeBanner
                    visible: opt.ds ? true : (sizeBanner > 0)
                    delegate: Rectangle
                    {
                        width: viewPager.width
                        height: viewPager.height

                        CPImageView
                        {
                            id: bannerImage
                            width: viewPager.width
                            height: viewPager.height
                            animateCond: bannerImage.imageLoadState === Image.Ready
                            src : opt.ds ? imgPath :  /*("image://async/"+*/md.bannerList[md.bannerList[index].order-1].fileUrl//)
                        }

                        CPMouseArea
                        {
                            width: parent.width
                            height: parent.height

                            onEvtClicked:
                            {
                                var currentIndex = md.bannerList[index].order-1
                                pushNoticeDetailView(md.bannerList[currentIndex].boardNo, md.bannerList[currentIndex].boardArticleNo);
                            }
                        }
                    }

                    path: Path {
                        startX: viewPager.width * (countPage > 1 ? -0.5 : 0.5)
                        startY: viewPager.height*0.5
                        PathLine {
                            x: viewPager.width * ( countPage > 1 ? (countPage - 0.5) : 0.501)
                            y: viewPager.height*0.5;
                        }
                    }
                }

                PageIndicator
                {
                    id: pageIndicator
                    count: pathView.count
                    currentIndex: pathView.currentIndex

                    anchors
                    {
                        bottom: viewPager.bottom
                        horizontalCenter: parent.horizontalCenter
                        bottomMargin: R.dp(10)
                    }
                    delegate: Rectangle {
                        width: R.dp(25)
                        height: R.dp(25)
                        color: "transparent"

                        Rectangle
                        {
                            anchors
                            {
                                horizontalCenter: parent.horizontalCenter
                                verticalCenter: parent.verticalCenter
                            }

                            implicitWidth: R.dp(20)
                            implicitHeight: R.dp(20)
                            radius: width
                            color: index === pathView.currentIndex ? "transparent" : "white"
                            border.width: R.height_line_1px
                            border.color: "white"
                            //                            opacity: index === pathView.currentIndex ? 1.0 : pressed ? 0.7 : 0.45

                        }

                    }
                }

                Timer
                {
                    id: pagerControl
                    interval:5000
                    running: true
                    repeat: true
                    onTriggered: {
                        if(pathView.currentIndex == pathView.count-1)
                            pathView.currentIndex = 0;
                        else
                            pathView.currentIndex += 1;

                        pageIndicator.currentIndex = pathView.currentIndex;
                    }
                }
            }

            Rectangle
            {
                width: parent.width
                height: R.dp(16)
                color: "white"//R.color_gray001
            }

            ScrollView
            {
                id: scvCategory
                width: parent.width
                height: heightCategoryArea
                horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
                //                y: settings.heightStatusBar + R.height_titleBar

                Rectangle
                {
                    id: reectCategory
                    width: widthCategoryArea //* (opt.ds ? 7 : md.categorylist.length)
                    height: scvCategory.height
                    color: "white"

                    Row
                    {
                        id: rowCategory
                        width: parent.width
                        height: parent.height
                        x: R.dp(50)
                        Repeater
                        {
                            id: rp
                            model: countCategory

                            Rectangle
                            {

                                width: cpText.width; height: heightCategoryArea;
                                color:"transparent"

                                Component.onCompleted:
                                {
                                    widthCategoryArea += cpText.width;
                                }

                                Column {
                                    width: parent.width; height: parent.height;
                                    LYMargin { height: R.dp(20)}

                                    Rectangle
                                    {
                                        id: cpText
                                        width: cateTxt.width + R.dp(40)
                                        height: R.dp(70)
                                        CPText
                                        {
                                            id: cateTxt
                                            height: parent.height
                                            text: opt.ds ? "Untitled" : md.categorylist[index].name
                                            font.pointSize: R.font_size_category_button
                                            anchors.horizontalCenter: parent.horizontalCenter
                                        }
                                    }

                                    Rectangle
                                    {
                                        width: cpText.width;
                                        height: R.dp(6) //index != 0 && index != (countCategory-1) ? R.dp(6) : 0;
                                        color: opt.ds ? R.color_theme01 : (md.categorylist[index].selected ? R.color_theme01 : "#f5f6f6");
                                    }

                                }
                                MouseArea
                                {
                                    anchors.fill: parent
                                    onClicked:
                                    {
                                        R.log("[PGHome.qml] Selected Category -> name: " + md.categorylist[index].name + ", index: " + index);
                                        if(opt.ds) return;
                                        md.selectCategory(md.categorylist[index].id);
                                        selectedCategoryId = md.categorylist[index].id.toString();
                                        wk.getMain(1, selectedCategoryId);
                                        wk.request();
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Rectangle
            {
                id: scvPadding
                width: parent.width
                height: heightScvPadding
                color: "white"
            }

            Rectangle {

                id: rectList
                width: parent.width
                height: sizeCourse == 0 ? parent.height : heightListItem * sizeCourse
                y: viewPager.height
                color: "white"

                Column
                {
                    id: colRect
                    width: parent.width
                    height: heightListItem * sizeCourse
                    Repeater
                    {
                        id: rt
                        model: sizeCourse
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
                                    if(index < 2 || index%20 === 0) return true;
                                    else
                                    {
                                        /* FOR REFRESH. */
                                        if(!opt.ds && md.homelist[index].showed) {
                                            injectedOpacityValue = 1.0;
                                            return false;
                                        }
                                        if(opacityValue < 0.5 ) return (flick.contentY > R.dp(200) + heightListItem * (index-2))
                                        return false;
                                    }
                                }
                                src : opt.ds ? R.image("no_image") :  /*"image://async/"+*/md.homelist[index].courseImageUrl
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
                                        else return "[" + md.homelist[index].categoryTitle + "]  " + md.homelist[index].serviceTitle
                                    }
                                    width: parent.width - viewCountTxt.width - R.dp(60)
                                    maximumLineCount: 1
                                    font.pointSize: R.font_size_2grid_title
                                    color: "black"
                                    anchors
                                    {
                                        left: parent.left
                                        leftMargin: R.dp(20)
                                        top: parent.top
                                        topMargin: R.dp(40)
                                    }
                                }

                                CPText
                                {
                                    id: viewCountTxt
                                    text: "조회수 " + (opt.ds ? "999" : md.homelist[index].viewCount)
                                    maximumLineCount: 1
                                    font.pointSize: R.font_size_2grid_view_count
                                    color: "gray"
                                    anchors
                                    {
                                        right: parent.right
                                        rightMargin: R.dp(20)
                                        top: parent.top
                                        topMargin: R.dp(45)
                                    }
                                }
                            }

                            LYMargin
                            {
                                width: parent.width
                                height: R.height_boundary
                                color: R.color_gray001
                                visible: index !== (sizeCourse-1)
                                anchors
                                {
                                    bottom: parent.bottom
                                }
                            }

                            CPMouseArea
                            {
                                width: parent.width
                                height: parent.height

                                onEvtClicked:
                                {
                                    pushHomeStack("CourseDesk", {"courseNo": md.homelist[index].courseNo, "listIndex":index });
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    function clearListButton()
    {
        for(var i=0; i<md.homelist.length; i++)
        {
            md.homelist[i].click(false);
        }
    }

    function clearCategoryButtons()
    {
        for(var i=0; i<md.categorylist.length; i++)
        {
            md.categorylist[i].select(false);
        }
    }

}

