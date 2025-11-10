#!/bin/bash

module load gromacs
source ~/anaconda3/etc/profile.d/conda.sh

GMX=gmx_mpi

system=$1

HOME=`pwd`
mkdir -p $HOME/results
cd $HOME/MD/${system}
SYSTEM=`pwd`
printf "_____________________________________________\n     SYSTEM: ${system}   \n_____________________________________________\n"
############################ INITIALIZATION ################################
rm system.top
cp $HOME/scripts/new_topol.py .
python new_topol.py $HOME
rm new_topol.py
TOPOL=$SYSTEM/system.top
cd $SYSTEM
for i in {1..4}; do
  ########################## NVT EQUILIBRATION ###############################
  cd run_$i/2_eqNVT/
  $GMX mdrun -deffnm eq >> mdrun.log 2>&1
  ############################ NVT PRODUCTION ################################
  cd ../; mkdir -p 3_prNVT; cd 3_prNVT; rm -f *.log
  cp $HOME/mdp/productionNVT.mdp pr.mdp
  gmx_mpi grompp -f pr.mdp -c ../2_eqNVT/eq.gro -p $TOPOL -o pr.tpr -maxwarn 10 >> grompp.log 2>&1
  $GMX mdrun -deffnm pr >> mdrun.log 2>&1
  rm -f msd.log; rm -f $HOME/results/msd_${system}_${i}.log; rm -f $HOME/results/msd_${system}_${i}.xvg
  echo 5 | gmx_mpi msd -f pr.trr -s pr.tpr >> msd.log 2>&1
  cp msd.log $HOME/results/msd_${system}_${i}.log
  cp msd.xvg $HOME/results/msd_${system}_${i}.xvg
  cd $SYSTEM
  printf "\n\t...completed\n-----\n\n"
done
