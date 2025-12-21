#pragma once
#include <string>

struct SystemInfo {
    std::string hostname;
    std::string os;
    std::string kernel;
    std::string arch;
    std::string uptime;
    std::string cpuModel;
    int cpuCores;
    std::string cpuFreq;
};

SystemInfo getSystemInfo();
