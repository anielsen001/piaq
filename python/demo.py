
import logging

import datetime
import time
import board
 
# import digitalio # For use with SPI
import busio
import adafruit_bmp280
import adafruit_sgp30
import adafruit_scd30

# create logger for data
datalogger = logging.getLogger('data logger')
datalogger.setLevel(logging.DEBUG)
# create a file handler
fh = logging.FileHandler("/home/pi/log.csv")
fh.setLevel(logging.DEBUG)
# create a formatter
frmt = logging.Formatter('%(message)') # show only message
fh.setFormatter(frmt)

# add the handler t the logger
datalogger.addHandler(fh)

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
log.info(','.join(msgparts))

"""
logfile = "/home/pi/log.csv"
with open(logfile,'a') as f:
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
    #print( ','.join(msgparts))
    f.write(','.join(msgparts) + '\n')
"""

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

        #print( ', '.join(msgparts))
        log.info(','.join(msgparts))
    except RuntimeError:
        # this occured when an invalid checksum was received from the PM2.5 sensor
        # we just skip the error and keep going
        pass
    except OSError:
        # this occured when the PM2.5 was not ready 
        # if we get an os error, just skip
        pass

    #print("\nTemperature: %0.1f C" % bmp280.temperature)
    #print("Pressure: %0.1f hPa" % bmp280.pressure)
    #print("Altitude = %0.2f meters" % bmp280.altitude)

    #print("CO2:", scd.CO2, "PPM")
    #print("Temperature:", scd.temperature, "degrees C")
    #print("Humidity:", scd.relative_humidity, "%%rH")   

    #print("eCO2 = %d ppm \t TVOC = %d ppb" % (sgp30.eCO2, sgp30.TVOC))

    time.sleep(SAMPLE_PERIOD)

