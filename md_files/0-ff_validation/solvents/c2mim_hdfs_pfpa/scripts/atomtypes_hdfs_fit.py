import sys
import numpy as np

f_sigma = float(sys.argv[1])
f_eps = float(sys.argv[2])
f = open('HDFS_atoms.itp', 'w')
f.write('; from CL&P force field\n')
f.write('; sigma scaled by %.2f, epsilon scaled by %.2f\n\n' % (f_sigma, f_eps))
f.write('[ atomtypes ]\n')
f.write('; name  at.nr     mass   charge  ptype  sigma      epsilon\n')
names = ['CTF', 'CSF', 'CF3', 'SO', 'OS3', 'F', 'FC1']
nrs = [6, 6, 6, 16, 8, 9, 9]
masses = [12.0110, 12.0110, 12.0110, 32.0660, 15.9990, 15.9990, 18.9980, 18.9980]
sigmas = np.array([0.350, 0.350, 0.350, 0.355, 0.315, 0.295, 0.295])*f_sigma
epsilons = np.array([0.276144, 0.276144, 0.276144, 1.04600, 0.837360, 0.222000, 0.222000])*f_eps
for i in range(len(names)):
    f.write(f'{names[i]:<11}{nrs[i]:>2.0f}  {masses[i]:>7.4f}   0.0000      A  {sigmas[i]:.5f}    {epsilons[i]:.5f}\n')
f.close()
