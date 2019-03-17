#include <UIKit/UIKit.h>
//#include <qpa/qplatformnativeinterface.h>
#include <QtGui>
#include <QtQuick>
#include <MobileCoreServices/MobileCoreServices.h>
#include "src/imagepicker.h"
#include <qqml.h>
#include <qpa/qplatformnativeinterface.h>
//#include "../Config.h"

#define PICKER 6
#define CAMERA 7

@interface ImagePickerDelegate : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
                                     ImagePicker *m_imagePicker;
}
@end

@implementation ImagePickerDelegate

- (id) initWithObject:(ImagePicker *)imagePicker
{
    self = [super init];
    if (self) {
        m_imagePicker = imagePicker;
    }
    return self;
}

- (UIImage *)fixOrientation:(UIImage *)image {

    // No-op if the orientation is already correct
    if (image.imageOrientation == UIImageOrientationUp) return image;

    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;

    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;

        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;

        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }

    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;

        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }

    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;

        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }

    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


- (UIImage *)scaleAndRotateImage:(UIImage *)image {

    int kMaxResolution = 640; // Or whatever

    CGImageRef imgRef = image.CGImage;

    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);


    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }

    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {

        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;

        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;

        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;

        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;

        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;

        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;

        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;

        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;

        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];

    }

    UIGraphicsBeginImageContext(bounds.size);

    CGContextRef context = UIGraphicsGetCurrentContext();

    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }

    CGContextConcatCTM(context, transform);

    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return imageCopy;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //DEBUG;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"/image-%f.jpg", [[NSDate date] timeIntervalSince1970]];
    path = [path stringByAppendingString:fileName];
    UIImage *image = nil;
    if([info objectForKey:UIImagePickerControllerEditedImage])
    {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    else
    {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    //qDebug() << m_imagePicker->imageScale();
    //qDebug() << m_imagePicker->imageQuality();
    //qDebug() << m_imagePicker->saveImageToCameraRoll();
    if(picker.view.tag == CAMERA && m_imagePicker->saveImageToCameraRoll())
    {
        //qDebug() << "#####" << m_imagePicker->saveImageToCameraRoll();
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    //UIImage *uImage = [UIImage imageWithCGImage:[image CGImage]
    //        scale:m_imagePicker->imageScale()
    //        orientation:UIImageOrientationUp];
    UIImage *uRotatedImage = [self fixOrientation:image];
    [UIImageJPEGRepresentation(uRotatedImage, m_imagePicker->imageQuality()) writeToFile:path options:NSAtomicWrite error:nil];
    m_imagePicker->setImagePath(QString::fromNSString(path));
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end

ImagePicker::ImagePicker(QQuickItem *parent) :
    QQuickItem(parent),
    m_delegate([[ImagePickerDelegate alloc] initWithObject:this]),
    m_imageName(""),
    m_imagePath(""),
    m_imageScale(1.0),
    m_imageQuality(1.0),
    m_crop(false),
    m_saveImageToCameraRoll(true)
{
    //qmlRegisterType<ImagePicker>(cfg.uri, 1, 0, "ImagePicker");
    //DEBUG;
}

void ImagePicker::openPicker()
{
//    UIView *view = static_cast<UIView *>(
//                QGuiApplication::platformNativeInterface()
//                ->nativeResourceForWindow("uiview", window()));
    UIViewController *qtController = [[[UIApplication sharedApplication] keyWindow]rootViewController]; //[[view window] rootViewController];
    UIImagePickerController *imageController = [[[UIImagePickerController alloc] init] autorelease];
    [imageController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imageController setAllowsEditing: m_crop ? YES : NO];
    [imageController setDelegate:id(m_delegate)];
    [imageController setMediaTypes: [NSArray arrayWithObjects:(NSString*)kUTTypeImage, nil]];
    [[imageController view] setTag:PICKER];
    [qtController presentViewController:imageController animated:YES completion:nil];
}

void ImagePicker::openCamera()
{
//    UIView *view = static_cast<UIView *>(
//                QGuiApplication::platformNativeInterface()
//                ->nativeResourceForWindow("uiview", window()));
    UIViewController *qtController = [[[UIApplication sharedApplication] keyWindow]rootViewController]; //[[view window] rootViewController];
    UIImagePickerController *imageController = [[[UIImagePickerController alloc] init] autorelease];
    [imageController setSourceType:UIImagePickerControllerSourceTypeCamera];
    [imageController setAllowsEditing: m_crop ? YES : NO];
    [imageController setDelegate:id(m_delegate)];
    [imageController setMediaTypes: [NSArray arrayWithObjects:(NSString*)kUTTypeImage, nil]];
    [[imageController view] setTag:CAMERA];
    [qtController presentViewController:imageController animated:YES completion:nil];
}

void ImagePicker::onResultRecieved(QObject* imgPickerResult)
{

}
