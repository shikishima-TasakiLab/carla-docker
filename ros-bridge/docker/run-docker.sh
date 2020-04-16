#/bin/bash
CARLA_VERSION="0.9.8"
CONTAINER_NAME="carla-ros-bridge"
ROS_DISTRO="melodic"

PROG_NAME=$(basename $0)

function usage_exit {
  cat <<_EOS_ 1>&2

  Usage: $PROG_NAME [OPTIONS...]

  OPTIONS:
    -h, --help                      このヘルプを表示
    -v, --version VERSION           ImageのCARLAのバージョンを指定  (既定値：$CARLA_VERSION)
    -n, --name NAME                 コンテナの名前を設定            (既定値：$CONTAINER_NAME)
    -r, --ros-distro ROS_DISTRO     ROSのバージョンを指定           (既定値：$ROS_DISTRO)

  Example: $PROG_NAME --version $CARLA_VERSION --ros-distro $ROS_DISTRO

_EOS_
    cd ${CURRENT_DIR}
    exit 1
}

while (( $# > 0 )); do
    if [[ $1 == "--help" ]] || [[ $1 == "-h" ]]; then
        usage_exit
    elif [[ $1 == "--version" ]] || [[ $1 == "-v" ]]; then
        if [[ $2 == -* ]]; then
            echo "無効なパラメータ"
            usage_exit
        else
            CARLA_VERSION=$2
        fi
        shift 2
    elif [[ $1 == "--ros-distro" ]] || [[ $1 == "-r" ]]; then
        if [[ $2 == -* ]]; then
            echo "無効なパラメータ： $1 $2"
            usage_exit
        else
            ROS_DISTRO=$2
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

HOST_WS=$(dirname $(dirname $(readlink -f $0)))/carla_ws
IMAGE="carla/ros-bridge:${CARLA_VERSION}-${ROS_DISTRO}"
VOLUME="-v /tmp/.X11-unix:/tmp/.X11-unix:rw"
VOLUME="${VOLUME} -v ${HOST_WS}:/home/carla/catkin_ws:rw"

docker images | grep carla/ros-bridge | grep ${CARLA_VERSION}-${ROS_DISTRO}
if [[ $? -ne 0 ]]; then
    echo "Dockerイメージがありません：${IMAGE}"
    usage_exit
fi

echo "CARLA VERSION = ${CARLA_VERSION}"
echo "ROS DISTRO    = ${ROS_DISTRO}"

echo ${VOLUME}

docker run --rm -it --gpus all -e DISPLAY=$DISPLAY --name ${CONTAINER_NAME} --network carla-net ${VOLUME} ${IMAGE}
