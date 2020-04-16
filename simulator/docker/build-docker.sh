CARLA_VERSION="0.9.8"

HOST_USER=$(id -u)
CURRENT_DIR=$(pwd)
BUILD_DIR=$(dirname $(readlink -f $0))
PROG_NAME=$(basename $0)

cd ${BUILD_DIR}

function usage_exit {
  cat <<_EOS_ 1>&2

  Usage: $PROG_NAME [OPTIONS...]

  OPTIONS:
    -h, --help              このヘルプを表示
    -v, --version VERSION   ImageのCARLAのバージョンを指定  (既定値：$CARLA_VERSION)

  Example: $PROG_NAME --version $CARLA_VERSION

_EOS_
    cd ${CURRENT_DIR}
    exit 1
}

while (( $# > 0 )); do
    if [[ $1 == "--help" ]] || [[ $1 == "-h" ]]; then
        usage_exit
    elif [[ $1 == "--version" ]] || [[ $1 == "-v" ]]; then
        if [[ $2 == -* ]]; then
            echo "無効なパラメータ： $1 $2"
            usage_exit
        fi
        VERSION=$(ls -1 Dockerfile.* | grep $2)
        VERSION=${VERSION:11}
        if [[ $VERSION == $2 ]]; then
            CARLA_VERSION=$2
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

docker build \
    -f Dockerfile.${CARLA_VERSION} \
    --build-arg HOST_USER=${HOST_USER} \
    --force-rm=true \
    -t carla/simulator:${CARLA_VERSION} .

cd ${CURRENT_DIR}
