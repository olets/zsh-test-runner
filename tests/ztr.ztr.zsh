#!/usr/bin/env zsh

main() {
	{
		autoload -U colors && colors

		typeset -i failures
		typeset -i passes
		typeset -A ztr_results

		ztr_results=(
			[failed]=0
			[skipped]=0
			[passed]=0
		)

		run() {
			emulate -LR zsh
			local cmd name result
			local -i expectation i

			expectation=$1
			cmd=$2
			notes=$3

			eval $cmd &>/dev/null

			if [[ $? == $expectation ]]; then
				(( ztr_results[passed]++ ))
				result="$fg[green]PASS$reset_color"
			else
				(( ztr_results[failed]++ ))
				result="$fg[red]FAIL$reset_color"
			fi

			'builtin' 'print' $result $notes
		}

		should_pass() {
			emulate -LR zsh
			run 0 $@
		}

		should_fail() {
			emulate -LR zsh
			run 1 $@
		}

		# clear
		ztr clear
		ztr --quiet test false
		ztr --quiet test true
		ztr --quiet skip
		typeset -i clear_total
		clear_total=$(( ZTR_RESULTS[failed] && ZTR_RESULTS[passed] && ZTR_RESULTS[skipped] ))
		ztr clear
		should_pass '(( clear_total )) && [[ $ZTR_RESULTS[failed] == 0 && $ZTR_RESULTS[passed] == 0 && $ZTR_RESULTS[skipped] == 0 ]]' "clear zeros the fail, pass, and skip counts"
		unset clear_total

		# basic
		should_pass "ztr test true" "basic pass"
		should_fail "ztr test false" "basic fail"

		# [[ ]]
		should_pass 'ztr test "[[ 1 == 1 ]]"' "evaluation, passing"
		should_fail 'ztr test "[[ 1 == 2 ]]"' "evaluation, failing"

		# dynamic arg
		my_cmd='"[[ 1 == 1 ]]"' && should_pass "ztr test $my_cmd" "dynamic command, passing"
		my_cmd='"[[ 1 == 2 ]]"' && should_fail "ztr test $my_cmd" "dynamic command, failing"

		# dynamic value
		my_var=1 && should_pass 'ztr test "[[ $my_var == 1 ]]"' "variable evaluation, not expanded in output, passing"
		my_var=2 && should_fail 'ztr test "[[ $my_var == 1 ]]"' "variable evaluation, not expanded in output, failing"
		my_var=1 && should_pass "ztr test '[[ $my_var == 1 ]]'" "variable evaluation, expanded in output, passing"
		my_var=2 && should_fail "ztr test '[[ $my_var == 1 ]]'" "variable evaluation, expanded in output, failing"

		# skip
		should_pass "ztr skip true" "skip passes when test would pass"
		should_pass "ztr skip false" "skip passes when test would fail"

		# counts pt 2
		should_pass "(( ZTR_RESULTS[failed] ))" "fail count increments"
		should_pass "(( ZTR_RESULTS[passed] ))" "pass count increments"
		should_pass "(( ZTR_RESULTS[skipped] ))" "skip count increments"

		# emulation
		should_fail "ztr test '[ "a" == "a" ]'" "uses zsh by default"
		should_pass "ztr test --quiet-emulate --emulate sh '[ "a" == "a" ]'" "can emulate sh"

		# ----------------------------------------------------------------
		# results. all test should be above this point

		typeset -gA +r ZTR_RESULTS
		set -A ZTR_RESULTS ${(kv)ztr_results}
		typeset -gAr ZTR_RESULTS

		echo
		ztr summary
	} always {
		unfunction -m run
		unfunction -m should_pass
		unfunction -m should_fail
	}
}

source ${0:h}/../ztr.zsh
main
