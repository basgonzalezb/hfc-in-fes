reset
set encoding utf8

T		= "303.15"
RATIO		= 0.8
LW		= 4
PT		= 5
PS		= 2

set lmargin at screen 0.266
set bmargin at screen 0.15
set border lw 1.5

XLABEL		= "$\\tilde{E}$ / kJ$\\cdot$mol$^{-1}$"

PARAM		= "TZVP"
array HFC[3]	= ["R32", "R134a", "R125"]
array DES[3]	= ["c2mim_hdfs_pfpa[1_2]", "tba_nfs_pfpa[1_2]", "tbp_br_pfpa[1_2]"]
array COLORS[5] = ["#a41623", "#d9dcd6", "#16425b", "#0091ad", "#52b788"] # GE HE_vdw HE_hb HE_mf HE
array TICS[3]	= [\
		"{[C2M][HDFS]:PFPA (1:2)}",\
		"{[TBA][NFS]:PFPA (1:2)}",\
		"{[TBP]Br:PFPA (1:2)}"]

CSMO		      = "../../cosmo/excess_properties/"

set size ratio 1.2
set xrange [-2.5:0.5]
set yrange [0.1:6.3]
set xlabel XLABEL offset 0, -1
set xtics 0.5 format "%.1f" scale 2 offset 0,    0
set ytics (TICS[1] 6.0, TICS[2] 5.4, TICS[3] 4.8, TICS[1] 3.8, TICS[2] 3.2, TICS[3] 2.6, TICS[1] 1.6, TICS[2] 1.0, TICS[3] 0.4) scale 2 offset 0, -0.5 rotate by 0
set mxtics 2
unset k
set boxwidth 0.20
set style fill solid border -1
set pointintervalbox 0

set arrow from 0,0 to 0,6 nohead lw LW dt 2

set label 1 "R32"	at -1.5,6.0 left
set label 2 "R134a"	at -1.5,3.8 left
set label 3 "R125"	at -1.5,1.6 left
set term epslatex size 12cm,12cm fontscale 0.75
set output "figures/excess_properties1.tex"
plot \
  for [i=1:3] for [j=0:2] CSMO.DES[i]."-".PARAM.".out" skip 1 u 0:(6.1-0.6*(i-1)-2.2*j):(0):2:(6.1-0.6*(i-1)-2.2*j-0.1):(6.1-0.6*(i-1)-2.2*j+0.1) every 1::j::j w boxxy lw LW lc rgb COLORS[1] ,\
  for [i=1:3] for [j=0:2] CSMO.DES[i]."-".PARAM.".out" skip 1 u 0:(5.9-0.6*(i-1)-2.2*j):(0):4:(5.9-0.6*(i-1)-2.2*j-0.1):(5.9-0.6*(i-1)-2.2*j+0.1) every 1::j::j w boxxy lw LW lc rgb COLORS[2] ,\
  for [i=1:1] for [j=0:0] CSMO.DES[i]."-".PARAM.".out" skip 1 u 0:(5.9-0.6*(i-1)-2.2*j):(0):5:(5.9-0.6*(i-1)-2.2*j-0.1):(5.9-0.6*(i-1)-2.2*j+0.1) every 1::j::j w boxxy lw LW lc rgb COLORS[3] ,\
  for [i=1:1] for [j=0:0] CSMO.DES[i]."-".PARAM.".out" skip 1 u 0:(5.9-0.6*(i-1)-2.2*j):(0):($5+$6):(5.9-0.6*(i-1)-2.2*j-0.1):(5.9-0.6*(i-1)-2.2*j+0.1) every 1::j::j w boxxy lw LW lc rgb COLORS[4] ,\
  for [i=1:1] for [j=1:2] CSMO.DES[i]."-".PARAM.".out" skip 1 u 0:(5.9-0.6*(i-1)-2.2*j):(0):($4+$5):(5.9-0.6*(i-1)-2.2*j-0.1):(5.9-0.6*(i-1)-2.2*j+0.1) every 1::j::j w boxxy lw LW lc rgb COLORS[3] ,\
  for [i=1:1] for [j=1:2] CSMO.DES[i]."-".PARAM.".out" skip 1 u 0:(5.9-0.6*(i-1)-2.2*j):(0):($4+$5+$6):(5.9-0.6*(i-1)-2.2*j-0.1):(5.9-0.6*(i-1)-2.2*j+0.1) every 1::j::j w boxxy lw LW lc rgb COLORS[4] ,\
  for [i=2:2] for [j=0:0] CSMO.DES[i]."-".PARAM.".out" skip 1 u 0:(5.9-0.6*(i-1)-2.2*j):(0):($4+$5):(5.9-0.6*(i-1)-2.2*j-0.1):(5.9-0.6*(i-1)-2.2*j+0.1) every 1::j::j w boxxy lw LW lc rgb COLORS[3] ,\
  for [i=2:2] for [j=0:0] CSMO.DES[i]."-".PARAM.".out" skip 1 u 0:(5.9-0.6*(i-1)-2.2*j):(0):6:(5.9-0.6*(i-1)-2.2*j-0.1):(5.9-0.6*(i-1)-2.2*j+0.1) every 1::j::j w boxxy lw LW lc rgb COLORS[4] ,\
  for [i=2:2] for [j=1:2] CSMO.DES[i]."-".PARAM.".out" skip 1 u 0:(5.9-0.6*(i-1)-2.2*j):(0):5:(5.9-0.6*(i-1)-2.2*j-0.1):(5.9-0.6*(i-1)-2.2*j+0.1) every 1::j::j w boxxy lw LW lc rgb COLORS[3] ,\
  for [i=2:2] for [j=1:2] CSMO.DES[i]."-".PARAM.".out" skip 1 u 0:(5.9-0.6*(i-1)-2.2*j):(0):($5+$6):(5.9-0.6*(i-1)-2.2*j-0.1):(5.9-0.6*(i-1)-2.2*j+0.1) every 1::j::j w boxxy lw LW lc rgb COLORS[4] ,\
  for [i=3:3] for [j=0:0] CSMO.DES[i]."-".PARAM.".out" skip 1 u 0:(5.9-0.6*(i-1)-2.2*j):(0):($4+$5):(5.9-0.6*(i-1)-2.2*j-0.1):(5.9-0.6*(i-1)-2.2*j+0.1) every 1::j::j w boxxy lw LW lc rgb COLORS[3] ,\
  for [i=3:3] for [j=0:0] CSMO.DES[i]."-".PARAM.".out" skip 1 u 0:(5.9-0.6*(i-1)-2.2*j):(0):($4+$5+$6):(5.9-0.6*(i-1)-2.2*j-0.1):(5.9-0.6*(i-1)-2.2*j+0.1) every 1::j::j w boxxy lw LW lc rgb COLORS[4] ,\
  for [i=3:3] for [j=1:2] CSMO.DES[i]."-".PARAM.".out" skip 1 u 0:(5.9-0.6*(i-1)-2.2*j):(0):5:(5.9-0.6*(i-1)-2.2*j-0.1):(5.9-0.6*(i-1)-2.2*j+0.1) every 1::j::j w boxxy lw LW lc rgb COLORS[3] ,\
  for [i=3:3] for [j=1:2] CSMO.DES[i]."-".PARAM.".out" skip 1 u 0:(5.9-0.6*(i-1)-2.2*j):(0):($5+$6):(5.9-0.6*(i-1)-2.2*j-0.1):(5.9-0.6*(i-1)-2.2*j+0.1) every 1::j::j w boxxy lw LW lc rgb COLORS[4] ,\
  for [i=1:3] for [j=0:2] CSMO.DES[i]."-".PARAM.".out" skip 1 u 3:(5.9-0.6*(i-1)-2.2*j) every 1::j::j pt 5 ps 2.5 lc -1 ,\
  for [i=1:3] for [j=0:2] CSMO.DES[i]."-".PARAM.".out" skip 1 u 3:(5.9-0.6*(i-1)-2.2*j) every 1::j::j pt 5 ps PS lc rgb COLORS[5]
unset term
unset output
replot



array TICS[3]	= ["R32", "R134a", "R125"]
set label 1 "{[C2M][HDFS]:PFPA (1:2)}"	at -1.5,6.0 left
set label 2 "{[TBA][NFS]:PFPA (1:2)}"	at -1.5,3.8 left
set label 3 "{[TBP]Br:PFPA (1:2)}"	at -1.5,1.6 left
set term epslatex size 12cm,12cm fontscale 0.75
set output "figures/excess_properties1.tex"
plot \
  for [i=1:3] for [j=0:2] CSMO.DES[i]."-".PARAM.".out" skip 1 u 0:(6.1-0.6*j-2.2*(i-1)):(0):2:(6.1-0.6*j-2.2*(i-1)-0.1):(6.1-0.6*j-2.2*(i-1)+0.1) every 1::j::j w boxxy lw LW lc rgb COLORS[1] ,\
  for [i=1:3] for [j=0:2] CSMO.DES[i]."-".PARAM.".out" skip 1 u 0:(5.9-0.6*j-2.2*(i-1)):(0):4:(5.9-0.6*j-2.2*(i-1)-0.1):(5.9-0.6*j-2.2*(i-1)+0.1) every 1::j::j w boxxy lw LW lc rgb COLORS[2] ,\
  for [i=1:1] for [j=0:0] CSMO.DES[i]."-".PARAM.".out" skip 1 u 0:(5.9-0.6*j-2.2*(i-1)):(0):5:(5.9-0.6*j-2.2*(i-1)-0.1):(5.9-0.6*j-2.2*(i-1)+0.1) every 1::j::j w boxxy lw LW lc rgb COLORS[3] ,\
  for [i=1:1] for [j=0:0] CSMO.DES[i]."-".PARAM.".out" skip 1 u 0:(5.9-0.6*j-2.2*(i-1)):(0):($5+$6):(5.9-0.6*j-2.2*(i-1)-0.1):(5.9-0.6*j-2.2*(i-1)+0.1) every 1::j::j w boxxy lw LW lc rgb COLORS[4] ,\
  for [i=1:1] for [j=1:2] CSMO.DES[i]."-".PARAM.".out" skip 1 u 0:(5.9-0.6*j-2.2*(i-1)):(0):($4+$5):(5.9-0.6*j-2.2*(i-1)-0.1):(5.9-0.6*j-2.2*(i-1)+0.1) every 1::j::j w boxxy lw LW lc rgb COLORS[3] ,\
  for [i=1:1] for [j=1:2] CSMO.DES[i]."-".PARAM.".out" skip 1 u 0:(5.9-0.6*j-2.2*(i-1)):(0):($4+$5+$6):(5.9-0.6*j-2.2*(i-1)-0.1):(5.9-0.6*j-2.2*(i-1)+0.1) every 1::j::j w boxxy lw LW lc rgb COLORS[4] ,\
  for [i=2:2] for [j=0:0] CSMO.DES[i]."-".PARAM.".out" skip 1 u 0:(5.9-0.6*j-2.2*(i-1)):(0):($4+$5):(5.9-0.6*j-2.2*(i-1)-0.1):(5.9-0.6*j-2.2*(i-1)+0.1) every 1::j::j w boxxy lw LW lc rgb COLORS[3] ,\
  for [i=2:2] for [j=0:0] CSMO.DES[i]."-".PARAM.".out" skip 1 u 0:(5.9-0.6*j-2.2*(i-1)):(0):6:(5.9-0.6*j-2.2*(i-1)-0.1):(5.9-0.6*j-2.2*(i-1)+0.1) every 1::j::j w boxxy lw LW lc rgb COLORS[4] ,\
  for [i=2:2] for [j=1:2] CSMO.DES[i]."-".PARAM.".out" skip 1 u 0:(5.9-0.6*j-2.2*(i-1)):(0):5:(5.9-0.6*j-2.2*(i-1)-0.1):(5.9-0.6*j-2.2*(i-1)+0.1) every 1::j::j w boxxy lw LW lc rgb COLORS[3] ,\
  for [i=2:2] for [j=1:2] CSMO.DES[i]."-".PARAM.".out" skip 1 u 0:(5.9-0.6*j-2.2*(i-1)):(0):($5+$6):(5.9-0.6*j-2.2*(i-1)-0.1):(5.9-0.6*j-2.2*(i-1)+0.1) every 1::j::j w boxxy lw LW lc rgb COLORS[4] ,\
  for [i=3:3] for [j=0:0] CSMO.DES[i]."-".PARAM.".out" skip 1 u 0:(5.9-0.6*j-2.2*(i-1)):(0):($4+$5):(5.9-0.6*j-2.2*(i-1)-0.1):(5.9-0.6*j-2.2*(i-1)+0.1) every 1::j::j w boxxy lw LW lc rgb COLORS[3] ,\
  for [i=3:3] for [j=0:0] CSMO.DES[i]."-".PARAM.".out" skip 1 u 0:(5.9-0.6*j-2.2*(i-1)):(0):($4+$5+$6):(5.9-0.6*j-2.2*(i-1)-0.1):(5.9-0.6*j-2.2*(i-1)+0.1) every 1::j::j w boxxy lw LW lc rgb COLORS[4] ,\
  for [i=3:3] for [j=1:2] CSMO.DES[i]."-".PARAM.".out" skip 1 u 0:(5.9-0.6*j-2.2*(i-1)):(0):5:(5.9-0.6*j-2.2*(i-1)-0.1):(5.9-0.6*j-2.2*(i-1)+0.1) every 1::j::j w boxxy lw LW lc rgb COLORS[3] ,\
  for [i=3:3] for [j=1:2] CSMO.DES[i]."-".PARAM.".out" skip 1 u 0:(5.9-0.6*j-2.2*(i-1)):(0):($5+$6):(5.9-0.6*j-2.2*(i-1)-0.1):(5.9-0.6*j-2.2*(i-1)+0.1) every 1::j::j w boxxy lw LW lc rgb COLORS[4] ,\
  for [i=1:3] for [j=0:2] CSMO.DES[i]."-".PARAM.".out" skip 1 u 3:(5.9-0.6*j-2.2*(i-1)) every 1::j::j pt 5 ps 2.5 lc -1 ,\
  for [i=1:3] for [j=0:2] CSMO.DES[i]."-".PARAM.".out" skip 1 u 3:(5.9-0.6*j-2.2*(i-1)) every 1::j::j pt 5 ps PS lc rgb COLORS[5]
unset term
unset output
#replot















