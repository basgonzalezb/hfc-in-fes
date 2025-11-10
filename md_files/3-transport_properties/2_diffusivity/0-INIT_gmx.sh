#!/bin/bash

module load gromacs
source ~/anaconda3/etc/profile.d/conda.sh

GMX=gmx_mpi

system=$1

HOME=`pwd`
PREV='../../../../../0_equilibrations/MD/'$system'/2_eqNPT'
mkdir -p $HOME/MD; mkdir -p $HOME/MD/${system}; cd $HOME/MD/${system}
cp ../../../0_equilibrations/MD/$system/system_original.top .
SYSTEM=`pwd`
printf "_____________________________________________\n     SYSTEM: ${system}   \n_____________________________________________\n"
cp $HOME/scripts/new_topol.py .
conda activate; python new_topol.py $HOME; conda deactivate
rm new_topol.py
TOPOL=$SYSTEM/system.top
for i in {1..4}; do
	printf "\t> run $i "
	rm -rf run_$i; mkdir -p run_$i; cd run_$i
	mkdir -p 0_initial; cd 0_initial
	printf "."
	echo 0 | gmx_mpi trjconv -s $PREV/eq2.tpr -f $PREV/eq2.xtc --dump $((30000-$i*500)) -o init_unscaled.gro >> trjconv.log 2>&1
	echo -e 'Box-X\n' | gmx_mpi energy -s $PREV/eq2.tpr -f $PREV/eq2.edr -b 15000 -o box.xvg >> box.log 2>&1
	LX=$(tail -n 5 box.log | grep 'Box-X' | awk '{print $2}')
	gmx_mpi editconf -f init_unscaled.gro -o init.gro -box $LX $LX $LX -c >> rescaling.log 2>&1
	printf "."
	cd ../; mkdir -p 1_min; cd 1_min
	cp $HOME/mdp/minimization.mdp min.mdp
	gmx_mpi grompp -f min.mdp -c ../0_initial/init.gro -p $TOPOL -o min.tpr >> grompp.log 2>&1
	$GMX mdrun -deffnm min >> mdrun.log 2>&1
	printf "."
	cd ../; mkdir -p 2_eqNVT; cd 2_eqNVT
	SEEDVAL=$((1 + $RANDOM))
	sed -s 's/MYSEED/'$SEEDVAL'/g' $HOME/mdp/equilibrationNVT.mdp > eq.mdp
	gmx_mpi grompp -f eq.mdp -c ../1_min/min.gro -p $TOPOL -o eq.tpr >> grompp.log 2>&1
	cd $SYSTEM
	printf "done!\n"
done
