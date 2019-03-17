#include "display_information.h"
#include <QScreen>
#include <QGuiApplication>
#include <QDebug>
#include "native_app.h"
//#if defined(Q_OS_ANDROID)
//#include <QAndroidJniEnvironment>
//#include <QAndroidJniObject>
//#include <QtAndroid>
//#endif

DisplayInfo::DisplayInfo(/*int dpWidth,*/QObject *parent)
    : QObject(parent)
{
    //  refDpi      = 96;
    //  refHeight   = 1776.;
    //  refWidth    = 1080.;
    //  rect        = qApp->primaryScreen()->geometry();
    //  width       = qMin(rect.width(), rect.height());
    //  height      = qMax(rect.width(), rect.height());
    //  dpi         = qApp->primaryScreen()->logicalDotsPerInch();
    //  hdpi        = qApp->primaryScreen()->physicalDotsPerInch();
    //  m_ratio     = qMin(height/refHeight, width/refWidth);
    //m_ratioFont = qMin(heightrefDpi/(dpirefHeight), widthrefDpi/(dpirefWidth));

    //  dpiFactor = 2.0 / 3.0;
    //  #if defined(Q_OS_WIN)
    //    dpiFactor = dpi / 96;
    //  #elif defined(Q_OS_ANDROID)
    //    QAndroidJniObject activity = QtAndroid::androidActivity();
    //    QAndroidJniObject resources = activity.callObjectMethod("getResources", "()Landroid/content/res/Resources;");
    //    QAndroidJniObject displayMetrics = resources.callObjectMethod("getDisplayMetrics", "()Landroid/util/DisplayMetrics;");
    //    qreal densityDpi  = displayMetrics.getField<int>("densityDpi");
    //    qreal density     = displayMetrics.getField<float>("density");
    //    dpiFactor = 2.0 / 3.0 * density;
    //    /*if(densityDpi == 120) //DENSITY_LOW
    //      dpiFactor = 0.75 / density;
    //    else if(densityDpi == 160) //DENSITY_MEDIUM
    //      dpiFactor = 1.0 / density;
    //    else if(densityDpi == 240) //DENSITY_HIGH
    //      dpiFactor = 1.5 / density;
    //    else if(densityDpi == 320) //DENSITY_XHIGH
    //      dpiFactor = 2.0 / density;
    //    else if(densityDpi == 480) //DENSITY_XXHIGH
    //      dpiFactor = 3.0 / density;
    //    else if(densityDpi == 640) //DENSITY_XXXHIGH
    //      dpiFactor = 4.0 / density;*/
    //  #endif

    //QSize logicalSize = QGuiApplication::primaryScreen()->size();
    //QSizeF physicalSize = QGuiApplication::primaryScreen()->physicalSize();



    //    qreal refDpi = 252.;
    ////    qreal refHeight = 1080.;
    ////    qreal refWidth = 1776.;
    //    QRect rect = QGuiApplication::primaryScreen()->geometry();
    //    qreal height = qMax(rect.width(), rect.height());
    //    qreal width = qMin(rect.width(), rect.height());
    //    qreal dotsLogical = QGuiApplication::primaryScreen()->logicalDotsPerInch();
    //    qDebug() << "logicalDotsPerInch ::: " << dotsLogical;
    //    qreal dotsPhysical = qApp->primaryScreen()->physicalDotsPerInch();
    //    qDebug() << "physicalDotsPerInch ::: " << dotsPhysical;


    //    qDebug() << "logicalSize :: " << logicalSize;
    //    qDebug() << "physicalSize :: " << physicalSize;
    //    qDebug() << "availableSize :: " << QGuiApplication::primaryScreen()->availableSize();
    //    qDebug() << "WIDTH/HEIGHT :: " << QGuiApplication::primaryScreen()->geometry().size();
    //    qDebug() << "virualSize :: " << QGuiApplication::primaryScreen()->virtualSize();
    //    m_ratio = qMin(height/refHeight, width/refWidth);
    //    m_ratioFont = qMin(height*refDpi/(dpi*refHeight), width*refDpi/(dpi*refWidth));

    //    #if defined(Q_OS_ANDROID)
    //      m_ratioFont = dotsLogical / dotsPhysical; //dotsPhysical; //4/3;
    //      m_ratio = refDpi / dotsLogical / 160.0;
    //    #endif

    qreal refDpi = 72.;
    qreal refHeight = 2208.;
    QRect deviceRes = QGuiApplication::primaryScreen()->geometry();
    m_width = deviceRes.width();
    m_height = deviceRes.height();
    m_ratio = deviceRes.height() / refHeight;

    qreal dotsLogical = QGuiApplication::primaryScreen()->logicalDotsPerInch();
//    qreal dotsPhysical = QGuiApplication::primaryScreen()->physicalDotsPerInch();
    m_ratioFont = (refDpi / dotsLogical) * m_ratio;

//    qDebug() << "dotsLogical :: " << dotsLogical;
//    qDebug() << "dotsPhysical :: " << dotsPhysical;
//    qDebug() << "ratio :: " << m_ratio;
//    qDebug() << "ratioFont :: " << m_ratioFont;
//    qDebug() << "resHeight :: " << deviceRes.height();
//    qDebug() << "resWidth :: " << m_width;

    NativeApp* app = NativeApp::getInstance();
    if(!app->getDeviceName().compare("iPhone X")
            || !app->getDeviceName().compare("iPhone XR")
            || !app->getDeviceName().compare("iPhone XS")
            || !app->getDeviceName().compare("iPhone XS Max"))
        m_ratioFont = m_ratioFont * 0.8;
    else m_ratioFont = m_ratioFont * 1.0;
}

DisplayInfo::~DisplayInfo()
{

}

QSize DisplayInfo::screenSize() const
{
    return QSize(m_width, m_height);
}

qreal DisplayInfo::pt(const int value) const
{
    return int(value * m_ratioFont);
}

qreal DisplayInfo::dp(const int value) const
{
    return int(value * m_ratio);
    //      return int(value / m_ratioFont);
    //    return qMax(2, int(value * m_ratio));
}
int DisplayInfo::width() const
{
    return m_width;
}
int DisplayInfo::height() const
{
    return m_height;
}
//qreal DisplayInfo::pt(double val) const
//{
//   return val * dpiFactor;
//}

//qreal DisplayInfo::px(double val) const
//{
//  return val;
//}

//qreal DisplayInfo::widthPercent(double proportion) const
//{
//  return width * proportion;
//}

//qreal DisplayInfo::heightPercent(double proportion) const
//{
//  return height * proportion;
//}

