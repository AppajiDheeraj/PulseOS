#include "system_info.h"
#include "../utils/proc_reader.h"
#include <sys/utsname.h>
#include <unistd.h>
#include <fstream>
#include <sstream>

SystemInfo getSystemInfo() {
    SystemInfo info;

    // Hostname
    char host[256];
    gethostname(host, sizeof(host));
    info.hostname = host;

    // Kernel + Arch
    struct utsname uts;
    uname(&uts);
    info.kernel = uts.release;
    info.arch = uts.machine;

    // OS
    std::ifstream osFile("/etc/os-release");
    std::string line;
    while (std::getline(osFile, line)) {
        if (line.find("PRETTY_NAME=") == 0) {
            info.os = line.substr(13, line.size() - 14);
        }
    }

    // Uptime
    std::ifstream up("/proc/uptime");
    double seconds;
    up >> seconds;
    int hrs = seconds / 3600;
    int mins = (seconds - hrs * 3600) / 60;
    info.uptime = std::to_string(hrs) + "h " + std::to_string(mins) + "m";

    // CPU info
    auto cpuLines = ProcReader::readLines("/proc/cpuinfo");
    info.cpuCores = 0;

    for (auto& l : cpuLines) {
        if (l.find("model name") != std::string::npos && info.cpuModel.empty()) {
            info.cpuModel = l.substr(l.find(":") + 2);
        }
        if (l.find("cpu MHz") != std::string::npos && info.cpuFreq.empty()) {
            info.cpuFreq = l.substr(l.find(":") + 2) + " MHz";
        }
        if (l.find("processor") != std::string::npos) {
            info.cpuCores++;
        }
    }

    return info;
}
