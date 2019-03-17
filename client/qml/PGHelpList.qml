import QtQuick 2.9
import QtQuick.Controls 2.2
import "Resources.js" as R
import enums 1.0

PGPage {
    id: mainView
    visibleSearchBtn: false
    titleText: "도움말"
    titleTextColor: "black"
    titleLineColor: "black"
    visibleBackBtn: true
    pageName: "HelpList"

    property int itemHeight: R.dp(180)
    property int dLength : opt.ds ? 40 : md.helpList.length
    property int selectedIndex: 0

    onEvtInitData: md.clearHelpList();

    Component.onCompleted:
    {
        if(opt.ds) return;
        dataGetter.running = true
    }

    Timer
    {
        running: opt.ds ? false : (md.requestNativeBackBehavior === ENums.REQUESTED_BEHAVIOR && compareCurrentPage(pageName))
        repeat: false
        interval: 100
        onTriggered:
        {
            md.setRequestNativeBackBehavior(ENums.WAIT_BEHAVIOR);
            if(closeWindowInMain()) return;
            evtBack();
        }
    }

    Timer
    {
        id: dataGetter
        running: false
        repeat: false
        interval: 300
        onTriggered:
        {
            md.clearHelpList();

            wk.getSystemFAQList();
            wk.request();
        }
    }

    Rectangle
    {
        id: noDataRect
        width: parent.width
        height: parent.height - mainView.heightStatusBar - mainView.heightBottomArea - R.height_titleBar
        color: R.color_gray001
        visible: dLength == 0
        y: mainView.heightStatusBar + R.height_titleBar

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
            text: R.message_load_data
            font.pointSize: R.pt(45)
            anchors
            {
                top: centerPoint.top
                topMargin: R.dp(50)
                horizontalCenter: parent.horizontalCenter
            }
        }
    }

    Column
    {
        width: parent.width
        height: parent.height
        y: mainView.heightStatusBar + R.height_titleBar

        Flickable
        {
            id: flick
            width: parent.width
            height: parent.height - mainView.heightStatusBar - R.height_titleBar - mainView.heightBottomArea
            contentWidth : parent.width
            contentHeight: mainColumn.height
            maximumFlickVelocity: R.flickVelocity(mainColumn.height)
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            Column
            {
                id: mainColumn
                width: parent.width

                ListModel
                {
                    id: listModel
                    ListElement
                    {
                        title: "제목"
                        imageUrl: "http://kr.people.com.cn/NMediaFile/2017/0808/FOREIGN201708081338000326513010044.jpg"
                        selected: false
                    }
                    ListElement
                    {
                        title: "제목"
                        imageUrl: "http://kr.people.com.cn/NMediaFile/2017/0808/FOREIGN201708081338000326513010044.jpg"
                        selected: false
                    }
                    ListElement
                    {
                        title: "제목"
                        imageUrl: "http://kr.people.com.cn/NMediaFile/2017/0808/FOREIGN201708081338000326513010044.jpg"
                        selected: false
                    }
                    ListElement
                    {
                        title: "제목"
                        imageUrl: "http://kr.people.com.cn/NMediaFile/2017/0808/FOREIGN201708081338000326513010044.jpg"
                        selected: false
                    }
                    ListElement
                    {
                        title: "제목"
                        imageUrl: "http://kr.people.com.cn/NMediaFile/2017/0808/FOREIGN201708081338000326513010044.jpg"
                        selected: false
                    }
                    ListElement
                    {
                        title: "제목"
                        imageUrl: "http://kr.people.com.cn/NMediaFile/2017/0808/FOREIGN201708081338000326513010044.jpg"
                        selected: false
                    }
                }

                Repeater
                {
                    model: opt.ds ? listModel : dLength
                    Rectangle
                    {
                        id: helpItem
                        width: parent.width
                        height: headerRect.height + contentsRect.height + (!(opt.ds ? selected : md.helpList[index].selected) ? 0 : R.dp(50))
                            color: R.color_gray001
                        Rectangle
                        {
                            id: headerRect
                            width: parent.width
                            height: R.dp(180)
                            color: !(opt.ds ? selected : md.helpList[index].selected) ? "white" : R.color_bgColor002

                            CPText
                            {
                                id: txtContents
                                width: headerRect.width - R.margin_common * 3
                                text: (opt.ds ? title + index : md.helpList[index].title)
                                font.pointSize: R.font_size_list_title
                                anchors
                                {
                                    left: parent.left
                                    leftMargin: R.margin_common
                                    verticalCenter: parent.verticalCenter
                                }
                            }

                            CPImage
                            {
                                id: arrowImg
                                source: R.image("button_go")
                                rotation: !(opt.ds ? selected : md.helpList[index].selected) ? 0 : 180
                                width: R.dp(50)
                                height: R.dp(50)
                                anchors
                                {
                                    right: parent.right
                                    rightMargin: R.margin_common
                                    verticalCenter: parent.verticalCenter
                                }
                            }
                        }

                        Rectangle
                        {
                            id: contentsRect
                            width: helpItem.width
                            height: !(opt.ds ? selected : md.helpList[index].selected) ? 0 : contentsLine.height + contentsTxt.height + contentsImg.height + R.dp(70)
                            color: R.color_gray001
                            anchors
                            {
                                top: headerRect.bottom
                            }

                            LYMargin
                            {
                                id: contentsLine
                                color: R.color_gray87
                                width: helpItem.width
                                height: !(opt.ds ? selected : md.helpList[index].selected) ? 0 : R.height_line_1px
                                anchors
                                {
                                    horizontalCenter: parent.horizontalCenter
                                }
                            }

                            CPText
                            {
                                id: contentsTxt
                                text: opt.ds ? "ASFLKJALDKFJLSKDJFLKSDJLKSDFKJSDFLKSLDKF" : md.helpList[index].contents
                                width: !(opt.ds ? selected : md.helpList[index].selected) ? 0 : (helpItem.width - R.margin_common*2)
                                font.pointSize: R.pt(45)
                                anchors
                                {
                                    top: contentsLine.top
                                    topMargin: !(opt.ds ? selected : md.helpList[index].selected) ? 0 : R.dp(40)
                                    left: parent.left
                                    leftMargin: R.margin_common
                                }
                            }

                            CPImage
                            {
                                id: contentsImg
                                width: !(opt.ds ? selected : md.helpList[index].selected) ? 0 : (helpItem.width - R.margin_common*2)
                                source: opt.ds ? imageUrl : md.helpList[index].imageUrl
                                anchors
                                {
                                    top: contentsTxt.bottom
                                    topMargin: !(opt.ds ? selected : md.helpList[index].selected) ? 0 : R.dp(30)
                                    horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }

                        LYMargin
                        {
                            color: R.color_gray87
                            width: parent.width; height: R.height_line_1px
                            anchors
                            {
                                bottom: parent.bottom
                            }
                        }

                        MouseArea
                        {
                            anchors.fill: parent
                            onClicked:
                            {
                                if(opt.ds)
                                {
                                    for(var i=0; i<listModel.count; i++)
                                    {
                                        if(index === i) continue;
                                        listModel.get(i).selected = false;
                                    }

                                    var selected = listModel.get(index).selected;
                                    listModel.get(index).selected = !selected;
                                }
                                else
                                {
                                    md.clearNoticeDetail();
                                    for(var i=0; i<md.helpList.length; i++)
                                    {
                                        if(index === i) continue;
                                        md.helpList[i].select(false);
                                    }

                                    var selected = md.helpList[index].selected;
                                    md.helpList[index].select(!selected);

                                    wk.getSystemFAQDetail(md.helpList[index].boardNo, index);
                                    wk.request();

//                                    tmGetDetail.running = true;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
//    Timer
//    {
//        id: tmGetDetail
//        running: false
//        repeat: false
//        interval: 5000
//        onTriggered:
//        {
//            wk.clearDelayedHosts();
//            wk.request();
//        }
//    }
}
