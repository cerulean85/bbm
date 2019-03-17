import QtQuick 2.11
import QtMultimedia 5.8
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "Resources.js" as R

Rectangle {

    id: mainView
    property string url: "http://www.html5videoplayer.net/videos/toystory.mp4"
    property int fullHeight: (appWindow.height)
    property int screenWidth: opt.ds ? R.dp(1242) : appWindow.width * (md.fullScreen ? 1 : 0.3)
    property int screenHeight: opt.ds ? R.dp(2208) : fullHeight * (md.fullScreen ? 1 : 0.3)

    width: opt.ds ? R.dp(1242) : appWindow.width
    height: opt.ds ? R.dp(2208) : screenHeight
    color: "black"//"#84c9c1"

    MouseArea {
        anchors.fill: parent
        onClicked:
        {
            if(bgCtrl.visible) hideCtrlArea();
            else showCtrlArea();
        }
    }

    Timer
    {
        id: timer
        running: false; repeat: false;
        interval: 5000
        onTriggered:
        {
            hideCtrlArea();
            timer.running = false;
        }
    }

    Timer
    {
        running: opt.ds ? false : md.videoStatus === 0
        repeat: false
        interval: 200
        onTriggered:
        {
            if(md.clipDetail.isVerticalVideo)
            {
                md.setVideoStatus(-1);
                pause();
            }
        }
    }

    Timer
    {
        id: seekMoveTimer
        running: false; repeat: true;
        interval: 1000
        onTriggered:
        {
            if(!md.fullScreen)
            {
                seekSmallMode.x = (seekBarSmallMode.width - seekSmallMode.width) * (video.position / video.duration);
                bgSeekBarSmallMode.width = seekSmallMode.x + R.dp(15);
                currentTime.text = R.toTime(video.position);
            }
            else
            {
                seekFullMode.x = (seekBarFullMode.width - seekFullMode.width) * (video.position / video.duration);
                bgSeekBarFullMode.width = seekFullMode.x + R.dp(15);
                currentTimeFullMode.text = R.toTime(video.position);
            }
        }
    }

    Timer
    {
        id: bufferCheck
        running: true; repeat: true;
        interval: 1000
        onTriggered:
        {
            if(video.playbackState === MediaPlayer.PlayingState)
            {
                if(video.bufferProgress < 1.0) indiCtrl.visible = true;
                else indiCtrl.visible = false;
            }
        }
    }

    Rectangle
    {
        id: videoRect
        width : screenWidth
        height : screenHeight
        color : "transparent"

        anchors
        {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }

       Video {
            id: video
            audioRole: MediaPlayer.VideoRole
            width : screenWidth
            height : screenHeight
            source: url
            focus: true
            anchors
            {
                top: parent.top
//                topMargin: - (screenHeight - video.height) * 0.5
                horizontalCenter: parent.horizontalCenter
            }
        }
    }

    Rectangle
    {
        id: bgCtrl
        width: videoRect.width//parent.width
        height : videoRect.height//md.fullScreen ? (parent.height) : (parent.width * 0.5625)
        color: "black"
        opacity: 0.3
        visible: false
    }

    Rectangle
    {
        id: ctrlSmallArea
        width: parent.width
        height :  parent.height//parent.width * 0.5625 - R.dp(5)
        color : "transparent"
        opacity: 1

        MouseArea {
            anchors.fill: parent
            onClicked: hideCtrlArea();
        }

        Column
        {
            id: columnSmallArea
            width: parent.width
            height: parent.height

            Rectangle
            {
                width: parent.width
                height: R.dp(120)
                color : "transparent"
                CPButton
                {
                    id: cmdVolume
                    anchors
                    {
                        right: parent.right
                        rightMargin: R.dp(20)
                        top: parent.top
                        topMargin: R.dp(20)
                    }

                    width: R.dp(100)
                    height: R.dp(100)
                    sourceWidth: R.dp(100)
                    sourceHeight: R.dp(100)
                    imageSource: !video.muted ? R.image("volume_on_48dp") : R.image("volume_off_48dp")
                    type: "image"
                    onClicked:
                    {
                        video.muted = !video.muted;
                    }
                }
            }

            Rectangle
            {
                width: parent.width
                height: parent.height - R.dp(170)
                color: "transparent"
                CPButton
                {
                    id: cmdPrevSmallMode
                    anchors
                    {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                    }
                    visible: false
                    width: R.dp(200)
                    height: R.dp(200)
                    sourceWidth: R.dp(100)
                    sourceHeight: R.dp(100)
                    imageSource: R.image("prev_48dp")
                    type: "image"
                    onClicked:
                    {

                    }
                }
                CPButton
                {
                    id: cmdPlaySmallMode
                    anchors
                    {
                        verticalCenter: parent.verticalCenter
                        horizontalCenter: parent.horizontalCenter
                    }
                    width: R.dp(300)
                    height: R.dp(300)
                    sourceWidth: R.dp(150)
                    sourceHeight: R.dp(150)
                    imageSource: video.playbackState === MediaPlayer.PlayingState ? R.image("pause_48dp") : R.image("play_48dp");
                    type: "image"
                    onClicked: play();
                }

                CPButton
                {
                    id: cmdNextSmallMode
                    anchors
                    {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                    }
                    visible: false
                    width: R.dp(200)
                    height: R.dp(200)
                    sourceWidth: R.dp(100)
                    sourceHeight: R.dp(100)
                    imageSource: R.image("next_48dp")
                    type: "image"
                    onClicked:
                    {

                    }
                }
            }

            Row
            {
                id: row3
                width: parent.width
                height: R.dp(50)

                Column
                {
                    width: parent.width
                    height: parent.height
                    Rectangle
                    {
                        height: R.dp(20)
                        width: parent.width
                        color: "transparent"

                        CPText
                        {
                            id: currentTime
                            text: R.toTime(video.position)
                            color: "white"
                            font.pointSize: R.pt(30)
                            anchors
                            {
                                left: parent.left
                                leftMargin: R.dp(20)
                                bottom: parent.bottom
                            }
                        }

                        CPButton
                        {
                            id:cmdToFullMode
                            anchors
                            {
                                right: parent.right
                                rightMargin: R.dp(20)
                                bottom: parent.bottom
                                bottomMargin: R.dp(-20)
                            }

                            width: R.dp(100)
                            height: R.dp(100)
                            sourceWidth: R.dp(100)
                            sourceHeight: R.dp(100)
                            imageSource: R.image("full_48dp")
                            type: "image"
                            onClicked:expend();
                        }

                        CPText
                        {
                            text: R.toTime(video.duration)//"총 재생시간"
                            color: "white"
                            font.pointSize: R.pt(30)
                            anchors
                            {
                                right: cmdToFullMode.left
                                rightMargin: R.dp(5)
                                bottom: parent.bottom
                            }
                        }
                    }
                }
            }
        }
    }

    Rectangle
    {
        id: ctrlSeekSmallMode
        width: parent.width
        height: seekSmallMode.height
        color : "transparent"
        anchors
        {
            top: ctrlSmallArea.bottom
        }

        Rectangle
        {
            id: seekBarSmallMode
            width: parent.width
            height: R.dp(10)
            color: R.color_gray88
        }

        Rectangle
        {
            id: bufferedSmallMode
            width: parent.width * video.bufferProgress
            height: R.dp(10)
            color: R.color_grayCF
        }

        Rectangle
        {
            id: bgSeekBarSmallMode
            width: 0
            height: seekBarSmallMode.height
            color: "red"
        }

        Rectangle
        {
            id: seekSmallMode
            anchors
            {
                top: parent.top
                topMargin: -R.dp(14)
            }
            radius: width * 0.5
            width: R.dp(40)
            height: R.dp(40)
            color: "red"
        }
    }

    Rectangle
    {
        id: dragSeekSmallMode
        width: parent.width
        height: ctrlSeekSmallMode.height * 1.5
        color : "transparent"
        anchors
        {
            top: ctrlSmallArea.bottom
        }

        MouseArea
        {
            anchors.fill: parent
            drag.target: seekSmallMode
            drag.axis: Drag.XAxis
            drag.minimumX: 0
            drag.maximumX: parent.width - R.dp(60)
            onPositionChanged: move(mouseX)
            onPressed: move(mouseX)
        }
    }

    //When is FULL MODE,
    Rectangle
    {
        id: ctrlFullArea
        width: mainView.width //parent.width
        height : mainView.height //parent.height
        color : "transparent"
        opacity: 0.0

        MouseArea {
            anchors.fill: parent
            onClicked: hideCtrlArea();
        }

        Column
        {
            width: parent.width
            height: parent.height

            Rectangle
            {
                width: parent.width
                height: parent.height  - R.dp(320)
                color: "transparent"

                CPButton
                {
                    id: cmdPrevFullMode
                    rotation: 0
                    anchors
                    {
                        verticalCenter: parent.verticalCenter
                        right: cmdPlayFullMode.left
                        rightMargin: R.dp(150)
                    }
                    visible: false
                    width: R.dp(300)
                    height: R.dp(300)
                    sourceWidth: R.dp(150)
                    sourceHeight: R.dp(150)
                    imageSource: R.image("prev_48dp")
                    type: "image"
                    onClicked:
                    {

                    }
                }

                CPButton
                {
                    id: cmdPlayFullMode
                    rotation: 0
                    anchors
                    {
                        verticalCenter: parent.verticalCenter
                        horizontalCenter: parent.horizontalCenter
                    }
                    width: R.dp(400)
                    height: R.dp(400)
                    sourceWidth: R.dp(200)
                    sourceHeight: R.dp(200)
                    imageSource: video.playbackState === MediaPlayer.PlayingState ? R.image("pause_48dp") : R.image("play_48dp");
                    type: "image"
                    onClicked: play();
                }

                CPButton
                {
                    id: cmdNextFullMode
                    rotation: 0
                    anchors
                    {
                        verticalCenter: parent.verticalCenter
                        left: cmdPlayFullMode.right
                        leftMargin: R.dp(150)
                    }
                    visible: false
                    width: R.dp(300)
                    height: R.dp(300)
                    sourceWidth: R.dp(150)
                    sourceHeight: R.dp(150)
                    imageSource: R.image("next_48dp")
                    type: "image"
                    onClicked:
                    {

                    }
                }
            }
        }

        Rectangle
        {
            color: "black"
            width: parent.width - R.dp(100)
            height: R.dp(340)
            opacity: 0.5
            radius: 10
            anchors
            {
                bottom: parent.bottom
                bottomMargin: R.dp(80)
                horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle
        {
            color: "transparent"
            width: parent.width - R.dp(100)
            height: R.dp(320)
            anchors
            {
                bottom: parent.bottom
                bottomMargin: R.dp(100)
                horizontalCenter: parent.horizontalCenter
            }

            CPText
            {
                id: currentTimeFullMode
                rotation: 0
                text: R.toTime(video.position)
                height: R.dp(90)
                verticalAlignment: Text.AlignVCenter
                color: "white"
                font.pointSize: R.pt(30)
                anchors
                {
                    left: parent.left
                    leftMargin: R.dp(30)
                    top: parent.top
                    topMargin: R.dp(30)
                }
            }

            CPText
            {
                id: totalPlayTimeFullMode
                rotation: 0
                text: R.toTime(video.duration)//"총 재생시간"
                color: "white"
                font.pointSize: R.pt(30)
                height: R.dp(90)
                verticalAlignment: Text.AlignVCenter
                anchors
                {
                    right: parent.right
                    rightMargin: R.dp(30)
                    top: parent.top
                    topMargin: R.dp(30)
                }
            }

            Rectangle
            {
                id: ctrlSeekFullMode
                width: parent.width - R.dp(60)
                height: R.dp(60)
                color : "transparent"

                anchors
                {
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }

                Rectangle
                {
                    id: seekBarFullMode
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    height: R.dp(10)
                    color: R.color_gray88
                }

                Rectangle
                {
                    id: bufferedFullMode
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width * video.bufferProgress
                    height: R.dp(10)
                    color: R.color_grayCF
                }

                Rectangle
                {
                    id: bgSeekBarFullMode
                    anchors.verticalCenter: parent.verticalCenter
                    width: 0
                    height: R.dp(10)
                    color: "red"
                }

                Rectangle
                {
                    id: seekFullMode
                    anchors.verticalCenter: parent.verticalCenter
                    y: R.dp(-15)
                    radius: width*0.5
                    width: R.dp(40)
                    height: R.dp(40)
                    color: "red"
                }

                Rectangle
                {
                    id: dragSeekFullMode
                    width: parent.width
                    height: R.dp(90)
                    color : "transparent"
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea
                    {
                        anchors.fill: parent
                        drag.target: seekFullMode
                        drag.axis: Drag.YAxis
                        drag.minimumX: 0
                        drag.maximumX: parent.width
                        onPositionChanged: move(mouseX)
                        onPressed: move(mouseX)
                    }
                }
            }

            CPButton
            {
                id: cmdVolumeFullMode
                rotation: 0
                anchors
                {
                    left: parent.left
                    leftMargin: R.dp(40)
                    bottom: parent.bottom
                    bottomMargin: R.dp(10)
                }

                width: R.dp(100)
                height: R.dp(100)
                sourceWidth: R.dp(100)
                sourceHeight: R.dp(100)
                imageSource: !video.muted ? R.image("volume_on_48dp") : R.image("volume_off_48dp")
                type: "image"
                onClicked:
                {
                    video.muted = !video.muted;
                }
            }

            CPButton
            {
                id:cmdToSmallMode
                width: R.dp(120)
                height: R.dp(120)
                sourceWidth: R.dp(120)
                sourceHeight: R.dp(120)
                imageSource: R.image("full_exit_48dp")
                type: "image"
                onClicked:shrink();
                anchors
                {
                    right: parent.right
                    rightMargin: R.dp(20)
                    bottom: parent.bottom
                    bottomMargin: R.dp(10)
                }
            }
        }
    }

    Rectangle
    {
        id: indiCtrl
        width: parent.width
        height : md.fullScreen ? (parent.height) : (parent.width * 0.5625)
        color: "black"
        opacity: 0.3
        visible: false;

        CPBusyIndicator
        {
            width: R.dp(200)
            height: R.dp(200)
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

        }
    }

    function prev()
    {
        R.log("PREV");
    }

    function next()
    {
        R.log("next");
    }

    function pause()
    {
        video.pause();
        seekMoveTimer.stop();

        cmdPlaySmallMode.imageSource = video.playbackState === MediaPlayer.PlayingState ? R.image("pause_48dp") : R.image("play_48dp");
        cmdPlayFullMode.imageSource = video.playbackState === MediaPlayer.PlayingState ? R.image("pause_48dp") : R.image("play_48dp");

        if(video.playbackState === MediaPlayer.PlayingState)
            timer.start();
    }

    function play()
    {
        R.log(video.duration);
        timer.stop();

        if(video.playbackState === MediaPlayer.PlayingState)
        {
            video.pause();
            seekMoveTimer.stop();
        }
        else if(video.playbackState === MediaPlayer.PausedState || video.playbackState === MediaPlayer.StoppedState)
        {
            video.play();
            seekMoveTimer.start();
        }

        cmdPlaySmallMode.imageSource = video.playbackState === MediaPlayer.PlayingState ? R.image("pause_48dp") : R.image("play_48dp");
        cmdPlayFullMode.imageSource = video.playbackState === MediaPlayer.PlayingState ? R.image("pause_48dp") : R.image("play_48dp");

        if(video.playbackState === MediaPlayer.PlayingState)
            timer.start();
    }

    function stop()
    {
        if(video.playbackState === MediaPlayer.PlayingState || video.playbackState === MediaPlayer.PausedState)
        {
            video.pause();
            /* seekSmallMode position */
            showCtrlArea();

            cmdPlaySmallMode.imageSource = R.image("play_48dp");
            cmdPlayFullMode.imageSource = R.image("play_48dp");
        }
    }

    function expend()
    {
        md.setFullScreen(true);
        showCtrl(true);
        np.showStatusBar(false);
        //            np.setOrientation(1);
        np.checkStatusBar(true);
    }

    function shrink()
    {
        md.setFullScreen(false);
        showCtrl(true);
        np.showStatusBar(true);
        np.setOrientation(0);
        np.checkStatusBar(false);
    }

    function showCtrlArea()
    {
        timer.stop();

        showCtrl(true);
        bgCtrl.visible = true;

        if(video.playbackState === MediaPlayer.PlayingState)
            timer.start();
    }

    function hideCtrlArea()
    {
        showCtrl(false);
        bgCtrl.visible = false;
    }

    function move(mouse)
    {
        var position = 0;
        if(!md.fullScreen)
        {
            if(mouse > seekBarSmallMode.width) return;
            else if(mouse > seekBarSmallMode.width - seekSmallMode.width) seekSmallMode.x = seekBarSmallMode.width - seekSmallMode.width;
            else seekSmallMode.x = parseInt(mouse);

            bgSeekBarSmallMode.width = seekSmallMode.x + R.dp(5);

            position = parseInt(video.duration * (seekSmallMode.x / seekBarSmallMode.width));
            video.seek(position);
            currentTime.text = R.toTime(position);
        }
        else
        {
            if(mouse > seekBarFullMode.width) return;
            else if(mouse > seekBarFullMode.width - seekFullMode.width) seekFullMode.x = seekBarFullMode.width - seekFullMode.width;
            else seekFullMode.x = parseInt(mouse);

            bgSeekBarFullMode.width = seekFullMode.x + R.dp(5);

            position = parseInt(video.duration * (seekFullMode.x / seekBarFullMode.width));
            video.seek(position);
            currentTimeFullMode = R.toTime(position);
        }

        if(video.playbackState === MediaPlayer.PausedState || video.playbackState === MediaPlayer.StoppedState)
            tmPlay.running = true;
    }

    function showCtrl(show)
    {
        if(!md.fullScreen)
        {
            ctrlFullArea.opacity = 0;
            ctrlFullArea.enabled = false;
            ctrlSmallArea.enabled = show;
            ctrlSeekSmallMode.visible = true;
            //            seekSmallMode.visible = show;
            if(show) {
                seekSmallMode.visible = true;
                onCtrlSmallArea.running = true;
            }
            else {
                seekSmallMode.visible = false;
                offCtrlSmallArea.running = true;
            }
        }
        else
        {
            ctrlSmallArea.opacity = 0;
            ctrlSmallArea.enabled = false;
            ctrlSeekSmallMode.visible = false;
            seekSmallMode.visible = false;
            ctrlFullArea.enabled = show;
            if(show) onCtrlFullArea.running = true;
            else offCtrlFullArea.running = true;
        }
    }

    OpacityAnimator
    {
        id: onCtrlSmallArea
        target: ctrlSmallArea;
        running: false
        duration: 300
        to: 1
    }

    OpacityAnimator
    {
        id: offCtrlSmallArea
        target: ctrlSmallArea;
        running: false
        duration: 500
        to: 0
    }

    OpacityAnimator
    {
        id: onCtrlFullArea
        target: ctrlFullArea;
        running: false
        duration: 300
        to: 1
    }

    OpacityAnimator
    {
        id: offCtrlFullArea
        target: ctrlFullArea;
        running: false
        duration: 500
        to: 0
    }

    Timer
    {
        id: tmPlay
        running: false
        repeat: false
        interval: 3000
        onTriggered: play();
    }

    Timer
    {
        running: Qt.platform.os === R.os_name_ios ? true : false
        repeat: true
        interval: 1000
        onTriggered:
        {
            var deviceName = settings.deviceName;
            if(deviceName === R.device_ios_6 || deviceName === R.device_ios_7 || deviceName === R.device_ios_8)
            {
                if(md.requestedShrinkVideo === true) shrink();
            }
            md.requestShrinkVideo(false);
        }
    }

    Component.onCompleted:
    {
        showCtrl(true);
    }
}