#!/bin/bash
if [ $# != 1 ]; then
    echo "indicate gpu id"
    exit 1
fi
if [ $1 != '0' ] && [ $1 != '1' ] && [ $1 != '2' ]; then
    echo "indicate proper gpu id"
    exit 1
fi
docker run -u $(id -u):$(id -g) --detach --cpus 4.0 --gpus '"device='$1'"' --shm-size 16g --env 'TZ=Asia/Tokyo' --volume ${HOME}/Projects:/home -p 58888:8888 --name ${USER}_jupyter ${USER}:latest jupyter lab --ip=0.0.0.0 --allow-root --no-browser --NotebookApp.notebook_dir='/home' --NotebookApp.password=${JUPYTER_PASSWD}
