# ROS-BRIDGE

## Docker

※先にSIMULATORのDockerイメージをビルドしてください．

### Docker イメージの作成
```bash
./docker/build-docker.sh --version VERSION --ros-distro ROS_DISTRO
```
|オプション      |パラメータ |説明                   |既定値 |
|----------------|:---------:|-----------------------|:-----:|
|-h, --help      |なし       |ヘルプを表示           |なし   |
|-v, --version   |VERSION    |CARLAのバージョンを指定|0.9.8  |
|-r, --ros-distro|ROS_DISTRO |ROSのバージョンを指定  |melodic|

### Docker コンテナの作成・実行
```bash
./docker/run-docker.sh --version VERSION --name NAME --ros-distro ROS_DISTRO
```
|オプション      |パラメータ |説明                   |既定値          |
|----------------|:---------:|-----------------------|:--------------:|
|-h, --help      |なし       |ヘルプを表示           |なし            |
|-v, --version   |VERSION    |CARLAのバージョンを指定|0.9.8           |
|-n, --name      |NAME       |コンテナの名前         |carla-ros-bridge|
|-r, --ros-distro|ROS_DISTRO |ROSのバージョンを指定  |melodic         |

### Docker 実行中のコンテナに入る
```bash
./docker/exec-docker.sh --id CONTAINER_ID --version VERSION --name NAME --ros-distro ROS_DISTRO
```
|オプション      |パラメータ  |説明                   |既定値|
|----------------|:----------:|-----------------------|:----:|
|-h, --help      |なし        |ヘルプを表示           |なし  |
|-i, --id        |CONTAINER_ID|コンテナのID           |なし  |
|-v, --version   |VERSION     |CARLAのバージョンを指定|なし  |
|-n, --name      |NAME        |コンテナの名前         |なし  |
|-r, --ros-distro|ROS_DISTRO  |ROSのバージョンを指定  |なし  |
