from pandas import read_excel
import numpy as np
import shutil
import sys
import datetime
import warnings

def load_data(path, sheet):
    """Load data from an Excel file."""
    warnings.simplefilter(action='ignore', category=UserWarning)
    return read_excel(path, sheet)

num_id =  int(sys.argv[1])       # INPUT: ID system (number)
HOME = str(sys.argv[2])          # INPUT: Folder Path

index_id = num_id - 1

Nav = 6.0221408e23                # Avogadro constant

# Information in data base
list_molecules = load_data(HOME + '/scripts/systems.xlsx', 'list-molecules')
name_DB = list(list_molecules.iloc[:,1])
ID_DB = list(list_molecules.iloc[:,2])
MW_DB = list(list_molecules.iloc[:,4])


# Information about the system "num_id"
ph = read_excel(HOME + '/scripts/systems.xlsx', 'phase-homo')
system_name = ph.iloc[index_id,1]   # system full name
tag_name = ph.iloc[index_id,2]      # system tag name
T = float(ph.iloc[index_id,4])      # temperature [K]
P = float(ph.iloc[index_id,5])      # pressure    [bar]
nc = int(ph.iloc[index_id,6])       # number of components in the system (water no considered)
Lx = float(ph.iloc[index_id,7])     # Lx    [nm]
Ly = float(ph.iloc[index_id,8])     # Ly    [nm]
Lz = float(ph.iloc[index_id,9])     # Lz    [nm]

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
        
# Box desing using the mass density
x = np.array(N_ph)/sum(N_ph)      # mol fracction
mws = np.dot(x,mwi)               # molecular weight [g/mol]
NT = sum(N_ph)                    # total amount of molecules
molT = NT/Nav                     # total amount of moles
rho = 1e24*mws*molT/(Lx*Ly*Lz)    # initial mass density [kg/m3]

###############################################################################
###                             LOG FILE                                    ###
###############################################################################
f = open("../" + str(num_id) + "_Initial_Configuration.log","w+")

f.write("#############################################\n")
f.write(" ID:" + str(num_id) + " | "+ system_name +"\n")
f.write(" T [K]: %36.2f\n"%T)
f.write(" P [bar]: %34.2f\n"%P)
f.write("#############################################\n")
f.write(" * Number of molecules\n")
for i in range(nc):
    aux = len(name_comp[i]) + len(ID_comp[i]) + len(str(int(N_ph[i])))
    if aux>34:
        aux = 34
    space = ' '*(34 - aux)
    f.write('   - '+name_comp[i]+" (" + ID_comp[i] +")" + ": " 
            + space + str(int(N_ph[i])) + "\n")
aux = len("Total") + len(str(int(sum(N_ph))))
space = ' '*(37 - aux)
f.write("   - Total: " + space + str(int(sum(N_ph))) + "\n")
f.write(" * Box initial dimensions \n")
f.write("   - Lx [nm]: %30.5f \n"%Lx)
f.write("   - Ly [nm]: %30.5f \n"%Ly)
f.write("   - Lz [nm]: %30.5f \n"%Lz)
f.write(" * Mass Density \n")
f.write("   - rho [kg/m3]: %26.0f \n"%rho)
f.write("#############################################\n")
f.close()


print(" Initial Configuration ")
print("_____________________________________________")
print(" ID:" + str(num_id) + " | "+ system_name +"\n")
print(" T [K]: %36.2f"%T)
print(" P [bar]: %34.2f"%P)
print("_____________________________________________")
print(" * Number of molecules")
for i in range(nc):
    aux = len(name_comp[i]) + len(ID_comp[i]) + len(str(int(N_ph[i])))
    if aux>34:
        aux = 34
    space = ' '*(34 - aux)
    print('   - '+name_comp[i]+" (" + ID_comp[i] +")" + ": " 
            + space + str(int(N_ph[i])))
aux = len("Total") + len(str(int(sum(N_ph))))
space = ' '*(37 - aux)
print("   - Total: " + space + str(int(sum(N_ph))))
print(" * Box initial dimensions ")
print("   - Lx [nm]: %30.5f"%Lx)
print("   - Ly [nm]: %30.5f"%Ly)
print("   - Lz [nm]: %30.5f"%Lz)
print(" * Mass Density ")
print("   - rho [kg/m3]: %26.0f"%rho)
print("_____________________________________________")


###############################################################################
###                      INP FILES for PACKMOL                              ### 
###############################################################################
tol = 1.
f = open("system.inp","w+")
f.write("tolerance 2.0\n")
f.write("filetype pdb\n")
f.write("output  system.pdb \n\n")  

for i in range(nc):
    f.write("structure "+ ID_comp[i]+".pdb \n")
    f.write("  number "+ str(N_ph[i]) +" \n")
    f.write("  inside box 0. 0. 0. %.3f %.3f %4.3f \n"
        %(Lx*10 - tol,Ly*10 - tol,Lz*10 - tol))
    f.write("end structure\n\n")
    shutil.copy(HOME + "/pdb/"  + ID_comp[i] +".pdb", ID_comp[i] +".pdb")        # copy pdb file into the folder
f.close()


###############################################################################
###                            TOPOL FILE                                   ###
###############################################################################

HOME2="PWD"
f = open('system_original.top',"w+")

f.write(";; F-Gases Proyect \n")
f.write(";; Date:" + str(datetime.datetime.now()))


f.write("\n\n [ defaults ] \n")
f.write(";nbfunc comb-rule gen-pairs fudgeLJ fudgeQQ \n")
f.write(" 1           3        yes        0.5     0.5 \n")


f.write("\n; Include atomtypes \n")
for i in range(nc):
    f.write("#include \"" + HOME2 + "/ff/" + str(ID_comp[i]) +"_atoms.itp\"\n")



f.write("\n; ; Include molecules \n") 
for i in range(nc):             
    f.write("#include \"" + HOME2 + "/ff/" + str(ID_comp[i]) +".itp\"\n")

f.write("\n [ system ] \n")
f.write("; Name \n") 
f.write(system_name + "\n") 

f.write("\n[ molecules ] \n") 
f.write("; Compound        #mols \n") 

for i in range(nc):
    ncg = N_ph[i]
    aux = len(ID_comp[i])
    space = ' '*(10 - aux)
    f.write(ID_comp[i]+space+"     %.0f\n"%ncg)
f.close()

###############################################################################
###                             SAVE INFO                                   ###
###############################################################################

f= open("dimension-system.gro","w+")
f.write("%10.5f%10.5f%10.5f"%(Lx, Ly, Lz))
f.close()

f= open("temperature.txt","w+")
f.write("%0.2f"%(T))
f.close()

f= open("pressure.txt","w+")
f.write("%0.2f"%(P))
f.close()

f= open("name.txt","w+")
f.write(system_name)
f.close()

f= open("name_id.txt","w+")
f.write(tag_name)
f.close()

###############################################################################
