# coding=utf8
import sys
import codecs
import SPARQLWrapper

def chech_dbpedia(item):
	sparql = SPARQLWrapper.SPARQLWrapper("http://dbpedia.org/sparql")
	try:
		sparql.setQuery("""
		    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
		    SELECT ?label
		    WHERE {{ <http://dbpedia.org/resource/{}> rdfs:label ?label }}
		""".format(item[::-1]))
		sparql.setReturnFormat(SPARQLWrapper.JSON)
		results = sparql.query().convert()
	except:
		return False
	else:
		if results == []:
			return False
		return True


def scan(file):
	res_list = list()
	with codecs.open(file, 'r', encoding='utf8') as inpt:
		for line in inpt:
			word_lst = line.split('\t')
			if word_lst:
				if chech_dbpedia(word_lst[0]):
					res_list.append(word_lst[0])
	return res_list


file = "Part_1_Results.tsv"
print (scan(file))
input()