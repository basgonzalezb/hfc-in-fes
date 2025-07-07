reset
set encoding utf8

T		= "303.15"
RATIO		= 0.8
LW		= 4
PT		= 5
PS		= 2

XLABEL		= "HFC"
YLABEL		= "$E$ / kJ$\\cdot$mol$^{-1}$"

MDYN		= "../../md_analysis/interaction_energy/x1=0.45/intener-"

array DES[3]	= ["c2m_hdfs_pfpa[1_2]", "tba_nfs_pfpa[1_2]", "tbp_br_pfpa[1_2]"]
array COLORS[3]	= ["#005da4", "#29a4c3", "#57aa29"]
GRAY	  	= "#adadad"
array HFC[3]	= ["RM2", "RE4a", "RE5"]

set lmargin at screen 0.266
set bmargin at screen 0.258
set border lw 1.5

set size ratio RATIO
set xrange [0.0:2.8]
set yrange [-20:0]
set xlabel XLABEL offset 0, -1
set ylabel YLABEL offset -2, 0 rotate by 90
set xtics ("R32" 0.40, "R134a" 1.40, "R125" 2.40) scale 2 offset 0, -0.5 rotate by 0
set ytics 5 format "%.0f" scale 2 offset 0,    0
unset k
set boxwidth 0.20
set style fill solid border -1
set pointintervalbox 0

set label 1 "a)" at graph 0.10, 0.15
set term epslatex size 8cm,6cm fontscale 0.75
set output "figures/intener_coul.tex"
plot \
  for [i=1:3] for [j=1:3] MDYN.HFC[i]."_".DES[j].".out" skip 1 u (0.20*j+i-1):2 w boxes lw LW lc rgb COLORS[j]
unset term
unset output
replot

set label 1 "b)" at graph 0.10, 0.15
set term epslatex size 8cm,6cm fontscale 0.75
set output "figures/intener_lj.tex"
plot \
  for [i=1:3] for [j=1:3] MDYN.HFC[i]."_".DES[j].".out" skip 1 u (0.20*j+i-1):3 w boxes lw LW lc rgb COLORS[j]
unset term
unset output
replot
