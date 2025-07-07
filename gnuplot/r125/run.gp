reset
set encoding utf8
set pointintervalbox 0

RATIO		= 0.8
LW		= 4
PT		= 5
PS		= 2

set lmargin at screen 0.266
set bmargin at screen 0.258
set border lw 1.5
set size ratio RATIO
unset k
set mxtics 2
set mytics 2

MDYN		= "../../md_analysis/r125/md.out"
DATA		= "../../md_analysis/r125/nist.txt"
array LABELS[2]	= ["a)", "b)"]

# FIRST PLOT, VLE COEXISTENCE CURVE
XLABEL		= "$\\hat{\\rho}$ / g$\\cdot$cm$^{-3}$"
YLABEL		= "$T$ / K"
set xrange [0.0:1.6]
set yrange [200:360]
set xlabel XLABEL offset 0, -1
set ylabel YLABEL offset -2, 0 rotate by 90
set xtics .4 format "%.1f" scale 2 offset 0, -0.5
set ytics 40 format "%.0f" scale 2 offset 0,    0
set label 1 LABELS[1] at graph 0.10, 0.85
set term epslatex size 8cm,6cm fontscale 0.75
set output "figures/r125_rho_t.tex"
p DATA skip 1 u 3:1 w lp lc -1 pt -1 lw LW ,\
  DATA skip 1 u 4:1 w lp lc -1 pt -1 lw LW ,\
  MDYN skip 1 u 3:1      lc -1 ps 2.5 pt 4 lw LW ,\
  MDYN skip 1 u 4:1      lc -1 ps 2.5 pt 4 lw LW
unset term
unset output
replot

# SECOND PLOT, SURFACE TENSION
XLABEL		= "$T$ / K"
YLABEL		= "$\\gamma$ / mN$\\cdot$m$^{-1}$"
set xrange [200:350]
set yrange [0:20]
set xlabel XLABEL offset 0, -1
set ylabel YLABEL offset -2, 0 rotate by 90
set xtics 50 format "%.0f" scale 2 offset 0, -0.5
set ytics  5 format "%.0f" scale 2 offset 0,    0
set label 1 LABELS[2] at graph 0.10, 0.85
set term epslatex size 8cm,6cm fontscale 0.75
set output "figures/r125_t_ift.tex"
p DATA skip 1 u 1:5 w lp lc -1 pt -1 lw LW ,\
  MDYN skip 1 u 1:5      lc -1 ps 2.5 pt 4 lw LW
unset term
unset output
replot
