reset
set encoding utf8

T		= "303.15"
RATIO		= 0.8
LW		= 4
PT		= 5
PS		= 2

XLABEL		= "System"
YLABEL		= "$\\eta$ / cP"

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
set xrange [0.50:5.25]
set ylabel YLABEL offset -2, 0 rotate by 90
unset xtics
set xtics ("[C2mim][HDFS]:PFPA (1:2)" 1.25, "[TBA][NFS]:PFPA (1:2)" 2.75, "[TBP][Br]:PFPA (1:2)" 4.25) offset 0, -0.5 rotate by 0
set xtics ("FDES1" 1.375, "FDES2" 2.875, "FDES3" 4.375) offset 0, -0.5 rotate by 0 nomirror
set format y "10^{%T}"
set ytics scale 2 offset 0,    0
set mxtics 2
#set mytics 2
unset k
set logscale y
set boxwidth 0.25
set style fill solid border -1
set pointintervalbox 0


#set label 1 HFC[i]." (1)" at graph 0.10, 0.85
set term epslatex size 8cm,6cm fontscale 0.75
set output "figures/viscosities.tex"
p MDYN.DES[1].RDES.".out" skip 1 u ($1*0+1.00):2:3 w boxerrorbars lw LW lc rgb GRAY ,\
  MDYN.HFC[1]."_".DES[1].RDES.".out" skip 1 u ($1*0+1.25):2:3 w boxerrorbars lw LW lc rgb COLORS[1] ,\
  MDYN.HFC[2]."_".DES[1].RDES.".out" skip 1 u ($1*0+1.50):2:3 w boxerrorbars lw LW lc rgb COLORS[2] ,\
  MDYN.HFC[3]."_".DES[1].RDES.".out" skip 1 u ($1*0+1.75):2:3 w boxerrorbars lw LW lc rgb COLORS[3] ,\
  MDYN.DES[2].RDES.".out" skip 1 u ($1*0+2.50):2:3 w boxerrorbars lw LW lc rgb GRAY,\
  MDYN.HFC[1]."_".DES[2].RDES.".out" skip 1 u ($1*0+2.75):2:3 w boxerrorbars lw LW lc rgb COLORS[1] ,\
  MDYN.HFC[2]."_".DES[2].RDES.".out" skip 1 u ($1*0+3.00):2:3 w boxerrorbars lw LW lc rgb COLORS[2] ,\
  MDYN.HFC[3]."_".DES[2].RDES.".out" skip 1 u ($1*0+3.25):2:3 w boxerrorbars lw LW lc rgb COLORS[3] ,\
  MDYN.DES[3].RDES.".out" skip 1 u ($1*0+4.00):2:3 w boxerrorbars lw LW lc rgb GRAY,\
  MDYN.HFC[1]."_".DES[3].RDES.".out" skip 1 u ($1*0+4.25):2:3 w boxerrorbars lw LW lc rgb COLORS[1] ,\
  MDYN.HFC[2]."_".DES[3].RDES.".out" skip 1 u ($1*0+4.50):2:3 w boxerrorbars lw LW lc rgb COLORS[2] ,\
  MDYN.HFC[3]."_".DES[3].RDES.".out" skip 1 u ($1*0+4.75):2:3 w boxerrorbars lw LW lc rgb COLORS[3]
unset term
unset output
replot



reset
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
p 0,0 w boxes lw LW lc rgb GRAY fillstyle pattern 3      title "FDES"   ,\
  0,0 w boxes lw LW lc rgb COLORS[1] fillstyle pattern 3 title "  FDES + R32"   ,\
  0,0 w boxes lw LW lc rgb COLORS[2] fillstyle pattern 3 title "FDES + R134a" ,\
  0,0 w boxes lw LW lc rgb COLORS[3] fillstyle pattern 3 title " FDES + R125"
unset term
unset output
replot