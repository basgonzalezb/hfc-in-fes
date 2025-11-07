#!/bin/bash

module load gromacs
source ~/anaconda3/etc/profile.d/conda.sh

conda activate
python scripts/name.py 
conda deactivate

GMX=gmx_mpi
HOME=`pwd`

Ns1=500000   # Number step EQ at Tsys (1 fs) NPT [0.5 ns]
Ns2=5000000  # Number step PROD at Tsys (1 fs) NPT [5 ns]

fsigma=1.00
for feps in 0.89 0.92 0.95
    do
        cd $HOME/FIT/
        rm -r fs_${fsigma}_and_fe_${feps}
        mkdir -p fs_${fsigma}_and_fe_${feps}
        cd fs_${fsigma}_and_fe_${feps}
        SYSTEM=`pwd`
        cp $HOME/scripts/atomtypes_fit.py .
        conda activate
        python atomtypes_fit.py $fsigma $feps
        conda deactivate
        rm atomtypes_fit.py
        ########################## TOPOL ##########################
        cp $HOME/MD/system_original.top .
        cp $HOME/scripts/new_topol.py .
        conda activate
        python new_topol.py $HOME $fsigma $feps
        conda deactivate
        sed -i "s/ROUTE/fs_${fsigma}_and_fe_${feps}/" system.top
        rm *.py system_original.top
        TOPOL=$SYSTEM/system.top
        for temp in 303 323 343
            do
                cd $SYSTEM
                mkdir ${temp}
                cd ${temp}
                INIT=$HOME/MD/prod.gro
                ########################## MINIMIZATION ########################## 
                printf "Minimization \n  "
                gmx_mpi grompp -f $HOME/mdp/minimization.mdp  -c $INIT  -p $TOPOL  -o min.tpr  >> 0_grompp_min.log 2>&1
                gmx_mpi mdrun -v -deffnm min >> 0_run_min.log 2>&1
                ########################## EQUILIBRATION ########################## 
                TIME=$(( $Ns1/1000000 ))
                printf "Equilibration NPT using 1 fs as timestep for $Ns1 steps ($TIME ns) at ${temp} K:  \n  "
                cp $HOME/mdp/equilibrationNPT.mdp eq.mdp
                sed -i "s/TEMPERATURE/${temp}/" eq.mdp
                sed -i "s/VALUE_NSTEPS/$Ns1/" eq.mdp
                gmx_mpi grompp -f eq.mdp -c min.gro  -p $TOPOL -o eq.tpr -maxwarn 2  >> 1_grompp_eq.log 2>&1
                $GMX mdrun -v -deffnm eq >> 1_run_eq.log 2>&1
                ########################## PRODUCTION ########################## 
                TIME=$(( $Ns2/1000000 ))
                printf "Production NPT using 1 fs as timestep for $Ns2 steps ($TIME ns) at ${temp} K:  \n  "
                cp $HOME/mdp/productionNPT.mdp prd.mdp
                sed -i "s/TEMPERATURE/${temp}/" prd.mdp
                sed -i "s/VALUE_NSTEPS/$Ns2/" prd.mdp
                gmx_mpi grompp -f prd.mdp -c eq.gro -p $TOPOL -o prod.tpr -t eq.cpt  >> 2_grompp_prd.log 2>&1
                $GMX mdrun -v -deffnm prod >> 2_run_prod.log 2>&1
                ########################## RESULTS ##########################
                echo -e 'Pressure \nDensity \nT-System \nTotal-Energy'  | gmx_mpi energy -f prod.edr -s prod.tpr -o $HOME/results_fit/energy_fs_${fsigma}_and_fe_${feps}_${temp}.xvg >> 3_energy.log 2>&1
                rm 3_energy.log
                echo -e 'Pressure \nDensity \nT-System \nTotal-Energy'  | gmx_mpi energy -f prod.edr -s prod.tpr -o energy.xvg -b 2000 >> 3_energy.log 2>&1
                grep "Pressure" 3_energy.log  | tail -n 1 >> $HOME/results_fit/pressure_fs_${fsigma}_and_fe_${feps}_${temp}.log 2>&1
                grep "Pressure" 3_energy.log  | tail -n 1 >> $HOME/results_fit/pressure_fs_${fsigma}_and_fe_${feps}_${temp}.log 2>&1
                grep "T-System" 3_energy.log  | tail -n 1 >> $HOME/results_fit/temperature_fs_${fsigma}_and_fe_${feps}_${temp}.log 2>&1
                grep "Density" 3_energy.log  | tail -n 1 >> $HOME/results_fit/density_fs_${fsigma}_and_fe_${feps}_${temp}.log 2>&1
                grep "Total-Energy" 3_energy.log  | tail -n 1 >> $HOME/results_fit/energy_fs_${fsigma}_and_fe_${feps}_${temp}.log 2>&1
            done
    done
