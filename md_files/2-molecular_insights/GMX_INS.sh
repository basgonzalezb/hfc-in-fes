#!/bin/bash

module load gromacs
source ~/anaconda3/etc/profile.d/conda.sh

conda activate
python scripts/name.py 
conda deactivate
GMX=gmx_mpi
HOME=`pwd`
MDP=$HOME/mdp

for system in {3..27..3}; do
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
	############################ ENERGY MINIMIZATION ############################
	rm -rf 1_min
	mkdir -p 1_min; cd 1_min
	cp $HOME/mdp/minimization.mdp min.mdp
	$GMX grompp -f min.mdp -c $INIT  -p $TOPOL -o min.tpr -maxwarn 10 >> grompp.log 2>&1
	$GMX mdrun -v -deffnm min >> mdrun.log 2>&1
	INIT=$SYSTEM/1_min/min.gro
	cd $SYSTEM
	############################ NPT EQUILIBRATIONS ##############################
	rm -rf 2_eqNPT
	mkdir -p 2_eqNPT; cd 2_eqNPT
	# first equilibration using Berendsen barostat
	sed -s 's/PRESSURE/'$pres'/g' $HOME/mdp/equilibrationNPT1.mdp > eq1.mdp
	$GMX grompp -f eq1.mdp -c $INIT -p $TOPOL -o eq1.tpr -maxwarn 10 >> grompp.log 2>&1
	$GMX mdrun -v -deffnm eq1 >> mdrun1.log 2>&1
	INIT=$SYSTEM/2_eqNPT/eq1.gro
	# second equilibration using Parrinello-Rahman barostat
	sed -s 's/PRESSURE/'$pres'/g' $HOME/mdp/equilibrationNPT2.mdp > eq2.mdp
	$GMX grompp -f eq2.mdp -c eq1.gro -p $TOPOL -o eq2.tpr -maxwarn 10 >> grompp.log 2>&1
	$GMX mdrun -v -deffnm eq2 >> mdrun2.log 2>&1
	INIT=$SYSTEM/2_eqNPT/eq2.gro
	cd $SYSTEM
	############################## NPT PRODUCTION ################################
	rm -rf 3_prNPT
	mkdir -p 3_prNPT; cd 3_prNPT
	sed -s 's/PRESSURE/'$pres'/g' $HOME/mdp/productionNPT.mdp > pr.mdp
	$GMX grompp -f pr.mdp -c $INIT -p $TOPOL -o pr.tpr -maxwarn 10 >> grompp.log 2>&1
	$GMX mdrun -v -deffnm pr >> mdrun.log 2>&1
	echo 0 | $GMX trjconv -f pr.xtc -s pr.tpr -o trajectory.pdb -b 2000 >> trjconv.log 2>&1
	cd $SYSTEM
	################################## RESULTS ###################################
	mkdir -p 4_results; cd 4_results
	echo Total-Energy | $GMX energy -f ../3_prNPT/pr.edr -s ../3_prNPT/pr.tpr -b 2000 -o energy.xvg >> energy.log 2>&1
	echo Pressure | $GMX energy -f ../3_prNPT/pr.edr -s ../3_prNPT/pr.tpr -b 2000 -o pressure.xvg >> pressure.log 2>&1
	echo Volume | $GMX energy -f ../3_prNPT/pr.edr -s ../3_prNPT/pr.tpr -b 2000 -o volume.xvg >> volume.log 2>&1
	echo Density | $GMX energy -f ../3_prNPT/pr.edr -s ../3_prNPT/pr.tpr -b 2000 -o density.xvg >> density.log 2>&1
	mkdir -p rdf_mol; cd rdf_mol
	$GMX rdf -f ../../3_prNPT/pr.xtc -s ../../3_prNPT/pr.tpr -selrpos whole_mol_com -seltype whole_mol_com -o rdf_con.xvg -ref 2 -sel 2 3 4 5 -bin 0.02 -b 2000 >> rdfcon.log 2>&1
	$GMX rdf -f ../../3_prNPT/pr.xtc -s ../../3_prNPT/pr.tpr -selrpos whole_mol_com -seltype whole_mol_com -o rdf_aon.xvg -ref 3 -sel 2 3 4 5 -bin 0.02 -b 2000 >> rdfaon.log 2>&1
	$GMX rdf -f ../../3_prNPT/pr.xtc -s ../../3_prNPT/pr.tpr -selrpos whole_mol_com -seltype whole_mol_com -o rdf_hbd.xvg -ref 4 -sel 2 3 4 5 -bin 0.02 -b 2000 >> rdfhbd.log 2>&1
	$GMX rdf -f ../../3_prNPT/pr.xtc -s ../../3_prNPT/pr.tpr -selrpos whole_mol_com -seltype whole_mol_com -o rdf_hfc.xvg -ref 5 -sel 2 3 4 5 -bin 0.02 -b 2000 >> rdfhfc.log 2>&1
	cd $SYSTEM
	printf "\n\t...completed\n-----\n\n"
done

exit;
