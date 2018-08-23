# coding=UTF-8
import sys
import codecs
import re

###################### XML Definitions ######################

meta = """<?xml version="1.0" encoding="UTF-8"?>
<?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>
<?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml"
	schematypens="http://purl.oclc.org/dsdl/schematron"?>
<TEI xmlns="http://www.tei-c.org/ns/1.0">
   <teiHeader>
      <fileDesc>
         <titleStmt>
            <title>
               <surname>פרנקל</surname>, <forename>אלונה</forename> (<surname>גולדמן</surname>,
                  <forename>אילונה</forename>) <date when="1937">(1937) </date>
            </title>
         </titleStmt>
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

###################### Initialization ######################

originalText = codecs.open('input.txt','r',encoding='UTF-8')
ans = codecs.open('output.xml','w',encoding='UTF-8')
tag_dict = dict()
body = ""

###################### Tagging ######################

def scanTags ():
	with codecs.open ('TagSource.txt', 'r',encoding="utf8" ) as tagged_list:
		for line in tagged_list:
			line_words = line.split()
			if line_words:
				word = line_words[1]
				tag = line_words[4]
				if not word in tag_dict:
					tag_dict[word] = tag

def TagWord (word):
	if word in tag_dict:
		tag = tag_dict[word]
		word = "<" + tag + ">" + word + "</" + tag + ">"
	if re.findall(r'\d\d\d\d|\d\d.\d.\d\d\d\d|\d\d.\d\d.\d\d\d\d', word):
		word = "<date>" + word + "</date>"
	word = " " + word + " "
	return word

###################### main ######################

scanTags()
for line in originalText:
		text = line.split(' ')
		for Origin_word in text:
			body = body + TagWord (Origin_word)

###################### return ######################

outputText=meta+"\n"+body+"\n"+closing
ans.write(outputText)
	
