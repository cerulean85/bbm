import QtQuick 2.7

Image
{
    id: img
    asynchronous: true
    cache: true
    antialiasing: true
    fillMode: Image.PreserveAspectFit
    horizontalAlignment : Image.AlignHCenter
    verticalAlignment: Image.AlignVCenter
    smooth: true
    property bool isLoaded : false
}
