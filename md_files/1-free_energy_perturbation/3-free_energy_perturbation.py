import os
import sys
from alchemlyb.workflows import ABFE


os.system('mkdir -p results')
system = sys.argv[1]
out = 'results/'+system+'/'
dir = 'fep/'+system+'/'
os.system('mkdir -p results/{}'.format(system))
workflow = ABFE(software='GROMACS', dir=dir, prefix='fep_', suffix='xvg', T=303.15)
workflow.update_units('kJ/mol')
workflow.read(n_jobs=-1)                                        # read the data
workflow.preprocess(n_jobs=-1, skiptime=30000, uncorr='dhdl', threshold=50)    # decorrelate the data
workflow.estimate(estimators=("MBAR", "BAR", "TI"))             # run the estimator
summary = workflow.generate_result()                            # retrieve the result
workflow.plot_overlap_matrix(overlap=out+'overlap.pdf')         # plot the overlap matrix
workflow.plot_ti_dhdl(dhdl_TI=out+'dhdl_TI_.pdf')               # plot the dHdl for TI
workflow.plot_dF_state(dF_state=out+'dF_state_.pdf')            # plot the dF states
workflow.check_convergence(10, dF_t=out+'dF_t_.pdf')            # convergence analysis
summary.to_excel(out+'summary.xlsx')
