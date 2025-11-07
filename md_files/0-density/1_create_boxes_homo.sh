#!/bin/bash

module load gromacs
source ~/anaconda3/etc/profile.d/conda.sh

HOME=`pwd`
GMX=gmx_mpi

conda activate
python scripts/name.py 
conda deactivate

mkdir -p $HOME/MD
for system in {1..18}
	do
	rm -r -f $HOME/MD/${system}
	mkdir -p $HOME/MD/${system}
	cd $HOME/MD/${system}
	SYSTEM=`pwd`
	printf "_____________________________________________\n     SYSTEM: ${system}   \n_____________________________________________\n"

	########################## PACKMOL ##########################
	mkdir 0_packmol
	cd 0_packmol

	cp $HOME/scripts/initial_conf_homo.py .
	cp $HOME/scripts/packmol . 
	chmod 777 packmol

	conda activate
	python initial_conf_homo.py ${system} $HOME
	conda deactivate

	system_name="$(cat name.txt)"
	system_tag="$(cat name_id.txt)"
	temp="$(cat temperature.txt)"
	pres="$(cat pressure.txt)"

	printf "Inserting molecules in phase the system using PACKMOL\n"
	chmod 777 packmol
	./packmol < system.inp >> packmol.log 2>&1
	printf "  \n"

	$GMX editconf -f system.pdb -o system.gro  >> editconf.log 2>&1

	sed -i '$ d' system.gro
	cat dimension-system.gro >> system.gro

	rm *.inp *.pdb packmol *.py dimension-system.gro

	mkdir log
	mv editconf.log packmol.log log
	mv system_original.top ../system_original.top

done