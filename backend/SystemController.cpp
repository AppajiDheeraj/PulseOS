#include "SystemController.h"

SystemController::SystemController(QObject *parent)
    : QObject(parent) {
    refresh();
}

void SystemController::refresh() {
    m_sys = getSystemInfo();
    m_mem = getMemoryStat();
    m_cpu = getCPUUsage();
    emit updated();
}

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
        list.append(QVariant(static_cast<double>(usage)));
    }
    return list;
}

double SystemController::memoryUsage() const {
    return m_mem.usagePercent;
}
