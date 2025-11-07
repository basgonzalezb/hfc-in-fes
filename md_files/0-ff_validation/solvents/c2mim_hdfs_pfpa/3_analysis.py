import numpy as np
import matplotlib.pyplot as plt


inp_str = 'results_fit/'
mwct, mwan, mwhbd = 111.17, 499.12, 264.05
xhba = [1./(hbd_to_hba+1.) for hbd_to_hba in [.5, 1, 2]]
xhbd = [hbd_to_hba/(hbd_to_hba+1.) for hbd_to_hba in [.5, 1, 2]]
mwdes = [xhba[i]*(mwct+mwan) + xhbd[i]*mwhbd for i in range(3)]
ratios = ['2_1', '1_1', '1_2']
# from https://doi.org/10.1021/acs.iecr.0c01893
T_exp = [293.15, 303.15, 313.15, 323.15]
rhoL_exp = [[1.6875, 1.6732, 1.6608, 1.6477],   # 2:1
            [1.6721, 1.6620, 1.6490, 1.6351],   # 1:1
            [1.6893, 1.6739, 1.6564, 1.6428]]   # 1:2
rhoL_exp_aux = rhoL_exp
rhoL_exp = [[], [], []]
for i in range(3):
    for j in range(4):
        rhoL_exp[i].append(rhoL_exp_aux[i][j]/mwdes[i]*1e3) # convert to mol/L

T_MD = np.array([303.15, 323.15])
fs_vec = np.array([0.86, 0.88, 0.90, 0.92, 0.92, 0.92, 0.92, 0.92, 0.94])
fe_vec = np.array([1.00, 1.00, 1.00, 0.90, 0.95, 1.00, 1.05, 1.10, 1.00])
rhoL_MD = []
for r in ratios:
    rhoL_MD_aux = []
    for T in T_MD:
        rhoL_MD_aux1 = []
        for fs, fe in zip(fs_vec, fe_vec):
            with open(inp_str+r+'/density_fs_{:.2f}_and_fe_{:.2f}_{:.0f}.log'.format(fs, fe, T), 'r') as f:
                lines = f.readlines()
                data = float(lines[-1].split()[1])/mwdes[ratios.index(r)]
            rhoL_MD_aux1.append(data)
        rhoL_MD_aux.append(rhoL_MD_aux1)
    rhoL_MD.append(rhoL_MD_aux)
rhoL_MD = np.array(rhoL_MD)

res = []
for k in range(len(fs_vec)):
    res_aux = 0
    for i in range(len(ratios)):
        for j in range(len(T_MD)):
            res_aux += ((rhoL_MD[i][j][k] - rhoL_exp[i][T_exp.index(T_MD[j])])/rhoL_exp[i][T_exp.index(T_MD[j])])**2
    res.append(res_aux)
res = np.array(res)
res_sigma, res_epsilon = res[3:8], res[[0,1,2,5,8]]
ps, pe = np.polyfit(fe_vec[3:8], res_sigma, 2), np.polyfit(fs_vec[[0,1,2,5,8]], res_epsilon, 2)

plt.figure(figsize=(8,4))
plt.subplot(1, 2, 1)
plt.title(r'$S_\sigma = 0.92$')
plt.plot(fe_vec[3:8], res_sigma, 'o', ms=8, lw=2, color='blue', mec='k')
fe_ls = np.linspace(0.80, 1.20, 100)
plt.plot(fe_ls, ps[0]*fe_ls**2 + ps[1]*fe_ls + ps[2], '-', lw=2, color='blue')
plt.axhline(y=0, color='k', linestyle='--', lw=2)
plt.xlabel(r'$S_\epsilon$', fontsize=16)
plt.subplot(1, 2, 2)
plt.title(r'$S_\epsilon = 1.00$')
plt.plot(fs_vec[[0,1,2,5,8]], res_epsilon, 'o', ms=8, lw=2, color='blue', mec='k')
fs_ls = np.linspace(0.85, 0.96, 100)
plt.plot(fs_ls, pe[0]*fs_ls**2 + pe[1]*fs_ls + pe[2], '-', lw=2, color='blue')
plt.axhline(y=0, color='k', linestyle='--', lw=2)
plt.xlabel(r'$S_\sigma$', fontsize=16)
plt.tight_layout()
plt.savefig('res.png', dpi=1200)
plt.show()

shapes = ['o', 's', 'd']
colors = plt.cm.rainbow(np.linspace(0, 1, len(T_MD)))
plt.figure(figsize=(8,4))
plt.subplot(1, 2, 1)
plt.title(r'$S_\sigma = 0.92$')
for i in range(len(ratios)):
    for j in range(len(T_MD)):
        plt.plot(fe_vec[3:8], rhoL_MD[i][j][3:8], shapes[i], color=colors[j], ms=8, lw=2, mec='k')
        plt.axhline(y=rhoL_exp[i][T_exp.index(T_MD[j])], color=colors[j], linestyle='--', lw=2)
plt.xlabel(r'$S_\epsilon$', fontsize=16)
plt.ylabel(r'$\rho^L$ (mol/L)', fontsize=16)
plt.subplot(1, 2, 2)
plt.title(r'$S_\epsilon = 1.00$')
for i in range(len(ratios)):
    for j in range(len(T_MD)):
        plt.plot(fs_vec[[0,1,2,5,8]], [rhoL_MD[i][j][0], rhoL_MD[i][j][1], rhoL_MD[i][j][2], rhoL_MD[i][j][5], rhoL_MD[i][j][8]], shapes[i], color=colors[j], ms=8, lw=2, mec='k')
        plt.axhline(y=rhoL_exp[i][T_exp.index(T_MD[j])], color=colors[j], linestyle='--', lw=2)
plt.xlabel(r'$S_\sigma$', fontsize=16)
plt.ylabel(r'$\rho^L$ (mol/L)', fontsize=16)
plt.tight_layout()
plt.savefig('rho.png', dpi=1200)
plt.show()
