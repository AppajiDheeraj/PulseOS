#include "process_model.h"

#include <QVariant>
#include <algorithm>
#include <cctype>
#include <cmath>
#include <filesystem>
#include <fstream>
#include <sstream>
#include <string>

namespace {

bool isDigits(const std::string &value) {
    return std::all_of(value.begin(), value.end(), [](unsigned char ch) { return std::isdigit(ch) != 0; });
}

void trimInPlace(std::string &value) {
    const auto begin = value.find_first_not_of(" \t");
    if (begin == std::string::npos) {
        value.clear();
        return;
    }
    const auto end = value.find_last_not_of(" \t");
    value = value.substr(begin, end - begin + 1);
}

long long readTotalJiffies() {
    std::ifstream statFile("/proc/stat");
    if (!statFile.is_open()) {
        return 0;
    }

    std::string cpuLabel;
    long long user = 0, nice = 0, system = 0, idle = 0;
    long long iowait = 0, irq = 0, softirq = 0, steal = 0;
    statFile >> cpuLabel >> user >> nice >> system >> idle >> iowait >> irq >> softirq >> steal;

    if (cpuLabel != "cpu") {
        return 0;
    }

    return user + nice + system + idle + iowait + irq + softirq + steal;
}

struct StatusData {
    std::string name;
    long memoryKb = 0;
    int threads = 0;
    long voluntaryCs = 0;
    long nonVoluntaryCs = 0;
};

StatusData readStatusFile(int pid) {
    StatusData data;
    std::ifstream statusFile("/proc/" + std::to_string(pid) + "/status");
    if (!statusFile.is_open()) {
        return data;
    }

    std::string line;
    while (std::getline(statusFile, line)) {
        const auto colonPos = line.find(':');
        if (colonPos == std::string::npos) {
            continue;
        }

        std::string key = line.substr(0, colonPos);
        std::string value = line.substr(colonPos + 1);
        trimInPlace(key);
        trimInPlace(value);

        if (key == "Name") {
            data.name = value;
        } else if (key == "VmRSS") {
            std::istringstream iss(value);
            iss >> data.memoryKb;
        } else if (key == "Threads") {
            std::istringstream iss(value);
            iss >> data.threads;
        } else if (key == "voluntary_ctxt_switches") {
            std::istringstream iss(value);
            iss >> data.voluntaryCs;
        } else if (key == "nonvoluntary_ctxt_switches") {
            std::istringstream iss(value);
            iss >> data.nonVoluntaryCs;
        }
    }

    return data;
}

struct StatData {
    long long totalTime = 0;
};

bool readStatFile(int pid, StatData &out) {
    std::ifstream statFile("/proc/" + std::to_string(pid) + "/stat");
    if (!statFile.is_open()) {
        return false;
    }
    std::string line;
    std::getline(statFile, line);
    if (line.empty()) {
        return false;
    }

    const auto closePos = line.rfind(')');
    if (closePos == std::string::npos) {
        return false;
    }

    std::string after = line.substr(closePos + 2);
    std::istringstream iss(after);

    char state;
    iss >> state;
    long long ppid = 0, pgrp = 0, session = 0, tty_nr = 0, tpgid = 0;
    long long flags = 0;
    long long minflt = 0, cminflt = 0, majflt = 0, cmajflt = 0;
    long long utime = 0, stime = 0, cutime = 0, cstime = 0;
    long long priority = 0, nice = 0, num_threads = 0, itrealvalue = 0;
    long long starttime = 0, vsize = 0, rss = 0;

    iss >> ppid >> pgrp >> session >> tty_nr >> tpgid >> flags
        >> minflt >> cminflt >> majflt >> cmajflt
        >> utime >> stime >> cutime >> cstime
        >> priority >> nice >> num_threads >> itrealvalue
        >> starttime >> vsize >> rss;

    if (!iss) {
        return false;
    }

    out.totalTime = utime + stime;
    return true;
}

} // namespace

ProcessModel *ProcessModel::instance() {
    static ProcessModel model;
    return &model;
}

ProcessModel::ProcessModel(QObject *parent)
    : QAbstractListModel(parent) {}

int ProcessModel::rowCount(const QModelIndex &parent) const {
    if (parent.isValid()) {
        return 0;
    }

    const std::size_t offset = static_cast<std::size_t>(m_page) * static_cast<std::size_t>(m_pageSize);
    if (offset >= m_processes.size()) {
        return 0;
    }

    const std::size_t remaining = m_processes.size() - offset;
    const std::size_t count = std::min<std::size_t>(remaining, static_cast<std::size_t>(m_pageSize));
    return static_cast<int>(count);
}

QVariant ProcessModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid()) {
        return {};
    }

    const int offset = m_page * m_pageSize + index.row();
    if (offset < 0 || static_cast<std::size_t>(offset) >= m_processes.size()) {
        return {};
    }

    const ProcessEntry &entry = m_processes[offset];

    switch (role) {
    case PidRole:
        return entry.pid;
    case NameRole:
        return entry.name;
    case CpuRole:
        return entry.cpuPercent;
    case MemoryRole:
        return entry.memoryMb;
    case ThreadsRole:
        return entry.threads;
    case VoluntaryCsRole:
        return static_cast<qlonglong>(entry.voluntaryCs);
    case NonVoluntaryCsRole:
        return static_cast<qlonglong>(entry.nonVoluntaryCs);
    default:
        return {};
    }
}

QHash<int, QByteArray> ProcessModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[PidRole] = "pid";
    roles[NameRole] = "name";
    roles[CpuRole] = "cpu";
    roles[MemoryRole] = "memory";
    roles[ThreadsRole] = "threads";
    roles[VoluntaryCsRole] = "volCS";
    roles[NonVoluntaryCsRole] = "nonVolCS";
    return roles;
}

int ProcessModel::page() const {
    return m_page;
}

int ProcessModel::totalPages() const {
    if (m_processes.empty()) {
        return 1;
    }
    return (static_cast<int>(m_processes.size()) + m_pageSize - 1) / m_pageSize;
}

int ProcessModel::pageSize() const {
    return m_pageSize;
}

void ProcessModel::setPageSize(int value) {
    if (value <= 0 || value == m_pageSize) {
        return;
    }
    m_pageSize = value;
    if (m_page >= totalPages()) {
        setPageInternal(totalPages() - 1);
    }
    emit pageSizeChanged();
    emit totalPagesChanged();
    if (rowCount() > 0) {
        emit dataChanged(index(0, 0), index(rowCount() - 1, 0));
    }
}

void ProcessModel::refresh() {
    long long currTotalJiffies = 0;
    std::unordered_map<int, long long> currTimes;
    auto processes = collectProcesses(currTotalJiffies, currTimes);

    const long long deltaTotal = (m_prevTotalJiffies > 0 && currTotalJiffies > m_prevTotalJiffies)
                                     ? currTotalJiffies - m_prevTotalJiffies
                                     : 0;

    if (deltaTotal > 0) {
        for (auto &entry : processes) {
            const auto prevIt = m_prevProcTimes.find(entry.pid);
            const auto currIt = currTimes.find(entry.pid);
            if (prevIt != m_prevProcTimes.end() && currIt != currTimes.end()) {
                const long long deltaProc = currIt->second - prevIt->second;
                if (deltaProc >= 0) {
                    const double cpu = static_cast<double>(deltaProc) * 100.0 / static_cast<double>(deltaTotal);
                    entry.cpuPercent = cpu < 0.0 ? 0.0 : cpu;
                }
            }
        }
    }

    std::sort(processes.begin(), processes.end(), [](const ProcessEntry &lhs, const ProcessEntry &rhs) {
        if (std::fabs(lhs.cpuPercent - rhs.cpuPercent) > 0.01) {
            return lhs.cpuPercent > rhs.cpuPercent;
        }
        return lhs.memoryMb > rhs.memoryMb;
    });

    beginResetModel();
    m_processes = std::move(processes);
    endResetModel();

    m_prevProcTimes = std::move(currTimes);
    m_prevTotalJiffies = currTotalJiffies;

    setPageInternal(std::min(m_page, totalPages() - 1));
    emit totalPagesChanged();
}

void ProcessModel::nextPage() {
    setPageInternal(std::min(page() + 1, totalPages() - 1));
}

void ProcessModel::prevPage() {
    setPageInternal(std::max(page() - 1, 0));
}

void ProcessModel::gotoPage(int targetPage) {
    if (targetPage < 0) {
        targetPage = 0;
    }
    setPageInternal(std::min(targetPage, totalPages() - 1));
}

void ProcessModel::setPageInternal(int newPage) {
    if (newPage < 0) {
        newPage = 0;
    }

    const int maxPage = std::max(totalPages() - 1, 0);
    if (newPage > maxPage) {
        newPage = maxPage;
    }

    if (newPage == m_page) {
        return;
    }

    m_page = newPage;
    emit pageChanged();

    const int rows = rowCount();
    if (rows > 0) {
        emit dataChanged(index(0, 0), index(rows - 1, 0));
    }
}

std::vector<ProcessModel::ProcessEntry> ProcessModel::collectProcesses(
    long long &currTotalJiffies,
    std::unordered_map<int, long long> &currTimes) const {
    currTotalJiffies = readTotalJiffies();
    std::vector<ProcessEntry> entries;
    entries.reserve(256);

    for (const auto &dirEntry : std::filesystem::directory_iterator(
             "/proc", std::filesystem::directory_options::skip_permission_denied)) {
        if (!dirEntry.is_directory()) {
            continue;
        }

        const std::string pidStr = dirEntry.path().filename().string();
        if (!isDigits(pidStr)) {
            continue;
        }

        int pid = 0;
        try {
            pid = std::stoi(pidStr);
        } catch (...) {
            continue;
        }

        StatData statData;
        if (!readStatFile(pid, statData)) {
            continue;
        }

        StatusData statusData = readStatusFile(pid);
        if (statusData.name.empty()) {
            continue;
        }

        ProcessEntry entry;
        entry.pid = pid;
        entry.name = QString::fromStdString(statusData.name);
        entry.threads = statusData.threads;
        entry.voluntaryCs = statusData.voluntaryCs;
        entry.nonVoluntaryCs = statusData.nonVoluntaryCs;
        entry.memoryMb = static_cast<double>(statusData.memoryKb) / 1024.0;

        currTimes.emplace(pid, statData.totalTime);
        entries.push_back(entry);
    }

    return entries;
}
