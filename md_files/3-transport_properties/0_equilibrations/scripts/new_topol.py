import sys

HOME = str(sys.argv[1])          # INPUT: Folder Path

f1 = open('system_original.top', 'r')
f2 = open('system.top', 'w')
for line in f1:
    f2.write(line.replace("PWD", HOME))
f1.close()
f2.close()