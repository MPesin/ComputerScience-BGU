# coding=utf8
import sys
import codecs
import re
import glob
import os

###################### Conts Folders ######################

max_fldr = "Max_100/"
lex_fldr = "lexicon_txt/"
dest = "Tagged_Max/"

###################### XML Definitions ######################

meta = """<?xml version="1.0" encoding="UTF-8"?>
<?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>
<?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml"
	schematypens="http://purl.oclc.org/dsdl/schematron"?>
<TEI xmlns="http://www.tei-c.org/ns/1.0">
   <teiHeader>
      <fileDesc>
         <publicationStmt>
            <p>Publication Information</p>
         </publicationStmt>
         <sourceDesc>
            <p>Information about the source</p>
         </sourceDesc>
      </fileDesc>
   </teiHeader>
   <text>
      <body>"""

closing="""		</body>
	</text>
</TEI>"""

###################### Creating Tagged Folder ######################


def tag_top_100(maxl, destination):
	global meta
	global closing
	if not os.path.exists(destination):
			os.makedirs(destination)
	for doc in maxl:
		doc = os.path.basename(doc)
		body = ""
		path_lex = lex_fldr + doc
		path_doc = max_fldr + doc
		path_dest = destination + doc
		
		with codecs.open(path_lex ,'r',encoding='utf8') as file_read:
			tag_dict = scanTags(path_doc)
			for line in file_read:
				text = line.split()
				if text:
					for Origin_word in text:
						body = body + TagWord (tag_dict, Origin_word)
			outputText=meta + "\n" + body + "\n" + closing
		path_dest = path_dest.replace("txt", "xml")
		#print(path_dest)
		with codecs.open(path_dest ,'w',encoding='utf8') as file_write:
			file_write.write(outputText)

###################### Tagging ######################

def scanTags (tag_file):
	tag_dict = dict()
	with codecs.open (tag_file, 'r',encoding="utf8" ) as tagged_list:
		for line in tagged_list:
			line_words = line.split()
			if line_words:
				word = line_words[1]
				tag = line_words[4]
				if not word in tag_dict:
					tag_dict[word] = tag
	return tag_dict

def TagWord (tag_dict, word):
	if word in tag_dict:
		tag = tag_dict[word]
		word = "<" + tag + ">" + word + "</" + tag + ">"
	if re.findall(r'\d\d\d\d|\d\d.\d.\d\d\d\d|\d\d.\d\d.\d\d\d\d', word):
		word = "<date>" + word + "</date>"
	word = " " + word + " "
	return word

###################### Check files exist ######################

def check_data(max_lst, lex_lst):
	ans = True
	global false_list
	false_list = list()
	for file in max_lst:
		file = lex_fldr + os.path.basename(file)
		if not file in lex_lst:
			false_list.append(file)
			ans = False
	return ans

###################### main ######################
	
max_lst = glob.glob(max_fldr + "*.txt")
lex_lst = glob.glob(lex_fldr + "*.txt")
if check_data(max_lst, lex_lst):
	tag_top_100(max_lst, dest)
	print("DONE!")
else:
	print(false_list)