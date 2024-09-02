#####
# A small collection of utility functions
#####


# =============================================================================
# Return true if shelled out from Midnight Commander
# =============================================================================
function in_midnight_commander() {
	if [[ -n "${MC_SID}${MC_TMPDIR}" ]]; then
		return 0
	else
		return 1
	fi
}


# =============================================================================
# Return true if shelled out from Ranger
# =============================================================================
function in_ranger() {
	if [[ -n "${RANGER_LEVEL}" ]]; then
		return 0
	else
		return 1
	fi
}


# =============================================================================
# Small debugging utility to display a list of variables and their contents
#
# Arguments:
# 	str	${@} as list of variables to display
# =============================================================================
function mystic_ckv() {
	local arg

	printf '%s\n' "$(mystic_fill 40 "-")" >&2

	for arg in "${@}"; do

		echo -n "${arg}: " >&2
		echo "${!arg}" >&2

	done

	printf '%s\n' "$(mystic_fill 40 "-")" >&2
}
# Uncomment for short alias
# ckv() { mystic_ckv $@; }


# =============================================================================
# Abstracts fetching a boolean "value" for check commands
# =============================================================================
function mystic_check() {
	# shellcheck disable=SC2068
	if ${@}; then
		echo "true"
	else
		echo "false"
	fi
}
