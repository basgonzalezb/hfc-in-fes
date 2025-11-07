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

feps=1.00
for fsigma in 0.86 0.88 0.90 0.92 0.94
    do
        cd $HOME/FIT/
        rm -r fs_${fsigma}_and_fe_${feps}
        mkdir -p fs_${fsigma}_and_fe_${feps}
        cd fs_${fsigma}_and_fe_${feps}
        cp $HOME/scripts/atomtypes_hdfs_fit.py .
        conda activate
        python atomtypes_hdfs_fit.py $fsigma $feps
        conda deactivate
        rm atomtypes_hdfs_fit.py
        for ratio in 2_1 1_1 1_2
            do
                mkdir -p $ratio; cd  $ratio
                SYSTEM=`pwd`
                ########################## TOPOL ##########################
                cp $HOME/MD/system_original[${ratio}].top .
                cp $HOME/scripts/new_topol.py .
                conda activate
                python new_topol.py $HOME system_original[${ratio}].top
                conda deactivate
                sed -i "s/ROUTE/fs_${fsigma}_and_fe_${feps}/" system.top
                rm *.py system_original[${ratio}].top
                TOPOL=$SYSTEM/system.top
                for temp in 303 323
                    do
                        cd $SYSTEM
                        mkdir ${temp}; cd ${temp}
                        INIT=$HOME/MD/init[${ratio}].gro
                        ########################## MINIMIZATION ##########################
                        gmx_mpi grompp -f $HOME/mdp/minimization.mdp  -c $INIT  -p $TOPOL  -o min.tpr  >> 0_grompp_min.log 2>&1
                        gmx_mpi mdrun -v -deffnm min >> 0_run_min.log 2>&1
                        ########################## EQUILIBRATION #########################
                        TIME=$(( $Ns1/1000000 ))
                        cp $HOME/mdp/equilibrationNPT.mdp eq.mdp
                        sed -i "s/TEMPERATURE/$temp/" eq.mdp
                        sed -i "s/VALUE_NSTEPS/$Ns1/" eq.mdp
                        gmx_mpi grompp -f eq.mdp -c min.gro  -p $TOPOL -o eq.tpr -maxwarn 2  >> 1_grompp_eq.log 2>&1
                        $GMX mdrun -v -deffnm eq >> 1_run_eq.log 2>&1
                        ########################## PRODUCTION ###########################
                        TIME=$(( $Ns2/1000000 ))
                        cp $HOME/mdp/productionNPT.mdp pr.mdp
                        sed -i "s/TEMPERATURE/$temp/" pr.mdp
                        sed -i "s/VALUE_NSTEPS/$Ns2/" pr.mdp
                        gmx_mpi grompp -f pr.mdp -c eq.gro -p $TOPOL -o pr.tpr -t eq.cpt  >> 2_grompp_prd.log 2>&1
                        $GMX mdrun -v -deffnm pr >> 2_run_pr.log 2>&1
                        ########################## RESULTS ##############################
                        mkdir -p $HOME/results_fit
                        mkdir -p $HOME/results_fit/${ratio}
                        echo -e 'Pressure\nDensity\nT-System\nTotal-Energy'  | $GMX energy -f pr.edr -s pr.tpr -o $HOME/results_fit/${ratio}/energy_fs_${fsigma}_and_fe_${feps}_${temp}.xvg >> 3_energy.log 2>&1
                        rm 3_energy.log
                        echo -e 'Pressure\nDensity\nT-System\nTotal-Energy'  | $GMX energy -f pr.edr -s pr.tpr -o energy.xvg -b 2000 >> 3_energy.log 2>&1
                        grep "Pressure" 3_energy.log     | tail -n 1 >> $HOME/results_fit/${ratio}/pressure_fs_${fsigma}_and_fe_${feps}_${temp}.log 2>&1
                        grep "T-System" 3_energy.log     | tail -n 1 >> $HOME/results_fit/${ratio}/temperature_fs_${fsigma}_and_fe_${feps}_${temp}.log 2>&1
                        grep "Density" 3_energy.log      | tail -n 1 >> $HOME/results_fit/${ratio}/density_fs_${fsigma}_and_fe_${feps}_${temp}.log 2>&1
                        grep "Total Energy" 3_energy.log | tail -n 1 >> $HOME/results_fit/${ratio}/energy_fs_${fsigma}_and_fe_${feps}_${temp}.log 2>&1
                    done
            done
    done
