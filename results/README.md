# Model output files

If running via singularity, make sure to either bind mount a local directory into the results folder or specify results
in the submit script as the output directory to pick up and transfer.

e.g.,

`singularity exec --bind ./results:/code/results --pwd /code spatialrust-v1.sif bash`
