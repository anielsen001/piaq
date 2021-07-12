#!/usr/bin/env julia

using CSV
using DataFrames
using Dates
using TimeZones
#using Plots
#plotly()
using Gaston

log_file_name = ARGS[1]

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
convert from celcius to farenheit
"""
function celcius2farenheit(c)
    c*9/5+32
end


df = CSV.read(log_file_name,
              header=["datetime","eC02","TVOC","PM10","PM25","PM100","SCD30_CO2","SCD30_Temp","SCD30_RH","BMP280_Temp","BMP280_Pres","BMP280_Alt"],
              DataFrame)

# https://stackoverflow.com/questions/64140373/convert-julia-data-frame-column-from-string-to-float
from_zone = tz"America/New_York"
to_zone = tz"America/New_York"
transform!(df, :datetime => ByRow(x -> DateTimeMs(x,from_zone=from_zone,to_zone=to_zone)) => :dt)

plots_to_make = ["datetime","eC02","TVOC","PM10","PM25","PM100","SCD30_CO2","SCD30_Temp","SCD30_RH","BMP280_Temp","BMP280_Pres","BMP280_Alt"]

for ptm in plots_to_make
    plot(df.dt, df[!,ptm],label=ptm);
    savefig(log_file_name * ptm * ".html")
end
