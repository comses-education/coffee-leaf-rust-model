# Load Packages
import Pkg
Pkg.activate(".") 
using Agents, CSV, DataFrames, Distributed, Statistics
using SpatialRust


# Run one simulation using default parameters
df = onerun_spatialrust()

# Write results
CSV.write("results/singlerun.csv", df)