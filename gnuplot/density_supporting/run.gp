reset
set encoding utf8
set pointintervalbox 0

RATIO		= 0.8
LW		= 4
PT		= 5
PS		= 2

XLABEL		= "$T$ / K"
YLABEL		= "$\\tilde{\\rho}$ / mol$\\cdot$L$^{-1}$"

MDYN		= "../../md_analysis/density/"
DATA		= "../../experimental/density/"

array DES[3]	= ["c2mim_hdfs_pfpa", "tba_nfs_pfpa", "tbp_br_pfpa"]
array RDES[3]	= ["[1_2]", "[1_1]", "[2_1]"]
array COLORS[3]	= ["#780116", "#B85B27", "#F7B538"]
array LABELS[2]	= ["a)", "b)"]

set lmargin at screen 0.266
set bmargin at screen 0.258
set border lw 1.5

set size ratio RATIO
set xrange [280:340]
set yrange [2.0:6.0]
set xlabel XLABEL offset 0, -1
set ylabel YLABEL offset -2, 0 rotate by 90
set xtics 20 format "%.0f" scale 2 offset 0, -0.5
set ytics  1 format "%.1f" scale 2 offset 0,    0
set mxtics 2
set mytics 2
unset k

do for [i=1:2] {
  set label 1 LABELS[i] at graph 0.10, 0.85
  set term epslatex size 8cm,6cm fontscale 0.75
  set output "figures/density_fdes".i."_molar.tex"
  p DATA.DES[i].RDES[1].".txt" skip 1 u 1:2 lc -1 ps 2.5 pt 7 lw LW ,\
    DATA.DES[i].RDES[2].".txt" skip 1 u 1:2 lc -1 ps 2.5 pt 7 lw LW ,\
    DATA.DES[i].RDES[3].".txt" skip 1 u 1:2 lc -1 ps 2.5 pt 7 lw LW ,\
    DATA.DES[i].RDES[1].".txt" skip 1 u 1:2 lc rgb COLORS[1] ps PS pt 7 lw LW ,\
    DATA.DES[i].RDES[2].".txt" skip 1 u 1:2 lc rgb COLORS[2] ps PS pt 7 lw LW ,\
    DATA.DES[i].RDES[3].".txt" skip 1 u 1:2 lc rgb COLORS[3] ps PS pt 7 lw LW ,\
    MDYN.DES[i].RDES[1].".txt" skip 1 u 1:2 lc -1 ps 2.5 pt PT lw LW ,\
    MDYN.DES[i].RDES[2].".txt" skip 1 u 1:2 lc -1 ps 2.5 pt PT lw LW ,\
    MDYN.DES[i].RDES[3].".txt" skip 1 u 1:2 lc -1 ps 2.5 pt PT lw LW ,\
    MDYN.DES[i].RDES[1].".txt" skip 1 u 1:2 lc rgb COLORS[1] ps PS pt PT lw LW ,\
    MDYN.DES[i].RDES[2].".txt" skip 1 u 1:2 lc rgb COLORS[2] ps PS pt PT lw LW ,\
    MDYN.DES[i].RDES[3].".txt" skip 1 u 1:2 lc rgb COLORS[3] ps PS pt PT lw LW
  unset term
  unset output
  replot
}
