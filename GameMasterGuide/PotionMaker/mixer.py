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
	print "Chunk model for %d->%d" % (start,end)
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
	print "Chunk model for %d->%d" % (start,n)
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

	print "\n\n Models Loaded. Initialising Learner"
	mixPotion([0,1,2],5,False)


def randomBad(potion):
	
	badEffects=np.genfromtxt("badEffects.csv", delimiter=";",dtype="str",usecols=np.arange(0,3))
	badEffects = badEffects[1:len(badEffects)]
	badStart = 0
	badEnd = len(badEffects)
	badUsed = [-1]
	s = potion.PotionOutcome[0]
	while potion.PotionOutcome[0] > 0:
		x = -1
		while x in badUsed:
			x = np.random.randint(badStart,badEnd)
		badUsed.append(x)
		
		potion.PotionOutcome[0] = potion.PotionOutcome[0] - 1
		
		text = badEffects[x][2]
		explodeID = 0
		nilID = 1
		if x == explodeID:
			potion.Catalyse +=100
		if x == nilID:
			n = len(potion.PotionOutcome);
			new = [0]*n
			potion.PotionOutcome = new
			s = 0
		
		
		potion.RandomEffects.append(text)	
	potion.PotionOutcome[0] = s
	return potion

def randomGood(potion):
	
	goodEffects=np.genfromtxt("goodEffects.csv", delimiter=";",dtype="str",usecols=np.arange(0,3))
	goodEffects = goodEffects[1:len(goodEffects)]
	goodStart = 0
	goodEnd = len(goodEffects)
	goodUsed = [-1]
	s = potion.PotionOutcome[1]
	while potion.PotionOutcome[1] > 0:
		x = -1
		while x in goodUsed:
			x = np.random.randint(goodStart,goodEnd)
		goodUsed.append(x)
		
		potion.PotionOutcome[1] = potion.PotionOutcome[1] - 1
		healID = 0
		skillID = 2
		ingID = 7
		safeID = 8
		text = goodEffects[x][2]
		
		if x == healID:
			hpID = 67
			fpID = 66
			potion.PotionOutcome[hpID] =2*potion.PotionOutcome[hpID]
			potion.PotionOutcome[fpID] =2*potion.PotionOutcome[fpID]
		if x==skillID:
			s1ID = 45
			s2ID = 51
			for i in range(s1ID,s2ID+1):
				potion.PotionOutcome[i] =2*potion.PotionOutcome[i]
		if x==ingID:
			y = np.random.randint(0,len(potion.Ingredients))
			iName = potion.Ingredients[y].Name
			text = text % iName
		if x==safeID:
			potion.Catalyse = potion.Catalyse/8
		potion.RandomEffects.append(text)	
	potion.PotionOutcome[1] = s
	return potion
		

def textify(potion,effects):
	aerosolID = 8
	aerosolActive = False
	detonateActive = False
	detonateID = 33
	
	potion = randomBad(potion)
	potion = randomGood(potion)
	realDetonateID = detonateID
	explodeOnTheSpot = False
	r = np.random.randint(0,100)
	if r < potion.Catalyse:
		explodeOnTheSpot = True
		
		explode = potion.PotionOutcome[detonateID] + float(potion.Catalyse)/20
		detonateID = 2
		potion.PotionOutcome[detonateID] = explode
	if sum(potion.PotionOutcome)-potion.PotionOutcome[1] == 0:
		print ("   This potion has no effect")
	else:
		##mixer effects	
		
		trigger = False
		for j in range(0,len(potion.RandomEffects)):
			if len(potion.RandomEffects[j]) > 0:
				trigger =True
		
		if trigger:
			print "   The brewer of the potion:\n"
			for j in range(0,len(potion.RandomEffects)):
				if len(potion.RandomEffects[j]) > 0:
					print '\t\t+' + potion.RandomEffects[j] 
		
		##Drinking effects
		print "\n\n"
		text = "The drinker of the potion:"
		
	
		rootDescriptionID = 8
		descriptionID = rootDescriptionID
	
		if potion.PotionOutcome[aerosolID] > 0:
			aerosolActive = True
			descriptionID = rootDescriptionID + 1
		if potion.PotionOutcome[detonateID] > 0:
			detonateActive = True
			descriptionID = rootDescriptionID + 1
		if (aerosolActive==False) and (detonateActive==False):
			print "   "+text
		if (detonateActive==True) and (aerosolActive==False):
			text = effects[detonateID][rootDescriptionID]
			print "   "+(text % potion.PotionOutcome[detonateID]).decode('string_escape')
		if (aerosolActive==True) and (detonateActive==False):
	
			text = effects[aerosolID][rootDescriptionID]
			print "   "+(text % potion.PotionOutcome[aerosolID]).decode('string_escape')
		if (aerosolActive==True) and (detonateActive==True):
			text = effects[detonateID][descriptionID]
			print (text % potion.PotionOutcome[detonateID]).decode('string_escape')
			text = effects[aerosolID][descriptionID]
			print "   "+(text % potion.PotionOutcome[aerosolID]).decode('string_escape')
		c = False
		for j in range(0,len(effects)):
			if potion.PotionOutcome[j] != 0 and j not in [detonateID,realDetonateID,aerosolID,0,1,2]:
				text = effects[j][descriptionID]
				if len(text) > 0:
					if "%" in text:
						print ("\t\t+ "+text % potion.PotionOutcome[j]).decode('string_escape')
					else:
						print "\t\t+ "+text
					c = True
		if c == False:
			print "\t\t (No other effects)"
		

		
		
def potion(idVector,roll,printVal=True):
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
	head = ("="*20)
	print "\n\n" + (head*6)
	print "Mixing potion with ingredients: ",
	for i in ingVec:
		print i.Name + ", ",
	print "with a roll of %d\n" % roll
	
	p = pc.Potion(ingVec,roll,potionEffects)
	p.AutoDetermine()
	if printVal:
		#p.display(True)
		textify(p,potionEffects)
	print  "\n" + (head*6)
	
	return p
def getIngredients():
	
	str_arr = raw_input("Enter potion ingredient IDs, separated by a comma. Potions have between 2 and 5 ingredients, and cannot be repeated:\n\t").split(',') #will take in a string of numbers separated by a space
	arr = [int(num) for num in str_arr]
	print arr

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
n = len(potionEffects)
models = [None]*n
xScalers = [None]*n
yScalers = [None]*n
graphs = [None]*n

pEffect = potionEffects[0][1]

#joblib.load("Models/"+pEffect+".mdl")
#loadModels()
#getIngredients()
