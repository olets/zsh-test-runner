#!/usr/bin/env zsh

# zsh-test-runner implementations of example tests from core Bats plugins' documentation.

main() {
	{
		_tests_assert() {
			# Ref https://github.com/bats-core/bats-assert/tree/master

			# assert assert
			ztr queue '[ 1 -gt 0 ]' assert
			ztr queue '[ 1 -lt 0 ]' 'assert fail' 'Should fail'

			# assert refute
			ztr queue '[ 1 -gt 0 ]' refute
			ztr queue '[ 1 -lt 0 ]' 'refute fail' 'Should fail'

			# assert assert equal
			ztr queue '[ 1 -eq 1 ]' 'assert equal'
			ztr queue '[ 1 -eq 0 ]' 'assert equal fail' 'Should fail'

			# assert assert not equal
			ztr queue '! [ 1 -eq 0 ]' 'assert not equal'
			ztr queue '! [ 1 -eq 1 ]' 'assert not equal fail' 'Should fail'

			# assert success
			ztr queue 'echo success' 'assert success'
			ztr queue 'echo failure; return 1' 'assert success fail' 'Should fail'

			# assert failure
			ztr queue 'echo failure' 'assert failure'
			ztr queue 'echo success; return 1' 'assert failure fail' 'Should fail'

			# assert output
			ztr queue '[ $(echo have) == have ]' 'assert output matching'
			ztr queue '[ $(echo have) == want ]' 'assert output matching fail' 'Should fail'
			ztr queue 'output=$(echo have); (( ${#output}))' 'assert output existence'
			ztr queue 'output=$(echo); (( ${#output}))' 'assert output existence fail' 'Should fail'
			ztr queue '[ $(echo have) =~ ha ]' 'assert output partial match'
			ztr queue '[ $(echo have) =~ want ]' 'assert output partial match fail' 'Should fail'
			ztr queue 'date=20000101; [[ "$date" =~ ^[0-9]{8}$ ]]' 'assert output regex match'
			ztr queue 'date=YYYYMMDD; [[ "$date" =~ ^[0-9]{8}$ ]]' 'assert output regex match fail' 'Should fail'
			ztr queue --skip ' ' 'assert output with pipe'
			ztr queue --skip ' ' 'assert output with herestring'

			# refute output
			ztr queue '[ $(echo have) != want ]' 'refute output matching'
			ztr queue '[ $(echo have) != have ]' 'refute output matching fail' 'Should fail'
			ztr queue 'output=$(echo); (( ! ${#output}))' 'refute output existence'
			ztr queue 'output=$(echo have); (( ! ${#output}))' 'refute output existence fail' 'Should fail'
			ztr queue '! [ $(echo have) =~ want ]' 'refute output partial match'
			ztr queue '! [ $(echo have) =~ ha ]' 'refute output partial match fail' 'Should fail'
			ztr queue 'date=YYYYMMDD; ! [[ "$date" =~ ^[0-9]{8}$ ]]' 'refute output regex match'
			ztr queue 'date=20000101; ! [[ "$date" =~ ^[0-9]{8}$ ]]' 'refute output regex match fail' 'Should fail'
			ztr queue --skip ' ' 'refute output with pipe'
			ztr queue --skip ' ' 'refute output with herestring'

			# assert line
			ztr queue --skip ' ' 'assert line'
			ztr queue --skip ' ' 'assert line fail' 'Would fail'
			ztr queue --skip ' ' 'assert line index'
			ztr queue --skip ' ' 'assert line index fail' 'Would fail'
			ztr queue --skip ' ' 'assert line partial'
			ztr queue --skip ' ' 'assert line partial fail' 'Would fail'
			ztr queue --skip ' ' 'assert line regex'
			ztr queue --skip ' ' 'assert line regex fail' 'Would fail'

			# refute line
			ztr queue --skip ' ' 'refute line'
			ztr queue --skip ' ' 'refute line fail' 'Would fail'
			ztr queue --skip ' ' 'refute line index'
			ztr queue --skip ' ' 'refute line index fail' 'Would fail'
			ztr queue --skip ' ' 'refute line partial'
			ztr queue --skip ' ' 'refute line partial fail' 'Would fail'
			ztr queue --skip ' ' 'refute line regex'
			ztr queue --skip ' ' 'refute line regex fail' 'Would fail'

			# assert regex
			ztr queue '[[ foo =~ ^.o+$ ]]' 'assert regex'
			ztr queue '[[ foo =~ ^o+$ ]]' 'assert regex fail' 'Should fail'

			# refute regex
			ztr queue '! [[ foo =~ ^o+$ ]]' 'refute regex'
			ztr queue '! [[ foo =~ ^.o+$ ]]' 'refute regex fail' 'Should fail'

			ztr run-queue '---assert---'
		}

		_tests_support() {
			# Ref https://github.com/bats-core/bats-support

			ztr queue 'return 1' fail 'Should fail'
			ztr run-queue '---support---'
		}

		_tests_file() {
			# Ref https://github.com/bats-core/bats-file

			# file types
				# exists
				ztr queue '[ -e $_ztr_examples_cur_file ] || [ -h $_ztr_examples_cur_file ]' exists
				ztr queue '! [ -e nonexistent$_ztr_examples_cur_file ] && ! [ -h nonexistent$_ztr_examples_cur_file ]' 'does not exists'

				# file exists
				ztr queue '[ -f $_ztr_examples_cur_file ]' 'file exists'
				ztr queue '! [ -f nonexistent$_ztr_examples_cur_file ]' 'file not exists'

				# directory exists
				ztr queue '[ -d $_ztr_examples_cur_dir ]' 'directory exists'
				ztr queue '! [ -d nonexistent$_ztr_examples_cur_dir ]' 'directory not exists'

				# link
				ztr queue '[ -h ${_ztr_examples_cur_dir}/index-link ]' 'link exists'
				ztr queue '! [ -h ${_ztr_examples_cur_dir}/nonexistent-link ]' 'link not exists'

				# block file
				ztr queue '[ -b $(find /dev -type b 2>/dev/null | head -1) ]' 'block exists'
				ztr queue '! [ -b $_ztr_examples_cur_file ]' 'block not exists'

				# character file
				ztr queue '[ -c /dev/tty ]' 'character exists'
				ztr queue '! [ -c $_ztr_examples_cur_file ]' 'character not exists'

				# socket
				ztr queue --skip ' ' 'socket exists'
				ztr queue '! [ -S $_ztr_examples_cur_file ]' 'socket not exists'

				# fifo
				ztr queue --skip ' ' 'fifo exists'
				ztr queue '! [ -p $_ztr_examples_cur_file ]' 'fifo not exists'

			# file attributes
				# executable
				ztr queue '[ -x $_ztr_examples_cur_file ]' 'executable'
				ztr queue '! [ -x $_ztr_examples_cur_file ]' 'not executable' 'Should fail'

				# file owner
				ztr queue --skip ' ' 'file owner'
				ztr queue --skip ' ' 'not file owner'

				# permission
				ztr queue --skip ' ' 'file permission'
				ztr queue --skip ' ' 'not file permission'

				# file size
				ztr queue '[ $(cat ${_ztr_examples_cur_dir}/empty | wc -c) -eq 0 ]' 'file size equals'

				# size zero
				ztr queue '[ $(cat ${_ztr_examples_cur_dir}/empty | wc -c) -eq 0 ]' 'size zero'
				ztr queue '[ $(cat $_ztr_examples_cur_file | wc -c) -ne 0 ]' 'size not zero'

				# groupID
				ztr queue --skip ' ' 'file groupID set'
				ztr queue --skip ' ' 'file not groupID set'

				# userID
				ztr queue --skip ' ' 'file userID set'
				ztr queue --skip ' ' 'file not userID set'

				# sticky bit
				ztr queue --skip ' ' 'sticky bit'
				ztr queue '! [ -k $_ztr_examples_cur_file ]' 'no sticky bit'

			# file content
				# empty
				ztr queue '! [ -s ${_ztr_examples_cur_dir}/empty ]' empty
				ztr queue '[ -s $_ztr_examples_cur_file ]' 'not empty'

				# file contains
				ztr queue --skip ' ' 'file contains'
				ztr queue --skip ' ' 'file not contains'

				# symlink
				ztr queue '[ -h ${_ztr_examples_cur_dir}/index-link ] && [[ $(readlink ${_ztr_examples_cur_dir}/index-link) == "index.ztr.zsh" ]]' 'symlink to'
				ztr queue '! [ -h ${_ztr_examples_cur_dir}/index-link ] || ! [ readlink ${_ztr_examples_cur_dir}/index-link == "index.ztr.zsh" ]' 'not symlink to'

			ztr run-queue '---file---'
		}

		local saved_emulation_mode
		local saved_quiet_emulation_mode

		saved_emulation_mode=$ZTR_EMULATION_MODE
		saved_quiet_emulation_mode=$ZTR_QUIET_EMULATION_MODE

		ZTR_EMULATION_MODE=sh
		ZTR_QUIET_EMULATION_MODE=1

		ztr clear-queue
		ztr clear-summary

		_tests_assert
		echo
		_tests_support
		echo
		_tests_file

		ZTR_EMULATION_MODE=$saved_emulation_mode
		ZTR_QUIET_EMULATION_MODE=$saved_quiet_emulation_mode
	} always {
		unfunction -m assert
		unfunction -m support
		unfunction -m file
	}
}

_ztr_examples_cur_file=${0:A}
_ztr_examples_cur_dir=${0:A:h}
main

unset _ztr_examples_cur_file
unset _ztr_examples_cur_dir
unfunction -m main
