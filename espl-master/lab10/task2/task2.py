import sys
import task1 as t1

def GetPoints(file):
    inpt = open (file, 'r')
    ans = dict()
    for line in inpt:
        line = line.strip('\n')
        lst = line.split('\t')
        ans[lst[0]] = int(lst[1])
    return ans

def CalcGrad(file, p_table):
    inpt = open (file, 'r')
    ans = dict()
    for line in inpt:
        line = line.strip('\n')
        lst = line.split('\t')
        ans[lst[0]] = CalcErrorPoints(lst[1].split('|'), p_table)
    return ans

def CalcErrorPoints(lst, p_table):
    g = 100
    for i in lst:
        if i != '':
            g -= p_table[i]
    return g

def task2():
    g = CalcGrad('lab10_grades', GetPoints('error-codes'))
    t1.WriteDicToFile(g, 'final_grades')

task2()