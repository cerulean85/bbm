#include "imagepicker_result.h"
#include <QDebug>

OnPickImageResult::OnPickImageResult(QObject *parent)
    :QObject(parent), QAndroidActivityResultReceiver() {
    m_tempImagePath = "";
    m_requestCode = 0;
}

void OnPickImageResult::handleActivityResult(int requestCode, int resultCode, const QAndroidJniObject & intent)
{
    //qDebug() << "OnPickImageResult " << requestCode << " : " << resultCode;

    if (resultCode == -1)//RESULT_OK=-1, (resultCode != 0 && intent.isValid())
    {
        m_requestCode = requestCode;
        if (requestCode == PICK_IMAGE_FROM_ALBUM)
        {
      //      qDebug() << "OnPickImageResult PICK_IMAGE_FROM_ALBUM";
            m_selectedImageUri = intent.callObjectMethod("getData", "()Landroid/net/Uri;");
        }
        else if (requestCode == PICK_IMAGE_FROM_CAMERA)
        {
      //      qDebug() << "OnPickImageResult PICK_IMAGE_FROM_CAMERA";
        }
        else if(requestCode == CROP_IMAGE)
        {
      //      qDebug() << "OnPickImageResult CROP_IMAGE";
            m_selectedImageUri = intent.callObjectMethod("getData", "()Landroid/net/Uri;");
        }
        emit resultRecieve(this);
    }
}
