#ifndef IMAGEPICKER_H
#define IMAGEPICKER_H

#include <QQuickItem>

#ifdef Q_OS_ANDROID
#include "../android-sources-qt/imagepicker_result.h"
#endif


class ImagePicker : public QQuickItem
{
  Q_OBJECT
  Q_PROPERTY(QString imageName  READ imageName    WRITE setImageName    NOTIFY imageNameChanged)
  Q_PROPERTY(QString imagePath  READ imagePath    WRITE setImagePath    NOTIFY imagePathChanged)
  Q_PROPERTY(float imageScale   READ imageScale   WRITE setImageScale   NOTIFY imageScaleChanged)
  Q_PROPERTY(float imageQuality READ imageQuality WRITE setImageQuality NOTIFY imageQualityChanged)
  Q_PROPERTY(bool crop          READ crop         WRITE setCrop         NOTIFY cropChanged)
  Q_PROPERTY(bool saveImageToCameraRoll READ saveImageToCameraRoll WRITE setSaveImageToCameraRoll NOTIFY saveImageToCameraRollChanged)

public:
  explicit ImagePicker(QQuickItem *parent = 0);
  Q_INVOKABLE void openPicker();
  Q_INVOKABLE void openCamera();
#ifdef Q_OS_ANDROID
  void openCropImage(QString srcImageFilePath, QString dstImageFilePath); // Only Android
#endif

  QString imageName() const
  {
    return m_imageName;
  }

  QString imagePath() const
  {
    return m_imagePath;
  }

  float imageScale() const
  {
    return m_imageScale;
  }

  float imageQuality() const
  {
    return m_imageQuality;
  }

  bool crop() const
  {
    return m_crop;
  }

  bool saveImageToCameraRoll() const
  {
    return m_saveImageToCameraRoll;
  }

signals:

  void imageNameChanged(QString imageName);

  void imagePathChanged(QString imagePath);

  void imageScaleChanged(float arg);

  void imageQualityChanged(float arg);

  void cropChanged(bool arg);

  void saveImageToCameraRollChanged(bool arg);

public slots:

//#ifdef Q_OS_ANDROID // ifdef 쓰면 no such slot 이라고 오류나면서 함수 인식 안됨
  //void onResultRecieved(OnPickImageResult* imgPickerResult);
  void onResultRecieved(QObject* imgPickerResult); // Only Android
//#endif

  void setImageName(QString arg);
  void setImagePath(QString arg);
  void setImageScale(float arg);
  void setImageQuality(float arg);
  void setCrop(bool arg);
  void setSaveImageToCameraRoll(bool arg);

private:
  void *m_delegate;
  QString m_imageName;
  QString m_imagePath;
  float m_imageScale;
  float m_imageQuality;
  bool m_crop;
  bool m_saveImageToCameraRoll;

  QString removeStartWith(QString str);

};

#endif // IMAGEPICKER_H
