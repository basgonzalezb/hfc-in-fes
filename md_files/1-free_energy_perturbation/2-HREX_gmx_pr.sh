#!/bin/bash
## SLURM options ##
#SBATCH --job-name=gmxHREXpr
#SBATCH --exclusive
#SBATCH -N 2
#SBATCH -o hrex_pr.log
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

cd ../
HOME=`pwd`

# run as sbatch GMX_HREX_pr.sh <system>
system=$1
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
TOPOL=$SYSTEM/system.top
########################## FREE ENERGY PERTURBATION ##########################
cd fep
$GMX mdrun -v -deffnm pr -multidir 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 -nex 10000 -replex 2000 >> fep_mdrun.log 2>&1
for ((i=0;i<24;i++)); do
	cd $i
	cp pr.xvg $HOME/fep/${system}/fep_$i.xvg
	cd ../
done
cd $SYSTEM
printf "\n\t...completed\n-----\n\n"
cd $HOME/fep/${system}
gmx_mpi bar -f fep_*.xvg --o -oi -oh -temp 303.15 >> bar.log 2>&1
cd $HOME

exit;
