FROM python:slim
USER root
# install cuda
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list
ENV CUDA_VERSION 10.1.243
ENV CUDA_PKG_VERSION 10-1=$CUDA_VERSION-1
# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        cuda-cudart-$CUDA_PKG_VERSION \
        cuda-compat-10-1 \
        libcudnn7=7.6.4.38-1+cuda10.1  \
        libcudnn7-dev=7.6.4.38-1+cuda10.1 \
        libnvinfer6=6.0.1-1+cuda10.1 \
        libnvinfer-dev=6.0.1-1+cuda10.1 \
        libnvinfer-plugin6=6.0.1-1+cuda10.1 \
        libcublas10=10.2.1.243-1 \
        libcublas-dev=10.2.1.243-1 \
        cuda-nvrtc-10-1 \
        cuda-nvrtc-dev-10-1 \
        cuda-cudart-dev-10-1 \
        cuda-cufft-dev-10-1 \
        cuda-curand-dev-10-1 \
        cuda-cusolver-dev-10-1 \
        cuda-cusparse-dev-10-1 && \
    ln -s cuda-10.1 /usr/local/cuda
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf
ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64
# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.1 brand=tesla,driver>=384,driver<385 brand=tesla,driver>=396,driver<397 brand=tesla,driver>=410,driver<411"
ENV TF_CUDA_VERSION=10.1
ENV TF_CUDNN_VERSION=7
# install mecab
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        g++ git make xz-utils file patch fonts-takao libopencv-dev \
        mecab libmecab-dev mecab-ipadic-utf8 mecab-jumandic-utf8
RUN sed -i "s/\${prefix}\/lib\/x86_64-linux-gnu\/mecab\/dic/\/var\/lib\/mecab\/dic/" /usr/bin/mecab-config
# install ipadic-NEologd
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git && \
    cd mecab-ipadic-neologd && \
    ./bin/install-mecab-ipadic-neologd -a -n -y -p /var/lib/mecab/dic/mecab-ipadic-neologd && \
    cd .. && rm -rf mecab-ipadic-neologd
# install Python packages
RUN pip install --no-cache --upgrade pip && \
    pip install --no-cache \
        simplejson xlrd requests click \
        numpy scipy scikit-learn \
        pandas matplotlib seaborn \
        mojimoji mecab-python3 spacy ginza sumeval \
        gensim fasttext sentencepiece \
        tensorflow tensorboard \
        opencv-python scikit-image \
        ipywidgets widgetsnbextension ipympl qgrid bokeh jupyterlab && \
    pip install --no-cache torch==1.5.0+cu101 torchvision==0.6.0+cu101 -f https://download.pytorch.org/whl/torch_stable.html && \
    pip install --no-cache pytorch-lightning transformers && \
    jupyter nbextension enable --py --sys-prefix widgetsnbextension && \
    jupyter nbextension enable --py --sys-prefix qgrid && \
    curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install -y nodejs && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager@2.0 && \
    jupyter labextension install jupyter-matplotlib && \
    jupyter labextension install @bokeh/jupyter_bokeh && \
    jupyter labextension install qgrid2 && \
    jupyter labextension install @axlair/jupyterlab_vim && \
    jupyter lab build && \
    jupyter lab clean
RUN apt-get purge --autoremove -y curl git make file patch && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN echo "export TZ=Asia/Tokyo" >> /root/.bashrc
