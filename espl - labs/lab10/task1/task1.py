import sys


def GetStatsErrors(file):
    inpt = open (file, 'r')
    errors = dict()
    for line in inpt:
        line = line.strip('\n')
        lst = line.split('\t')
        err = lst[1].split('|')
        for r in err:
            if r!= '':
                if r in errors:
                    errors[r] += 1
                else:
                    errors[r] = 1
    return errors

def PrintDic (dic):
    for i in dic:
        print "{} : {}".format (i ,dic[i])

def WriteDicToFile (dic, file):
    outpt = open(file, 'w')
    for i in dic:
        outpt.write("{}|{}\n".format (i ,dic[i]))
        
def GetStatsStudents(file):
    inpt = open (file, 'r')
    students = dict()
    for line in inpt:
        line = line.strip('\n')
        lst = line.split('\t')
        err = lst[1].split('|')
        if lst[1] != '':
            students[lst[0]] = len(err)
        else:
            students[lst[0]] = 0
    return students

def Task1c (file):
    e = GetStatsErrors (file)
    max_err_val = max(e, key=e.get)
    min_err_val = min(e, key=e.get)
    print "The max error is '{}', appeared {} times".format(max_err_val, e[max_err_val])
    print "The min error is '{}', appeared {} times".format(min_err_val, e[min_err_val])
    s = GetStatsStudents (file)
    max_stud_val = max(s, key=s.get)
    min_stud_val = min(s, key=s.get)
    print "The student with max error is '{}', with {} errors".format(max_stud_val, s[max_stud_val])
    print "The student with min error is '{}', with {} errors".format(min_stud_val, s[min_stud_val])
    med_stud_cal = FinfMedian(s.values())
    print "Median errors per students is {}".format(med_stud_cal)
    
def FinfMedian(lst): 
    lst.sort()
    return lst[int(len(lst)/2)]




