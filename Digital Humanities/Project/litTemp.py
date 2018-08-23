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
def search (search_txt):
	vec = Doc_Vector(file)
	for doc in docs_vector:
		docs_comp[doc] = bm25(vec, docs_vector[doc])

# END Calculation of similarities with bm25 formula