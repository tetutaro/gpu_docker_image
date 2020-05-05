# gpu_docker_image
GPUマシン上で動くdockerのcontainer imageを作る

共有GPU&DockerホストマシンのCUDAのバージョンが10.1なので、10.1 に対応したもの。

各ディレクトリに行き `build.sh` で docker container image を作る。

コンテナ起動スクリプトが `run_console.sh` もしくは `run_juputer.sh` 。

CPUの石が12個、GPUが3枚ささっているので、使うときは両方1/3だけ使う想定。

動かすときは gpu の番号（0/1/2）を指定する。

shared memory のサイズを 16G に指定している。

`run_console.sh` はTensorBoadを使うことを想定してコンテナの6006ポートを、
`run_jupyter.sh` はJupyterLabを使うことを想定してコンテナの8888ポートを
ホストの58888にバインドしている。

JupyterLabからTensorBoardを見たいときは以下のMagicを使った専用Notebookを作る想定。
```
%load_ext tensorboard
%tensorboard --logdir <logdir path>
```

JupyterLabのpasswordは、以下の操作で得られた文字列を.bashrcかなんかで設定する。（JupyterLabが動く別の環境か、docker run --rm -it とかで）
```
> python -c 'from notebook.auth import passwd; print(passwd())'
Enter password: <input your password>
Verify password: <input your password again>
```

## gpu\_test

GPUがちゃんと動くかのテスト。nVIDIAのCUDAライブラリとTensorFlow, TensorBoard, PyTorch, TorchVision だけ。

## full\_packed

全部盛り盛り。機械学習関係、自然言語関係、画像処理関係、Jupyter関係全部入り。

## Motivations and Tips

```
1. container image に CUDA ライブラリのインストールが必要
Python の諸々をインストールしていくのに他のを使うと依存関係と必要ライブラリの泥沼にハマって簡単に死ぬるので、
是非 DockerHub の本家 Python イメージを使いたい。（例えば python:slim とか）
https://hub.docker.com/_/python
しかし当然これには CUDA ライブラリは入ってないので、別途入れることが必要。
（もちろん本家 nVIDIA https://hub.docker.com/r/nvidia/cuda には最初から入っている）
本家 Python イメージは Debian ベースだが、上記 nVIDIA のリストに Debian はない。
そこで、こいつの Dockerfile を<strike>コピペ</strike>リスペクトして自分の Dockerfile に貼ればいい。
https://gitlab.com/nvidia/container-images/cuda/-/tree/master
相変わらずここにも Debian のバージョンのものはないけど、Ubuntu のもので動いた。

2. この CUDA ライブラリは docker ホストに入っている CUDA ライブラリとバージョンを合わせる必要がある
ちょっとぐらい backward compatibility があってもいいとは思うのだが、
Dockerfile にも明確に書いてある。
ホストのCUDAバージョンは nvidia-smi コマンドで確認できる。

3. PyTorch のバージョンも CUDA のバージョンに合わせる必要がある
ちょっとぐらい backward（略）
pytorch.org に行くとポチポチするだけで pip コマンドが出てくる奴があるので、それをコピペする。
（tensorflow はあんま考えなくても使える（XLA_GPU）っぽいので、その点 Google さん優秀）

4. docker run コマンドに --gpus XXX オプションを付けるのを忘れない
私は毎回 docker run して調べる度にびっくりして絶望する

GPUが使えるかどうかチェックポイント

1. Shell でコンテナに入る
2. nvidia-smi コマンドが打てて、まっとな表示が出るかチェックする
（--gpus オプションがつけばホストのドライバが勝手にコンテナの中に入ってくる）
3. python を起動
4. import torch; torch.cuda.is_available() が True 返す
5. torch.cuda.device_count() が GPU の数を返す
6. from tensorflow.python.client import device_lib; device_lib.list_local_devices() で GPU 一覧が見える
```
