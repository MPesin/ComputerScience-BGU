# -*- coding: utf-8 -*-
# coding=utf8
import sys
import codecs
import glob
import math
import os
from operator import itemgetter
from shutil import copy2

# ====================== Doc Vector Object ======================

class Doc_Vector:
	
	# Optional: check text for hebrew words only
	def check_t_hebrew (self,term):
		if len(term) > 1:
			return all("\u05D0" <= c <= "\u05EA" for c in term)
		return False
	

	# Returns number of appearances of word 'w' in the document
	# If the word doesn't appear in the document Returns 0
	def word_count(self, w):
		if w in self.word_vector:
			return self.word_vector[w]
		else:
			return 0

	# Adds +1 to the counter of word 'term' in document to the word_vector
	def update_word_vector (self, term):
		if term in self.word_vector:
			self.word_vector[term] += 1
		else:
			self.word_vector[term] = 1

	# Returns the size of the document = Total number of words in document
	def get_size(self):
		lenth = 0
		for word in self.word_vector:
			lenth += self.word_vector[word]
		return lenth

	# Constructor for Doc_Vector, Recieves a path to a document and creates a Doc_Vector Object. 
	'''
	Variabels:
		word_vector <word, number_of_appearances_in_doc> : holds all the words and their counters.
		doc_name : the name of the file.
		size : the document length = amount of words.
	'''
	def __init__(self, path):
		self.word_vector = dict()
		self.doc_name = os.path.basename(path)
		with codecs.open (path, 'r',encoding="utf8" ) as doc:
			for line in doc:
				line_words = line.split()
				if len(line_words) > 1:
					term = line_words[1]					
					if self.check_t_hebrew(term):
						self.update_word_vector(term)
		self.size = self.get_size()

# ====================== Global Variables ======================

docs_num = 0
docs_vector = dict()
word_dictionary = dict()
docs_comp = dict()
idf_dict = dict()
avgbl = 0

# Constants: 
k = 0.75
b = 1.6

# ====================== Global Variables ======================

# Scan  all files in Folder
# *also updates the docs_num
def get_docs_list (folder_path):	
	global docs_num
	g_scan_path = folder_path + "/*.txt"
	docs_list = glob.glob(g_scan_path)
	docs_num = len(docs_list)
	return docs_list

# ====================== Build dictionaries ======================

# Builds the docs_vector <file_name, Doc_Vector(file_name)>
def build_vectors(folder_path):
	files = get_docs_list(folder_path)
	for file in files:
		name = os.path.basename(file)
		docs_vector[name] = Doc_Vector(file)	

# ====================== Calculation of similarities with bm25 formula ======================

# Idf formula
# Returns the idf value of integer 'count'
def idf (count):
	return math.log((docs_num + 1)/count)

# Updates the Value field of Dictionary 'dic' to the idf value of the word in the Key position
def update_to_idf (dic):
	for term in dic:
		value = dic[term]
		dic[term] = idf(value)

# Buildes a Dictionary <word, word_count_in_doc> for all the different words in all the documents.
# After build it updates the word_count_in_doc to the idf(word_count_in_doc) value
# Returns Dictionary <word, word_idf_value>
def bulid_idf_table():
	if not bool(docs_vector):
		return {}
	word_idf = dict()
	for file in docs_vector:
		for word in docs_vector[file].word_vector:
			if word in word_idf:
				word_idf[word] += 1
			else:
				word_idf[word] = 1

	update_to_idf(word_idf)
	return word_idf

# Returns the 'avglb' value for the bm25 formula
def get_avglb():
	global avgbl
	if avgbl != 0:
		return avgbl
	else:
		total = 0
		for doc in docs_vector:
			total += docs_vector[doc].size
		avgbl = total / docs_num
		return avgbl

# Returns the tf formula value of word 'w' and document 'D'
def tf (w, D):
	c = D.word_count(w)
	return (c * (k + 1))/(c + k * ( 1 + b + b * (D.size/get_avglb())))

# Returns the idf value of word 'w'
def get_idf(w):
	if w in idf_dict:
		return idf_dict[w]
	else:
		return 0

# Returns the result of the similarity between document 'vec' and 'doc'
def bm25(vec, doc):
	sim = 0
	for word in vec.word_vector:
		if word in doc.word_vector:
			sim += vec.word_vector[word] * tf(word, doc) * get_idf(word)
	return sim

# Compare all files in the Data Base directory and calculate their bm25 value
def compr (file):
	global vec
	print ("Comparing, Please wait...")
	vec = Doc_Vector(file)
	for doc in docs_vector:
		docs_comp[doc] = bm25(vec, docs_vector[doc])
	print ("Finished Comparing!")


# ====================== Service Functions ======================

# Print most similar 'num' documents to the input document
def print_first(num):
	if docs_comp == {}:
		print ("Please compare a document first")
	else:
		for key in sorted(docs_comp.items(), key= itemgetter(1), reverse = True)[:num]:
			print ("{} : {}".format(key[0][::-1], key[1]))

# Copy most similar 'num' documents to dictionary Max_'num'
def copy_first(num):
	if docs_comp == {}:
		print ("Please compare a document first")
	else:
		target_path = "Max_{}".format(num)
		if not os.path.exists(target_path):
			os.makedirs(target_path)
		print("Copying to", target_path)
		for key in sorted(docs_comp.items(), key= itemgetter(1), reverse = True)[:num]:
			file_path = r"{}/{}".format(f_name, key[0])
			copy2 (file_path, target_path)


# User Manu
def open_menu():
	menu = """
What would you like to do?
	1. Compare a document to the Data Base.
	2. Get first 10 similar documents.
	3. Get first 100 similar documents.
	4. Print all documents results.
	5. Change Data Base Directory.
	6. Copy first 10 similar documents to Directory Max_10
	7. Copy first 100 similar documents to Directory Max_100
	8. Exit
"""
	print(menu)
	try:
		inpt = input("What option would you like to choose? Num. ")
		if (inpt == '1'):
			file = input ("Enter file (include path):")
			compr(file)
		elif (inpt == '2'):
			print_first(10)
		elif (inpt == '3'):
			print_first(100)
		elif (inpt == '4'):
			print_first(len(docs_comp))
		elif (inpt == '5'):
			update_data_dir()
		elif (inpt == '6'):
			copy_first(10)
		elif (inpt == '7'):
			copy_first(100)
	finally:
		if (inpt == '8'):
			return
		open_menu()

# Set the directory of the Data Base
def update_data_dir():
	global docs_vector
	global idf_dict
	global f_name
	docs_vector = {}
	f_name = input("Please enter folder name of the Data Base: ")
	print("Please Wait a few seconds while we build the Data Base in folder '{}'...\n".format(f_name))
	build_vectors(f_name)
	idf_dict = bulid_idf_table()
	print("Completed building the Data Base in folder 'source_files';")
	print ("total different Docs in the Data Base: ", docs_num)
	print ("total different words in the Data Base: ",len(idf_dict))

# ====================== main ======================
update_data_dir()
open_menu()