# customize via `% make build OSG_USERNAME=<your-osg-username>` e.g., `% make build OSG_USERNAME=alee`
# customizable variables via the command line include:
# OSG_USERNAME, OSG_SUBMIT_FILENAME, CURRENT_VERSION
#
OSG_USERNAME := ${USER}
OSG_MODEL_NAME := spatialrust
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
	SINGULARITY_IMAGE_NAME=${SINGULARITY_IMAGE_NAME} OSG_USERNAME=${OSG_USERNAME} envsubst < submit.template > $(OSG_SUBMIT_FILENAME)

build: $(SINGULARITY_DEF) $(SINGULARITY_IMAGE_NAME) $(OSG_SUBMIT_FILENAME)
	docker build -t comses/${OSG_MODEL_NAME}:${CURRENT_VERSION} .

.PHONY: clean deploy

clean:
	rm -f ${SINGULARITY_IMAGE_NAME} ${OSG_SUBMIT_FILENAME} *~

deploy: build
	echo "Attempting to deploy to osg:/public/${OSG_USERNAME}"
	rsync -avzP ${SINGULARITY_IMAGE_NAME}  osg:/public/${OSG_USERNAME}
	rsync -avzP ${OSG_SUBMIT_FILENAME} ${OSG_JOB_SCRIPT} osg:.
	rsync -avzP scripts/ osg:${OSG_MODEL_NAME}/
