#!/bin/bash

set -e

DEFAULT_USER_ID=1000

if [ -v USER_ID ] && [ "$USER_ID" != "$DEFAULT_USER_ID" ]; then
    usermod --uid $USER_ID carla
    find /home/carla -user $DEFAULT_USER_ID -exec chown -h $USER_ID {} \;
fi

cd /home/carla

echo ""
echo "CARLA ROS-Bridge"
echo ""

if [ -z "$1" ]; then
    set - "/bin/bash" -l
fi

exec "$@"
