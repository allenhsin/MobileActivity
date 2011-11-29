train = open('train','w')
test  = open('test' ,'w')

INPUT_FILE_NAME0 = "trainClass0"
INPUT_FILE_NAME1 = "trainClass1"
INPUT_FILE_NAME2 = "trainClass2"
INPUT_FILE_NAME3 = "trainClass3"
INPUT_FILE_NAME4 = "trainClass4"
with open(INPUT_FILE_NAME0) as f0:
	for line in f0:
		train.write(line)
with open(INPUT_FILE_NAME1) as f1:
	for line in f1:
		train.write(line)
with open(INPUT_FILE_NAME2) as f2:
	for line in f2:
		train.write(line)
with open(INPUT_FILE_NAME3) as f3:
	for line in f3:
		train.write(line)
with open(INPUT_FILE_NAME4) as f4:
	for line in f4:
		train.write(line)		



INPUT_FILE_NAME0 = "testClass0"
INPUT_FILE_NAME1 = "testClass1"
INPUT_FILE_NAME2 = "testClass2"
INPUT_FILE_NAME3 = "testClass3"
INPUT_FILE_NAME4 = "testClass4"
with open(INPUT_FILE_NAME0) as f0:
	for line in f0:
		test.write(line)
with open(INPUT_FILE_NAME1) as f1:
	for line in f1:
		test.write(line)
with open(INPUT_FILE_NAME2) as f2:
	for line in f2:
		test.write(line)
with open(INPUT_FILE_NAME3) as f3:
	for line in f3:
		test.write(line)
with open(INPUT_FILE_NAME4) as f4:
	for line in f4:
		test.write(line)

