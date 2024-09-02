#####
# Python-Virtualenvs Widget
#####


# =============================================================================
# Checks if vanilla venv or virtualenv is active
#
# Globals:
#		gets:
#			- VIRTUAL_ENV_PROMPT
# =============================================================================
function mystic_virtualenv_check() {
	[[ -n "${VIRTUAL_ENV_PROMPT}" ]]
}


# =============================================================================
# Checks if a pyenv virtualenv is active
#
# Globals:
#		gets:
#			- PYENV_ACTIVATE_SHELL
# =============================================================================
function mystic_pyenv_check() {
	[[ "${PYENV_ACTIVATE_SHELL}" -eq 1 ]]
}


# =============================================================================
# Checks if any virtualenv is active
# =============================================================================
function mystic_virtualenv_middle_check() {
	mystic_virtualenv_check || mystic_pyenv_check
}


# =============================================================================
# Renders and prints a widget displaying the current virtualenv
#
# Globals:
#		gets:
#			- MYSTIC_MAXLENGTH_PWD
#			- PYENV_VERSION
#			- PYENV_ACTIVATE_SHELL
#			- VIRTUAL_ENV_PROMPT
#			- MYSTIC_COLOR_PUNCTUATION
#			- MYSTIC_COLOR_USERNAME
#			- MYSTIC_COLOR_VIRTUALENV_LOW
#			- MYSTIC_COLOR_VIRTUALENV_HIGH
#			- MYSTIC_GLYPH_LB
#			- MYSTIC_GLYPH_RB
#			- MYSTIC_GLYPH_ELLIPSIS
#
# =============================================================================
function mystic_virtualenv_middle() {

	local output virtualenv virtualenv_name

	virtualenv_name="${VIRTUAL_ENV_PROMPT}${PYENV_VERSION}"

	virtualenv="$(mystic_ellipsify ${MYSTIC_MAXLENGTH_PWD} ${MYSTIC_GLYPH_ELLIPSIS} ${virtualenv_name})"
  virtualenv="$(mystic_style_filter \
								"${MYSTIC_COLOR_VIRTUALENV_LOW}" \
								"${MYSTIC_COLOR_VIRTUALENV_LOW}" \
								"${MYSTIC_COLOR_VIRTUALENV_HIGH}" \
								"${MYSTIC_COLOR_PUNCTUATION}" \
								"${virtualenv}")"

	output=''
	output+="${MYSTIC_COLOR_PUNCTUATION} text ( "
  output+="${virtualenv}"
	output+="${MYSTIC_COLOR_PUNCTUATION} text ) space nnl"

	mystic_echo ${output}
}
