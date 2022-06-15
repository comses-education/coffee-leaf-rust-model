#!/bin/bash

# build singularity image and submit script for OSG execution

SINGULARITY_DEF="Singularity.def"
CURRENT_VERSION="v1"
SINGULARITY_USERNAME="${1:-USER}"

# convert Dockerfile to singularity recipe
spython recipe Dockerfile ${SINGULARITY_DEF}

echo "SINGULARITY USERNAME: ${SINGULARITY_USERNAME}"

# explicitly version singularity images due to aggressive filesystem caching
# that can cause OSG nodes to run different versions of the container
export SINGULARITY_IMAGE_NAME="spatialrust-${CURRENT_VERSION}.sif"
export SINGULARITY_USERNAME

envsubst < submit.template > submit

singularity build --fakeroot ${SINGULARITY_IMAGE_NAME} ${SINGULARITY_DEF}
