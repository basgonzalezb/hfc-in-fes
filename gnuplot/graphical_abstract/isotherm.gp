reset
set encoding utf8

T		= "303.15"
PARAM		= "TZVP"
RATIO		= 0.8
LW		= 4
PT		= 5
PS		= 2

XLABEL		= "HFC molar fraction"
YLABEL		= "Pressure"

MDYN		= "../../md_analysis/isotherms/px_"
CSMO		= "../../cosmo/isotherms/"
DATA		= "../../experimental/isotherms/"

array DES[3]	= ["c2mim_hdfs_pfpa", "tba_nfs_pfpa", "tbp_br_pfpa"]
RDES		= "[1_2]"
array COLORS[3]	= ["#005da4", "#29a4c3", "#57aa29"]
array HFC[3]	= ["R32", "R134a", "R125"]

set lmargin at screen 0.266
set bmargin at screen 0.258
set border lw 1.5

set size ratio RATIO
set xrange [0.0:0.6]
set yrange [0.0:2.0]
set xlabel XLABEL offset 0, -1
set ylabel YLABEL offset -2, 0 rotate by 90
unset xtics
unset ytics
unset k

set term epslatex size 8cm,6cm fontscale 0.75
set output "figures_ga/isotherm.tex"
plot \
  CSMO.HFC[1]."+".DES[1].RDES."-".PARAM.".txt" skip 1 u 1:3 w lp lc rgb COLORS[1] pt -1 lw LW ,\
  CSMO.HFC[1]."+".DES[3].RDES."-".PARAM.".txt" skip 1 u 1:3 w lp lc rgb COLORS[3] pt -1 lw LW ,\
  DATA.HFC[1]."+".DES[1].RDES.".txt" skip 2 u 1:2 lc -1 ps 1.5*PS pt 7 lw LW ,\
  DATA.HFC[1]."+".DES[1].RDES.".txt" skip 2 u 1:2 lc rgb COLORS[1] ps 1.0*PS pt 7 lw LW ,\
  MDYN.HFC[1]."_".DES[1].RDES.".out" skip 1 u 1:2 lc -1 ps 1.5*PS pt PT lw LW ,\
  MDYN.HFC[1]."_".DES[3].RDES.".out" skip 1 u 1:2 lc -1 ps 1.5*PS pt PT lw LW ,\
  MDYN.HFC[1]."_".DES[1].RDES.".out" skip 1 u 1:2:3 w errorbars lc rgb COLORS[1] ps 1.0*PS pt PT lw LW ,\
  MDYN.HFC[1]."_".DES[3].RDES.".out" skip 1 u 1:2:3 w errorbars lc rgb COLORS[3] ps 1.0*PS pt PT lw LW
unset term
unset output
replot
