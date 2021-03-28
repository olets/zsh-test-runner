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
	ZTR_VERSION=1.1.0 && \
	typeset -gr ZTR_VERSION

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

	'command' 'man' ztr 2>/dev/null || 'command' 'man' $__ztr_manpage_path
}

__ztr_init() { # Set variables.
	emulate -LR zsh
	__ztr_debugger

	# -g
	typeset -g fail_color pass_color skip_color

	# if NO_COLOR has not been declared
	if ! typeset -p NO_COLOR 2>/dev/null | grep -q '^'; then
		'builtin' 'autoload' -U colors && colors
		fail_color="$fg[red]"
		pass_color="$fg[green]"
		skip_color="$fg[yellow]"
	fi

	# -gi
	typeset -gi ZTR_DEBUG >/dev/null && \
		ZTR_DEBUG=${ZTR_DEBUG:-0}
	typeset -gi ZTR_QUIET >/dev/null && \
		ZTR_QUIET=${ZTR_QUIET:-0}

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

	# -gr
	typeset -g +r __ztr_manpage_path && \
		__ztr_manpage_path=$__ztr_dir/man/man1/ztr.1 && \
		typeset -gr __ztr_manpage_path

	typeset -g +r ZTR_PATH && \
		ZTR_PATH=$__ztr_dir/ztr.zsh && \
		typeset -gr ZTR_PATH
}

__ztr_test() { # Test <arg> [<name> [<notes>]]. Pretty-print result and notes unless "quiet".
	emulate -LR zsh
	__ztr_debugger

	local notes result arg
	local -i exit_code

	arg=$1
	name=$2
	notes=$3

	eval $arg &>/dev/null

	exit_code=$?

	if (( exit_code )); then
		result="${fail_color}FAIL$reset_color"

		typeset -gi +r ZTR_COUNT_FAIL
		(( ZTR_COUNT_FAIL++ ))
		typeset -gir ZTR_COUNT_FAIL
	else
		result="${pass_color}PASS$reset_color"

		typeset -gi +r ZTR_COUNT_PASS
		(( ZTR_COUNT_PASS++ ))
		typeset -gir ZTR_COUNT_PASS
	fi

	if (( ! __ztr_quiet )); then
		'builtin' 'echo' "$result ${name:-$arg}${notes:+\\n    $notes}"
	fi

	return $exit_code
}

__ztr_skip() { # Skip <arg>.
	emulate -LR zsh
	__ztr_debugger

	local arg name notes

		arg=$1
	name=$2
	notes=$3

	typeset -gi +r ZTR_COUNT_SKIP
	(( ZTR_COUNT_SKIP++ ))
	typeset -gir ZTR_COUNT_SKIP

	if (( ! __ztr_quiet )); then
		'builtin' 'echo' "${skip_color}SKIP$reset_color ${name:-$arg}${notes:+\\n    $notes}"
	fi
}

__ztr_summary() { # Pretty-print summary of counts.
	emulate -LR zsh
	__ztr_debugger

	local rate_fail rate_pass
	local -i total

		total=$(( ZTR_COUNT_FAIL + ZTR_COUNT_PASS + ZTR_COUNT_SKIP ))

	if (( total )); then
		(( ZTR_COUNT_FAIL )) && (( rate_fail=ZTR_COUNT_FAIL*100/total ))
		(( ZTR_COUNT_PASS )) && (( rate_pass=ZTR_COUNT_PASS*100/total ))
	fi

	if (( total == 1 )); then
		'builtin' 'print' $total test total
	else
		'builtin' 'print' $total tests total
	fi

	'builtin' 'print' $fail_color$ZTR_COUNT_FAIL ${rate_fail:+"(${rate_fail}%)"} failed$reset_color

	if (( ZTR_COUNT_SKIP == 1 )); then
		'builtin' 'print' $skip_color$ZTR_COUNT_SKIP was skipped$reset_color
	else
		'builtin' 'print' $skip_color$ZTR_COUNT_SKIP were skipped$reset_color
	fi

	'builtin' 'print' $pass_color$ZTR_COUNT_PASS ${rate_pass:+"(${rate_pass}%)"} passed$reset_color
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
	typeset -gi __ztr_quiet

	__ztr_quiet=$ZTR_QUIET

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
