# import numpy as np
# from keras.layers import Input, Flatten
# from keras.models import Model
# inputs = Input(shape=(3,2,4))
#
# # Define a model consisting only of the Flatten operation
# prediction = Flatten()(inputs)
# model = Model(inputs=inputs, outputs=prediction)
#
# X = np.arange(0,24).reshape(1,3,2,4)
# print(X)
# #[[[[ 0  1  2  3]
# #   [ 4  5  6  7]]
# #
# #  [[ 8  9 10 11]
# #   [12 13 14 15]]
# #
# #  [[16 17 18 19]
# #   [20 21 22 23]]]]
# print(model.predict(X))
# #array([[  0.,   1.,   2.,   3.,   4.,   5.,   6.,   7.,   8.,   9.,  10.,
# #         11.,  12.,  13.,  14.,  15.,  16.,  17.,  18.,  19.,  20.,  21.,
# #         22.,  23.]], dtype=float32)

import numpy as np
import time
t = time.time()
x = np.random.random((30000,1))
elapsed = time.time() - t
print(elapsed)

t = time.time()
y = np.random.random((30000,30000))
elapsed = time.time() - t
print(elapsed)

t = time.time()
for n in range(1,30000):
    y2 = y[1:300,:]
    np.dot(y2, x)
elapsed = time.time() - t
print(elapsed)

t = time.time()
z = np.dot(x,y)
elapsed = time.time() - t
print(elapsed)
