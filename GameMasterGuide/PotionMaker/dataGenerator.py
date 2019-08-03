import pandas as pd
import numpy as np
import copy
import os
import math
from keras.models import Sequential
from keras.layers import Dense
from keras.wrappers.scikit_learn import KerasRegressor
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import KFold
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import MinMaxScaler
from sklearn.model_selection import train_test_split
import potionClasses as pc

dataset=np.genfromtxt("../Data/ingredients.csv", delimiter=",",dtype="str"	,usecols=np.arange(0,14))
cols = dataset[0]

dataset = dataset[1:len(dataset)]
effectList = pc.effectExtractor(dataset)

a = sorted(effectList[0])
z = [x for _,x in sorted(zip(*effectList))]
effectList[0] = a
effectList[1] = z
# ~ for x, y in zip(*effectList): 
    # ~ print(x, y) 
# ~ print("There are %d effects" % len(effectList[0]))
global ingredients,ingredientEffects
ingredients = pc.vectoriseIngredients(dataset,a)
ingredientEffects = a


potionEffects=np.genfromtxt("effectList.csv", delimiter=";",dtype="str")
potionEffects = potionEffects[1:len(potionEffects)]
print(potionEffects)
# ~ for i in range(10):
	# ~ x = input("Ingredient1:\n\t")
	# ~ y = input("Ingredient2:\n\t")
	# ~ z = input("Ingredient3:\n\t")
	# ~ r = [x,y,z]
	# ~ v = []
	# ~ for id in r:
		# ~ v.append(ingredients[id])
	# ~ p = Potion(v,0,potionEffects)		
	# ~ p.QueryEffects()
	
#pc.generatePresets(ingredients,potionEffects)
pc.generateRandomPotions(ingredients,potionEffects,200)
#
