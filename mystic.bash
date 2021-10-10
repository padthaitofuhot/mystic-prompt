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

#####
# Mystic Prompt Configuration
#####


# This is a mess.
# todo: clean up mess.


## System

# Render segments in parallel to speed up.
# Uses mktemp(1) temporary files. Best used
# with tmpfs or other in-memory fs to avoid
# unnecessary spam on your SSD.
MYSTIC_BGRENDER=false


## General display parameters

# Configure visual elements for each supported $TERM
MYSTIC_PLATFORM_NAME="$(uname -s)"
MYSTIC_TERM_SIGNATURE="${MYSTIC_PLATFORM_NAME}${LANG}${TERM}${COLORTERM}"
# MYSTIC_VTY_SIGNATURE_OPENBSD='OpenBSDvt220'
# MYSTIC_VTY_SIGNATURE_FREEBSD='FreeBSDC.UTF-8xterm'
# MYSTIC_VTY_SIGNATURE_LINUX='Linuxen_US.UTF-8linux'

MYSTIC_GLOBAL_TEXT_ATTR="bold"
#MYSTIC_GLOBAL_TEXT_ATTR=""

# Regardless of how many widgets are enabled,
# this is the minimum length of the top frame.
# Default: 23
# Consider:
#
# .-----[o^B]-[0OoL]-[oM.S]- -[Sun-30-02:30]-
# : 127 [root@samadhi] - [.../usr/local/sbin]# ls -la
#
# .--[0OoL]----------------- -[Sun-30-02:30]-
# : ...-issue-1987 3:0 idx.notup:4 tree.rm:2 untracked:7
# :. [root@samadhi] - [.../usr/local/sbin]# ls -la
#
MYSTIC_MIN_FRAME_LENGTH=23

# Max PWD length
MYSTIC_MAXLENGTH_PWD=27

# Max length of branch name to display
MYSTIC_MAXLENGTH_GIT=23

# Outshells
MYSTIC_GLYPH_RANGER='rg'
MYSTIC_GLYPH_MC='mc'

# Base Frame
MYSTIC_GLYPH_LB='['
MYSTIC_GLYPH_RB=']'
MYSTIC_GLYPH_AT='@'
MYSTIC_GLYPH_SLASH='/'

# git
MYSTIC_GLYPH_GIT_WHOSEP='.'
MYSTIC_GLYPH_GIT_NUMSEP=':'

# Input
MYSTIC_GLYPH_ROOT_INPUT='# '


# Select by known terminal signatures
# @TODO: Needs a lot of work yet
case ${MYSTIC_TERM_SIGNATURE} in


	# Assume if it can do at least 256color then it
	# can also do UTF-8.  Same w/ $TRUECOLOR.

	# Why?

	# Because *2*0*2*1*, that's why.

	# Because if you're not spooning with a DEC Alpha
	# you have probably C-A-F7'd out of your framebuffer
	# vty, nice though it is to reminisce, back into
	# present times where we have 256color xterms and
	# are sufficiently internationalized and inclusive
	# for GNU/Linux to find itself distributed with
	# UTF-8 enabled everywhere by default.

	# My oh my what a time to be alive.

  # I am a unicorn. Behold my glitter.


#	*truecolor*)
# 	todo: ... sooon ...
#		MYSTIC_COLOR_MODE=24BIT
#		;;

	*256color*)

		MYSTIC_COLOR_MODE=256

		### Outshells
		MYSTIC_COLOR_RANGER="${MYSTIC_GLOBAL_TEXT_ATTR} xt 550"
		MYSTIC_COLOR_MC="${MYSTIC_GLOBAL_TEXT_ATTR} xt 550"
		#

		### Base Frame
		MYSTIC_GLYPH_ELLIPSIS='…'
		MYSTIC_GLYPH_LINE_H='─'
		MYSTIC_GLYPH_CORNER_TL='┌'
		MYSTIC_GLYPH_LINE_V='│'
		MYSTIC_GLYPH_CORNER_BL='└'
		MYSTIC_COLOR_PUNCTUATION="${MYSTIC_GLOBAL_TEXT_ATTR} xt 222"
		#

		###  Graphing
		MYSTIC_GRAPH_GLYPHS='▁▂▂▃▃▄▅▆▇█'
		#
		# Battery graph
		MYSTIC_GLYPH_BATTERY='ᵇ'
		MYSTIC_GLYPH_SPACER='·'
		MYSTIC_GLYPH_CHARGING='↑'
		MYSTIC_GLYPH_DISCHARGING='↓'
		MYSTIC_GLYPH_FULL='☻'
		MYSTIC_GLYPH_UNKNOWN='‽'
		MYSTIC_GRADIENT_BATTERY_CODE="BCA"
		declare -a MYSTIC_GRADIENT_BATTERY
		#MYSTIC_GRADIENT_BATTERY_CODE="AAB"
		MYSTIC_COLOR_CHARGING="${MYSTIC_GLOBAL_TEXT_ATTR} xt 055"
		MYSTIC_COLOR_DISCHARGING="${MYSTIC_GLOBAL_TEXT_ATTR} xt 033"
		MYSTIC_COLOR_GRAPH_LABEL="${MYSTIC_GLOBAL_TEXT_ATTR} xt 222"
		#
		# Load graph
		MYSTIC_GLYPH_LOAD='ˡ'
		declare -a MYSTIC_GRADIENT_LOAD
		MYSTIC_GRADIENT_LOAD_CODE="ABC"
		#
		# Memory graph
		MYSTIC_GLYPH_MEMORY='ᵐ'
		MYSTIC_GLYPH_SWAP='ˢ'
		declare -a MYSTIC_GRADIENT_MEMORY
		MYSTIC_GRADIENT_MEMORY_CODE="ABC"
		declare -a MYSTIC_GRADIENT_SWAP
		MYSTIC_GRADIENT_SWAP_CODE="ACB"
		#

		### Clock
		MYSTIC_GLYPH_TIMESEP=':'
		MYSTIC_COLOR_DAYNAME="${MYSTIC_GLOBAL_TEXT_ATTR} xt 115"
		MYSTIC_COLOR_DATE="${MYSTIC_GLOBAL_TEXT_ATTR} xt 005"
		MYSTIC_COLOR_TIME="${MYSTIC_GLOBAL_TEXT_ATTR} xt 115"
		#

		### Git
		MYSTIC_COLOR_GITBRANCH_TEXT="${MYSTIC_GLOBAL_TEXT_ATTR} xt 033"
		MYSTIC_COLOR_GITBRANCH_CAPS="${MYSTIC_GLOBAL_TEXT_ATTR} xt 044"
		MYSTIC_COLOR_GITBRANCH_NUM="${MYSTIC_GLOBAL_TEXT_ATTR} xt 055"
		MYSTIC_COLOR_GITSTATUS_NUM="${MYSTIC_GLOBAL_TEXT_ATTR} xt 550"
		MYSTIC_COLOR_GITSTATUS_WHO="${MYSTIC_GLOBAL_TEXT_ATTR} xt 505"
		MYSTIC_COLOR_GITSTATUS_WHAT="${MYSTIC_GLOBAL_TEXT_ATTR} xt 303"
		#

		### Exit Code
		MYSTIC_COLOR_OK_HIGH="${MYSTIC_GLOBAL_TEXT_ATTR} xt 555"
		MYSTIC_COLOR_OK_MID="${MYSTIC_GLOBAL_TEXT_ATTR} xt 005"
		MYSTIC_COLOR_OK_LOW="${MYSTIC_GLOBAL_TEXT_ATTR} xt 003"
		MYSTIC_COLOR_ERROR_HIGH="${MYSTIC_GLOBAL_TEXT_ATTR} xt 555"
		MYSTIC_COLOR_ERROR_MID="${MYSTIC_GLOBAL_TEXT_ATTR} xt 500"
		MYSTIC_COLOR_ERROR_LOW="${MYSTIC_GLOBAL_TEXT_ATTR} xt 300"
		MYSTIC_COLOR_EXITCODE="${MYSTIC_GLOBAL_TEXT_ATTR} xt 555"
		#

		### PWD
		MYSTIC_COLOR_PATH_PWD="${MYSTIC_GLOBAL_TEXT_ATTR} xt 050"
		MYSTIC_COLOR_PATH_PATH="${MYSTIC_GLOBAL_TEXT_ATTR} xt 030"
		#

		### User@Host & Input Pip
		MYSTIC_COLOR_HOSTNAME="${MYSTIC_GLOBAL_TEXT_ATTR} xt 303"
		MYSTIC_COLOR_ROOT_USERNAME="bxt 500 ${MYSTIC_GLOBAL_TEXT_ATTR} xt 550"
		MYSTIC_COLOR_ROOT_INPUT="${MYSTIC_GLOBAL_TEXT_ATTR} xt 500"
		MYSTIC_COLOR_USERNAME="${MYSTIC_GLOBAL_TEXT_ATTR} xt 505"
		MYSTIC_COLOR_INPUT="${MYSTIC_GLOBAL_TEXT_ATTR} xt 005"
		MYSTIC_GLYPH_INPUT='∙ '
		#

		;;

	# Default to 16 color, basic charset
	*)
		MYSTIC_COLOR_MODE=16
		MYSTIC_COLOR_RANGER="${MYSTIC_GLOBAL_TEXT_ATTR} bright yellow"
		MYSTIC_COLOR_MC="${MYSTIC_GLOBAL_TEXT_ATTR} bright yellow"
		MYSTIC_GLYPH_SPACER='-'
		MYSTIC_GLYPH_CHARGING='^'
		MYSTIC_GLYPH_DISCHARGING='.'
		MYSTIC_GLYPH_FULL='*'
		MYSTIC_GLYPH_UNKNOWN='?'
		MYSTIC_GLYPH_ELLIPSIS='...'
		MYSTIC_GLYPH_LINE_H='-'
		MYSTIC_GLYPH_CORNER_TL='.'
		MYSTIC_GLYPH_LINE_V=':'
		MYSTIC_GLYPH_CORNER_BL='.'
		MYSTIC_GLYPH_TIMESEP=':'
		MYSTIC_GLYPH_MEMORY='m'
		MYSTIC_GLYPH_SWAP='s'
		MYSTIC_GLYPH_LOAD='l'
		MYSTIC_GLYPH_BATTERY='b'
		MYSTIC_GRAPH_GLYPHS='..oooOOO00'
		MYSTIC_GRADIENT_COLORS=("${MYSTIC_GLOBAL_TEXT_ATTR} green" \
														"${MYSTIC_GLOBAL_TEXT_ATTR} bright yellow" \
														"${MYSTIC_GLOBAL_TEXT_ATTR} bright purple" \
														"${MYSTIC_GLOBAL_TEXT_ATTR} bright red")
		MYSTIC_GRADIENT_BATTERY_CODE='3322211100'
		MYSTIC_GRADIENT_MEMORY_CODE='0011122233'
		MYSTIC_GRADIENT_SWAP_CODE='0011122233'
		MYSTIC_GRADIENT_LOAD_CODE='0011122233'
		MYSTIC_COLOR_PUNCTUATION="${MYSTIC_GLOBAL_TEXT_ATTR} bright black"
		MYSTIC_COLOR_FRAME=''
		MYSTIC_COLOR_CHARGING="${MYSTIC_GLOBAL_TEXT_ATTR} bright cyan"
		MYSTIC_COLOR_DISCHARGING="${MYSTIC_GLOBAL_TEXT_ATTR} cyan"
		MYSTIC_COLOR_GRAPH_LABEL="${MYSTIC_GLOBAL_TEXT_ATTR} bright black"
		MYSTIC_COLOR_DAYNAME="${MYSTIC_GLOBAL_TEXT_ATTR} bright blue"
		MYSTIC_COLOR_DATE="${MYSTIC_GLOBAL_TEXT_ATTR} blue"
		MYSTIC_COLOR_TIME="${MYSTIC_GLOBAL_TEXT_ATTR} bright blue"
		MYSTIC_COLOR_OK_HIGH="${MYSTIC_GLOBAL_TEXT_ATTR} bright white"
		MYSTIC_COLOR_OK_MID="${MYSTIC_GLOBAL_TEXT_ATTR} bright blue"
		MYSTIC_COLOR_OK_LOW="${MYSTIC_GLOBAL_TEXT_ATTR} blue"
		MYSTIC_COLOR_ERROR_HIGH="${MYSTIC_GLOBAL_TEXT_ATTR} bright white"
		MYSTIC_COLOR_ERROR_MID="${MYSTIC_GLOBAL_TEXT_ATTR} bright red"
		MYSTIC_COLOR_ERROR_LOW="${MYSTIC_GLOBAL_TEXT_ATTR} red"
		MYSTIC_COLOR_EXITCODE="${MYSTIC_GLOBAL_TEXT_ATTR} bright red"
		MYSTIC_COLOR_GITBRANCH_TEXT="${MYSTIC_GLOBAL_TEXT_ATTR} cyan"
		MYSTIC_COLOR_GITBRANCH_CAPS="${MYSTIC_GLOBAL_TEXT_ATTR} bright cyan"
		MYSTIC_COLOR_GITBRANCH_NUM="${MYSTIC_GLOBAL_TEXT_ATTR} bright white"
		MYSTIC_COLOR_GITSTATUS_NUM="${MYSTIC_GLOBAL_TEXT_ATTR} bright yellow"
		MYSTIC_COLOR_GITSTATUS_WHO="${MYSTIC_GLOBAL_TEXT_ATTR} bright purple"
		MYSTIC_COLOR_GITSTATUS_WHAT="${MYSTIC_GLOBAL_TEXT_ATTR} purple"
		MYSTIC_COLOR_HOSTNAME="${MYSTIC_GLOBAL_TEXT_ATTR} purple"
		MYSTIC_COLOR_PATH_PWD="${MYSTIC_GLOBAL_TEXT_ATTR} bright green"
		MYSTIC_COLOR_PATH_PATH="${MYSTIC_GLOBAL_TEXT_ATTR} green"
		MYSTIC_COLOR_ROOT_USERNAME="${MYSTIC_GLOBAL_TEXT_ATTR} bred bright yellow"
		MYSTIC_COLOR_ROOT_INPUT="${MYSTIC_GLOBAL_TEXT_ATTR} bright red"
		MYSTIC_GLYPH_ROOT_INPUT='# '
		MYSTIC_COLOR_USERNAME="${MYSTIC_GLOBAL_TEXT_ATTR} bright purple"
		MYSTIC_COLOR_INPUT="${MYSTIC_GLOBAL_TEXT_ATTR} bright blue"
		MYSTIC_GLYPH_INPUT='$ '

		;;

esac

##
#####
#
# Terminal control/attr codes and colors
#
# This is a blend of VTx and ANSI.
#
# It is incomplete. Your PR can help complete it.
#
# It is assumed these are generally available for
# any terminals in which mystic-prompt runs.
# If your daily-driver terminal chokes on these,
# please file a github issue.
#
#####


# Prefix and suffix for PROMPT_COMMAND
MYSTIC_PC_START='\x01'
MYSTIC_PC_STOP='\x02'
# clear these if not used in PROMPT_COMMAND
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

# Terminal Attribute Codes
MYSTIC_AT_BOLD="${MYSTIC_TC_ESC}[1m"
MYSTIC_AT_DIM="${MYSTIC_TC_ESC}[2m"
MYSTIC_AT_UNDERLINE="${MYSTIC_TC_ESC}[4m"
MYSTIC_AT_BLINK="${MYSTIC_TC_ESC}[5m"
MYSTIC_AT_RESET="${MYSTIC_TC_ESC}[0m"
# Widely unused
MYSTIC_AT_REVERSE="${MYSTIC_TC_ESC}[7m"
MYSTIC_AT_STANDOUT="${MYSTIC_TC_ESC}[3m"

## Color stuff

# fg
MYSTIC_COLOR_PREFIX="${MYSTIC_PC_START}${MYSTIC_TC_ESC}["
MYSTIC_COLOR_SUFFIX="m${MYSTIC_PC_STOP}"
MYSTIC_FG_BLACK=30
MYSTIC_FG_RED=31
MYSTIC_FG_GREEN=32
MYSTIC_FG_YELLOW=33
MYSTIC_FG_BLUE=34
MYSTIC_FG_MAGENTA=35
MYSTIC_FG_CYAN=36
MYSTIC_FG_WHITE=37

# bg
MYSTIC_BG_BLACK=40
MYSTIC_BG_RED=41
MYSTIC_BG_GREEN=42
MYSTIC_BG_YELLOW=43
MYSTIC_BG_BLUE=44
MYSTIC_BG_MAGENTA=45
MYSTIC_BG_CYAN=46
MYSTIC_BG_WHITE=47


# =============================================================================
# Set the XTerm titlebar to a text
#
# Arguments:
# 	str	"text"		put this into titlebar
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
	if [ -x /usr/bin/unicode_start ]; then
		/usr/bin/unicode_start
	else
		# Limited fallback, does not work well with *BSD
		export
		printf '\033%%G'
	fi
}


# =============================================================================
# Rings the terminal bell (maybe)
#
# Effects vary from blinking and beeping to
# playing audio files and doing nothing.
#
# Big Mood.
#
# This is broken in a lot of terminals, but maybe it'll work for you.
# (unless it is playing audio files and doing nothing)
# =============================================================================
mystic_bell() {
  printf '%s' "${MYSTIC_TC_BELL}"
}


# =============================================================================
# Tells the terminal to report its rows and cols.
# Should be implied by 'shopt -s checkwinsize' but it's here in case.
# =============================================================================
mystic_update_termsize() {
  MYSTIC_ROWS="$(tput lines)"
	MYSTIC_COLS="$(tput cols)"
  export MYSTIC_ROWS MYSTIC_COLS
}


# =============================================================================
# Prints a repeated string
#
# Arguments:
#		int count			repeat count
#		str "text"		text to repeat
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
# Move the cursor around and stuff
#
# Arguments:
#		str 
# =============================================================================
mystic_cursor () {
	local _print
	local _pos _row _col
	local _nl

	_nl="${MYSTIC_TC_NEWLINE}"

	while (($# > 0)); do
    case "$1" in
      up)
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
      move | home)
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
      formfeed)
        _print+="${MYSTIC_TC_FORMFEED}"
        ;;
      return | cr)
        _print+="${MYSTIC_TC_RETURN}"
        ;;
      save)
        _print+="${MYSTIC_PC_START}${MYSTIC_TC_SCREEN_SAVE}${MYSTIC_PC_STOP}"
        ;;
      load)
        _print+="${MYSTIC_PC_START}${MYSTIC_TC_SCREEN_LOAD}${MYSTIC_PC_STOP}"
        ;;
      clearline)
        _print+="${MYSTIC_PC_START}${MYSTIC_TC_CLEAR_LINE}${MYSTIC_PC_STOP}"
        ;;
      clearbefore)
        _print+="${MYSTIC_PC_START}${MYSTIC_TC_CLEAR_BEFORE}${MYSTIC_PC_STOP}"
        ;;
      clearafter)
        _print+="${MYSTIC_PC_START}${MYSTIC_TC_CLEAR_AFTER}${MYSTIC_PC_STOP}"
        ;;
      clearscreen | clear | cls)
        _print+="${MYSTIC_PC_START}${MYSTIC_TC_SCREEN_CLEAR}${MYSTIC_PC_STOP}"
        ;;
      space|spc)
      	_print+='\x20'
      	;;
      *)
        _print+="${1}"
        ;;
    esac
    shift
  done

  _print+="${MYSTIC_PC_START}${MYSTIC_AT_RESET}${MYSTIC_PC_STOP}"

  printf "%b" "${_print}"
}


# =============================================================================
# Throws bits approximating valid, encapsulated, color escape sequences at
# the terminal and then yolos out.
#
# Arguments:
#		A list of commands as positional arguments.
#		Examine the conditions of the following case
#		control flow for available commands.
#
# WARNING: Built for speed, not safety. Does not check for valid or clean
# 				 input. For example, uses \x01 rather than \001 to avoid interpreting
#					 succeeding numerals as part of the preceding escape code.
#
# 				 Terminal emulators are, at their core, a writhing mass of ancient
# 				 serpents and angry chaos. Bash quoting and string manipulation
# 				 and expansion are imperfect. You get -i and -a types, and those
#					 are hints.
#
#          What I'm saying is: There are inescapable holes in this cheese,
#          										 Bobby, and we're going in.
#
# =============================================================================
mystic_echo() {
  local _print
  local _r _b _g
  local _color_offset_fg _color_offset_bg
  local _nl

  _nl="${MYSTIC_TC_NEWLINE}"

  while (($# > 0)); do
    case "$1" in
      bold)
        _print+="${MYSTIC_PC_START}${MYSTIC_AT_BOLD}${MYSTIC_PC_STOP}"
        ;;
      unbold)
        _print+="${MYSTIC_PC_START}${MYSTIC_AT_DIM}${MYSTIC_PC_STOP}"
        ;;
      underline | line)
        _print+="${MYSTIC_PC_START}${MYSTIC_AT_UNDERLINE}${MYSTIC_PC_STOP}"
        ;;
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
      	# This is "bright black". Output that without setting global "bright" flag.
        _format+="${MYSTIC_COLOR_PREFIX}$((MYSTIC_FG_BLACK + 60))${MYSTIC_COLOR_SUFFIX}"
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
      newline | nl | linefeed | lf)
        _print+="${MYSTIC_TC_NEWLINE}"
        ;;
      xterm | xt)
      	# xterm 256 .. mmm ye merry olde 8-bit index
      	# \033[38;255m
				_print+="${MYSTIC_COLOR_PREFIX}38;5;$(( 16 + ${2:0:1} * 36 + ${2:1:1} * 6 + ${2:2:1} ))${MYSTIC_COLOR_SUFFIX}"
				shift
 				;;
 			bxterm | bxt)
 				_print+="${MYSTIC_COLOR_PREFIX}48;5;$(( 16 + ${2:0:1} * 36 + ${2:1:1} * 6 + ${2:2:1}))${MYSTIC_COLOR_SUFFIX}"
 				shift
 				;;
      rgb)
        # 24-bit RGB does like this
        # \033[38;R;G;B;128m
        # you can use hex or dec because I love you.
        # args <3 are interpreted as hex
        # args >2 are interpreted as dec
        # values not in [0-9a-fA-F] may summon death
        # values 0 < or > 0xff (255) may summon dragons

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
      text)
      	# Quote "your text" to avoid splitting
        shift
        _print+="${1}"
        ;;
      no-newline|nn|nnl)
        _nl=''
        ;;
      space|spc)
      	# Sometimes you need an explicit space
      	_print+='\x20'
      	;;
      *)
      	# Just print anything that doesn't match.
      	# Behaves like a more dangerous variant of
      	# the 'text' command.
        _print+="${1}"
        ;;
    esac
    shift
  done

  _print+="${MYSTIC_PC_START}${MYSTIC_AT_RESET}${MYSTIC_PC_STOP}"

  printf "%b" "${_print}${_nl}"
}


##
#####
# A collection of output filter functions
#####


# =============================================================================
# Shorten "text" to given length by inserting an ellipsis (or other string)
# between the first 1/4 "hint" and the remainder of "text".
#
# Try to gracefully deal with unreasonably small values of $length,
# but c'mon dude, be reasonable.
#
# You can tweak the hint percent by changing '25' to 1-99.
# 	hint=$(( ( 25 * length ) / 100 ))
#
# Arguments:
#   int length 			trim to this length
#		str	ellipsis		ellipsis char/str to use
# 	str	"text"			text to ellipsify
#
# Example:
# 	mystic_ellipsify 20 '...' "$(mystic_pwd)"
#
# Quirks:
#		Don't use long ellipsis strings.
# =============================================================================
function mystic_ellipsify() {

	local -i length hint
	local ellipsis input
	local output

	length="$1"
	ellipsis="$2"
	shift 2
	input="$*"
	output=''
	hint=$(( ( 25 * length ) / 100 ))

	# short circuit
	if (( ${#input} <= length )); then
		printf '%s\n' "${input}"
		return 0
	fi

	# include root hint if hint >= 1
	if (( hint > ${#ellipsis} )); then

		output+="${input:0:${hint}}"
		output+="${ellipsis}"
		length=$(( length - ${#output} ))

	# or ellipsify at the front when $length is tiny
	elif (( length > ( 2 * ${#ellipsis} ) )); then

		output+="${ellipsis}"
		length=$(( length - ${#output} ))

	fi

	# trim remainder to $length
	output+=${input: -${length} }

	printf '%s\n' "${output}"
}


# =============================================================================
# Walks "text" emitting mystic_echo() commands appropriate to each character.
#
# Arguments:
#   str base_color	mystic_echo() commands for default output
#		str	cap_color		mystic_echo() commands to output CAPITALS
# 	str	num_color		mystic_echo() commands to output Numb3rs222
#   str pun_color		mystic_echo() commands to output Pun(tu@t!on
#		str "text"			the text to filter
#
# Examples:
# 	mystic_style_filter "bright blue" "bright white" \
# 											"bright yellow" "blue" "my Text 2 Filter!"
# 	mystic_style_filter "xt 005" "xt 555" "xt 550" "xt 003" "my Text 2 Filter!"
# =============================================================================
function mystic_style_filter() {

	local cap_color num_color pun_color base_color input
	local filter_tmp output

	base_color="${1}"
	cap_color="${2}"
	num_color="${3}"
	pun_color="${4}"
	shift 4
	input="${*}"
	output=''

	for (( i = 0; i < ${#input}; i++ )); do

		filter_tmp="${input:${i}:1}"

		case "${filter_tmp}" in
			[a-z])
				output+="${base_color} text ${filter_tmp} "
				;;
			[A-Z])
				output+="${cap_color} text ${filter_tmp} "
				;;
			[0-9])
				output+="${num_color} text ${filter_tmp} "
				;;
			[[:space:]])
				output+="${filter_tmp} space "
				;;
			*)
				output+="${pun_color} text ${filter_tmp} "
				;;
		esac

	done

	printf '%s' "${output}"
}

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
mystic_ckv() {
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

#####
# A small library for load metrics graphing
#####


# =============================================================================
# Configure platform globals required to scrape load metrics
#
# Globals:
# 	get:
# 		MYSTIC_PLATFORM_NAME
#		set:
#			MYSTIC_CPU_CORES
#			MYSTIC_HW_PHYS_MEM
#			MYSTIC_HW_PAGE_SIZE
#
# =============================================================================
function mystic_graphs_config_platform() {

	case "${MYSTIC_PLATFORM_NAME}" in

		Linux)
			# graph load based on real cores (default)
			MYSTIC_CPU_CORES="$(grep cores /proc/cpuinfo | sed -e 's/[a-z:]//g' | head -1)"
			# or; graph load based on thread cores
			# MYSTIC_CPU_CORES="$(grep -c cores /proc/cpuinfo)"
			# or; set cores manually
			# MYSTIC_CPU_CORES=''
			;;

		Darwin|FreeBSD)
			MYSTIC_HW_PHYS_MEM="$(sysctl -n hw.physmem)"
			MYSTIC_HW_PAGE_SIZE="$(sysctl -n hw.pagesize)"
			# graph load based on real cores (default)
			MYSTIC_CPU_CORES="$(sysctl -n hw.ncpu)"
			# or; set cores manually
			# MYSTIC_CPU_CORES=''
			;;

		OpenBSD)
			MYSTIC_HW_PHYS_MEM="$(sysctl -n hw.physmem)"
			MYSTIC_HW_PAGE_SIZE="$(sysctl -n hw.pagesize)"
			# graph load based on real cores (default)
			MYSTIC_CPU_CORES="$(sysctl -n hw.ncpuonline)"
			# or; set cores manually
			# MYSTIC_CPU_CORES=''
			;;

		*)
			# Don't graph if we don't know how
			:
			;;

	esac

}

# =============================================================================
# Collect battery state on Linux
#
# Globals:
#		set:
#			MYSTIC_BATTERY_CHARGE
#			MYSTIC_BATTERY_STATUS
# 		MYSTIC_MAINS_STATUS
#
# =============================================================================
function mystic_update_battery_stats_linux() {

	### Battery status, if BAT* nodes exist in sysfs

	# Charge %
	if [[ -f /sys/class/power_supply/BAT0/capacity ]]; then
		MYSTIC_BATTERY_CHARGE="$(< /sys/class/power_supply/BAT0/capacity)"
	else
		MYSTIC_BATTERY_CHARGE=''
	fi

	# Charging/Discharging
	if [[ -f /sys/class/power_supply/BAT0/status ]]; then
		MYSTIC_BATTERY_STATUS="$(< /sys/class/power_supply/BAT0/status)"
	else
		MYSTIC_BATTERY_STATUS=''
	fi

	# Mains
	if [[ -f /sys/class/power_supply/AC/online ]]; then
		MYSTIC_MAINS_STATUS="$(< /sys/class/power_supply/AC/online)"
	else
		MYSTIC_MAINS_STATUS=''
	fi

}

# =============================================================================
# Collect memory stats on Linux
#
# Globals:
#		set:
#			MYSTIC_MEM_LEVEL
#			MYSTIC_SWAP_LEVEL
#
# =============================================================================
function mystic_update_mem_stats_linux() {

	# Query MemTotal every time in case of ballooning.
	# Sets function local vars from /proc/meminfo
	#
	# MemTotal      Total memory
	# MemAvailable  Memory available for allocation by programs
	# SwapTotal     Total swap capacity
	# SwapFree      Swap available

	local MemTotal MemAvailable SwapTotal SwapFree

	# shellcheck disable=SC2046
	eval $(grep -E 'MemTotal|MemAvailable|SwapTotal|SwapFree' /proc/meminfo |
		sed -r -e 's/:/=/g' -e 's/(kB|\)|\(| )//g')

	# shellcheck disable=SC2154
	MYSTIC_MEM_LEVEL="$((100 - ((MemAvailable * 100) / MemTotal)))"

	if [[ "${SwapTotal}" -gt 0 ]]; then
		MYSTIC_SWAP_LEVEL="$((100 - ((SwapFree * 100) / SwapTotal)))"
	else
		MYSTIC_SWAP_LEVEL=''
	fi

}

# =============================================================================
# Collect load averages on Linux
#
# Globals:
#		set:
#			MYSTIC_LOAD_AVERAGES=()
#
# =============================================================================
function mystic_update_load_stats_linux() {

	# shellcheck disable=SC2207
	MYSTIC_LOAD_AVERAGES=($(< /proc/loadavg))
	MYSTIC_LOAD_AVERAGES[0]=$(echo "scale=2; x = ( ${MYSTIC_LOAD_AVERAGES[0]} / ${MYSTIC_CPU_CORES} ) * 100; scale=0; x/1" | bc -l)
	MYSTIC_LOAD_AVERAGES[1]=$(echo "scale=2; x = ( ${MYSTIC_LOAD_AVERAGES[1]} / ${MYSTIC_CPU_CORES} ) * 100; scale=0; x/1" | bc -l)
	MYSTIC_LOAD_AVERAGES[2]=$(echo "scale=2; x = ( ${MYSTIC_LOAD_AVERAGES[2]} / ${MYSTIC_CPU_CORES} ) * 100; scale=0; x/1" | bc -l)

}

# =============================================================================
# Collect battery state on OpenBSD
# @TODO: Okay, how though?
#
# Globals:
#		set:
#			MYSTIC_BATTERY_CHARGE
#			MYSTIC_BATTERY_STATUS
#
# =============================================================================
function mystic_update_battery_stats_openbsd() {

	# Charge %
	MYSTIC_BATTERY_CHARGE=''
	# Charging/Discharging
	MYSTIC_BATTERY_STATUS=''

}

# =============================================================================
# Collect memory stats on OpenBSD
#
# Globals:
#		get:
#			MYSTIC_HW_PAGE_SIZE
#			MYSTIC_HW_PHYS_MEM
#		set:
#			MYSTIC_MEM_LEVEL
#			MYSTIC_SWAP_LEVEL
#
# =============================================================================
function mystic_update_mem_stats_openbsd() {

	local mem_available
	local -a swap_stats
	local SwapTotal SwapFree

	mem_available=$(($(
		vmstat -s |
			awk '
            /pages free$/ { pfree=$1 };
            /pages inactive$/ { pinact=$1 };
            END { print pfree + pinact }'
	) * MYSTIC_HW_PAGE_SIZE))

	MYSTIC_MEM_LEVEL="$((100 - ((mem_available * 100) / MYSTIC_HW_PHYS_MEM)))"

	IFS=" " read -ra swap_stats <<< "$(swapctl -s)"

	SwapTotal="${swap_stats[1]}"
	SwapFree="$((SwapTotal - swap_stats[4]))"

	if [[ "${SwapTotal}" -gt 0 ]]; then
		MYSTIC_SWAP_LEVEL="$((100 - ((SwapFree * 100) / SwapTotal)))"
	else
		MYSTIC_SWAP_LEVEL=''
	fi
}

# =============================================================================
# Collect load averages on OpenBSD
#
# Globals:
#		set:
#			MYSTIC_LOAD_AVERAGES=()
#
# =============================================================================
function mystic_update_load_stats_openbsd() {
	### Load averages
	# shellcheck disable=SC2207
	MYSTIC_LOAD_AVERAGES=($(sysctl -n vm.loadavg))
	MYSTIC_LOAD_AVERAGES[0]=$(echo "scale=2; x = ( ${MYSTIC_LOAD_AVERAGES[0]} / ${MYSTIC_CPU_CORES} ) * 100; scale=0; x/1" | bc -l)
	MYSTIC_LOAD_AVERAGES[1]=$(echo "scale=2; x = ( ${MYSTIC_LOAD_AVERAGES[1]} / ${MYSTIC_CPU_CORES} ) * 100; scale=0; x/1" | bc -l)
	MYSTIC_LOAD_AVERAGES[2]=$(echo "scale=2; x = ( ${MYSTIC_LOAD_AVERAGES[2]} / ${MYSTIC_CPU_CORES} ) * 100; scale=0; x/1" | bc -l)
}

# =============================================================================
# Collect battery state on FreeBSD
# @TODO: Okay, how though: FreeBSD edition
#
# Globals:
#		set:
#			MYSTIC_BATTERY_CHARGE
#			MYSTIC_BATTERY_STATUS
#
# =============================================================================
function mystic_update_battery_stats_freebsd() {
	### Battery stats
	# Charge %
	MYSTIC_BATTERY_CHARGE=''
	# Charging/Discharging
	MYSTIC_BATTERY_STATUS=''
}

# =============================================================================
# Collect memory stats on FreeBSD
#
# Globals:
#		get:
#			MYSTIC_HW_PAGE_SIZE
#			MYSTIC_HW_PHYS_MEM
#		set:
#			MYSTIC_MEM_LEVEL
#			MYSTIC_SWAP_LEVEL
#
# =============================================================================
function mystic_update_mem_stats_freebsd() {

	local pages_available mem_available
	local -a swap_stats
	local SwapTotal SwapFree

	pages_available="$(( $(sysctl -n vm.stats.vm.v_inactive_count) \
										 + $(sysctl -n vm.stats.vm.v_cache_count) \
										 + $(sysctl -n vm.stats.vm.v_free_count) ))"

	mem_available="$(( pages_available * MYSTIC_HW_PAGE_SIZE ))"

	MYSTIC_MEM_LEVEL="$((100 - ((mem_available * 100) / MYSTIC_HW_PHYS_MEM)))"

	IFS=" " read -ra swap_stats <<< "$(swapctl -s)"

	SwapTotal="${swap_stats[1]}"
	SwapFree="$((SwapTotal - swap_stats[2]))"

	if [[ "${SwapTotal}" -gt 0 ]]; then
		MYSTIC_SWAP_LEVEL="$((100 - ((SwapFree * 100) / SwapTotal)))"
	else
		MYSTIC_SWAP_LEVEL=''
	fi

}

# =============================================================================
# Collect load averages on FreeBSD
#
# Globals:
#		set:
#			MYSTIC_LOAD_AVERAGES=()
#
# =============================================================================
function mystic_update_load_stats_freebsd() {

	# shellcheck disable=SC2207
	MYSTIC_LOAD_AVERAGES=($(sysctl -n vm.loadavg | sed 's,[{}],,g'))
	MYSTIC_LOAD_AVERAGES[0]=$(echo "scale=2; x = ( ${MYSTIC_LOAD_AVERAGES[0]} / ${MYSTIC_CPU_CORES} ) * 100; scale=0; x/1" | bc -l)
	MYSTIC_LOAD_AVERAGES[1]=$(echo "scale=2; x = ( ${MYSTIC_LOAD_AVERAGES[1]} / ${MYSTIC_CPU_CORES} ) * 100; scale=0; x/1" | bc -l)
	MYSTIC_LOAD_AVERAGES[2]=$(echo "scale=2; x = ( ${MYSTIC_LOAD_AVERAGES[2]} / ${MYSTIC_CPU_CORES} ) * 100; scale=0; x/1" | bc -l)

}

# =============================================================================
# Abstract call to platform stats functions
#
# Globals:
#		get:
#			MYSTIC_PLATFORM_NAME
#
# =============================================================================
function mystic_update_system_stats() {

	"mystic_update_mem_stats_${MYSTIC_PLATFORM_NAME,,}"
	"mystic_update_load_stats_${MYSTIC_PLATFORM_NAME,,}"
	"mystic_update_battery_stats_${MYSTIC_PLATFORM_NAME,,}"

}


# =============================================================================
# takes a percentage as a whole number and prints a single colored graph bar
#
#	Arguments:
#		int pos					0-99 percentage. <0 = 0; >99 = 99
#		str gradient 		Global array containing the bar cache from which to fetch,
#										for example "MYSTIC_GRADIENT_BATTERY".
#
#	Globals:
#		get:
#			Dynamically fetched from specified in "gradient" argument.
# =============================================================================
function mystic_graph_bar() {

	local pos=${1:-99}
	local gradient="${2}"

	[[ pos -gt 99 ]] && pos=99
	[[ pos -lt 10 ]] && pos=0
	pos="${pos:0:1}"

	foo="${gradient}[${pos}]"

	printf '%s' "${!foo}"
}


# =============================================================================
# Generates positional, colored bar graph segments for the given position
# and gradient code.
#
# Arguments:
#		int pos
#		str gradient
#
# =============================================================================
function mystic_graph_gradient() {

	local gradient color_arg output
	local -i pos

	pos=${1:-9}
	gradient=${2:-ABC}
	color_arg=''
	output=''

	[[ pos -gt 9 ]] && pos=9
	[[ pos -lt 0 ]] && pos=0

	case "${MYSTIC_COLOR_MODE}" in
		16)
			color_arg="${MYSTIC_GRADIENT_COLORS["${!gradient:${pos}:1}"]}"
			;;

		256)
			local x=${gradient:0:1}
			local y=${gradient:1:1}
			local z=${gradient:2:1}
			local A=0 B=9 C=0

			if [[ $pos -gt 4 ]]; then
				A=5
				B=$((B - pos))
			else
				A=$pos
				B=5
			fi
			color_arg="xt ${!x}${!y}${!z}"
			;;

#		24BIT)
#			:
#			;;

		*)
			color_arg="bright white"
			;;
		esac

	output+="$(mystic_echo bold ${color_arg} text "${MYSTIC_GRAPH_GLYPHS:${pos}:1}" reset)"

	printf '%s' "${output}"
}


# =============================================================================
# Render and cache graph bars and colors for quick access.
#
# Globals:
#		get:
#			MYSTIC_GRADIENT_BATTERY_CODE
#			MYSTIC_GRADIENT_MEMORY_CODE
#			MYSTIC_GRADIENT_SWAP_CODE
#			MYSTIC_GRADIENT_LOAD_CODE
#		set:
#			MYSTIC_GRADIENT_BATTERY=()
#			MYSTIC_GRADIENT_MEMORY=()
#			MYSTIC_GRADIENT_SWAP=()
#			MYSTIC_GRADIENT_LOAD=()

# =============================================================================
function mystic_cache_gradients() {

	function _gen_gradient() {
		for ((i = 0; i < 10; i += 1)); do
			printf '%s ' "$(mystic_graph_gradient "${i}" "${1}")"
		done
	}

	read -r -a MYSTIC_GRADIENT_BATTERY << EOA
$(_gen_gradient "${MYSTIC_GRADIENT_BATTERY_CODE}")
EOA
	read -r -a MYSTIC_GRADIENT_MEMORY << EOA
$(_gen_gradient "${MYSTIC_GRADIENT_MEMORY_CODE}")
EOA
	read -r -a MYSTIC_GRADIENT_SWAP << EOA
$(_gen_gradient "${MYSTIC_GRADIENT_SWAP_CODE}")
EOA
	read -r -a MYSTIC_GRADIENT_LOAD << EOA
$(_gen_gradient "${MYSTIC_GRADIENT_LOAD_CODE}")
EOA

}


# =============================================================================
# Render and print bar graphs widgets in the top frame.
#
# Globals:
#		get:
#			MYSTIC_GLYPH_MEMORY
#			MYSTIC_GLYPH_SWAP
#			MYSTIC_GLYPH_LOAD
#			MYSTIC_GLYPH_BATTERY
#			MYSTIC_BATTERY_CHARGE
#			MYSTIC_BATTERY_STATUS
#			MYSTIC_MEM_LEVEL
#			MYSTIC_SWAP_LEVEL
#			MYSTIC_LOAD_AVERAGES=()
#			MYSTIC_GRADIENT_BATTERY
#			MYSTIC_GRADIENT_MEMORY
#			MYSTIC_GRADIENT_SWAP
#			MYSTIC_GRADIENT_LOAD
#
# =============================================================================
function mystic_top_graph() {

	local filler output

	filler=''
	output=''

	# [▅^ᵇ]─
	if [[ -n "${MYSTIC_BATTERY_CHARGE}" ]]; then

		# [
		output+="${MYSTIC_COLOR_PUNCTUATION} text ${MYSTIC_GLYPH_LB} "

		# .oO0
		if [[ MYSTIC_BATTERY_CHARGE -lt 15 ]]; then
			output+="blink $(mystic_graph_bar ${MYSTIC_BATTERY_CHARGE} MYSTIC_GRADIENT_BATTERY) "
		else
			output+="$(mystic_graph_bar ${MYSTIC_BATTERY_CHARGE} MYSTIC_GRADIENT_BATTERY) "
		fi

		# status indicator (charge/discharge/full/???)
		case "${MYSTIC_BATTERY_STATUS,,}" in

			charging)
				output+="${MYSTIC_COLOR_CHARGING} text ${MYSTIC_GLYPH_CHARGING} "
				;;

			discharging)
				output+="${MYSTIC_COLOR_DISCHARGING} text ${MYSTIC_GLYPH_DISCHARGING} "
				;;

			full)
				output+="${MYSTIC_COLOR_CHARGING} text ${MYSTIC_GLYPH_FULL} "
				;;

			*)
				output+="${MYSTIC_COLOR_PUNCTUATION} text ${MYSTIC_GLYPH_UNKNOWN} "
				;;

		esac

		output+="${MYSTIC_COLOR_GRAPH_LABEL} text ${MYSTIC_GLYPH_BATTERY} "

		# ]-
		output+="${MYSTIC_COLOR_PUNCTUATION} text ${MYSTIC_GLYPH_RB} "
		output+="${MYSTIC_COLOR_FRAME} text ${MYSTIC_GLYPH_LINE_H} "

	else

		filler+="text $(mystic_fill 6 "${MYSTIC_GLYPH_LINE_H}") "

	fi

	mystic_echo ${output} nnl
	output=''


	# [▆▄▂ˡ]─
	if [[ -n "${MYSTIC_LOAD_AVERAGES[0]}" ]]; then

		# [
		output+="${MYSTIC_COLOR_PUNCTUATION} text ${MYSTIC_GLYPH_LB} "

		# .oO0
		output+="$(mystic_echo $(mystic_graph_bar ${MYSTIC_LOAD_AVERAGES[0]} MYSTIC_GRADIENT_LOAD)) "
		output+="$(mystic_echo $(mystic_graph_bar ${MYSTIC_LOAD_AVERAGES[1]} MYSTIC_GRADIENT_LOAD)) "
		output+="$(mystic_echo $(mystic_graph_bar ${MYSTIC_LOAD_AVERAGES[2]} MYSTIC_GRADIENT_LOAD)) "
		# TODO: figure out why this reset is necessary for the next color codes to not be "walked" forward
		mystic_echo ${output} reset nnl
		output=''

		# l
		output+="${MYSTIC_COLOR_GRAPH_LABEL} text ${MYSTIC_GLYPH_LOAD} "

		# ]-
		output+="${MYSTIC_COLOR_PUNCTUATION} text ${MYSTIC_GLYPH_RB} "
		output+="${MYSTIC_COLOR_FRAME} text ${MYSTIC_GLYPH_LINE_H} "

	else

		filler+="text $(mystic_fill 7 "${MYSTIC_GLYPH_LINE_H}") "

	fi

	mystic_echo ${output} nnl
	output=''

	# [▂ᵐ▁ˢ]─
	if [[ -n "${MYSTIC_MEM_LEVEL}" ]]; then

		# [
		output+="${MYSTIC_COLOR_PUNCTUATION} text ${MYSTIC_GLYPH_LB} "

		# .oO0
		output+="$(mystic_graph_bar ${MYSTIC_MEM_LEVEL} MYSTIC_GRADIENT_MEMORY) "

		# m
		output+="${MYSTIC_COLOR_GRAPH_LABEL} text ${MYSTIC_GLYPH_MEMORY} "

		if [[ -n "${MYSTIC_SWAP_LEVEL}" ]]; then

			# .oO0
			output+="$(mystic_graph_bar ${MYSTIC_SWAP_LEVEL} MYSTIC_GRADIENT_SWAP) "

			# s
			output+="${MYSTIC_COLOR_GRAPH_LABEL} text ${MYSTIC_GLYPH_SWAP} "

		else

			# ──
			filler+="text $(mystic_fill 2 "${MYSTIC_GLYPH_LINE_H}") "

		fi

		# ]
		output+="${MYSTIC_COLOR_PUNCTUATION} text ${MYSTIC_GLYPH_RB} "

		# ─
		output+="${MYSTIC_COLOR_FRAME} text ${MYSTIC_GLYPH_LINE_H} "

	else

		# ───────
		filler+="text $(mystic_fill 7 "${MYSTIC_GLYPH_LINE_H}") "

	fi

	mystic_echo ${output} nnl
	output=''

	output+="${MYSTIC_COLOR_FRAME} ${filler}${MYSTIC_GLYPH_LINE_H} "
	mystic_echo ${output} nnl
}

#####
# Clock widget
#####


# =============================================================================
# Renders and prints a clock widget.
#
#	·[Sun·30·02:30]·
#	-[Sun-30-02:30]-
#
# Globals:
#		gets:
#			MYSTIC_COLOR_FRAME
#			MYSTIC_COLOR_PUNCTUATION
#			MYSTIC_COLOR_DAYNAME
#			MYSTIC_COLOR_DATE
#			MYSTIC_COLOR_TIME
#			MYSTIC_GLYPH_TIMESEP
#			MYSTIC_GLYPH_LB
#			MYSTIC_GLYPH_RB
#			MYSTIC_GLYPH_SPACER
#
# =============================================================================
function mystic_top_time() {

	local output
	local a d H M

	output=''
	a=$(date '+%a')
	d=$(date '+%d')
	H=$(date '+%H')
	M=$(date '+%M')

	# -
	output+="${MYSTIC_COLOR_FRAME} text ${MYSTIC_GLYPH_SPACER} "
	# [
	output+="${MYSTIC_COLOR_PUNCTUATION} text ${MYSTIC_GLYPH_LB} "
	# Sun
	output+="${MYSTIC_COLOR_DAYNAME} text ${a} "
	# -
	output+="${MYSTIC_COLOR_PUNCTUATION} text ${MYSTIC_GLYPH_SPACER} "
	# 30
	output+="${MYSTIC_COLOR_DATE} text ${d} "
	# -
	output+="${MYSTIC_COLOR_PUNCTUATION} text ${MYSTIC_GLYPH_SPACER} "
	# 02
	output+="${MYSTIC_COLOR_TIME} text ${H} "
	# :
	output+="${MYSTIC_COLOR_PUNCTUATION} text ${MYSTIC_GLYPH_TIMESEP} "
	# 30
	output+="${MYSTIC_COLOR_TIME} text ${M} "
	# ]
	output+="${MYSTIC_COLOR_PUNCTUATION} text ${MYSTIC_GLYPH_RB} "
	# -
	output+="${MYSTIC_COLOR_FRAME} text ${MYSTIC_GLYPH_SPACER} "

	mystic_echo ${output}
}

#####
# Git dashboard
#####


# =============================================================================
# Emits mystic_echo() script of the middle git widget
#
# Globals:
#		gets:
#			MYSTIC_COLOR_GITBRANCH_TEXT
#			MYSTIC_COLOR_GITBRANCH_CAPS
#			MYSTIC_COLOR_GITBRANCH_NUM
#			MYSTIC_COLOR_PUNCTUATION
# =============================================================================
function mystic_git_styled_branch() {

	local gba_temp

	gba_temp="$(mystic_git_branch)"

	mystic_style_filter "${MYSTIC_COLOR_GITBRANCH_TEXT}" "${MYSTIC_COLOR_GITBRANCH_CAPS}" \
  		"${MYSTIC_COLOR_GITBRANCH_NUM}" "${MYSTIC_COLOR_PUNCTUATION}" "${gba_temp} "

}


# =============================================================================
# Renders and prints the middle git widget
# =============================================================================
function mystic_middle_git() {

	local output

	output=''

	# main 3:0
	output+="$(mystic_git_styled_branch)"

	# idx.notup:4 tree.rm:2 untracked:7
	output+="$(mystic_git_status_dashboard)"

  mystic_echo ${output}
}


# =+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-
#
# Git functions are mostly the work of
# Christopher Barry <christopher.r.barry@gmail.com>
#
# from https://github.com/christopher-barry/bash-color-tools
#
# =+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-

#-------------------------------------------------------------------------------
function mystic_git_branch() {

	local loc_rem gb gb_data

	gb=''
	gb_data=''

	gb="$(git symbolic-ref HEAD 2> /dev/null)"
	if [[ "${gb}" ]]; then

		gb="${gb##*/}"
		loc_rem="$(git rev-list --left-right "${gb}"...origin/"${gb}" --count 2> /dev/null)"

		if [[ "${?}" -eq 0 ]]; then
			loc_rem=
		fi

		if [[ ! "${loc_rem}" || "${loc_rem//[[:blank:]]/:}" == "0:0" ]]; then

			gb_data="${gb}"

		else

			gb_data="${gb} ${loc_rem//[[:blank:]]/:}"

		fi

		mystic_ellipsify "${MYSTIC_MAXLENGTH_GIT}" "${MYSTIC_GLYPH_ELLIPSIS}" "${gb_data}"

	fi
}

#-------------------------------------------------------------------------------
function mystic_git_status() {

	local XY X Y out

	while IFS='' read line; do

		XY="${line:0:2}"

		if [[ "${XY:0:1}" == " " ]]; then
			X="_"
		else
			X="${XY:0:1}"
		fi

		if [[ "${XY:1:1}" == " " ]]; then
		 Y="_"
		else
			Y="${XY:1:1}"
		fi

		out+=("${X}${Y}")

	done < <(git status --porcelain 2>&1)

	printf '%s\n' "${out[@]}"
}

# ===============================================================================
# from man git-status
#
#    ' ' = unmodified
#     M  = modified
#     A  = added
#     D  = deleted
#     R  = renamed
#     C  = copied
#     U  = updated but unmerged
#
#    X          Y     Meaning
#    -------------------------------------------------
#              [MD]   not updated
#    M        [ MD]   updated in index
#    A        [ MD]   added to index
#    D         [ M]   deleted from index
#    R        [ MD]   renamed in index
#    C        [ MD]   copied in index
#    [MARC]           index and work tree matches
#    [ MARC]     M    work tree changed since index
#    [ MARC]     D    deleted in work tree
#    -------------------------------------------------
#    D           D    unmerged, both deleted
#    A           U    unmerged, added by us
#    U           D    unmerged, deleted by them
#    U           A    unmerged, added by them
#    D           U    unmerged, deleted by us
#    A           A    unmerged, both added
#    U           U    unmerged, both modified
#    -------------------------------------------------
#    ?           ?    untracked
#    -------------------------------------------------

# additional refs:
# https://stackoverflow.com/questions/21025314/who-is-us-and-who-is-them-according-to-git
# ===============================================================================

#-------------------------------------------------------------------------------
function mystic_git_status_dashboard() {

	local -i not_updated updated_in_index added_to_index deleted_from_index renamed_in_index
	local -i copied_in_index index_and_work_tree_matches work_tree_changed_since_index
	local -i deleted_in_work_tree unmerged_both_deleted unmerged_added_by_us unmerged_deleted_by_them
	local -i unmerged_added_by_them unmerged_deleted_by_us unmerged_both_added unmerged_both_modified untracked
	local output
	local -a dashboard=()

	output=''

	# parse the status, counting instances of each
	for s in $(mystic_git_status); do

		case ${s} in

			# normal status
			   _[MD]) ((not_updated++)) ;;&
			   D[_M]) ((deleted_from_index++)) ;;&
			  M[_MD]) ((updated_in_index++)) ;;&
			  A[_MD]) ((added_to_index++)) ;;&
			  R[_MD]) ((renamed_in_index++)) ;;&
			  C[_MD]) ((copied_in_index++)) ;;&
			 [MARC]_) ((index_and_work_tree_matches++)) ;;&
			[_MARC]M) ((work_tree_changed_since_index++)) ;;&
			[_MARC]D) ((deleted_in_work_tree++)) ;;&

			# merge status
			DD) ((unmerged_both_deleted++)) ;;&
			AU) ((unmerged_added_by_us++)) ;;&
			UD) ((unmerged_deleted_by_them++)) ;;&
			UA) ((unmerged_added_by_them++)) ;;&
			DU) ((unmerged_deleted_by_us++)) ;;&
			AA) ((unmerged_both_added++)) ;;&
			UU) ((unmerged_both_modified++)) ;;&

			# untracked status
			\?\?) ((untracked++)) ;;

		esac

	done

	# normal dashboard elements
	[[ ${not_updated} -gt 0 ]] && dashboard+=("idx !up ${not_updated}")
	[[ ${updated_in_index} -gt 0 ]] && dashboard+=("idx up ${updated_in_index}")
	[[ ${added_to_index} -gt 0 ]] && dashboard+=("idx add ${added_to_index}")
	[[ ${deleted_from_index} -gt 0 ]] && dashboard+=("idx rm ${deleted_from_index}")
	[[ ${renamed_in_index} -gt 0 ]] && dashboard+=("idx mv ${renamed_in_index}")
	[[ ${copied_in_index} -gt 0 ]] && dashboard+=("idx cp ${copied_in_index}")
	[[ ${index_and_work_tree_matches} -gt 0 ]] && dashboard+=("idx =tree ${index_and_work_tree_matches}")
	[[ ${work_tree_changed_since_index} -gt 0 ]] && dashboard+=("tree mod ${work_tree_changed_since_index}")
	[[ ${deleted_in_work_tree} -gt 0 ]] && dashboard+=("tree rm ${deleted_in_work_tree}")

	# merge dashboard elements
	[[ ${unmerged_both_deleted} -gt 0 ]] && dashboard+=("both rm ${unmerged_both_deleted}")
	[[ ${unmerged_added_by_us} -gt 0 ]] && dashboard+=("us add ${unmerged_added_by_us}")
	[[ ${unmerged_deleted_by_them} -gt 0 ]] && dashboard+=("them rm ${unmerged_deleted_by_them}")
	[[ ${unmerged_added_by_them} -gt 0 ]] && dashboard+=("them add ${unmerged_added_by_them}")
	[[ ${unmerged_deleted_by_us} -gt 0 ]] && dashboard+=("us rm ${unmerged_deleted_by_us}")
	[[ ${unmerged_both_added} -gt 0 ]] && dashboard+=("both add ${unmerged_both_added}")
	[[ ${unmerged_both_modified} -gt 0 ]] && dashboard+=("both mod ${unmerged_both_modified}")

	# untracked dashboard element
	[[ ${untracked} -gt 0 ]] && dashboard+=("!trk _ ${untracked}")

	if [[ ${#dashboard[@]} -gt 0 ]]; then

		for ((i = 0; i < ${#dashboard[@]}; i++)); do

			set -- ${dashboard[i]}

			output+="${MYSTIC_COLOR_GITSTATUS_WHO} text ${1} "

			if ! [[ "${2}" == '_' ]]; then

				output+="${MYSTIC_COLOR_PUNCTUATION} text ${MYSTIC_GLYPH_GIT_WHOSEP} "
				output+="${MYSTIC_COLOR_GITSTATUS_WHAT} text ${2} "

			fi

			output+="${MYSTIC_COLOR_PUNCTUATION} text ${MYSTIC_GLYPH_GIT_NUMSEP} "
			output+="${MYSTIC_COLOR_GITSTATUS_NUM} text ${3} "
			output+='space '

		done

	fi

	printf '%s' "${output}"
}

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
		if git status --porcelain &> /dev/null; then
			mystic_middle_edge
			mystic_middle_git
		fi
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
