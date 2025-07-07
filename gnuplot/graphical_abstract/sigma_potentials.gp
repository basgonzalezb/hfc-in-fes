reset
set encoding utf8

PARAM		= "TZVP"
T		= "303.15"
RATIO		= 0.8
LW		= 4
PT		= 5
PS		= 2

XLABEL		= "$\\sigma$"
YLABEL		= "$\\mu_S(\\sigma)$"

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
unset xtics
unset ytics
unset k

set yrange [-1.2:0.4]
set ylabel  YLABEL  offset -2, 0 rotate by 90
set term epslatex size 8cm,6cm fontscale 0.75
set output "figures_ga/sigma_potentials-fdes.tex"
plot \
  0*x w lp pt -1 lw LW dt 2 lc -1 ,\
  CSMO."spot_fdes-".PARAM.".txt"  skip 1 u ($1*100):2 w lp lc rgb COLORS[1] pt -1 lw LW ,\
  CSMO."spot_fdes-".PARAM.".txt"  skip 1 u ($1*100):4 w lp lc rgb COLORS[3] pt -1 lw LW
unset term
unset output
replot
