#include "SystemController.h"

#include <QStandardPaths>
#include <QDir>
#include <QDateTime>

// --------------------------------------------------
// Constructor
// --------------------------------------------------

SystemController::SystemController(QObject *parent)
    : QObject(parent),
    m_energyEstimator(PowerModel{
        5.0,   // CPU idle watts
        0.4,   // CPU watts per %
        1.0,   // RAM idle watts
        0.3,   // RAM watts per GB
        0.7    // Carbon intensity (kg CO2 / kWh)
    }),
    m_logger()
{
    // Setup data directory
    const QString dataDir =
        QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);

    // ✅ Create directory FIRST if it doesn't exist
    QDir().mkpath(dataDir);

    // ✅ Initialize logger with proper database path
    m_logger = DataLogger(dataDir + "/carbonqt.db");

    // ✅ Initialize database tables
    if (!m_logger.init()) {
        qWarning() << "Failed to initialize database!";
    }

    // Initial system refresh
    refresh();
}

// --------------------------------------------------
// Refresh
// --------------------------------------------------

void SystemController::refresh() {
    m_sys = getSystemInfo();
    m_mem = getMemoryStat();
    m_cpu = getCPUUsage();

    constexpr double samplingIntervalSec = 0.5;
    const double ramUsedGb = m_mem.usedMB / 1024.0;

    m_energy = m_energyEstimator.estimate(
        m_cpu.total,
        ramUsedGb,
        samplingIntervalSec
        );

    // -------- DB LOGGING --------
    SystemRecord record;
    record.timestamp = QDateTime::currentSecsSinceEpoch();
    record.cpu_percent = m_cpu.total;
    record.mem_mb = m_mem.usedMB;
    record.cpu_watts = m_energy.cpu_watts;
    record.ram_watts = m_energy.ram_watts;
    record.energy_joules = m_energy.energy_joules;
    record.co2e_kg = m_energy.co2e_kg;

    m_logger.logSystem(record);

    // ----------------------------
    emit updated();
}

// --------------------------------------------------
// Q_PROPERTY getters (ALL MUST BE const)
// --------------------------------------------------

QString SystemController::hostname() const {
    return QString::fromStdString(m_sys.hostname);
}

QString SystemController::os() const {
    return QString::fromStdString(m_sys.os);
}

QString SystemController::kernel() const {
    return QString::fromStdString(m_sys.kernel);
}

QString SystemController::uptime() const {
    return QString::fromStdString(m_sys.uptime);
}

QString SystemController::cpuModel() const {
    return QString::fromStdString(m_sys.cpuModel);
}

int SystemController::cpuCores() const {
    return m_sys.cpuCores;
}

double SystemController::cpuUsage() const {
    return m_cpu.total;
}

QVariantList SystemController::perCoreUsage() const {
    QVariantList list;
    for (float usage : m_cpu.perCore) {
        list.append(static_cast<double>(usage));
    }
    return list;
}

double SystemController::memoryUsage() const {
    return m_mem.usagePercent;
}

double SystemController::cpuWatts() const {
    return m_energy.cpu_watts;
}

double SystemController::ramWatts() const {
    return m_energy.ram_watts;
}

double SystemController::energyJoules() const {
    return m_energy.energy_joules;
}

double SystemController::co2e() const {
    return m_energy.co2e_kg;
}
