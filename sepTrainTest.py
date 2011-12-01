import random

testing_fraction = 0.7

a0 = open('trainClass0','w')
b0 = open('testClass0','w')
with open("Class0") as f0:
	for line in f0:
		
		r = random.random()
		if r >= testing_fraction:
			a0.write(line)
		else:
			b0.write(line)


a1 = open('trainClass1','w')
b1 = open('testClass1','w')
with open("Class1") as f1:
	for line in f1:
		
		r = random.random()
		if r >= testing_fraction:
			a1.write(line)
		else:
			b1.write(line)
			
			
a2 = open('trainClass2','w')
b2 = open('testClass2','w')
with open("Class2") as f2:
	for line in f2:
		
		r = random.random()
		if r >= testing_fraction:
			a2.write(line)
		else:
			b2.write(line)
			
			
a3 = open('trainClass3','w')
b3 = open('testClass3','w')
with open("Class3") as f3:
	for line in f3:
		
		r = random.random()
		if r >= testing_fraction:
			a3.write(line)
		else:
			b3.write(line)
			
			
a4 = open('trainClass4','w')
b4 = open('testClass4','w')
with open("Class4") as f4:
	for line in f4:
		
		r = random.random()
		if r >= testing_fraction:
			a4.write(line)
		else:
			b4.write(line)
			
			
a0 = open('trainClass0PCA','w')
b0 = open('testClass0PCA','w')
with open("Class0PCA") as f0:
	for line in f0:
		
		r = random.random()
		if r >= testing_fraction:
			a0.write(line)
		else:
			b0.write(line)


a1 = open('trainClass1PCA','w')
b1 = open('testClass1PCA','w')
with open("Class1PCA") as f1:
	for line in f1:
		
		r = random.random()
		if r >= testing_fraction:
			a1.write(line)
		else:
			b1.write(line)
			
			
a2 = open('trainClass2PCA','w')
b2 = open('testClass2PCA','w')
with open("Class2PCA") as f2:
	for line in f2:
		
		r = random.random()
		if r >= testing_fraction:
			a2.write(line)
		else:
			b2.write(line)
			
			
a3 = open('trainClass3PCA','w')
b3 = open('testClass3PCA','w')
with open("Class3PCA") as f3:
	for line in f3:
		
		r = random.random()
		if r >= testing_fraction:
			a3.write(line)
		else:
			b3.write(line)
			
			
a4 = open('trainClass4PCA','w')
b4 = open('testClass4PCA','w')
with open("Class4PCA") as f4:
	for line in f4:
		
		r = random.random()
		if r >= testing_fraction:
			a4.write(line)
		else:
			b4.write(line)