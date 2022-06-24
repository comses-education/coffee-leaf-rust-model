# SpatialRust

SpatialRust is an individual based model that simulates Coffee Leaf Rust epidemics within a coffee farm.

### Installing dependencies

Move to this project's directory and run:

```julia
using Pkg
Pkg.activate(".")
Pkg.instantiate()
```

### Running the model

There are two script files available. You can run a single simulation using a fixed parameter set using `scripts/OneRun.jl` as follows:

```bash
$ julia scripts/OneRun.jl
```

Results from this single run will be saved in a `results` folder as `singlerun.csv`.

The second option, `scripts/ParameterRuns.jl`, lets you run a parameter exploration experiment. The default setup of this experiment will run 2700 simulations. To modify the parameter values to be evaluated or the replicates for each combination, open `scripts/ParameterRuns.jl` and edit lines 11 to 14. Like the first option, you can run the script from bash:

```bash
$ julia scripts/ParameterRuns.jl
```

Results from this experiment will be saved in a `results` folder as `parameterexp.csv`. Both scripts take care of creating the `results` folder if it has not been created yet.

### Running on Open Science Grid
1. Establish an account on Open Science Grid
   https://osg-htc.org/research-facilitation/accounts-and-projects/general/index.html
2. Build a singularity image from this file via `./build.sh <your-osg-username>`
3. Copy the singularity image e.g., `spatialrust-v1.sif` to your OSG `/public/<username>` directory
