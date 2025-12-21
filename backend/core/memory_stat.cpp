#include "memory_stat.h"
#include "../utils/proc_reader.h"
#include <sstream>

MemoryStat getMemoryStat() {
    MemoryStat mem{};
    auto lines = ProcReader::readLines("/proc/meminfo");

    long total = 0, free = 0, buffers = 0, cached = 0;

    for (auto& l : lines) {
        std::stringstream ss(l);
        std::string key;
        long value;
        ss >> key >> value;

        if (key == "MemTotal:") total = value;
        if (key == "MemFree:") free = value;
        if (key == "Buffers:") buffers = value;
        if (key == "Cached:") cached = value;
    }

    long used = total - free - buffers - cached;

    mem.totalMB = total / 1024;
    mem.usedMB = used / 1024;
    mem.freeMB = free / 1024;
    mem.usagePercent = (float)used / total * 100.0f;

    return mem;
}
