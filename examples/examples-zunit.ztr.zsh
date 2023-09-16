#!/usr/bin/env zsh

main() {
	{
		_tests_syntax() {
			local testing output
			local -a lines
			local -i state

			lines=( a b my-third-file )
			output="foo bar"

			ztr queue "'(( 1 == 1 ))'" "'Testing assertions'"
			testing=Tada! && \
				ztr queue "'[[ \$testing = Tada\! ]]'" "'Test loading scripts'"
			ztr queue "'(( state == 0 )) && [[ -n \$output ]] && [[ \$lines[3] == my-third-file ]]'" "'Test command output'"
			ztr queue true 'true'
			ztr queue --skip false 'false' "'Would fail'"
			ztr queue --skip "' '" Skip
			# error is not supported
			ztr run-queue '---Test syntax---'
		}

		_tests_assertions() {
			local -a lines
			local -A hash

			hash=( [a]=1 [b]=2 [c]=3 )
			lines=( a b my-third-file )

			ztr queue "'(( 1 == 1 ))'" "'equals'"
			ztr queue "'(( 1 != 0 ))'" "'not equal to'"
			ztr queue "'(( 1 > 0 ))'" "'is positive'"
			ztr queue "'(( -1 < 0 ))'" "'is negative'"
			ztr queue "'(( 2 > 1 ))'" "'is greater than'"
			ztr queue "'(( 1 < 2 ))'" "'is less than'"
			ztr queue "'[[ foo == foo ]]'" "'same as'"
			ztr queue "'[[ foo != bar ]]'" "'different from'"
			ztr queue "'[[ -z \"\" ]]'" "'is empty'"
			ztr queue "'[[ -n foo ]]'" "'is not empty'"
			ztr queue "'[[ \"foo bar\" =~ foo ]]'" "'is substring of'"
			ztr queue "'! [[ \"foo bar\" =~ baz ]]'" "'is not substring of'"
			ztr queue "'[[ \"foo bar\" =~ foo ]]'" "'contains'"
			ztr queue "'! [[ \"foo bar\" =~ baz ]]'" "'does not contain'"
			ztr queue "'[[ foo =~ ^[a-z]{3}$ ]]'" "'matches'"
			ztr queue "'! [[ foo =~ [0-9] ]]'" "'does not match'"
			ztr queue "'[[ \$lines[(Ie)a] ]]'" "'in'"
			ztr queue "'[[ \$lines[(Ie)c] ]]'" "'in'"
			ztr queue "'[[ \${(k)hash} =~ a ]]'" "'is key in'"
			ztr queue "'! [[ \${(k)hash} =~ d ]]'" "'is not key in'"
			ztr queue "'[[ \${(v)hash} =~ 1 ]]'" "'is value in'"
			ztr queue "'! [[ \${(v)hash} =~ 4 ]]'" "'is not value in'"
			ztr queue "'[ -e \$_ztr_examples_cur_file ] || [ -h \$_ztr_examples_cur_file ]'" exists
			ztr queue "'[[ -f \$_ztr_examples_cur_file ]]'" "'is file'"
			ztr queue "'[[ -d \$_ztr_examples_cur_dir ]]'" "'is directory'"
			ztr queue "'[[ -h \$_ztr_examples_cur_dir/index-link ]]'" "'is a link'"
			ztr queue "'[[ -r \$_ztr_examples_cur_file ]]'" "'is readable'"
			ztr queue "'[[ -w \$_ztr_examples_cur_file ]]'" "'is writeable'"
			ztr queue "'[[ -x \$_ztr_examples_cur_file ]]'" "'is executable'"
			ztr run-queue '---Assertions---'
		}

		local saved_emulation_mode=$ZTR_EMULATION_MODE

		ZTR_EMULATION_MODE=zsh

		ztr clear-queue
		ztr clear-summary

		_tests_syntax
		echo
		_tests_assertions

		ZTR_EMULATION_MODE=$saved_emulation_mode
	} always {
		unfunction -m _tests_syntax
		unfunction -m _tests_assertions
	}
}

_ztr_examples_cur_file=${0:A}
_ztr_examples_cur_dir=${0:A:h}
main

unset _ztr_examples_cur_file
unset _ztr_examples_cur_dir
unfunction -m main
