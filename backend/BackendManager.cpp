#include "BackendManager.h"
#include <iostream>

void BackendManager::printToTerminal() {
    auto sys = getSystemInfo();
    auto mem = getMemoryStat();
    auto cpu = getCPUUsage();

    std::cout << "SYSTEM INFO\n";
    std::cout << "Hostname: " << sys.hostname << "\n";
    std::cout << "OS: " << sys.os << "\n";
    std::cout << "Kernel: " << sys.kernel << "\n";
    std::cout << "Arch: " << sys.arch << "\n";
    std::cout << "Uptime: " << sys.uptime << "\n\n";

    std::cout << "CPU\n";
    std::cout << "Model: " << sys.cpuModel << "\n";
    std::cout << "Cores: " << sys.cpuCores << "\n";
    std::cout << "Freq: " << sys.cpuFreq << "\n";
    std::cout << "Total Usage: " << cpu.total << "%\n";

    for (size_t i = 0; i < cpu.perCore.size(); i++) {
        std::cout << "Core " << i << ": " << cpu.perCore[i] << "%\n";
    }

    std::cout << "\nMEMORY\n";
    std::cout << "Total: " << mem.totalMB << " MB\n";
    std::cout << "Used: " << mem.usedMB << " MB\n";
    std::cout << "Free: " << mem.freeMB << " MB\n";
    std::cout << "Usage: " << mem.usagePercent << "%\n";
}
