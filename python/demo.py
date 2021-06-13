
import logging
from logging.handlers import TimedRotatingFileHandler

import datetime
import time
import board
 
# import digitalio # For use with SPI
import busio
import adafruit_bmp280
import adafruit_sgp30
import adafruit_scd30

DEBUG=False

if DEBUG:
    my_log_level = logging.DEBUG
else:
    my_log_level = logging.INFO

# create logger for data
datalogger = logging.getLogger('data logger')
datalogger.setLevel(my_log_level)

# create a file handler
fh = TimedRotatingFileHandler("/home/pi/log",when="midnight")
fh.suffix = '%Y-%m-%d_%H-%M-%S.csv'
fh.setLevel(logging.INFO)
# create a formatter
frmt = logging.Formatter('%(message)s') # show only message
fh.setFormatter(frmt)

# add the handler to the logger
datalogger.addHandler(fh)

# create a screen handling for display in case of debugging
if DEBUG:
    sh = logging.StreamHandler()
    sh.setLevel(my_log_level)
    sh.setFormatter(frmt)
    datalogger.addHandler(sh)

# for pm2.5 sensor
import serial
uart = serial.Serial("/dev/ttyS0", baudrate=9600, timeout=0.25)
from adafruit_pm25.uart import PM25_UART
reset_pin = None
pm25 = PM25_UART(uart, reset_pin)

SAMPLE_PERIOD=10.0 # seconds
 
# Create library object using our Bus I2C port
i2c = busio.I2C(board.SCL, board.SDA)

sgp30 = adafruit_sgp30.Adafruit_SGP30(i2c)
bmp280 = adafruit_bmp280.Adafruit_BMP280_I2C(i2c)
scd = adafruit_scd30.SCD30(i2c)
 
# change this to match the location's pressure (hPa) at sea level
bmp280.sea_level_pressure = 1013.25

# must do these first to initialize the sensor
sgp30.iaq_init()
sgp30.set_iaq_baseline(0x8973, 0x8AAE)
 
# write a header into the log file
msgparts = ['# datetime',
            'eC02',
            'TVOC',
            'PM10',
            'PM25',
            'PM100',
            'SCD30_CO2',
            'SCD30_Temp',
            'SCD30_RH',
            'BMP280_Temp',
            'BMP280_Pres',
            'BMP280_Alt']
datalogger.debug(','.join(msgparts))

# sleep before starting to settle
time.sleep(1)

#with open(logfile,'a') as f:
while True:

    try:
        pm25data= pm25.read()

        msgparts = [str(datetime.datetime.now()),
                    str(sgp30.eCO2),
                    str(sgp30.TVOC),
                    str(pm25data["pm10 standard"]),
                    str(pm25data["pm25 standard"]),
                    str(pm25data["pm100 standard"]),
                    str(scd.CO2),
                    str(scd.temperature),
                    str(scd.relative_humidity),
                    str(bmp280.temperature),
                    str(bmp280.pressure),
                    str(bmp280.altitude) ]
        datalogger.info(','.join(msgparts))
    except RuntimeError:
        # this occured when an invalid checksum was received from the PM2.5 sensor
        # we just skip the error and keep going
        pass
    except OSError:
        # this occured when the PM2.5 was not ready 
        # if we get an os error, just skip
        pass

    time.sleep(SAMPLE_PERIOD)

