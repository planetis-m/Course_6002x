# After executing drunk_sim run with:
#  gnuplot -p drunk_plottrace.gp

set title 'Spots Visited on Walk (500 steps)'
set xlabel 'Steps East/West of Origin'
set ylabel 'Steps North/South of Origin'

set style line 1 lc rgb 'blue' pt 16
set style line 2 lc rgb 'red' pt 9

set key top left reverse Left box height 0.5
plot 'plotting-tracewalk.dat' index 0 with points title 'Field' ls 1, \
     '' index 1 with points title 'OddField' ls 2
