#pragma once

struct MemoryStat {
    long totalMB;
    long usedMB;
    long freeMB;
    float usagePercent;
};

MemoryStat getMemoryStat();
