reset
set encoding utf8

T		= "303.15"
RATIO		= 0.8
LW		= 4
PT		= 5
PS		= 2

set lmargin at screen 0.266
set bmargin at screen 0.258
set border lw 1.5

XLABEL		= "Excess property"

PARAM		= "TZVP"
array HFC[3]	= ["R32", "R134a", "R125"]
array DES[3]	= ["c2mim_hdfs_pfpa[1_2]", "tba_nfs_pfpa[1_2]", "tbp_br_pfpa[1_2]"]
array COLORS[5] = ["#a41623", "#d9dcd6", "#16425b", "#0091ad", "#52b788"]
array TICS[2]	= ["FES 1", "FES 2"]

CSMO		      = "../../cosmo/excess_properties/"

set size ratio RATIO
set xrange [-0.5:0.3]
set yrange [5.1:6.3]
set xlabel XLABEL offset 0, -1
unset xtics
set ytics (TICS[1] 6.0, TICS[2] 5.4) scale 2 offset 0, -0.5 rotate by 0 nomirror
unset k
set boxwidth 0.20
set style fill solid border -1
set pointintervalbox 0

set arrow from 0,5.1 to 0.0,6.3 nohead lw LW dt 2
set term epslatex size 8cm,6cm fontscale 0.75
set output "figures_ga/excess_properties.tex"
plot \
  CSMO.DES[1]."-".PARAM.".out" skip 1 u 0:(6.1):(0):2:(6.0):(6.2) every 1::0::0 w boxxy lw LW lc rgb COLORS[1] ,\
  CSMO.DES[1]."-".PARAM.".out" skip 1 u 0:(5.9):(0):4:(5.8):(6.0) every 1::0::0 w boxxy lw LW lc rgb COLORS[2] ,\
  CSMO.DES[1]."-".PARAM.".out" skip 1 u 0:(5.9):(0):($5+$6):(5.8):(6.0) every 1::0::0 w boxxy lw LW lc rgb COLORS[4] ,\
  CSMO.DES[1]."-".PARAM.".out" skip 1 u 0:(5.9):(0):5:(5.8):(6.0) every 1::0::0 w boxxy lw LW lc rgb COLORS[3] ,\
  CSMO.DES[1]."-".PARAM.".out" skip 1 u 3:(5.9) every 1::0::0 pt 13 ps 1.5*PS lc -1 ,\
  CSMO.DES[1]."-".PARAM.".out" skip 1 u 3:(5.9) every 1::0::0 pt 13 ps 1.0*PS  lc rgb COLORS[5] ,\
  CSMO.DES[3]."-".PARAM.".out" skip 1 u 0:(5.5):(0):2:(5.4):(5.6) every 1::0::0 w boxxy lw LW lc rgb COLORS[1] ,\
  CSMO.DES[3]."-".PARAM.".out" skip 1 u 0:(5.3):(0):($4+$5+$6):(5.2):(5.4) every 1::0::0 w boxxy lw LW lc rgb COLORS[4] ,\
  CSMO.DES[3]."-".PARAM.".out" skip 1 u 0:(5.3):(0):($4+$5):(5.2):(5.4) every 1::0::0 w boxxy lw LW lc rgb COLORS[3] ,\
  CSMO.DES[3]."-".PARAM.".out" skip 1 u 0:(5.3):(0):4:(5.2):(5.4) every 1::0::0 w boxxy lw LW lc rgb COLORS[2] ,\
  CSMO.DES[3]."-".PARAM.".out" skip 1 u 3:(5.3) every 1::0::0 pt 13 ps 1.5*PS lc -1 ,\
  CSMO.DES[3]."-".PARAM.".out" skip 1 u 3:(5.3) every 1::0::0 pt 13 ps 1.0*PS  lc rgb COLORS[5]
unset term
unset output
replot















