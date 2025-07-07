reset
set encoding utf8

PARAM		= "TZVP"
T		= "303.15"
RATIO		= 0.8
LW		= 4
PT		= 5
PS		= 2

XLABEL		= "$\\sigma$ / e$\\cdot$\\AA$^{-2}$"
YLABEL		= "$p(\\sigma)$"
Y2LABEL		= "$\\mu_S(\\sigma)$"

CSMO		= "../../cosmo/sigma_profiles/"

array DES[3]	= ["c2mim_hdfs_pfpa", "tba_nfs_pfpa", "tbp_br_pfpa"]
array COLORS[3]	= ["#00798c", "#d1495b", "#44af69"]

set lmargin at screen 0.266
set bmargin at screen 0.258
set border lw 1.5

set size ratio RATIO
set xrange  [-.03:.03]
set yrange  [0:100]
set y2range [-2:1]
set xlabel  XLABEL  offset 0, -1
set ylabel  YLABEL  offset -2, 0 rotate by 90
set y2label Y2LABEL offset  0, 0 rotate by 90
set xtics  0.03 format "%.2f" scale 2 offset 0, -0.5
set ytics    25 format "%.0f" scale 2 offset 0,    0 nomirror
set y2tics    1 format "%.1f" scale 2 offset 0,    0
set mxtics 2
set mytics 2
set my2tics 2
unset k

array NDXCT[3]	= [2, 4, 6]
array NDXAN[3]	= [3, 5, 7]
do for [i=1:3] {
  set label 1 "FDES".i at graph 0.10, 0.85
  set term epslatex size 8cm,6cm fontscale 0.75
  set output "figures/sigma_profiles-".DES[i].".tex"
  p CSMO."sprof_fdes-".PARAM.".txt" skip 1 u 1:2*i   w lp lc rgb COLORS[1] pt -1 lw LW ,\
    CSMO."sprof_fdes-".PARAM.".txt" skip 1 u 1:2*i+1 w lp lc rgb COLORS[2] pt -1 lw LW ,\
    CSMO."sprof_fdes-".PARAM.".txt" skip 1 u 1:8     w lp lc rgb COLORS[3] pt -1 lw LW ,\
    0*x w lp lc -1 pt -1 lw LW dt 3 axes x1y2 ,\
    CSMO."spot_fdes-".PARAM.".txt"  skip 1 u 1:i+1 w lp lc -1 pt -1 lw LW axes x1y2
  unset term
  unset output
  replot
}
