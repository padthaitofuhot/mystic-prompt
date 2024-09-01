#####
#
# Mystic TermLib v1.1.1
# A fast, light, and fluenty bash library for using terminal escape sequences.
#
# This program is free software: you can redistribute it and/or modify it under the terms of the
# GNU General Public License as published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program.
# If not, see <https://www.gnu.org/licenses/>.
#####

#####
# This is a blend of VTx, ANSI, and non-standard escape sequences for controlling terminal
# colors, cursor movement, xterm window headers, and more.  It is set up to be used with bash's
# PROMPT_COMMAND= environment variable (see MYSTIC_PC_START and _STOP), meaning it encapsulates
# escape sequences in bytes which prevent bash from counting escape sequence bytes as readable
# characters for the purposes of knowing a prompt's line length, which prevents issues with
# line editing, for example backspacing over the prompt.
#
# It is assumed these are generally available for any "modern" terminals,
# including some tty devices.  If your daily-driver terminal chokes on these,
# please file a github issue.
#
# This library likely has bugs and is incomplete.  Your PR can help improve it.
#
# References:
#			https://en.wikipedia.org/wiki/ANSI_escape_code
#
#####

# Prefix and suffix for PROMPT_COMMAND
MYSTIC_PC_START='\x01'
MYSTIC_PC_STOP='\x02'
# You can clear these if not used in PROMPT_COMMAND
#MYSTIC_PC_START=
#MYSTIC_PC_STOP=

# Terminal Control Codes
MYSTIC_TC_ESC="\x1b"
MYSTIC_TC_BELL="\a"
MYSTIC_TC_NEWLINE="\n"
MYSTIC_TC_BACKSPACE="\b"
MYSTIC_TC_HTAB="\t"
MYSTIC_TC_VTAB="\v"
MYSTIC_TC_FORMFEED="\f"
MYSTIC_TC_RETURN="\r"
MYSTIC_TC_CLEAR_AFTER="${MYSTIC_TC_ESC}[0K"
MYSTIC_TC_CLEAR_BEFORE="${MYSTIC_TC_ESC}[1K"
MYSTIC_TC_CLEAR_LINE="${MYSTIC_TC_ESC}[2K"
MYSTIC_TC_SCREEN_SAVE="${MYSTIC_TC_ESC}[?47h"
MYSTIC_TC_SCREEN_LOAD="${MYSTIC_TC_ESC}[?47l"
MYSTIC_TC_SCREEN_CLEAR="${MYSTIC_TC_ESC}[2J"
MYSTIC_TC_SAVE_CURSOR="${MYSTIC_TC_ESC}7"
MYSTIC_TC_LOAD_CURSOR="${MYSTIC_TC_ESC}8"

# Terminal Attribute Codes
MYSTIC_AT_BOLD="${MYSTIC_TC_ESC}[1m"
MYSTIC_AT_FAINT="${MYSTIC_TC_ESC}[2m"
MYSTIC_AT_ITALIC="${MYSTIC_TC_ESC}[3m"
MYSTIC_AT_UNDERLINE="${MYSTIC_TC_ESC}[4m"
MYSTIC_AT_BLINK="${MYSTIC_TC_ESC}[5m"
MYSTIC_AT_INVERSE="${MYSTIC_TC_ESC}[7m"
MYSTIC_AT_STRIKETHROUGH="${MYSTIC_TC_ESC}[9m"
MYSTIC_AT_DOUBLE_UNDERLINE="${MYSTIC_TC_ESC}[21m"
# includes some non-standard reset sequences for known attributes, such as double-underline
MYSTIC_AT_RESET="${MYSTIC_TC_ESC}[0m${MYSTIC_TC_ESC}[22m${MYSTIC_TC_ESC}[24m"

## Color stuff
MYSTIC_COLOR_PREFIX="${MYSTIC_PC_START}${MYSTIC_TC_ESC}["
MYSTIC_COLOR_SUFFIX="m${MYSTIC_PC_STOP}"

# ANSI 16-color Forground
MYSTIC_FG_BLACK=30
MYSTIC_FG_RED=31
MYSTIC_FG_GREEN=32
MYSTIC_FG_YELLOW=33
MYSTIC_FG_BLUE=34
MYSTIC_FG_MAGENTA=35
MYSTIC_FG_CYAN=36
MYSTIC_FG_WHITE=37

# ANSI 16-color Background
MYSTIC_BG_BLACK=40
MYSTIC_BG_RED=41
MYSTIC_BG_GREEN=42
MYSTIC_BG_YELLOW=43
MYSTIC_BG_BLUE=44
MYSTIC_BG_MAGENTA=45
MYSTIC_BG_CYAN=46
MYSTIC_BG_WHITE=47

# =============================================================================
# Set the XTerm titlebar text
#
# Arguments:
# 	str	"text"		puts provided text into titlebar
#
# =============================================================================
function mystic_xterm_titlebar() {
	printf '\033]0;%s\007' "${*}"
}

# =============================================================================
# Attempt to sweet talk terminal into supporting unicode
# =============================================================================
function mystic_setup_unicode() {
	# Available on some Linux
	if hash unicode_start 2>/dev/null; then
		unicode_start
	else
		# Limited fallback, does not work well with *BSD
		printf '\033%%G'
	fi
}

# =============================================================================
# Rings the terminal bell (maybe)
#
# Effects vary from blinking and beeping to
# playing audio files and doing nothing.
#
# This is broken in many terminals, but maybe it'll work for you.
# =============================================================================
mystic_bell() {
	printf '%s' "${MYSTIC_TC_BELL}"
}

# =============================================================================
# Tells the terminal to report its rows and cols into variables.
# Should be implied by 'shopt -s checkwinsize' but it's here in case.
# =============================================================================
mystic_update_termsize() {
	MYSTIC_ROWS="$(tput lines)"
	MYSTIC_COLS="$(tput cols)"
	export MYSTIC_ROWS MYSTIC_COLS
}

# =============================================================================
# Prints a string one or more times contiguously
#
# Arguments:
#		int count			repeat count
#		str "text"			text to repeat
#
# Examples:
#
#		mystic_fill 10 '#'
#		##########
#
#		mystic_fill 5 '-='
#		-=-=-=-=-=
#
# =============================================================================
function mystic_fill() {
	# shellcheck disable=SC2183
	printf -v fill '%*s' "${1}"
	printf '%s' "${fill// /${2}}"
}

# =============================================================================
# Moves the cursor around, handles tabs and line clearing, and saves to and
# loads from the terminal buffer.
#
# Arguments:
#		A list of commands as positional arguments.
#
# Usage:
#   mystic_cursor <command(s)>
#         mcursor <command(s)>
#
# =============================================================================
mystic_cursor() {
	local _print
	local _pos _row _col
	local _nl
	local _reset=true

	_nl="${MYSTIC_TC_NEWLINE}"

	while (($# > 0)); do
		case "$1" in
			text)
				# Quote "your text" to avoid splitting
				shift
				_print+="${1}"
				;;
			up)
				# Notes about up, down, right, left, and move/home:
				#
				# If an integer argument is provided to the command, then its value will be used.
				# Otherwise, the cursor will move one character in the direction indicated by
				# the command.
				#
				# In the case of move/home, if integer argument is not provided then the
				# cursor will move to position 1,1, which is the top-left corner of the terminal.
				_pos=1
				[[ $2 == ?(-)+([0-9]) ]] && _pos=$2 && shift
				_print+="${MYSTIC_PC_START}${MYSTIC_TC_ESC}[${_pos}A${MYSTIC_PC_STOP}"
				;;
			down | dn)
				_pos=1
				[[ $2 == ?(-)+([0-9]) ]] && _pos=$2 && shift
				_print+="${MYSTIC_PC_START}${MYSTIC_TC_ESC}[${_pos}B${MYSTIC_PC_STOP}"
				;;
			right | rt)
				_pos=1
				[[ $2 == ?(-)+([0-9]) ]] && _pos=$2 && shift
				_print+="${MYSTIC_PC_START}${MYSTIC_TC_ESC}[${_pos}C${MYSTIC_PC_STOP}"
				;;
			left | lt)
				_pos=1
				[[ $2 == ?(-)+([0-9]) ]] && _pos=$2 && shift
				_print+="${MYSTIC_PC_START}${MYSTIC_TC_ESC}[${_pos}D${MYSTIC_PC_STOP}"
				;;
			move | home | mv)
				_row=1
				_col=1
				[[ $2 == ?(-)+([0-9]) ]] && _row=$2 && shift
				[[ $2 == ?(-)+([0-9]) ]] && _col=$2 && shift
				_print+="${MYSTIC_PC_START}${MYSTIC_TC_ESC}[${_row:-1};${_col:-1}H${MYSTIC_PC_STOP}"
				;;
			newline | nl | linefeed | lf)
				_print+="${MYSTIC_TC_NEWLINE}"
				;;
			backspace | bs)
				_print+="${MYSTIC_TC_BACKSPACE}"
				;;
			htab)
				_print+="${MYSTIC_TC_HTAB}"
				;;
			vtab)
				_print+="${MYSTIC_TC_VTAB}"
				;;
			formfeed | ff)
				_print+="${MYSTIC_TC_FORMFEED}"
				;;
			return | cr)
				_print+="${MYSTIC_TC_RETURN}"
				;;
			save)
				# Notes about save and load:
				#
				# The terminal has a second buffer into which bytes can be written and
				# read.  Save and load write the terminal contents into the buffer and
				# restore it to the terminal accordingly.
				#
				# If you have exited from `less`, `vim`, or any other terminal app which
				# returns the terminal contents as they were before the app was run,
				# you will have seen the behavior of save and load.
				_print+="${MYSTIC_PC_START}${MYSTIC_TC_SCREEN_SAVE}${MYSTIC_PC_STOP}"
				;;
			load)
				_print+="${MYSTIC_PC_START}${MYSTIC_TC_SCREEN_LOAD}${MYSTIC_PC_STOP}"
				;;
			clearline | cl)
				_print+="${MYSTIC_PC_START}${MYSTIC_TC_CLEAR_LINE}${MYSTIC_PC_STOP}"
				;;
			clearbefore | cb)
				_print+="${MYSTIC_PC_START}${MYSTIC_TC_CLEAR_BEFORE}${MYSTIC_PC_STOP}"
				;;
			clearafter | ca)
				_print+="${MYSTIC_PC_START}${MYSTIC_TC_CLEAR_AFTER}${MYSTIC_PC_STOP}"
				;;
			clearscreen | clear | cls)
				_print+="${MYSTIC_PC_START}${MYSTIC_TC_SCREEN_CLEAR}${MYSTIC_PC_STOP}"
				;;
			savecursor | sc)
				_print+="${MYSTIC_PC_START}${MYSTIC_TC_SAVE_CURSOR}${MYSTIC_PC_STOP}"
				;;
			loadcursor | lc)
				_print+="${MYSTIC_PC_START}${MYSTIC_TC_LOAD_CURSOR}${MYSTIC_PC_STOP}"
				;;
			space | spc)
				_print+='\x20'
				;;
			*)
				_print+="${1}"
				;;
		esac
		shift
	done

	printf "%b" "${_print}"
}
mcursor() { mystic_cursor "${@}"; }

# =============================================================================
# Throws bits approximating valid, encapsulated, color escape sequences at
# the terminal and then yolos out.
#
# Arguments:
#		A list of commands as positional arguments.
#
# Usage:
#   mystic_echo <command(s)>
#
# WARNING:
#		Built for speed, not safety. Does not check for valid or clean input.
#
# 	Terminal emulators are, at their core, a writhing mass of ancient serpents
# 	and a chaos of compromises.  Bash quoting, string manipulation, and expansion
# 	are.. imperfect.  You get -i and -a types, and those are hints.
#
#		What I'm saying is: There are inescapable holes in this cheese,	Bobby.
#		...and we're going in.
#
# =============================================================================
mystic_echo() {
	local _print
	local _r _b _g
	local _color_offset_fg _color_offset_bg
	local _nl
	local _reset=true

	_nl="${MYSTIC_TC_NEWLINE}"

	while (($# > 0)); do
		case "$1" in

			# Basic text control
			bold | bd)
				_print+="${MYSTIC_PC_START}${MYSTIC_AT_BOLD}${MYSTIC_PC_STOP}"
				;;
			faint | ft)
				_print+="${MYSTIC_PC_START}${MYSTIC_AT_FAINT}${MYSTIC_PC_STOP}"
				;;
			underline | ul)
				_print+="${MYSTIC_PC_START}${MYSTIC_AT_UNDERLINE}${MYSTIC_PC_STOP}"
				;;
			italics | italic | it)
				_print+="${MYSTIC_PC_START}${MYSTIC_AT_ITALIC}${MYSTIC_PC_STOP}"
				;;
			strikethrough | strike)
				_print+="${MYSTIC_PC_START}${MYSTIC_AT_STRIKETHROUGH}${MYSTIC_PC_STOP}"
				;;
			inverse | reverse | inv | rev)
				_print+="${MYSTIC_PC_START}${MYSTIC_AT_INVERSE}${MYSTIC_PC_STOP}"
				;;
			doubleunderline | du)
				_print+="${MYSTIC_PC_START}${MYSTIC_AT_DOUBLE_UNDERLINE}${MYSTIC_PC_STOP}"
				;;
			text)
				# Quote "your text" to avoid splitting
				shift
				_print+="${1}"
				;;
			no-reset | nrst)
				_reset=false
				;;
			no-newline | nn | nnl)
				_nl=''
				;;
			newline | nl | linefeed | lf)
				_print+="${MYSTIC_TC_NEWLINE}"
				;;
			space | spc)
				# Sometimes you need an explicit space
				_print+='\x20'
				;;

			# ANSI 16-color
			bright)
				_color_offset_fg=60
				;;
			bbright)
				_color_offset_bg=60
				;;
			dim)
				_color_offset_fg=0
				;;
			bdim)
				_color_offset_bg=0
				;;
			blink | flash)
				_print+="${MYSTIC_PC_START}${MYSTIC_AT_BLINK}${MYSTIC_PC_STOP}"
				;;
			reset)
				_print+="${MYSTIC_PC_START}${MYSTIC_AT_RESET}${MYSTIC_PC_STOP}"
				_color_offset_fg=0
				_color_offset_bg=0
				;;
			black | bk)
				_print+="${MYSTIC_COLOR_PREFIX}$((MYSTIC_FG_BLACK + _color_offset_fg))${MYSTIC_COLOR_SUFFIX}"
				;;
			gray | grey)
				# This is a shortcut to "bright black".
				# If bright was specified, this outputs dim white.
				case "${_color_offset_fg}" in
					60)
						_print+="${MYSTIC_COLOR_PREFIX}${MYSTIC_FG_WHITE}${MYSTIC_COLOR_SUFFIX}"
						;;
					*)
						_print+="${MYSTIC_COLOR_PREFIX}$((MYSTIC_FG_BLACK + 60))${MYSTIC_COLOR_SUFFIX}"
						;;
				esac
				;;
			red | rd)
				_print+="${MYSTIC_COLOR_PREFIX}$((MYSTIC_FG_RED + _color_offset_fg))${MYSTIC_COLOR_SUFFIX}"
				;;
			green | gn)
				_print+="${MYSTIC_COLOR_PREFIX}$((MYSTIC_FG_GREEN + _color_offset_fg))${MYSTIC_COLOR_SUFFIX}"
				;;
			yellow | yl)
				_print+="${MYSTIC_COLOR_PREFIX}$((MYSTIC_FG_YELLOW + _color_offset_fg))${MYSTIC_COLOR_SUFFIX}"
				;;
			blue | bl)
				_print+="${MYSTIC_COLOR_PREFIX}$((MYSTIC_FG_BLUE + _color_offset_fg))${MYSTIC_COLOR_SUFFIX}"
				;;
			magenta | pink | mg)
				_print+="${MYSTIC_COLOR_PREFIX}$((MYSTIC_FG_MAGENTA + _color_offset_fg))${MYSTIC_COLOR_SUFFIX}"
				;;
			cyan | cn)
				_print+="${MYSTIC_COLOR_PREFIX}$((MYSTIC_FG_CYAN + _color_offset_fg))${MYSTIC_COLOR_SUFFIX}"
				;;
			white | wt)
				_print+="${MYSTIC_COLOR_PREFIX}$((MYSTIC_FG_WHITE + _color_offset_fg))${MYSTIC_COLOR_SUFFIX}"
				;;
			bblack | bbk)
				_print+="${MYSTIC_COLOR_PREFIX}$((MYSTIC_BG_BLACK + _color_offset_bg))${MYSTIC_COLOR_SUFFIX}"
				;;
			bred | brd)
				_print+="${MYSTIC_COLOR_PREFIX}$((MYSTIC_BG_RED + _color_offset_bg))${MYSTIC_COLOR_SUFFIX}"
				;;
			bgreen | bgn)
				_print+="${MYSTIC_COLOR_PREFIX}$((MYSTIC_BG_GREEN + _color_offset_bg))${MYSTIC_COLOR_SUFFIX}"
				;;
			byellow | byl)
				_print+="${MYSTIC_COLOR_PREFIX}$((MYSTIC_BG_YELLOW + _color_offset_bg))${MYSTIC_COLOR_SUFFIX}"
				;;
			bblue | bbl)
				_print+="${MYSTIC_COLOR_PREFIX}$((MYSTIC_BG_BLUE + _color_offset_bg))${MYSTIC_COLOR_SUFFIX}"
				;;
			bmagenta | bpink | bmg)
				_print+="${MYSTIC_COLOR_PREFIX}$((MYSTIC_BG_MAGENTA + _color_offset_bg))${MYSTIC_COLOR_SUFFIX}"
				;;
			bcyan | bcn)
				_print+="${MYSTIC_COLOR_PREFIX}$((MYSTIC_BG_CYAN + _color_offset_bg))${MYSTIC_COLOR_SUFFIX}"
				;;
			bwhite | bwt)
				_print+="${MYSTIC_COLOR_PREFIX}$((MYSTIC_BG_WHITE + _color_offset_bg))${MYSTIC_COLOR_SUFFIX}"
				;;

			# Xterm's weird indexed 8-bit color: \033[38;255m
			#
			# Usage:
			#     xterm <000-255>
			#     xterm 255 (white)
			#
			# Reference:
			#			https://en.wikipedia.org/wiki/File:Xterm_256color_chart.svg
			xterm | xt)
				_print+="${MYSTIC_COLOR_PREFIX}38;5;$((16 + ${2:0:1} * 36 + ${2:1:1} * 6 + ${2:2:1}))${MYSTIC_COLOR_SUFFIX}"
				shift
				;;
			bxterm | bxt)
				_print+="${MYSTIC_COLOR_PREFIX}48;5;$((16 + ${2:0:1} * 36 + ${2:1:1} * 6 + ${2:2:1}))${MYSTIC_COLOR_SUFFIX}"
				shift
				;;

			# 24-bit RGB does it like this: \033[38;R;G;B;128m
			#
			# Usage:
			#		rgb <red> <green> <blue>
			#		rgb  000     128     255
			#		rgb   00      80      FF
			# you can use hex or dec because I love you.
			# num args <3 are interpreted as hex (use 00-FF)
			# num args >2 are interpreted as dec (use 000-255)
			# values not in [0-9a-fA-F] may summon death
			# values 0x00 (000) < or > 0xff (255) may summon dragons
			# explanation: values outside of the above ranges have no standardized function
			# and your terminal emulator may/not handle it or handle it poorly.  Might be
			# a playground for security researchers.
			rgb)
				if [[ ${#2} -lt 3 ]]; then
					_r=$((0x${2})) && shift
				elif [[ ${#2} -gt 2 ]]; then
					_r=$2 && shift
				else
					_r=255
				fi

				if [[ ${#2} -lt 3 ]]; then
					_g=$((0x${2})) && shift
				elif [[ ${#2} -gt 2 ]]; then
					_g=$2 && shift
				else
					_g=255
				fi

				if [[ ${#2} -lt 3 ]]; then
					_b=$((0x${2})) && shift
				elif [[ ${#2} -gt 2 ]]; then
					_b=$2 && shift
				else
					_b=255
				fi

				_print+="${MYSTIC_COLOR_PREFIX}38;2;${_r:-255};${_g:-255};${_b:-255}${MYSTIC_COLOR_SUFFIX}"
				;;
			brgb)
				if [[ ${#2} -lt 3 ]]; then
					_r=$((0x${2})) && shift
				elif [[ ${#2} -gt 2 ]]; then
					_r=$2 && shift
				else
					_r=255
				fi

				if [[ ${#2} -lt 3 ]]; then
					_g=$((0x${2})) && shift
				elif [[ ${#2} -gt 2 ]]; then
					_g=$2 && shift
				else
					_g=255
				fi

				if [[ ${#2} -lt 3 ]]; then
					_b=$((0x${2})) && shift
				elif [[ ${#2} -gt 2 ]]; then
					_b=$2 && shift
				else
					_b=255
				fi

				_print+="${MYSTIC_COLOR_PREFIX}48;2;${_r:-255};${_g:-255};${_b:-255}${MYSTIC_COLOR_SUFFIX}"
				;;

			# Just print anything that doesn't match a command.
			# Behaves like a more dangerous variant of the 'text' command.
			# Quoting works and is recommended.
			*)
				_print+="${1}"
				;;
		esac
		shift
	done

	if $_reset; then
		_print+="${MYSTIC_PC_START}${MYSTIC_AT_RESET}${MYSTIC_PC_STOP}"
	fi

	printf "%b" "${_print}${_nl}"
}
mecho() { mystic_echo "${@}"; }

## eof
