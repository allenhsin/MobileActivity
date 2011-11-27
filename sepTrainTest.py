a = open('train','w')
b = open('test','w')

with open("features") as f:
	for line in f:
		
		r = random.random()
		if r >= 0.5:
			a.write(line)
		else:
			b.write(line)

