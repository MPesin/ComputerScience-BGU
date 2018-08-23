import sys
from plumbum.cmd import wc,uniq,sort,sed,awk

f = 'lab10_grades'

op1 = (awk["-F", " ", '{print $1}', f])()
print "All the Names:\n" + op1

op2 = (awk['{print $1}',f]|wc["-l"])
print "Number of students: {}".format(op2())

op3 = awk["-F", " ", '{if ($2 != "") \nprint $2\n}', f] | sed[r"s/|/\n/g"] | sort | uniq
print "All the errors:\n" + op3()

op4 = op3|wc["-l"]
print "Number of errors:\n" + op4()