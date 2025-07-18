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

array XHBA[3]	= [0.333, 0.500, 0.667]
array MW1[3]	= [379.35, 437.17, 494.99]
array MW2[3]    = [356.46, 402.80, 449.14]
array MW[6]	= [379.35, 437.17, 494.99, \
                   356.46, 402.80, 449.14]

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

YLABEL		= "$\\hat{\\rho}$ / g$\\cdot$cm$^{-3}$"
array Y1[2]	= [1.6, 1.2]
array Y2[2]	= [1.8, 1.5]
#set yrange [1.2:1.8]
set ylabel YLABEL offset -2, 0 rotate by 90
k = 0
do for [i=1:2] {
  set label 1 LABELS[i] at graph 0.10, 0.85
  set yrange [Y1[i]:Y2[i]]
  set ytics 0.1 format "%.1f" scale 2 offset 0,    0
  set term epslatex size 8cm,6cm fontscale 0.75
  set output "figures/density_fdes".i."_mass.tex"
#  set term pdfcairo size 8cm,6cm fontscale 0.75
#  set output "figures/density_fdes".i.".pdf"
  p DATA.DES[i].RDES[1].".txt" skip 1 u 1:($2*MW[i+k+0]/1000) lc -1 ps 2.5 pt 7 lw LW ,\
    DATA.DES[i].RDES[2].".txt" skip 1 u 1:($2*MW[i+k+1]/1000) lc -1 ps 2.5 pt 7 lw LW ,\
    DATA.DES[i].RDES[3].".txt" skip 1 u 1:($2*MW[i+k+2]/1000) lc -1 ps 2.5 pt 7 lw LW ,\
    DATA.DES[i].RDES[1].".txt" skip 1 u 1:($2*MW[i+k+0]/1000) lc rgb COLORS[1] ps PS pt 7 lw LW ,\
    DATA.DES[i].RDES[2].".txt" skip 1 u 1:($2*MW[i+k+1]/1000) lc rgb COLORS[2] ps PS pt 7 lw LW ,\
    DATA.DES[i].RDES[3].".txt" skip 1 u 1:($2*MW[i+k+2]/1000) lc rgb COLORS[3] ps PS pt 7 lw LW ,\
    MDYN.DES[i].RDES[1].".txt" skip 1 u 1:($2*MW[i+k+0]/1000) lc -1 ps 2.5 pt PT lw LW ,\
    MDYN.DES[i].RDES[2].".txt" skip 1 u 1:($2*MW[i+k+1]/1000) lc -1 ps 2.5 pt PT lw LW ,\
    MDYN.DES[i].RDES[3].".txt" skip 1 u 1:($2*MW[i+k+2]/1000) lc -1 ps 2.5 pt PT lw LW ,\
    MDYN.DES[i].RDES[1].".txt" skip 1 u 1:($2*MW[i+k+0]/1000) lc rgb COLORS[1] ps PS pt PT lw LW ,\
    MDYN.DES[i].RDES[2].".txt" skip 1 u 1:($2*MW[i+k+1]/1000) lc rgb COLORS[2] ps PS pt PT lw LW ,\
    MDYN.DES[i].RDES[3].".txt" skip 1 u 1:($2*MW[i+k+2]/1000) lc rgb COLORS[3] ps PS pt PT lw LW
  unset term
  unset output
  replot
  k = 2
}

unset label 1
unset xlabel
unset ylabel
unset margin
unset xtics
unset ytics
unset border
set yrange [1:2]
set key noautotitle at graph -10, .75 noreverse horizontal keywidth screen 1 left
#set key noautotitle at screen 0.93, 0.80 noreverse horizontal keywidth screen 1 left
set style fill solid 0.5 border -1
set term pdf size 18cm, 1cm
set output "legend.pdf"
p 0,0 w boxes lw LW lc rgb COLORS[1] fillstyle pattern 3 title "\\!\\!\\!{1:2}" ,\
  0,0 w boxes lw LW lc rgb COLORS[2] fillstyle pattern 3 title "\\!\\!\\!{1:1}" ,\
  0,0 w boxes lw LW lc rgb COLORS[3] fillstyle pattern 3 title "\\!\\!\\!{2:1}"
set term epslatex size 18cm,1cm fontscale 0.75 
set output "figures/density_fdes-legend.tex"
replot
