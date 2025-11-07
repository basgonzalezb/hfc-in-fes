import sys
import numpy as np

f_sigma = float(sys.argv[1])
f_eps = float(sys.argv[2])
f = open('atomtypes.itp', 'w')
f.write('[ atomtypes ]\n')
f.write('; name  at.nr     mass   charge  ptype    sigma    epsilon\n')
names = ['HBDC_CF', 'HBDF', 'HBDC_COOH', 'HBDO_OH', 'HBDO_CO', 'HBDH_OH']
nrs = [6, 9, 6, 8, 8, 1]
masses = [12.0110, 18.9984, 12.0110, 15.9990, 15.9990, 1.0080]
sigmas = np.array([0.350, 0.295, 0.375, 0.300, 0.296, 0.000])*f_sigma
epsilons = np.array([0.276144, 0.221752, 0.439320, 0.711280, 0.878640, 0.000000])*f_eps
for i in range(len(names)):
    f.write(f'{names[i]:<12}{nrs[i]:.0f}  {masses[i]:>7.4f}   0.0000      A  {sigmas[i]:.5f}    {epsilons[i]:.5f}\n')
f.close()
