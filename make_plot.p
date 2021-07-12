set datafile separator ","
set timefmt "%Y-%m-%d %H:%M:%S"
set xdata time
set format x "%H:%M"
set title "CO2"
set xlabel "time"
set ylabel "PPM"
set grid
set term png
set output 'log_co2.png'
plot 'log' using 0:7