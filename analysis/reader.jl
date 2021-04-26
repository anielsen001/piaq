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

dateformat= DateFormat("Y-m-d H:M:S.sss")

function DateTimeMs(usstr)
    DateTime(astimezone(ZonedDateTime(DateTime(SubString(usstr,1,length(usstr)-3),dateformat),tz"UTC"),tz"UTC-5"))
end

function celcius2farenheit(c)
    c*9/5+32
end
         
df = CSV.read("log.csv",
              header=["datetime","eC02","TVOC","PM25","SCD30_CO2","SCD30_Temp","SCD30_RH","BMP280_Temp","BMP280_Pres","BMP280_Alt"],
              DataFrame)

# https://stackoverflow.com/questions/64140373/convert-julia-data-frame-column-from-string-to-float
transform!(df, :datetime => ByRow(x -> DateTimeMs(x)) => :dt)

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
