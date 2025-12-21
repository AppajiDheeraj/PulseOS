#include "cpu_stat.h"
#include "../utils/proc_reader.h"
#include <thread>
#include <sstream>
#include <vector>
#include <chrono>
#include <cstdint>
#include <optional>

struct CpuTimes {
    uint64_t busy = 0;
    uint64_t idle = 0;
};

static std::vector<CpuTimes> readCpuTimes() {
    auto lines = ProcReader::readLines("/proc/stat");
    std::vector<CpuTimes> times;
    times.reserve(32); // reasonable default

    for (const auto &l : lines) {
        // Keep only cpu and cpuN lines
        if (l.rfind("cpu", 0) != 0) {
            continue;
        }

        std::stringstream ss(l);
        std::string cpu_label;
        ss >> cpu_label;

        // Read all standard fields; missing ones stay zero
        uint64_t user = 0, nice = 0, system = 0, idle = 0, iowait = 0;
        uint64_t irq = 0, softirq = 0, steal = 0, guest = 0, guest_nice = 0;

        ss >> user >> nice >> system >> idle >> iowait
            >> irq >> softirq >> steal >> guest >> guest_nice;

        if (!ss) {
            // Parsing failed, skip this line
            continue;
        }

        // guest and guest_nice are already included in user and nice; do not add them again.
        // Busy = user + nice + system + irq + softirq + steal
        // Idle = idle + iowait
        CpuTimes ct;
        ct.busy = user + nice + system + irq + softirq + steal;
        ct.idle = idle + iowait;

        times.push_back(ct);
    }

    return times;
}

static std::optional<CPUUsage> computeCpuUsageSample(
    const std::vector<CpuTimes> &t1,
    const std::vector<CpuTimes> &t2) {
    if (t1.empty() || t2.empty() || t1.size() != t2.size()) {
        return std::nullopt;
    }

    CPUUsage usage;

    // Total (aggregate) CPU: index 0
    uint64_t total_busy_diff = t2[0].busy - t1[0].busy;
    uint64_t total_idle_diff = t2[0].idle - t1[0].idle;
    uint64_t total_diff = total_busy_diff + total_idle_diff;

    if (total_diff > 0) {
        float total_pct = 100.0f * static_cast<float>(total_busy_diff) /
                          static_cast<float>(total_diff);
        // Clamp for safety
        if (total_pct < 0.0f) total_pct = 0.0f;
        if (total_pct > 100.0f) total_pct = 100.0f;
        usage.total = total_pct;
    } else {
        usage.total = 0.0f;
    }

    // Per-core: skip aggregate at index 0
    const std::size_t num_cores = t1.size() - 1;
    usage.perCore.reserve(num_cores);

    for (std::size_t i = 0; i < num_cores; ++i) {
        const auto &c1 = t1[i + 1];
        const auto &c2 = t2[i + 1];

        uint64_t busy_diff = c2.busy - c1.busy;
        uint64_t idle_diff = c2.idle - c1.idle;
        uint64_t core_total = busy_diff + idle_diff;

        float core_pct = 0.0f;
        if (core_total > 0) {
            core_pct = 100.0f * static_cast<float>(busy_diff) /
                       static_cast<float>(core_total);
        }

        if (core_pct < 0.0f) core_pct = 0.0f;
        if (core_pct > 100.0f) core_pct = 100.0f;

        usage.perCore.push_back(core_pct);
    }

    return usage;
}

CPUUsage getCPUUsage() {
    auto t1 = readCpuTimes();
    // You can tweak this interval; 500–1000 ms is common
    std::this_thread::sleep_for(std::chrono::milliseconds(500));
    auto t2 = readCpuTimes();

    auto maybeUsage = computeCpuUsageSample(t1, t2);
    if (!maybeUsage) {
        return CPUUsage{};
    }
    return *maybeUsage;
}
