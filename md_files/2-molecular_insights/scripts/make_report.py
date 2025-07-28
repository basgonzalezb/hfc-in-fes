import numpy as np
from pandas import read_excel

import matplotlib.pyplot as plt
import matplotlib.transforms as mtransforms

import sys
import warnings



def load_data(path, sheet):
    """Load data from an Excel file."""
    warnings.simplefilter(action='ignore', category=UserWarning)
    return read_excel(path, sheet)

num_id =  int(sys.argv[1])       # INPUT: ID system (number)
HOME = str(sys.argv[2])          # INPUT: Folder Path


index_id = num_id - 1


# Information in data base
list_molecules = load_data(HOME + '/scripts/systems.xlsx', 'list-molecules')
name_DB = list(list_molecules.iloc[:,1])
ID_DB = list(list_molecules.iloc[:,2])
MW_DB = list(list_molecules.iloc[:,4])


# Information about the system "num_id"
ph = read_excel(HOME + '/scripts/systems.xlsx', 'phase')
system_name = ph.iloc[index_id,1]   # system full name
tag_name = ph.iloc[index_id,2]      # system tag name
T = float(ph.iloc[index_id,4])      # temperature [K]
P = float(ph.iloc[index_id,5])      # pressure    [bar]
nc = int(ph.iloc[index_id,6])       # number of components in the system (water no considered)


# Adding components
name_comp, N_ph = [], []
for i in range(nc):
    name_comp.append(ph.iloc[index_id, 2*i + 10])       # Saving name of cosolvent
    N_ph.append(int(ph.iloc[index_id, 2*i + 11]))       # Saving the amount of molecules of cosolvent
    

ID_comp, MW_comp = [], []
for i in range(nc):
    index = name_DB.index(name_comp[i])
    MW_comp.append(MW_DB[index])
    ID_comp.append(ID_DB[index])
mwi = np.array(MW_comp)

def error(x):
    n = len(x)
    mK = np.array(x)
    m = np.sum(mK)/n
    if m>0:
        error = np.sqrt(np.sum(mK**2 - m**2)/n)/np.sqrt(n - 1)
    else:
        error = 0
    return m, error

# Density profile
data = np.loadtxt("xvg/density_" + str(0) + ".xvg", comments=['#',"@"], unpack = True)
slb = np.shape(data)[-1]
z = np.zeros([slb])
n = 10
RHO = np.zeros([n, nc, slb]) # mass density
for i in range(n):
    data = np.loadtxt("xvg/density_" + str(i) + ".xvg", comments=['#',"@"], unpack = True)
    z, RHO[i] = data[0, :], data[1:nc + 1, :]
    
    
rho, rho_error = np.zeros([nc, slb]),  np.zeros([nc, slb])
for i in range(slb):
    for j in range(nc):
        rho[j, i], rho_error[j, i] = error(RHO[:, j, i])

rhoT, rhoT_error = np.sum(rho, axis = 0), np.sum(rho_error, axis = 0)
# mass density -> molar density
rho_mol, rho_mol_error = (rho.T/mwi).T, (rho_error.T/mwi).T
rhoT_mol, rhoT_mol_error = np.sum(rho_mol, axis = 0), np.sum(rho_error, axis = 0)

# Founding the interfase
drhoTdz = np.gradient(rhoT, z)
mindrdz = min(drhoTdz)
maxdrdz = max(drhoTdz)
z1, z2 = z[drhoTdz==mindrdz][0], z[drhoTdz==maxdrdz][0]
L = 3.0  # <- Interfacial width / nm
zi = [z1 - L/2, z1 + L/2, z2 - L/2, z2 + L/2]
zi.sort()

# Creating plot
colors = ["#000000", "#49C60A", "#FC7725", "#3A66F7", "#DBC30B"]

fig, axs = plt.subplots(2,1, figsize=(8, 8), dpi = 300)
fig.subplots_adjust(hspace=0.5, wspace=0.3)
font = {'weight' : 'normal',
        'size'   : 16}
plt.rc('font', **font)

for i in range(nc):
    axs[0].plot(z, rho[i] - rho_error[i], colors[i], alpha=0.5)
    axs[0].plot(z, rho[i] + rho_error[i], colors[i], alpha=0.5)
    axs[0].plot(z, rho[i], colors[i], label = name_comp[i])
axs[0].tick_params(labelbottom=True, labeltop=False, labelleft=True, labelright=False,
                     bottom=True, top=True, left=True, right=True, direction="in")

ymax = 1.1*np.max(rho)
trans = mtransforms.blended_transform_factory(axs[0].transData, axs[0].transAxes)
axs[0].fill_between(z, 0, ymax, where=(z>zi[0]) & (z<zi[1]),
                facecolor='0.8', alpha=0.5, transform=trans)
axs[0].fill_between(z, 0, ymax, where=(z>zi[2]) & (z<zi[3]),
                facecolor='0.8', alpha=0.5, transform=trans)
axs[0].set_ylabel(r'$\rho$ / $kg \cdot m^{-3}$')
axs[0].set_xlabel(r"$z$ / $nm$")
axs[0].axis([-10, 10, 0, 1000])
axs[0].legend(loc=3, borderaxespad=.1,fontsize=12)


for i in range(nc):
    axs[1].plot(z, rho_mol[i] - rho_mol_error[i], colors[i], alpha=0.5)
    axs[1].plot(z, rho_mol[i] + rho_mol_error[i], colors[i], alpha=0.5)
    axs[1].plot(z, rho_mol[i], colors[i], label = name_comp[i])
axs[1].tick_params(labelbottom=True, labeltop=False, labelleft=True, labelright=False,
                     bottom=True, top=True, left=True, right=True, direction="in")

trans = mtransforms.blended_transform_factory(axs[1].transData, axs[1].transAxes)
axs[1].fill_between(z, 0, ymax, where=(z>zi[0]) & (z<zi[1]),
                facecolor='0.8', alpha=0.5, transform=trans)
axs[1].fill_between(z, 0, ymax, where=(z>zi[2]) & (z<zi[3]),
                facecolor='0.8', alpha=0.5, transform=trans)
axs[1].set_ylabel(r'$\rho$ / $mol \cdot L^{-1}$')
axs[1].set_xlabel(r"$z$ / $nm$")
axs[1].axis([-10, 10, 0, 20])
axs[1].legend(loc=3, borderaxespad=.1,fontsize=12)
plt.savefig(system_name + ' density profile.pdf', dpi=300, transparent=True, bbox_inches='tight')  
plt.close()

DATA = np.zeros([slb, nc + 1])
for i in range(slb):
    DATA[i,:] = np.append(z[i], rho[:, i])
np.savetxt(system_name + ' density profile (mass).dat', DATA, delimiter=' ')

DATA = np.zeros([slb, nc + 1])
for i in range(slb):
    DATA[i,:] = np.append(z[i], rho_mol[:, i])
np.savetxt(system_name + ' density profile (mass).dat', DATA, delimiter=' ')



def density_determination(RHO):
    rho_phase2 = RHO[(z>zi[1]) & (z<zi[2])]
    return error(rho_phase2)

rhoi, rhoi_error = np.zeros(nc), np.zeros(nc)
rhoMi, rhoMi_error = np.zeros(nc), np.zeros(nc)
for i in range(nc):
    rhoi[i], rhoi_error[i] =  density_determination(rho[i])
    rhoMi[i], rhoMi_error[i] =  density_determination(rho_mol[i])

def mass_frac(rhoi, rhoi_error, rhoT, rhoT_error):
    xfrac = rhoi/rhoT
    error_xfrac = xfrac*np.sqrt((rhoi_error/rhoi)**2 + (rhoT_error/rhoT)**2)
    return xfrac, error_xfrac

xi, xi_error = np.zeros(nc), np.zeros(nc)
xMi, xMi_error = np.zeros(nc), np.zeros(nc)
for i in range(nc):
    xi[i], xi_error[i] =  mass_frac(rhoi[i], rhoi_error[i], np.sum(rhoi), np.sum(rhoi_error))
    xMi[i], xMi_error[i] =  mass_frac(rhoMi[i], rhoMi_error[i], np.sum(rhoMi), np.sum(rhoMi_error))
    
s = 2*rhoMi[2]/(rhoMi[0] + rhoMi[1])
t, U, T, P, g = np.loadtxt("xvg/energy.xvg",comments=["#","@"],unpack=True)
g *= 0.05


T = T[t>50000]
P = P[t>50000]
g = g[t>50000]



N = 10
n = len(P)
st = int(n/N)
Pavg, gavg, Tavg, Uavg = [], [], [], []
for i in range(N):
    Pavg.append(np.average(P[st*i:st*(i+1)]))
    gavg.append(np.average(g[st*i:st*(i+1)]))
    Tavg.append(np.average(T[st*i:st*(i+1)]))
    Uavg.append(np.average(U[st*i:st*(i+1)]))

Pzz, error_Pzz = error(Pavg)
g, error_g = error(gavg)
T, error_T = error(Tavg)
U, error_U = error(Uavg)
    
f= open(system_name + " REPORT.txt","w+")
f.write("REPORT\n")
f.write(system_name)
f.write("\n#######################################\n")
f.write("s [HBD/HBA]: %26.2f\n"%(s))
f.write("Temperature [K]: %16.3f+-%1.3f\n"%(T, error_T))
f.write("Pressure-ZZ [bar]: %14.3f+-%1.3f\n"%(Pzz, error_Pzz))
f.write("Surface tension [mN/m]: %9.3f+-%1.3f\n"%(g, error_g))
f.write("_______________________________________\n")
f.write("\nBulk Phase in mass\n")
f.write(" Density [kg/m3]: %10.3f+-%1.3f\n"%(np.sum(rhoi), np.sum(rhoi_error)))
for i in range(nc):
    f.write("  * Mass fraction (%1.0f): %5.5f+-%1.5f\n"%(i + 1, xi[i], xi_error[i]))


f.write("\nBulk Phase in mol\n")
f.write(" Density [mol/L]: %10.3f+-%1.3f\n"%(np.sum(rhoMi), np.sum(rhoMi_error)))
for i in range(nc):
    f.write("  * Mol fraction (%1.0f):  %5.5f+-%1.5f\n"%(i + 1, xMi[i], xMi_error[i]))
f.write("_______________________________________\n")
f.close()

t, Uv, Tv, P, gv = np.loadtxt("xvg/energy.xvg",comments=["#","@"],unpack=True)
gv *= 0.05

N = 100
n = len(P)
st = int(n/N)
Pavg, gavg, Tavg, Uavg, tavg = [], [], [], [], []
for i in range(N):
    tavg.append(np.average(t[st*i:st*(i+1)])/1000)
    Pavg.append(np.average(P[st*i:st*(i+1)]))
    gavg.append(np.average(gv[st*i:st*(i+1)]))
    Tavg.append(np.average(Tv[st*i:st*(i+1)]))
    Uavg.append(np.average(Uv[st*i:st*(i+1)])/1000)
    
fig, axs = plt.subplots(2, 2, figsize=(12, 10), dpi=300)
fig.subplots_adjust(hspace=0.5, wspace=0.5)

ax = axs[0,0]
ax.plot(tavg, Pavg, c = colors[0])
ax.plot([0, max(t)/1000], [Pzz, Pzz], "-k", label=r"$P_{N,avg}=$" + str(round(Pzz,2)) + " $\pm$ " + str(round(error_Pzz,2)) + " bar")
ax.plot([0, max(t)/1000], [Pzz - error_Pzz, Pzz - error_Pzz], "--k")
ax.plot([0, max(t)/1000], [Pzz + error_Pzz, Pzz + error_Pzz], "--k")
ax.set_xlabel("time / ns")
ax.set_ylabel(r"Pressure-ZZ / $bar$")
ax.axis([0, np.max(t)/1000, round(np.min(Pavg) - error_Pzz,0), round(np.max(Pavg) + error_Pzz,0)])
ax.legend(fontsize=12)

ax = axs[0,1]
ax.plot(tavg, Tavg, c = colors[1])
ax.plot([0, max(t)/1000], [T, T], "-k", label=r"$T_{avg}=$" + str(round(T,2)) + " $\pm$ " + str(round(error_T,2)) + " K")
ax.plot([0, max(t)/1000], [T - error_T, T - error_T], "--k")
ax.plot([0, max(t)/1000], [T + error_T, T + error_T], "--k")
ax.set_xlabel("time / ns")
ax.set_ylabel(r"Tmperature / $K$")
ax.axis([0, np.max(t)/1000, round(0.5*(np.min(Tavg) - 1.05*error_T),1)*2, round(0.5*(np.max(Tavg) + 1.05*error_T),1)*2])
ax.legend(fontsize=12)

ax = axs[1,0]
ax.plot(tavg, gavg, c = colors[2], label=r"$\gamma_{avg}=$" + str(round(g,2)) + " $\pm$ " + str(round(error_g,2)) + " $mN \cdot m^{-1}$")
ax.plot([0, max(t)/1000], [g, g], "-k")
ax.plot([0, max(t)/1000], [g - error_g, g - error_g], "--k")
ax.plot([0, max(t)/1000], [g + error_g, g + error_g], "--k")
ax.set_xlabel("time / ns")
ax.set_ylabel(r"Surface Tension / $mN \cdot m^{-1}$")
ax.axis([0, np.max(t)/1000, round(np.min(gavg) - error_g, 0), round(error_g + np.max(gavg), 0)])
ax.legend(fontsize=12)

ax = axs[1,1]
ax.plot(tavg, Uavg, c = colors[3])
ax.plot([0, max(t)/1000], [U/1000, U/1000], "-k")
ax.plot([0, max(t)/1000], [U/1000 - error_U/1000, U/1000 - error_U/1000], "--k")
ax.plot([0, max(t)/1000], [U/1000 + error_U/1000, U/1000 + error_U/1000], "--k")
ax.set_xlabel("time / ns")
ax.set_ylabel(r"Total Energy / $MJ \cdot mol^{-1}$")
ax.axis([0, np.max(t)/1000, round(np.min(Uavg) - error_U/1000, 1), round(error_U/1000 + np.max(Uavg), 1)])
plt.savefig(system_name + ' evolution time.pdf', dpi=300, transparent=True, bbox_inches='tight')  
plt.close()