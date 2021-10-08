#####
# Clock widget
#####


# =============================================================================
# Renders and prints a clock widget.
#
#	·[Sun·30·02:30]·
#	-[Sun-30-02:30]-
#
# Globals:
#		gets:
#			MYSTIC_COLOR_FRAME
#			MYSTIC_COLOR_PUNCTUATION
#			MYSTIC_COLOR_DAYNAME
#			MYSTIC_COLOR_DATE
#			MYSTIC_COLOR_TIME
#			MYSTIC_GLYPH_TIMESEP
#			MYSTIC_GLYPH_LB
#			MYSTIC_GLYPH_RB
#			MYSTIC_GLYPH_SPACER
#
# =============================================================================
function mystic_top_time() {

	local output
	local a d H M

	output=''
	a=$(date '+%a')
	d=$(date '+%d')
	H=$(date '+%H')
	M=$(date '+%M')

	# -
	output+="${MYSTIC_COLOR_FRAME} text ${MYSTIC_GLYPH_SPACER} "
	# [
	output+="${MYSTIC_COLOR_PUNCTUATION} text ${MYSTIC_GLYPH_LB} "
	# Sun
	output+="${MYSTIC_COLOR_DAYNAME} text ${a} "
	# -
	output+="${MYSTIC_COLOR_PUNCTUATION} text ${MYSTIC_GLYPH_SPACER} "
	# 30
	output+="${MYSTIC_COLOR_DATE} text ${d} "
	# -
	output+="${MYSTIC_COLOR_PUNCTUATION} text ${MYSTIC_GLYPH_SPACER} "
	# 02
	output+="${MYSTIC_COLOR_TIME} text ${H} "
	# :
	output+="${MYSTIC_COLOR_PUNCTUATION} text ${MYSTIC_GLYPH_TIMESEP} "
	# 30
	output+="${MYSTIC_COLOR_TIME} text ${M} "
	# ]
	output+="${MYSTIC_COLOR_PUNCTUATION} text ${MYSTIC_GLYPH_RB} "
	# -
	output+="${MYSTIC_COLOR_FRAME} text ${MYSTIC_GLYPH_SPACER} "

	mystic_echo ${output}
}

