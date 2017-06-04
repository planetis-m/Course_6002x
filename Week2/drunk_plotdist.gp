# After executing drunk_sim run with:
#  gnuplot -p drunk_plotdist.gp

set title 'Location at End of Walks (10000 steps)'
set xlabel 'Steps East/West of Origin'
set ylabel 'Steps North/South of Origin'

set xrange [-1000: 1000]
set yrange [-1000: 1000]

set style line 1 lc rgb 'black' pt 16
set style line 2 lc rgb 'red' pt 9

set key top left reverse Left box height 0.5
plot 'plotting-locations.dat' index 0 with points title 'Usual Drunk' ls 1, \
     '' index 1 with points title 'Cold Drunk' ls 2
