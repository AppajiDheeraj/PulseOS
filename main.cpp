#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "backend/SystemController.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Register SystemController as a QML type
    qmlRegisterType<SystemController>("CarbonQt", 1, 0, "SystemController");

    QQmlApplicationEngine engine;

    // Load the main QML module
    const QUrl url(u"qrc:/qt/qml/CarbonQt/qml/App.qml"_qs);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);

    engine.loadFromModule("CarbonQt", "App");

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
