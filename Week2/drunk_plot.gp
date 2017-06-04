# After executing drunk_sim run with:
#  gnuplot -p drunk_plot.gp

set terminal qt
set xlabel 'Number of Steps'
set ylabel 'Distance from Origin'

set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 7 ps 1.5
set style line 2 lc rgb '#dd181f' lt 1 lw 2 pt 5 ps 1.5

plot 'plotting-means.dat' index 0 with linespoints title 'Usual Drunk' ls 1, \
     '' index 1 with linespoints title 'Cold Drunk' ls 2
