import QtQuick 2.11
import "Resources.js" as R

Rectangle
{
    id: item
    radius: 10
    color: getColorRandomly(dIndex)

    property int dIndex: 0
    property int dCount: 0
    property string keyword: ""

    signal evtShowSearcIcon();


    visible: dIndex <= (dCount - 1)

    Rectangle
    {
        width: parent.width
        height: parent.height
        color: "transparent"

        ColorAnimation on color {
            id: animation
            from: R.color_gray87
            to: "transparent"
            running: false
            duration: 200
        }
        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                animation.running = true;
                keyword = opt.ds ? "" : md.searchLogList[dIndex].keyword;
                evtShowSearcIcon();

                if(opt.ds) return;
                cmd.updateSearchLogDate(md.searchLogList[dIndex].no);
                wk.getSearchMain(1, keyword, 0);
                wk.request();
            }
        }
    }

    CPText
    {
        width: parent.width - R.dp(110)
        height: parent.height
        font.pointSize: R.pt(45)
        maximumLineCount: 1
        text: keyword
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors
        {
            left: parent.left
            leftMargin: R.dp(30)
            verticalCenter: parent.verticalCenter
        }
    }

    Rectangle
    {
        width: R.dp(100)
        height: R.dp(100)
        color: "transparent"

        CPText
        {
            width: R.dp(100)
            height: R.dp(100)
            font.pointSize: R.pt(50)
            color: "black"//R.color_grayCF
            text: R.btn_name_close
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors
            {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle
        {
            width: parent.width
            height: item.height
            radius: 10
            color: "transparent"

            ColorAnimation on color {
                id: xButtonAnimation
                from: R.color_gray87
                to: "transparent"
                running: false
                duration: 100
            }
            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
//                                            xButtonAnimation.running = true;
                    if(opt.ds) return;
                    cmd.removeSearchLog(md.searchLogList[dIndex].boardNo);
                }
            }
        }

        anchors
        {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: R.dp(00)
        }
    }

    function makeRandom(min, max){
        var RandVal = Math.random() * (max- min) + min;
        return Math.floor(RandVal);
    }
    function getColorRandomly(num)
    {
        //        var num = Math.floor(Math.random()*10);
        //        bgArray.splice(num, 1);
        switch(makeRandom(0, num+5)%10)
        {
        case 0: return "#afffba";
        case 1: return "#ffe4af";
        case 2: return "#dfd4e4";
        case 3: return "#f2cfa5";
        case 4: return "#fcffb0";
        case 5: return "#aee4ff";
        case 6: return "#b5c7ed";
        case 7: return "#c4f4fe";
        case 8: return "#bee9b4";
        case 9: return "#fbfa87";
        }
    }
}
