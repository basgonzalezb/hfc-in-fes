import warnings
warnings.simplefilter("ignore")

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from uncertainties import ufloat
from uncertainties import unumpy as unp
from uncertainties.umath import exp


T = 303.15
R = 8.314463125729601
beta = 1./(R*T)

des_nms = ['[C2M][HDFS]:PFPA', '[TBA][NFS]:PFPA', '[TBP][BR]:PFPA']
des_nkm = ['c2m_hdfs_pfpa', 'tba_nfs_pfpa', 'tbp_br_pfpa']
hbd_ndx = 1
des_ndx = [
    [ 2,  3,  4,  5,  6],
    [ 7,  8,  9, 10, 11],
    [12, 13, 14, 15, 16]
]
mwct1, mwct2, mwct3 = 111.17, 242.46, 259.42
mwan1, mwan2, mwan3 = 499.12, 299.09,  79.91
mwhba = [mwct1+mwan1, mwct2+mwan2, mwct3+mwan3]
mwhbd = 264.05
x1_vec = np.array([100/300, 100/400, 100/500, 100/700, 100/1000])

def get_rho(ndx):
    data = np.loadtxt('results/{:.0f}/density.xvg'.format(ndx), comments=['#', '@'], unpack=True)
    return np.mean(data[1])
def get_mu(ndx):
    data = pd.read_excel('results/{:.0f}/summary.xlsx'.format(ndx))
    mu = data['MBAR'].iloc[-1]
    dmu = data['MBAR_Error'].iloc[-1]
    return -ufloat(mu, dmu)*1e3

rho0 = get_rho(hbd_ndx)*1e3/mwhbd
mu0 = get_mu(hbd_ndx)
colors = ['b', 'r', 'y']
plt.figure(figsize=(4,4))
for i in range(3):
    mw_vec = np.array([x1*mwhba[i]+(1.-x1)*mwhbd for x1 in x1_vec])
    rho_vec, mu_vec = [], []
    for j in range(len(x1_vec)):
        rho_vec_aux = get_rho(des_ndx[i][j])*1e3/mw_vec[j]*(1.-x1_vec[j])
        mu_vec_aux = get_mu(des_ndx[i][j])
        rho_vec.append(rho_vec_aux), mu_vec.append(mu_vec_aux)
    rho_vec, mu_vec = np.array(rho_vec), np.array(mu_vec)
    g_vec, dg_vec = [], []
    for k in range(len(des_ndx[i])):
        g = exp(beta*(mu_vec[k] - mu0))*rho_vec[k]/rho0/(1.-x1_vec[k])
        g_vec.append(g.nominal_value), dg_vec.append(g.std_dev)
    g_vec = np.array(g_vec)
    dg_vec = np.array(dg_vec)
    x1_vec = np.array(x1_vec)
    plt.errorbar(x1_vec, g_vec, yerr=dg_vec, fmt='s', color=colors[i], ms=8, lw=2, mec='k', label=des_nms[i])
    np.savetxt('results/gamma2_{:s}.out'.format(des_nkm[i]), np.array([x1_vec, g_vec, dg_vec]).T, header='x1\tgamma2\tdgamma2')
plt.legend()
plt.xlabel(r'$x_{HBA}$ / mol$\cdot$mol$^{-1}$', fontsize=16), plt.ylabel(r'$\gamma_{HBD}$', fontsize=16)
plt.tight_layout()
plt.savefig('gamma2.png', dpi=1200)
plt.close()
