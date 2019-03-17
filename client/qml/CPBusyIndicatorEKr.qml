/* https://github.com/lasconic/CustomBusyIndicator-QML */

import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import "Resources.js" as R

BusyIndicator {
    property int bSizeOut: opt.ds ? 25 : R.dp(25)
    property int bSizeIn: opt.ds ? 35 : R.dp(35)
    property int bSizeSpacing: opt.ds ? 5 : R.dp(5)
    property int bCountIndicator: 4
    property real bSpeed: 250 // smaller is faster
    width: bSizeIn * bCountIndicator + bSizeSpacing*3
    height: bSizeIn

    style: CPBusyIndicatorStyleEKr {
        sizeOut: bSizeOut
        sizeIn: bSizeIn
        sizeSpacing: bSizeSpacing
        countIndicator: bCountIndicator
        speed: bSpeed
    }
}
