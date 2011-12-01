

a = open('Class0','w') #Stationary
b = open('Class1','w') #Walking
c = open('Class2','w') #Running
d = open('Class3','w') #Biking
e = open('Class4','w') #Taking Bus

NUM_OF_FEATURES = 7
INPUT_FILE_NAME = "normFeatures"
with open(INPUT_FILE_NAME) as f:
	for line in f:
		seg = line.split(',')
		gt = int(seg[NUM_OF_FEATURES])# 
		
		#print gt
		if gt == 0:
			a.write(line)

		elif gt == 1:
			b.write(line)
		elif gt == 2:
			c.write(line)
		elif gt == 3:
			d.write(line)
		elif gt == 4:
			e.write(line)
		else:
			print "it won't happen."
	

a = open('Class0PCA','w') #Stationary
b = open('Class1PCA','w') #Walking
c = open('Class2PCA','w') #Running
d = open('Class3PCA','w') #Biking
e = open('Class4PCA','w') #Taking Bus

NUM_OF_FEATURES = 7
INPUT_FILE_NAME = "normFeaturesPCA"
with open(INPUT_FILE_NAME) as f:
	for line in f:
		seg = line.split(',')
		gt = int(seg[NUM_OF_FEATURES])# 
		
		#print gt
		if gt == 0:
			a.write(line)

		elif gt == 1:
			b.write(line)
		elif gt == 2:
			c.write(line)
		elif gt == 3:
			d.write(line)
		elif gt == 4:
			e.write(line)
		else:
			print "it won't happen."
	
