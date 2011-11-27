

a = open('class0','w')
b = open('class1','w')
c = open('class2','w')
d = open('class3','w')
e = open('class4','w')

NUM_OF_FEATURES = 4
INPUT_FILE_NAME = "features"
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
		elif gt ==4:
			e.write(line)
		else:
			print "it won't happen."
	
