#pragma once

#include <QObject>
#include <QString>
#include <QVariantList>

#include "core/system_info.h"
#include "core/memory_stat.h"
#include "core/cpu_stat.h"
#include "energy/EnergyEstimator.h"
#include "storage/DataLogger.h"

class SystemController : public QObject {
    Q_OBJECT

    // -------- System Info --------
    Q_PROPERTY(QString hostname READ hostname NOTIFY updated)
    Q_PROPERTY(QString os READ os NOTIFY updated)
    Q_PROPERTY(QString kernel READ kernel NOTIFY updated)
    Q_PROPERTY(QString uptime READ uptime NOTIFY updated)
    Q_PROPERTY(QString cpuModel READ cpuModel NOTIFY updated)
    Q_PROPERTY(int cpuCores READ cpuCores NOTIFY updated)

    // -------- Usage --------
    Q_PROPERTY(double cpuUsage READ cpuUsage NOTIFY updated)
    Q_PROPERTY(QVariantList perCoreUsage READ perCoreUsage NOTIFY updated)
    Q_PROPERTY(double memoryUsage READ memoryUsage NOTIFY updated)

    // -------- Energy --------
    Q_PROPERTY(double cpuWatts READ cpuWatts NOTIFY updated)
    Q_PROPERTY(double ramWatts READ ramWatts NOTIFY updated)
    Q_PROPERTY(double energyJoules READ energyJoules NOTIFY updated)
    Q_PROPERTY(double co2e READ co2e NOTIFY updated)

public:
    explicit SystemController(QObject *parent = nullptr);

    Q_INVOKABLE void refresh();

    // -------- Getters (MUST be const) --------
    QString hostname() const;
    QString os() const;
    QString kernel() const;
    QString uptime() const;
    QString cpuModel() const;
    int cpuCores() const;

    double cpuUsage() const;
    QVariantList perCoreUsage() const;
    double memoryUsage() const;

    double cpuWatts() const;
    double ramWatts() const;
    double energyJoules() const;
    double co2e() const;

signals:
    void updated();

private:
    SystemInfo m_sys;
    MemoryStat m_mem;
    CPUUsage m_cpu;

    EnergyEstimator m_energyEstimator;
    EnergyMetrics m_energy;

    DataLogger m_logger;
};
