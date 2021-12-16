from flask import Flask, render_template, Response, request
import sys
import os
import time
import logging
import socket
from subprocess import Popen, PIPE

# name of curent log file
current_log_filename = "/home/pi/log"

# use farenheight or not
use_farenheit = True

app = Flask(__name__)


def get_ip():
    """
    find the primary IP address of the machine we are running on and 
    return as a string
    will return 127.0.0.1 (locahost) if none is found
    """
    # from here:
    # https://stackoverflow.com/questions/166506/finding-local-ip-addresses-using-pythons-stdlib
    
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        # doesn't even have to be reachable
        s.connect(('10.255.255.255', 1))
        IP = s.getsockname()[0]
    except Exception:
        IP = '127.0.0.1'
    finally:
        s.close()
    return IP


def read_last_line(filename):
    """
    read the last line of text from filename
    """
    p = Popen(["tail","-1",filename],shell=False,stderr=PIPE,stdout=PIPE)
    res,err = p.communicate()
    if err:
        return err
    else:
        return res.decode()


def celcius_to_farenheit(c):
    """
    convert a temperature in celcius to farenheit
    """
    return c*9/5+32.0


def make_plots():
    # make the plot
    p = Popen(["gnuplot", "/home/pi/proj/piaq/make_plot.p"])
    res,err = p.communicate()

    # move the plot to templates
    os.rename("/home/pi/log_co2.png", "/home/pi/proj/piaq/app/static/log_co2.png")
    os.rename("/home/pi/log_pm.png", "/home/pi/proj/piaq/app/static/log_pm.png")
    os.rename("/home/pi/log_temp.png", "/home/pi/proj/piaq/app/static/log_temp.png")
    
    if err:
        return err
    else:
        return 0

@app.route("/current")
def current():
    header=["datetime","eC02","TVOC","PM10","PM25","PM100","SCD30_CO2","SCD30_Temp","SCD30_RH","BMP280_Temp","BMP280_Pres","BMP280_Alt"]
    current_sensor_reading = read_last_line(current_log_filename).split(',')

    readings = dict(zip(header,current_sensor_reading))
    
    return readings

@app.route("/")
def main():
    header=["datetime","eC02","TVOC","PM10","PM25","PM100","SCD30_CO2","SCD30_Temp","SCD30_RH","BMP280_Temp","BMP280_Pres","BMP280_Alt"]
    current_sensor_reading = read_last_line(current_log_filename).split(',')

    readings = dict(zip(header,current_sensor_reading))

    if use_farenheit:
        temp_keys = ["SCD30_Temp", "BMP280_Temp"]
        for tk in temp_keys:
            readings[tk] = celcius_to_farenheit(float(readings[tk]))

    make_plots()
    
    return render_template("main.html",readings=readings)


if __name__ == "__main__":
    app.run(host=get_ip(), port=5342)
