using CSV
using DataFrames
using Dates
using TimeZones
using PyPlot

# this is the header that's not present in the file
#datetime,eC02,TVOC,PM25,SCD30_CO2,SCD30_Temp,SCD30_RH,BMP280_Temp,BMP280_Pres,BMP280_Alt

# for a variety of reasons, it seems that Juila's DateTime cannot
# parse more than milliseconds, see
# https://github.com/JuliaLang/julia/issues/31525
# https://discourse.julialang.org/t/dates-datetime-parse-string-with-microseconds-decimal-6-places/25653

# the default pi timezone is BST (British summer time)
# changed to US/Eastern in Early map
filename = "2021-04-09-log.csv"
filename = "log.2021-07-04_00-00-00.csv"

dateformat= DateFormat("Y-m-d H:M:S.sss")

"""
Take a datetime string with microsecond precision, such as 
2021-07-04 00:00:03.912410,
convert to milliseconds to work with julia's time mechanisms and 
convert from UTC to Eastern Timezone.

"""
function DateTimeMs(usstr; from_zone=tz"UTC", to_zone=tz"UTC-5")
    DateTime(astimezone(ZonedDateTime(DateTime(SubString(usstr,1,length(usstr)-3),dateformat),from_zone),to_zone))
end


"""
convert from celcisu to farenheit
"""
function celcius2farenheit(c)
    c*9/5+32
end
         
df = CSV.read(filename,
              header=["datetime","eC02","TVOC","PM10","PM25","PM100","SCD30_CO2","SCD30_Temp","SCD30_RH","BMP280_Temp","BMP280_Pres","BMP280_Alt"],
              DataFrame)

# https://stackoverflow.com/questions/64140373/convert-julia-data-frame-column-from-string-to-float
from_zone = tz"America/New_York"
to_zone = tz"America/New_York"
transform!(df, :datetime => ByRow(x -> DateTimeMs(x,from_zone=from_zone,to_zone=to_zone)) => :dt)

figure()
plot(df.dt, df.SCD30_CO2,label="SCD30")
grid()
gcf().autofmt_xdate()
title("CO2 (ppm)")
ylabel("CO2 (ppm)")
xlabel("Time")

figure()
plot(df.dt, df.PM25,label="PM2.5")
grid()
gcf().autofmt_xdate()
title("pm2.5 count")
ylabel("pm2.5 count")
xlabel("Time")

figure()
plot(df.dt, celcius2farenheit.(df.SCD30_Temp), label="SCD30")
grid()
gcf().autofmt_xdate()
title("Temperature")
ylabel("Temperature")
xlabel("Time")

figure()
plot(df.dt,df.SCD30_RH, label="SCD30")
grid()
gcf().autofmt_xdate()
title("Relative Humidity")
ylabel("Relative Humidity")
xlabel("Time")


figure()
plot(df.dt,df.TVOC)
grid()
gcf().autofmt_xdate()
title("VOCs")
ylabel("Total VOC")
xlabel("Time")

figure()
plot(df.dt,df.eC02)
grid()
gcf().autofmt_xdate()
title("eCO2")
ylabel("eCO2")
xlabel("Time")
