[BotwV208]
moduleMatches = 0x6267BFD0

.origin = codecave

_BOTW_WeatherForecast_ToWeathers:
.int $WFData0
.int $WFData1
.int $WFData2

_BOTW_WeatherForecast_ReplaceWeather:
lis r6, _BOTW_WeatherForecast_ToWeathers@ha
addi r6, r6, _BOTW_WeatherForecast_ToWeathers@l
lbzx r26, r6, r26
stb r26, 0x18(r30)
blr

0x03668FEC = bla _BOTW_WeatherForecast_ReplaceWeather # Update weather area [stb r26, +0x18(r30)]