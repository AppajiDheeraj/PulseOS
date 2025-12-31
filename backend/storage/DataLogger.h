#pragma once

#include <QString>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

// ---------------- System ----------------
struct SystemRecord {
    qint64 timestamp;
    double cpu_percent;
    double mem_mb;
    double gpu_percent; // 0 for now
    double cpu_watts;
    double gpu_watts; // 0 for now
    double ram_watts;
    double energy_joules;
    double co2e_kg;
};

// ---------------- Process ----------------
struct ProcessRecord {
    qint64 timestamp;
    int pid;
    QString name;
    double cpu_percent;
    double mem_mb;
    int threads;
    qint64 voluntary_cs;
    qint64 nonvoluntary_cs;
    double cpu_watts;
    double ram_watts;
    double energy_joules;
    double co2e_kg;
};

class DataLogger {
public:
    DataLogger();  // ✅ DEFAULT CONSTRUCTOR
    explicit DataLogger(const QString& dbPath);  // ✅ PARAMETERIZED CONSTRUCTOR

    bool init();
    bool logSystem(const SystemRecord& record);
    bool logProcess(const ProcessRecord& record);
    bool setConfig(const QString& key, const QString& value);
    QString getConfig(const QString& key) const;

private:
    QSqlDatabase m_db;
};
