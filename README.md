# zsh-test-runner ![GitHub release (latest by date)](https://img.shields.io/github/v/release/olets/zsh-test-runner)

> Straight-forward tests and reports for zsh

## Installation

Source `ztr.zsh`

## Commands

### clear

<!-- Clear counts. -->

### skip <test>

<!-- Skip <test>. -->

### summary

<!-- Pretty-print summary of counts. -->

### test [--quiet | -q] <command> [<notes>]

Test <command>. Pretty-print result and notes unless "quiet".

If your command will error when passed to `eval`, quote it.

Optionally pass notes as a second parameter. For example, noting dependencies can help with troubleshooting. In the output notes are indented.

```shell
% ztr test true
PASS true
% ztr test false
FAIL false
```

If your test will error when passed to `eval`, quote it. If your test has spaces, quote it.

Optionally pass notes as a second parameter. For example, noting dependencies can help with troubleshooting. In the output notes are indented.

```shell
% ztr test [[ 1 == 1 ]]
zsh: = not found # same error you get if you run `eval [[ 1 == 1 ]]`
% ztr test '[[ 1 == 1 ]]'
PASS [[ 1 == 1 ]]
```

Optionally pass notes as a second parameter. For example, noting dependencies can help with troubleshooting. In the output notes follow the test result and are indented.

```shell
% cat my_tests.ztr
# --- snip ---
ztr test 'my_test_10'
# --- snip ---
ztr test 'my_test_20' 'Dependencies: my_test_10'
# --- snip ---
ztr test 'my_test_30' 'Dependencies: my_test_10'
# --- snip ---

% ./my_tests.ztr
# --- snip ---
FAIL my_test_10
# --- snip ---
FAIL my_test_20
    'Dependencies: my_test_10'
# --- snip ---
FAIL my_test_30
    'Dependencies: my_test_10'
# Ok let's see if fixing my_test_10 fixes my_test_20 and my_test_30
```

### ( --help | -h | help)

Show the manpage.

### ( --version | -v | version )

Print the command name and current version.

## Contributing

Thanks for your interest. Contributions are welcome!

> Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

Check the [Issues](https://github.com/olets/zsh-test-runner/issues) to see if your topic has been discussed before or if it is being worked on.

Please read [CONTRIBUTING.md](CONTRIBUTING.md) before opening a pull request.

## License

<p xmlns:dct="http://purl.org/dc/terms/" xmlns:cc="http://creativecommons.org/ns#" class="license-text"><a rel="cc:attributionURL" property="dct:title" href="https://www.github.com/olets/zsh-test-runner">zsh-test-runner</a> by <a rel="cc:attributionURL dct:creator" property="cc:attributionName" href="https://www.github.com/olets">Henry Bley-Vroman</a> is licensed under <a rel="license" href="https://creativecommons.org/licenses/by-nc-sa/4.0">CC BY-NC-SA 4.0</a> with a human rights condition from <a href="https://firstdonoharm.dev/version/2/1/license.html">Hippocratic License 2.1</a>. Persons interested in using or adapting this work for commercial purposes should contact the author.</p>

<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1" /><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1" /><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1" /><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1" />

For the full text of the license, see the [LICENSE](LICENSE) file.
