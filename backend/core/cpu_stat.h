#pragma once
#include <vector>

struct CPUUsage {
    float total;
    std::vector<float> perCore;
};

CPUUsage getCPUUsage();
