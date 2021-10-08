#===============================================================================
MYSTIC_VERSION="0.0.5i7"
#===============================================================================
#
#    Copyright 2021 Travis Wichert <padthaitofuhot@users.noreply.github.com>
#

#@todo license goes here

#===============================================================================

if [[ "${BASH_VERSINFO:-0}" -lt 4 ]]; then
	printf '%s\n' "MysticPrompt requires BASH 4.x+"
	exit 1
fi

MYSTIC_BASH="$0"
MYSTIC_HOSTNAME="$(hostname -s)"

# This is necessary to avoid deforming the prompt when using up/down keys
shopt -s checkwinsize

