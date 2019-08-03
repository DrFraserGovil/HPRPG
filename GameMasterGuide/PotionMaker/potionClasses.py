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
import webcolors
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
		self.ColourName = "Ugly"
		self.Thickness = 3
		self.R = 74.0/255
		self.G = 65.0/255
		self.B = 42.0/755
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
		
		
	def DetermineVisuals(self,models,xscalers,yscalers):
		n = len(models)
		r = self.Effects
		r.append(self.Roll)
		inputVector = np.array([r])
		
		out = []
		for i in range(0,n):
			inputVectorScaled = xscalers[i].transform(inputVector)
			outputScaled= models[i].predict(inputVectorScaled,batch_size=len(inputVectorScaled))
			output = yscalers[i].inverse_transform(outputScaled) 
			
			rounded = round(output[0][0])
		
			out.append(output)
			
		self.R = out[0]

		self.G = out[1]
		self.B = out[2]
		self.Thickness = out[3]
		
		if self.R < 0:
			self.R = 0
		if self.R > 255:
			self.R = 255
		if self.G < 0:
			self.G = 0
		if self.G > 255:
			self.G = 255
		if self.B < 0:
			self.B = 0
		if self.B > 255:
			self.B = 255
		if self.Thickness < 0:
			self.Thickness = 0
		if self.Thickness > 3:
			self.R = 3
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
		
	def ColourSave(self):
		f = open("potionColours.csv","a+")
		txt = ""
		for val in self.Effects:
			txt += str(val) + ","
		txt+=str(self.Roll) + ","
		
		txt+=str(self.R) + ","
		txt+=str(self.G) + ","
		txt+=str(self.B) + ","
		
		txt+=str(self.Thickness)
		
		txt+="\n"
		f.write(txt)
		f.close()
		
	def ColourAccelerate(self):
		grossR = 74
		grossG = 65
		grossB = 42
		
		failRoll = float(self.Difficulty)/1.5
		k = 1
		interpBase = (np.exp(-k*failRoll) - np.exp(-k*self.Difficulty))
		betaR = (grossR - self.R)/interpBase
		betaG = (grossG - self.G)/interpBase
		betaB = (grossB - self.B)/interpBase
		
		alphaR = grossR - betaR*np.exp(-k*failRoll)
		alphaG = grossG - betaG*np.exp(-k*failRoll)
		alphaB = grossB - betaB*np.exp(-k*failRoll)
		for roll in range(1,30):
			obj = copy.deepcopy(self)
			obj.Roll = roll
			if roll < failRoll:
				obj.R = grossR
				obj.G = grossG
				obj.B = grossB
				obj.Thickness = 3
			else:
				if roll >= self.Difficulty:
					obj.R = self.R
					obj.G = self.G
					obj.B = self.B
				else:
					obj.R = alphaR + betaR*np.exp(-k*roll)
					obj.G = alphaG + betaG*np.exp(-k*roll)
					obj.B = alphaB + betaB*np.exp(-k*roll)
			obj.ColourSave()
	
	def QueryColour(self,info):
		#os.system('clear')
		#os.system('clear')
		os.system('cls')
		print (info)
		self.Roll = self.Difficulty
		self.AutoDetermine()
		q = textify(self,self.PotionStore)
		
			
		if q==0:
			self.Difficulty = 300
			self.ColourAccelerate()
			return 0
		while True:
			try:
				r = raw_input("What colour is this potion?\n\t")
			except:
				r = input("What colour is this potion?\n\t")
			
			if len(r)==0:
				return 0
			try:
				rgb = webcolors.name_to_rgb(r)
				self.R = rgb[0]
				self.G = rgb[1]
				self.B = rgb[2]
				
				break
			except:
				print("That was probably not a valid CSS3 colourname. Try again")
				
		while True:
			txt = "\nWhat thickness does this potion have?\n\t"
			colorCode = ["Transparent","Opaque","Thick","Congealing"] 
			for i in range(0,len(colorCode)):
				txt += str(i+1) + ": " + colorCode[i] + "\n\t"			
			try:
				r = raw_input(txt)
			except:
				r = input(txt)
				
			try:
				val = int(r)
				if val in range(1,len(colorCode)+1):
					self.Thickness = val-1
					self.ColourAccelerate()
					return True
				else:
					print("That was not a number between 1 and %s. Try again" % str(len(colorCode)+1))
			except:
				print("That was not a number between 1 and %s. Try again" % str(len(colorCode)+1))
		
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
	txt = ""
	if sum(potion.PotionOutcome)-potion.PotionOutcome[1] == 0:
		txt += "   This potion has no effect"
		return txt
	else:
		##mixer effects	
		
		trigger = False
		for j in range(0,len(potion.RandomEffects)):
			if len(potion.RandomEffects[j]) > 0:
				trigger =True
		
		if trigger:
			txt+="   The brewer of the potion:\n"
			for j in range(0,len(potion.RandomEffects)):
				if len(potion.RandomEffects[j]) > 0:
					txt+='\n    +' + potion.RandomEffects[j] 
		
		##Drinking effects
		txt+="\n\n\n\n"
		text = "The drinker of the potion:\n"
		
	
		rootDescriptionID = 8
		descriptionID = rootDescriptionID
	
		if potion.PotionOutcome[aerosolID] > 0:
			aerosolActive = True
			descriptionID = rootDescriptionID + 1
		if potion.PotionOutcome[detonateID] > 0:
			detonateActive = True
			descriptionID = rootDescriptionID + 1
		if (aerosolActive==False) and (detonateActive==False):
			txt+="   "+text
		if (detonateActive==True) and (aerosolActive==False):
			text = effects[detonateID][rootDescriptionID]
			txt += "   "+(text % potion.PotionOutcome[detonateID])

		if (aerosolActive==True) and (detonateActive==False):
	
			text = effects[aerosolID][rootDescriptionID]
			txt+="   "+(text % potion.PotionOutcome[aerosolID])
		
		if (aerosolActive==True) and (detonateActive==True):
			text = effects[detonateID][descriptionID]
			
			#print ("   "+(text % potion.PotionOutcome[detonateID]).decode('string_escape'))
			txt+="   "+(text % potion.PotionOutcome[detonateID])
			text = effects[aerosolID][descriptionID]
			txt+="   "+(text % potion.PotionOutcome[aerosolID])
			
		c = False
		for j in range(0,len(effects)):
			if potion.PotionOutcome[j] != 0 and j not in [detonateID,realDetonateID,aerosolID,0,1,2]:
				text = effects[j][descriptionID]
				if len(text) > 0:
					if "%" in text:
					
						txt+="\n    +"+(text % potion.PotionOutcome[j])
					else:
						txt+="    + "+text
					c = True
		if c == False:
			txt+="+ (No other effects)"
	
		return txt
				
	
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
		
		p = Potion(v,0,potionEffects)	
		p.QueryColour(info)
			#p.Save()
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
		p.QueryColour(info)

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
			p.QueryColour(info)
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
			p.QueryColour(info)
			


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
