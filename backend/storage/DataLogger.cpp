#include "DataLogger.h"

#include <QStandardPaths>
#include <QDir>

// ✅ DEFAULT CONSTRUCTOR
DataLogger::DataLogger() {
    // Empty - database not initialized yet
}

// ✅ PARAMETERIZED CONSTRUCTOR
DataLogger::DataLogger(const QString& dbPath) {
    if (QSqlDatabase::contains("carbonqt_connection")) {
        m_db = QSqlDatabase::database("carbonqt_connection");
    } else {
        m_db = QSqlDatabase::addDatabase("QSQLITE", "carbonqt_connection");
        m_db.setDatabaseName(dbPath);
    }
}

// ✅ INIT - Creates tables
bool DataLogger::init() {
    qDebug() << "=== DataLogger::init() CALLED ===";
    qDebug() << "DB path:" << m_db.databaseName();
    qDebug() << "DB open state before open():" << m_db.isOpen();

    if (!m_db.open()) {
        qDebug() << "DB open failed:" << m_db.lastError();
        return false;
    }

    qDebug() << "DB open OK";

    QSqlQuery q(m_db);

    // Create system_metrics table
    if (!q.exec(R"(
        CREATE TABLE IF NOT EXISTS system_metrics (
            timestamp INTEGER,
            cpu_percent REAL,
            mem_mb REAL,
            gpu_percent REAL,
            cpu_watts REAL,
            gpu_watts REAL,
            ram_watts REAL,
            energy_joules REAL,
            co2e_kg REAL
        )
    )")) {
        qDebug() << "FAILED system_metrics:" << q.lastError();
    }

    // Create process_metrics table
    if (!q.exec(R"(
        CREATE TABLE IF NOT EXISTS process_metrics (
            timestamp INTEGER,
            pid INTEGER,
            name TEXT,
            cpu_percent REAL,
            mem_mb REAL,
            threads INTEGER,
            voluntary_cs INTEGER,
            nonvoluntary_cs INTEGER,
            cpu_watts REAL,
            ram_watts REAL,
            energy_joules REAL,
            co2e_kg REAL
        )
    )")) {
        qDebug() << "FAILED process_metrics:" << q.lastError();
    }

    // Create config table
    if (!q.exec(R"(
        CREATE TABLE IF NOT EXISTS config (
            key TEXT PRIMARY KEY,
            value TEXT NOT NULL
        )
    )")) {
        qDebug() << "FAILED config:" << q.lastError();
    }

    qDebug() << "=== DataLogger::init() DONE ===";
    return true;
}

// ✅ LOG SYSTEM METRICS
bool DataLogger::logSystem(const SystemRecord& r) {
    QSqlQuery q(m_db);
    q.prepare(R"(
        INSERT INTO system_metrics
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    )");

    q.addBindValue(r.timestamp);
    q.addBindValue(r.cpu_percent);
    q.addBindValue(r.mem_mb);
    q.addBindValue(r.gpu_percent);
    q.addBindValue(r.cpu_watts);
    q.addBindValue(r.gpu_watts);
    q.addBindValue(r.ram_watts);
    q.addBindValue(r.energy_joules);
    q.addBindValue(r.co2e_kg);

    return q.exec();
}

// ✅ LOG PROCESS METRICS
bool DataLogger::logProcess(const ProcessRecord& r) {
    QSqlQuery q(m_db);
    q.prepare(R"(
        INSERT INTO process_metrics
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    )");

    q.addBindValue(r.timestamp);
    q.addBindValue(r.pid);
    q.addBindValue(r.name);
    q.addBindValue(r.cpu_percent);
    q.addBindValue(r.mem_mb);
    q.addBindValue(r.threads);
    q.addBindValue(r.voluntary_cs);
    q.addBindValue(r.nonvoluntary_cs);
    q.addBindValue(r.cpu_watts);
    q.addBindValue(r.ram_watts);
    q.addBindValue(r.energy_joules);
    q.addBindValue(r.co2e_kg);

    return q.exec();
}

// ✅ SET CONFIG
bool DataLogger::setConfig(const QString& key, const QString& value) {
    QSqlQuery q(m_db);
    q.prepare(R"(
        INSERT OR REPLACE INTO config (key, value)
        VALUES (?, ?)
    )");

    q.addBindValue(key);
    q.addBindValue(value);

    return q.exec();
}

// ✅ GET CONFIG
QString DataLogger::getConfig(const QString& key) const {
    QSqlQuery q(m_db);
    q.prepare("SELECT value FROM config WHERE key = ?");
    q.addBindValue(key);

    if (q.exec() && q.next()) {
        return q.value(0).toString();
    }

    return {};
}
