#pragma once
#include <QObject>
#include <QString>
#include <QVariantList>
#include "core/system_info.h"
#include "core/memory_stat.h"
#include "core/cpu_stat.h"
// #include "core/ProcessCollector.h"
// #include "core/ProcessInfo.h"
// #include "core/ProcessSnapshot.h"
// #include "core/ProcessModel.h"

class SystemController : public QObject {
    Q_OBJECT

    Q_PROPERTY(QString hostname READ hostname NOTIFY updated)
    Q_PROPERTY(QString os READ os NOTIFY updated)
    Q_PROPERTY(QString kernel READ kernel NOTIFY updated)
    Q_PROPERTY(QString uptime READ uptime NOTIFY updated)
    Q_PROPERTY(QString cpuModel READ cpuModel NOTIFY updated)
    Q_PROPERTY(int cpuCores READ cpuCores NOTIFY updated)
    Q_PROPERTY(double cpuUsage READ cpuUsage NOTIFY updated)
    Q_PROPERTY(QVariantList perCoreUsage READ perCoreUsage NOTIFY updated)
    Q_PROPERTY(double memoryUsage READ memoryUsage NOTIFY updated)

public:
    explicit SystemController(QObject *parent = nullptr);

    Q_INVOKABLE void refresh();

    QString hostname() const;
    QString os() const;
    QString kernel() const;
    QString uptime() const;
    QString cpuModel() const;
    int cpuCores() const;
    double cpuUsage() const;
    QVariantList perCoreUsage() const;
    double memoryUsage() const;

signals:
    void updated();

private:
    SystemInfo m_sys;
    MemoryStat m_mem;
    CPUUsage m_cpu;
};
