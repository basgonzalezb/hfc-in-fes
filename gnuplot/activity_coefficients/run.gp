reset
set encoding utf8
set pointintervalbox 0

T		= "303.15"
RATIO		= 0.8
LW		= 4
PT		= 5
PS		= 2

XLABEL		= "$x_{HBA}$ / mol$\\cdot$mol$^{-1}$"
YLABEL		= "$\\gamma_{HBD}$"

MDYN		= "../../md_analysis/activity_coefficients/"
CSMO		= "../../cosmo/activity_coefficients/"

array DES[3]	= ["c2mim_hdfs_pfpa", "tba_nfs_pfpa", "tbp_br_pfpa"]
array COLORS[3]	= ["#00798c", "#d1495b", "#edae49"]
array COLORS[3]	= ["#005da4", "#29a4c3", "#57aa29"]

set lmargin at screen 0.266
set bmargin at screen 0.258
set border lw 1.5
set size ratio RATIO

set xrange [0.0:0.4]
set yrange [0.0:2.0]
set xlabel XLABEL offset 0, -1
set ylabel YLABEL offset -2, 0 rotate by 90
set xtics 0.1 format "%.1f" scale 2 offset 0, -0.5
set ytics 0.5 format "%.1f" scale 2 offset 0,    0
set mxtics 2
set mytics 2
unset k

set label 1 "b)" at graph 0.10, 0.85
set term epslatex size 8cm,6cm fontscale 0.75
set output "figures/activity_coef-pfpa.tex"
p CSMO.DES[1].".out" skip 1 w lp lc rgb COLORS[1] pt -1 lw LW dt 1 ,\
  CSMO.DES[2].".out" skip 1 w lp lc rgb COLORS[2] pt -1 lw LW dt 1 ,\
  CSMO.DES[3].".out" skip 1 w lp lc rgb COLORS[3] pt -1 lw LW dt 1 ,\
  MDYN.DES[1].".out" skip 1 u 1:2 lc -1 ps 2.5 pt PT lw LW ,\
  MDYN.DES[2].".out" skip 1 u 1:2 lc -1 ps 2.5 pt PT lw LW ,\
  MDYN.DES[3].".out" skip 1 u 1:2 lc -1 ps 2.5 pt PT lw LW ,\
  MDYN.DES[1].".out" skip 1 u 1:2:3 w errorbars lc rgb COLORS[1] ps PS pt PT lw LW ,\
  MDYN.DES[2].".out" skip 1 u 1:2:3 w errorbars lc rgb COLORS[2] ps PS pt PT lw LW ,\
  MDYN.DES[3].".out" skip 1 u 1:2:3 w errorbars lc rgb COLORS[3] ps PS pt PT lw LW
unset term
unset output
replot

