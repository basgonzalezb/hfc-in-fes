import sys

HOME = str(sys.argv[1])

f1 = open('system_original.top', 'r')
f2 = open('topol.top', 'w')
for line in f1:
    f2.write(line.replace("PWD", HOME))
f1.close()
f2.close()