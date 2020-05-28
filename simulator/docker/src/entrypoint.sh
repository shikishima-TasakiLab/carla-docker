#!/bin/bash

set -e

ROOT_USER_ID=0
DEFAULT_USER_ID=1000

if [ -v USER_ID ] && [ "$USER_ID" != "$ROOT_USER_ID" ]; then
    usermod --uid $USER_ID carla
    find /home/carla -user $DEFAULT_USER_ID -exec chown -h $USER_ID {} \;
fi

cd /home/carla

echo ""
echo "CARLA Simulator"
echo ""

if [ -z "$1" ]; then
    su - carla -c "set - \"/bin/bash\" -l"
fi

su - carla -c "exec \"$@\""
