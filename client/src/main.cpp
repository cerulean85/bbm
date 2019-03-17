#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "native_app.h"
#include "display_information.h"
#include "model.h"
#include "option.h"
#include "networker.h"
#include "commander.h"
#include "settings.h"
#include "imageresponseprovider.h"
#include "imagepicker.h"
#include "page_manager.h"
#include <QThread>
#include <QSettings>
#include "enums.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    DisplayInfo dpInfo;

    qmlRegisterType<ImagePicker>("QmlTypes", 1, 0, "ImagePicker");
        qmlRegisterType<ENums>("enums", 1, 0, "ENums");
    Option opt; opt.setDs(false);

    NativeApp *np = NativeApp::getInstance();
    Model *model = Model::getInstance();
    NetWorker *wk = NetWorker::getInstance();
    Commander *cmd = Commander::getInstance();
    Settings *settings = Settings::getInstance();
    AlarmPopup *alarmPopup = AlarmPopup::getInstance();
    PageManager *pm = PageManager::getInstance();
    ClipViewer *cl = new ClipViewer();

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("np", np);
    engine.rootContext()->setContextProperty("di", &dpInfo);
    engine.rootContext()->setContextProperty("md", model);
    engine.rootContext()->setContextProperty("wk", wk);
    engine.rootContext()->setContextProperty("opt", &opt);
    engine.rootContext()->setContextProperty("cmd", cmd);
    engine.rootContext()->setContextProperty("settings", settings);
    engine.rootContext()->setContextProperty("ap", alarmPopup);
    engine.rootContext()->setContextProperty("pm", pm);
    engine.rootContext()->setContextProperty("clipViewer", cl);
    engine.addImageProvider("async", new AsyncImageProvider);

    engine.load(QUrl(QLatin1String("qrc:/qml/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
