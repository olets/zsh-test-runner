# zsh-test-runner ![GitHub release (latest by date)](https://img.shields.io/github/v/release/olets/zsh-test-runner)

> Straight-forward tests and reports for zsh

## Installation

### Plugin

You can install zsh-test-runner with a zsh plugin manager. Each has their own way of doing things. See your package manager's documentation or the [zsh plugin manager plugin installation procedures gist](https://gist.github.com/olets/06009589d7887617e061481e22cf5a4a). If you're new to zsh plugin management, at this writing zinit is a good choice for its popularity, frequent updates, and great performance.

After adding the plugin to the manager, restart zsh:

```shell
exec zsh
```

### Manual

Clone this repo and add `source path/to/ztr.zsh` to your `.zshrc` (replace `path/to/` with the correct path). Then restart zsh:

```shell
exec zsh
```

## Commands

### `clear`

Clear counts.

```shell
% ztr test true
PASS true
% ztr clear
% ztr test false
% ztr summary
1 test total
1 failed
0 were skipped
0 passed
```

### `skip <arg>`

Skip `<arg>`.

```shell
% ztr skip my_test
%
```

### `summary`

Pretty-print summary of counts.

```shell
% ztr test true --quiet
% ztr test false --quiet
% ztr summary
2 tests total
1 (50%) failed
0 were skipped
1 (50%) passed
```

### `test [--quiet | -q] <arg> [<name> [<notes>]]`

Test `<arg>`. Pretty-print result and notes unless "quiet".

```shell
% ztr test true
PASS true
% ztr test false
FAIL false
```

If your arg will error when passed to `eval`, quote it.

```shell
% ztr test [[ 1 == 1 ]]
zsh: = not found # same error you get if you run `eval [[ 1 == 1 ]]`
% ztr test '[[ 1 == 1 ]]'
PASS [[ 1 == 1 ]]
```

Optionally pass a name as a second parameter.

```shell
% ztr test '[[ 1 == 1 ]]' '<name> appears instead of <arg>'
PASS <name> appears instead of <arg>
```

Optionally pass notes as a third parameter. For example, noting dependencies can help with troubleshooting. In the output notes are indented.

```shell
% cat my_tests.ztr
# --- snip ---
ztr test 'my_test_10'
# --- snip ---
ztr test 'my_test_20' 'my_test_20' 'Dependencies: my_test_10'
# --- snip ---
ztr test 'my_test_30' 'my_test_30' 'Dependencies: my_test_10'
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

### `( --help | -h | help)`

Show the manpage.

### `( --version | -v | version )`

Print the command name and current version.

## Roadmap

See the [ROADMAP](ROADMAP.md) file.

## Contributing

Thanks for your interest. Contributions are welcome!

> Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

Check the [Issues](https://github.com/olets/zsh-test-runner/issues) to see if your topic has been discussed before or if it is being worked on. You may also want to check the roadmap (see above).

Please read [CONTRIBUTING.md](CONTRIBUTING.md) before opening a pull request.

To test `ztr` run `./tests/ztr.ztr`

## License

<p xmlns:dct="http://purl.org/dc/terms/" xmlns:cc="http://creativecommons.org/ns#" class="license-text"><a rel="cc:attributionURL" property="dct:title" href="https://www.github.com/olets/zsh-test-runner">zsh-test-runner</a> by <a rel="cc:attributionURL dct:creator" property="cc:attributionName" href="https://www.github.com/olets">Henry Bley-Vroman</a> is licensed under <a rel="license" href="https://creativecommons.org/licenses/by-nc-sa/4.0">CC BY-NC-SA 4.0</a> with a human rights condition from <a href="https://firstdonoharm.dev/version/2/1/license.html">Hippocratic License 2.1</a>. Persons interested in using or adapting this work for commercial purposes should contact the author.</p>

<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1" /><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1" /><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1" /><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1" />

For the full text of the license, see the [LICENSE](LICENSE) file.
