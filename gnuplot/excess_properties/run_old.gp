reset
set encoding utf8

T		= "303.15"
RATIO		= 0.8
LW		= 4
PT		= 5
PS		= 2

set lmargin at screen 0.266
set bmargin at screen 0.258
set border lw 1.5

XLABEL		= "HFC"
YLABEL		= "$\\tilde{E}$ / kJ$\\cdot$mol$^{-1}$"

PARAM		= "TZVP"
array HFC[3]	= ["R32", "R134a", "R125"]
array DES[3]	= ["c2mim_hdfs_pfpa[1_2]", "tba_nfs_pfpa[1_2]", "tbp_br_pfpa[1_2]"]
array COLORS[3]	= ["#005da4", "#29a4c3", "#57aa29"]

CSMO		      = "../../cosmo/excess_properties/"

set size ratio RATIO
set xrange [0:2.8]
set yrange [-3:1]
set xlabel XLABEL offset 0, -1
set ylabel YLABEL offset -2, 0 rotate by 90
set xtics ("R32" 0.40, "R134a" 1.40, "R125" 2.40) scale 2 offset 0, -0.5 rotate by 0
set ytics 1 format "%.1f" scale 2 offset 0,    0
set mytics 2
unset k
set boxwidth 0.20
set style fill solid border -1
set pointintervalbox 0

set term epslatex size 8cm,6cm fontscale 0.75
set output "figures/excess_properties.tex"
plot \
  for [i=1:3] for [j=1:3] CSMO.DES[i]."-".PARAM.".out" skip 1 u (0.2*i+j-1):2 every 1::j-1::j-1 w boxes lw LW lc rgb COLORS[i] ,\
  for [i=1:3] for [j=1:3] CSMO.DES[i]."-".PARAM.".out" skip 1 u (0.2*i+j-1):3 every 1::j-1::j-1 pt 13 ps 2.5 lc -1 ,\
  for [i=1:3] for [j=1:3] CSMO.DES[i]."-".PARAM.".out" skip 1 u (0.2*i+j-1):3 every 1::j-1::j-1 pt 13 ps  PS lc rgb COLORS[i]
replot
unset term
unset output
replot
