# Load Packages
using Distributed
@everywhere using DrWatson
@everywhere @quickactivate "SpatialRust"
@everywhere begin
using Agents, CSV, DataFrames, Distributed, Statistics
using SpatialRust
end

# Run one simulation using default parameters
df = onerun_spatialrust()

# Create directory, in case it has not been created yet
mkpath("results/")

# Write results
CSV.write("results/singlerun.csv", df)