import QtQuick 2.9
import "Resources.js" as R
Item {
    id: mainView
    width: R.dp(1242)
    height: R.dp(182)

    property int _selectedSex : 0

    /* 0 : MAN, 1: WOMAN */
    property alias selectedSex : mainView._selectedSex


    Row
    {
        width: parent.width
        height: R.dp(182)

        Rectangle
        {
            width: R.dp(134)
            height: R.dp(50)
            anchors
            {
                verticalCenter: parent.verticalCenter
            }

            Row
            {
                width: parent.widh
                height: parent.height

                Rectangle
                {
                    width: R.dp(50)
                    height: R.dp(50)
                    radius: 20
                    border.width: R.height_line_1px
                    border.color: R.color_bgColor001
                    color: "white"

                    CPImage
                    {
                        width: R.dp(50)
                        height: R.dp(50)
                        source: R.image("check_mark")
                        visible: _selectedSex == 0 ? true : false
                    }
                }

                LYMargin { width: R.dp(10) }
                CPText
                {
                    text: "남자"
                    width: R.dp(100)
                    height: R.dp(50)
                    color: R.color_gray87
                    font.pointSize: R.font_size_common_style_login
                }
            }
            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    _selectedSex = 0;
                }
            }
        }

        LYMargin { width: R.dp(148) }
        Rectangle
        {
            width: R.dp(134)
            height: R.dp(50)
            anchors
            {
                verticalCenter: parent.verticalCenter
            }

            Row
            {
                width: parent.widh
                height: parent.height

                Rectangle
                {
                    width: R.dp(50)
                    height: R.dp(50)
                    radius: 20
                    border.width: R.height_line_1px
                    border.color: R.color_bgColor001
                    color: "white"

                    CPImage
                    {
                        width: R.dp(50)
                        height: R.dp(50)
                        source: R.image("check_mark")
                        visible: _selectedSex == 1 ? true : false
                    }
                }

                LYMargin { width: R.dp(10) }
                CPText
                {
                    text: "여자"
                    width: R.dp(100)
                    height: R.dp(50)
                    color: R.color_gray87
                    font.pointSize: R.font_size_common_style_login
                }
            }
            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    _selectedSex = 1;
                }
            }
        }
    }
}
