import potionClasses as pc
import numpy as np
import pandas
import keras
import sklearn
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
import multiprocessing as mp
import threading
import time
global models,xScalers,yScalers
import tensorflow as tf
import matplotlib.pyplot as plt
#keras.backend_set_learning_phase(0)
def loadEffect(pEffect,i):
	global models,xScalers,yScalers
	model = joblib.load("Models/"+pEffect+".mdl")
	scaler_x = joblib.load("Models/"+pEffect+"_x_scale.scl")
	scaler_y = joblib.load("Models/"+pEffect+"_y_scale.scl")
	
	models[i] = model
	xScalers[i] = scaler_x
	yScalers[i] = scaler_y
def loopLoad(start,end):
	global models,xScalers,yScalers
	print (" model for %d->%d" % (start,end))
	for i in range(start,end):
		pEffect = potionEffects[i][1]
		
		print ("Loading model for: %s" % pEffect)
		
		loadEffect(pEffect,i)
		
	return 1

def parallelLoad():
	keras.backend.clear_session()
	potionEffects=np.genfromtxt("effectList.csv", delimiter=";",dtype="str",usecols=np.arange(0,9))
	potionEffects = potionEffects[1:len(potionEffects)]
	n = len(potionEffects)
	
	t = time.time()
	
	global models,xScalers,yScalers
	#m = pool.map(loopLoad, range(0,10))
	nT = mp.cpu_count()
	leftOvers = n % nT
	chunk = n/nT
	threads = list()
	start = 0
	for index in range(nT):
		end = start+chunk
		x = threading.Thread(target=loopLoad, args=(start,end))
		threads.append(x)
		x.start()
		start = start+chunk
	#calculate 
	print("Chunk model for %d->%d" % (start,n))
	#loopLoad(start,n)

	for index, thread in enumerate(threads):
		thread.join()
		a=1


	print ("Load time = %f seconds" % round(time.time() - t,1))
	
def linearLoad():
	potionEffects=np.genfromtxt("effectList.csv", delimiter=";",dtype="str",usecols=np.arange(0,9))
	potionEffects = potionEffects[1:len(potionEffects)]
	n = len(potionEffects)
	
	t = time.time()
	
	global models,xScalers,yScalers
	for i in range(0,n):
		pEffect = potionEffects[i][1]
		print ("Loading model  %s" % pEffect)
		loadEffect(pEffect,i)
	
		
def loadModels():
	linearLoad()

	print("\n\n Models Loaded. Initialising Learner")
	mixPotion([0,1,2],5,False)


def loadColourModels():
	names = ["Red","Green","Blue","Thickness"]
	n = len(names)
	global models,xScalers,yScalers
	for i in range(0,n):
		pEffect = names[i]
		print ("Loading model  %s" % pEffect)
		loadEffect(pEffect,i)

def vial():
	leftEdgeX = [0.2,0.2]
	leftEdgeY = [0.8,0.2]
	rightEdgeX = [0.4,0.4]
	rightEdgeY = [0.2,0.8]
	
	x = leftEdgeX + rightEdgeX
	y = leftEdgeY + rightEdgeY
	
	return x,y
		
def potion(idVector,roll,printVal=True,graphVal=False):
	storeVec = []
	ingVec = []
	
	potionEffects=np.genfromtxt("effectList.csv", delimiter=";",dtype="str",usecols=np.arange(0,10))
	potionEffects = potionEffects[1:len(potionEffects)]
	
	
	
	n = len(ingredients)
	for id in idVector:
		if (id < n) and (id >=0) and (id not in storeVec):
			storeVec.append(id)
			ingVec.append(ingredients[id])
		else:
			print("You have passed an invalid or duplicated id. Try again")
			return -1
	if (len(ingVec) < 2) or (len(ingVec) > 5):
		print("You passed an invalid number of ingredients. Try again")
		return -1

	
	title ="Mixing potion with ingredients: "
	for i in ingVec:
		title+= i.Name + ", "
	title+= "with a roll of %d\n" % roll
	
	p = pc.Potion(ingVec,roll,potionEffects)
	p.AutoDetermine()
	if printVal:
		#p.display(True)
		head = ("="*20)
		print ("\n\n" + (head*6))
		print(title)
		
	
		print(pc.textify(p,potionEffects))
		print  ("\n" + (head*6))
	
	if graphVal:
		p.DetermineVisuals(models,xScalers,yScalers)
		x,y=vial()
		c = (float(p.R)/255,float(p.G)/255,float(p.B)/255)

		f,(ax1,ax2) = plt.subplots(1,2)
		ax1.fill(x,y,color = c)
		ax1.axis('off')
		t = pc.textify(p,potionEffects)
		ax2.text(0.5,0.5,t,wrap=True,fontsize=10,va='center',ha='center',multialignment='left')
		ax2.axis('off')
		plt.show()
	
	return p
def getIngredients():
	
	str_arr = raw_input("Enter potion ingredient IDs, separated by a comma. Potions have between 2 and 5 ingredients, and cannot be repeated:\n\t").split(',') #will take in a string of numbers separated by a space
	arr = [int(num) for num in str_arr]
	print (arr)

dataset=np.genfromtxt("../Data/ingredients.csv", delimiter=",",dtype="str",usecols=np.arange(0,14))
cols = dataset[0]

dataset = dataset[1:len(dataset)]
effectList = pc.effectExtractor(dataset)

a = sorted(effectList[0])
global ingredients,ingredientEffects
ingredients = pc.vectoriseIngredients(dataset,a)
ingredientEffects = a


potionEffects=np.genfromtxt("effectList.csv", delimiter=";",dtype="str",usecols=np.arange(0,10))
potionEffects = potionEffects[1:len(potionEffects)]
n = 4
models = [None]*n
xScalers = [None]*n
yScalers = [None]*n
graphs = [None]*n


loadColourModels()
#getIngredients()
