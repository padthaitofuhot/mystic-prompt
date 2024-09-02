#####
# Weather widget
#####

# So my friend Violet showed me this way to get weather data ....

MYSTIC_WEATHER_LOCATION="48912"
MYSTIC_WEATHER_UNITS=F

function mystic_get_weather() {
	MYSTIC_WEATHER_CACHE="$(curl -s "https://wttr.in/${MYSTIC_WEATHER_LOCATION}?${MYSTIC_WEATHER_UNITS}&format=2" | sed -e 's/[[:space:]]\+/ /g')"
	export MYSTIC_WEATHER_CACHE
}

function mystic_weather_bar() {
	local output
	output=$MYSTIC_WEATHER_CACHE
	printf '[%s]' "${wb}"
}

