# Load Packages
import Pkg
Pkg.activate(".") 
using Agents, CSV, DataFrames, Distributed, Statistics
using SpatialRust

# Run one simulation using default parameters
df = onerun_spatialrust()

# Create directory, in case it has not been created yet
# mkpath("results/")

# Write results
CSV.write("results/singlerun.csv", df)