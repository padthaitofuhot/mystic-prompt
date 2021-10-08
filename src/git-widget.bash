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

