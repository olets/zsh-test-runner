#!/usr/bin/env zsh

# Straight-forward tests and coverage reports for zsh and —under zsh's emulation— csh, ksh, and sh
# https://github.com/olets/zsh-test-runner
# v2.1.1
# Copyright (c) 2021-present Henry Bley-Vroman

__ztr_bootstrap() {
	emulate -LR zsh
	__ztr_debugger

	local -a shell_funcs
	local -i found

	shell_funcs=( ${(k)functions} )
	found=$(( $shell_funcs[(Ie)ZTR_BOOTSTRAP_FN] ))

	if (( found )); then
		ZTR_BOOTSTRAP_FN
	fi
}

__ztr_clean() {
	emulate -LR zsh
	__ztr_debugger

	local -a shell_funcs
	local -i found

	shell_funcs=( ${(k)functions} )
	found=$(( $shell_funcs[(Ie)ZTR_CLEAN_FN] ))

	if (( found )); then
		ZTR_CLEAN_FN
	fi
}

__ztr_clear_queue() {
	typeset -ga +r __ztr_queue
	__ztr_queue=
	typeset -gar __ztr_queue
}

__ztr_clear_summary() {
	emulate -LR zsh
	__ztr_debugger

	typeset -gA +r ZTR_RESULTS
	ZTR_RESULTS[failed]=0
	ZTR_RESULTS[passed]=0
	ZTR_RESULTS[skipped]=0
	typeset -gAr ZTR_RESULTS
}

__ztr_no_color() {
	# no debugger

	local -a shell_vars
	local -i found

	shell_vars=( ${(k)parameters} )

	found=$(( ! $shell_vars[(Ie)NO_COLOR] ))

	return $found
}

__ztr_debugger() { # Print name of caller function.
	emulate -LR zsh
	# no debugger

	(( ZTR_DEBUG )) && 'builtin' 'print' $funcstack[2]
}

__ztr_eval() {
	emulate -LR ${__ztr_emulation_mode_requested:-$ZTR_EMULATION_MODE}
	# no debugger

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

	if ! __ztr_no_color; then
		'builtin' 'autoload' -U colors && colors
	fi

	# Global read/writable string variables
	typeset -g ZTR_EMULATION_MODE && \
		ZTR_EMULATION_MODE=${ZTR_EMULATION_MODE:-zsh}

	# Global read-only array variables
	typeset -gar __ztr_queue

	# Global read-only associative array variables
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

	# Global integer variables
	typeset -gi ZTR_DEBUG >/dev/null && \
		ZTR_DEBUG=${ZTR_DEBUG:-0}
	typeset -gi ZTR_QUIET >/dev/null && \
		ZTR_QUIET=${ZTR_QUIET:-0}
	typeset -gi ZTR_QUIET_EMULATION_MODE >/dev/null && \
		ZTR_QUIET_EMULATION_MODE=${ZTR_QUIET_EMULATION_MODE:-0}
	typeset -gi ZTR_QUIET_FAIL >/dev/null && \
		ZTR_QUIET_FAIL=${ZTR_QUIET_FAIL:-0}
	typeset -gi ZTR_QUIET_PASS >/dev/null && \
		ZTR_QUIET_PASS=${ZTR_QUIET_PASS:-0}
	typeset -gi ZTR_QUIET_SKIP >/dev/null && \
		ZTR_QUIET_SKIP=${ZTR_QUIET_SKIP:-0}

	# Global read-only string variables
	typeset -g +r ZTR_PATH && \
		ZTR_PATH=$__ztr_dir/ztr.zsh && \
		typeset -gr ZTR_PATH
	typeset -g +r ZTR_VERSION >/dev/null && \
		ZTR_VERSION=2.1.1 && \
		typeset -gr ZTR_VERSION
}

__ztr_queue() {
	emulate -LR zsh
	__ztr_debugger

	local args cmd

	args=$@

	cmd=test
	if (( __ztr_queue_skip )); then
		cmd=skip
	fi

	if (( ! ${#args} )); then
		for q in $__ztr_queue; do
			'builtin' 'print' "$q"
		done

		return
	fi

	typeset -ga +r __ztr_queue
	__ztr_queue+=( "ztr $cmd $args" )
	typeset -gar __ztr_queue
}

__ztr_reset() {
	unset __ztr_emulation_mode_requested __ztr_emulation_mode_used \
		__ztr_queue_skip __ztr_quiet __ztr_quiet_emulation_mode
}

__ztr_run_queue() {
	emulate -LR zsh
	__ztr_debugger

	local quiet_saved
	local name

	quiet_saved=$ZTR_QUIET
	name=$1

	__ztr_bootstrap

	ZTR_QUIET=$__ztr_quiet

	if [[ -n $name ]]; then
		'builtin' 'printf' "%s\n" "$name"
	fi

	for q in $__ztr_queue; do
		__ztr_eval $q
	done

	ZTR_QUIET=quiet_saved

	__ztr_clean

	__ztr_clear_queue
}

__ztr_setup() {
	emulate -LR zsh
	__ztr_debugger

	local -a shell_funcs
	local -i found

	shell_funcs=( ${(k)functions} )
	found=$(( $shell_funcs[(Ie)ZTR_SETUP_FN] ))

	if (( found )); then
		ZTR_SETUP_FN $ZTR_SETUP_ARGS
	fi
}

__ztr_skip() { # Skip <arg>.
	emulate -LR zsh
	__ztr_debugger

	local arg color_default color_skipped name notes

	arg=$1
	name=$2
	notes=$3

	if ! __ztr_no_color; then
		color_default="$__ztr_colors[default]"
		color_skipped="$__ztr_colors[skipped]"
	fi

	typeset -gA +r ZTR_RESULTS
	(( ZTR_RESULTS[skipped]++ ))
	typeset -gAr ZTR_RESULTS

	if (( ! __ztr_quiet && ! __ztr_quiet_skip )); then
		'builtin' 'echo' - "${color_skipped}SKIP$color_default ${name:-$arg}${notes:+\\n    $notes}"
	fi
}

__ztr_summary() { # Pretty-print summary of counts.
	emulate -LR zsh
	__ztr_debugger

	local color_default color_failed color_passed color_skipped rate_failed rate_passed
	local -i total

	if ! __ztr_no_color; then
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

__ztr_teardown() {
	emulate -LR zsh
	__ztr_debugger

	local -a shell_funcs
	local -i found

	shell_funcs=( ${(k)functions} )
	found=$(( $shell_funcs[(Ie)ZTR_TEARDOWN_FN] ))

	if (( found )); then
		ZTR_TEARDOWN_FN $ZTR_TEARDOWN_ARGS
	fi
}

__ztr_test() { # Test <arg> [<name> [<notes>]]. Pretty-print result and notes unless "quiet".
	emulate -LR zsh
	__ztr_debugger

	local arg color_default color_failed color_passed notes result
	local -i exit_code

	arg=$1
	name=$2
	notes=$3

	if ! __ztr_no_color; then
		color_default="$__ztr_colors[default]"
		color_failed="$__ztr_colors[failed]"
		color_passed="$__ztr_colors[passed]"
	fi

	__ztr_setup

	__ztr_eval $arg &>/dev/null

	exit_code=$?

	__ztr_teardown

	if (( exit_code )); then
		if (( ! __ztr_quiet_fail )); then
			result="${color_failed}FAIL$color_default"
		fi

		typeset -gA +r ZTR_RESULTS
		(( ZTR_RESULTS[failed]++ ))
		typeset -gAr ZTR_RESULTS
	else
		if (( ! __ztr_quiet_pass )); then
			result="${color_passed}PASS$color_default"
		fi

		typeset -gA +r ZTR_RESULTS
		(( ZTR_RESULTS[passed]++ ))
		typeset -gAr ZTR_RESULTS
	fi

	if [[ -n $result ]] && (( ! __ztr_quiet )); then
		'builtin' 'print' "$result ${name:-$arg}${notes:+\\n    $notes}"

		(( ! __ztr_quiet_emulation_mode )) && [[ $__ztr_emulation_mode_used != zsh ]] \
			&& 'builtin' 'print' "    emulation mode: $__ztr_emulation_mode_used"
	fi

	return $exit_code
}

__ztr_version() { # Print the command name and current version.
	emulate -LR zsh
	__ztr_debugger

	'builtin' 'print' ztr $ZTR_VERSION
}

ztr() {
	emulate -LR zsh
	__ztr_debugger

	local -a args exit_code flags
	local -i clear_queue clear_summary queue run_queue run_test skip_test summary
	typeset -g __ztr_emulation_mode_requested __ztr_emulation_mode_used
	typeset -gi __ztr_queue_skip __ztr_quiet __ztr_quiet_emulation_mode __ztr_quiet_fail __ztr_quiet_pass __ztr_quiet_skip

	__ztr_emulation_mode_requested=$ZTR_EMULATION_MODE
	__ztr_quiet_emulation_mode=$ZTR_QUIET_EMULATION_MODE
	__ztr_quiet_fail=$ZTR_QUIET_FAIL
	__ztr_quiet_pass=$ZTR_QUIET_PASS
	__ztr_quiet_skip=$ZTR_QUIET_SKIP
	__ztr_quiet=$ZTR_QUIET

	while (( $# )); do
		case $1 in
			"--emulate")
				__ztr_emulation_mode_requested=$2
				flags+=( "--emulate $__ztr_emulation_mode_requested" )
				shift 2
				;;
			"--help"|\
			"-h"|\
			"help")
				__ztr_help
				return
				;;
			"--skip")
				__ztr_queue_skip=1
				shift
				;;
			"--quiet"|"-q")
				__ztr_quiet=1
				flags+=( "--quiet" )
				shift
				;;
			"--quiet-emulate")
				__ztr_quiet_emulation_mode=1
				flags+=( "--quiet-emulate" )
				shift
				;;
			"--quiet-fail")
				__ztr_quiet_fail=1
				flags+=( "--quiet-fail" )
				shift
				;;
			"--quiet-pass")
				__ztr_quiet_pass=1
				flags+=( "--quiet-pass" )
				shift
				;;
			"--quiet-skip")
				__ztr_quiet_skip=1
				flags+=( "--quiet-skip" )
				shift
				;;
			"--version"|\
			"-v"|\
			"version")
				__ztr_version
				return
				;;
			"clear-queue")
				clear_queue=1
				shift
				;;
			"clear-summary")
				clear_summary=1
				shift
				;;
			# "help" see "--help"
			"queue")
				queue=1
				shift
				;;
			"run-queue")
				run_queue=1
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
			"test")
				run_test=1
				shift
				;;
			# "version" see "--version"
			*)
				args+=( $1 )
				shift
				;;
		esac
	done

	if (( clear_queue )); then
		__ztr_clear_queue
		__ztr_reset
		return
	fi

	if (( clear_summary )); then
		__ztr_clear_summary
		__ztr_reset
		return
	fi

	if (( queue )); then
		if (( ${#args} || ${#flags} )); then
			__ztr_queue $flags ${args:+${(qq)args}}
		else
			__ztr_queue
		fi

		__ztr_reset
		return
	fi

	if (( run_queue )); then
		__ztr_run_queue $args
		__ztr_reset
		return
	fi

	if (( run_test )); then
		__ztr_test $args

		exit_code=$?

		__ztr_reset

		return $exit_code
	fi

	if (( skip_test )); then
		__ztr_skip $args
		__ztr_reset
		return 0
	fi

	if (( summary )); then
		__ztr_summary
		__ztr_reset
		return
	fi
}

typeset -g +r __ztr_dir && \
	__ztr_dir=${0:A:h} && \
	typeset -gr __ztr_dir

__ztr_init
