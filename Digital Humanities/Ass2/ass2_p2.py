# coding=utf8
import sys
import codecs
import glob



max_lst = glob.glob("Max_100/*.txt")

def hebrew_filter (c):
	if "\u05D0" <= c <= "\u05EA":
		return c
	else:
		return ''

def get_name(term):
	name = ""
	for c in term:
		if c == '_':
			name += ' '
		else:
			name += hebrew_filter(c)
	if name[0] == ' ':
		name = name[1:]
	return name

def create_tsv():
	print("Creating a TSV from Max_100...")
	with codecs.open("Part_1_Results.tsv", 'w', encoding='utf8') as output:
		output.write("Name\tFile\tValue\tTag\n")
		for item in max_lst:
			name = get_name(item)
			with codecs.open(item ,'r',encoding='utf8') as file:			
				for line in file:
					text = line.split()
					if len(text) > 0 and len(text[2]) > 1:
						if 'I_LOC' in text:
							output.write("{}\t{}\t{}\tI_LOC\n".format(name,item,text[2]))
						elif 'I_PERS' in text:						
							output.write("{}\t{}\t{}\tI_PERS\n".format(name,item,text[2]))
						elif 'I_ORG' in text:						
							output.write("{}\t{}\t{}\tI_ORG\n".format(name,item,text[2]))
	print("Finished!")


create_tsv()




