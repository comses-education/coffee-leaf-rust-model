# Load Packages
using Distributed
@everywhere import Pkg
@everywhere Pkg.activate(".") 
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