reset
set encoding utf8
set pointintervalbox 0

T		= "303.15"
RATIO		= 0.8
LW		= 4
PT		= 5
PS		= 2

XLABEL		= "Molar Ratio (HBA:HBD)"
YLABEL		= "$\\tilde{\\rho}$ / mol$\\cdot$L$^{-1}$"

MDYN		= "../../md_analysis/density/"
DATA		= "../../experimental/density/"

array DES[3]	= ["c2mim_hdfs_pfpa", "tba_nfs_pfpa", "tbp_br_pfpa"]
array RDES[3]	= ["[1_2]", "[1_1]", "[2_1]"]
array COLORS[3]	= ["#005da4", "#29a4c3", "#57aa29"]

set lmargin at screen 0.266
set bmargin at screen 0.258
set border lw 1.5

set size ratio RATIO
set xrange [0:2.2]
set yrange [2:5]
set xlabel XLABEL offset 0, -1
set ylabel YLABEL offset -2, 0 rotate by 90
set xtics ("\\strut{}1:2" 0.30, "\\strut{}1:1" 1.10, "\\strut{}2:1" 1.90) offset 0, -0.5 nomirror
set ytics  1 format "%.1f" scale 2 offset 0,    0
set mytics 2
unset k
set boxwidth 0.2
set style fill solid border -1

set term epslatex size 8cm,6cm fontscale 0.75
set output "figures/density_bars.tex"
p DATA.DES[1].RDES[1].".txt" skip 1 u (0.20):2   every 1::1::1 w boxes     lc rgb COLORS[1] lw LW ,\
  MDYN.DES[1].RDES[1].".txt" skip 1 u (0.20):2:3 every 1::1::1 w errorbars lc -1 lw LW pt PT ps 2.5 ,\
  MDYN.DES[1].RDES[1].".txt" skip 1 u (0.20):2:3 every 1::1::1 w errorbars lc rgb COLORS[1] lw LW pt PT ps PS ,\
  DATA.DES[2].RDES[1].".txt" skip 1 u (0.40):2   every 1::1::1 w boxes     lc rgb COLORS[2] lw LW ,\
  MDYN.DES[2].RDES[1].".txt" skip 1 u (0.40):2:3 every 1::1::1 w errorbars lc -1 lw LW pt PT ps 2.5 ,\
  MDYN.DES[2].RDES[1].".txt" skip 1 u (0.40):2:3 every 1::1::1 w errorbars lc rgb COLORS[2] lw LW pt PT ps PS ,\
  DATA.DES[1].RDES[2].".txt" skip 1 u (1.00):2   every 1::1::1 w boxes     lc rgb COLORS[1] lw LW ,\
  MDYN.DES[1].RDES[2].".txt" skip 1 u (1.00):2:3 every 1::1::1 w errorbars lc -1 lw LW pt PT ps 2.5 ,\
  MDYN.DES[1].RDES[2].".txt" skip 1 u (1.00):2:3 every 1::1::1 w errorbars lc rgb COLORS[1] lw LW pt PT ps PS ,\
  DATA.DES[2].RDES[2].".txt" skip 1 u (1.20):2   every 1::1::1 w boxes     lc rgb COLORS[2] lw LW ,\
  MDYN.DES[2].RDES[2].".txt" skip 1 u (1.20):2:3 every 1::1::1 w errorbars lc -1 lw LW pt PT ps 2.5 ,\
  MDYN.DES[2].RDES[2].".txt" skip 1 u (1.20):2:3 every 1::1::1 w errorbars lc rgb COLORS[2] lw LW pt PT ps PS ,\
  DATA.DES[1].RDES[3].".txt" skip 1 u (1.80):2   every 1::1::1 w boxes     lc rgb COLORS[1] lw LW ,\
  MDYN.DES[1].RDES[3].".txt" skip 1 u (1.80):2:3 every 1::1::1 w errorbars lc -1 lw LW pt PT ps 2.5 ,\
  MDYN.DES[1].RDES[3].".txt" skip 1 u (1.80):2:3 every 1::1::1 w errorbars lc rgb COLORS[1] lw LW pt PT ps PS ,\
  DATA.DES[2].RDES[3].".txt" skip 1 u (2.00):2   every 1::1::1 w boxes     lc rgb COLORS[2] lw LW ,\
  MDYN.DES[2].RDES[3].".txt" skip 1 u (2.00):2:3 every 1::1::1 w errorbars lc -1 lw LW pt PT ps 2.5 ,\
  MDYN.DES[2].RDES[3].".txt" skip 1 u (2.00):2:3 every 1::1::1 w errorbars lc rgb COLORS[2] lw LW pt PT ps PS ,\

unset term
unset output
replot
