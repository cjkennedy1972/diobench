DOCKER_FILE=Dockerfile
IMAGE_NAME=diobench
IMAGE_TAG=latest
RUN_NAME=diob


all: build-image

build-image:
	docker build -f $(DOCKER_FILE) -t $(IMAGE_NAME) .

run: 
	docker run -tid --name $(RUN_NAME) $(IMAGE_NAME)

# do a sample run of 4 I/O of 4K each
dio:
	docker exec -ti $(RUN_NAME) /bin/diobench --hello /data 4 4096

# get a shell to the container in the background
shell:
	docker exec -ti $(RUN_NAME) /bin/bash

show:
	docker images $(IMAGE_NAME)

stop:
	- docker stop $(RUN_NAME)
	- docker rm $(RUN_NAME)

# create a tarball of the docker image so it can be manually pushed around
tar-image:
	- docker save $(IMAGE_NAME) > $(IMAGE_NAME).tar
	- gzip $(IMAGE_NAME).tar

import-image:
	- docker import $(IMAGE_NAME).tar.gz $(IMAGE_NAME):$(IMAGE_TAG)

clean: stop
	- docker rmi $(IMAGE_NAME)

