# SIMULATOR

## Docker

### Docker イメージの作成
```bash
./docker/build-docker.sh --version VERSION
```
|オプション      |パラメータ |説明                   |既定値 |
|----------------|:---------:|-----------------------|:-----:|
|-h, --help      |なし       |ヘルプを表示           |なし   |
|-v, --version   |VERSION    |CARLAのバージョンを指定|0.9.8  |

### Docker コンテナの作成・実行
```bash
./docker/run-docker.sh --version VERSION --name NAME --ros-distro ROS_DISTRO
```
|オプション    |パラメータ |説明                      |既定値   |
|--------------|:---------:|--------------------------|:-------:|
|-h, --help    |なし       |ヘルプを表示              |なし     |
|-s, --screen  |{on|off}   |画面の表示のON/OFF切り替え|on       |
|-n, --name    |NAME       |コンテナの名前            |carla-sim|
|-v, --version |VERSION    |CARLAのバージョンを指定   |0.9.8    |
