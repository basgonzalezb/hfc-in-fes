import os
import sys
import numpy as np

resname, sq = sys.argv[1], float(sys.argv[2])

if not os.path.exists('{}.itp.bak'.format(resname)):
    os.system('mv {}.itp {}.itp.bak'.format(resname, resname))
with open('{}.itp.bak'.format(resname), 'r') as inf, open('{}.itp'.format(resname), 'w') as outf:
    lines = inf.readlines()
    atoms = False
    outf.write('; Charges have been scaled by {}\n\n'.format(sq))
    for i, line in enumerate(lines):
        if line.startswith('[ atoms ]'):
            atoms = True
            outf.write(line)
        elif atoms and line.startswith('[ '):
            atoms = False
            outf.write(line)
        elif atoms and not line.startswith(';'):
            try:
                values = line.split()
                values[-1] = f'{float(values[-1])*sq:.6f}'
                outf.write('{:>5}   {:<10}{:>1}  {:<8}{:<9}{:>2}{:>12}\n'.format(*values))
            except:
                outf.write(line)
        else:
            outf.write(line)
