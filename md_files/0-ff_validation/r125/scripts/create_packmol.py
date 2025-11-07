import numpy as np
import sys

state = sys.argv[1]
N = int(sys.argv[2])
Lx = float(sys.argv[3])
Ly = float(sys.argv[4])
Lz = float(sys.argv[5])

tol = 1.
f = open("pack.inp","w+")
f.write("tolerance 2.0\n")
f.write("filetype pdb\n")
f.write("output  init.pdb \n\n")

f.write("structure RE5"+state+".pdb \n")
f.write("  number "+ str(N) +" \n")
f.write("  inside box 0. 0. 0. %.3f %.3f %4.3f \n"
    %(Lx*10 - tol,Ly*10 - tol,Lz*10 - tol))
f.write("end structure\n")
f.close()
