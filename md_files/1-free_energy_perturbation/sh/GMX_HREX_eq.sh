#!/bin/bash
## SLURM options ##
#SBATCH --job-name=gmxHREXeq
#SBATCH --exclusive
#SBATCH -N 2
#SBATCH -o hrex_eq.log
#SBATCH -p MD
#SBATCH --ntasks-per-node=48
#SBATCH --cpus-per-task=1
#SBATCH --time=01-00:00:00

NODELIST=$(pwd)/nodelist.${SLURM_JOBID}
for host in $(scontrol show hostnames); do
  echo "host ${host} ++cpus ${SLURM_CPUS_ON_NODE}" >> ${NODELIST}
done

# calculate total processes (P) and procs per node (PPN)
PPN=`expr $SLURM_NTASKS_PER_NODE - 1`
P="$(($PPN * $SLURM_NNODES))"

GMX="mpiexec.hydra -bootstrap slurm -genv I_MPI_FABRICS=shm:ofi -genv I_MPI_PIN_DOMAIN=auto -genv I_MPI_PIN_ORDER=bunch -genv OMP_PLACES=threads -genv OMP_PROC_BIND=SPREAD -genv OMP_NUM_THREADS=1 /opt/ohpc/pub/gromacs/2022.1/gromacs.AVX512.static/bin/gmx_mpi"

module load gromacs/2022.1
module load python/intelpython3/2021.4.0

dc_array=()
for i in {1..16}; do
	dc_array+=("PFPA1")
done
for i in 1 2 3; do
	dc_array=("${dc_array[@]}" "DM2" "DM2" "DM2" "DE4" "DE4" "DE4" "DE5" "DE5" "DE5")
done

cd ../
HOME=`pwd`
# run as sbatch GMX_HREX_eq.sh <system>
system=$1
dc=${dc_array[$system]}
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
python new_topol.py $HOME
rm new_topol.py
TOPOL=$SYSTEM/system.top
INIT=$SYSTEM/0_packmol/system.gro
############################ ENERGY MINIMIZATION ############################
rm -rf 1_min
mkdir -p 1_min; cd 1_min
sed -s 's/DECOUPLE/'$dc'/g' $HOME/mdp/minimization.mdp > min.mdp
gmx_mpi grompp -f min.mdp -c $INIT  -p $TOPOL -o min.tpr -maxwarn 10 >> grompp.log 2>&1
gmx_mpi mdrun -v -deffnm min >> mdrun.log 2>&1
INIT=$SYSTEM/1_min/min.gro
cd $SYSTEM
############################ NPT EQUILIBRATIONS ##############################
rm -rf 2_eqNPT
mkdir -p 2_eqNPT; cd 2_eqNPT
# first equilibration using Berendsen barostat
sed -s 's/DECOUPLE/'$dc'/g' $HOME/mdp/equilibrationNPT1.mdp > eq1.mdp
gmx_mpi grompp -f eq1.mdp -c $INIT -p $TOPOL -o eq1.tpr -maxwarn 10 >> grompp1.log 2>&1
$GMX mdrun -v -deffnm eq1 >> mdrun1.log 2>&1
# second equilibration using Parrinello-Rahman barostat
sed -s 's/DECOUPLE/'$dc'/g' $HOME/mdp/equilibrationNPT2.mdp > eq2.mdp
gmx_mpi grompp -f eq2.mdp -c $INIT -p $TOPOL -o eq2.tpr -maxwarn 10 >> grompp2.log 2>&1
$GMX mdrun -v -deffnm eq2 >> mdrun2.log 2>&1
mkdir -p $HOME/fep
mkdir -p $HOME/fep/${system}
echo Total-Energy | gmx_mpi energy -f eq2.edr -s eq2.tpr -b 2000 -o $HOME/fep/${system}/energy.xvg >> energy.log 2>&1
echo Pressure | gmx_mpi energy -f eq2.edr -s eq2.tpr -b 2000 -o $HOME/fep/${system}/pressure.xvg >> pressure.log 2>&1
echo Volume | gmx_mpi energy -f eq2.edr -s eq2.tpr -b 2000 -o $HOME/fep/${system}/volume.xvg >> volume.log 2>&1
echo Density | gmx_mpi energy -f eq2.edr -s eq2.tpr -b 2000 -o $HOME/fep/${system}/density.xvg >> density.log 2>&1
cd $SYSTEM
########################## FREE ENERGY PERTURBATION ##########################
mkdir -p fep; cd fep
for ((i=0;i<24;i++)); do
	mkdir $i; cd $i
	# generate different initial configurations for each lambda
	echo 0 | gmx_mpi trjconv -s $SYSTEM/2_eqNPT/eq2.tpr -f $SYSTEM/2_eqNPT/eq2.xtc --dump $((10000-$i*100)) -o init.gro >> trjconv.log 2>&1
	# energy minimization
	cp $HOME/mdp/minimization.mdp min.mdp
	gmx_mpi grompp -f min.mdp -c init.gro -p $TOPOL -o min.tpr -maxwarn 10 >> min_grompp.log 2>&1
	gmx_mpi mdrun -v -deffnm min >> min_mdrun.log 2>&1
	# define NPT production run
	sed 's/LAMBDA/'$i'/g' $HOME/mdp/fep.mdp > fep.mdp
	sed -i 's/DECOUPLE/'$dc'/g' fep.mdp
	gmx_mpi grompp -f fep.mdp -c min.gro -p $TOPOL -o pr.tpr -maxwarn 10 >> fep_grompp.log 2>&1
	cd ../
done
cd $SYSTEM
printf "\n\t...completed\n-----\n\n"

exit;
