# Straight-forward tests and reports for zsh
# https://github.com/olets/zsh-test-runner
# Copyright (c) 2021 Henry Bley-Vroman

# Licensed under CC BY-NC-SA 4.0 # with a human rights condition from
# Hippocratic License 2.1. # See the LICENSE file for details. Persons
# interested in using or adapting this work for # commercial purposes should
# contact the author.

typeset -g __ztr_dir && \
	__ztr_dir=${0:A:h}

typeset -g +r ZTR_VERSION >/dev/null && \
	ZTR_VERSION=1.1.1 && \
	typeset -gr ZTR_VERSION

__ztr_clear() { # Clear counts.
	emulate -LR zsh
	__ztr_debugger

	typeset -gA +r ZTR_RESULTS
	ZTR_RESULTS[failed]=0
	ZTR_RESULTS[passed]=0
	ZTR_RESULTS[skipped]=0
	typeset -gAr ZTR_RESULTS
}

__ztr_get_use_color() {
	# succeeds if NO_COLOR has not been declared
	! typeset -p NO_COLOR 2>/dev/null | grep -q '^'
}

__ztr_debugger() { # Print name of caller function.
	emulate -LR zsh

	(( ZTR_DEBUG )) && 'builtin' 'print' $funcstack[2]
}

__ztr_eval() {
	emulate -LR $__ztr_emulation_mode_requested

	__ztr_emulation_mode_used=$(emulate)

	eval $*
}

__ztr_help() { # Show the manpage.
	emulate -LR zsh
	__ztr_debugger

	'command' 'man' ztr 2>/dev/null || 'command' 'man' $__ztr_dir/man/man1/ztr.1
}

__ztr_init() { # Set variables.
	emulate -LR zsh
	__ztr_debugger

	if __ztr_get_use_color; then
		'builtin' 'autoload' -U colors && colors
	fi

	# -g
	typeset -g ZTR_EMULATION_MODE && \
		ZTR_EMULATION_MODE=${ZTR_EMULATION_MODE:-zsh}

	# -gAr
	typeset -gA +r __ztr_colors && \
		__ztr_colors=(
			[failed]=$fg[red]
			[passed]=$fg[green]
			[skipped]=$fg[yellow]
			[default]=$reset_color
		) && \
		typeset -gAr __ztr_colors

	typeset -gA +r ZTR_RESULTS && \
		ZTR_RESULTS=(
			[failed]=${ZTR_RESULTS[failed]:-0}
			[passed]=${ZTR_RESULTS[passed]:-0}
			[skipped]=${ZTR_RESULTS[skipped]:-0}
		) && \
		typeset -gAr ZTR_RESULTS

	# -gi
	typeset -gi ZTR_DEBUG >/dev/null && \
		ZTR_DEBUG=${ZTR_DEBUG:-0}
	typeset -gi ZTR_QUIET >/dev/null && \
		ZTR_QUIET=${ZTR_QUIET:-0}

	typeset -g +r ZTR_PATH && \
		ZTR_PATH=$__ztr_dir/ztr.zsh && \
		typeset -gr ZTR_PATH
}

__ztr_test() { # Test <arg> [<name> [<notes>]]. Pretty-print result and notes unless "quiet".
	emulate -LR zsh
	__ztr_debugger

	local arg color_default color_failed color_passed notes result
	local -i exit_code

	arg=$1
	name=$2
	notes=$3

	if __ztr_get_use_color; then
		color_default="$__ztr_colors[default]"
		color_failed="$__ztr_colors[failed]"
		color_passed="$__ztr_colors[passed]"
	fi

	__ztr_eval $arg &>/dev/null

	exit_code=$?

	if (( exit_code )); then
		result="${color_failed}FAIL$color_default"

		typeset -gA +r ZTR_RESULTS
		(( ZTR_RESULTS[failed]++ ))
		typeset -gAr ZTR_RESULTS
	else
		result="${color_passed}PASS$color_default"

		typeset -gA +r ZTR_RESULTS
		(( ZTR_RESULTS[passed]++ ))
		typeset -gAr ZTR_RESULTS
	fi

	if (( ! __ztr_quiet )); then
		'builtin' 'print' "$result ${name:-$arg}${notes:+\\n    $notes}"

		[[ $__ztr_emulation_mode_used != zsh ]] \
			&& 'builtin' 'print' "    emulation mode: $__ztr_emulation_mode_used"
	fi

	return $exit_code
}

__ztr_skip() { # Skip <arg>.
	emulate -LR zsh
	__ztr_debugger

	local arg color_default color_skipped name notes

	arg=$1
	name=$2
	notes=$3

	if __ztr_get_use_color; then
		color_default="$__ztr_colors[default]"
		color_skipped="$__ztr_colors[skipped]"
	fi

	typeset -gA +r ZTR_RESULTS
	(( ZTR_RESULTS[skipped]++ ))
	typeset -gAr ZTR_RESULTS

	if (( ! __ztr_quiet )); then
		'builtin' 'echo' "${color_skipped}SKIP$color_default ${name:-$arg}${notes:+\\n    $notes}"
	fi
}

__ztr_summary() { # Pretty-print summary of counts.
	emulate -LR zsh
	__ztr_debugger

	local color_default color_failed color_passed color_skipped rate_failed rate_passed
	local -i total

	if __ztr_get_use_color; then
		color_default="$__ztr_colors[default]"
		color_failed="$__ztr_colors[failed]"
		color_passed="$__ztr_colors[passed]"
		color_skipped="$__ztr_colors[skipped]"
	fi

	total=$(( ZTR_RESULTS[failed] + ZTR_RESULTS[passed] + ZTR_RESULTS[skipped] ))

	if (( total )); then
		(( ZTR_RESULTS[failed] )) && (( rate_failed=ZTR_RESULTS[failed]*100/total ))
		(( ZTR_RESULTS[passed] )) && (( rate_passed=ZTR_RESULTS[passed]*100/total ))
	fi

	if (( total == 1 )); then
		'builtin' 'print' $total test total
	else
		'builtin' 'print' $total tests total
	fi

	'builtin' 'print' $color_failed$ZTR_RESULTS[failed] ${rate_failed:+"(${rate_failed}%)"} failed$color_default

	if (( ZTR_RESULTS[skipped] == 1 )); then
		'builtin' 'print' $color_skipped$ZTR_RESULTS[skipped] was skipped$color_default
	else
		'builtin' 'print' $color_skipped$ZTR_RESULTS[skipped] were skipped$color_default
	fi

	'builtin' 'print' $color_passed$ZTR_RESULTS[passed] ${rate_passed:+"(${rate_passed}%)"} passed$color_default
}

__ztr_version() { # Print the command name and current version.
	emulate -LR zsh
	__ztr_debugger

	'builtin' 'print' ztr $ZTR_VERSION
}

ztr() {
	emulate -LR zsh
	__ztr_debugger

	typeset -a args
	typeset -i clear run_test skip_test summary
	typeset -g __ztr_emulation_mode_requested
	typeset -g __ztr_emulation_mode_used
	typeset -gi __ztr_quiet

	__ztr_emulation_mode_requested=$ZTR_EMULATION_MODE
	__ztr_quiet=$ZTR_QUIET

	while (( $# )); do
		case $1 in
			"--emulate")
				__ztr_emulation_mode_requested=$2
				shift 2
				;;
			"--help"|\
			"-h"|\
			"help")
				__ztr_help
				return
				;;
			"--quiet"|"-q")
				__ztr_quiet=1
				shift
				;;
			"--version"|\
			"-v"|\
			"version")
				__ztr_version
				return
				;;
			"clear")
				clear=1
				shift
				;;
			# "help" see "--help"
			"test")
				run_test=1
				shift
				;;
			"skip")
				skip_test=1
				shift
				;;
			"summary")
				summary=1
				shift
				;;
			# "version" see "--version"
			*)
				args+=( $1 )
				shift
				;;
		esac
	done

	if (( clear )); then
		__ztr_clear
		return
	fi

	if (( run_test )); then
		__ztr_test $args
		return
	fi

	if (( skip_test )); then
		__ztr_skip $args
		return 0
	fi

	if (( summary )); then
		__ztr_summary
		return
	fi
}

__ztr_init
