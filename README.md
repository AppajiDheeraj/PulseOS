# 🌿 **PulseOS — Carbon Emission Profiling GUI for Linux**

> **A Qt-based desktop application that makes your system’s energy consumption visible, measurable, and environmentally responsible.**

![Qt](https://img.shields.io/badge/Qt-5%2F6-green)
![Linux](https://img.shields.io/badge/Platform-Linux-orange)
![Sustainable Computing](https://img.shields.io/badge/Focus-Green%20Computing-brightgreen)
![Status](https://img.shields.io/badge/Status-In%20Development-yellow)

---

## 🌍 Project Overview

Modern computing—especially AI, simulation, and high-performance workloads—consumes significant energy and contributes to global CO₂ emissions. Yet, most users have *no visibility* into how their systems consume power.

**PulseOS solves this.**

PulseOS is an interactive Linux desktop application designed to monitor, visualize, and reduce the carbon footprint of computational workloads. Inspired by the open-source library **CodeCarbon**, PulseOS transforms backend emission and system-usage tracking into an elegant **Qt-based real-time GUI experience** for developers, researchers, and system administrators.

---

## 🎯 Core Objectives

| No. | Objective                                                                        |
| --- | -------------------------------------------------------------------------------- |
| 1   | Build a Linux-based Qt desktop application for real-time energy & CO₂ monitoring |
| 2   | Provide per-process and per-thread energy breakdown                              |
| 3   | Track CPU context-switch overhead energy                                         |
| 4   | Enable monitoring of specific applications and directories                       |
| 5   | Implement **Green Mode** for low-carbon-intensity scheduling                     |
| 6   | Maintain a local emissions database and generate reports (CSV/PDF)               |
| 7   | Keep the system modular for future sustainability integrations                   |

---

## 📊 Planned Features

### 🔍 System Monitoring

* CPU usage per core
* Memory and swap usage
* Process-level and thread-level resource usage
* Context switch analysis (voluntary & non-voluntary)

### 🌱 Carbon & Energy Insights

* Real-time energy consumption estimation
* CO₂ emission calculations (region-aware)
* Historical usage trends and summaries

### 🟢 Green Mode

* Identify low-carbon-intensity periods
* Suggest optimal execution times for heavy workloads
* Reduce unnecessary background resource usage

### 📈 Reporting

* Daily and weekly emission summaries
* Export reports as CSV / PDF

---

## 🧠 Project Vision

As computational workloads grow—driven by AI, big data, and real-time systems—the energy footprint of software becomes a critical concern. Developers rarely realize how their algorithms and environments contribute to CO₂ emissions.

**PulseOS was created to make these invisible impacts visible.**

By translating low-level Linux system metrics into intuitive visualizations, PulseOS enables users to:

* Understand real-time environmental impact
* Optimize workload execution
* Adopt sustainable computing habits
* Leverage data-driven insights for research and optimization

PulseOS merges Qt’s UI capabilities with Linux’s system introspection to deliver a **practical tool** and an **educational platform** for green computing.

---

## 🛠 Tech Stack

* **Language:** C++ (Modern C++)
* **UI Framework:** Qt 5 / Qt 6 (Qt Quick + QML)
* **Platform:** Linux
* **System Metrics:** `/proc`, `/sys`, Linux kernel interfaces
* **Inspiration:** CodeCarbon

---

## 👤 Author

**Appaji Nagaraja Dheeraj**
B.Tech CSE, NITK Surathkal

---

## 🚧 Project Status

PulseOS is currently **under active development**. Core system monitoring modules are being implemented first, followed by process tracking, carbon estimation logic, and UI integration.

---

## 🟢 License

This project will be released under an open-source license (to be finalized).

> **“You can’t improve what you don’t measure — PulseOS makes emissions measurable.”**
