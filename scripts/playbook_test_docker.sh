#!/bin/bash

DOCKER_CONTAINER_NAME="ansible-test"

cd ../docker && docker build -t myubuntu .

docker run -ti --privileged --name $DOCKER_CONTAINER_NAME -d -p 5000:22 myubuntu

cd ../packer/ansible && ansible-playbook -i env/local_docker site.yml

#docker stop $DOCKER_CONTAINER_NAME

#docker rm $DOCKER_CONTAINER_NAME
