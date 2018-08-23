import task1

def task1a():
    e = task1.GetStatsErrors ('lab10_grades')  
    task1.WriteDicToFile(e, 'errorcodes.stats')

def task1b():
    s = task1.GetStatsStudents ('lab10_grades')
    task1.WriteDicToFile(s, 'codes_per_student.stats')

def task1c():
    task1.Task1c('lab10_grades')
    
task1a()
task1b()
task1c()