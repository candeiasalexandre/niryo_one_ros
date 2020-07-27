#!/bin/bash
set -e

# setup ros environment
source "/home/niryo_one/devel/setup.bash"

# keep runing
while true; do :; done & kill -STOP $! && wait $!