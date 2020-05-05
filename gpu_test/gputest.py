#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import torch
import tensorflow as tf


# disable information log of capability of using AVX2 FMA of CPU
# if you want to use AVX2 FMA, you should compile TensorFlow from source
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'
print("Can GPUs be used from PyTorch?", torch.cuda.is_available())
print("How many GPUs be used from PyTorch?", torch.cuda.device_count())
protos = tf.config.list_physical_devices('GPU')
names = [x.name for x in protos if x.device_type == 'GPU']
print("GPUs which can be used from TensorFlow:")
if len(names) > 0:
    for name in names:
        print(" GPU Name:", name)
else:
    print(" None")
