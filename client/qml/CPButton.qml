import QtQuick 2.0
import "Resources.js" as R

Rectangle {
    id:btn
    width:  sourceWidth
    height:  sourceHeight;
    color: {
        if(!active) return inactiveColor
        return ma.pressed ? pressedColor : rectColor
    }

    opacity: {
        if( !active ) return 0.3
        if( rectColor==pressedColor && imageSource==pressedImageSource) return ma.pressed ? 0.6 : 1
        else return 1
    }

    signal clicked()

    property string imageSource: "../img/back_white.png"  //아이콘
    property string pressedImageSource : imageSource
    property string hoverImageSource : imageSource

    property int    imageRotation : 0

    property real   sourceSize : R.pt(25)  //아이콘사이즈
    property real   sourceWidth : sourceSize
    property real   sourceHeight : sourceSize

    property color inactiveColor : "gray"
    property color rectColor : "transparent"
    property color pressedColor : R.color_buttonPressed//rectColor
    property color hoverdColor : rectColor

    property bool  active : true ;

    property bool  hoverEnabled: false
    property int     mouseAreaMargin : -R.MARGIN_XS
    property string type : "text"
    property int   fontSize: 10
    property string textColor: "black"
    property bool  fontBold: false
    property string btnName: "Button"

    property int leftMarginValue: 0
    property int rightMarginValue: 0

    Row
    {
        width: parent.width
        height: parent.height

        LYMargin { width: leftMarginValue; height: parent.height }

        Item
        {
            width: parent.width
            height: parent.height
            Image {
                id:img
                visible: type=="image"
                source: {
                    if( ma.containsMouse ) ma.pressed&&pressedImageSource!="" ?pressedImageSource : hoverImageSource
                    else imageSource
                }
                width:  btn.sourceWidth
                height:  btn.sourceHeight
                fillMode:  Image.PreserveAspectFit
                rotation: imageRotation
                anchors.centerIn: parent
            }
        }

        Item
        {
            width: parent.width
            height: parent.height
            CPText {
                id:txt
                visible: type=="text"
                text: btnName
                anchors
                {
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }
                width: sourceWidth
                height: sourceHeight
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                //      anchors{verticalCenter:parent.verticalCenter;
                //          horizontalCenter: if(align==1) parent.horizontalCenter
                //          left: if(align==0) parent.left
                //          margins: btn.margins
                //      }
                font.pointSize: fontSize
                color: textColor
                //      color: ma.pressed? pressedTextColor :textColor
                //      style :Text.Outline;
                //      styleColor: textStrokeColor
                font.bold: fontBold

                //      lineHeight: btn.lineHeight
                //        fontType: btn.fontType
            }
        }

        LYMargin { width: leftMarginValue; height: parent.height }
    }

    MouseArea {
        id:ma
        visible: active
        anchors.fill: parent
        anchors.margins: mouseAreaMargin

        hoverEnabled: btn.hoverEnabled
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            btn.clicked()
        }
    }
}


