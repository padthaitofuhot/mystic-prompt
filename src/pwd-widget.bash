#####
# PWD widget
#####


# =============================================================================
# Print $PWD.  If $PWD is child of $HOME then print relative to tilde (~).
# =============================================================================
function mystic_pwd() {

	local output

	output="${PWD}"

	if [[ "${output}" =~ (^${HOME})(.*) ]]; then
		output="~${BASH_REMATCH[2]}"
	fi

	printf '%s\n' "${output}"
}


# =============================================================================#
# Renders and prints a PWD widget
#
# Globals:
# 	get:
#			MYSTIC_COLOR_PUNCTUATION
#			MYSTIC_COLOR_PATH_PWD
#			MYSTIC_COLOR_PATH_PATH
#			MYSTIC_GLYPH_LB
#			MYSTIC_GLYPH_RB
#			MYSTIC_GLYPH_ELLIPSIS
#			MYSTIC_GLYPH_SLASH
#
# =============================================================================
function mystic_bottom_pwd() {

	local output fullpath

	output=''
	fullpath="$(mystic_ellipsify ${MYSTIC_MAXLENGTH_PWD} ${MYSTIC_GLYPH_ELLIPSIS} $(mystic_pwd))"

	output+="${MYSTIC_COLOR_PUNCTUATION} text ${MYSTIC_GLYPH_LB} "

	if [[ "${#fullpath}" -eq 1 ]]; then

		output+="${MYSTIC_COLOR_PATH_PWD} ${fullpath} "

	else

		output+="$(mystic_style_filter \
							"${MYSTIC_COLOR_PATH_PATH}" \
							"${MYSTIC_COLOR_PATH_PATH}" \
							"${MYSTIC_COLOR_PATH_PATH}" \
							"${MYSTIC_COLOR_PUNCTUATION}" \
							"${fullpath%/*}/") "

		output+="${MYSTIC_COLOR_PATH_PWD} ${fullpath##*/} "

	fi

	output+="${MYSTIC_COLOR_PUNCTUATION} text ${MYSTIC_GLYPH_RB} "

	mystic_echo ${output} nnl
}
