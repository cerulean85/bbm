import QtQuick 2.9
import QtQuick.Controls 2.2
import "Resources.js" as R
import enums 1.0

PGPage {

    id: mainView
    name: "joinClause"
    visibleSearchBtn: false
    titleText: "회원가입"
    titleTextColor: "black"
    titleLineColor: "black"
    visibleBackBtn: true
    pageName: "JoinClause"

    useDefaultEvtBack: false
    onEvtBack:
    {
        settings.clearUser();
        popUserStack();
    }

    Component.onCompleted:
    {
        if(opt.ds) return;
        md.setShowIndicator(false);
    }

    onEvtBehaviorAndroidBackButton:
    {
        if(viewCluase.y === 0) viewCluase.hide();
        else evtBack();
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
            evtBehaviorAndroidBackButton();
        }
    }

    property int chkBoxLeftMargin: R.dp(55)
    property int chkBoxTxtIntervalMargin: R.dp(20)

    PropertyAnimation
    {
        id: viewCluaseAnimator;
        target: viewCluase;
        running: false
        property: "y";
        to: 0;
        duration: 200
    }
    PGJoinViewClause
    {
        id: viewCluase
        y: parent.height
        z: 7777
    }

    Rectangle
    {
        width: parent.width
        height: parent.height - mainView.heightStatusBar - mainView.heightBottomArea - R.height_titleBar
        color: "white"
        y: mainView.heightStatusBar + R.height_titleBar

        Column
        {
            width: parent.width
            height: parent.height

            Rectangle
            {
                width: parent.width
                height: R.dp(377)

                CPJoinMarker
                {
                    id: joinMaker
                    currentStage: 1
                    anchors { verticalCenter: parent.verticalCenter }
                }
            }
            LYMargin { width: parent.width; height: R.dp(19); color: R.color_gray001 }
            LYMargin { width: parent.width; height: R.dp(170); }
            LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_bgColor001 }
            Rectangle
            {
                width: parent.width
                height: R.dp(173)

                Row
                {
                    width: parent.width
                    height: R.dp(100)
                    anchors.verticalCenter: parent.verticalCenter

                    LYMargin { width: chkBoxLeftMargin }
                    CPCheckBox
                    {
                        id: clause1
                        width: R.dp(100)
                        height: R.dp(100)
                        checked: opt.ds ? false : md.checkedClause1
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    LYMargin { width: chkBoxTxtIntervalMargin }

                    CPText
                    {
                        text: "이버봄 서비스 " + R.txt_title_clause1 + " 동의"
                        font.pointSize: R.pt(40)
                        anchors.verticalCenter: parent.verticalCenter
                        color: R.color_gray87
                    }
                    LYMargin { width: R.dp(10) }
                    CPText
                    {
                        font.pointSize: R.pt(40)
                        anchors.verticalCenter: parent.verticalCenter
                        color: R.color_bgColor001
                        text: "(필수)"
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        if(opt.ds) {
                            clause1.checked = !clause1.checked;
                            return
                        }
                        md.setCheckedClause1(!md.checkedClause1);
                    }
                }

                CPTextButtonTrans
                {
                    id: viewAll1
                    width: R.dp(300)
                    height: parent.height
                    btnName: "전문보기 >"
                    fontColor: R.color_gray87
                    subColor: R.color_gray001
                    pointSize: R.pt(35)
                    anchors
                    {
                        right: parent.right
                        rightMargin: R.dp(10)
                        verticalCenter: parent.verticalCenter
                    }
                    onClick:
                    {
                        if(opt.ds) return;
                        viewCluaseAnimator.running = true;
                    }
                }
            }


            LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_bgColor001 }

            Rectangle
            {
                width: parent.width
                height: R.dp(173)

                Rectangle
                {
                    width: parent.width
                    height: R.dp(173)

                    Row
                    {
                        width: parent.width
                        height: R.dp(100)
                        anchors.verticalCenter: parent.verticalCenter

                        LYMargin { width: chkBoxLeftMargin }
                        CPCheckBox
                        {
                            id: clause2
                            width: R.dp(100)
                            height: R.dp(100)
                            checked: opt.ds ? false : md.checkedClause2
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        LYMargin { width: chkBoxTxtIntervalMargin }

                        CPText
                        {
                            text: R.txt_title_clause2 + " 동의"
                            font.pointSize: R.pt(40)
                            anchors.verticalCenter: parent.verticalCenter
                            color: R.color_gray87
                        }

                        LYMargin { width: R.dp(10) }
                        CPText
                        {
                            font.pointSize: R.pt(40)
                            anchors.verticalCenter: parent.verticalCenter
                            color: R.color_bgColor001
                            text: "(필수)"
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked:
                        {
                            if(opt.ds) {
                                clause2.checked = !clause2.checked;
                                return
                            }
                            md.setCheckedClause2(!md.checkedClause2);
                        }
                    }

                    CPTextButtonTrans
                    {
                        id: viewAll2
                        width: R.dp(300)
                        height: parent.height
                        btnName: "전문보기 >"
                        fontColor: R.color_gray87
                        subColor: R.color_gray001
                        pointSize: R.pt(35)
                        anchors
                        {
                            right: parent.right
                            rightMargin: R.dp(10)
                            verticalCenter: parent.verticalCenter
                        }
                        onClick:
                        {
                            if(opt.ds) return;
                            viewCluaseAnimator.running = true;
                        }
                    }
                }
            }
            LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_bgColor001 }

            Rectangle
            {
                width: parent.width
                height: R.dp(173)

                Rectangle
                {
                    width: parent.width
                    height: R.dp(173)

                    Row
                    {
                        width: parent.width
                        height: R.dp(100)
                        anchors.verticalCenter: parent.verticalCenter

                        LYMargin { width: chkBoxLeftMargin }
                        CPCheckBox
                        {
                            id: clause3
                            width: R.dp(100)
                            height: R.dp(100)
                            checked: opt.ds ? false : md.checkedClause3
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        LYMargin { width: chkBoxTxtIntervalMargin }

                        CPText
                        {
                            text: R.txt_title_clause3 + " 동의"
                            font.pointSize: R.pt(40)
                            anchors.verticalCenter: parent.verticalCenter
                            color: R.color_gray87
                        }

                        LYMargin { width: R.dp(10) }
                        CPText
                        {
                            font.pointSize: R.pt(40)
                            anchors.verticalCenter: parent.verticalCenter
                            text: "(선택)"
                            verticalAlignment: Text.AlignVCenter
                            color: R.color_gray87
                        }
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked:
                        {
                            if(opt.ds) {
                                clause3.checked = !clause3.checked;
                                return
                            }
                            md.setCheckedClause3(!md.checkedClause3);
                        }
                    }

                    CPTextButtonTrans
                    {
                        id: viewAll3
                        width: R.dp(300)
                        height: parent.height
                        btnName: "전문보기 >"
                        fontColor: R.color_gray87
                        subColor: R.color_gray001
                        pointSize: R.pt(35)
                        anchors
                        {
                            right: parent.right
                            rightMargin: R.dp(10)
                            verticalCenter: parent.verticalCenter
                        }
                        onClick:
                        {
                            if(opt.ds) return;
                            viewCluaseAnimator.running = true;
                        }
                    }
                }
            }
            LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_bgColor001 }

//            Rectangle
//            {
//                width: parent.width
//                height: R.dp(173)

//                Rectangle
//                {
//                    width: parent.width
//                    height: R.dp(173)

//                    Row
//                    {
//                        width: parent.width
//                        height: R.dp(100)
//                        anchors.verticalCenter: parent.verticalCenter

//                        LYMargin { width: chkBoxLeftMargin }
//                        CPCheckBox
//                        {
//                            id: clause4
//                            width: R.dp(100)
//                            height: R.dp(100)
//                            checked: opt.ds ? false : md.checkedClause4
//                            anchors.verticalCenter: parent.verticalCenter
//                        }
//                        LYMargin { width: chkBoxTxtIntervalMargin }

//                        CPText
//                        {
//                            text: "이벤트 프로모션 알림 수신"
//                            font.pointSize: R.pt(40)
//                            anchors.verticalCenter: parent.verticalCenter
//                            color: R.color_gray87
//                        }

//                        LYMargin { width: R.dp(10) }
//                        CPText
//                        {
//                            font.pointSize: R.pt(40)
//                            anchors.verticalCenter: parent.verticalCenter
//                            text: "(선택)"
//                            verticalAlignment: Text.AlignVCenter
//                            color: R.color_gray87
//                        }
//                    }

//                    MouseArea
//                    {
//                        anchors.fill: parent
//                        onClicked:
//                        {
//                            if(opt.ds) {
//                                clause4.checked = !clause4.checked;
//                                return
//                            }
//                            md.setCheckedClause4(!md.checkedClause4);
//                        }
//                    }

//                    CPTextButtonTrans
//                    {
//                        id: viewAll4
//                        width: R.dp(300)
//                        height: parent.height
//                        btnName: "전문보기 >"
//                        fontColor: R.color_gray87
//                        subColor: R.color_gray001
//                        pointSize: R.pt(35)
//                        anchors
//                        {
//                            right: parent.right
//                            rightMargin: R.dp(10)
//                            verticalCenter: parent.verticalCenter
//                        }
//                        onClick:
//                        {
//                            if(opt.ds) return;
//                            viewCluaseAnimator.running = true;
//                        }
//                    }
//                }
//            }
//            LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_bgColor001 }
            LYMargin { width: parent.width; height: R.dp(52) }
            CPTextButton
            {
                name: "다음"
                pointSize: R.pt(45)
                enabled: opt.ds ? false : (md.checkedClause1 && md.checkedClause2)
                onClick: pushUserStack("JoinIdentity");

                color: opt.ds ? R.color_grayE1 : ( (md.checkedClause1 && md.checkedClause2) ?  R.color_bgColor001 : R.color_grayE1 )
                subColor: opt.ds ? R.color_bgColor003 : ( (md.checkedClause1 && md.checkedClause2) ?  R.color_bgColor002 : R.color_bgColor003 )
            }
        }
    }
}
