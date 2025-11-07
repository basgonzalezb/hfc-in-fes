reset
set encoding utf8
set pointintervalbox 0

RATIO		= 0.8
LW		= 4
PT		= 5
PS		= 2

XLABEL		= "$T$ / K"
YLABEL		= "$\\hat{\\rho}^L$ / g$\\cdot$cm$^{-3}$"

MDYN1		= "../../md_analysis/density/pfpa_unscaled.out"
MDYN2		= "../../md_analysis/density/pfpa_scaled.out"
DATA		= "../../experimental/density/pfpa.txt"

array COLORS[3]	= ["#780116", "#B85B27", "#F7B538"]

set lmargin at screen 0.266
set bmargin at screen 0.258
set border lw 1.5

set size ratio RATIO
set xrange [280:400]
set yrange [1.4:2.0]
set xlabel XLABEL offset 0, -1
set ylabel YLABEL offset -2, 0 rotate by 90
set xtics 280, 30, 400 format "%.0f" scale 2 offset 0, -0.5
set ytics .2 format "%.1f" scale 2 offset 0,    0
set mxtics 2
set mytics 2
unset k

set term epslatex size 8cm,6cm fontscale 0.75
set output "figures/density_pfpa.tex"
p DATA  skip 1 u 1:2 lc -1 ps PS pt 6 lw LW ,\
  MDYN1 skip 1 u 1:2 lc rgb "#d1495b" ps PS pt 4 lw LW ,\
  MDYN2 skip 1 u 1:2 lc -1 ps PS pt 4 lw LW
unset term
unset output
replot
