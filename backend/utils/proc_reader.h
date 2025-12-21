#pragma once
#include <string>
#include <vector>

namespace ProcReader {

std::string readFile(const std::string& path);
std::vector<std::string> readLines(const std::string& path);

}
