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

