#!/bin/bash

module load gromacs
source ~/anaconda3/etc/profile.d/conda.sh

GMX=gmx_mpi
HOME=`pwd`

for system in {1..18}
do
	cd $HOME/MD/${system}
	SYSTEM=`pwd`
	printf "_____________________________________________\n     SYSTEM: ${system}   \n_____________________________________________\n"
	############################ INITIALIZATION ################################
	cd 0_packmol
	system_name="$(cat name.txt)"
	system_tag="$(cat name_id.txt)"
	temp="$(cat temperature.txt)"
	pres="$(cat pressure.txt)"
	cd $SYSTEM
	cp $HOME/scripts/new_topol.py .
	conda activate
	python new_topol.py $HOME
	conda deactivate
	rm new_topol.py
	TOPOL=$SYSTEM/system.top
	INIT=$SYSTEM/0_packmol/system.gro
	cd $SYSTEM
	############################ ENERGY MINIMIZATION ############################
	rm -rf 1_min
	mkdir -p 1_min; cd 1_min
	cp $HOME/mdp/minimization.mdp min.mdp
	$GMX grompp -f min.mdp -c $INIT  -p $TOPOL -o min.tpr -maxwarn 10 >> grompp.log 2>&1
	$GMX mdrun -v -deffnm min >> mdrun.log 2>&1
	INIT=$SYSTEM/1_min/min.gro
	cd $SYSTEM
	############################ NPT EQUILIBRATION ###############################
	rm -rf 2_eqNPT
	mkdir -p 2_eqNPT; cd 2_eqNPT
	sed -s 's/TEMPERATURE/'$temp'/g' $HOME/mdp/equilibrationNPT.mdp > eq.mdp
	$GMX grompp -f eq.mdp -c $INIT -p $TOPOL -o eq.tpr -maxwarn 10 >> grompp.log 2>&1
	$GMX mdrun -v -deffnm eq >> mdrun.log 2>&1
	INIT=$SYSTEM/2_eqNPT/eq.gro
	cd $SYSTEM
	############################## NPT PRODUCTION ################################
	rm -rf 3_prNPT
	mkdir -p 3_prNPT; cd 3_prNPT
	sed -s 's/TEMPERATURE/'$temp'/g' $HOME/mdp/productionNPT.mdp > pr.mdp
	$GMX grompp -f pr.mdp -c $INIT -p $TOPOL -o pr.tpr -maxwarn 10 >> grompp.log 2>&1
	$GMX mdrun -v -deffnm pr >> mdrun.log 2>&1
	echo -e 'Pressure\nDensity\nT-System\nTotal-Energy' | $GMX energy -f pr.edr -s pr.tpr -b 1000 -o energy.xvg >> energy.log 2>&1
	cd $SYSTEM
	printf "\n\t...completed\n-----\n\n"
done
