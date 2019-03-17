import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2

Item {

    width: parent.width
    height: parent.height

    signal pick(string imagePath);

    property string filePath: ""
    property string fileName: ""


    FileDialog
    {
        id: dialog
        title: "Please Choose a file."
        nameFilters: ["Image Files (*.jpg *.png)", "All Files (*)"]
        onAccepted:
        {
            console.log("Chosen: " + fileUrl);
            filePath = fileUrl
            pick(fileUrl);
        }
    }

    function pickResult(path, name)
    {
        if(!opt.ds) cmd.imagePickerResult.disconnect();

        filePath = path;
        fileName = name;
        pick(path);
    }

    function openCamera()
    {
        var mobile = Qt.platform.os == "android" || Qt.platform.os == "ios";
        if(mobile)
        {
            cmd.clearImagePickerSlots();
            cmd.imagePickerResult.connect(pickResult);
            cmd.openImageCamera();
        }
        else dialog.open();
    }

    function openAlbum()
    {
        var mobile = Qt.platform.os == "android" || Qt.platform.os == "ios";
        if(mobile)
        {
            cmd.clearImagePickerSlots();
            cmd.imagePickerResult.connect(pickResult);
            cmd.openImagePicker();
        }
        else dialog.open();

    }

}
