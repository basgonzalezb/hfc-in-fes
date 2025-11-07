import numpy as np
import matplotlib.pyplot as plt


T_vec = np.array([303, 323, 343])
rho_exp = [1679.25, 1636.15, 1594.16]
inp_str = 'results_fit/'
fs_vec = np.append(np.ones(3), np.array([1.01, 1.02, 1.03, 1.04]))
fe_vec = np.append(np.array([0.89, 0.92, 0.95]), np.ones(4)*0.89)
rhoL_MD = []
for T in T_vec:
    rhoL_MD_aux = []
    for fs, fe in zip(fs_vec, fe_vec):
        #data = np.loadtxt(inp_str+'density_fs_{:.2f}_and_fe_{:.2f}_{:.0f}.log'.format(fs, fe, T), unpack=True, usecols=1)
        with open(inp_str+'density_fs_{:.2f}_and_fe_{:.2f}_{:.0f}.log'.format(fs, fe, T), 'r') as f:
            lines = f.readlines()
            data = float(lines[-1].split()[1])
        rhoL_MD_aux.append(np.mean(data))
    rhoL_MD.append(rhoL_MD_aux)
rhoL_MD = np.array(rhoL_MD)

print('rhoL at fs=1.00, fe=0.88:')
for i in range(3):
    pol = np.polyfit(fe_vec[:3], rhoL_MD[i][:3], 1)
    rhoL = pol[0]*0.88 + pol[1]
    print('T={:.0f} K, rhoL={:.2f} kg/m^3'.format(T_vec[i], rhoL))

colors = plt.cm.rainbow(np.linspace(0, 1, 3))
plt.figure(figsize=(8, 4))
plt.subplot(1, 2, 1)
plt.title(r'$S_\sigma = 1.00$')
for i in range(3):
    plt.plot(fe_vec[:3], rhoL_MD[i][:3], 'o', label=r'$T = {:.0f}$ K'.format(T_vec[i]), color=colors[i], ms=8, lw=2, mec='k')
    plt.axhline(y=rho_exp[i], color=colors[i], linestyle='--', lw=2)
plt.xlabel(r'$S_\epsilon$', fontsize=16)
plt.ylabel(r'$\rho_L$ (kg/m$^3$)', fontsize=16)
plt.ylim(1500, 1800)
plt.legend()
plt.subplot(1, 2, 2)
plt.title(r'$S_\epsilon = 0.89$')
for i in range(3):
    plt.plot(np.append(fs_vec[0], fs_vec[3:]), np.append(rhoL_MD[i][0], rhoL_MD[i][3:]), 'o', color=colors[i], ms=8, lw=2, mec='k')
    plt.axhline(y=rho_exp[i], color=colors[i], linestyle='--', lw=2)
plt.xlabel(r'$S_\sigma$', fontsize=16)
plt.ylabel(r'$\rho_L$ (kg/m$^3$)', fontsize=16)
plt.ylim(1500, 1800)
plt.tight_layout()
plt.savefig('rho.png', dpi=1200)
plt.show()

res = []
for j in range(7):
    res_aux = 0
    for i in range(3):
        res_aux += ((rhoL_MD[i][j] - rho_exp[i])/rho_exp[i])**2
    res.append(res_aux)
res = np.array(res)

res_sigma, res_epsilon = res[:3], res[3:]
ps, pe = np.polyfit(fe_vec[:3], res_sigma, 2), np.polyfit(fs_vec[3:], res_epsilon, 2)

plt.figure(figsize=(8, 4))
plt.subplot(1, 2, 1)
plt.title(r'$S_\sigma = 1.00$')
plt.plot(fe_vec[:3], res[:3], 'o', ms=8, lw=2, color='blue', mec='k')
fe_ls = np.linspace(0.85, 0.96, 100)
plt.plot(fe_ls, ps[0]*fe_ls**2 + ps[1]*fe_ls + ps[2], '-', lw=2, color='blue')
plt.axhline(y=0, color='k', linestyle='--', lw=2)
plt.xlabel(r'$S_\epsilon$', fontsize=16)
plt.subplot(1, 2, 2)
plt.title(r'$S_\epsilon = 0.89$')
plt.plot(fs_vec[3:], res[3:], 'o', ms=8, lw=2, color='blue', mec='k')
fs_ls = np.linspace(0.9, 1.05, 100)
plt.plot(fs_ls, pe[0]*fs_ls**2 + pe[1]*fs_ls + pe[2], '-', lw=2, color='blue')
plt.axhline(y=0, color='k', linestyle='--', lw=2)
plt.xlabel(r'$S_\sigma$', fontsize=16)
plt.tight_layout()
plt.savefig('res.png', dpi=1200)
plt.show()

# print where ps and pe reach minimia
S_sigma = -ps[1]/(2*ps[0])
S_epsilon = -pe[1]/(2*pe[0])
# print where ps and pe reach its positive root
S_sigma = (-ps[1] + np.sqrt(ps[1]**2 - 4*ps[0]*ps[2]))/(2*ps[0])
print('fs=1.00, fe_opt={:.3f}, res={:.3e}'.format(S_sigma, ps[0]*S_sigma**2 + ps[1]*S_sigma + ps[2]))
print('fe=0.89, fs_opt={:.3f}, res={:.3e}'.format(S_epsilon, pe[0]*S_epsilon**2 + pe[1]*S_epsilon + pe[2]))
