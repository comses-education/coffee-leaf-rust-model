# Load Packages
import Pkg
Pkg.activate("/code/.") 
using CSV, DataFrames, DrWatson, Statistics, SpatialRust

# Define parameter options and # of steps
mean_temp = collect(19.0:0.5:24.0) # mean temperature values: min:step:max
rain_prob = collect(0.3:0.2:0.9) # rain probability values
wind_prob = collect(0.3:0.2:0.9) # wind probability values
reps = 5 # number of replicates per parameter combination
years = 2

# Define which parameter columns are included in output dataframe and their order
parsorder = [:rep, :wind_prob, :rain_prob, :mean_temp]

# Create dictionary with parameter conditions
conds = Dict(
    :mean_temp => mean_temp,
    :rain_prob => rain_prob,
    :wind_prob => wind_prob,
    :rep => collect(1:reps),
    :steps => years * 365,
)

# Generate dataframe with all the parameter permutations
pars = DataFrame(dict_list(conds))
# Run simulations
results = parameters_experiment(pars, parsorder)

# Write results
mkpath("/srv/results")
CSV.write("/srv/results/parameterexp.csv", results)
