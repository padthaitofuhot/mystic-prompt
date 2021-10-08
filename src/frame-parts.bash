#####
# Frame pieces and parts
#####


# =============================================================================
# Renders and prints top-left-corner with subshell indicators for a few popular
# programs that can "shell out".
#
# Globals:
#		gets:
#			MYSTIC_EXITCODE
#			MYSTIC_COLOR_ERROR_MID
#			MYSTIC_COLOR_OK_MID
#			MYSTIC_GLYPH_LINE_V
#
# =============================================================================
function mystic_top_corner() {

	local output

	output=''

	if [[ MYSTIC_EXITCODE -gt 0 ]]; then

	# @TODO: refactor. this will get bonkers as more outshells are added.
		if in_midnight_commander; then
			# mc────
			output+="${MYSTIC_COLOR_MC} text ${MYSTIC_GLYPH_MC} "
			output+="${MYSTIC_COLOR_ERROR_MID} text $(mystic_fill 2 ${MYSTIC_GLYPH_LINE_H}) "
			output+="${MYSTIC_COLOR_ERROR_LOW} text $(mystic_fill 2 ${MYSTIC_GLYPH_LINE_H}) "

		elif in_ranger; then
			# ra----
			output+="${MYSTIC_COLOR_RANGER} text ${MYSTIC_GLYPH_RANGER} "
			output+="${MYSTIC_COLOR_ERROR_MID} text $(mystic_fill 2 ${MYSTIC_GLYPH_LINE_H}) "
			output+="${MYSTIC_COLOR_ERROR_LOW} text $(mystic_fill 2 ${MYSTIC_GLYPH_LINE_H}) "

		else

			# ┌─────
			# .-----
			output+="${MYSTIC_COLOR_ERROR_HIGH} text ${MYSTIC_GLYPH_CORNER_TL} "
			output+="${MYSTIC_COLOR_ERROR_HIGH} text ${MYSTIC_GLYPH_LINE_H} "
			output+="${MYSTIC_COLOR_ERROR_MID} text $(mystic_fill 2 ${MYSTIC_GLYPH_LINE_H}) "
			output+="${MYSTIC_COLOR_ERROR_LOW} text $(mystic_fill 2 ${MYSTIC_GLYPH_LINE_H}) "

		fi

	else

		# mc-
		if in_midnight_commander; then

			output+="${MYSTIC_COLOR_MC} text ${MYSTIC_GLYPH_MC} "
			output+="${MYSTIC_COLOR_OK_LOW} text ${MYSTIC_GLYPH_LINE_H} "

		# ra─
		elif in_ranger; then

			output+="${MYSTIC_COLOR_RANGER} text ${MYSTIC_GLYPH_RANGER} "
			output+="${MYSTIC_COLOR_OK_LOW} text ${MYSTIC_GLYPH_LINE_H} "

		else

			# ┌──
			# .--
			output+="${MYSTIC_COLOR_OK_HIGH} text ${MYSTIC_GLYPH_CORNER_TL} "
			output+="${MYSTIC_COLOR_OK_MID} text ${MYSTIC_GLYPH_LINE_H} "
			output+="${MYSTIC_COLOR_OK_LOW} text ${MYSTIC_GLYPH_LINE_H} "

		fi

	fi

	mystic_echo ${output} nnl
}


# =============================================================================
# Renders and prints the middle git widget
#
# Globals:
#		gets:
#			MYSTIC_EXITCODE
#			MYSTIC_COLOR_ERROR_MID
#			MYSTIC_COLOR_OK_MID
#			MYSTIC_GLYPH_LINE_V
#
# =============================================================================
function mystic_middle_edge() {

	local output

	output=''

	if [[ MYSTIC_EXITCODE -gt 0 ]]; then
		output+="${MYSTIC_COLOR_ERROR_MID} text ${MYSTIC_GLYPH_LINE_V} "
	else
		output+="${MYSTIC_COLOR_OK_MID} text ${MYSTIC_GLYPH_LINE_V}"
	fi

	mystic_echo ${output} space nnl
}


# =============================================================================
# Renders and prints the bottom-left corner
#
# Globals:
#		gets:
#			MYSTIC_EXITCODE
#			MYSTIC_COLOR_EXITCODE
#			MYSTIC_COLOR_ERROR_MID
#			MYSTIC_COLOR_OK_MID
#			MYSTIC_COLOR_OK_LOW
#			MYSTIC_GLYPH_CORNER_BL
#			MYSTIC_GLYPH_LINE_H
#
# =============================================================================
function mystic_bottom_corner() {

	local output

	output=''

	if [[ MYSTIC_EXITCODE -gt 0 ]]; then
		output+="${MYSTIC_COLOR_ERROR_MID} text ${MYSTIC_GLYPH_CORNER_BL} space nnl "
		output+="${MYSTIC_COLOR_EXITCODE} text $( printf '%.03d' "${MYSTIC_EXITCODE}") space nnl"
	else
		output+="${MYSTIC_COLOR_OK_MID} text ${MYSTIC_GLYPH_CORNER_BL} "
		output+="${MYSTIC_COLOR_OK_LOW} text ${MYSTIC_GLYPH_LINE_H} space nnl"
	fi
	mystic_echo ${output}
}

