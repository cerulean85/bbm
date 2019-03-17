#pragma once
#include <QObject>
#include <QSize>
#include <QRect>

class DisplayInfo : public QObject
{
    Q_OBJECT

public:
    DisplayInfo(QObject *parent = NULL);
    ~DisplayInfo();

    Q_INVOKABLE QSize  screenSize() const;    
//    Q_INVOKABLE qreal  px(double val) const;
//    Q_INVOKABLE qreal  widthPercent(double proportion) const;
//    Q_INVOKABLE qreal  heightPercent(double proportion) const;

    Q_INVOKABLE qreal  dp(const int value) const;
    Q_INVOKABLE qreal  pt(const int value) const;
    Q_INVOKABLE int width() const;
    Q_INVOKABLE int height() const;

  private:
//    qreal refDpi     ;
//    qreal refHeight  ;
//    qreal refWidth   ;
//    QRect rect       ;
    int   m_width      ;
    int   m_height     ;
//    qreal dpi        ;
//    qreal hdpi       ;
    qreal m_ratio    = 1.0;
    qreal m_ratioFont = 1.0;
//    qreal dpiFactor  ;
};
