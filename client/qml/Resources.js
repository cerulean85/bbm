function dp(size) { return di.dp(size); }
function pt(size)
{
    if(Qt.platform.os === "osx" || Qt.platform.os === "windows")
        return di.pt(size) * 0.5;
    return di.pt(size);
}

function viewWidth() { return di.width(); }
function viewHeight()
{
    if(Qt.platform.os == "android") return di.height() - np.getStatusBarHeight(); /* Android don't includes the status bar height. */
    else return di.height(); /* iOS includes the status bar height. */
}

function image(name)
{
    if(name.length > 0 && name !== undefined)
    {
        name = replaceAll(name, "/");
        name = replaceAll(name, "\\");
        name = replaceAll(name, ".");
        name = replaceAll(name, "&");
    }
    return "../img/" + name + ".png";
}

function imageJPG(name)
{
    if(name.length > 0 && name !== undefined)
    {
        name = replaceAll(name, "/");
        name = replaceAll(name, "\\");
        name = replaceAll(name, ".");
        name = replaceAll(name, "&");
    }
    return "../img/" + name + ".jpg";
}

function os() { return Qt.platform.os; }

function toTime(mSecs)
{
    var hours = parseInt((mSecs / (1000*60*60))%24);
    var minutes = parseInt((mSecs / (1000*60))%60);
    var seconds = parseInt(mSecs / (1000)%60);

    hours = (hours < 10) ? "0" + hours : hours;
    minutes = (minutes < 10) ? "0" + minutes : minutes;
    seconds = (seconds < 10) ? "0" + seconds : seconds;

    return hours + ":" + minutes + ":" + seconds;
}

var system_font = "../font/NanumBarunGothic.ttf";
var height_statusbar = 0//Qt.platform.os == "ios" ? np.getStatusBarHeight() : 0
var height_titleBar = dp(144);
var height_button_middle = dp(144);
var height_tabBar = dp(172);
var width_banner_thumb = viewWidth();
var height_banner_thumb = dp(500)
var width_course_list_thumb = viewWidth()
var height_course_list_thumb = dp(560) //settings.deviceName() === "iPhone X" ? dp(460) : dp(560)
var width_course_intro_thumb = dp(1242)
var height_course_intro_thumb = dp(792)
var width_clip_list_thumb = dp(385)
var height_clip_list_thumb = dp(510)
var width_myprofile_thumb = dp(180)
var height_myprofilet_thumb = dp(180)
var width_comment_profile_thumb = dp(110)
var height_comment_profile_thumb = dp(110)
var height_boundary = height_line_1px * 5;

var color_appTitlebar = "#ffffff"
var color_appTitleText = "black"
var color_buttonPressed = "#44000000"

var color_theme01 = "#fa7070"

var color_bgColor001 = "#fa7070" //"#ffc81e"//"#fa7070"
var color_bgColor002 = "#f9acac" //"#ffe650"//"#f9acac"
var color_bgColor003 = "#ffe9e9" //"#fff56e"//"#ffe9e9"
var color_bgColor004 = "#ff8c8c"

var color_orange = "#f6712a"
var color_toast = "#656565"

var color_kut_orange = "#ff7f00"
var color_kut_blue = "#183072"
var color_kut_lightBlue = "#22449c"
var color_kut_lightGray = "#b3b3aa"
var color_kut_gray = "#4c4c4c"

var color_gray001 = "#f5f6f6"
var color_gray88 = "#888888"
var color_gray87 = "#878787"
var color_grayED = "#ededed"
var color_grayE1 = "#e1e1e1"
var color_grayCF = "#cfcfcf"

var colorBox =
        [
            "#ef404a", "#f2728c", "#ffd400", "#80b463", "#27aae1",
            "#4eb8b9", "#9e7eb9", "#a7a9ac", "#f79552", "#f9c0c7",
            "#ffcc43", "#d5e05b", "#81d3eb", "#b0dfdb","#bbb8dc"
        ];
//var color_vivid01 = "#ef404a"
//var color_vivid02 = "#f2728c"
//var color_vivid03 = "#ffd400"
//var color_vivid04 = "#80b463"
//var color_vivid05 = "#27aae1"
//var color_vivid06 = "#4eb8b9"
//var color_vivid07 = "#9e7eb9"
//var color_vivid08 = "#a7a9ac"
//var color_vivid09 = "#f79552"
//var color_vivid10 = "#f9c0c7"
//var color_vivid11 = "#ffcc43"
//var color_vivid12 = "#d5e05b"
//var color_vivid13 = "#81d3eb"
//var color_vivid14 = "#b0dfdb"
//var color_vivid15 = "#bbb8dc"

var height_event_contents = 0;
var height_applied_contents = 0;


var MARGIN_XL     =   pt(45)//80
var MARGIN_L      =  pt(37.5)//72
var MARGIN_ML     = pt(33.5)//64
var MARGIN_M      = pt(21)//40
var MARGIN_MS      = pt(17)//32
var MARGIN_S       =  pt(12.5)//24
var MARGIN_XS       = pt(8)//16
var MARGIN_XXS       = pt(5)//8

var font_XXXXL        =  pt(89.25)//170
var font_XXXL        =  pt(51)//98
var font_XXL        = pt(38.5)//74
var font_XL         =  pt(35)//67
var font_L         =pt(30)//57
var font_ML        = pt(24.5)//47
var font_M           = pt(21.5)//41
var font_S         =  pt(19)//36
var font_XS         =  pt(17)//32.5


var string_title  = "OLEI ekoreatech"


var design_size_width = dp(1242); //di.width();
var design_size_height = dp(2208); //di.height();

var view_file_popup = "CPPopup.qml"

var view_file_joinDesk = "PGJoinDesk.qml"
var view_file_joinEmail = "PGJoinEmail.qml"
var view_file_loginEmail = "PGLoginEmail.qml"
var view_file_loginDesk = "PGLoginDesk.qml"
var view_file_myClassRoom = "PGRoomMyClass.qml"
var view_file_option = "PGOption.qml"
var view_file_boardNotice = "PGBoardNotice.qml"
var view_file_boardQnA = "PGBoardQnA.qml"
var view_file_boardData = "PGBoardData.qml"
var view_file_videoPlayer_landscape = "PGVideoPlayerLandscape.qml"
var view_file_videoPlayer_portrait = "PGVideoPlayerPortrait.qml"
var view_file_regularLecture = "PGLectureRegular.qml"
var view_file_recentlyLecture = "PGLectureRecently.qml"
var view_file_myLecture = "PGLectureMine.qml"
var view_file_myPage = "PGMyPage.qml"
var view_file_joinClause = "PGJoinClause.qml"
var view_file_joinIdentity = "PGJoinIdentity.qml"
var view_file_joinSetInfo = "PGJoinSetInfo.qml"

var height_line_1px = Qt.platform.os === "ios" ? 0.5 : 1

var dummyID = ""//"JHtest6@test.ac.kr";
var dummyPass = ""//"@Qw12345678";
var adminEmail = "ibeobom@gmail.com";

var message_check_password_expression = "비밀번호는 9~16자의 영문 대소문자와 숫자, 특수문자 조합이어야 합니다.";
var message_check_password_length = "비밀번호는 9~16자이어야 합니다.";
var message_check_password_repeat = "비밀번호 확인을 다시해주세요.";
var message_need_login = "해당 기능을 이용하기 위해서는 로그인이 필요합니다. 로그인하시겠습니까?";
var message_question_finish_clip = "현재 강의를 수강완료 하시겠습니까?";
var message_notice_finished_clip = "정상적으로 처리되었습니다.";
var message_apply_event = "이벤트를 신청하시겠습니까?";
var message_no_data = "데이터가 존재하지 않습니다.";
var message_load_data = "데이터를 불러오는 중입니다.";
var message_has_no_article = "해당 게시물이 존재하지 않습니다.";
var message_has_no_course_list = "강좌 목록이 존재하지 않습니다.";
var message_has_no_alarm_list = "알림 목록이 존재하지 않습니다.";
var message_load_alarm_list = "알림 목록을 불러오는 중입니다.";
var message_has_no_article_list = "게시글 목록이 존재하지 않습니다.";
var message_load_article_list = "게시글 목록을 불러오는 중입니다.";
var message_has_no_history_list = "내역이 존재하지 않습니다.";
var message_load_history_list = "내역을 불러오는 중입니다.";
var message_has_no_event_list = "이벤트 목록이 존재하지 않습니다.";
var message_load_event_list = "이벤트 목록을 불러오는 중입니다.";
var message_cancel_write_article = "작성 중인 글이 있습니다. 계속 진행하시겠습니까?";
var message_withdraw_user = "탈퇴한 사용자입니다.";
var message_form_password = "숫자, 대소문자, 특수문자 조합의 9~16자";
var message_retyping_password = "비밀번호를 다시 입력해주세요.";
var message_enrolled_alarm = "신고가 접수되었습니다.";
var message_load_main_item_list = "강좌 목록을 불러오는 중입니다.";
var message_has_no_clip_list = "클립 목록이 존재하지 않습니다.";
var message_load_clip_item_list = "클립 목록을 불러오는 중입니다.";
var message_cant_load_content = "콘텐츠를 호출할 수 없습니다.";
var message_has_no_comment = "댓글 목록이 존재하지 않습니다.";
var message_load_comment = "댓글 목록을 불러오는 중입니다.";

var sample_image01 = "https://scontent-sjc3-1.cdninstagram.com/vp/eaf56aa30148a578e29d34631cb84968/5BB12F51/t51.2885-15/e35/26156236_123939068416546_2742507055683207168_n.jpg"
var sample_image02 = "http://kr.people.com.cn/NMediaFile/2017/0808/FOREIGN201708081338000326513010044.jpg"
var sample_image03 = "https://0.soompi.io/wp-content/uploads/2018/04/04033103/Song-Ji-Hyo1.jpg"
var sample_image04 = "http://img.yonhapnews.co.kr/etc/inner/KR/2018/03/28/AKR20180328100900005_01_i.jpg"
var sample_image05 = "https://0.soompi.io/wp-content/uploads/2018/04/04033103/Song-Ji-Hyo1.jpg"
var sample_image06 = "https://www.fashionseoul.com/wp-content/uploads/2015/08/20150807-Archimedes_So-Ji-sub-e1438915205628.jpg"
var sample_image07 = "https://www.fashionseoul.com/wp-content/uploads/2017/03/20170323_aSO-1.jpg"

var font_size_2grid_title = pt(50)
var font_size_2grid_keyword = pt(40)
var font_size_2grid_view_count = pt(40)
var font_size_list_title = pt(45)
var font_size_date = pt(40)
var font_size_common_button = pt(45)
var font_size_category_button = pt(45)
var font_size_notice_list_common_title = pt(45)
var font_size_notice_list_common_date = pt(40)
var font_size_common_style_login = pt(45)

var btn_name_close = "X";
var btn_close_white_image = "close_x_white";
var btn_close_gray_image = "close_x_gray";

var timer_interval_net = 200;

var margin_common = dp(60);

var name_stack_home = "home";
var name_stack_user = "user";

var os_name_android = "android";
var os_name_ios = "ios";

var device_ios_6 = "iPhone 6";
var device_ios_7 = "iPhone 7";
var device_ios_8 = "iPhone 8";

var viewer_from_desk = "course_desk";
var viewer_from_like_clip = "course_like_clip";
var viewer_from_like_comment = "course_like_comment";
var viewer_from_search = "course_search";
var viewer_from_push = "push";

function emptyAndUse(oldUrl, newUrl)
{
    if(oldUrl !== "")
    url = "";

}

function hideKeyboard()
{
    log("Hide the keyboard!");
    if (Qt.inputMethod.visible)
    {
        Qt.inputMethod.commit();
        Qt.inputMethod.hide();
    }
}

function log(msg)
{
//    console.log(msg);
}

function startsWithAndReplace(target, checkStr, replaceStr)
{
    if(target.startsWith(checkStr))
    {
        return replaceStr + target.substring(checkStr.length, target.length)
    }
    return target;
}

function toHttp(target)
{
    return startsWithAndReplace(target, "https", "http");
//    if(Qt.platform.os === os_name_android) return startsWithAndReplace(target, "https", "http");
//    return target;

}

function replace(strString, targetChar, convertChar)
{
    var strTmp = "";

    for (var i = 0; i< strString.length; i++) {
        if (strString.charAt(i) !== targetChar) {
            strTmp = strTmp + strString.charAt(i);
        }
        else strTmp = strTmp + convertChar;
    }
    return strTmp;
}

function replaceAll(strString, strChar) {
    var strTmp = "";

    for (var i = 0; i< strString.length; i++) {
        if (strString.charAt(i) !== strChar) {
            strTmp = strTmp + strString.charAt(i);
        }
    }
    return strTmp;
}

function flickVelocity(value) { return 50 * value; }


var txt_title_clause1 = "이용약관";
var txt_clause1 = "제 1 조 (목적)\n"+
"이 약관은 한국기술교육대학교 온라인평생교육원 clip learning(이하\"교육원\"이라 한다)이 제공하는 제반 서비스의 이용과 관련하여 기관과 회원과의 권리, 의무 및 책임사항, 기타 필요한 사항을 규정함을 목적으로 합니다.\n"+
"\n"+
"제 2 조 (정의)\n"+
"이 약관에서 사용하는 용어의 정의는 다음과 같습니다.\n"+
"① \"서비스\"라 함은 \"교육원\"의 앱을 통하여 제공하는 제반 서비스를 의미합니다.\n"+
"② \"회원\"이라 함은 \"교육원\"의 \"서비스\"에 접속하여 이 약관에 따라 \"교육원\"과 이용계약을 체결하고 \"교육원\"이 제공하는 \"서비스\"를 이용하는 고객을 말합니다.\n"+
"③\"운영자\": 회사가 제공하는 서비스의 전반적인 관리와 원할한 운영을 위하여 회사에서 선정한 자를 말합니다.\n"+
"④ \"아이디(ID)\"라 함은 \"회원\"의 식별과 \"서비스\"이용을 위하여 \"회원\"이 정하고 \"교육원\"이 승인 하는 문자와 숫자의 조합(혹은 이메일 주소) 혹은 소셜네트워크 고유 값을 의미합니다. \"비밀번호\"라 함은 \"회원\"이 부여 받은 \"아이디\"와 일치되는 \"회원\"임을 확인하고 비밀보호 를 위해 \"회원\"자신이 정한 문자 또는 숫자, 특수문자의 조합을 의미합니다.\n"+
"⑤ \"콘텐츠\"라 함은 \"교육원\"이 제공하는 온라인 디지털 콘텐츠(각종정보 콘텐츠, VOD, 기타 콘텐츠를 포함) 및 제반 서비스를 의미합니다.\n"+
"⑥ \"게시물\"이라 함은 \"회원\"이 \"서비스\"를 이용함에 있어 \"서비스상\"에 게시한 부호ㆍ문자ㆍ음성ㆍ 음향ㆍ화상ㆍ동영상 등의 정보 형태의 글, 사진, 동영상 및 각종 파일과 링크 등을 의미합니다.\n"+
"※ 그 외 정의되지 않은 이 약관상의 용어의 의미는 일반적인 관행에 의합니다.\n"+
"\n"+
"제 3 조 (약관의 게시와 개정)\n"+
"① \"교육원\"은 이 약관의 내용을 \"회원\"이 쉽게 알 수 있도록 서비스 초기 화면에 게시합니다.\n"+
"② \"교육원\"은 \"약관의 규제에 관한 법률\", \"정보통신망 이용 촉진 및 정보 보호 등에 관한 법률(이하 \"정보통신망법\")\"등 관련법을 위배하지 않는 범위에서 이 약관을 개정할 수 있습니다.\n"+
"③ \"교육원\"이 약관을 개정할 경우에는 적용일자 및 개정사유를 명시하여 현행약관과 함께 제1항의 방식에 따라 그 개정약관의 적용일자 30일 전부터 적용일자 전일까지 공지합니다. 다만, 회원에게 불리한 약관의 개정의 경우에는 공지 외에 일정기간 서비스 내 전자우편, 전자쪽지, 로그인시 동의 창 등의 전자적 수단을 통해 따로 명확히 통지 하도록 합니다.\n"+
"④ \"교육원\"은 전항에 따라 개정약관을 공지 또는 통지하면서 회원에게 30일 기간 내에 의사표시를 하지 않으면 의사표시가 표명된 것으로 본다는 뜻을 명확하게 공지 또는 통지하였음에도 회원이 명시적으로 거부의 의사표시를 하지 아니한 경우 회원이 개정약관에 동의한 것으로 봅니다.\n"+
"⑤ 회원이 개정약관의 적용에 동의하지 않는 경우 \"교육원\"은 개정 약관의 내용을 적용할 수 없으며, 이 경우 회원은 이용계약을 해지할 수 있습니다. 다만, 기존 약관을 적용할 수 없는 특별한 사정이 있는 경우에는 \"교육원\"은 이용계약을 해지할 수 있습니다.\n"+
"\n"+
"제 4 조 (약관의 해석)\n"+
"① \"교육원\"은 \"콘텐츠\" 및 개별 서비스에 대해서는 별도의 이용약관 및 정책을 둘 수 있으며, 해당 내용이 이 약관과 상충할 경우에는 관계법령이 우선하여 적용 할 수 있습니다.\n"+
"② 이 약관에서 정하지 아니한 사항이나 해석에 대해서는 상관례에 따릅니다.\n"+
"\n"+
"제 5 조 (이용계약 체결)\n"+
"① 이용계약은 \"회원\"이 되고자 하는 자(이하 \"가입신청자\"라 한다)가 약관의 내용에 대하여 동의를 한 다음 회원가입신청을 하고 \"교육원\"이 이러한 신청에 대하여 승낙함으로써 체결됩니다.\n"+
"② \"교육원\"은 \"가입신청자\"의 신청에 대하여 \"서비스\" 이용을 승낙함을 원칙으로 합니다. 다만, \"교육원\"\"은 다음 각 호에 해당하는 신청에 대하여는 승낙을 하지 않거나 사후에 이용계약을 해지할 수 있습니다.\n"+
"  1. 가입신청자가 이 약관에 의하여 이전에 회원자격을 상실한 적이 있는 경우, 단 \"교육원\"의 회원 재가입 승낙을 얻은 경우에는 예외로 함\n"+
"  2. 실명이 아니거나 타인의 명의를 이용한 경우\n"+
"  3. 허위의 정보를 기재하거나, \"교육원\"이 제시하는 내용을 기재하지 않은 경우\n"+
"  4. 14세 미만 아동이 법정대리인(부모 등)의 동의를 얻지 아니한 경우\n"+
"  5. 이용자의 귀책사유로 인하여 승인이 불가능하거나 기타 규정한 제반 사항을 위반 하며 신청하는 경우\n"+
"③ 제1항에 따른 신청에 있어 \"교육원\"은 \"회원\"의 종류에 따라 전문기관을 통한 실명확인 및 본인인증을 요청할 수 있습니다.\n"+
"④ \"교육원\"은 서비스 관련 설비의 여유가 없거나, 기술상 또는 업무상 문제가 있는 경우에는 승낙을 유보할 수 있습니다.\n"+
"⑤ 제2항과 제4항에 따라 회원가입신청의 승낙을 하지 아니하거나 유보한 경우, \"교육원\"은 원칙적으로 이를 가입신청자에게 알리도록 합니다.\n"+
"⑥ 이용계약의 성립 시기는 \"교육원\"이 가입완료를 신청절차 상에서 표시한 시점으로 합니다.\n"+
"⑦ \"교육원\"은 \"회원\"에 대해 \"교육원\"정책에 따라 등급별로 구분하여 이용시간, 이용횟수, 서비스 메뉴 등을 세분하여 이용에 차등을 둘 수 있습니다.\n"+
"⑧ \"교육원\"은 \"회원\"에 대하여 \"청소년보호법\"등에 따른 등급 및 연령 준수를 위해 이용제한이나 등급별 제한을 할 수 있습니다.\n"+
"\n"+
"제 6 조 (회원정보의 변경)\n"+
"① \"회원\"은 개인정보관리화면을 통하여 언제든지 본인의 개인정보를 열람하고 수정할 수 있습니다. 다만, 서비스 관리를 위해 필요한 별명, 아이디 등은 수정이 불가능합니다.\n"+
"② \"회원\"은 회원가입신청 시 기재한 사항이 변경되었을 경우 온라인으로 수정을 하거나 전자우편 기 타 방법으로 \"교육원\"에 대하여 그 변경사항을 알려야 합니다.\n"+
"③ 제2항의 변경사항을 \"교육원\"\"에 알리지 않아 발생한 불이익에 대하여 \"교육원\"\"은 책임지지 않습니다.\n"+
"\n"+
"제 7 조 (개인정보보호 의무)\n"+
"\"교육원\"은 \"정보통신망법\", \"개인정보보호법\"등 관계 법령이 정하는 바에 따라 \"회원\"의 개인정보를 보호하기 위해 노력합니다. 개인정보의 보호 및 사용에 대해서는 관련법 및 \"교육원\"의 개인정보처리방침이 적용됩니다. 다만, \"교육원\"의 공식 사이트 이외의 링크된 사이트에서는 \"교육원\"의 개인정보처리방침이 적용되지 않습니다.\n"+
"\n"+
"제 8 조 (\"회원\"의 \"아이디\"및 \"비밀번호\"의 관리에 대한 의무)\n"+
"① \"회원\"의 \"아이디\"와 \"비밀번호\"에 관한 관리책임은 \"회원\"에게 있으며, 이를 제3자가 이용하도록 하여서는 안 됩니다.\n"+
"② \"교육원\"은 \"회원\"의 \"아이디\"가 개인정보 유출 우려가 있거나, 반사회적 또는 미풍양속에 어긋나거나 \"교육원\" 및 \"교육원의 운영자\"로 오인한 우려가 있는 경우, 해당 \"아이디\"의 이용을 제한할 수 있습니다.\n"+
"③ \"회원\"은 \"아이디\"및 \"비밀번호\"가 도용되거나 제3자가 사용하고 있음을 인지한 경우에는 이를 즉시 \"교육원\"에 통지하고 \"교육원\"의 안내에 따라야 합니다.\n"+
"④ 제3항의 경우에 해당 \"회원\"이 \"교육원\"에 그 사실을 통지하지 않거나, 통지한 경우에도 \"교육원\"의 안내에 따르지 않아 발생한 불이익에 대하여 \"교육원\"은 책임지지 않습니다.\n"+
"\n"+
"제 9 조 (\"회원\"에 대한 통지)\n"+
"① \"교육원\"이 \"회원\"에 대한 통지를 하는 경우 이 약관에 별도 규정이 없는 한 서비스 내 전자우편주소, 푸시알림 등으로 할 수 있습니다.\n"+
"② \"교육원\"은 \"회원\"전체에 대한 통지의 경우 10일 이상 \"교육원\"의 게시판에 게시함으로써 제1항의 통지에 갈음할 수 있습니다.\n"+
"\n"+
"제 10 조 (\"교육원\"의 의무)\n"+
"① \"교육원\"은 관련법과 이 약관이 금지하거나 미풍양속에 반하는 행위를 하지 않으며, 계속적이고 안정적으로 \"서비스\"를 제공하기 위하여 최선을 다하여 노력합니다.\n"+
"② \"교육원\"은 \"회원\"이 안전하게 \"서비스\"를 이용할 수 있도록 개인정보보호를 위해 보안시스템을 갖추어야 하며 개인정보처리방침을 공시하고 준수합니다.\n"+
"③ \"교육원\"은 서비스이용과 관련하여 \"회원\"으로부터 제기된 의견이나 불만이 정당하다고 인정할 경우에는 이를 처리하여야 합니다. \"회원\"이 제기한 의견이나 불만사항에 대해서는 게시판을 활용 하거나 전자우편 등을 통하여 \"회원\"에게 처리과정 및 결과를 전달합니다.\n"+
"\n"+
"제 11 조 (\"회원\"의 의무)\n"+
"① \"회원\"은 다음 행위를 하여서는 안 됩니다.\n"+
"  1. 신청 또는 변경 시 허위내용의 등록\n"+
"  2. 타인의 정보도용\n"+
"  3.\"교육원\"이 게시한 정보의 변경\n"+
"  4.\"교육원\"이 정한 정보 이외의 정보(컴퓨터 프로그램 등) 등의 송신 또는 게시\n"+
"  5.\"교육원\"과 기타 제3자의 저작권 등 지적재산권에 대한 침해\n"+
"  6.\"교육원\"및 기타 제3자의 명예를 손상시키거나 업무를 방해하는 행위\n"+
"  7. 외설 또는 폭력적인 메시지, 화상, 음성, 기타 공서양속에 반하는 정보를 \"서비스\"에 공개 또는 게시하는 행위\n"+
"  8.\"교육원\"의 동의 없이 영리를 목적으로 \"서비스\"를 사용하는 행위\n"+
"  9. 기타 불법적이거나 부당한 행위\n"+
"② \"회원\"은 관계법, 이 약관의 규정, 이용안내 및 \"서비스\"와 관련하여 공지한 주의사항,\"교육원\"이 통지하는 사항 등을 준수하여야 하며, 기타 \"교육원\"의 업무에 방해되는 행위를 하여서는 안 됩니다.\n"+
"③ \"회원\"이 \"서비스\"를 이용하여 통신판매 또는 통신판매중개를 업으로 하여 \"교육원\" 가 제공하는 \"서비스\"를 방해되는 행위를 하여서 안됩니다.\n"+
"\n"+
"제 12 조 (\"서비스\"의 제공 등)\n"+
"① \"교육원\"는 회원에게 아래와 같은 서비스를 제공합니다.\n"+
"  1. 콘텐츠 검색 서비스\n"+
"  2. 이러닝 콘텐츠 스트리밍 서비스\n"+
"  3. 게시판형 서비스\n"+
"  4. 기타 \"교육원\"이 추가 개발하거나 다른 기관와의 제휴계약 등을 통해 \"회원\"에게 제공하는 일체의 서비스\n"+
"② \"교육원\"는 \"서비스\"를 일정범위로 분할하여 각 범위 별로 이용가능시간을 별도로 지정할 수 있습니다. 다만, 이러한 경우에는 그 내용을 사전에 공지합니다.\n"+
"③ \"서비스\"는 연중무휴, 1일 24시간 제공함을 원칙으로 합니다.\n"+
"④ \"교육원\"은 컴퓨터 등 정보통신설비의 보수점검, 교체 및 고장, 통신두절 또는 운영상 상당한 이유 가 있는 경우 \"서비스\"의 제공을 일시적으로 중단할 수 있습니다. 이 경우 \"교육원\"은 제9조[\"회원\"에 대한 통지]에 정한 방법으로 \"회원\"에게 통지합니다. 다만, \"교육원\"이 사전에 통지할 수 없는 부득이한 사유가 있는 경우 사후에 통지할 수 있습니다.\n"+
"⑤ \"교육원\"은 서비스의 제공에 필요한 경우 정기점검을 실시할 수 있으며, 정기점검시간은 서비스제공 화면에 공지한 바에 따릅니다.\n"+
"\n"+
"제 13 조 (\"서비스\"의 변경)\n"+
"① \"교육원\"은 상당한 이유가 있는 경우에 운영상, 기술상의 필요에 따라 제공하고 있는 전부 또는 일부 \"서비스\"를 변경할 수 있습니다.\n"+
"② \"서비스\"의 내용, 이용방법, 이용시간에 대하여 변경이 있는 경우에는 변경사유, 변경될 서비스의 내용 및 제공일자 등은 그 변경 전에 해당 서비스 초기화면에 게시하여야 합니다.\n"+
"③ \"교육원\"은 무료로 제공되는 서비스의 일부 또는 전부를 \"교육원\"의 정책 및 운영의 필요상 수정, 중단, 변경할 수 있으며, 이에 대하여 관련법에 특별한 규정이 없는 한 \"회원\"에게 별도의 보상을 하지 않습니다.\n"+
"\n"+
"제 14 조 (정보의 제공 및 광고의 게재)\n"+
"① \"교육원\"은 \"회원\"이 \"서비스\"이용 중 필요하다고 인정되는 다양한 정보를 공지사항이나 전자우편 등의 방법으로 \"회원\"에게 제공할 수 있습니다. 다만, \"회원\"은 관련법에 따른 거래관련 정보 및 고객문의 등에 대한 답변 등을 제외하고는 언제든지 전자우편에 대해서 수신 거절을 할 수 있습니다.\n"+
"② 제1항의 정보를 전화 및 모사전송기기에 의하여 전송하려고 하는 경우에는 \"회원\"의 사전 동의를 받아서 전송합니다. 다만, \"회원\"의 관련 정보 및 고객문의 등에 대한 회신에 있어서는 제외됩니다.\n"+
"③ \"교육원\"은 \"서비스\"의 운영과 관련하여 서비스화면, 공지사항, 전자우편 등에 광고를 게재할 수 있습니다.\n"+
"④ \"이용자(회원, 비회원 포함)\"는 \"교육원\"이 제공하는 서비스와 관련하여 게시물 또는 기타 정보를 변경, 수정, 제한하는 등의 조치를 취하지 않습니다.\n"+
"\n"+
"제 15 조 (\"게시물\"의 저작권)\n"+
"① \"회원\"이 \"서비스\"내에 게시한 \"게시물\"의 저작권은 해당 게시물의 저작자에게 귀속됩니다.\n"+
"② \"회원\"이 \"서비스\"내에 게시하는 \"게시물\"은 검색결과 내지 \"서비스\"및 관련 프로모션 등에 노출될 수 있으며, 해당 노출을 위해 필요한 범위 내에서는 일부 수정, 복제, 편집되어 게시될 수 있습니다. 이 경우, \"교육원\"은 저작권법 규정을 준수하며, \"회원\"은 언제든지 고객센터 또는 \"서비스\" 내 관리기능을 통해 해당 게시물에 대해 삭제, 검색결과 제외, 비공개 등의 조치를 취할 수 있습니다.\n"+
"③ \"교육원\"은 제2항 이외의 방법으로 \"회원\"의 \"게시물\"을 이용하고자 하는 경우에는 전화, 팩스, 전자우편 등을 통해 사전에 \"회원\"의 동의를 얻어야 합니다.\n"+
"\n"+
"제 16 조 (\"게시물\"의 관리)\n"+
"① \"회원\"의 \"게시물\"이 \"정보통신망법\"및 \"저작권법\"등 관련법에 위반되는 내용을 포함하는 경우, 권리자는 관련법이 정한 절차에 따라 해당 \"게시물\"의 게시중단 및 삭제 등을 요청할 수 있으며, \"교육원\"은 관련법에 따라 조치를 취하여야 합니다.\n"+
"② \"교육원\"은 전항에 따른 권리자의 요청이 없는 경우라도 권리침해가 인정될 만한 사유가 있거나 기타 기관 정책 및 관련법에 위반되는 경우에는 관련법에 따라 해당 \"게시물\"에 대해 임시조치 등 을 취할 수 있습니다.\n"+
"③ 본 조에 따른 세부절차는 \"정보통신망법\"및 \"저작권법\"이 규정한 범위 내에서 \"교육원\"이 정한 \"게시중단요청서비스\"에 따릅니다.\n"+
"\n"+
"제 17 조 (권리의 귀속)\n"+
"① \"서비스\"에 대한 저작권 및 지적재산권은 \"교육원\"에 귀속됩니다. 단, \"회원\"의 \"게시물\"및 제휴 계약에 따라 제공된 저작물 등은 제외합니다.\n"+
"② \"교육원\"은 서비스와 관련하여 \"회원\"에게 \"교육원\"이 정한 이용조건에 따라 계정, \"아이디\", 콘텐츠 등을 이용할 수 있는 이용권만을 부여하며, \"회원\"은 이를 양도, 판매, 담보제공 등의 처분행위를 할 수 없습니다.\n"+
"\n"+
"제 18 조 (계약해제, 해지 등)\n"+
"① \"회원\"은 언제든지 서비스초기화면의 설정 또는 문의하기 메뉴 등을 통하여 이용계약 해 지 신청을 할 수 있으며, \"교육원\"은 관련법 등이 정하는 바에 따라 이를 즉시 처리하여야 합니다.\n"+
"② \"회원\"이 계약을 해지할 경우, 관련법 및 개인정보처리방침에 따라 \"교육원\"이 회원정보를 보유하는 경우를 제외하고는 해지 즉시 \"회원\"의 모든 데이터는 소멸됩니다.\n"+
"③ \"회원\"이 계약을 해지하는 경우, 타인에 의해 담기, 스크랩 등이 되어 재 게시되거나, 공용게시판 에 등록된 \"게시물\"등은 삭제되지 않으니 사전에 삭제 후 탈퇴하시기 바랍니다.\n"+
"\n"+
"제 19 조 (이용제한 등)\n"+
"① \"교육원\"은 \"회원\"이 이 약관의 의무를 위반하거나 \"서비스\"의 정상적인 운영을 방해한 경우, 경고, 일시정지, 영구이용정지 등으로 \"서비스\"이용을 단계적으로 제한할 수 있습니다.\n"+
"② \"교육원\"은 전항에도 불구하고, 명의도용, \"저작권법\"및 \"컴퓨터프로그램보호법\"을 위반한 불법 프로그램의 제공 및 운영방해, \"정보통신망법\"을 위반한 불법통신 및 해킹, 악성프로그램의 배포, 접속권한 초과행위 등과 같이 관련법을 위반한 경우에는 즉시 영구이용정지를 할 수 있습니다. \"교육원\"은 이에 대해 별도로 보상하지 않습니다.\n"+
"③ \"교육원\"은 \"회원\"이 계속해서 6개월 이상 로그인하지 않는 경우, 회원정보의 보호 및 운영의 효율성을 위해 이용을 제한할 수 있습니다.\n"+
"④ \"교육원\"은 본 조의 이용제한 범위 내에서 제한의 조건 및 세부내용은 이용제한정책 및 개별 서비스 상의 운영정책에서 정하는 바에 의합니다.\n"+
"⑤ 본 조에 따라 \"서비스\"이용을 제한하거나 계약을 해지하는 경우에는 \"교육원\"은 제9조[\"회원\"에 대한 통지]에 따라 통지합니다.\n"+
"⑥ \"회원\"은 본 조에 따른 이용제한 등에 대해 \"교육원\"이 정한 절차에 따라 이의신청을 할 수 있습니다. 이 때 이의가 정당하다고 \"교육원\"이 인정하는 경우 \"교육원\"은 즉시 \"서비스\"의 이용을 재개합니다.\n"+
"\n"+
"제 20 조 (책임제한)\n"+
"① \"교육원\"은 천재지변 또는 이에 준하는 불가항력으로 인하여 \"서비스\"를 제공할 수 없는 경우에는 \"서비스\"제공에 관한 책임이 면제됩니다.\n"+
"② \"교육원\"은 \"회원\"의 귀책사유로 인한 \"서비스\"이용의 장애에 대하여는 책임을 지지 않습니다.\n"+
"③ \"교육원\"은 \"회원\"이 \"서비스\"와 관련하여 게재한 정보, 자료, 사실의 신뢰도, 정확성 등의 내용에 관하여는 책임을 지지 않습니다.\n"+
"④ \"교육원\"은 \"회원\"간 또는 \"회원\"과 제3자 상호간에 \"서비스\"를 매개로 하여 거래 등을 한 경우 에는 책임이 면제됩니다.\n"+
"⑤ \"교육원\"은 무료로 제공되는 서비스 이용과 관련하여 관련법에 특별한 규정이 없는 한 책임을 지지 않습니다.\n"+
"\n"+
"제 21 조 (준거법 및 재판관할)\n"+
"① \"교육원\"과 \"회원\"간 제기된 소송은 대한민국법을 준거법으로 합니다.\n"+
"② \"교육원\"과 \"회원\"간 발생한 분쟁에 관한 소송은 제소 당시의 \"회원\"의 주소에 의하고, 주소가 없는 경우 거소를 관할하는 지방법원의 전속관할로 합니다. 단, 제소 당시 \"회원\"의 주소 또는 거소가 명확하지 아니한 경우의 관할법원은 민사소송법에 따라 정합니다.\n"+
"③ 해외에 주소나 거소가 있는 \"회원\"의 경우 \"교육원\"과 \"회원\"간 발생한 분쟁에 관한 소송은 전항에도 불구하고 대한민국 대전지방법원 천안지원을 관할 법원으로 합니다.";

var txt_title_clause2 = "개인정보 수집 및 이용"
var txt_clause2 =
"1. 개인정보의 수집 및 이용 목적\n"+
"\"교육원\"은 개인정보를 다음의 목적을 위해 처리하며, 처리한 개인정보는 다음의 목적이외의 용도로는 사용되지 않으며 이용 목적이 변경될 시에는 사전 동의를 구할 예정입니다.\n"+
"① 홈페이지 회원가입 및 관리\n"+
"- 회원 가입의사 확인, 회원제 서비스 제공에 따른 본인 식별·인증, 회원자격 유지·관리, 제한적 본인 확인제 시행에 따른 본인확인, 서비스 부정이용 방지, 만14세 미만 아동 개인정보 수집 시 법정대리인 동의 여부 확인, 각종 고지·통지, 고충처리, 분쟁 조정을 위한 기록 보존 등을 목적으로 개인정보를 처리합니다.\n"+
"② 민원사무 처리\n"+
"- 민원인의 신원 확인, 민원사항 확인, 사실조사를 위한 연락·통지, 처리결과 통보 등을 목적으로 개인 정보를 처리합니다.\n"+
"③ 재화 또는 서비스 제공\n"+
"- 서비스 제공, 콘텐츠 제공, 맞춤 서비스 제공, 본인인증 등을 목적으로 개인정보를 처리합니다.\n"+
"④ 마케팅 및 광고에의 활용\n"+
"- 신규 서비스(제품) 개발 및 맞춤 서비스 제공, 이벤트 및 광고성 정보 제공 및 참여기회 제공, 인구통계 학적 특성에 따른 서비스 제공 및 광고 게재, 서비스의 유효성 확인, 접속빈도 파악 또는 회원의 서비스 이용에 대한 통계 등을 목적으로 개인정보를 처리합니다. \n"+
"\n"+
"2. 수집하려는 개인정보의 항목\n"+
"① 일반회원 가입시 수집하는 개인정보 항목\n"+
"- 필수정보 : 이름, 로그인 ID, 비밀번호, 성별, 생년월일, 휴대폰번호, 이메일, 기기 고유정보\n"+
"② 서비스 이용과정이나 사업처리 과정에서 아래와 같은 정보들이 자동으로 생성되어 수집될 수 있습니다.\n"+
"- 방문일시, 서비스 이용기록, 불량이용 기록 \n"+
"\n"+
"3. 개인정보의 보유 및 이용기간\n"+
"<홈페이지 회원가입 및 관리>, <민원사무 처리>, <재화 또는 서비스 제공>, <마케팅 및 광고에의 활용>와 관련한 개인정보는 수집, 이용에 관한 동의일로부터까지 위 이용목적을 위하여 보유 및 이용됩니다.\n"+
"① 보유 및 이용기간 : 회원 가입일로 부터 탈퇴 시점 까지\n"+
"② 보유근거 : 정보주체의 동의\n"+
"③ 관련법령 : 개인정보보호법 제15조 (개인정보의 수집·이용), 공공기록물관리에 관한 법률 시행령 제26조 1항(보존기간)\n";

var txt_title_clause3 = "개인정보의 제3자 제공"
var txt_clause3 =
"교육원은 정보주체의 동의, 법률의 특별한 규정 등 개인정보 보호법 제17조 및 제18조에 해당하는 경우에만 개인정보를 제3자에게 제공합니다.\n"+
"\n"+
"[교육협약기업]\n"+
"① 개인정보를 제공받는 자 : 온라인평생교육원과 교육협약을 체결한 자\n"+
"② 제공근거 : 정보주체의 동의\n"+
"③ 제공받는 자의 개인정보 이용목적 : 교육훈련정보 제공\n"+
"④ 제공하는 개인정보 항목 : 로그인ID, 성명, 생년월일, 이메일, 휴대전화번호, 수강 과목명, 수료여부, 성별, 학습자구분\n"+
"⑤ 제공받는 자의 보유?이용기간 : 회원가입일로 부터 탈퇴 시 까지\n"+
"\n"+
"교육원은 원칙적으로 정보주체의 개인정보를 본래의 목적 범위를 초과하여 처리하거나 제3자에게 제공하지 않습니다.\n"+
"단, 다음의 경우에는 개인정보를 제3자에게 제공할 수 있습니다.\n"+
"① 정보주체로부터 별도의 동의를 받은 경우, 다른 법률에 특별한 규정이 있는 경우\n"+
"② 정보주체 또는 그 법정대리인이 의사표시를 할 수 없는 상태에 있거나 주소불명 등으로 사전 동의를 받을 수 없는 경우로서 명백히 정보주체 또는 제3자의 급박한 생명, 신체, 재산의 이익을 위하여 필요하다고 인정되는 경우\n"+
"③ 통계작성 및 학술연구 등의 목적을 위하여 필요한 경우로서 특정 개인을 알아볼 수 없는 형태로 개인정보를 제공하는 경우\n"+
"④ 개인정보를 목적 외의 용도로 이용하거나 이를 제3자에게 제공하지 아니하면 다른 법률에서 정하는 소관 업무를 수행할 수 없는 경우로서 보호위원회의 심의?의결을 거친 경우\n"+
"⑤ 조약, 그 밖의 국제협정의 이행을 위하여 외국정부 또는 국제기구에 제공하기 위하여 필요한 경우\n"+
"⑥ 범죄의 수사와 공소의 제기 및 유지를 위하여 필요한 경우\n"+
"⑦ 법원의 재판업무 수행을 위하여 필요한 경우\n"+
"⑧ 형(刑) 및 감호, 보호처분의 집행을 위하여 필요한 경우\n"+
"※ 단, 정보주체 또는 제3자의 이익을 부당하게 침해할 우려가 있는 경우에는 제외 \n"+
"\n"+
"교육원은 이용자의 개인정보를 제3자에게 제공하는 경우, 반드시 사전에 합당한 절차를 통하여 다음 각 호의 사항을 상세히 기재하여 이용자의 동의를 구하겠습니다.\n"+
"① 개인정보를 제공받는 자\n"+
"② 개인정보 이용목적(제공 시에는 제공받는 자의 이용목적을 말한다.)\n"+
"③ 이용 또는 제공하는 개인정보의 항목\n"+
"④ 개인정보의 보유 및 이용 기간(제공 시에는 제공받는 자의 보유 및 이용기간을 말한다.)\n"+
"⑤ 동의를 거부할 권리가 있다는 사실 및 동의 거부에 따른 불이익이 있는 경우에는 그 불이익의 내용\n";
