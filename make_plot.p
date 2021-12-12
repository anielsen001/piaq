set datafile separator ","
set timefmt "%Y-%m-%d %H:%M:%S"
set xdata time
set format x "%H:%M"
set title "CO2"
set xlabel "time"
set ylabel "PPM"
set grid
set term png
set xtics out rotate by -80
set output '/home/pi/log_co2.png'
plot '/home/pi/log' using 1:7 notitle

set output '/home/pi/log_pm.png'
set title "PM"
set ylabel "Count"
plot '/home/pi/log' using 1:6 title "PM 10.0",\
'/home/pi/log' using 1:5 title "PM 2.5",\
'/home/pi/log' using 1:4 title "PM 1.0"

set output '/home/pi/log_temp.png'
set title "Temperature"
set ylabel "Degrees"
plot '/home/pi/log' using 1:8 notitle
