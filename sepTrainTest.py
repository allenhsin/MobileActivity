import random

training_feaction = 0.5

a0 = open('trainClass0','w')
b0 = open('testClass0','w')
with open("Class0") as f0:
	for line in f0:
		
		r = random.random()
		if r >= training_feaction:
			a0.write(line)
		else:
			b0.write(line)


a1 = open('trainClass1','w')
b1 = open('testClass1','w')
with open("Class1") as f1:
	for line in f1:
		
		r = random.random()
		if r >= training_feaction:
			a1.write(line)
		else:
			b1.write(line)
			
			
a2 = open('trainClass2','w')
b2 = open('testClass2','w')
with open("Class2") as f2:
	for line in f2:
		
		r = random.random()
		if r >= training_feaction:
			a2.write(line)
		else:
			b2.write(line)
			
			
a3 = open('trainClass3','w')
b3 = open('testClass3','w')
with open("Class3") as f3:
	for line in f3:
		
		r = random.random()
		if r >= training_feaction:
			a3.write(line)
		else:
			b3.write(line)
			
			
a4 = open('trainClass4','w')
b4 = open('testClass4','w')
with open("Class4") as f4:
	for line in f4:
		
		r = random.random()
		if r >= training_feaction:
			a4.write(line)
		else:
			b4.write(line)