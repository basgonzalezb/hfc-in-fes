reset
set encoding utf8

T		= "303.15"
RATIO		= 0.8
LW		= 4
PT		= 5
PS		= 2

XLABEL		= "HFC"
YLABEL		= "$\\eta^L$ / cP"

MDYN		= "../../md_analysis/viscosities/"

array DES[3]	= ["c2mim_hdfs_pfpa", "tba_nfs_pfpa", "tbp_br_pfpa"]
RDES   = "[1_2]"
array COLORS[3]	= ["#00798c", "#d1495b", "#edae49"]
array COLORS[3]	= ["#005da4", "#29a4c3", "#57aa29"]
GRAY	  	= "#adadad"
array HFC[3]	= ["R32", "R134a", "R125"]

set lmargin at screen 0.266
set bmargin at screen 0.258
set border lw 1.5

set size ratio RATIO
set xrange [0:3.8]
set yrange [1:1E4]
set xlabel XLABEL offset 0, -1
set ylabel YLABEL offset -2, 0 rotate by 90
#set xtics ("None" 0.40, "R32" 1.40, "R134a" 2.40, "R125" 3.40) scale 2 offset 0, -0.5 rotate by 0
set xtics ("R32" 0.40, "R134a" 1.40, "R125" 2.40, "None" 3.40) scale 2 offset 0, -0.5 rotate by 0
set ytics format "$10^{%T}$" scale 2 offset 0,    0
unset k
set logscale y
set boxwidth 0.20
set style fill solid border -1
set pointintervalbox 0

set label 1 "a)" at graph 0.10, 0.85
set term epslatex size 8cm,6cm fontscale 0.75
set output "figures/viscosities.tex"
plot \
  MDYN.DES[1].RDES.".out" skip 1 u (3.20):2:3 w boxerrorbars lw LW lc rgb COLORS[1] ,\
  MDYN.DES[2].RDES.".out" skip 1 u (3.40):2:3 w boxerrorbars lw LW lc rgb COLORS[2],\
  MDYN.DES[3].RDES.".out" skip 1 u (3.60):2:3 w boxerrorbars lw LW lc rgb COLORS[3],\
  MDYN.HFC[1]."_".DES[1].RDES.".out" skip 1 u (0.20):2:3 w boxerrorbars lw LW lc rgb COLORS[1] ,\
  MDYN.HFC[1]."_".DES[2].RDES.".out" skip 1 u (0.40):2:3 w boxerrorbars lw LW lc rgb COLORS[2] ,\
  MDYN.HFC[1]."_".DES[3].RDES.".out" skip 1 u (0.60):2:3 w boxerrorbars lw LW lc rgb COLORS[3] ,\
  MDYN.HFC[2]."_".DES[1].RDES.".out" skip 1 u (1.20):2:3 w boxerrorbars lw LW lc rgb COLORS[1] ,\
  MDYN.HFC[2]."_".DES[2].RDES.".out" skip 1 u (1.40):2:3 w boxerrorbars lw LW lc rgb COLORS[2] ,\
  MDYN.HFC[2]."_".DES[3].RDES.".out" skip 1 u (1.60):2:3 w boxerrorbars lw LW lc rgb COLORS[3] ,\
  MDYN.HFC[3]."_".DES[1].RDES.".out" skip 1 u (2.20):2:3 w boxerrorbars lw LW lc rgb COLORS[1] ,\
  MDYN.HFC[3]."_".DES[2].RDES.".out" skip 1 u (2.40):2:3 w boxerrorbars lw LW lc rgb COLORS[2] ,\
  MDYN.HFC[3]."_".DES[3].RDES.".out" skip 1 u (2.60):2:3 w boxerrorbars lw LW lc rgb COLORS[3]
#  for [i=1:3] for [j=1:3] MDYN.HFC[i]."_".DES[j].RDES.".out" skip 1 u ((i-1+j/5)):2:3 w boxerrorbars lw LW lc rgb COLORS[j] ,\
#  for [i=1:3] MDYN.DES[i].RDES.".out" skip 1 u ((3+i/5)):2:3 w boxerrorbars lw LW lc rgb COLORS[i]
unset term
unset output
replot
