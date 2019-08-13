'''Trains a simple convnet on the MNIST dataset.
Gets to 99.25% test accuracy after 12 epochs
(there is still a lot of margin for parameter tuning).
16 seconds per epoch on a GRID K520 GPU.
'''

from __future__ import print_function
import keras
from keras.datasets import mnist
from keras.models import Sequential
from keras.layers import Dense, Dropout, Flatten
from keras.layers import Conv2D, MaxPooling2D
from keras import backend as K
import scipy.io
import numpy as np

batch_size = 128
num_classes = 10
epochs = 12

# # input image dimensions
# img_rows, img_cols = 28, 28
#
# # the data, split between train and test sets
# (x_train, y_train), (x_test, y_test) = mnist.load_data()
#
# if K.image_data_format() == 'channels_first':
#     x_train = x_train.reshape(x_train.shape[0], 1, img_rows, img_cols)
#     x_test = x_test.reshape(x_test.shape[0], 1, img_rows, img_cols)
#     input_shape = (1, img_rows, img_cols)
# else:
#     x_train = x_train.reshape(x_train.shape[0], img_rows, img_cols, 1)
#     x_test = x_test.reshape(x_test.shape[0], img_rows, img_cols, 1)
#     input_shape = (img_rows, img_cols, 1)
#
# x_train = x_train.astype('float32')
# x_test = x_test.astype('float32')
# x_train /= 255
# x_test /= 255
#
# # for test
# input_p = x_test[1,:,:,0]
# scipy.io.savemat('input_p.mat', {'input_p':input_p})
#
# print('x_train shape:', x_train.shape)
# print(x_train.shape[0], 'train samples')
# print(x_test.shape[0], 'test samples')
#
# # convert class vectors to binary class matrices
# y_train = keras.utils.to_categorical(y_train, num_classes)
# y_test = keras.utils.to_categorical(y_test, num_classes)
#
# model = Sequential()
# model.add(Conv2D(32, kernel_size=(3, 3),
#                  activation='relu',
#                  input_shape=input_shape))
# model.add(Conv2D(64, (3, 3), activation='relu'))
# model.add(MaxPooling2D(pool_size=(2, 2)))
# model.add(Dropout(0.25))
# model.add(Flatten())
# model.add(Dense(128, activation='relu'))
# model.add(Dropout(0.5))
# model.add(Dense(num_classes, activation='softmax'))
#
# model.compile(loss=keras.losses.categorical_crossentropy,
#               optimizer=keras.optimizers.Adadelta(),
#               metrics=['accuracy'])
#
# model.fit(x_train, y_train,
#           batch_size=batch_size,
#           epochs=epochs,
#           verbose=1,
#           validation_data=(x_test, y_test))
# score = model.evaluate(x_test, y_test, verbose=0)
# print('Test loss:', score[0])
# print('Test accuracy:', score[1])

# weights = model.get_weights()
# scipy.io.savemat('mnist_nnet.mat', {'weights':weights})
#
# model.save('mnist_nnet.h5')

model = keras.models.load_model('mnist_nnet.h5')

filters, biases = model.layers[0].get_weights()
weights = model.get_weights()
weights0 = weights[0][:,:,0,0]
scipy.io.savemat('mnist_cnn.mat', {'weights':weights})

# test
inp = model.input                                           # input placeholder
outputs = [layer.output for layer in model.layers]          # all layer outputs
functors = [K.function([inp, K.learning_phase()], [out]) for out in outputs]    # evaluation functions

input_p = scipy.io.loadmat('input_p.mat')['input_p']
input_p = input_p.reshape(1, 28, 28, 1)

# Testing
layer_outs = [func([input_p, 0.]) for func in functors]
layer0 = layer_outs[0][0][0,:,:,0]
layer1 = layer_outs[1][0][0,:,:,0]
layer2 = layer_outs[2][0][0,:,:,0]
layer3 = layer_outs[3][0][0,:,:,0]
layer4 = layer_outs[4][0][0]
x = len(layer4[layer4>0.0])
print(layer_outs[0])