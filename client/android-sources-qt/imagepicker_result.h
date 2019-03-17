#ifndef IMAGEPICKER_RESULT
#define IMAGEPICKER_RESULT

#include <QObject>
#include <QAndroidJniObject>
#include <QtAndroid>
#include <QAndroidActivityResultReceiver>

#define  PICK_IMAGE_FROM_CAMERA 1001
#define  PICK_IMAGE_FROM_ALBUM  1002
#define  CROP_IMAGE       1003
#define  PICTURE_MAX_SIZE 256

class OnPickImageResult : public QObject, public QAndroidActivityResultReceiver
{
  Q_OBJECT

public:
  QString           m_tempImagePath;
  int               m_requestCode;
  QAndroidJniObject m_selectedImageUri;

  explicit OnPickImageResult(QObject *parent = NULL);
  //~OnPickImageResult();

  void handleActivityResult(int requestCode, int resultCode, const QAndroidJniObject & intent);

signals:
  //void resultRecieve(OnPickImageResult* imgPickerResult);
  void resultRecieve(QObject* imgPickerResult);
};


#endif // IMAGEPICKER_RESULT
