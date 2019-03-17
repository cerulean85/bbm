/* https://github.com/lasconic/CustomBusyIndicator-QML */

//=============================================================================
// Copyright (c) 2014 Nicolas Froment

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//=============================================================================

import QtQuick 2.3
import QtQuick.Controls.Styles 1.2
import "Resources.js" as R

BusyIndicatorStyle {
    id: style
    property int sizeOut: R.dp(25)
    property int sizeIn: R.dp(40)
    property int sizeSpacing: R.dp(5)
    property int countIndicator: 4
    property real speed: 250
    property bool isRunning: true
    property string color1: "#FD9B1E";
    property string color2: "#5E73B6";
    property string color3: "#3BB24E";
    property string color4: "#CC5A71";

    indicator: Row {
        width: sizeIn*countIndicator + sizeSpacing*3
        height: sizeIn
        spacing: sizeSpacing
        Repeater {
            id: repeat
            model: countIndicator

            Item
            {
                width: sizeIn
                height: sizeIn
                Rectangle {
                    width: sizeOut
                    height: sizeOut
                    radius: 100
                    anchors
                    {
                        horizontalCenter: parent.horizontalCenter
                        verticalCenter: parent.verticalCenter
                    }

                    color: {
                        switch(index%4)
                        {
                            case 0: return color1;
                            case 1: return color2;
                            case 2: return color3;
                            case 3: return color4;
                            default: return "white"
                        }
                    }

                    Timer {
                        id: inside
                        interval: style.speed * index
                        running: isRunning
                        onTriggered: {
                            parent.width = sizeIn;
                            parent.height = sizeIn;
                            outside.start();
                        }
                    }
                    Timer {
                        id: outside
                        interval: style.speed
                        running: isRunning
                        onTriggered: {
                            parent.width = sizeOut;
                            parent.height = sizeOut;
                        }
                    }
                    Timer {
                        id: globalTimer
                        interval: style.speed * countIndicator
                        running: isRunning
                        onTriggered: {
                            inside.start();
                        }
                        triggeredOnStart: true
                        repeat: true
                    }
                    Component.onCompleted: {
                        globalTimer.start()
                    }
                }
            }
        }
    }
}
