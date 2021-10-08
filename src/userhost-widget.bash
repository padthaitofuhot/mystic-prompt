#####
# User@Host Widget
#####


# =============================================================================
# Renders and prints a "user@host" widget
#
# Globals:
#		gets:
#			USER
#			MYSTIC_HOSTNAME
#			MYSTIC_COLOR_PUNCTUATION
#			MYSTIC_BGCOLOR_USERNAME
#			MYSTIC_COLOR_USERNAME
#			MYSTIC_COLOR_HOSTNAME
#			MYSTIC_GLYPH_LB
#			MYSTIC_GLYPH_RB
#			MYSTIC_GLYPH_AT
#
# =============================================================================
function mystic_bottom_user() {

	local output

	output=''

	output+="${MYSTIC_COLOR_PUNCTUATION} text ${MYSTIC_GLYPH_LB} "

	if [[ "${UID}" -eq 0 ]]; then
		output+="${MYSTIC_COLOR_ROOT_USERNAME} text ${USER} reset "
	else
		output+="${MYSTIC_COLOR_USERNAME} text ${USER} reset "
	fi

	output+="${MYSTIC_COLOR_PUNCTUATION} text ${MYSTIC_GLYPH_AT} "
	output+="${MYSTIC_COLOR_HOSTNAME} text ${MYSTIC_HOSTNAME} "
	output+="${MYSTIC_COLOR_PUNCTUATION} text ${MYSTIC_GLYPH_RB} nnl"

	mystic_echo ${output}
}

