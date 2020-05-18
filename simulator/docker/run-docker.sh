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
    else
        echo "無効なパラメータ： $1"
        usage_exit
    fi
done

IMAGE_LS=$(docker image ls carla/simulator)
declare -a images=()

IMAGE_LS_LINES=$(echo "${IMAGE_LS}" | wc -l)
if [[ ${IMAGE_LS_LINES} -eq 1 ]]; then
    echo "carla/simulator のイメージが見つかりませんでした．"
    docker images
    usage_exit
else
    cnt=0
    while read repo tag id created size ; do
        if [[ ${cnt} != 0 ]]; then
            images+=( "${repo}:${tag}" )
        fi
        cnt=$((${cnt}+1))
    done <<END
${IMAGE_LS}
END
    if [[ ${#images[@]} -eq 1 ]]; then
        DOCKER_IMAGE="${images[0]}"
        echo "${DOCKER_IMAGE}"
    else
        echo -e "番号\tイメージ:タグ"
        cnt=0
        for im in ${images[@]}; do
            echo -e "${cnt}:\t${im}"
            cnt=$((${cnt}+1))
        done
        isnum=3
        image_num=-1
        while [[ ${isnum} -ge 2 ]] || [[ ${image_num} -ge ${cnt} ]] || [[ ${image_num} -lt 0 ]]; do
            read -p "使用するイメージの番号を入力してください: " image_num
            expr ${image_num} + 1 > /dev/null 2>&1
            isnum=$?
        done
        DOCKER_IMAGE="${images[${image_num}]}"
        echo "${DOCKER_IMAGE}"
    fi
fi

docker network create carla-net

if [[ $SCREEN == "on" ]]; then
    XSOCK="/tmp/.X11-unix"
    XAUTH="/tmp/.docker.xauth"
    DOCKER_VOLUME="${DOCKER_VOLUME} -v ${XSOCK}:${XSOCK}:rw"
    DOCKER_VOLUME="${DOCKER_VOLUME} -v ${XAUTH}:${XAUTH}:rw"
    touch ${XAUTH}
    xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f ${XAUTH} nmerge -
    
    docker run --rm -it --gpus all -e DISPLAY=$DISPLAY -p 2000-2002:2000-2002 --name ${CONTAINER_NAME} --network carla-net ${DOCKER_VOLUME} ${DOCKER_IMAGE}
else
    docker run --rm -it --gpus all -e DISPLAY=$DISPLAY -e SDL_VIDEODRIVER=offscreen -p 2000-2002:2000-2002 --name ${CONTAINER_NAME} --network carla-net ${DOCKER_VOLUME} ${DOCKER_IMAGE}
fi

docker network rm carla-net
