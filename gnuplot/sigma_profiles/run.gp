reset
set encoding utf8

PARAM		= "TZVP"
T		= "303.15"
RATIO		= 0.8
LW		= 4
PT		= 5
PS		= 2

XLABEL		= "$\\sigma$ / e$\\cdot$nm$^{-2}$"

CSMO		= "../../cosmo/sigma_profiles/"

array DES[3]	= ["c2mim_hdfs_pfpa", "tba_nfs_pfpa", "tbp_br_pfpa"]
array COLORS[3]	= ["#005da4", "#29a4c3", "#57aa29"]
GRAY	  	= "#adadad"

set lmargin at screen 0.266
set bmargin at screen 0.258
set border lw 1.5

set size ratio RATIO
set xrange  [-3:3]
set xlabel  XLABEL  offset 0, -1
set xtics 1.5 format "%.1f" scale 2 offset 0, -0.5
set mxtics 2
set mytics 2
unset k

YLABEL		= "$p(\\sigma)$"
set yrange [0:80]
set ylabel  YLABEL  offset -2, 0 rotate by 90
set ytics 20 format "%.0f" scale 2 offset 0, 0
set label 1 "a)" at graph 0.10, 0.85
set term epslatex size 8cm,6cm fontscale 0.75
set output "figures/sigma_profiles-fdes.tex"
plot \
  for [i=1:3] CSMO."sprof_fes-".PARAM.".out" skip 1 u ($1*100):2*i   w lp lc rgb COLORS[i] pt -1 lw LW dt 1 ,\
  for [i=1:3] CSMO."sprof_fes-".PARAM.".out" skip 1 u ($1*100):2*i+1 w lp lc rgb COLORS[i] pt -1 lw LW dt 3 ,\
  CSMO."sprof_fes-".PARAM.".out" skip 1 u ($1*100):8     w lp lc -1 pt -1 lw LW
unset term
unset output
replot

YLABEL		= "$p(\\sigma)$"
set yrange [0:0.06]
set yrange [0:40]
set ylabel  YLABEL  offset -2, 0 rotate by 90
set ytics 0.02 format "%.2f" scale 2 offset 0, 0
set ytics 10 format "%.0f" scale 2 offset 0, 0
set label 1 "a)" at graph 0.10, 0.85
set term epslatex size 8cm,6cm fontscale 0.75
set output "figures/sigma_profiles-fdes.tex"
plot \
  for [i=1:3] CSMO."sprof_fes-".PARAM.".out" skip 1 u ($1*100):8+i w lp lc rgb COLORS[i] pt -1 lw LW
unset term
unset output
replot

YLABEL		= "$\\mu_S(\\sigma)$"
set yrange [-1.2:0.4]
set ylabel  YLABEL  offset -2, 0 rotate by 90
set ytics 0.4 format "%.1f" scale 2 offset 0, 0
set label 1 "b)" at graph 0.10, 0.85
set term epslatex size 8cm,6cm fontscale 0.75
set output "figures/sigma_potentials-fdes.tex"
plot \
  0*x w lp pt -1 lw LW dt 1 lc rgb GRAY ,\
  for [i=1:3] CSMO."spot_fes-".PARAM.".out"  skip 1 u ($1*100):i+1 w lp lc rgb COLORS[i] pt -1 lw LW
unset term
unset output
replot
