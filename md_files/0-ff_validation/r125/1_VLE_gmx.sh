#!/bin/bash

module load gromacs
source ~/anaconda3/etc/profile.d/conda.sh

GMX=gmx_mpi
HOME=`pwd`

Tvec=(250 280 300)
Pvec=(3.00 8.47 14.61) # values from NIST
NLvec=(2230 2010 1820)
NVvec=(30 95 170)

Lx=5.0
Ly=5.0
Lz=12.5

for i in "${!Tvec[@]}"
do
    T=${Tvec[$i]}
    mkdir -p $HOME/${T}; cd $HOME/${T}
    mkdir -p 1_L; mkdir -p 2_V; mkdir -p 3_VLE
    for state in 1_L 2_V
    do
        cd $HOME/${T}/${state}
        mkdir -p 0_packmol; mkdir -p 1_minimization; mkdir -p 2_equilibrationNPzAT
        # initial configuration
        cd 0_packmol
        cp $HOME/pdb/RE5${state:2}.pdb .
        cp $HOME/scripts/packmol .; cp $HOME/scripts/create_packmol.py .
        conda activate
        if [ "$state" == "1_L" ]; then
            python3 create_packmol.py L ${NLvec[$i]} ${Lx} ${Ly} ${Lz}
        else
            python3 create_packmol.py V ${NVvec[$i]} ${Lx} ${Ly} ${Lz}
        fi
        conda deactivate
        chmod 777 packmol; ./packmol < pack.inp > pack.log 2>&1
        $GMX editconf -f init.pdb -o init.gro -box ${Lx} ${Ly} ${Lz} > editconf.log 2>&1
        rm -f packmol create_packmol.py \#*; cd ..
        # topology
        cp $HOME/scripts/create_topol.py .; cp $HOME/scripts/new_topol.py .
        conda activate
        if [ "$state" == "1_L" ]; then
            python3 create_topol.py L ${NLvec[$i]}
        else
            python3 create_topol.py V ${NVvec[$i]}
        fi
        python new_topol.py $HOME
        conda deactivate
        INIT=$HOME/${T}/${state}/0_packmol/init.gro
        TOPOL=$HOME/${T}/${state}/topol.top
        rm -f create_topol.py new_topol.py system_original.top \#*
        # minimization
        cd 1_minimization
        cp $HOME/mdp/minimization.mdp .
        $GMX grompp -f minimization.mdp -c $INIT -p $TOPOL -o min.tpr > grompp.log 2>&1
        $GMX mdrun -deffnm min -v > mdrun.log 2>&1
        INIT=$HOME/${T}/${state}/1_minimization/min.gro
        rm -f \#*; cd ..
        # equilibration
        cd 2_equilibrationNPzAT
        cp $HOME/mdp/equilibrationNPzAT.mdp .
        if [ "$state" == "1_L" ]; then
            Ns=60000000
            fgrid=0.12
        else
            Ns=10000000
            fgrid=3.00
        fi
        temp=$T
        pres=${Pvec[$i]}
        sed -i "s/NSTEPS/$Ns/g" equilibrationNPzAT.mdp
        sed -i "s/FGRID/$fgrid/g" equilibrationNPzAT.mdp
        sed -i "s/TEMP/$temp/g" equilibrationNPzAT.mdp
        sed -i "s/PRES/$pres/g" equilibrationNPzAT.mdp
        $GMX grompp -f equilibrationNPzAT.mdp -c $INIT -p $TOPOL -o npzat.tpr > grompp.log 2>&1
        printf "> running NPzAT ${state:2} slab simulation at $temp K\n..."
        $GMX mdrun -deffnm npzat -v > mdrun.log 2>&1
        INIT=$HOME/${T}/${state}/2_equilibrationNPzAT/npzat.gro
        rm -f \#*; cd ..
    done
    # VLE system
    cd $HOME/${T}/3_VLE
    mkdir -p 0_initial_configuration; mkdir -p 1_minimization; mkdir -p 2_productionNVT
    state="VLE"
    # initial configuration
    cd 0_initial_configuration
    cp $HOME/${T}/1_L/2_equilibrationNPzAT/npzat.gro L.gro
    cp $HOME/${T}/2_V/2_equilibrationNPzAT/npzat.gro V.gro
    cp $HOME/scripts/merge_boxes.py .
    conda activate MD
    python3 merge_boxes.py
    conda deactivate
    rm -f merge_boxes.py
    cd ..
    # topology
    cp $HOME/scripts/create_topol.py .; cp $HOME/scripts/new_topol.py .
    conda activate
    python3 create_topol.py VLE ${NLvec[$i]} ${NVvec[$i]}
    python new_topol.py $HOME
    conda deactivate
    INIT=$HOME/${T}/3_VLE/0_initial_configuration/init.gro
    TOPOL=$HOME/${T}/3_VLE/topol.top
    rm -f create_topol.py new_topol.py system_original.top \#*
    # minimization
    cd 1_minimization
    cp $HOME/mdp/minimization.mdp .
    $GMX grompp -f minimization.mdp -c $INIT -p $TOPOL -o min.tpr > grompp.log 2>&1
    $GMX mdrun -deffnm min -v > mdrun.log 2>&1
    INIT=$HOME/${T}/3_VLE/1_minimization/min.gro
    rm -f \#*; cd ..
    # production
    cd 2_productionNVT
    cp $HOME/mdp/productionNVT.mdp .
    temp=$T
    sed -i "s/TEMP/$temp/g" productionNVT.mdp
    $GMX grompp -f productionNVT.mdp -c $INIT -p $TOPOL -o nvt.tpr > grompp.log 2>&1
    printf "> running NVT VLE simulation at $temp K\n..."
    $GMX mdrun -deffnm nvt -v > mdrun.log 2>&1
    echo 2 0 | $GMX trjconv -f nvt.xtc -s nvt.tpr -pbc mol -center -o trj.xtc > trjconv.log 2>&1
    echo 0 | $GMX density -f trj.xtc -s nvt.tpr -b 30000 -o density.xvg > density.log 2>&1
    echo 33 34 35 | $GMX energy -f nvt.edr -s nvt.tpr -b 30000 -o energy.xvg > energy.log 2>&1
    rm -f \#*; cd ..
    cd $HOME
done
