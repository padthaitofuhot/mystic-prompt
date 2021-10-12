#===============================================================================
MYSTIC_VERSION="0.0.5i7"
#===============================================================================
#
#    A responsive semantic bash prompt in the style of MysticBBS software.
#    Copyright (C) 2021 Travis Wichert
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
#===============================================================================

if [[ "${BASH_VERSINFO:-0}" -lt 4 ]]; then
	printf '%s\n' "MysticPrompt requires BASH 4.x+"
	exit 1
fi

MYSTIC_BASH="$0"
MYSTIC_HOSTNAME="$(hostname -s)"

# This is necessary to avoid deforming the prompt when using up/down keys
shopt -s checkwinsize

