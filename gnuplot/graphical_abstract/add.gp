
reset session
set encoding utf8
RATIO		= 0.8
LW		= 4
PT		= 5
PS		= 2

YLABEL		= "\\theta[C1-H1]-[C1-Br] / Degree"

array XLABEL[3]	= ["$r_{C1-O1}$", "$r_{C1-O1}$", "$r_{C1-Br}$"]
array YLABEL[3] = ["$\\theta_{H1-C1-O1}$", "$\\theta_{H1-C1-O1}$", "$\\theta_{H1-C1-Br}$"]

DATA		= "cdf-"

array ZMAX[9]	= [ 800,  800, 1600, \
		    920,  950, 2050, \
		   2000, 2600, 6500]
array ZMAX[9] 	= [1600, 1600, 1600, \
		   2050, 2050, 2050, \
		   6500, 6500, 6500]
array ZMAX[9] 	= [6500, 6500, 6500, \
		   6500, 6500, 6500, \
		   6500, 6500, 6500]
array HFC[3]	= ["r32", "r134a", "r125"]
array ANION[3]	= ["hdfs", "nfs", "br"]
array LBL[3]	= ["a)", " ", "b)"]

set lmargin at screen 0.15
set rmargin at screen 0.85
set bmargin at screen 0.15
set tmargin at screen 0.90
#set lmargin at screen 0.266
#set bmargin at screen 0.258
set border lw 1.5

set size ratio RATIO
set xrange [0:1]
set yrange [0:180]
unset xtics
unset ytics
unset k

set palette defined (0 "#fafafa", 0.25 "#2c7bb6", 0.50 "#43aa8b", 0.75 "#f9c74f", 1 "#d7191c")
set pm3d interpolate 3,3 map
unset colorbox
do for [i=1:1] {
  do for [j=1:3:2] {
    set xlabel XLABEL[j] offset 0,1
    set ylabel YLABEL[j] offset -2,0 rotate by 90
    NDX		= 3*(i-1) + j
    f_plot(x)	= (x/ZMAX[NDX]>1?1:x/ZMAX[NDX])
    set term epslatex size 8cm,6cm fontscale 0.75
    set output "figures_ga/add-".HFC[i]."_".ANION[j].".tex"
    splot DATA.HFC[i]."_".ANION[j].".gp.csv" matrix using (($2*10+5)/1000):($1*1.8+0.9):(f_plot($3))
    unset term
    unset output
    replot
  }
}

unset border
unset xtics
unset ytics
unset xlabel
unset ylabel
set colorbox vertical user origin 0.35,0.18 size 0.2,0.6
set cblabel "ADD" offset 2,0 rotate by -90
set cbrange [0:1]
set cbtics 0.2 format "%.1f"
set term epslatex size 3cm,12cm fontscale 0.75
set output "figures_ga/add_colorbar.tex"
splot 0
unset term
unset output
replot

