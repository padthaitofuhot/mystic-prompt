#####
# Core
#####


# =============================================================================
# promptly prime all prompt parts into a perfectly perky printed prompt
# =============================================================================
function mystic_evoke_light() {

	set +m

	local output

	output=''

	if [[ MYSTIC_EXITCODE -gt 0 ]]; then
		MYSTIC_COLOR_FRAME=${MYSTIC_COLOR_ERROR_LOW}
	else
		MYSTIC_COLOR_FRAME=${MYSTIC_COLOR_OK_LOW}
	fi

	function mktop() {
		mystic_top_corner
		mystic_top_graph
		mystic_top_time
	}

	function mkmid() {
		local active_git active_virtualenv

		active_virtualenv=$(mystic_check mystic_virtualenv_middle_check)
		active_git=$(mystic_check mystic_git_middle_check)

		if [ "${active_git}" = true ] || [ "${active_virtualenv}" = true ]; then
			mystic_middle_edge
		fi

		if [ "${active_virtualenv}" = true ]; then
			mystic_virtualenv_middle
		fi

		if [ "${active_git}" = true ]; then
			mystic_git_middle
		fi

		if [ "${active_virtualenv}" = true ]; then
			printf "\n"
		fi

		unset active_virtualenv active_git
	}

	function mkbot() {
		mystic_bottom_corner
		mystic_bottom_user
		mystic_echo space ${MYSTIC_COLOR_FRAME} text "${MYSTIC_GLYPH_LINE_H}" space nnl
		mystic_bottom_pwd
		mystic_bottom_input
	}

	if ${MYSTIC_BGRENDER}; then

		local toptmp midtmp bottmp

		toptmp="$(mktemp --suffix '.mystic')"
		midtmp="$(mktemp --suffix '.mystic')"
		bottmp="$(mktemp --suffix '.mystic')"

			function bgfetch() {
				"${1}" > "${2}"
			}

		(
			bgfetch mktop "${toptmp}" &
			bgfetch mkmid "${midtmp}" &
			bgfetch mkbot "${bottmp}" &
			wait
		)

		cat "${toptmp}" "${midtmp}" "${bottmp}"
		rm "${toptmp}" "${midtmp}" "${bottmp}"

	else

		mktop
		mkmid
		mkbot

	fi

	set -m

	return 0
}


function mystic_evoke_prompt() {
	gec
	mystic_update_system_stats
	PS1="$(mystic_evoke_light)"
	mystic_xterm_titlebar "[${USER}@${MYSTIC_HOSTNAME}] $(mystic_ellipsify $(( ${COLUMNS:-40} / 2 )) ${MYSTIC_GLYPH_ELLIPSIS} "$(mystic_pwd)")"
}


# =============================================================================
# Get Exit Code and park it so a plethora of princely prompt parts may partake
# =============================================================================
function gec() {

	MYSTIC_EXITCODE="${?}"

	if [[ ${MYSTIC_EXITCODE} != 0 ]]; then
		MYSTIC_COLOR_FRAME="${MYSTIC_COLOR_ERROR_LOW}"
	else
		MYSTIC_COLOR_FRAME="${MYSTIC_COLOR_OK_LOW}"
	fi
}


### Preparatory Incantations
mystic_graphs_config_platform
mystic_cache_gradients


###
PROMPT_COMMAND=mystic_evoke_prompt
###
