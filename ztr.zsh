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

	typeset -gi +r ZTR_COUNT_SKIP ZTR_COUNT_FAIL ZTR_COUNT_PASS
	ZTR_COUNT_FAIL=0
	ZTR_COUNT_PASS=0
	ZTR_COUNT_SKIP=0
	typeset -gir ZTR_COUNT_SKIP ZTR_COUNT_FAIL ZTR_COUNT_PASS
}

__ztr_get_use_color() {
	# succeeds if NO_COLOR has not been declared
	! typeset -p NO_COLOR 2>/dev/null | grep -q '^'
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

	if __ztr_get_use_color; then
		'builtin' 'autoload' -U colors && colors
	fi

	# -g
	typeset -g fail_color pass_color skip_color

	# -gAr
	typeset -gA +r __ztr_colors && \
		__ztr_colors=(
			[fail]=red
			[pass]=green
			[skip]=yellow
			[default]=$reset_color
		) && \
		typeset -gAr __ztr_colors

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

	local arg default_color fail_color pass_color notes result
	local -i exit_code

	arg=$1
	name=$2
	notes=$3

	if __ztr_get_use_color; then
		default_color="$__ztr_colors[default]"
		fail_color="$fg[$__ztr_colors[fail]]"
		pass_color="$fg[$__ztr_colors[pass]]"
	fi

	eval $arg &>/dev/null

	exit_code=$?

	if (( exit_code )); then
		result="${fail_color}FAIL$default_color"

		typeset -gi +r ZTR_COUNT_FAIL
		(( ZTR_COUNT_FAIL++ ))
		typeset -gir ZTR_COUNT_FAIL
	else
		result="${pass_color}PASS$default_color"

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

	local arg default_color name notes skip_color

	arg=$1
	name=$2
	notes=$3

	if __ztr_get_use_color; then
		default_color="$__ztr_colors[default]"
		skip_color="$fg[$__ztr_colors[skip]]"
	fi

	typeset -gi +r ZTR_COUNT_SKIP
	(( ZTR_COUNT_SKIP++ ))
	typeset -gir ZTR_COUNT_SKIP

	if (( ! __ztr_quiet )); then
		'builtin' 'echo' "${skip_color}SKIP$default_color ${name:-$arg}${notes:+\\n    $notes}"
	fi
}

__ztr_summary() { # Pretty-print summary of counts.
	emulate -LR zsh
	__ztr_debugger

	local default_color fail_color pass_color rate_fail rate_pass skip_color
	local -i total

	if __ztr_get_use_color; then
		fail_color="$fg[$__ztr_colors[fail]]"
		pass_color="$fg[$__ztr_colors[pass]]"
		default_color="$__ztr_colors[default]"
		skip_color="$fg[$__ztr_colors[skip]]"
	fi

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

	'builtin' 'print' $fail_color$ZTR_COUNT_FAIL ${rate_fail:+"(${rate_fail}%)"} failed$default_color

	if (( ZTR_COUNT_SKIP == 1 )); then
		'builtin' 'print' $skip_color$ZTR_COUNT_SKIP was skipped$default_color
	else
		'builtin' 'print' $skip_color$ZTR_COUNT_SKIP were skipped$default_color
	fi

	'builtin' 'print' $pass_color$ZTR_COUNT_PASS ${rate_pass:+"(${rate_pass}%)"} passed$default_color
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
