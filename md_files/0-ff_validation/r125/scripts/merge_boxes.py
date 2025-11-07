import MDAnalysis as mda
import numpy as np

uL = mda.Universe('L.gro')
uV = mda.Universe('V.gro')
coords_L = np.copy(uL.atoms.positions)
coords_V = np.copy(uV.atoms.positions)

Lx  = np.copy(uL.dimensions[:3][0])
Ly  = np.copy(uL.dimensions[:3][1])
LzL = np.copy(uL.dimensions[:3][-1])
LzV = np.copy(uV.dimensions[:3][-1])
Lz  = LzL + 2.*LzV

with open('init.gro', 'w') as f:
    f.write('VLE for R32\n')
    f.write('  %.0f\n' % (len(uL.atoms) + 2.*len(uV.atoms)))
    for atom in uV.atoms:
        x, y, z = np.copy(atom.position)
        f.write('{:<5}{:>5}{:<5}{:>5}{:>8.3f}{:>8.3f}{:>8.3f}\n'.format(
            atom.resid, atom.resname, atom.name, 1+atom.index,
            x/10, y/10, z/10))
    last_resid = np.copy(atom.resid)
    last_index = 1+np.copy(atom.index)
    for atom in uL.atoms:
        x, y, z = np.copy(atom.position) + np.array([0, 0, LzV])
        f.write('{:<5.0f}{:>5}{:<5}{:>5}{:>8.3f}{:>8.3f}{:>8.3f}\n'.format(
            atom.resid+last_resid, atom.resname, atom.name, 1+atom.index+last_index,
            x/10, y/10, z/10))
    last_resid = np.copy(atom.resid)+last_resid
    last_index = 1+np.copy(atom.index)+last_index
    for atom in uV.atoms:
        x, y, z = np.copy(atom.position) + np.array([0, 0, LzL+LzV])
        f.write('{:<5.0f}{:>5}{:<5}{:>5}{:>8.3f}{:>8.3f}{:>8.3f}\n'.format(
            atom.resid+last_resid, atom.resname, atom.name, 1+atom.index+last_index,
            x/10, y/10, z/10))
    f.write('{:>10.5f}{:>10.5f}{:>10.5f}\n'.format(Lx/10, Ly/10, Lz/10))