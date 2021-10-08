#####
# Input pip widget
#####


# =============================================================================#
# Renders and prints the input pip section of the prompt
#
# Globals:
# 	get:
#			MYSTIC_COLOR_INPUT
#			MYSTIC_COLOR_ROOT_INPUT
#			MYSTIC_GLYPH_INPUT
#			MYSTIC_GLYPH_ROOT_INPUT
#
# =============================================================================
function mystic_bottom_input() {

	local output

	output=''

	if [[ "${UID}" -eq 0 ]]; then
		output+="$(mystic_echo ${MYSTIC_COLOR_ROOT_INPUT} text "${MYSTIC_GLYPH_ROOT_INPUT}" nnl)"
	else
		output+="$(mystic_echo ${MYSTIC_COLOR_INPUT} text "${MYSTIC_GLYPH_INPUT}" nnl)"
	fi

	printf '%s' "${output}"
}
