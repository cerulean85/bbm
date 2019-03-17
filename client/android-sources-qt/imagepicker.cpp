    #include <QAndroidJniEnvironment>
#include <QAndroidJniObject>
#include <QtAndroid>
#include <QDebug>
#include <QFile>
#include <QFileInfo>
#include "src/imagepicker.h"
#include "src/native_app.h"
#include <qqml.h>

ImagePicker::ImagePicker(QQuickItem *parent) :
    QQuickItem(parent),
    m_delegate(NULL),
    m_imageName(""),
    m_imagePath(""),
    m_imageScale(1.0),
    m_imageQuality(1.0),
    m_crop(true),
    m_saveImageToCameraRoll(true)
{

}
void ImagePicker::openPicker()
{
    OnPickImageResult* pickImageResult = new OnPickImageResult(this);
    connect(pickImageResult, SIGNAL(resultRecieve(QObject*)), SLOT(onResultRecieved(QObject*)));

    QAndroidJniObject activity = QtAndroid::androidActivity();
    QAndroidJniObject intent = activity.callObjectMethod("createPickImageAlbumIntent", "()Landroid/content/Intent;");

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
    else
    {
        QtAndroid::startActivity(intent, PICK_IMAGE_FROM_ALBUM, pickImageResult);
    }
}

void ImagePicker::openCamera()
{
    OnPickImageResult* pickImageResult = new OnPickImageResult(this);
    connect(pickImageResult, SIGNAL(resultRecieve(QObject*)), SLOT(onResultRecieved(QObject*)));

    QAndroidJniObject activity = QtAndroid::androidActivity();
    QAndroidJniObject intent = activity.callObjectMethod("createPickImageCameraIntent", "()Landroid/content/Intent;");

    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
    else
    {
        QtAndroid::startActivity(intent, PICK_IMAGE_FROM_CAMERA, pickImageResult);
    }
}

void ImagePicker::openCropImage(QString srcImageFilePath, QString dstImageFilePath)
{
    OnPickImageResult* pickImageResult = new OnPickImageResult(this);
    connect(pickImageResult, SIGNAL(resultRecieve(QObject*)), SLOT(onResultRecieved(QObject*)));
    pickImageResult->m_tempImagePath = dstImageFilePath;

    QAndroidJniObject activity = QtAndroid::androidActivity();
    QAndroidJniObject intent = activity.callObjectMethod("createCropImageIntent",
                                                         "(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;",
                                                         QAndroidJniObject::fromString(srcImageFilePath).object<jstring>(),
                                                         QAndroidJniObject::fromString(dstImageFilePath).object<jstring>());
    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
    else
    {
        QString tartgetPath = removeStartWith(dstImageFilePath);
        QFile croppedFile(tartgetPath);
        if(croppedFile.exists())
        {
            setImagePath(dstImageFilePath);
        }
        else
        {
            tartgetPath = removeStartWith(srcImageFilePath);
            setImagePath(srcImageFilePath);
        }
        //QtAndroid::startActivity(intent, CROP_IMAGE, pickImageResult);
    }
}

QString ImagePicker::removeStartWith(QString str)
{
    int rLength = 0;
    if(str.length() > 0)
    {
        if(str.startsWith("/")) rLength = 1;
        else if(str.startsWith("//")) rLength = 2;
        else if(str.startsWith("///")) rLength = 3;
        str.replace(0, rLength, "");
    }
    return str;
}

void ImagePicker::onResultRecieved(QObject *imgPickerResult)
{
    OnPickImageResult* pickImageResult = qobject_cast<OnPickImageResult*>(imgPickerResult);
    QString           tempImagePath     = pickImageResult->m_tempImagePath;
    int               requestCode       = pickImageResult->m_requestCode;
    QAndroidJniObject selectedImageUri  = pickImageResult->m_selectedImageUri;
    delete pickImageResult;

    NativeApp* app = NativeApp::getInstance();

    if (requestCode == PICK_IMAGE_FROM_ALBUM)
    {
        QAndroidJniObject activity = QtAndroid::androidActivity();
        QAndroidJniObject selectedImageFileObj = activity.callObjectMethod("getPathFromAlbumImageUri",
                                                                           "(Landroid/net/Uri;)Ljava/lang/String;",
                                                                           selectedImageUri.object<jobject>());
        QString selectedImageFilePath = selectedImageFileObj.toString();
        QFileInfo selectedImageFileInfo(selectedImageFilePath);
        tempImagePath = app->getTempFilePathByExtension(NativeApp::DIR_TEMP, selectedImageFileInfo.suffix());
        QAndroidJniObject nonRotatedImageFileObj = activity.callObjectMethod("getRotatedImage",
                                                                             "(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;",
                                                                             QAndroidJniObject::fromString(selectedImageFilePath).object<jstring>(),
                                                                             QAndroidJniObject::fromString(tempImagePath).object<jstring>());
        QString nonRotatedImageFilePath = nonRotatedImageFileObj.toString();
//        qDebug() << "onResultRecieved PICK_IMAGE_FROM_ALBUM nonRotatedImageFilePath : " << selectedImageFilePath;

        QFile nonRotatedImageFile(nonRotatedImageFilePath);
        if(nonRotatedImageFile.exists())
        {
            if(m_crop) openCropImage(nonRotatedImageFilePath, tempImagePath);
            else setImagePath(nonRotatedImageFilePath);
        }
    }
    else if (requestCode == PICK_IMAGE_FROM_CAMERA){
        QString selectedImageFilePath;// = tempImagePath;

        QAndroidJniObject activity = QtAndroid::androidActivity();
        QAndroidJniObject pathObj = activity.callObjectMethod("getCameraImagePath", "()Ljava/lang/String;");
        selectedImageFilePath = pathObj.toString();

        QFileInfo selectedImageFileInfo(selectedImageFilePath);

        if(m_saveImageToCameraRoll){
            tempImagePath = app->getTempFilePathByExtension(NativeApp::DIR_IMAGE,
                                                            selectedImageFileInfo.suffix());
            if(QFile::copy(selectedImageFilePath, tempImagePath))
            {
                activity.callMethod<void>("showMediaFileToGallery",
                                          "(Ljava/lang/String;)V",
                                          QAndroidJniObject::fromString(tempImagePath).object<jstring>());
            }
        }

        tempImagePath = app->getTempFilePathByExtension(NativeApp::DIR_TEMP, selectedImageFileInfo.suffix());
        QAndroidJniObject nonRotatedImageFileObj = activity.callObjectMethod("getRotatedImage",
                                                                             "(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;",
                                                                             QAndroidJniObject::fromString(selectedImageFilePath).object<jstring>(),
                                                                             QAndroidJniObject::fromString(tempImagePath).object<jstring>());

        QString nonRotatedImageFilePath = nonRotatedImageFileObj.toString();
        QFileInfo nonRotatedImageFileInfo(nonRotatedImageFilePath);
        if(nonRotatedImageFileInfo.exists())
        {
            if(m_crop) {
                QString tempImagePath2 = app->getTempFilePathByExtension(NativeApp::DIR_TEMP,
                                                                         nonRotatedImageFileInfo.suffix());
                openCropImage(nonRotatedImageFilePath, tempImagePath2);
            }
            else
                setImagePath(nonRotatedImageFilePath);
        }
    }
    else if (requestCode == CROP_IMAGE){
//        qDebug() << "onResultRecieved CROP_IMAGE tempImagePath : " << tempImagePath;

        QFile imageFileInfo(tempImagePath);
        if(imageFileInfo.exists())
            setImagePath(tempImagePath);
    }
}
