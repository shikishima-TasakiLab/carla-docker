# CARLA-Docker

[CARLA](http://carla.org/)をDocker上で実行する
- リンク
    - [CARLA GitHub](https://github.com/carla-simulator)
    - [CARLA Documentation](https://carla.readthedocs.io/en/latest/)

## 環境依存

### ハードウェア
|ハードウェア                |テスト済         |
|----------------------------|:---------------:|
|メモリが4GB以上のNVIDIA製GPU|NVIDIA RTX 2080Ti|

### ソフトウェア
|ソフトウェア            |テスト済    |
|------------------------|:----------:|
|Linux OS-64bit          |Ubuntu 18.04|
|NVIDIA driver           |440.82      |
|Docker-CE               |19.03.8     |
|NVIDIA-Container-Toolkit|1.0.7       |
 

## インストール
```bash
git clone --recursive https://github.com/shikishima-TasakiLab/carla-docker.git
```

## 使い方

### Docker イメージのビルド
1. 次のコマンドでSimulatorのDockerイメージをビルドする．
    ```bash
    ./simulator/docker/build-docker.sh
    ```
    コマンドの詳細：[./simulator/README.md](https://github.com/shikishima-TasakiLab/carla-docker/blob/master/simulator/README.md)

2. 次のコマンドでROS-BridgeのDockerイメージをビルドする．
    ```bash
    ./ros-bridge/docker/build-docker.sh
    ```
    コマンドの詳細：[./ros-bridge/README.md](https://github.com/shikishima-TasakiLab/carla-docker/blob/master/ros-bridge/README.md)

### Docker コンテナの起動
1. 次のコマンドでSimulatorのDockerコンテナを起動する．
    ```bash
    ./simulator/docker/run-docker.sh
    ```
    コマンドの詳細：[./simulator/README.md](https://github.com/shikishima-TasakiLab/carla-docker/blob/master/simulator/README.md)

2. 次のコマンドでROS-BridgeのDockerコンテナを起動する．起動と同時に[./ros-bridge/carla_ws](https://github.com/shikishima-TasakiLab/carla-docker/tree/master/ros-bridge/carla_ws)内のROSパッケージがcatkin_makeされる．
    ```bash
    ./ros-bridge/docker/run-docker.sh
    ```
    コマンドの詳細：[./ros-bridge/README.md](https://github.com/shikishima-TasakiLab/carla-docker/blob/master/simulator/README.md)

3. ROS-BridgeのDockerコンテナで複数のROSパッケージを使用する際は，次のコマンドを別のターミナルで実行する．
    ```bash
    ./ros-bridge/docker/exec-docker.sh
    ```
    コマンドの詳細：[./ros-bridge/README.md](https://github.com/shikishima-TasakiLab/carla-docker/blob/master/simulator/README.md)

4. ROSの各ノードを起動する前に，hostの情報を編集する．各パッケージ内にある"config"や"launch"のhostの設定を，"localhost"からシミュレータのコンテナ名(既定値：carla-sim)に書き換える.

### CARLAの使用方法
[CARLA Documentation](https://carla.readthedocs.io/en/latest/)・[CARLA GitHub](https://github.com/carla-simulator)を参照．
