#pragma once

struct EnergyMetrics {
    double cpu_watts = 0.0;
    double ram_watts = 0.0;
    double total_watts = 0.0;
    double energy_joules = 0.0;
    double co2e_kg = 0.0;
};

struct PowerModel {
    double cpu_idle_watts;
    double cpu_watts_per_percent;

    double ram_idle_watts;
    double ram_watts_per_gb;

    double carbon_intensity; // kg CO2 / kWh
};

class EnergyEstimator {
public:
    explicit EnergyEstimator(const PowerModel& model);

    EnergyMetrics estimate(
        double cpu_percent,
        double ram_used_gb,
        double interval_sec
        ) const;

private:
    PowerModel model_;
};
