import QtQuick 2.9
import QtQuick.Controls 2.2
import "Resources.js" as R
import enums 1.0

PGPage {
    id: mainView
    name: "joinSetInfo"
    pageName: "JoinSetInfo"

    visibleSearchBtn: false
    titleText: "회원가입"
    titleTextColor: "black"
    titleLineColor: "black"
    visibleBackBtn: true

    property bool checkedIDFromClient: false
    property bool checkedNicknameFromClient: false
    property int  checkedIDResultFromServer : ENums.WAIT
    property bool checkedNicknameResultFromServer : ENums.WAIT

    property string dummyID : ""//R.dummyID
    property string dummyPass : ""//R.dummyPass
    property string dummyRePass : ""//"@Qw12345678"
    property string dummyName : ""//"JHKim"
    property string dummyNickname : ""//"멋쨍이JHEAAzz"
    property string dummyEmail : ""//"zinx2@koreatech.ac.kr"
    property string dummyBirth : ""//"19890805"

    useDefaultEvtBack: false
    onEvtBack: popUserStack();

    Timer
    {
        running: opt.ds ? false : (md.requestNativeBackBehavior === ENums.REQUESTED_BEHAVIOR && compareCurrentPage(pageName))
        repeat: false
        interval: 100
        onTriggered:
        {
            md.setRequestNativeBackBehavior(ENums.WAIT_BEHAVIOR);
            if(!hideAlarm()) evtBack();
        }
    }

    Component.onCompleted:
    {
        if(opt.ds) return;
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
                    currentStage: 3
                    anchors { verticalCenter: parent.verticalCenter }
                }
            }
            LYMargin { width: parent.width; height: R.dp(19); color: R.color_gray001 }

            Row
            {
                width: parent.width
                height: R.dp(182)

                LYMargin { width: R.dp(50) }

                CPText
                {
                    text: "아이디"
                    color: R.color_bgColor001
                    font.pointSize: R.font_size_common_style_login
                    width: R.dp(300)
                    height: R.dp(182)
                    verticalAlignment: Text.AlignVCenter
                }

                LYMargin { width: R.dp(10) }
                CPTextField
                {
                    id: idTxt
                    width: parent.width - R.dp(50) - R.dp(300) - R.dp(10) - R.dp(228) - R.dp(80)//R.dp(500)
                    height: R.dp(182)
                    placeholderText: "이메일을 입력하세요."
                    text: dummyID
                    font.pointSize: R.font_size_common_style_login
                    maximumLength: 50
                    onTextChanged:
                    {
                        checkedIDFromClient = false;
                        checkedIDResultFromServer = ENums.WAIT;
                    }
                }

                LYMargin { width: R.dp(30) }
                CPTextButton
                {
                    name: "중복확인"
                    pointSize: R.pt(36)
                    width: R.dp(228)
                    height: R.dp(100)
                    anchors.verticalCenter: parent.verticalCenter
                    onClick:
                    {
                        switch(cmd.checkEmail(idTxt.text.trim()))
                        {
                        case ENums.WRONG_FORM:

                            alarm("아이디는 이메일 형식이어야 합니다.");
                            checkedIDFromClient = false;
                            checkedIDResultFromServer = ENums.WAIT;
                            break;

                        case ENums.WRONG_LENGTH:

                            alarm("아이디는 10~50자까지 사용가능합니다.");
                            checkedIDFromClient = false;
                            checkedIDResultFromServer = ENums.WAIT;
                            break;


                        case ENums.ALL_RIGHT:

                            md.setShowIndicator(true);
                            checkedIDFromClient = true;
                            wk.duplicateID(idTxt.text.trim());
                            wk.request();
                            break;

                        }
                    }
                }

                Timer
                {
                    running: opt.ds ? false : (wk.duplicatedIDResult !== ENums.WAIT && checkedIDFromClient)
                    repeat: false
                    interval: 200
                    onTriggered:
                    {
                        md.setShowIndicator(false);
                        var type = wk.volDuplicatedIDResult();
                        switch(type)
                        {
                        case ENums.POSITIVE:
                            alarm("사용할 수 있는 아이디입니다.");
                            checkedIDResultFromServer = ENums.POSITIVE;
                            break;
                        case ENums.NAGATIVE:
                            error();
                            checkedIDFromClient = false;
                            checkedIDResultFromServer = ENums.NAGATIVE;
                            break;
                        case ENums.NOT_OPENED:
                            error();
                            checkedIDFromClient = false;
                            checkedIDResultFromServer = ENums.NOT_OPENED;
                            break;
                        }

                    }
                }
            }
            LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_bgColor001 }
            Row
            {
                width: parent.width
                height: R.dp(182)

                LYMargin { width: R.dp(50) }

                CPText
                {
                    text: "비밀번호"
                    color: R.color_bgColor001
                    font.pointSize: R.font_size_common_style_login
                    width: R.dp(300)
                    height: R.dp(182)
                    verticalAlignment: Text.AlignVCenter
                }

                LYMargin { width: R.dp(10) }
                CPTextField
                {
                    id: passTxt
                    width: appWindow.width - R.dp(350)
                    height: R.dp(182)
                    placeholderText: R.message_form_password
                    text: dummyPass
                    font.pointSize: R.font_size_common_style_login
                    maximumLength: 16
                    echoMode: TextInput.Password
                }

            }
            LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_bgColor001 }
            Row
            {
                width: parent.width
                height: R.dp(182)

                LYMargin { width: R.dp(50) }

                CPText
                {
                    text: "비밀번호 확인"
                    color: R.color_bgColor001
                    font.pointSize: R.font_size_common_style_login
                    width: R.dp(300)
                    height: R.dp(182)
                    verticalAlignment: Text.AlignVCenter
                }

                LYMargin { width: R.dp(10) }
                CPTextField
                {
                    id: cnfPassTxt
                    width: R.dp(600)
                    height: R.dp(182)
                    placeholderText: R.message_retyping_password
                    text: dummyRePass
                    font.pointSize: R.font_size_common_style_login
                    maximumLength: 50
                    echoMode: TextInput.Password
                }

            }
            LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_bgColor001 }
            Row
            {
                width: parent.width
                height: R.dp(182)

                LYMargin { width: R.dp(50) }

                CPText
                {
                    text: "이름"
                    color: R.color_bgColor001
                    font.pointSize: R.font_size_common_style_login
                    width: R.dp(300)
                    height: R.dp(182)
                    verticalAlignment: Text.AlignVCenter
                }

                LYMargin { width: R.dp(10) }
                CPTextField
                {
                    id: nameTxt
                    width: R.dp(600)
                    height: R.dp(182)
                    placeholderText: "이름을 입력하세요."
                    text: dummyName
                    font.pointSize: R.font_size_common_style_login
                    maximumLength: 30
                }

            }
            LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_bgColor001 }
            Row
            {
                width: parent.width
                height: R.dp(182)

                LYMargin { width: R.dp(50) }

                CPText
                {
                    text: "닉네임"
                    color: R.color_bgColor001
                    font.pointSize: R.font_size_common_style_login
                    width: R.dp(300)
                    height: R.dp(182)
                    verticalAlignment: Text.AlignVCenter
                }

                LYMargin { width: R.dp(10) }
                CPTextField
                {
                    id: nicknameTxt
                    width: parent.width - R.dp(50) - R.dp(300) - R.dp(10) - R.dp(228) - R.dp(80)//R.dp(500)
                    height: R.dp(182)
                    placeholderText: "닉네임을 입력하세요."
                    text: dummyNickname
                    font.pointSize: R.font_size_common_style_login
                    maximumLength: 30
                    onTextChanged:
                    {
                        checkedNicknameFromClient = false;
                    }
                }

                LYMargin { width: R.dp(30) }
                CPTextButton
                {
                    name: "중복확인"
                    pointSize: R.pt(36)
                    width: R.dp(228)
                    height: R.dp(100)
                    anchors.verticalCenter: parent.verticalCenter
                    onClick:
                    {
                        switch(cmd.checkNickname(nicknameTxt.text))
                        {
                        case ENums.NO_SPECIAL_CHAR:
                            alarm("닉네임에는 특수문자를 사용할 수 없습니다.");
                            checkedNicknameFromClient = false;
                            checkedNicknameResultFromServer = ENums.WAIT;
                            break;

                        case ENums.NO_KOREAN_INITIAL:
                            alarm("닉네임에는 한글 초성을 사용할 수 없습니다.");
                            checkedNicknameFromClient = false;
                            checkedNicknameResultFromServer = ENums.WAIT;
                            break;

                        case ENums.WRONG_LENGTH:
                            alarm("닉네임은 2~30자까지 사용가능합니다.")
                            checkedNicknameFromClient = false;
                            checkedNicknameResultFromServer = ENums.WAIT;
                            break;

                        case ENums.ALL_RIGHT:
                            checkedNicknameFromClient = true;
                            md.setShowIndicator(true);
                            wk.duplicateNickname(nicknameTxt.text);
                            wk.request();
                            break;
                        }
                    }
                }

                Timer
                {
                    running: opt.ds ? false : (wk.duplicatedNicknameResult !== ENums.WAIT && checkedNicknameFromClient)
                    repeat: false
                    interval: 200
                    onTriggered:
                    {
                        md.setShowIndicator(false);
                        var type = wk.volDuplicatedNicknameResult();
                        switch(type)
                        {
                        case ENums.POSITIVE:
                            alarm("사용할 수 있는 닉네임입니다.");
                            checkedNicknameResultFromServer = ENums.POSITIVE;
                            break;
                        case ENums.NAGATIVE:
                            error();
                            checkedNicknameFromClient = false;
                            checkedNicknameResultFromServer = ENums.NAGATIVE;
                            break;
                        case ENums.NOT_OPENED:
                            error();
                            checkedNicknameFromClient = false;
                            checkedNicknameResultFromServer = ENums.NOT_OPENED;
                            break;
                        }
                    }
                }
            }
            LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_bgColor001 }
            Row
            {
                width: parent.width
                height: R.dp(182)

                LYMargin { width: R.dp(50) }

                CPText
                {
                    text: "이메일"
                    color: R.color_bgColor001
                    font.pointSize: R.font_size_common_style_login
                    width: R.dp(300)
                    height: R.dp(182)
                    verticalAlignment: Text.AlignVCenter
                }

                LYMargin { width: R.dp(10) }
                CPTextField
                {
                    id: emailTxt
                    width: R.dp(600)
                    height: R.dp(182)
                    placeholderText: "이메일을 입력하세요."
                    text: dummyEmail
                    font.pointSize: R.font_size_common_style_login
                    maximumLength: 80
                }

            }
            LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_bgColor001 }

            Row
            {
                width: parent.width
                height: R.dp(182)

                LYMargin { width: R.dp(50) }

                CPText
                {
                    text: "성별"
                    color: R.color_bgColor001
                    font.pointSize: R.font_size_common_style_login
                    width: R.dp(300)
                    height: R.dp(182)
                    verticalAlignment: Text.AlignVCenter
                }

                LYMargin { width: R.dp(40) }
                CPGenderSelector
                {
                    id: genderSelector
                    width: parent.width - R.dp(390)
                }
            }

            LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_bgColor001 }
            Row
            {
                width: parent.width
                height: R.dp(182)

                LYMargin { width: R.dp(50) }

                CPText
                {
                    text: "생년월일"
                    color: R.color_bgColor001
                    font.pointSize: R.font_size_common_style_login
                    width: R.dp(300)
                    height: R.dp(182)
                    verticalAlignment: Text.AlignVCenter
                }

                LYMargin { width: R.dp(10) }
                CPTextField
                {
                    id: birthTxt
                    width: R.dp(600)
                    height: R.dp(182)
                    placeholderText: "ex) 19950619"
                    text: dummyBirth
                    font.pointSize: R.font_size_common_style_login
                    maximumLength: 8
                    inputMethodHints: Qt.ImhDigitsOnly
                }

            }
            LYMargin { width: parent.width; height: R.height_line_1px; color: R.color_bgColor001 }
            //            LYMargin { width: parent.width; height: R.dp(38) }

        }


    }

    CPTextButton
    {
        name: "다음"
        pointSize: R.font_size_common_style_login
        anchors
        {
            bottom: parent.bottom
            left: parent.left
        }

        onClick:
        {
            if(opt.ds) return;

            /* 아이디 체크 */
            var message = "";
            if(!checkedIDFromClient)
            {
                alarm("아이디 중복확인을 해주세요.");
                return;
            }

            switch(checkedIDResultFromServer)
            {
            case ENums.NAGATIVE:
            case ENums.NOT_OPENED:
                alarm(settings.errorMessage);
                return;
            }

            /* 비밀번호 체크 */
            var checkPass = cmd.checkPass(passTxt.text);
            switch(checkPass)
            {
            case ENums.NO_SMALL:
            case ENums.NO_CAPITAL:
            case ENums.NO_NUMBER:
            case ENums.NO_KOREAN:
            case ENums.NO_SPECIAL_CHAR:
                alarm(R.message_check_password_expression);
                return;
            case ENums.WRONG_LENGTH:
                alarm(R.message_check_password_length);
                return;
            }

            /* 비밀번호 확인 체크 */
            if(passTxt.text !== cnfPassTxt.text)
            {
                alarm(R.message_check_password_repeat);
                return;
            }

            /* 이름 체크 */
            var checkName = cmd.checkNickname(nameTxt.text);
            switch(checkName)
            {
            case ENums.WRONG_FORM:
                alarm("이름에는 특수문자를 사용할 수 없습니다.");
                return;

            case ENums.WRONG_LENGTH:
                alarm("이름은 2~30자까지 가능합니다.");
                return;
            }

            /* 닉네임 체크 */
            if(!checkedNicknameFromClient)
            {
                alarm("닉네임 중복확인을 해주세요.");
                return;
            }

            switch(checkedNicknameResultFromServer)
            {
            case ENums.NAGATIVE:
            case ENums.NOT_OPENED:
                alarm(settings.errorMessage);
                return;
            }

            /* 이메일 체크 */
            var checkEmail = cmd.checkEmail(emailTxt.text.trim());
            switch(checkEmail)
            {
            case ENums.WRONG_FORM:
                alarm("이메일 형식이 잘못되었습니다.");
                return;
            case ENums.WRONG_LENGTH:
                alarm("이메일은 10~50자까지 입력가능합니다.");
                return;
            }

            /* 생년월일 체크 */
            var checkBirth = cmd.checkBirth(birthTxt.text);
            switch(checkBirth)
            {
            case ENums.WRONG_FORM:
                alarm("생년월일에는 숫자만 사용가능합니다.");
                return;

            case ENums.WRONG_LENGTH:
                alarm("8자로 된 생년월일을 입력해야 합니다.");
                return;

            case ENums.WRONG_BIRTH:
                alarm("유효하지 않은 생년월일입니다.");
                return;
            }

            var id = idTxt.text.trim();
            var pass = passTxt.text.trim();
            var name = nameTxt.text.trim();
            var nickname = nicknameTxt.text.trim();
            var birth = birthTxt.text.trim();
            var gender = genderSelector.selectedSex;
            var email = emailTxt.text.trim();
            md.setShowIndicator(true);
            wk.join(id, pass, name, nickname, email, gender, birth);
            wk.request();
        }

        Timer
        {
            running: opt.ds ? false : (wk.joinResult!==ENums.WAIT)
            repeat: false
            onTriggered:
            {
                md.setShowIndicator(false);
                if(wk.vJoinResult() === ENums.POSITIVE)
                {
                    settings.setId(idTxt.text.trim());
                    settings.setPassword(passTxt.text);
                    pushUserStack("JoinFinished");
                }
                else error();
            }
        }
    }
}
