# Straight-forward tests and reports for zsh
# https://github.com/olets/zsh-test-runner
# Copyright (c) 2021 Henry Bley-Vroman

# Licensed under CC BY-NC-SA 4.0 # with a human rights condition from
# Hippocratic License 2.1. # See the LICENSE file for details. Persons
# interested in using or adapting this work for # commercial purposes should
# contact the author.

__ztr_clear() { # Clear counts.
	emulate -LR zsh
	__ztr_debugger

	typeset -gi +r ZTR_COUNT_SKIP ZTR_COUNT_FAIL ZTR_COUNT_PASS
	ZTR_COUNT_FAIL=0
	ZTR_COUNT_PASS=0
	ZTR_COUNT_SKIP=0
	typeset -gir ZTR_COUNT_SKIP ZTR_COUNT_FAIL ZTR_COUNT_PASS
}

__ztr_debugger() { # Print name of caller function.
  emulate -LR zsh

  (( ZTR_DEBUG )) && 'builtin' 'print' $funcstack[2]
}

__ztr_help() { # Show the manpage.
	emulate -LR zsh
	__ztr_debugger

	'command' 'man' ztr 2>/dev/null || 'command' 'man' ${__ZTR_SOURCE_PATH}/man/ztr.1
}

__ztr_init() { # Set variables.
	emulate -LR zsh
	__ztr_debugger

	# -g
	typeset -g __ZTR_SOURCE_PATH >/dev/null && \
		__ZTR_SOURCE_PATH=${0:A:h}

	# -gi
	typeset -gi ZTR_DEBUG >/dev/null && \
		ZTR_DEBUG=${ZTR_DEBUG:-0}
	typeset -gi ZTR_QUIET >/dev/null && \
		ZTR_QUIET=${ZTR_QUIET:-0}

	# -gr
	typeset -g +r ZTR_VERSION >/dev/null && \
		ZTR_VERSION=alpha-1 && \
		typeset -r ZTR_VERSION

	# -gir
	typeset -gi +r ZTR_COUNT_FAIL && \
		ZTR_COUNT_FAIL=${ZTR_COUNT_FAIL:-0} && \
		typeset -gir ZTR_COUNT_FAIL
	typeset -gi +r ZTR_COUNT_PASS && \
		ZTR_COUNT_PASS=${ZTR_COUNT_PASS:-0} && \
		typeset -gir ZTR_COUNT_PASS
	typeset -gi +r ZTR_COUNT_SKIP && \
		ZTR_COUNT_SKIP=${ZTR_COUNT_SKIP:-0} && \
		typeset -gir ZTR_COUNT_SKIP
}

__ztr_test() { # Test <command> [<notes>]. Pretty-print result and notes unless "quiet".
	emulate -LR zsh
	__ztr_debugger

	local notes result cmd
	local -i exit_code

	cmd=$1
	notes=$2

	eval $cmd &>/dev/null

	exit_code=$?

	if (( exit_code )); then
		result="$fg[red]FAIL$reset_color"

		typeset -gi +r ZTR_COUNT_FAIL
		(( ZTR_COUNT_FAIL++ ))
		typeset -gir ZTR_COUNT_FAIL
	else
		result="$fg[green]PASS$reset_color"

		typeset -gi +r ZTR_COUNT_PASS
		(( ZTR_COUNT_PASS++ ))
		typeset -gir ZTR_COUNT_PASS
	fi

	if (( ! ZTR_QUIET )); then
		'builtin' 'echo' "$result $cmd${notes:+\\n    $notes}"
	fi

	return $exit_code
}

__ztr_skip() { # Skip <command>.
	emulate -LR zsh
	__ztr_debugger

	local cmd && \
		cmd=$1

	typeset -gi +r ZTR_COUNT_SKIP
	(( ZTR_COUNT_SKIP++ ))
	typeset -gir ZTR_COUNT_SKIP

	if (( ! ZTR_QUIET )); then
		'builtin' 'echo' "$fg[yellow]SKIP$reset_color $cmd${notes:+\\n    $notes}"
	fi
}

__ztr_summary() { # Pretty-print summary of counts.
	emulate -LR zsh
	__ztr_debugger

	# @TODO
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

	for opt in "$@"; do
		if (( should_exit )); then
			return
		fi

		case $opt in
			"--help"|\
			"-h"|\
			"help")
				__ztr_help
				return
				;;
			"--quiet"|"-q")
				ZTR_QUIET=1
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
				args+=( $opt )
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
