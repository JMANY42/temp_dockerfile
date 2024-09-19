#!/usr/bin/bash

CONTAINER_NAME="RoboBoat"
IMAGE_NAME="roboboat"
IMAGE_TAG="latest"

WORK_DIR="$HOME/code/python/opencv-playground/src"

CONTAINER_ID=`docker ps -aqf "name=^/${CONTAINER_NAME}$"`

if [ -z "${CONTAINER_ID}" ]; then

    docker run \
        --tty \
        --detach \
        --name ${CONTAINER_NAME} \
        --device "/dev/dri:/dev/dri" \
        --privileged \
        --gpus all \
        --shm-size 16G \
        --network host \
        --env "DISPLAY=$DISPLAY" \
        --volume "/tmp/.X11-unix:/tmp/.X11-unix" \
        --volume "${WORK_DIR}:/root/code/src/" \
       ${IMAGE_NAME}:${IMAGE_TAG} 

else
    xhost +local:`docker inspect --format='{{ .Config.Hostname }}' ${CONTAINER_ID}`

    if [ -z `docker ps -qf "name=^/${CONTAINER_NAME}$"` ]; then
        echo "${CONTAINER_NAME} container not running. Starting container..."
        docker start ${CONTAINER_ID}
    else
        echo "Attaching to running ${CONTAINER_NAME} container..."
    fi
    docker exec -it ${CONTAINER_ID} bash

    xhost -local:`docker inspect --format='{{ .Config.Hostname }}' ${CONTAINER_ID}`
fi