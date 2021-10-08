#####
# Weather
#####

# So my friend Violet showed me this way to get weather data ....

MYSTIC_WEATHER_LOCATION=48912
MYSTIC_WEATHER_UNITS=F

function weather() {
	curl -s "https://wttr.in/${MYSTIC_WEATHER_LOCATION}?${MYSTIC_WEATHER_UNITS}"
}

# Which one could maybe make a weather widget out of?

# It's slow, and hammering on this free service seems cruel.
# Perhaps it an be cached in the background every 15 minutes or so.

function weather-bar() {
	local wb
	wb="$(curl -s "https://wttr.in/${MYSTIC_WEATHER_LOCATION}?${MYSTIC_WEATHER_UNITS}&format=1")"
	printf '[%s]' "${wb}"
}

