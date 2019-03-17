#include "imagepicker.h"
#include <qqml.h>
//#include "Config.h"
#include <QFileInfo>

#if !defined(Q_OS_ANDROID) && !defined(Q_OS_IOS)
ImagePicker::ImagePicker(QQuickItem *parent) :
    QQuickItem(parent),
    m_delegate(NULL),
    m_imageName(""),
    m_imagePath(""),
    m_imageScale(1.0),
    m_imageQuality(1.0),
    m_crop(false),
    m_saveImageToCameraRoll(false)
{
//    qmlRegisterType<ImagePicker>(cfg.uri, 1, 0, "ImagePicker");
}
void ImagePicker::openPicker()
{

}

void ImagePicker::openCamera()
{

}

void ImagePicker::onResultRecieved(QObject* imgPickerResult)
{

}

#endif


void ImagePicker::setImageName(QString arg)
{
  if (m_imageName != arg) {
    m_imageName = arg;
    emit imageNameChanged(arg);
  }
}
void ImagePicker::setImagePath(QString arg)
{
  if (m_imagePath != arg) {
    m_imagePath = arg;

    QFileInfo imageFileInfo(arg);
    setImageName(imageFileInfo.fileName());
    emit imagePathChanged(arg);
  }
}

void ImagePicker::setImageScale(float arg)
{
  if (m_imageScale != arg) {
    m_imageScale = arg;
    emit imageScaleChanged(arg);
  }
}

void ImagePicker::setImageQuality(float arg)
{
  if (m_imageQuality != arg) {
    m_imageQuality = arg;
    emit imageQualityChanged(arg);
  }
}

void ImagePicker::setCrop(bool arg)
{
  if (m_crop != arg) {
    m_crop = arg;
    emit cropChanged(arg);
  }
}

void ImagePicker::setSaveImageToCameraRoll(bool arg)
{
  if (m_saveImageToCameraRoll != arg) {
    m_saveImageToCameraRoll = arg;
    emit saveImageToCameraRollChanged(arg);
  }
}
