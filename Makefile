# customize via `% make build OSG_USERNAME=<your-osg-username>` e.g., `% make build OSG_USERNAME=amelie`

OSG_USERNAME := allen.lee
OSG_SUBMIT_NODE := osg
OSG_OSDF_PATH := /ospool/PROTECTED
MODEL_NAME := spatialrust
ENTRYPOINT_SCRIPT_EXECUTABLE := julia
ENTRYPOINT_SCRIPT := ParameterRuns.jl
OSG_OUTPUT_DIR := results
OSG_SUBMIT_TEMPLATE := scripts/submit.template
OSG_SUBMIT_FILENAME := scripts/${MODEL_NAME}.sub
OSG_JOB_SCRIPT := job-wrapper.sh
OUTPUT_FILES := results

CONTAINER_DEF = container.def
CURRENT_VERSION = v1
CONTAINER_IMAGE_NAME = ${MODEL_NAME}-${CURRENT_VERSION}.sif

all: build


$(CONTAINER_IMAGE_NAME):
	apptainer build --fakeroot ${CONTAINER_IMAGE_NAME} ${CONTAINER_DEF}

$(OSG_SUBMIT_FILENAME): $(OSG_SUBMIT_TEMPLATE)
	CONTAINER_IMAGE_NAME=${CONTAINER_IMAGE_NAME} \
	OSG_USERNAME=${OSG_USERNAME} \
	ENTRYPOINT_SCRIPT_EXECUTABLE=${ENTRYPOINT_SCRIPT_EXECUTABLE} \
	ENTRYPOINT_SCRIPT=${ENTRYPOINT_SCRIPT} \
	envsubst < ${OSG_SUBMIT_TEMPLATE} > ${OSG_SUBMIT_FILENAME}

build: $(CONTAINER_DEF) $(CONTAINER_IMAGE_NAME) $(OSG_SUBMIT_FILENAME)
	docker build -t comses/${MODEL_NAME}:${CURRENT_VERSION} .

.PHONY: clean deploy apptainer-build
apptainer-build: $(CONTAINER_IMAGE_NAME)

clean:
	rm -f ${CONTAINER_IMAGE_NAME} ${OSG_SUBMIT_FILENAME} ${OSG_OUTPUT_DIR} *~

deploy: build
	@echo "IMPORTANT: This command assumes you have created an ssh alias in your ~/.ssh/config named '${OSG_SUBMIT_NODE}' that connects to your OSG connect node"
	@echo "Copying singularity image to ${OSG_SUBMIT_NODE}:${OSG_OSDF_PATH}/${OSG_USERNAME}"
	rsync -avzP ${CONTAINER_IMAGE_NAME} ${OSG_SUBMIT_NODE}:${OSG_OSDF_PATH}/${OSG_USERNAME}
	@echo "Creating ${MODEL_NAME} folder in /home/${OSG_USERNAME}"
	ssh ${OSG_USERNAME}@${OSG_SUBMIT_NODE} mkdir -p ${MODEL_NAME}
	@echo "Copying submit filename, job script, and entrypoint scripts to /home/${OSG_USERNAME}/${MODEL_NAME}"
	rsync -avzP scripts/ ${OSG_SUBMIT_NODE}:${MODEL_NAME}/
