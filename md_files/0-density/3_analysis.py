import os
import numpy as np
import matplotlib
import matplotlib.pyplot as plt


os.system('mkdir -p results')
inp_str = 'MD/'

xhba = [1./(hbd_to_hba+1.) for hbd_to_hba in [.5, 1, 2]]
xhbd = [hbd_to_hba/(hbd_to_hba+1.) for hbd_to_hba in [.5, 1, 2]]

mwil_dict = {'c2mim_hdfs_pfpa': 111.17+499.12, 'tba_nfs_pfpa': 242.46+299.09}
mwhbd = 264.05
systems_dict = {'c2mim_hdfs_pfpa': [1, 2, 3, 4, 5, 6, 7, 8, 9],
           'tba_nfs_pfpa': [10, 11, 12, 13, 14, 15, 16, 17, 18]}
# from https://doi.org/10.1021/acs.iecr.0c01893
T_exp = [293.15, 303.15, 313.15, 323.15]
rhoL_exp_dict = {
    'c2mim_hdfs_pfpa': [[1.6875, 1.6732, 1.6608, 1.6477],   # 2:1
                        [1.6721, 1.6620, 1.6490, 1.6351],   # 1:1
                        [1.6893, 1.6739, 1.6564, 1.6428]],  # 1:2
    'tba_nfs_pfpa': [[1.3066, 1.2985, 1.2893, 1.2795],   # 2:1
                     [1.3517, 1.3414, 1.3311, 1.3208],   # 1:1
                     [1.4191, 1.4063, 1.3946, 1.3836]]   # 1:2
}

colors = ['b', 'g', 'r']
T_MD = np.array([293.15, 303.15, 313.15])
for system_str in ['c2mim_hdfs_pfpa', 'tba_nfs_pfpa']:
    system_nrs = systems_dict[system_str]
    mwhba = mwil_dict[system_str]
    mwdes = [xhba[i]*mwhba + xhbd[i]*mwhbd for i in range(3)]
    rhoL_exp = rhoL_exp_dict[system_str]
    rhoL_exp_aux = [[], [], []]
    for i in range(3):
        for j in range(4):
            rhoL_exp_aux[i].append(rhoL_exp[i][j]/mwdes[i]*1e3)
    rhoL_exp = rhoL_exp_aux
    del rhoL_exp_aux
    rhoL_MD, rhoLerr_MD = [[], [], []], [[], [], []]
    j = 0
    for n in system_nrs:
        rhoL_MD_aux = np.loadtxt(inp_str+str(n)+'/3_prNPT/energy.xvg', comments=['#', '@'], unpack=True)[3]
        rhoL_MD[j%3].append(np.mean(rhoL_MD_aux))
        os.system('grep "Density" '+inp_str+str(n)+'/3_prNPT/energy.log'+' | tail -n 1 > tmp.txt')
        rhoLerr_MD[j%3].append(np.loadtxt('tmp.txt', usecols=(3)))
        os.system('rm tmp.txt')
        j += 1
    rhoL_MD_aux, rhoLerr_MD_aux = [[], [], []], [[], [], []]
    for i in range(3):
        for j in range(3):
            rhoL_MD_aux[i].append(rhoL_MD[j][i]/mwdes[i])
            rhoLerr_MD_aux[i].append(rhoLerr_MD[j][i]/mwdes[i])
    rhoL_MD, rhoLerr_MD = rhoL_MD_aux, rhoLerr_MD_aux
    del rhoL_MD_aux, rhoLerr_MD_aux
    plt.figure(figsize=(4,4))
    for i in range(3):
        plt.plot(T_exp, rhoL_exp[i], 'o', color=colors[i], ms=8, lw=2, mec='k')
        plt.errorbar(T_MD, rhoL_MD[i], yerr=rhoLerr_MD[i], fmt='s', color=colors[i], ms=8, lw=2, mec='k')
    plt.xlabel(r'$T$ / K', fontsize=16), plt.ylabel(r'$\rho^L$ / mol$\cdot$L$^{-1}$', fontsize=16)
    plt.tight_layout()
    plt.savefig(system_str+'.png', dpi=1200)
    plt.close()
    for i,rdes in enumerate(['2_1', '1_1', '1_2']):
        np.savetxt('results/'+system_str+'['+rdes+'].out', np.array([T_MD, rhoL_MD[i], rhoLerr_MD[i]]).T,
                   header='T/K\trhoL/mol/L', fmt='%.2f\t%.4f\t%.4f')
