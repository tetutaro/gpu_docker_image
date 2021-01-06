#!/bin/bash
if [ $# != 1 ]; then
    echo "indicate gpu id"
    exit 1
fi
if [ $1 != '0' ] && [ $1 != '1' ] && [ $1 != '2' ]; then
    echo "indicate proper gpu id"
    exit 1
fi
docker run --rm -it -u $(id -u):$(id -g) --cpus 4.0 --gpus '"device='$1'"' --shm-size 16g --env 'TZ=Asia/Tokyo' --volume ${HOME}/Projects:/home -p 58888:6006 --name ${USER}_console ${USER}:latest /bin/bash
