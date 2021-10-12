# Behavior Guide
If you cannot admit to yourself that there are _**many**_ more compatible ways to experience being alive, good, and human than the comparatively few ways you can personally imagine, then this is not the project for you.

# Style Guide
## Tabs/Spaces?
Ah yes, a _holy_ war.

**TL;DR - Use tabs.**

But I love spaces so much.  I always use them.  I am a fossil from the ancient realms of ANSI art, computer bulletin board systems, 80x25 or 80x50 terminals, and modems.  Tabs and spaces were converted depending on the server software used and SysOp preferences. If you used tabs on a spaces board and your indents broke, you'd be mocked.  That was, socially, the extent of it.  

However, accessibility considerations are important.

Users of screen readers back in the day did not have to operate in as many contexts as they do now. It's 2021 and the world is full of web 4.0 marketing and garbage which can be annoying, if not impossible, for a person using a screen reader.

And anyway, modern IDEs and code formatters exist and are able to handle the translation between spaces and tabs.

So: Use tabs.


Also, this: https://dev.to/alexandersandberg/why-we-should-default-to-tabs-instead-of-spaces-for-an-accessible-first-environment-101f

## Code style
```shell
# =============================================================================
# Brief description of the function. Bash has -i and -a types, so we have to 
# keep ourselves honest and organized by documenting and adhering to our types.
# Regardless, code defesively unless you are very clear about being dangerous,
# for example using `eval`.
# 
#	Arguments:
#		str strarg		string description
#		int intarg		int description
#		var vararg		var for ${!var}
#		arr arrarg		array name for array stuff
#
#	Globals
#		get:
#			GET_ME
#		set:
#			SET_ME
#
#(optional)
# Examples:
# 	printf '%s\n' "$(foo bar bas bid bop)"
# =============================================================================
function foo() {

	# declare str and untyped first	
	local strarg vararg arrarg local_var output
	local -i intarg
	local -a local_array
	
	# then local assignments
	output=''
	local_var="${!vararg}"
	local_array( "${strarg}" "${intarg}" )

	# Simple singular if
	if true; then
		printf '%s\n' "true"
	fi

	# Simple compound if
	if do_something; then
		printf '%s\n' "something done"
	else
		printf '%s\n' "something not done"
	fi
	 
	# prefer case over compound if whenever possible,
	# especially complex compound if.
	# case is faster anyway.
	case $local_var in
	
		foo)
			do_something
			;;
	
		*)
			default_thing
			;;
	
	esac
	
	# Complex compound if
	# add  s p a c e  between segments 
	if true && ! [[ "${local_var}" =~ false ]]; then


		if [[ true ]] && ! (( ( myint + 100 ) = 200 )); then

			if [[ "${BASH_VERSINFO:-0}" -lt 4 ]]; then
				printf '%s\n' "MysticPrompt requires BASH 4.x+"
				exit 1
			fi

			# Comment when not obvious.
			# "Obvious" things are what a newcomer to the code
			# could reasonably be expected to understand from
			# context.
			# Spaghetti is not obvious and SHOULD be commented.
			output+="${local_var:0:${strarg}}"
			output+="${strarg}"
			length=$(( intarg - ${#output} ))
		
		elif ! [[ -f /bin/false ]] || [[ -n "${local_var}" ]]; then

			output+="$(mystic_style_filter \
								"${MYSTIC_COLOR_PATH_PATH}" \
								"${MYSTIC_COLOR_PATH_PATH}" \
								"${MYSTIC_COLOR_PATH_PATH}" \
								"${MYSTIC_COLOR_PUNCTUATION}" \
								"${strarg%/*}/") "
			
		else
			
			return 1

		fi
		# keep same spacing as opening 'if'
	fi

	output+="${MYSTIC_COLOR_PUNCTUATION} text ${MYSTIC_GLYPH_RB} "
	
	# no space between function output and closing brace	
	mystic_echo ${output} nnl		
}

```

## Questions? 
File an issue. **Unanswered questions are docbugs.**
