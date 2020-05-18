#/bin/bash
CONTAINER_NAME="carla-ros-bridge"

PROG_NAME=$(basename $0)

function usage_exit {
  cat <<_EOS_ 1>&2

  Usage: $PROG_NAME [OPTIONS...]

  OPTIONS:
    -h, --help                      このヘルプを表示
    -n, --name NAME                 コンテナの名前を設定            (既定値：$CONTAINER_NAME)

  Example: $PROG_NAME --version $CARLA_VERSION --ros-distro $ROS_DISTRO

_EOS_
    cd ${CURRENT_DIR}
    exit 1
}

while (( $# > 0 )); do
    if [[ $1 == "--help" ]] || [[ $1 == "-h" ]]; then
        usage_exit
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

IMAGE_LS=$(docker image ls carla/ros-bridge)
declare -a images=()

IMAGE_LS_LINES=$(echo "${IMAGE_LS}" | wc -l)
if [[ ${IMAGE_LS_LINES} -eq 1 ]]; then
    echo "carla/ros-bridge のイメージが見つかりませんでした．"
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

HOST_WS=$(dirname $(dirname $(readlink -f $0)))/carla_ws

XSOCK="/tmp/.X11-unix"
XAUTH="/tmp/.docker.xauth"

DOCKER_VOLUME="${DOCKER_VOLUME} -v ${XSOCK}:${XSOCK}:rw"
DOCKER_VOLUME="${DOCKER_VOLUME} -v ${XAUTH}:${XAUTH}:rw"
DOCKER_VOLUME="${DOCKER_VOLUME} -v ${HOST_WS}:/home/carla/catkin_ws:rw"

docker images | grep carla/ros-bridge | grep ${CARLA_VERSION}-${ROS_DISTRO}
if [[ $? -ne 0 ]]; then
    echo "Dockerイメージがありません：${IMAGE}"
    usage_exit
fi

echo "CARLA VERSION = ${CARLA_VERSION}"
echo "ROS DISTRO    = ${ROS_DISTRO}"

echo ${VOLUME}

docker run --rm -it --gpus all -e DISPLAY=$DISPLAY --name ${CONTAINER_NAME} --network carla-net ${DOCKER_VOLUME} ${DOCKER_IMAGE}
