#!/bin/bash

module load gromacs
source ~/anaconda3/etc/profile.d/conda.sh

GMX=gmx_mpi

system=$1

AMPVEC=(0.005 0.010 0.015 0.020 0.025 0.030 0.035 0.040)
if [[ "$system" =~ ^(1|4|7|10)$ ]]; then
  viscndx=39
else
  viscndx=38
fi

HOME=`pwd`
mkdir -p $HOME/results
cd $HOME/MD_NEMD/${system}
SYSTEM=`pwd`
printf "_____________________________________________\n     SYSTEM: ${system}   \n_____________________________________________\n"
############################ INITIALIZATION ################################
rm system.top
cp $HOME/scripts/new_topol.py .
python new_topol.py $HOME
rm new_topol.py
TOPOL=$SYSTEM/system.top
cd $SYSTEM
for i in {1..4}
do
  ########################## NVT EQUILIBRATION ###############################
  cd run_$i/2_eqNVT/
  $GMX mdrun -deffnm eq >> mdrun.log 2>&1
  ############################ NVT PRODUCTION ################################
  cd ../; mkdir -p 3_nemd; cd 3_nemd; rm -f *.log
  AMP=${AMPVEC[$(($i-1))]}
  sed -s 's/AMPVAL/'$AMP'/g' $HOME/mdp/nemdNVT.mdp > nvt.mdp
  gmx_mpi grompp -f nvt.mdp -c ../2_eqNVT/eq.gro -p $TOPOL -o nvt.tpr -maxwarn 10 >> grompp.log 2>&1
  $GMX mdrun -deffnm nvt >> mdrun.log 2>&1
  echo -e "Total-Energy\nPressure\nT-System" | gmx_mpi energy -f nvt.edr -s nvt.tpr -b 0 -o energy.xvg >> energy.log 2>&1
  rm -f visc.log; rm -f $HOME/results/visc_${system}_${AMP}.log; rm -f $HOME/results/visc_${system}_${AMP}.xvg
  echo -e $viscndx | gmx_mpi energy -f nvt.edr -s nvt.tpr -nbmin 10 -nbmax 10 -b 2000 -o $HOME/results/visc_${system}_${AMP}.xvg >> visc.log 2>&1
  grep "1/Viscosity" visc.log >> $HOME/results/visc_${system}_${AMP}.log 2>&1
  cd $SYSTEM
  printf "\n\t...completed\n-----\n\n"
done
