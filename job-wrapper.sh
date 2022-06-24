#!/bin/bash

set -e

JULIA_ENTRYPOINT=${1:-ParameterRuns.jl}

export TMPDIR=$_CONDOR_SCRATCH_DIR

printf "Start time: "; /bin/date -Iminutes
printf "Job running on node: "; /bin/hostname
printf "OSG site: $OSG_SITE_NAME"
printf "Job running as user: "; /usr/bin/id
printf "Command line args: $1"

julia ${JULIA_ENTRYPOINT} 2>&1

printf "${JULIA_ENTRYPOINT} execution completed: "; /bin/date -Iminutes

tar jcvf results.tar.xz results

echo "Results archived in results.tar.xz with exit code $?"
