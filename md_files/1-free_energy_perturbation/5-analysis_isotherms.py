import warnings
warnings.simplefilter("ignore")

import unyt as u
import numpy as np
from uncertainties import ufloat
from uncertainties.umath import exp, log
from scipy.optimize import fsolve
import matplotlib
from matplotlib.ticker import MultipleLocator, AutoMinorLocator
import matplotlib.pyplot as plt
import pandas as pd
import openpyxl


R = 8.314463125729601
kb = 1.3806488e-23
def compute_debroglie(mass, temperature):
    """Compute the thermal de Broglie wavelength

    Parameters
    ----------
    mass : u.unyt_quantity
       mass of the molecule
    temperature : u.unyt_quantity
       temperature

    Returns
    -------
    debroglie : u.unyt_quantity
    """
    return np.sqrt(2 * np.pi * u.hbar**2 / (mass * u.kb * temperature))

data_inp = 'data/isotherms-303.15K/'
# fitted polynomials for HFCs, from soft-SAFT EoS
r32_phipol = np.array([9.76760466e-15, -2.08014210e-07, -8.59231767e-06])
r134a_phipol = np.array([4.78923897e-15, -3.03754250e-07, -3.16386109e-05])
r125_phipol = np.array([1.40871540e-15, -2.09745839e-07, -1.03734718e-05])
hfc_phipol = [r32_phipol, r134a_phipol, r125_phipol]
hfc_masses = [52.024, 102.03, 120.02]
ns_array = np.array([133, 322, 614])
des_nms = ['[C2M][HDFS]:PFPA (1:2)', '[TBA][NFS]:PFPA (1:2)', '[TBP][BR]:PFPA (1:2)']
des_inp = ['c2mim_hdfs_pfpa[1_2]', 'tba_nfs_pfpa[1_2]', 'tbp_br_pfpa[1_2]']
hfc_nms = ['R32', 'R134a', 'R125']
des_ndx = [
    [
        [17, 18, 19],
        [20, 21, 22],
        [23, 24, 25]
    ],
    [
        [26, 27, 28],
        [29, 30, 31],
        [32, 33, 34]
    ],
    [
        [35, 36, 37],
        [38, 39, 40],
        [41, 42, 43]
    ]
]

T = 303.15
P0 = 1e5
N1 = 250
N2 = 500
X1_MDYN, P_MDYN = [], []
X1_DATA, P_DATA = [], []
Ndist = 10000
for i in range(len(des_inp)):
    X1_MDYN_aux1, P_MDYN_aux1 = [], []
    X1_DATA_aux1, P_DATA_aux1 = [], []
    for j in range(len(des_ndx[i])):
        if i!=2:
            X1_DATA_aux2, P_DATA_aux2 = np.loadtxt(data_inp+'{}+{}.txt'.format(hfc_nms[j], des_inp[i]), unpack=True, comments=['#', '@'])
        else:
            X1_DATA_aux2, P_DATA_aux2 = np.nan, np.nan
        X1_MDYN_aux2, P_MDYN_aux2 = [], []
        mass = hfc_masses[j]
        debroglie = compute_debroglie(mass*u.amu, T*u.K).value
        pol = np.poly1d(hfc_phipol[j])
        for k,ndx in enumerate(des_ndx[i][j]):
            Ns = ns_array[k]
            x1 = Ns/(N1+N2+Ns)
            V = np.mean(np.loadtxt('results/{:.0f}/volume.xvg'.format(ndx), comments=['#', '@'], unpack=True)[1])*1e-27
            mu = -pd.read_excel('results/{:.0f}/summary.xlsx'.format(ndx))['MBAR'].iloc[-1]*1e3
            dmu = pd.read_excel('results/{:.0f}/summary.xlsx'.format(ndx))['MBAR_Error'].iloc[-1]*1e3
            mudist = np.random.normal(mu, dmu, Ndist)
            def fobj(P, mu):
                return mu/R/T - np.log(P0*V/kb/T/Ns) - np.log(P/P0) - pol(P)
            pdist = np.zeros(Ndist)
            for l,mu in enumerate(mudist):
                pdist[l] = fsolve(fobj, 1e5, args=(mu))[0]/1e6
            P = ufloat(np.mean(pdist), np.std(pdist))
            X1_MDYN_aux2.append(x1), P_MDYN_aux2.append(P)
        X1_MDYN_aux1.append(X1_MDYN_aux2), P_MDYN_aux1.append(P_MDYN_aux2)
        X1_DATA_aux1.append(X1_DATA_aux2), P_DATA_aux1.append(P_DATA_aux2)
    X1_MDYN.append(X1_MDYN_aux1), P_MDYN.append(P_MDYN_aux1)
    X1_DATA.append(X1_DATA_aux1), P_DATA.append(P_DATA_aux1)

colors = ['b', 'r', 'y']
for j in range(len(hfc_nms)):
    plt.figure(figsize=(12,4))
    for i in range(len(des_nms)):
        plt.subplot(1, 3, i+1)
        plt.title(des_nms[i])
        plt.plot(X1_DATA[i][j], P_DATA[i][j], 'o', color=colors[i], ms=8, lw=2, mec='k')
        pvec, dpvec = [], []
        for k in range(len(P_MDYN[i][j])):
            pvec.append(P_MDYN[i][j][k].nominal_value), dpvec.append(P_MDYN[i][j][k].std_dev)
        plt.errorbar(X1_MDYN[i][j], pvec, yerr=dpvec, fmt='s', color=colors[i], ms=8, lw=2, mec='k')
        plt.xlabel(r'$x_1$ / mol$\cdot$mol$^{-1}$', fontsize=16), plt.ylabel(r'$P$ / MPa', fontsize=16)
        plt.xlim(0, 0.6), plt.ylim(0, 2)
        np.savetxt('results/px_{}_{}.out'.format(hfc_nms[j], des_inp[i]), np.array([X1_MDYN[i][j], pvec, dpvec]).T,
                   header='x1\tP/MPa\tdP/MPa', fmt='%.6f\t%.6f\t%.6f')
    plt.tight_layout()
    plt.savefig('px-{}.png'.format(hfc_nms[j]), dpi=1200)
    plt.close()
