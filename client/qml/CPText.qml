import QtQuick 2.9
import "Resources.js" as R

Text {
    property int style : 0

    wrapMode: Text.Wrap
    elide: Text.ElideRight
//    font.pixelSize: R.font_M

    font.family: fontLoader.name
    horizontalAlignment: Text.AlignLeft
//    lineHeight: lineCount==1? 1 :


    //    font.family: fontType==0 ?

    FontLoader {
        id: fontLoader
        source:R.system_font;
    }
}
