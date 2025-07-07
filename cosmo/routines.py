from __future__ import division, print_function, absolute_import
import numpy as np

def ReadCOSMOthermEnergies(filename):
    data = {}
    compound = ''
    temperature = None
    start_reading = False
    with open(filename, 'r') as file:
        for line in file:
            if 'Property' in line:
                start_reading = False
                if line.split(':')[1].split()[2] == 'molecule/conformer':
                    continue
            elif 'Settings' in line:
                temperature = float(line.split('=')[1].split()[0])
            elif 'Units' in line:
                E_units = line.split(':')[1].split()[2]
                if E_units == 'kJ/mol':
                    Econversion = 1
                elif p_units == 'kcal/mol':
                    Econversion = 1/4.184
            elif 'Nr' in line:
                start_reading = True
                continue
            if start_reading and line.strip():    
                compound = line.split()[1]
                hint, hmf, hhb, hvdw, hglt = [float(line.split()[i])*Econversion for i in range(5,10)]
                data[(temperature, compound)] = [hint, hmf, hhb, hvdw, hglt]
    return data

def ReadCOSMOthermSolvation(filename):
    data = {}
    compound = ''
    temperature = None
    start_reading = False
    with open(filename, 'r') as file:
        for line in file:
            if 'Property' in line:
                start_reading = False
            elif 'Settings' in line:
                temperature = float(line.split('=')[1].split()[0])
            elif 'Units' in line:
                E_units = line.split(':')[1].split()[2]
                KH_units = line.split(';')[2].split()[3]
                if KH_units == 'bar':
                    KH_conversion = .1
                elif KH_units == 'MPa':
                    KH_conversion = 1.
                if E_units == 'kJ/mol':
                    Econversion = 1.
                elif E_units == 'kcal/mol':
                    Econversion = 1./4.184
            elif 'Nr' in line:
                start_reading = True
                continue
            if start_reading and line.strip():    
                compound, KH, lngamma, Gsolv = line.split()[1], line.split()[2], line.split()[3], line.split()[4]
                if KH != 'NA':
                    KH = float(KH)*KH_conversion
                    gamma = np.exp(float(lngamma))
                    Gsolv = float(Gsolv)*Econversion
                else:
                    KH, gamma, Gsolv = None, None, None
                data[(temperature, compound)] = [KH, gamma, Gsolv]
    return data

def ReadCOSMOthermGamma(filename):
    data = {}
    x1 = None
    temperature = None
    x1_vec, gamma_vec = [], []
    start_reading = False
    with open(filename, 'r') as file:
        for line in file:
            if 'Property' in line:
                start_reading = False
            elif 'Settings' in line:
                temperature = float(line.split('=')[1].split()[0])
                x1 = float(line.split('=')[2].split()[0])
            elif 'Nr' in line:
                start_reading = True
                continue
            if start_reading and line.strip():    
                lngamma = line.split()[3]
                if lngamma != 'NA':
                    gamma = np.exp(float(lngamma))
                else:
                    gamma = None
                if gamma is not None:
                    x1_vec.append(x1), gamma_vec.append(gamma)
    data[temperature] = [x1_vec, gamma_vec]
    return data

def ReadCOSMOthermIsotherm(filename):
    data = {}
    compound = ''
    temperature = None
    start_reading = False
    with open(filename, 'r') as file:
        for line in file:
            if 'Property' in line:
                start_reading = False
                if line.split(':')[1].split()[0] == 'LLE':
                    continue
                else:
                    x1, y1, ptot = [], [], []
            elif 'Compounds' in line:
                compound = line.split(':')[1].split()[0]
            elif 'Settings' in line:
                temperature = float(line.split('=')[1].split()[0])
            elif 'Units' in line:
                p_units = line.split(';')[1].split()[2]
                if p_units == 'mbar':
                    pconversion = 1e-4
                elif p_units == 'kPa':
                    pconversion = 1e-3
            elif 'x1' in line:
                start_reading = True
                continue
            if start_reading and line.strip():
                x1.append(float(line.split()[0])), y1.append(float(line.split()[-2])), ptot.append(float(line.split()[4])*pconversion)
                data[(temperature, compound)] = [x1, y1, ptot]
    return data

def ReadCOSMOthermDensity(filename):
    data = {}
    xHBA, density = [], []
    temperature = None
    start_reading = False
    with open(filename, 'r') as file:
        for line in file:
            if 'Property' in line:
                start_reading = False
            elif 'Settings' in line:
                temperature = float(line.split('=')[1].split()[0])
            elif 'Units' in line:
                d_units = line.split('Density')[1].split()[1]
                if d_units == 'g/cm^3':
                    dconversion = 1
                else:
                    raise ValueError('Density units not recognized')
            elif 'x1' in line:
                start_reading = True
                continue
            if start_reading and line.strip():
                density.append(float(line.split()[-2]))
                for i in range(len(line.split())):
                    if float(line.split()[i]) != 0:
                        xHBA.append(float(line.split()[i])*2)
                        break
                data[(temperature)] = [xHBA, density]
    return data

def ReadCOSMOthermExcess(filename):
    data = {}
    compound = ''
    temperature = None
    start_reading = False
    with open(filename, 'r') as file:
        for line in file:
            if 'Property' in line:
                start_reading = False
                x1, he, ge, he_mf, he_hb, he_vdw, he_conf = [], [], [], [], [], [], []
            elif 'Compounds' in line:
                compound = line.split(':')[1].split()[0]
            elif 'Settings' in line:
                temperature = float(line.split('=')[1].split()[0])
            elif 'Units' in line:
                e_units = line.split(';')[0].split()[-1]
                if e_units == 'kcal/mol':
                    econversion = 4.184
                elif e_units == 'kJ/mol':
                    econversion = 1.0
            elif 'x1' in line:
                start_reading = True
                continue
            if start_reading and line.strip():
                x1.append(float(line.split()[0])), he.append(float(line.split()[2])*econversion), ge.append(float(line.split()[3])*econversion)
                he_mf.append(float(line.split()[-5])*econversion), he_hb.append(float(line.split()[-4])*econversion)
                he_vdw.append(float(line.split()[-3])*econversion), he_conf.append(float(line.split()[-1])*econversion)
                data[(temperature, compound)] = [x1, he, ge, he_mf, he_hb, he_vdw, he_conf]
    return data
