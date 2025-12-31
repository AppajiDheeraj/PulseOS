#include "EnergyEstimator.h"

EnergyEstimator::EnergyEstimator(const PowerModel& model)
    : model_(model) {}

EnergyMetrics EnergyEstimator::estimate(
    double cpu_percent,
    double ram_used_gb,
    double interval_sec
    ) const {
    EnergyMetrics out;

    // CPU power
    out.cpu_watts =
        model_.cpu_idle_watts +
        cpu_percent * model_.cpu_watts_per_percent;

    // RAM power
    out.ram_watts =
        model_.ram_idle_watts +
        ram_used_gb * model_.ram_watts_per_gb;

    out.total_watts = out.cpu_watts + out.ram_watts;

    // Energy = Power × Time
    out.energy_joules = out.total_watts * interval_sec;

    // Convert J → kWh
    const double energy_kwh = out.energy_joules / 3'600'000.0;

    // CO₂
    out.co2e_kg = energy_kwh * model_.carbon_intensity;

    return out;
}
