import QtQuick 2.9
import "Resources.js" as R
Rectangle {
    id: pareintView
    width: R.design_size_width
    height: R.dp(144)

    color: "orange"

    signal evtSearch();
    signal evtInvoke();

    Rectangle
    {
        id: titleBar
        height: R.height_titleBar
        width: parent.width
        color: R.color_appTitlebar

        CPButton
        {
            id: btnSearch
            anchors
            {
                right: parent.right
            }

            visible: true
            width: parent.height
            height: parent.height
            sourceWidth: R.dp(100)
            sourceHeight: R.dp(100)
            imageSource: R.image("search_white")
            type: "image"
            onClicked:
            {
                evtSearch()
            }
        }

        Rectangle
        {
            width: parent.width - btnSearch.width - R.dp(8) * 4
            height: parent.height - R.dp(8) * 4
            anchors
            {
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: R.dp(8)
            }

            color: "white"
            border.width: 1
            radius: 5

            CPTextField
            {
                id: editWords
                width: parent.width - R.dp(8) * 2
                height: parent.height - R.dp(8) * 2
                anchors
                {
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }

                onFocusChanged:
                {
                    if(!editWords.focus)
                        pareintView.forceActiveFocus();
                }
            }
        }
    }



}
