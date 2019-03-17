import QtQuick 2.11
import QtQuick.Controls 2.2
import "Resources.js" as R

Rectangle
{
    id: mainView
    width: R.dp(1242)
    height: R.dp(2208)
    color: "#aa000000"

    property int fontSize: R.pt(70)
    opacity: opt.ds ? 1 : 0
    enabled: opt.ds ? true : false

    MouseArea
    {
        anchors.fill: parent
        onClicked:
        {
            hide();
        }
    }

    Rectangle
    {
        width: parent.width - R.dp(150)
        height: R.dp(850)
        color: "transparent"
        anchors
        {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }

        Rectangle
        {
            id: selectionRect
            width: parent.width
            height: parent.height
            MouseArea
            {
                anchors.fill: parent

            }
            Row
            {
                id: row
                width: parent.width
                height: parent.height

                Tumbler
                {
                    id: amPmPicker
                    model:["AM", "PM"]
                    width: row.width * 0.25 //R.dp(300)
                    height: selectionRect.height
                    currentIndex: opt.ds ? 0 : settings.pushTimeAMPM
                    delegate:
                    CPText
                    {
                        width: amPmPicker.width
                        height: R.dp(180)
                        text: modelData
                        opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: fontSize //fontMetrics.font.pointSize * 1.25

                    }
                }

                Tumbler
                {
                    id: hourPicker
                    model: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
                    width: row.width * 0.28 //R.dp(300)
                    height: selectionRect.height
                    currentIndex: opt.ds ? 0 : settings.pushTimeHour
                    delegate:
                        CPText
                    {
                        width: hourPicker.width - R.dp(80)
                        height: R.dp(200)
                        text: formatText(Tumbler.tumbler.count, modelData)
                        opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: fontSize //fontMetrics.font.pointSize * 1.25
                    }


                }
                LYMargin { width: R.dp(30) }
                CPText
                {
                    text: "시"
                    width: R.dp(50)
                    height: parent.height
                    font.pointSize: R.pt(40)
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Tumbler
                {
                    id: minutesPicker
                    model: [0, 30]
                    width: row.width * 0.25//R.dp(250)
                    height: selectionRect.height
                    currentIndex: opt.ds ? 0 : settings.pushTimeMinutes
                    delegate:

                    CPText
                    {
                        width: minutesPicker.width
                        height: R.dp(100)
                        text: formatText(Tumbler.tumbler.count, modelData)
                        opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: fontSize //fontMetrics.font.pointSize * 1.25
                    }
                }
                LYMargin { width: R.dp(30) }
                CPText
                {
                    text: "분"
                    width: R.dp(50)
                    height: parent.height
                    font.pointSize: R.pt(40)
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

            }

            Rectangle
            {
                width: parent.width
                height: R.dp(150)
                color: "transparent"
                border.width: R.height_line_1px * 2
                border.color: R.color_bgColor002
                anchors
                {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }
            }
        }



        FontMetrics {
            id: fontMetrics
            font.pointSize: R.pt(40)
        }


        Rectangle
        {
            id: titleRect
            width: parent.width
            height: R.dp(150)
            color: R.color_bgColor001

            CPText
            {
                width: parent.width
                height: parent.height
                font.pointSize: R.pt(50)
                text: "푸시 시간 설정"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: "white"
            }

            Rectangle
            {
                height: parent.height
                width: parent.height
                color: "transparent"
                CPImage
                {
                    width: R.dp(110)
                    height: R.dp(110)
                    source: R.image(R.btn_close_gray_image)
                    anchors
                    {
                        verticalCenter: parent.verticalCenter
                        horizontalCenter: parent.horizontalCenter
                    }
                }
                anchors
                {
                    right: parent.right
                }

                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        colorAnimator11.running = true;
                        hide();
                    }
                }

                ColorAnimation on color {
                    id: colorAnimator11
                    from: R.color_bgColor001
                    to: "transparent"
                    running: false
                    duration: 100
                }
            }
        }

        Rectangle
        {
            id: confirmRect
            width: parent.width
            height: R.dp(150)
            color: R.color_bgColor001
            anchors
            {
                bottom: parent.bottom
            }

            CPText
            {
                width: parent.width
                height: parent.height
                font.pointSize: R.pt(50)
                text: "확인"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: "white"
            }

            Rectangle
            {
                height: parent.height
                width: parent.width
                color: "transparent"

                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        colorAnimator22.running = true;
                        hide();

                        if(opt.ds) return
                        settings.setPushTimeAMPM(amPmPicker.currentIndex);
                        settings.setPushTimeHour(hourPicker.currentIndex);
                        settings.setPushTimeMinutes(minutesPicker.currentIndex);

                        R.log("[CPTimerSelector] Hour: " + (hourPicker.currentIndex+1) + ", AMPM: " + amPmPicker.currentIndex + ", Minutes: " + minutesPicker.currentIndex);
                        var fullTime = strHour(settings.pushTimeHour + (settings.pushTimeAMPM == 0 ? 0 : 12)) + ":" + strMinutes(settings.pushTimeMinutes*30) + ":00";
                        R.log("The time was set " + fullTime);
                        wk.setPushDatetime(fullTime);
                        wk.request();
                    }
                }

                ColorAnimation on color {
                    id: colorAnimator22
                    from: R.color_bgColor001
                    to: "transparent"
                    running: false
                    duration: 100
                }
            }
        }

    }

    //    Rectangle
    //    {
    //        id: frame
    //        anchors.centerIn: parent

    //        Row
    //        {
    //            id: row
    //            Tumbler
    //            {
    //                id: amPmPicker
    //                model: ["AM", "PM"]
    //                delegate: CPText
    //                {
    //                    text: formatText(Tumbler.tumbler.cout, modelData)
    //                    opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
    //                    horizontalAlignment: Text.AlignHCenter
    //                    verticalAlignment: Text.AlignVCenter
    //                    font.pointSize: fontMetrics.font.pointSize * 1.25

    //                }

    //            }
    //            Tumbler
    //            {
    //                id: hourPicker
    //                model: 12
    //                delegate: delegateComponent
    //            }
    //            Tumbler
    //            {
    //                id: minutesPicker
    //                model: ["0", "30"]
    //                delegate: delegateComponent

    //            }

    //        }
    //    }

    PropertyAnimation
    {
        id: rectUp;
        target: mainView
        property: "opacity";
        to: 1
        duration: 300
    }

    PropertyAnimation
    {
        id: rectDown
        target: mainView
        property: "opacity"
        to: 0
        duration: 300
    }

    function show()
    {
        mainView.enabled = true;
        rectUp.running = true;
    }

    function hide()
    {
        mainView.enabled = false;
        rectDown.running = true;
    }

    function formatText(count, modelData)
    {
        var data = count === 12 ? modelData + 1 : modelData;
        return data.toString().length < 2 ? "0" + data : data;
    }
}

