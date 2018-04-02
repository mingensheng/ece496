#!/usr/bin/python
#import time
import os, sys, fnmatch
import shutil
from subprocess import Popen, PIPE

def invoke_klee():
	# invoke bytecode from "BC" folder
	bcfiles = []
	for path, dir, files in os.walk(os.path.abspath(os.getcwd()+"/bcfiles")):
		for filename in fnmatch.filter(files, "*.bc"):
			bcfiles.append(os.path.join(path, filename))
	print(bcfiles)
	if not os.path.exists("IOfiles"):
		os.mkdir("IOfiles")
	else:
		shutil.rmtree("IOfiles")
		os.mkdir("IOfiles")	

	for file in bcfiles:
		print(">>>>>>>>>>>>>>>>>>>>>>>>>> invoke klee on " + file)
		# use the aliased command instead of the alias "klee"
		command = "klee --libc=uclibc --posix-runtime " + file
#		command = "klee " + file
		process = Popen(command, shell=True, stdout=PIPE)
		outs, errs = process.communicate()
#		print(outs)
		print("$$$$$$$$$$$$$$$$$$$MY KLEE ERROR:")
		print(errs)
		
		testcases = []
		filepath, filename = os.path.split(file)
#		print(filepath)
		filepath = filepath + '/klee-last'
#		print(filepath)
		for path, dir, files in os.walk(os.path.abspath(filepath)):
			for filename in fnmatch.filter(files, "*.ktest"):
				testcases.append(os.path.join(path, filename))
#		print(testcases)		
		print(">> extract input-output pairs")
		filepath, filename = os.path.split(file)
		filename = str.split(filename, '.')[0][0:-1]
		print("filename: " + filename)
		# read test case input
		input=[]
		output=[]
		for i in range(len(testcases)):
			command1 = "ktest-tool " + testcases[i]
			process1 = Popen(command1, shell=True, stdout=PIPE, stderr=PIPE)
			outs1, errs1 = process1.communicate()
#			print(errs1)
			outs1=outs1.decode()
			fd = open("temp.txt", 'w')
			fd.write(outs1)
			fd.close()
			inputArgs = getInputData()
			input.append(inputArgs)
			#replay tese case to get output
			command2 = "make -s replay MAIN="
			command2 += filename + ";"
			#command2+= " -lkleeRuntest;"
			command2 += "KTEST_FILE="+testcases[i]+" ./a.out;"
			command2 += "echo $?;"
			print(command2)	
			process2 = Popen(command2, shell=True, stdout=PIPE, stderr=PIPE)
			outs, errs = process2.communicate()
#			print("direct outs:")
#			print(outs)
			outs = outs.decode()
#			print("raw:"+outs)
			testOut = getOutputData(outs)
#			print(errs)
			print("after:::"+testOut)
			output.append(testOut)

#		print input
		print(">> input-output pairs num %d"%len(testcases))
		outFilename = "IOfiles/" + filename + ".txt"

		fd = open(outFilename, 'w')
		fd.write(str(len(testcases)) + '\n')
		for i in range(len(testcases)): 
#			fd.write("test %d\n"%i)
#			fd.write("input:")
			for _list in input[i]:
				for _str in _list:
					fd.write(_str)
				fd.write("\n")
			fd.write("output:")
			fd.write(output[i])
			fd.write("\n")
		fd.close()
	#	command3 = "KTEST_FILE=klee/last/test000001.ktest ./a.out"
		print("************************** klee execution on " + file + " done")
#		return

def getInputData():
	fd = open("temp.txt",'r')
	line = fd.readline()
	objects = []
	while line:
		if "data:" in line:
			args = line.split("data: ")
			objects.append(args[-1])	 
		line = fd.readline()
	#print(">>>>>>>>>>before>>>>>>>objects:")
	#print(objects)
	newStr = []
	for value in objects:
		newStr.append(value[2:-2].replace("\\x", ""));
	#print(">>>>>>>>after>>>>>>>objects:")
	#print(newStr)
	return newStr[1:]

def getOutputData(printout):
#	print("before replace:"+printout)
	printout = printout.split('\n')[0]
#	print("after replace:"+printout)
	output = printout.split("output:")
#	print("after split:"+output[-1])
	return output[-1]

if __name__ == "__main__":
	invoke_klee()
	#print "return code:" + rc
