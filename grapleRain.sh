#!/bin/sh
TITLE=$1
OUT=$2

gnuplot<<EOF
set term pdf 
set output "${OUT}.pdf"
set title "Rain intensity Graph"
set grid
set logscale x
set ylabel "Rain intensity [mm/h]"
set xlabel "Cumulative time rate[%]"
plot "${TITLE}"  using 1:2 w linespoints
EOF
