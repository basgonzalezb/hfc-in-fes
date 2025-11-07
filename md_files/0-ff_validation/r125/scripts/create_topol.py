import numpy as np
import shutil
import sys
import datetime
import warnings

state = sys.argv[1]

if state == "L" or state == "V":
    system_name = "R125 "+state+" slab"
    N = int(sys.argv[2])
elif state == "VLE":
    system_name = "R125 VLE slab"
    NL, NV = int(sys.argv[2]), 2*int(sys.argv[3])

HOME2="PWD"
f = open('system_original.top',"w+")
f.write(";; Date:" + str(datetime.datetime.now())+"\n")

f.write("\n [ defaults ]\n")
f.write(";nbfunc comb-rule gen-pairs fudgeLJ fudgeQQ\n")
f.write(" 1              3       yes     0.5     0.5\n")

f.write("\n; Include atomtypes\n")
f.write("#include \""+HOME2+"/ff/RE5_atoms.itp\"\n")

f.write("\n; Include molecules\n") 
if state == "L" or state == "V":
    f.write("#include \""+HOME2+"/ff/RE5"+state+".itp\"\n")
    f.write("\n [ system ]\n")
    f.write(system_name + "\n")
    f.write("\n [ molecules ]\n")
    f.write('RE5'+state+"\t%.0f\n"%N)
elif state=="VLE":
    f.write("#include \""+HOME2+"/ff/RE5L.itp\"\n")
    f.write("#include \""+HOME2+"/ff/RE5V.itp\"\n")
    f.write("\n [ system ]\n")
    f.write(system_name + "\n")
    f.write("\n [ molecules ]\n")
    f.write("RE5L\t%.0f\n"%NL)
    f.write("RE5V\t%.0f\n"%NV)
f.close()
