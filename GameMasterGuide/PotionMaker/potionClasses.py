import pandas as pd
import numpy as np
import copy
import os
import math
import time
from keras.models import Sequential
from keras.layers import Dense
from keras.wrappers.scikit_learn import KerasRegressor
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import KFold
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import MinMaxScaler
from sklearn.model_selection import train_test_split
import operator as op
global ingredientEffects
from functools import reduce
import copy
def nCr(n, r):
    r = min(r, n-r)
    numer = reduce(op.mul, range(n, n-r, -1), 1)
    denom = reduce(op.mul, range(1, r+1), 1)
    return numer / denom
class Potion:
	def __init__(self,ingredientVector,roll,potionEffects):
		self.Ingredients = ingredientVector
		self.Roll = roll
		self.Difficulty = 0
		self.PotionStore = potionEffects
		self.RandomEffects= []
		self.ColourName = "Clear"
		effects = [0]*len(ingredientVector[0].Vector)
		countPlus = [0]*len(ingredientVector[0].Vector)
		countNeg =  [0]*len(ingredientVector[0].Vector)
		self.Catalyse = 0
		for ing in ingredientVector:
			self.Difficulty += ing.Cost
			for i in range(0,len(ing.Vector)):
				if ing.Vector[i] != 0:
					effects[i]+=ing.Vector[i]
					if ing.Vector[i] > 0:
						countPlus[i] += 1
					else:
						countNeg[i] += 1
		for j in range(0,len(effects)):
			multVec = [0.5,1.0,3.0,4.0,5.0,6.0]
			f = effects[j]
			cplus = countPlus[j]
			cminus = countNeg[j]
			mult = multVec[ int(abs(cplus - cminus))]
			
			if f > 0:
				if cplus >= cminus:
					f = f*mult
				else:
					f = f/mult
			else:
				if cplus > cminus:
					f = f/mult
				else:
					f = f*mult
			effects[j] = f
		self.Effects = effects
		
		self.PotionOutcome = [0]*(len(potionEffects))
		self.ScaledOutcome = [0]*(len(potionEffects))
	def DetermineEffects(self,models,xscalers,yscalers):
		self.display(False)
		n = len(models)
		r = self.Effects
		r.append(self.Roll)
		inputVector = np.array([r])
		t = time.time()
		for i in range(0,n):
			pName = self.PotionStore[i][1]
			#print ("Predicting potion value for %s...." % pName)
			inputVectorScaled = xscalers[i].transform(inputVector)
			outputScaled= models[i].predict(inputVectorScaled,batch_size=len(inputVectorScaled))
			#invert normalize
			output = yscalers[i].inverse_transform(outputScaled) 
			#print "value = %f" % output 
			
			rounder = int(self.PotionStore[i][3])
			
			minVal = float(self.PotionStore[i][4])
			outcome = round(output,rounder)
			self.PotionOutcome[i] = outcome
			self.ScaledOutcome[i] = outputScaled
			if outcome < minVal:
				self.PotionOutcome[i] = 0
				self.ScaledOutcome[i]
		#print "Potion effects determined"
	def display(self,showVec):
		self.displayIngredients()
		
		if showVec:
			print("\nTherefore, the effects vector is:\n")
			eList = self.Ingredients[0].EList
			r = range(0,len(eList))
			z = np.absolute(self.Effects)
			r = [x for _,x in sorted(zip(z,r))]
			r.reverse()
			for i in r:
				if self.Effects[i] != 0:
					print( "\t%s (%d)" %(eList[i],self.Effects[i])),
			
			print("\nMixing difficulty is: %d" % self.Difficulty)
		s = self.NonZeroEffects()
		if len(s) > 0:
			print ("\n\nPotion Effects:\n\t\t" + s)
		else:
			print("\n\n Potion has no effect")
		
	def Accelerate(self, effectID,roundingValue,minValue):

		goodRandomID = 1
		badRandomID = 0
		volatileID = 2
		freezeID = 3
		fWeakID = 4
		cWeakID = 5
		igniteID = 6
		
		
		roll = self.Roll
		x = float(roll)/self.Difficulty
		
		modifier = x - 1.0/(2*np.pi)*np.sin(2*np.pi*x) 
		maxMod = 2
		if effectID in [goodRandomID,badRandomID]:
			if (modifier < 1) and (modifier > 0):

				amount = math.ceil(0.5/(modifier))
				if amount > 2:
					amount =2
				self.PotionOutcome[badRandomID] = amount
			if modifier >= 1.5:
				amount = round(2*(modifier - 0.9),0)
				#
				if amount > 2:
					amount = 2
				self.PotionOutcome[goodRandomID] = amount
		if effectID not in [goodRandomID, badRandomID,volatileID]:
			# roll modifier
			
			if modifier <= 0.5:
				modifier = 0
			if modifier > maxMod:
				modifier = maxMod
			self.PotionOutcome[effectID]=float(self.PotionOutcome[effectID])*modifier
			
			#catalyse modifier
			catalyseCutoff = 10
			if self.Catalyse >= catalyseCutoff:
				catalyser = 1.0 + float(self.Catalyse)/50
				self.PotionOutcome[effectID]=float(self.PotionOutcome[effectID])*catalyser
		
		if effectID in [freezeID,fWeakID,cWeakID,igniteID]:
			centre = 20
			if effectID in [freezeID,igniteID]:
				centre = 40
			x = self.Catalyse
			modifier = 1.0/(1.0 + np.exp(-0.6*(x - centre)))
			self.PotionOutcome[effectID] = modifier*self.PotionOutcome[effectID]
			
		## Round to specified value
		eff = round(self.PotionOutcome[effectID],roundingValue)
		if eff < minValue:
			eff = 0
		self.PotionOutcome[effectID] = eff
		
		
	def AutoDetermine(self):
		
		potionAssociates = [-1]*len(self.PotionStore)
		ingNames = [None]
		for i in range(0,len(self.PotionStore)):
			
			effectLine = self.PotionStore[i]
			effectName = effectLine[1]
			associateName = effectLine[5].replace(' ','')

			associateID = -1
			if associateName in ingredientEffects:
			
				associateID = ingredientEffects.index(associateName)
				
				associatedEffect = self.Effects[associateID]
				
				extractedSign = int(effectLine[6])
				associatedSign = np.sign(associatedEffect)
				if i ==2:
					self.Catalyse = associatedEffect
				if (extractedSign == 0) or (extractedSign == associatedSign):
					associatedEffect = abs(associatedEffect)
					
					modifier = float(effectLine[7])
					criticalCutoff = 8
					if associatedEffect > criticalCutoff:
						self.PotionOutcome[i] = associatedEffect*modifier
						
						rounder = int(effectLine[3])
						minVal = float(effectLine[4])
						self.Accelerate(i,rounder,minVal)

			else:
				if i not in [0,1]:
					self.PotionOutcome[i] = 0
				else:
					rounder = int(effectLine[3])
					minVal = float(effectLine[4])
					self.Accelerate(i,rounder,minVal)
			
	def displayIngredients(self):
		
		print("The Ingredients are:\n")
		
		nIng = len(self.Ingredients)

		q = [['']*nIng]

		for i in range(nIng):
			ing = self.Ingredients[i]
			vec = ing.displayVec()
			for j in range(0,len(vec)):
				if j >= len(q):
					q.append(['']*nIng)
				q[j][i] = vec[j]


		lens = []
		for col in zip(*q):
			lens.append(max([len(v) for v in col])+8)
		format = "  ".join(["{:>" + str(l) + "}" for l in lens])
		for row in q:
			print(format.format(*row))
			
	def QueryEffects(self,info):
		while True:
			os.system('clear')
			os.system('clear')
			print (info)
			self.display(True)
			
			print("\nWhat effect does this potion have?\n")
			
			f = raw_input("Type in the name of the effect to modify it (or type 'clear' to clear selection, 'q' to quit and 's' to save):\n\t")
			if f.lower() == 'q':
				exit()
			if f.lower() == 's':
				self.RollIterate()
				break
			if f.lower() == 'clear':
				self.PotionOutcome = [0]*(len(self.PotionStore))
			id = -10
			##try to interpret as integer ID
			try:
				id = int(f)
			except:
				j = 0
				for i in self.PotionStore:
					if f.lower() == self.PotionStore[j][1].lower():
						id = j

						break
					j+=1
				
			if id != -10:
				r = raw_input("New value for ``%s'' effect of potion (%s): \n\t" % (self.PotionStore[id][1], self.PotionStore[id][2]))
				if r.lower() == 'q':
					exit()
				if r.lower() == 's':
					self.RollIterate()
					break
				try:
					newVal = float(r)
					self.PotionOutcome[id] = newVal
				except:
					pass
				
		#save?

	def NonZeroEffects(self):
		eList = self.PotionStore
		s = ""
		for i in range(0,len(eList)):
			if self.PotionOutcome[i] != 0:
				s += "\t%s (%f)" %(eList[i][1],self.PotionOutcome[i])

		return s
		
		
	def PowerOrderer(self):
		eList = self.PotionStore
		pList = range(0,len(self.ScaledOutcome))
		self.PotionOutcome = [x for _,x in sorted(zip(self.ScaledOutcome,self.PotionOutcome))]
		
	
	def RollIterate(self):
		for roll in range(1,30):
			obj = copy.deepcopy(self)
			obj.Roll = roll
			goodRandomID = 1
			badRandomID = 0
			modifier = float(roll)/obj.Difficulty
			if modifier < 0.5:
				obj.PotionOutcome = [0]*(len(self.PotionStore))
				
				amount = math.ceil(1.0/(modifier + 0.2))
				obj.PotionOutcome[badRandomID] = amount

			if modifier > 2:
				amount = math.floor(2.0*(modifier - 2))
				
				modifier = 2
				obj.PotionOutcome[goodRandomID] = amount
				
			for i in range(0,len(obj.PotionOutcome)):
				if (i!=badRandomID) and (i!=goodRandomID):
					obj.PotionOutcome[i]=float(obj.PotionOutcome[i])*modifier
			
			
			obj.Save() 
	
	def Save(self):
		f = open("potionSet.csv","a+")
		txt = ""
		for val in self.Effects:
			txt += str(val) + ","
		txt+=str(self.Roll) + ","
		i = 1
		n = len(self.PotionOutcome)
		for val in self.PotionOutcome:
			txt+=str(val) 
			if i < n:
				txt+=","
		txt+="\n"
		f.write(txt)
		f.close()
			
class Ingredient:
	def initialiseVector(self,entry,effectList):
		print("Initialising %s" % self.Name)
		a = [0]*len(effectList)
		self.Vector = a
		i = 3
		while (len(entry[i]) > 2) and (i < 10):
			effectName = entry[i].replace(' ','')
			effectID = effectList.index(effectName)
			self.Vector[effectID] += int(entry[i+1])
			self.Cost = int(entry[12])
			i+=2
		
	def __init__(self,entry,effectList):
		self.ID = int(entry[0])
		self.Name = entry[1]
		self.EList = effectList
		self.initialiseVector(entry,effectList)
	def displayVec(self):
		r = [self.Name + ":"]
		for i in range(0,len(self.EList)):
			if self.Vector[i] != 0:
				r.append( "%s (%d)" %(self.EList[i],self.Vector[i]))
				
		return r
			
	
def potionSlider(ingredientVector,potionEffects,Npotions):
	step = 0
	r = []
	N = np.random.randint(2,6)
	while step < Npotions:
		
		
		while len(r) < N:
			x = np.random.randint(0,len(ingredientVector))
			if x not in r:
				r.append(x)
		v = []
		for id in r:
			v.append(ingredientVector[id])
		info = "Potion Slider, %d of %d" %	(step+1,Npotions)
		p = Potion(v,0,potionEffects)	
		#p.QueryEffects(info)
		for roll in range(1,35):
			p = Potion(v,roll,potionEffects)	
			p.AutoDetermine()
			p.Save()
		r.pop(0)

		step+=1
def totalRandom(ingredientVector,potionEffects,Npotions):
	for i in range(0,Npotions):
		r = []
		N = np.random.randint(2,5)
		while len(r) < N:
			x = np.random.randint(0,len(ingredientVector))
			if x not in r:
				r.append(x)
		v = []
		for id in r:
			v.append(ingredientVector[id])
		info = "Random potion, %d of %d" %	(i+1,Npotions)
		p = Potion(v,0,potionEffects)	
		#p.QueryEffects(info)
		for roll in range(1,35):
			p = Potion(v,roll,potionEffects)	
			p.AutoDetermine()
			p.Save()

def iterator(ingredientVector,potionEffects,Niters):
	stepPerIter = 5
	for i in range(0,Niters):
		N = np.random.randint(2,5)
		r = []
		while len(r) < N-1:
			x = np.random.randint(0,len(ingredientVector))
			if x not in r:
				r.append(x)
		for s in range(0,stepPerIter):
			x = r[0]
			while x in r:
				x = np.random.randint(0,len(ingredientVector))
			v = []
			for id in r:
				v.append(ingredientVector[id])
			v.append(ingredientVector[x])
			p = Potion(v,0,potionEffects)	
			info = "Potion Iterator, iteration %d of cycle %d (of %d)" %	(s+1,i+1,Niters)
			#p.QueryEffects(info)
			for roll in range(1,35):
				p = Potion(v,roll,potionEffects)	
				p.AutoDetermine()
				p.Save()

def effectIterator(ingredientVector, potionEffects,Niters):
	stepPerIter = 5
	for i in range(0,Niters):
		nSame = np.random.randint(2,4)
		N = np.random.randint(nSame+1,5)
		nAdd = N - nSame
		
		effectChoose = np.random.randint(2,len(ingredientVector[0].Vector) - 1)
		
		#generate between 2 and 4 potions with same effect
		basePotion = -1
		for j in range(0,len(ingredientVector)):
			ing = ingredientVector[j]
			if ing.Vector[effectChoose] !=0:
				basePotion = j
				target = ing.Vector[effectChoose]
				pEffect = ing.EList[effectChoose]
				break
		r = [basePotion]
		b = 0
		
		while len(r) < nSame:
				id = -1
				for j in range(0,len(ingredientVector)):
					ing = ingredientVector[j]
					effect = ing.Vector[effectChoose]
					if (effect !=0) and (np.sign(effect) == np.sign(target)):
						id = j
						if id not in r:
							r.append(id)
							break
						else:
							id = -1
				if id == -1:
					print ("Could not find another effect, quitting at length %d" % len(r))
					break
		for s in range(0,stepPerIter):
			q = []
			while len(q) < nAdd:
				x = np.random.randint(0,len(ingredientVector))
				if (x not in r) and (x not in q):
					q.append(x)
			v = []
			for id in r:
				v.append(ingredientVector[id])
			for id in q:
				v.append(ingredientVector[id])
			p = Potion(v,0,potionEffects)	
			info = "%s Iterator, iteration %d of cycle %d (of %d)" %	(pEffect,s+1,i+1,Niters)
			#p.QueryEffects(info)
			for roll in range(1,35):
				p = Potion(v,roll,potionEffects)	
				p.AutoDetermine()
				p.Save()


def includeEffect(effect,effectList):
	effect = effect.replace(' ','')
	if effect in effectList[0]:
		id = effectList[0].index(effect)
		effectList[1][id] += 1
	else:
		effectList[0].append(effect)
		effectList[1].append(1)
	return effectList
	
def effectExtractor(dataset):
	effects = []
	effect1ID = 3
	nEffects = 4
	finalID = effect1ID + nEffects*2
	effectList = [[], []]
	for entry in dataset:
		effects = entry[effect1ID:finalID]
		for effect in effects:
			
			if len(effect) > 0:
				try:
					s = int(effect)
				except:
					effectList = includeEffect(effect,effectList)
	return effectList
	
def vectoriseIngredients(dataset,effects):
	ingredientList = []
	for ingredient in dataset:
		r = Ingredient(ingredient,effects)
		ingredientList.append(r)
	return ingredientList


def generateRandomPotions(ingredients,potionEffects,Ntotal):
	v = []
	while sum(v) < Ntotal:
		a = np.random.randint(2,10)
		v.append(a)
	step = 1
	for steps in v:
		print ("Step %d" % step)
		step +=1
		roll = np.random.random()
		if roll < 0.25:
			#effectIterator(ingredients,potionEffects,steps)
			potionSlider(ingredients,potionEffects,steps)
		else:
			if roll < 0.5:
				totalRandom(ingredients,potionEffects,steps)
			else:
				if roll < 0.75:
					iterator(ingredients,potionEffects,steps)
				else:
					effectIterator(ingredients,potionEffects,steps)

def justThem(ingredients,allIngredients,effects,eName):
	
	n = len(ingredients)

	r = 2
	while (r <= n) and (r < 6):
		cyclesN = nCr(n,r)
		if cyclesN > 3:
			cyclesN = 3
		selectArray = []
		while len(selectArray) < cyclesN:
			q = []
			while len(q) < r:
				x = np.random.randint(0,n)
				if x not in q:
					q.append(x)
			q.sort()
			if q not in selectArray:
				selectArray.append(q)
		
		for entry in selectArray:
			v = []
			for id in entry:
				v.append(ingredients[id])
			
			#p.QueryEffects("Preset Training for %s" % eName)
			for roll in range(1,35):
				p = Potion(v,roll,effects)	
				p.AutoDetermine()
				p.Save()
		r+=1
	




global ingredients,ingredientEffects
dataset=np.genfromtxt("../Data/ingredients.csv", delimiter=",",dtype="str",usecols=np.arange(0,14))
cols = dataset[0]

dataset = dataset[1:len(dataset)]
effectList = effectExtractor(dataset)

a = sorted(effectList[0])
global ingredients,ingredientEffects
ingredients = vectoriseIngredients(dataset,a)
ingredientEffects = a
