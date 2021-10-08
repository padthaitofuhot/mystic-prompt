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
