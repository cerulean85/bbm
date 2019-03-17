import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import "Resources.js" as R

PGPage {
    id: mainView
    visibleSearchBtn: false
    titleText: "이용약관"
    titleTextColor: "black"
    titleLineColor: "black"
    visibleBackBtn: false

    useDefaultEvtBack: false
    onEvtBack:
    {
        //        userStackView.pop();
        mainView.y = mainView.height;
    }

    property int subTitleFontSize: R.pt(40)
    property int contentFontSize: R.pt(35)
    property int heightClauseBox : R.dp(950)

    Component.onCompleted:
    {
        if(opt.ds) return;
        md.setShowIndicator(false);
    }

    PropertyAnimation
    {
        id: animator;
        target: mainView;
        running: false
        property: "y";
        to: parent.height;
        duration: 200
    }

    CPTextButtonTrans
    {
        color: "white"
        width: R.height_titleBar + R.dp(50)
        height: R.height_titleBar - R.height_line_1px
        anchors
        {
            top: parent.top
            topMargin: settings.heightStatusBar
            right: parent.right
        }
        btnName: "확인"
        pointSize: R.pt(50)
        onClick:
        {
            if(opt.ds) return
            //            userStackView.pop();
            animator.running = true;
        }
    }

    function hide()
    {
        animator.running = true;
    }

    Column
    {
        width: parent.width
        height: parent.height - mainView.heightStatusBar - mainView.heightBottomArea - R.height_titleBar
        y: mainView.heightStatusBar + R.height_titleBar

        LYMargin { height: R.dp(66); width: parent.width; color: R.color_gray001; }
        LYMargin { height: R.height_line_1px; width: parent.width; color: "black" }



        ScrollView
        {
            width: parent.width
            height: parent.height - R.dp(66) - R.height_line_1px

            Rectangle
            {
                width: mainView.width
                height: R.dp(4200)

                Column
                {
                    width: parent.width
                    height: parent.height

                    CPClauseView
                    {
                        width: mainView.width
                        height: R.dp(950)

                        clauseOrder: 1
                        necessary: true

                        title: R.txt_title_clause1
                        contents: R.txt_clause1


                        applymsg: "서비스 이용약관에 동의합니다."
                        onEvtClicked:
                        {
                            md.setCheckedClause1(!md.checkedClause1);
                        }
                    }

                    CPClauseView
                    {
                        width: mainView.width
                        height: R.dp(950)

                        clauseOrder: 2
                        necessary: true

                        title: R.txt_title_clause2
                        contents: R.txt_clause2

                        applymsg: "개인정보 수집 및 이용에 동의합니다."
                        onEvtClicked:
                        {
                            md.setCheckedClause2(!md.checkedClause2);
                        }
                    }

                    CPClauseView
                    {
                        width: mainView.width
                        height: R.dp(950)

                        clauseOrder: 3
                        necessary: false

                        title: R.txt_title_clause3
                        contents: R.txt_clause3

                        applymsg: "개인정보의 제3자 제공에 동의합니다."
                        onEvtClicked:
                        {
                            md.setCheckedClause3(!md.checkedClause3);
                        }
                    }

//                    CPClauseView
//                    {
//                        width: mainView.width
//                        height: R.dp(950)

//                        clauseOrder: 4
//                        necessary: false

//                        title: "이벤트 프로모션 알림 수신"
//                        contents: R.txt_clause4

//                        applymsg: "이벤트 프로모션 알림 수신에 동의합니다."
//                        onEvtClicked:
//                        {
//                            md.setCheckedClause4(!md.checkedClause4);
//                        }
//                    }

                }
            }
        }
    }

    CPTextButton
    {
        name: "전체 동의"
        pointSize: R.pt(45)
        onClick:
        {
            if(opt.ds) return;

            md.setCheckedClause1(true);
            md.setCheckedClause2(true);
            md.setCheckedClause3(true);
            md.setCheckedClause4(true);
        }

        anchors
        {
            bottom: parent.bottom
        }
    }
}
