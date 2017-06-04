# After executing drunk_sim run with:
#  gnuplot -p drunk_plot.gp

set terminal qt
set title 'Mean Distance from Origin (100 trials)'

set xlabel 'Number of Steps'
set ylabel 'Distance from Origin'

set style line 1 lc rgb '#ff00ff' lt 1 lw 2
set style line 2 lc rgb '#0000ff' lt 1 lw 2 dt 2

set key top left reverse Left box height 0.5
plot 'plotting-means.dat' index 0 with lines title 'Usual Drunk' ls 1, \
     '' index 1 with lines title 'Cold Drunk' ls 2
