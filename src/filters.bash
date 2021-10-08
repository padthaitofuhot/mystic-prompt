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

