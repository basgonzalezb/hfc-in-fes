import os, sys
import numpy as np
import matplotlib.pyplot as plt
from uncertainties import ufloat, unumpy
from uncertainties.umath import log, exp

import warnings
warnings.filterwarnings("ignore", category=UserWarning)
os.system('mkdir -p figures')

sys_vec = [4, 7, 10, 14, 17, 20, 24, 27, 30]
run_vec = [1, 2, 3, 4]
t_vec, msd_vec = [], []
for i,system in enumerate(sys_vec):
    t_vec_aux, msd_vec_aux = [], []
    for j,run in enumerate(run_vec):
        t, msd = np.loadtxt('results/msd_%d_%d.xvg' % (system, run), comments=['#', '@'], unpack=True)
        t_vec_aux.append(t), msd_vec_aux.append(msd)
    t_vec.append(t_vec_aux), msd_vec.append(msd_vec_aux)
    t_vec[i], msd_vec[i] = np.array(t_vec[i]), np.array(msd_vec[i])

t0, tf = 10000, 25000
diff_vec, D = [], []
for i,system in enumerate(sys_vec):
    diff_vec_aux = []
    for j,run in enumerate(run_vec):
        ndx = np.where(t_vec[i][j] >= t0)[0][0]
        coeffs = np.polyfit(t_vec[i][j][:ndx], msd_vec[i][j][:ndx], 1)
        diff = coeffs[0]/6.0 * (1e-7)**2*1e12
        diff_vec_aux.append(diff)
    diff_vec.append(diff_vec_aux)
    diff_vec[i] = np.array(diff_vec[i])
    D.append(ufloat(np.mean(diff_vec[i]), np.std(diff_vec[i])))

for i,system in enumerate(sys_vec):
    plt.figure(figsize=(4,4))
    for j,run in enumerate(run_vec):
        t = t_vec[i][j]
        msd = msd_vec[i][j]
        plt.plot(t, msd, '-', lw=2, color=plt.cm.viridis(j/len(run_vec)), label=f'run {run}')
    plt.xlabel(r'$t$ / ps', fontsize=16), plt.ylabel(r'$MSD$ / nm$^2$', fontsize=16)
    plt.legend()
    plt.tight_layout()
    plt.savefig(f'figures/msd_{system}.png', dpi=1200)
    plt.close()

kb = 1.380649e-23
T = 303.15
os.system('mkdir -p diffusivities')
hfc_vec = ['R32', 'R134a', 'R125']
des_vec = ['c2mim_hdfs_pfpa[1_2]', 'tba_nfs_pfpa[1_2]', 'tbp_br_pfpa[1_2]']
mix_vec = [hfc_vec[0]+'_'+des_vec[0], hfc_vec[1]+'_'+des_vec[0], hfc_vec[2]+'_'+des_vec[0],
              hfc_vec[0]+'_'+des_vec[1], hfc_vec[1]+'_'+des_vec[1], hfc_vec[2]+'_'+des_vec[1],
              hfc_vec[0]+'_'+des_vec[2], hfc_vec[1]+'_'+des_vec[2], hfc_vec[2]+'_'+des_vec[2]]
x1 = 0.450147
for i in range(len(sys_vec)):
    with open('MD/{}/run_1/0_initial/rescaling.log'.format(sys_vec[i]), 'r') as f:
        lines = f.readlines()
    for line in lines:
        if line.startswith('new box vectors'):
            L = float(line.split()[4])*1e-9
            break
    _, visc, _ = np.loadtxt('../1_nemd/viscosities/{}.out'.format(mix_vec[i]), comments=['#', '@'], unpack=True)/1e3
    D[i] += 2.837297*kb*T/6./np.pi/visc/L*1e4   # adding finite size correction from https://doi.org/10.1021/jp0477147
    with open(f'diffusivities/{mix_vec[i]}.out', 'w') as f:
        f.write('# x1\t\tD/cm2/s\t\tdD/cm2/s\n')
        f.write(f'{x1:.6f}\t{D[i].n:.10f}\t{D[i].s:.10f}\n')
