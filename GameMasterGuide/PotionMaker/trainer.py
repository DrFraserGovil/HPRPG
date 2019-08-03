import numpy as np
import pandas
from keras.models import Sequential
from keras.layers import Dense
from keras.wrappers.scikit_learn import KerasRegressor
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import KFold
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import MinMaxScaler
from sklearn.model_selection import train_test_split
from sklearn.externals import joblib
seed = 3
np.random.seed(seed)

potionEffects=np.genfromtxt("effectList.csv", delimiter=",",dtype="str")
potionEffects = potionEffects[1:len(potionEffects)]
n = len(potionEffects)
for i in range(0,n):
	pEffect = potionEffects[i][1]
	
	# load dataset
	Ninputs = 46
	targetID = Ninputs + i
	dataset=np.genfromtxt("potionSet.csv", delimiter=",")
	
	x=dataset[:,0:Ninputs]
	print x[:,Ninputs-1]
	y=dataset[:,targetID]

	y=np.reshape(y, (-1,1))

	#rescale data
	scaler_x = MinMaxScaler()
	scaler_y = MinMaxScaler()
	print(scaler_x.fit(x))
	xscale=scaler_x.transform(x)
	print(scaler_y.fit(y))
	yscale=scaler_y.transform(y)
	
	#split data
	X_train, X_test, y_train, y_test = train_test_split(xscale, yscale)
	
	#Define the model
	model = Sequential()
	model.add(Dense(16, input_dim=Ninputs, kernel_initializer='normal', activation='relu'))
	model.add(Dense(8, activation='relu'))
	model.add(Dense(4, activation='relu'))
	model.add(Dense(1, activation='linear'))
	model.summary()
	model.compile(loss='mse', optimizer='adam', metrics=['mse','mae'])
	print("Training attribute: ``%s''" % pEffect)
	history = model.fit(X_train, y_train, epochs=100, batch_size=50,  verbose=1, validation_split=0.2)
	
	
	

	joblib.dump(model,"Models/"+pEffect+".mdl")
	joblib.dump(scaler_x,"Models/"+pEffect+"_x_scale.scl")
	joblib.dump(scaler_y,"Models/"+pEffect+"_y_scale.scl")
	
