# Load Packages
import Pkg
Pkg.activate(".") 
using Agents, CSV, DataFrames, Distributed, Statistics
using SpatialRust

# Run one simulation using default parameters
df = onerun_spatialrust()

# Write results
mkpath("/srv/results")
CSV.write("/srv/results/singlerun.csv", df)
