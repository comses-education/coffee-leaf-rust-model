# SpatialRust: Coffee Leaf Rust Epidemic Model
[![fair-software.eu](https://img.shields.io/badge/fair--software.eu-%E2%97%8F%20%20%E2%97%8F%20%20%E2%97%8B%20%20%E2%97%8B%20%20%E2%97%8B-orange)](https://fair-software.eu)
[![Docker Build](https://github.com/comses-education/spatialrust-model/actions/workflows/docker-image.yml/badge.svg)](https://github.com/comses-education/spatialrust-model/actions/workflows/docker-image.yml)
[![Singularity Build](https://github.com/comses-education/spatialrust-model/actions/workflows/singularity-image.yml/badge.svg)](https://github.com/comses-education/spatialrust-model/actions/workflows/singularity-image.yml))

SpatialRust is an individual based model that simulates Coffee Leaf Rust epidemics within a coffee farm.

### Installing dependencies

Move to this project's directory and run:

```bash
$ julia install.jl
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
2. Create a host alias for your OSG account (https://github.com/comses-education/fair-osg-template#set-up-your-user-account-on-the-open-science-grid) 
3. Build a singularity image and deploy it to your OSG `/public/<username>` directory via `$ make OSG_USERNAME=<your-osg-username> deploy`
4. ssh into the OSG login node, cd into the `spatialrust` directory and submit the generated `spatialrust.submit` via `$ condor_submit spatialrust.submit`
5. this runs the ParameterRuns.jl on OSG and should drop off a `results.zip` file with the data in the same directory you submitted the job script.
