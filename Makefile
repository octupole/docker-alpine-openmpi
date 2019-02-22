IMAGE_NAME="alpine-openmpi"
TAG="latest"
CONTAINER_NAME="alpine-openmpi"

.PHONY: all build

all: build

build:
	docker build --tag "octupole/${IMAGE_NAME}:${TAG}" .

start:
	docker run -d --rm -it \
		--name ${CONTAINER_NAME} \
		"octupole/${IMAGE_NAME}:${TAG}" \
		tail -f /dev/null

term:
	docker exec -it ${CONTAINER_NAME} /bin/bash


stop:
	docker kill ${CONTAINER_NAME}
