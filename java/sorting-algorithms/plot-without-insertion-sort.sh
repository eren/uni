#!/bin/sh

gnuplot -p << EOF

# gnuplot script to generate graph.
set title "Sorting Algorithms Comprasion" font "Helvatica Bold,20"
set xlabel "Number of Random Elements" font "Times-Roman Bold"
set ylabel "Time to Sort (in milliseconds)" font "Times-Roman Bold"
#set size ratio 0.5

set xtic auto
set ytic auto

#set xr[100:26214400]
#set yr[0:13482]

plot "$1" using 1:2 title "QuickSort" smooth csplines with lines, \
"$1" using 1:3 title "MergeSort" smooth csplines with lines, \
"$1" using 1:4 title "Cormen MergeSort" smooth csplines with lines

EOF

