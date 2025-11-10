reset
set encoding utf8

T		= "303.15"
RATIO		= 0.8
LW		= 4
PT		= 5
PS		= 2

XLABEL		= "$r$ / nm"
YLABEL		= "$g(r)$"

MDYN		= "../../md_analysis/rdf/x1=0.45/rdf_mol-"

array DES[3]	= ["c2mim_hdfs_pfpa", "tba_nfs_pfpa", "tbp_br_pfpa"]
RDES		= "[1_2]"
array COLORS[3]	= ["#005da4", "#29a4c3", "#57aa29"]
array HFC[3]	= ["R32", "R134a", "R125"]

set lmargin at screen 0.266
set bmargin at screen 0.258
set border lw 1.5

set size ratio RATIO
set xrange [0.0:1.2]
set yrange [0.0:4.8]
set xlabel XLABEL offset 0, -1
set ylabel YLABEL offset -2, 0 rotate by 90
set xtics 0.3 format "%.1f" scale 2 offset 0, -0.5
set ytics 1.2 format "%.1f" scale 2 offset 0,    0
set mxtics 2
set mytics 2
unset k

do for [i=1:3] {
  set label 1 "a)" at graph 0.10, 0.85
  set term epslatex size 8cm,6cm fontscale 0.75
  set output "figures/rdf_components-".HFC[i].".tex"
  plot \
    for [j=1:3] MDYN.HFC[i]."_".DES[j].".out" skip 1 u 1:2 w lp lc rgb COLORS[j] pt -1 dt 1 lw LW ,\
    for [j=1:3] MDYN.HFC[i]."_".DES[j].".out" skip 1 u 1:3 w lp lc rgb COLORS[j] pt -1 dt 3 lw LW
  unset term
  unset output
  replot
}
do for [i=1:3] {
  set label 1 "b)" at graph 0.10, 0.85
  set term epslatex size 8cm,6cm fontscale 0.75
  set output "figures/rdf-".HFC[i]."-".HFC[i].".tex"
  plot \
    for [j=1:3] MDYN.HFC[i]."_".DES[j].".out" skip 1 u 1:5 w lp lc rgb COLORS[j]    pt -1 dt 1 lw LW
  unset term
  unset output
  replot
}
