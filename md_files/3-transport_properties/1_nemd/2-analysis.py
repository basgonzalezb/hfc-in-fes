import os, sys
import numpy as np
from scipy.optimize import minimize, least_squares
from scipy import stats
from uncertainties import ufloat, unumpy
from uncertainties.umath import log, exp  # sin(), etc.

import warnings
warnings.filterwarnings("ignore", category=UserWarning)

import matplotlib
import matplotlib.pyplot as plt
from matplotlib.ticker import MultipleLocator, AutoMinorLocator
import matplotlib.colors as mcolors
matplotlib.rcParams['mathtext.fontset'] = 'custom'
matplotlib.rcParams['xtick.major.pad']='5'
matplotlib.rcParams['ytick.major.pad']='5'
matplotlib.rcParams['axes.linewidth'] = 0.75
matplotlib.rcParams['axes.axisbelow'] = True
matplotlib.rcParams['savefig.dpi'] = 1200
font = {'weight' : 'normal',
        'size'   : 16}
plt.rc('font', **font)
plt.rc('axes', titlesize=font["size"])


os.system('mkdir -p figures')
amp_vec = np.array([0.005, 0.010, 0.015, 0.020, 0.025, 0.030, 0.040])
sys_vec = np.array([1, 4, 7, 10, 11, 14, 17, 20, 21, 24, 27, 30])

des_nms = ['c2mim_hdfs_pfpa[1_2]', 'tba_nfs_pfpa[1_2]', 'tbp_br_pfpa[1_2]']
hfc_nms = ['R32', 'R134a', 'R125']
sys_nms = np.array([
    des_nms[0], hfc_nms[0]+'_'+des_nms[0], hfc_nms[1]+'_'+des_nms[0], hfc_nms[2]+'_'+des_nms[0],
    des_nms[1], hfc_nms[0]+'_'+des_nms[1], hfc_nms[1]+'_'+des_nms[1], hfc_nms[2]+'_'+des_nms[1],
    des_nms[2], hfc_nms[0]+'_'+des_nms[2], hfc_nms[1]+'_'+des_nms[2], hfc_nms[2]+'_'+des_nms[2]
])
x1_vec = np.array([0.450147])

visc_final, viscerr_final = [], []
for system in sys_vec:
    print('SYSTEM %d' % system)
    visc_aux, viscerr_aux, amp_aux = [], [], []
    for amp in amp_vec:
        # read data
        filename = f"results/visc_{system}_{amp:.3f}.log"
        try:
            visc_inv, visc_inv_err = np.loadtxt(filename, skiprows=1, usecols=(1, 2), unpack=True)
            visc = 1000/visc_inv                            # Viscosity, cp
            visc_err = 1000*visc_inv_err / (visc_inv**2)    # Viscosity error, cp
            visc_aux.append(visc), viscerr_aux.append(visc_err), amp_aux.append(amp)
        except OSError:
            print(f"File {filename} not found. Skipping.")
            continue
    # generate data for fitting taking into account the errors
    N = 500000
    n = len(viscerr_aux)
    logY = np.zeros((n, N))
    visc = unumpy.uarray(visc_aux, viscerr_aux)
    logvisc = unumpy.log(visc)
    for i in range(n):
        logY[i, :] = np.random.normal(logvisc[i].nominal_value, logvisc[i].std_dev, N)
    # fit the data
    res = np.zeros((N, 2))
    res_err = np.zeros((N, 2))
    x_data = amp_aux
    N2 = 1000
    RES = np.zeros((N2*N, 2))
    for i in range(N):
        y_data = logY[:, i]
        # Lineal fitting
        out = stats.linregress(x_data, y_data)
        res[i, 0] = out.intercept
        res[i, 1] = out.slope
        # Calculate the errors for each parameter
        res_err[i, 0] = out.intercept_stderr
        res_err[i, 1] = out.stderr
        # Generate pseudo data using np.random.normal
        # and the fitted parameters
        RES[i*N2:(i+1)*N2, 0] = np.random.normal(res[i, 0], res_err[i, 0], N2)
        RES[i*N2:(i+1)*N2, 1] = np.random.normal(res[i, 1], res_err[i, 1], N2)
    # Checking the normal distribution of each coefficient
    nk = 2
    fig, axs = plt.subplots(1, nk, figsize=(4*nk, 4), dpi = 300)
    fig.subplots_adjust(hspace=0.5, wspace=0.5)
    for i in range(nk):
        ax = axs[i]
        ax.set_xlabel(r'$C_{%d}$' % i)
        ax.set_ylabel('Probability', fontsize = 16)
        ax.set_title(r'$C_{%d}$ = %.2e $\pm$ %.2e' % (i, np.average(RES[:, i]), np.std(RES[:, i])), fontsize = 12)
        count, bins, ignored = ax.hist(RES[:, i], 30, density=True)
        mu, sigma = np.average(RES[:, i]), np.std(RES[:, i])
        ax.plot(bins, 1/(sigma * np.sqrt(2 * np.pi)) *
                    np.exp( - (bins - mu)**2 / (2 * sigma**2) ),
                linewidth=2, color='r')
    plt.tight_layout()
    plt.savefig('figures/ndist_%d.png' % system, dpi=300)
    plt.show()
    plt.close()
    res_avg = unumpy.uarray(np.average(RES, axis=0), 2 * np.std(RES, axis=0))
    a = res_avg[0]
    b = res_avg[1]
    x = np.linspace(0, 0.05, 100)
    y = unumpy.exp(a + b * x)
    y_mean = unumpy.nominal_values(y)
    y_std = unumpy.std_devs(y)
    y_err = unumpy.std_devs(y_mean)
    visc_eq = unumpy.exp(a)
    print(f"... viscosity at equilibrium: {unumpy.nominal_values(visc_eq):.3f} ± {unumpy.std_devs(visc_eq):.3f} cp")
    visc_final.append(unumpy.nominal_values(visc_eq)), viscerr_final.append(unumpy.std_devs(visc_eq))
    fig, ax = plt.subplots(figsize=(3.93701, 3.43701), dpi = 1200)
    ax.set_title(r'System {}'.format(system), fontsize=16, pad=10)
    fig.subplots_adjust(hspace=0.5, wspace=0.5)
    ax.errorbar(amp_aux, visc_aux, yerr=viscerr_aux, fmt='o', color='black', label='Data')
    ax.plot(x, y_mean, color='red', label='Fit')
    ax.fill_between(x, y_mean - y_std, y_mean + y_std, color='red', alpha=0.2, label='Uncertainty')
    ax.errorbar([0.0], [unumpy.nominal_values(visc_eq)], yerr=[unumpy.std_devs(visc_eq)], fmt='o', color='blue', markersize=5, capsize=3, 
    label='Equilibrium viscosity \n {:.3f} ± {:.3f} cp'.format(unumpy.nominal_values(visc_eq), unumpy.std_devs(visc_eq)))
    ax.set_xlabel(r'A / nm ps$^{-2}$', fontsize=16)
    ax.set_ylabel(r'$\eta$ / cp', fontsize=16)
    ax.set_xscale('linear')
    ax.legend(fontsize=6, frameon=False)
    ax.set_xlim(0, 0.04)
    ax.set_xticks(np.arange(0, 0.05, 0.01))
    ax.set_ylim(0, None)
    plt.tight_layout()
    plt.savefig('figures/visc_%d.png' % system, dpi=300)
    plt.show()

os.system('mkdir -p viscosities')
visc_final, viscerr_final = np.array(visc_final), np.array(viscerr_final)
for i,system in enumerate(sys_vec):
    with open('viscosities/'+sys_nms[system==sys_vec][0]+'.out', 'w') as f:
        f.write('# x1\t\tvisc/cP\t\tdvisc/cP\n')
        f.write(f'{x1_vec[0]}\t{visc_final[i]:.5f}\t{viscerr_final[i]:.5f}\n')
print('\nFINISHED... data saved in viscosities/')
