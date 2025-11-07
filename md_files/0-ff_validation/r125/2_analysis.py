import os
import numpy as np
import matplotlib.pyplot as plt


os.system('mkdir -p results')

Mw = 120.02
T_SAFT, P_SAFT, rhoL_SAFT, rhoV_SAFT, ift_SAFT = np.loadtxt('vle_saft.txt', skiprows=1, unpack=True)

T_MD = np.array([250, 280, 300])
P_MD, rhoL_MD, rhoV_MD, ift_MD = [], [], [], []
z, rhoprof = [], []
for T in T_MD:
    inp_str = f'{T}/3_VLE/2_productionNVT/'
    with open(inp_str+'energy.log', 'r') as f:
        lines = f.readlines()
        P_MD.append(float(lines[-3].split()[1]))
        ift_MD.append(float(lines[-2].split()[1])*1e-1/2.)
    data = np.loadtxt(inp_str+'density.xvg', comments=['#', '@'], unpack=True)
    if T==250:
        z1, z2, z3, z4, z5, z6 = 15, 23, 0, 10, 28, data[0][-1]
    if T==280:
        z1, z2, z3, z4, z5, z6 = 13, 20, 0, 7, 25, data[0][-1]
    elif T==300:
        z1, z2, z3, z4, z5, z6 = 0, 4, 10, 30, 30, 34
    z.append(data[0]), rhoprof.append(data[1])
    rhoL_MD.append(data[1][(data[0] > z1) & (data[0] < z2)].mean())
    rhoV_MD.append((data[1][(data[0] > z3) & (data[0] < z4)].mean()+data[1][(data[0] > z5) & (data[0] < z6)].mean())/2.)
    np.savetxt(f'results/rhoprof_{T}K.out', np.array([data[0], data[1]]).T, header='z/nm\trho/kg/m3', fmt='%10.5f\t%10.5f')
    plt.figure(figsize=(4,4))
    plt.plot(data[0], data[1], color='b', lw=2)
    for z_i in [z1, z2, z3, z4, z5, z6]:
        plt.axvline(z_i, color='k', linestyle='--', lw=1)
    plt.xlabel('z / nm', fontsize=16)
    plt.ylabel(r'$\rho$ / kg$\cdot$m$^{-3}$', fontsize=16)
    plt.tight_layout()
    plt.savefig(f'{inp_str}rhoprof.png', dpi=1200)
    plt.close()
np.savetxt('results/vle.out', np.array([T_MD, P_MD, rhoL_MD, rhoV_MD, ift_MD]).T, header='T/K\t  P/bar\trhoL/kg/m3\trhoV/kg/m3\tift/mN/m', 
           fmt='%5.0f\t%7.4f\t%10.4f\t%10.4f\t%8.4f')

plt.figure(figsize=(4,4))
plt.plot(rhoL_SAFT*Mw/1e3, T_SAFT, '-b', lw=2)
plt.plot(rhoV_SAFT*Mw/1e3, T_SAFT, '-r', lw=2)
plt.plot(rhoL_MD, T_MD, 'sb', ms=8, mec='k', lw=2)
plt.plot(rhoV_MD, T_MD, 'sr', ms=8, mec='k', lw=2)
plt.xlim(0, 1800), plt.ylim(100, 350)
plt.xlabel(r'$\rho$ / kg$\cdot$m$^{-3}$', fontsize=16), plt.ylabel(r'$T$ / K', fontsize=16)
plt.tight_layout()
plt.savefig('results/rho_T.png', dpi=1200)
plt.close()
plt.figure(figsize=(4,4))
plt.plot(T_SAFT, ift_SAFT, '-k', lw=2)
plt.plot(T_MD, ift_MD, 'sk', ms=8, mec='k', lw=2)
plt.xlim(100, 350), plt.ylim(0, 30)
plt.xlabel(r'$T$ / K', fontsize=16), plt.ylabel(r'$\gamma$ / mN$\cdot$m$^{-1}$', fontsize=16)
plt.tight_layout()
plt.savefig('results/T_ift.png', dpi=1200)
plt.close()
plt.figure(figsize=(4,4))
plt.plot(T_SAFT, P_SAFT/1e5, '-k', lw=2)
plt.plot(T_MD, P_MD, 'sk', ms=8, mec='k', lw=2)
plt.xlim(100, 350), plt.ylim(0, 30)
plt.xlabel(r'$T$ / K', fontsize=16), plt.ylabel(r'$P$ / bar', fontsize=16)
plt.tight_layout()
plt.savefig('results/T_P.png', dpi=1200)
plt.close()
