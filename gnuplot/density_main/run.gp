reset
set encoding utf8
set pointintervalbox 0

T		= "303.15"
RATIO		= 0.8
LW		= 4
PT		= 5
PS		= 2

XLABEL		= "$x_{HBA}$ / mol$\\cdot$mol$^{-1}$"
YLABEL		= "$\\hat{\\rho}$ / g$\\cdot$cm$^{-3}$"

MDYN		= "../../md_analysis/density/"
DATA		= "../../experimental/density/"

array DES[3]	= ["c2mim_hdfs_pfpa", "tba_nfs_pfpa", "tbp_br_pfpa"]
array RDES[3]	= ["[1_2]", "[1_1]", "[2_1]"]
array COLORS[3]	= ["#005da4", "#29a4c3", "#57aa29"]

array XHBA[3]	= [0.333, 0.500, 0.667]
array MW1[3]	= [379.35, 437.17, 494.99]
array MW2[3]    = [356.46, 402.80, 449.14]

set lmargin at screen 0.266
set bmargin at screen 0.258
set border lw 1.5

set size ratio RATIO
set xrange [0.3:0.7]
set yrange [1.2:1.8]
set xlabel XLABEL offset 0, -1
set ylabel YLABEL offset -2, 0 rotate by 90
set xtics 0.1 format "%.1f" scale 2 offset 0, -0.5
set ytics 0.2 format "%.1f" scale 2 offset 0,    0
set mxtics 2
set mytics 2
unset k

set label 1 "a)" at graph 0.10, 0.15
set term epslatex size 8cm,6cm fontscale 0.75
set output "figures/density_main.tex"
p DATA.DES[1].RDES[1].".txt" skip 1 u (XHBA[1]):($2*MW1[1]/1000)   every 1::1::1 pt 7 ps 2.5 lw LW lc -1 ,\
  DATA.DES[1].RDES[1].".txt" skip 1 u (XHBA[1]):($2*MW1[1]/1000)   every 1::1::1 pt 7 ps PS  lw LW lc rgb COLORS[1] ,\
  MDYN.DES[1].RDES[1].".out" skip 1 u (XHBA[1]):($2*MW1[1]/1000):($3*MW1[1]/1000) every 1::1::1 w errorbars pt PT ps 2.5 lw LW lc -1 ,\
  MDYN.DES[1].RDES[1].".out" skip 1 u (XHBA[1]):($2*MW1[1]/1000):($3*MW1[1]/1000) every 1::1::1 w errorbars pt PT ps PS  lw LW lc rgb COLORS[1] ,\
  DATA.DES[2].RDES[1].".txt" skip 1 u (XHBA[1]):($2*MW2[1]/1000)   every 1::1::1 pt 7 ps 2.5 lw LW lc -1 ,\
  DATA.DES[2].RDES[1].".txt" skip 1 u (XHBA[1]):($2*MW2[1]/1000)   every 1::1::1 pt 7 ps PS  lw LW lc rgb COLORS[2] ,\
  MDYN.DES[2].RDES[1].".out" skip 1 u (XHBA[1]):($2*MW2[1]/1000):($3*MW2[1]/1000) every 1::1::1 w errorbars pt PT ps 2.5 lw LW lc -1 ,\
  MDYN.DES[2].RDES[1].".out" skip 1 u (XHBA[1]):($2*MW2[1]/1000):($3*MW2[1]/1000) every 1::1::1 w errorbars pt PT ps PS  lw LW lc rgb COLORS[2] ,\
  DATA.DES[1].RDES[2].".txt" skip 1 u (XHBA[2]):($2*MW1[2]/1000)   every 1::1::1 pt 7 ps 2.5 lw LW lc -1 ,\
  DATA.DES[1].RDES[2].".txt" skip 1 u (XHBA[2]):($2*MW1[2]/1000)   every 1::1::1 pt 7 ps PS  lw LW lc rgb COLORS[1] ,\
  MDYN.DES[1].RDES[2].".out" skip 1 u (XHBA[2]):($2*MW1[2]/1000):($3*MW1[2]/1000) every 1::1::1 w errorbars pt PT ps 2.5 lw LW lc -1 ,\
  MDYN.DES[1].RDES[2].".out" skip 1 u (XHBA[2]):($2*MW1[2]/1000):($3*MW1[2]/1000) every 1::1::1 w errorbars pt PT ps PS  lw LW lc rgb COLORS[1] ,\
  DATA.DES[2].RDES[2].".txt" skip 1 u (XHBA[2]):($2*MW2[2]/1000)   every 1::1::1 pt 7 ps 2.5 lw LW lc -1 ,\
  DATA.DES[2].RDES[2].".txt" skip 1 u (XHBA[2]):($2*MW2[2]/1000)   every 1::1::1 pt 7 ps PS  lw LW lc rgb COLORS[2] ,\
  MDYN.DES[2].RDES[2].".out" skip 1 u (XHBA[2]):($2*MW2[2]/1000):($3*MW2[2]/1000) every 1::1::1 w errorbars pt PT ps 2.5 lw LW lc -1 ,\
  MDYN.DES[2].RDES[2].".out" skip 1 u (XHBA[2]):($2*MW2[2]/1000):($3*MW2[2]/1000) every 1::1::1 w errorbars pt PT ps PS  lw LW lc rgb COLORS[2] ,\
  DATA.DES[1].RDES[3].".txt" skip 1 u (XHBA[3]):($2*MW1[3]/1000)   every 1::1::1 pt 7 ps 2.5 lw LW lc -1 ,\
  DATA.DES[1].RDES[3].".txt" skip 1 u (XHBA[3]):($2*MW1[3]/1000)   every 1::1::1 pt 7 ps PS  lw LW lc rgb COLORS[1] ,\
  MDYN.DES[1].RDES[3].".out" skip 1 u (XHBA[3]):($2*MW1[3]/1000):($3*MW1[3]/1000) every 1::1::1 w errorbars pt PT ps 2.5 lw LW lc -1 ,\
  MDYN.DES[1].RDES[3].".out" skip 1 u (XHBA[3]):($2*MW1[3]/1000):($3*MW1[3]/1000) every 1::1::1 w errorbars pt PT ps PS  lw LW lc rgb COLORS[1] ,\
  DATA.DES[2].RDES[3].".txt" skip 1 u (XHBA[3]):($2*MW2[3]/1000)   every 1::1::1 pt 7 ps 2.5 lw LW lc -1 ,\
  DATA.DES[2].RDES[3].".txt" skip 1 u (XHBA[3]):($2*MW2[3]/1000)   every 1::1::1 pt 7 ps PS  lw LW lc rgb COLORS[2] ,\
  MDYN.DES[2].RDES[3].".out" skip 1 u (XHBA[3]):($2*MW2[3]/1000):($3*MW2[3]/1000) every 1::1::1 w errorbars pt PT ps 2.5 lw LW lc -1 ,\
  MDYN.DES[2].RDES[3].".out" skip 1 u (XHBA[3]):($2*MW2[3]/1000):($3*MW2[3]/1000) every 1::1::1 w errorbars pt PT ps PS  lw LW lc rgb COLORS[2]
unset term
unset output
replot
