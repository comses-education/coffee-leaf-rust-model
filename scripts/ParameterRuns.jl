# Load Packages
import Pkg
Pkg.activate(".") 
using Agents, CSV, DataFrames, Distributed, Statistics
using SpatialRust

# Define parameter options
mean_temp = collect([20.0:0.5:25.0]) # mean temperature values: min:step:max
rain_prob = collect([0.4:0.1:0.9]) # rain probability values
wind_prob = collect([0.1:0.1:0.9]) # wind probability values
reps = 5 # number of replicates per parameter combination

# Create dictionary with parameter conditions
conds = Dict(
    :mean_temp => mean_temp,
    :rain_prob => rain_prob,
    :wind_prob => wind_prob,
    :reps => collect(1:reps),
    
    # other settings
    :shade_d => [6],
    :barrier_arr => (1,1,0,0),
    :target_shade => 0.5,
    :prune_period => 365,
    :fungicide_period => 365,
    :barrier_rows => 2,
    :shade_g_rate => 0.05,
    :steps => 1095,
    :rust_gr => 1.63738,
    :cof_gr => 0.393961,
    :spore_pct => 0.821479,
    :fruit_load => 0.597133,
    :uv_inact => 0.166768,
    :rain_washoff => 0.23116,
    :rain_distance => 0.80621,
    :wind_distance => 3.29275,
    :exhaustion => 0.17458
)

# Run simulations (in parallel)
results = shading_experiment(conds)

# Create directory, in case it has not been created yet
mkpath("results/")

# Write results
CSV.write("results/parameterexp.csv", results)
