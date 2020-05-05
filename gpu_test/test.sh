#!/bin/bash
docker run --gpus all --rm -it ${USER}:gputest /bin/bash /root/gputest.sh
