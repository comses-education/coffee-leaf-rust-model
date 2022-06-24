# customize via `% make build OSG_USERNAME=<your-osg-username>` e.g., `% make build OSG_USERNAME=alee`
# customizable variables via the command line include:
# OSG_USERNAME, OSG_SUBMIT_FILENAME, CURRENT_VERSION
#
OSG_USERNAME := ${USER}
OSG_SUBMIT_FILENAME := spatialrust.submit

SINGULARITY_DEF = Singularity.def
CURRENT_VERSION = v1
SINGULARITY_IMAGE_NAME = spatialrust-${CURRENT_VERSION}.sif

all: build

$(SINGULARITY_IMAGE_NAME):
	singularity build --fakeroot ${SINGULARITY_IMAGE_NAME} ${SINGULARITY_DEF}

$(OSG_SUBMIT_FILENAME):
	echo "SINGULARITY USERNAME: ${SINGULARITY_USERNAME}"
	export SINGULARITY_IMAGE_NAME
	export OSG_USERNAME
	envsubst < submit.template > $(OSG_SUBMIT_FILENAME)

build: $(SINGULARITY_DEF) $(SINGULARITY_IMAGE_NAME) $(OSG_SUBMIT_FILENAME)
	docker build -t comses/spatialrust:${CURRENT_VERSION} .

.PHONY: clean deploy

clean:
	rm -f ${SINGULARITY_IMAGE_NAME} ${OSG_SUBMIT_FILENAME} *~

deploy:
	echo "Attempting to deploy to osg:/public/${OSG_USERNAME}"
	rsync -avzP ${SINGULARITY_IMAGE_NAME} ${OSG_SUBMIT_FILENAME} osg:/public/${OSG_USERNAME}

