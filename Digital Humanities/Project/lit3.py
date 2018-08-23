# -*- coding: utf-8 -*-
import codecs, math, io
import csv
import collections
import pandas as pd
import numpy as np
import plotly.plotly as py
import plotly.graph_objs as go


# ====================== Filter Hebrew Words or space ======================

def heb_filter (term):
		ans = ""
		for c in term:
			if ("\u05D0" <= c <= "\u05EA") or (c == "\u0020"):
				ans += "c"
		return ans

# END Filter Hebrew Words or space

# ====================== Noseh Vector Class ======================

class Noseh_Vector:

	def word_count(self, w):
		if w in self.word_vector:
			return self.word_vector[w]
		else:
			return 0

	def update_word_vector (self, term):
		if term in self.word_vector:
			self.word_vector[term] += 1
		else:
			self.word_vector[term] = 1

	def get_size(self):
		lenth = 0
		for word in self.word_vector:
			lenth += self.word_vector[word]
		return lenth

	def __init__(self, text):
		self.word_vector = dict()
		text = heb_filter(text)
		txt_words = text.split()
		for obj in txt_words:
			self.update_word_vector(obj)
		self.size = self.get_size()

#  END Noseh Vector Class 


# ====================== Protocols Vector ======================

protocol_vec = dict()

def build_protocol_vec():
	global protocol_vec
	with codecs.open ('Knesset_Protocols_tsv.tsv', 'r', encoding="utf8") as table:
		for line in table:
			colums = line.split('\t')
			protocol_vec[colums[0]] = Noseh_Vector(colums[8])

#  END Protocols Vector 




# ====================== Word Pool ======================

word_pool = dict()

def build_word_pool():
	global word_pool
	with codecs.open ('Knesset_Protocols_tsv.tsv', 'r', encoding="utf8") as table:
		for line in table:
			colums = line.split('\t')
			noseh_words = heb_filter(colums[8]).split()
			for word in noseh_words:
				if word in word_pool:
					word_pool[word].append(colums[0])
				else:
					word_pool[word] = [colums[0]]

# END Word Pool

# ====================== Graphs ======================


def do_grafh (from_user):
	input_file= pd.read_csv('Knesset-Protocols-Filtered_utf8.csv') 
	counts = input_file[from_user].value_counts().to_dict()
	freq= counts.values()
	value= counts.keys()
	trace = dict(x=value, y=freq)
	data = [trace]
	layout = dict( xaxis=dict(title=from_user),
				  yaxis=dict(title='number of meetings'))
	fig = dict(data=data, layout=layout)
	py.plot(fig, filename='ia_county_populations')
 
def do_grafh2 (from_user):
	f = open('Knesset-Protocols-Filtered_utf8.csv', 'rb')
	reader = csv.reader(f)	
	rows = list(reader)

def do_grafh3 (from_user, filtered):
	file = filtered + ".csv"
	input_file= pd.read_csv(file) 
	counts = input_file[from_user].value_counts().to_dict()
	freq= counts.values()
	value= counts.keys()
	trace = dict(x=value, y=freq)
	data = [trace]
	layout = dict( xaxis=dict(title=from_user),
				  yaxis=dict(title='number of meetings'))
	fig = dict(data=data, layout=layout)
	py.plot(fig, filename='ia_county_populations')


#  END Graphs 


# ====================== MAIN ======================

build_protocol_vec()

user_number = input("""choose your qustion\nhow many meeting have been evey ____ 
1.VAADA_CODE 
2.MOSHAV 
3.YESHIVA_DATE_MONTH
4.YESHIVA_DATE_DAY
5.YESHIVA_DATE_YEAR
6.NOSEH
7.SUG_PEILUT_NAME
8.SUG_PEILUT\n""")
if user_number== 1:
	from_user='VAADA_CODE'
	do_grafh2 (from_user)
elif user_number== 2:
	from_user='MOSHAV'
elif user_number== 3:
	from_user='YESHIVA_DATE_MONTH'
elif user_number== 5:
	from_user='YESHIVA_DATE_YEAR'
elif user_number== 6:
	from_user='NOSEH'
elif user_number== 7:
	from_user='SUG_PEILUT_NAME'
else:
	from_user='SUG_PEILUT'
	
	
do_grafh (from_user)

# END MAIN

