reset
set encoding utf8

T		= "303.15"
PARAM		= "TZVP"
RATIO		= 0.8
LW		= 4
PT		= 5
PS		= 2

XLABEL		= "$x_{1}$ / mol$\\cdot$mol$^{-1}$"
YLABEL		= "$P$ / MPa"

MDYN		= "../../md_analysis/isotherms/px_"
CSMO		= "../../cosmo/isotherms/"
DATA		= "../../experimental/isotherms/"

array DES[3]	= ["c2mim_hdfs_pfpa", "tba_nfs_pfpa", "tbp_br_pfpa"]
RDES		= "[1_2]"
array COLORS[3]	= ["#00798c", "#d1495b", "#edae49"]
array COLORS[3]	= ["#005da4", "#29a4c3", "#57aa29"]
array HFC[3]	= ["R32", "R134a", "R125"]

set lmargin at screen 0.266
set bmargin at screen 0.258
set border lw 1.5

set size ratio RATIO
set xrange [0.0:0.6]
set yrange [0.0:2.0]
set xlabel XLABEL offset 0, -1
set ylabel YLABEL offset -2, 0 rotate by 90
set xtics 0.2 format "%.1f" scale 2 offset 0, -0.5
set ytics 0.5 format "%.1f" scale 2 offset 0,    0
set mxtics 2
set mytics 2
unset k

set label 1 "b)" at graph 0.10, 0.85
do for [i=1:3] {
  set label 1 HFC[i]." (1)" at graph 0.10, 0.85
  set label 1 "b)" at graph 0.10, 0.85
  set term epslatex size 8cm,6cm fontscale 0.75
  set output "figures/isotherms-".HFC[i]."-".PARAM.".tex"
  p CSMO.HFC[i]."+".DES[1].RDES."-".PARAM.".txt" skip 1 u 1:3 w lp lc rgb COLORS[1] pt -1 lw LW ,\
    CSMO.HFC[i]."+".DES[2].RDES."-".PARAM.".txt" skip 1 u 1:3 w lp lc rgb COLORS[2] pt -1 lw LW ,\
    CSMO.HFC[i]."+".DES[3].RDES."-".PARAM.".txt" skip 1 u 1:3 w lp lc rgb COLORS[3] pt -1 lw LW ,\
    DATA.HFC[i]."+".DES[1].RDES.".txt" skip 2 u 1:2 lc -1 ps 2.5 pt 7 lw LW ,\
    DATA.HFC[i]."+".DES[2].RDES.".txt" skip 2 u 1:2 lc -1 ps 2.5 pt 7 lw LW ,\
    DATA.HFC[i]."+".DES[1].RDES.".txt" skip 2 u 1:2 lc rgb COLORS[1] ps PS pt 7 lw LW ,\
    DATA.HFC[i]."+".DES[2].RDES.".txt" skip 2 u 1:2 lc rgb COLORS[2] ps PS pt 7 lw LW ,\
    MDYN.HFC[i]."_".DES[1].RDES.".out" skip 1 u 1:2 lc -1 ps 2.5 pt PT lw LW ,\
    MDYN.HFC[i]."_".DES[2].RDES.".out" skip 1 u 1:2 lc -1 ps 2.5 pt PT lw LW ,\
    MDYN.HFC[i]."_".DES[3].RDES.".out" skip 1 u 1:2 lc -1 ps 2.5 pt PT lw LW ,\
    MDYN.HFC[i]."_".DES[1].RDES.".out" skip 1 u 1:2:3 w errorbars lc rgb COLORS[1] ps PS pt PT lw LW ,\
    MDYN.HFC[i]."_".DES[2].RDES.".out" skip 1 u 1:2:3 w errorbars lc rgb COLORS[2] ps PS pt PT lw LW ,\
    MDYN.HFC[i]."_".DES[3].RDES.".out" skip 1 u 1:2:3 w errorbars lc rgb COLORS[3] ps PS pt PT lw LW
  set term pdfcairo size 8cm,6cm fontscale 0.75
  set output "figures/isotherms-".HFC[i]."-".PARAM.".pdf"
  replot
  unset term
  unset output
  replot
}

unset label 1
unset xlabel
unset ylabel
unset margin
unset xtics
unset ytics
set key noautotitle at graph 0.97, .75 font "Aptos, 18" reverse
set style fill solid 0.5 border -1
set term pdf size 15cm, 10cm
set output "legend.pdf"
p 0,0 w boxes lw LW lc rgb COLORS[1] fillstyle pattern 3 title "[C2M][HDFS]:PFPA (1:2)" ,\
  0,0 w boxes lw LW lc rgb COLORS[2] fillstyle pattern 3 title "[TBA][NFS]:PFPA (1:2)" ,\
  0,0 w boxes lw LW lc rgb COLORS[3] fillstyle pattern 3 title "[TBP]Br:PFPA (1:2)"
unset term
unset output
replot
