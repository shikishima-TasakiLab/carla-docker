#!/bin/bash
SCREEN="on"
CONTAINER_NAME="carla-sim"
CARLA_VERSION="0.9.8"

PROG_NAME=$(basename $0)

function usage_exit {
  cat <<_EOS_ 1>&2

  Usage: $PROG_NAME [OPTIONS...]

  OPTIONS:
    -h, --help              このヘルプを表示
    -s, --screen {on|off}   画面の表示のON/OFF切り替え      (既定値：$SCREEN)
    -n, --name NAME         コンテナの名前を設定            (既定値：$CONTAINER_NAME)
    -v, --version VERSION   ImageのCARLAのバージョンを指定  (既定値：$CARLA_VERSION)

  Example: $PROG_NAME --screen off

_EOS_
  exit 1
}

while (( $# > 0 )); do
    if [[ $1 == "--help" ]] || [[ $1 == "-h" ]]; then
        usage_exit
    elif [[ $1 == "--screen" ]] || [[ $1 == "-s" ]]; then
        if [[ $2 == "on" ]]; then
            SCREEN="on"
        elif [[ $2 == "off" ]]; then
            SCREEN="off"
        else
            echo "無効なパラメータ： $1 $2"
            usage_exit
        fi
        shift 2
    elif [[ $1 == "--name" ]] || [[ $1 == "-n" ]]; then
        if [[ $2 == -* ]] || [[ $2 == *- ]]; then
            echo "無効なパラメータ： $1 $2"
            usage_exit
        fi
        CONTAINER_NAME=$2
        shift 2
    elif [[ $1 == "--version" ]] || [[ $1 == "-v" ]]; then
        docker images | grep carla/simulator | grep $2
        if [[ $? == "0" ]]; then
            CARLA_VERSION=$2
        else
            echo "Imageが存在しません：carla/simulator:$2"
            usage_exit
        fi
        shift 2
    else
        echo "無効なパラメータ： $1"
        usage_exit
    fi
done

IMAGE="carla/simulator:${CARLA_VERSION}"
VOLUME="-v /tmp/.X11-unix/:/tmp/.X11-unix:rw"

docker network create carla-net

if [[ $SCREEN == "on" ]]; then
    docker run --rm -it --gpus all -e DISPLAY=$DISPLAY -p 2000-2002:2000-2002 --name ${CONTAINER_NAME} --network carla-net $VOLUME $IMAGE
else
    docker run --rm -it --gpus all -e DISPLAY=$DISPLAY -e SDL_VIDEODRIVER=offscreen -p 2000-2002:2000-2002 --name ${CONTAINER_NAME} --network carla-net $VOLUME $IMAGE
fi

docker network rm carla-net
