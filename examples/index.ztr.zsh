#!/usr/bin/env zsh

main() {
	emulate -LR zsh

	local f

	for f ($_ztr_examples_cur_dir/examples-*.ztr.zsh(N.)); do
		printf "\nFile: %s\n\n" $f
		. $f
	done
}

_ztr_examples_cur_dir=${0:A:h}
main

unset _ztr_examples_cur_dir
unfunction -m main
