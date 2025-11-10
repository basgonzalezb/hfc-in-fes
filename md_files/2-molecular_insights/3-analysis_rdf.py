import os
import numpy as np
import matplotlib.pyplot as plt

rdf_ndx = ['rdf_con', 'rdf_aon', 'rdf_hbd', 'rdf_hfc']
x1_ndx = ['x1=0.45']
sim_ndx = [4, 8, 12, 16, 20, 24, 28, 32, 36]
hfc_ndx = ['r32', 'r134a', 'r125', 'r32', 'r134a', 'r125', 'r32', 'r134a', 'r125']
des_ndx = ['fdes1', 'fdes1', 'fdes1', 'fdes2', 'fdes2', 'fdes2', 'fdes3', 'fdes3', 'fdes3']
des_ndx = ['c2mim_hdfs_pfpa', 'c2mim_hdfs_pfpa', 'c2mim_hdfs_pfpa',
           'tba_nfs_pfpa', 'tba_nfs_pfpa', 'tba_nfs_pfpa',
           'tbp_br_pfpa', 'tbp_br_pfpa', 'tbp_br_pfpa']

x1 = x1_ndx[0]
os.system('mkdir -p results')
os.system('mkdir -p results/'+x1)
out = 'figures/'+x1+'/rdf_'
for i in sim_ndx:
    r, g_con_con, g_con_aon, g_con_hbd, g_con_hfc = np.loadtxt('MD/{}/4_results/rdf_mol/{}.xvg'.format(i, rdf_ndx[0]), unpack=True, comments=['#', '@'])
    r, g_aon_con, g_aon_aon, g_aon_hbd, g_aon_hfc = np.loadtxt('MD/{}/4_results/rdf_mol/{}.xvg'.format(i, rdf_ndx[1]), unpack=True, comments=['#', '@'])
    r, g_hbd_con, g_hbd_aon, g_hbd_hbd, g_hbd_hfc = np.loadtxt('MD/{}/4_results/rdf_mol/{}.xvg'.format(i, rdf_ndx[2]), unpack=True, comments=['#', '@'])
    r, g_hfc_con, g_hfc_aon, g_hfc_hbd, g_hfc_hfc = np.loadtxt('MD/{}/4_results/rdf_mol/{}.xvg'.format(i, rdf_ndx[3]), unpack=True, comments=['#', '@'])

    np.savetxt('results/'+x1+'/rdf_mol-'+hfc_ndx[sim_ndx.index(i)]+'_'+des_ndx[sim_ndx.index(i)]+'.out',
                np.array([r, g_hfc_con, g_hfc_aon, g_hfc_hbd, g_hfc_hfc]).T,
                header='     r/nm   g_cation    g_anion      g_hbd      g_hfc', fmt='%10.5f', comments='#')
