# customize via `% make build OSG_USERNAME=<your-osg-username>` e.g., `% make build OSG_USERNAME=alee`
# customizable variables via the command line include:
# OSG_USERNAME, OSG_SUBMIT_FILENAME, CURRENT_VERSION
#
OSG_USERNAME := ${USER}
OSG_MODEL_NAME := spatialrust
OSG_MODEL_ENTRYPOINT_SCRIPT := ParameterRuns.jl
OSG_MODEL_OUTPUT_FILES := results.tar.xz
OSG_SUBMIT_FILENAME := ${OSG_MODEL_NAME}.submit
OSG_JOB_SCRIPT := job-wrapper.sh

SINGULARITY_DEF = Singularity.def
CURRENT_VERSION = v1
SINGULARITY_IMAGE_NAME = ${OSG_MODEL_NAME}-${CURRENT_VERSION}.sif

all: build

$(SINGULARITY_IMAGE_NAME):
	singularity build --fakeroot ${SINGULARITY_IMAGE_NAME} ${SINGULARITY_DEF}

$(OSG_SUBMIT_FILENAME): submit.template
	echo "OSG USERNAME: ${SINGULARITY_USERNAME}"
	echo "SINGULARITY_IMAGE_NAME: ${SINGULARITY_IMAGE_NAME}"
	SINGULARITY_IMAGE_NAME=${SINGULARITY_IMAGE_NAME} \
	OSG_USERNAME=${OSG_USERNAME} \
	OSG_MODEL_ENTRYPOINT_SCRIPT=${OSG_MODEL_ENTRYPOINT_SCRIPT} \
	OSG_MODEL_OUTPUT_FILES=${OSG_MODEL_OUTPUT_FILES} \
	envsubst < submit.template > ${OSG_SUBMIT_FILENAME}

build: $(SINGULARITY_DEF) $(SINGULARITY_IMAGE_NAME) $(OSG_SUBMIT_FILENAME)
	docker build -t comses/${OSG_MODEL_NAME}:${CURRENT_VERSION} .

.PHONY: clean deploy

clean:
	rm -f ${SINGULARITY_IMAGE_NAME} ${OSG_SUBMIT_FILENAME} *~

deploy: build
	echo "IMPORTANT: This command assumes you have created an ssh alias in your ~/.ssh/config named 'osg' that connects to your OSG connect node"
	echo "Copying singularity image to osg:/public/${OSG_USERNAME}"
	rsync -avzP ${SINGULARITY_IMAGE_NAME} osg:/public/${OSG_USERNAME}
	echo "Creating ${OSG_MODEL_NAME} folder in /home/${OSG_USERNAME}"
	ssh ${OSG_USERNAME}@osg mkdir -p ${OSG_MODEL_NAME}
	echo "Copying submit filename, job script, and entrypoint scripts to /home/${OSG_USERNAME}/${OSG_MODEL_NAME}"
	rsync -avzP ${OSG_SUBMIT_FILENAME} ${OSG_JOB_SCRIPT} scripts/ osg:${OSG_MODEL_NAME}/
