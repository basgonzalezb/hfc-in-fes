reset
set encoding utf8

T		= "303.15"
RATIO		= 0.8
LW		= 4
PT		= 5
PS		= 2

XLABEL		= "HFC"
YLABEL		= "$K_H$ / MPa"

PARAM		= "TZVP"
CSMO		= "../../cosmo/henry_constants/"
MDYN		= "../../md_analysis/henry_constants/"
DATA		= "../../experimental/henry_constants/"

array DES[3]	= ["c2mim_hdfs_pfpa", "tba_nfs_pfpa", "tbp_br_pfpa"]
RDES		= "[1_2]"
array COLORS[3]	= ["#005da4", "#29a4c3", "#57aa29"]
array HFC[3]	= ["R32", "R134a", "R125"]

set lmargin at screen 0.266
set bmargin at screen 0.258
set border lw 1.5

set size ratio RATIO
set xrange [0:2.8]
set yrange [0:8]
set xlabel XLABEL offset 0, -1
set ylabel YLABEL offset -2, 0 rotate by 90
set xtics (HFC[1] 0.40, HFC[2] 1.40, HFC[3] 2.40) offset 0, -0.5 rotate by 0
set ytics 2 format "%.0f" scale 2 offset 0,    0
set mytics 2
unset k
set boxwidth 0.20
set style fill solid border -1
set pointintervalbox 0

set label 1 "a)" at graph 0.10, 0.85
set term epslatex size 8cm,6cm fontscale 0.75
set output "figures/henry_constants-".PARAM.".tex"
p CSMO.DES[1].RDES."-".PARAM.".txt" skip 1 u (0.20):2 every 1::0::0 w boxes              lw LW lc rgb COLORS[1] ,\
  DATA.DES[1].RDES.".txt"           skip 1 u (0.20):2 every 1::0::0 pt 7  lw LW ps 2.5 lc -1 ,\
  DATA.DES[1].RDES.".txt"           skip 1 u (0.20):2 every 1::0::0 pt 7  lw LW ps PS  lc rgb COLORS[1] ,\
  MDYN.DES[1].RDES.".txt" 	    skip 1 u (0.20):2 every 1::0::0 pt PT lw LW ps 2.5 lc -1 ,\
  MDYN.DES[1].RDES.".txt" 	    skip 1 u (0.20):2 every 1::0::0 pt PT lw LW ps PS  lc rgb COLORS[1] ,\
  CSMO.DES[2].RDES."-".PARAM.".txt" skip 1 u (0.40):2 every 1::0::0 w boxes              lw LW lc rgb COLORS[2] ,\
  DATA.DES[2].RDES.".txt"           skip 1 u (0.40):2 every 1::0::0 pt 7  lw LW ps 2.5 lc -1 ,\
  DATA.DES[2].RDES.".txt"           skip 1 u (0.40):2 every 1::0::0 pt 7  lw LW ps PS  lc rgb COLORS[2] ,\
  MDYN.DES[2].RDES.".txt" 	    skip 1 u (0.40):2 every 1::0::0 pt PT lw LW ps 2.5 lc -1 ,\
  MDYN.DES[2].RDES.".txt" 	    skip 1 u (0.40):2 every 1::0::0 pt PT lw LW ps PS  lc rgb COLORS[2] ,\
  CSMO.DES[3].RDES."-".PARAM.".txt" skip 1 u (0.60):2 every 1::0::0 w boxes              lw LW lc rgb COLORS[3] ,\
  MDYN.DES[3].RDES.".txt" 	    skip 1 u (0.60):2 every 1::0::0 pt PT lw LW ps 2.5 lc -1 ,\
  MDYN.DES[3].RDES.".txt" 	    skip 1 u (0.60):2 every 1::0::0 pt PT lw LW ps PS  lc rgb COLORS[3] ,\
  CSMO.DES[1].RDES."-".PARAM.".txt" skip 1 u (1.20):2 every 1::1::1 w boxes              lw LW lc rgb COLORS[1] ,\
  DATA.DES[1].RDES.".txt"           skip 1 u (1.20):2 every 1::1::1 pt 7  lw LW ps 2.5 lc -1 ,\
  DATA.DES[1].RDES.".txt"           skip 1 u (1.20):2 every 1::1::1 pt 7  lw LW ps PS  lc rgb COLORS[1] ,\
  MDYN.DES[1].RDES.".txt" 	    skip 1 u (1.20):2 every 1::1::1 pt PT lw LW ps 2.5 lc -1 ,\
  MDYN.DES[1].RDES.".txt" 	    skip 1 u (1.20):2 every 1::1::1 pt PT lw LW ps PS  lc rgb COLORS[1] ,\
  CSMO.DES[2].RDES."-".PARAM.".txt" skip 1 u (1.40):2 every 1::1::1 w boxes              lw LW lc rgb COLORS[2] ,\
  DATA.DES[2].RDES.".txt"           skip 1 u (1.40):2 every 1::1::1 pt 7  lw LW ps 2.5 lc -1 ,\
  DATA.DES[2].RDES.".txt"           skip 1 u (1.40):2 every 1::1::1 pt 7  lw LW ps PS  lc rgb COLORS[2] ,\
  MDYN.DES[2].RDES.".txt" 	    skip 1 u (1.40):2 every 1::1::1 pt PT lw LW ps 2.5 lc -1 ,\
  MDYN.DES[2].RDES.".txt" 	    skip 1 u (1.40):2 every 1::1::1 pt PT lw LW ps PS  lc rgb COLORS[2] ,\
  CSMO.DES[3].RDES."-".PARAM.".txt" skip 1 u (1.60):2 every 1::1::1 w boxes              lw LW lc rgb COLORS[3] ,\
  MDYN.DES[3].RDES.".txt" 	    skip 1 u (1.60):2 every 1::1::1 pt PT lw LW ps 2.5 lc -1 ,\
  MDYN.DES[3].RDES.".txt" 	    skip 1 u (1.60):2 every 1::1::1 pt PT lw LW ps PS  lc rgb COLORS[3] ,\
  CSMO.DES[1].RDES."-".PARAM.".txt" skip 1 u (2.20):2 every 1::2::2 w boxes              lw LW lc rgb COLORS[1] ,\
  DATA.DES[1].RDES.".txt"           skip 1 u (2.20):2 every 1::2::2 pt 7  lw LW ps 2.5 lc -1 ,\
  DATA.DES[1].RDES.".txt"           skip 1 u (2.20):2 every 1::2::2 pt 7  lw LW ps PS  lc rgb COLORS[1] ,\
  MDYN.DES[1].RDES.".txt" 	    skip 1 u (2.20):2 every 1::2::2 pt PT lw LW ps 2.5 lc -1 ,\
  MDYN.DES[1].RDES.".txt"   	    skip 1 u (2.20):2 every 1::2::2 pt PT lw LW ps PS  lc rgb COLORS[1] ,\
  CSMO.DES[2].RDES."-".PARAM.".txt" skip 1 u (2.40):2 every 1::2::2 w boxes              lw LW lc rgb COLORS[2] ,\
  DATA.DES[2].RDES.".txt"           skip 1 u (2.40):2 every 1::2::2 pt 7  lw LW ps 2.5 lc -1 ,\
  DATA.DES[2].RDES.".txt"           skip 1 u (2.40):2 every 1::2::2 pt 7  lw LW ps PS  lc rgb COLORS[2] ,\
  MDYN.DES[2].RDES.".txt" 	    skip 1 u (2.40):2 every 1::2::2 pt PT lw LW ps 2.5 lc -1 ,\
  MDYN.DES[2].RDES.".txt" 	    skip 1 u (2.40):2 every 1::2::2 pt PT lw LW ps PS  lc rgb COLORS[2] ,\
  CSMO.DES[3].RDES."-".PARAM.".txt" skip 1 u (2.60):2 every 1::2::2 w boxes              lw LW lc rgb COLORS[3] ,\
  MDYN.DES[3].RDES.".txt" 	    skip 1 u (2.60):2 every 1::2::2 pt PT lw LW ps 2.5 lc -1 ,\
  MDYN.DES[3].RDES.".txt" 	    skip 1 u (2.60):2 every 1::2::2 pt PT lw LW ps PS  lc rgb COLORS[3] ,\

unset term
unset output
replot
