import QtQuick 2.9
import QtQuick.Controls 2.2
import "Resources.js" as R
import enums 1.0

PGProto
{
    id: mainView
    color: "transparent"

    width: opt.ds ? R.dp(1242) : appWindow.width
    height: opt.ds ? R.dp(2208) : appWindow.height

    SwipeView
    {
        id: guideView
        anchors.fill: parent

        Rectangle
        {
            width: mainView.width
            height: mainView.height

            CPImage
            {
                width: mainView.width
                height: mainView.height
                fillMode: Image.Stretch
                source: R.imageJPG("guide1" + (Qt.platform.os===R.os_name_android ? "_and" : "_ios"));
            }
        }

        Rectangle
        {
            width: mainView.width
            height: mainView.height
            color: "transparent"

            CPImage
            {
                width: mainView.width
                height: mainView.height
                fillMode: Image.Stretch
                source: R.imageJPG("guide2" + (Qt.platform.os===R.os_name_android ? "_and" : "_ios"));
            }
        }

        Rectangle
        {
            width: mainView.width
            height: mainView.height
            color: "transparent"

            CPImage
            {
                width: mainView.width
                height: mainView.height
                fillMode: Image.Stretch
                source: R.imageJPG("guide3" + (Qt.platform.os===R.os_name_android ? "_and" : "_ios"));
            }

        }

        Rectangle
        {
            width: mainView.width
            height: mainView.height
            color: "transparent"

            CPImage
            {
                width: mainView.width
                height: mainView.height
                fillMode: Image.Stretch
                source: R.imageJPG("guide4" + (Qt.platform.os===R.os_name_android ? "_and" : "_ios"));
            }

            CPTextButton
            {
                name: "시작하기"
                width: parent.width
                pointSize: R.pt(45)
                onClick:
                {
                    if(opt.ds) return;
                    settings.setHideGuide(true);
                }
                anchors
                {
                    bottom: parent.bottom
                }
            }
        }
    }


//    PageIndicator
//    {
//        id: indicator

//        count: guideView.count
//        currentIndex: guideView.currentIndex

//        anchors.bottom: guideView.bottom
//        anchors.horizontalCenter: parent.horizontalCenter

//        delegate: Rectangle {
//            width: R.dp(50)
//            height: R.dp(50)
//            color: "transparent"

//            Rectangle
//            {
//                anchors
//                {
//                    horizontalCenter: parent.horizontalCenter
//                    bottom: parent.bottom
//                    bottomMargin: R.dp(100)
//                }

//                implicitWidth: R.dp(25)
//                implicitHeight: R.dp(25)
//                radius: width
//                color: index === guideView.currentIndex ? "white" : "transparent"
//                border.width: R.height_line_1px
//                border.color: "white"

//            }

//        }
//    }

}

