#/bin/bash

ROS_DISTRO="melodic"
CARLA_VERSION="0.9.9"

HOST_USER=$(id -u)
CURRENT_DIR=$(pwd)
BUILD_DIR=$(dirname $(readlink -f $0))
PROG_NAME=$(basename $0)

function usage_exit {
  cat <<_EOS_ 1>&2

  Usage: $PROG_NAME [OPTIONS...]

  OPTIONS:
    -h, --help                      このヘルプを表示
    -v, --version VERSION           ImageのCARLAのバージョンを指定  (既定値：$CARLA_VERSION)
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
        docker images | grep carla/simulator | grep $2
        if [[ $? == "0" ]]; then
            CARLA_VERSION=$2
        else
            echo "SimulatorのImageが存在しません：carla/simulator:$2"
            usage_exit
        fi
        shift 2
    elif [[ $1 == "--ros-distro" ]] || [[ $1 == "-r" ]]; then
        if [[ $2 == -* ]]; then
            echo "無効なパラメータ： $1 $2"
            usage_exit
        fi
        VERSION=$(ls -1 ${BUILD_DIR}/src/Dockerfile.* | xargs -n1 basename | grep $2)
        VERSION=${VERSION:11}
        if [[ $VERSION == $2 ]]; then
            ROS_DISTRO=$2
        else
            echo "無効なバージョン： $2"
            usage_exit
        fi
        shift 2
    else
        echo "無効なパラメータ： $1"
        usage_exit
    fi
done

echo "CARLA VERSION = ${CARLA_VERSION}"
echo "ROS DISTRO    = ${ROS_DISTRO}"

docker build \
    -f ${BUILD_DIR}/src/Dockerfile.${ROS_DISTRO} \
    --build-arg ROS_DISTRO=${ROS_DISTRO} \
    --build-arg CARLA_VERSION=${CARLA_VERSION} \
    --force-rm=true \
    -t carla/ros-bridge:${CARLA_VERSION}-${ROS_DISTRO} \
    ${BUILD_DIR}/src
