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

XLABEL		= "HFC"
YLABEL		= "$\\tilde{E}$ / kJ$\\cdot$mol$^{-1}$"

PARAM		= "TZVP"
array DES[3]	= ["c2mim_hdfs_pfpa[1_2]", "tba_nfs_pfpa[1_2]", "tbp_br_pfpa[1_2]"]
array COLORS[5]	= ["#e63946", "#1d3557", "#8d99ae", "#a8dadc", "#f1faee"]
array HFC[3]	= ["R32", "R134a", "R125"]
array FIGLBL[3]	= ["a)", "b)", "c)"]

CSMO		      = "../../cosmo/excess_properties/"

set xrange [0:1.8]
set yrange [-3:1]
set xlabel XLABEL offset 0, -1
set ylabel YLABEL offset -2, 0 rotate by 90
set xtics (HFC[1] 0.30, HFC[2] 0.90, HFC[3] 1.50) scale 2 offset 0, -0.5 rotate by 0
set ytics 1 format "%.1f" scale 2 offset 0,    0
set mytics 2
unset k
set boxwidth 0.20
set style fill solid border -1
set pointintervalbox 0

do for [i=1:3] {
  set label 1 FIGLBL[i] at graph .10, .20
  set term pdf size 8cm,6cm fontscale 0.75
  set output "figures/excess_properties-".DES[i].".pdf"
  p CSMO.DES[i]."-".PARAM.".out" skip 1 u (0.20):2 every 1::0::0 w boxes lw LW lc rgb COLORS[1] ,\
    CSMO.DES[i]."-".PARAM.".out" skip 1 u (0.40):3 every 1::0::0 w boxes lw LW lc rgb COLORS[2] ,\
    CSMO.DES[i]."-".PARAM.".out" skip 1 u (0.40):4 every 1::0::0 pt 5 ps 2.5 lc -1 ,\
    CSMO.DES[i]."-".PARAM.".out" skip 1 u (0.40):5 every 1::0::0 pt 5 ps 2.5 lc -1 ,\
    CSMO.DES[i]."-".PARAM.".out" skip 1 u (0.40):6 every 1::0::0 pt 5 ps 2.5 lc -1 ,\
    CSMO.DES[i]."-".PARAM.".out" skip 1 u (0.40):4 every 1::0::0 pt 5 ps  PS lc rgb COLORS[3] ,\
    CSMO.DES[i]."-".PARAM.".out" skip 1 u (0.40):5 every 1::0::0 pt 5 ps  PS lc rgb COLORS[4] ,\
    CSMO.DES[i]."-".PARAM.".out" skip 1 u (0.40):6 every 1::0::0 pt 5 ps  PS lc rgb COLORS[5] ,\
    CSMO.DES[i]."-".PARAM.".out" skip 1 u (0.80):2 every 1::1::1 w boxes lw LW lc rgb COLORS[1] ,\
    CSMO.DES[i]."-".PARAM.".out" skip 1 u (1.00):3 every 1::1::1 w boxes lw LW lc rgb COLORS[2] ,\
    CSMO.DES[i]."-".PARAM.".out" skip 1 u (1.00):4 every 1::1::1 pt 5 ps 2.5 lc -1 ,\
    CSMO.DES[i]."-".PARAM.".out" skip 1 u (1.00):5 every 1::1::1 pt 5 ps 2.5 lc -1 ,\
    CSMO.DES[i]."-".PARAM.".out" skip 1 u (1.00):6 every 1::1::1 pt 5 ps 2.5 lc -1 ,\
    CSMO.DES[i]."-".PARAM.".out" skip 1 u (1.00):4 every 1::1::1 pt 5 ps  PS lc rgb COLORS[3] ,\
    CSMO.DES[i]."-".PARAM.".out" skip 1 u (1.00):5 every 1::1::1 pt 5 ps  PS lc rgb COLORS[4] ,\
    CSMO.DES[i]."-".PARAM.".out" skip 1 u (1.00):6 every 1::1::1 pt 5 ps  PS lc rgb COLORS[5] ,\
    CSMO.DES[i]."-".PARAM.".out" skip 1 u (1.40):2 every 1::2::2 w boxes lw LW lc rgb COLORS[1] ,\
    CSMO.DES[i]."-".PARAM.".out" skip 1 u (1.60):3 every 1::2::2 w boxes lw LW lc rgb COLORS[2] ,\
    CSMO.DES[i]."-".PARAM.".out" skip 1 u (1.60):4 every 1::2::2 pt 5 ps 2.5 lc -1 ,\
    CSMO.DES[i]."-".PARAM.".out" skip 1 u (1.60):5 every 1::2::2 pt 5 ps 2.5 lc -1 ,\
    CSMO.DES[i]."-".PARAM.".out" skip 1 u (1.60):6 every 1::2::2 pt 5 ps 2.5 lc -1 ,\
    CSMO.DES[i]."-".PARAM.".out" skip 1 u (1.60):4 every 1::2::2 pt 5 ps  PS lc rgb COLORS[3] ,\
    CSMO.DES[i]."-".PARAM.".out" skip 1 u (1.60):5 every 1::2::2 pt 5 ps  PS lc rgb COLORS[4] ,\
    CSMO.DES[i]."-".PARAM.".out" skip 1 u (1.60):6 every 1::2::2 pt 5 ps  PS lc rgb COLORS[5]
  set term epslatex size 8cm,6cm fontscale 0.75
  set output "figures/excess_properties-".DES[i].".tex"
  replot
  unset term
  unset output
  replot
}

set term pdf size 10cm, 1cm
set output "legend.pdf"
set k noautotitle at screen .93, .80 horizontal reverse
unset margin
unset border
unset tics
unset label 1
unset xlabel
unset ylabel
set yrange [1:2]
p 0,0 w boxes lw 0 lc rgb COLORS[1] fillstyle pattern 3 title "{/:Italic ~G{0.9\\~}^{  E}}" ,\
  0,0 w boxes lw 0 lc rgb COLORS[2] fillstyle pattern 3 title "{/:Italic ~H{0.9\\~}^{  E}}" ,\
  0,0 w boxes lw 0 lc rgb COLORS[3] fillstyle pattern 3 title "{/:Italic ~H{0.9\\~}@_{ vdW}^{  E}}" ,\
  0,0 w boxes lw 0 lc rgb COLORS[4] fillstyle pattern 3 title "{/:Italic ~H{0.9\\~}@_{ hb}^{  E}}" ,\
  0,0 w boxes lw 0 lc rgb COLORS[5] fillstyle pattern 3 title "{/:Italic ~H{0.9\\~}@_{ mf}^{  E}}"
unset term
unset output
replot
