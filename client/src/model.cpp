#include "model.h"
//#include "model2.h"

Model* Model::m_instance = nullptr;
//Model2* Model2::m_instance = nullptr;


//3-1. 홈 메인화면(과목리스트받아오기)
QList<QObject*> Model::bannerList()
{
    return m_bannerList;
}

void Model::setBannerList(QList<QObject*> m)
{
    m_bannerList.clear();
    //        m_bannerList = m;
    for(QObject* o : m)
    {
        Banner* tmp = qobject_cast<Banner*>(o);
        Banner* b = new Banner();
        b->setBoardNo(tmp->boardNo());
        b->setBoardArticleNo(tmp->boardArticleNo());
        b->setTitle(tmp->title());
        b->setFileUrl(tmp->fileUrl());
        b->setThumbNailUrl(tmp->thumbNailUrl());
        b->setOrder(tmp->order());
        m_bannerList.append(qobject_cast<QObject*>(b));
    }


    emit bannerListChanged();
}
