from keras.models import Sequential
from keras.layers import Dense, Dropout, Activation
from keras.optimizers import SGD
from keras.datasets import mnist
import numpy as np

model = Sequential()
model.add(Dense(500, input_shape=(784, )))
model.add(Activation('tanh'))
model.add(Dropout(0.5))

model.add(Dense(500))
model.add(Activation('tanh'))
model.add(Dropout(0.5))

model.add(Dense(10))
model.add(Activation('softmax'))

#bianyi
sgd = SGD(lr=0.01, decay=1e-6, momentum=0.9, nesterov=True)
model.compile(loss='categorical_crossentropy', optimizer=sgd, metrics=['accuracy'])

#duqushuju
#(x_train, y_train),(x_test, y_test) = mnist.load_data()
(x_train,y_train),(x_test,y_test) = mnist.load_data()

X_train = x_train.reshape(x_train.shape[0], x_train.shape[1]*x_train.shape[2])
X_test = x_test.reshape(x_test.shape[0], x_test.shape[1]*x_test.shape[2])


Y_train = (np.arange(10) == y_train[:,None]).astype(int)
Y_test = (np.arange(10) == y_test[:, None]).astype(int)

model.fit(X_train, Y_train,batch_size=200, epochs=10, shuffle=True, verbose=1, validation_split=0.3)


print("test set")
scores = model.evaluate(X_test, Y_test, batch_size=200, verbose=1)
print("")

print("ths test loss is ")
print(scores)
result = model.predict(X_test, batch_size=200, verbose=1)
result_max = np.argmax(result, axis = 1)
test_max = np.argmax(Y_test, axis= 1)


result_bool = np.equal(result_max, test_max)
ture_num = np.sum(result_bool)
print("")

print("the accuracy of the model is %f" % (ture_num/len(result_bool)))
