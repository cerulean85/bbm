import QtQuick 2.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import "Resources.js" as R
Rectangle {

    id: mainRect
    property bool animateCond : false
    property string src : opt.ds ? "http://kr.people.com.cn/NMediaFile/2017/0808/FOREIGN201708081338000326513010044.jpg" : src
    property int injectedOpacityValue: 0.0
    property alias opacityValue : imgRect.opacity
    property alias imageLoadState: img.status
    property int fillMode: Image.PreserveAspectFit

    Rectangle
    {
        width: mainRect.width
        height: mainRect.height
        color: R.color_gray001

        CPImage
        {
            id: bgImage
            width: R.dp(300)
            height: R.dp(300)
            fillMode: mainRect.fillMode
            source: R.image("no_image")
            anchors
            {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
        }
    }


    Rectangle
    {
        id: imgRect
        width: mainRect.width
        height: mainRect.height
        opacity: injectedOpacityValue //0.0
        color: "transparent"

        CPImage
        {
            id: img
            width: mainRect.width
            height: mainRect.height
//            sourceSize.width: img.width// * 0.5
//            sourceSize.height: img.height// * 0.5
            fillMode: Image.PreserveAspectCrop
            source : R.toHttp(src)//opt.ds ? "http://kr.people.com.cn/NMediaFile/2017/0808/FOREIGN201708081338000326513010044.jpg" : src
            anchors
            {
                horizontalCenter: parent.horizontalCenter
                //                                verticalCenter: parent.verticalCenter
            }
        }

        OpacityAnimator
        {
            target: imgRect;
            from: 0;
            to: 1;
            duration: 500
            running: animateCond
        }
    }

}
