# zsh-test-runner (ztr) ![GitHub release (latest by date)](https://img.shields.io/github/v/release/olets/zsh-test-runner)

> Straight-forward tests and coverage reports for zsh

Features:

-   short and gentle learning curve
-   run one or more tests on the command line (see [`test`](#test---quiet---q-arg-name-notes))
-   run one or more tests saved in a test suite file (see [Running test suites](#running-test-suites))
-   skip tests (see [`skip`](#skip---quiet---q-arg-name-notes))
-   optionally give tests descriptive names (see [`skip`](#skip---quiet---q-arg-name-notes), [`test`](#test---quiet---q-arg-name-notes))
-   optionally provide notes to tests, for example to list dependencies in the logged output (see [`skip`](#skip---quiet---q-arg-name-notes), [`test`](#test---quiet---q-arg-name-notes))
-   access cumulative failure, pass, and skip counts as shell variables
-   print coverage summaries with total, failure, pass, and skip counts, and failure and pass rates (see [`summary`](#summary)).

What it does not feature: its own human language-like declarative test syntax. There's no "describe", "expect", etc. Downside is the tests don't read like a story. Upside is —because the shell already has rich support for tests— there is nothing to learn, there are no artificial limits on what can be tested, the cost to migrating to zsh-test-runner (or from it, if you must) is very low, and there is no risk that assertions were incorrectly implemented. Just write your `[[ ]]`s, your `(( ))`s, even your `test`s or `[ ]`s.

## Installation

### Plugin (recommended)

You can install zsh-test-runner with a zsh plugin manager. This is the recommended method because most modern plugin managers are optimized for shell load time performance and also install command-line completions for you.

Each has its own way of doing things. See your package manager's documentation or the [zsh plugin manager plugin installation procedures gist](https://gist.github.com/olets/06009589d7887617e061481e22cf5a4a). If you're new to zsh plugin management, at this writing zinit is a good choice for its popularity, frequent updates, and great performance.

After adding the plugin to the manager, restart zsh:

```shell
exec zsh
```

### Package

zsh-test-runner is available on Homebrew. Run

```
brew install olets/tap/zsh-test-runner
```

and follow the post-install instructions logged to the terminal.

### Manual

Clone this repo and add `source path/to/ztr.zsh` to your `.zshrc` (replace `path/to/` with the correct path). Then restart zsh:

```shell
exec zsh
```

## Usage

```shell
# Clear results.
ztr clear

# Skip `<arg>`. Pretty-print result and notes unless "quiet".
ztr skip ([--quiet | -q)] [--emulate <shell>] [--quiet-emulate] </shell><arg> [<name> [<notes>]]

# Pretty-print summary of results
ztr summary

# Test `<arg>`. Pretty-print result and notes unless "quiet".
ztr test ([--quiet | -q)] <arg> [<name> [<notes>]]
```

### Commands

#### `clear`

Clear results.

```shell
% ztr test true
PASS true
% ztr clear
% ztr test false
FAIL false
% ztr summary
1 test total
1 (100%) failed
0 were skipped
0 passed
```

#### `skip [(--quiet | -q)] <arg> [<name> [<notes>]]`

Skip `<arg>`. Pretty-print result and notes unless "quiet".

```shell
% ztr skip my_test
SKIP my_test
```

See [`test` command](#test) for details about `--quiet`, `<name>`, and `<notes>`.

#### `summary`

Pretty-print summary of results.

```shell
% ztr test true
PASS true
% ztr test false
FAIL false
% ztr summary
2 tests total
1 (50%) failed
0 were skipped
1 (50%) passed
```

#### `test [(--quiet | -q)] [--emulate <shell>] [--quiet-emulate] <arg> [<name> [<notes>]]`

Test `<arg>`. Pretty-print result and notes unless "quiet".

```shell
% ztr test true
PASS true
% ztr test false
FAIL false
```

In practice `<arg>` will most likely be a shell test expression.

```shell
% ztr test '[[ 1 == 1 ]]'
PASS [[ 1 == 1 ]]
```

Note that `<arg>` is passed to `eval`, so 1) don't pass something you don't want to `eval` and 2) watch out for quotation errors.

```shell
% ztr test [[ 1 == 1 ]]
zsh: = not found # same error you get if you run `eval [[ 1 == 1 ]]`
% ztr test '[[ 1 == 1 ]]'
PASS [[ 1 == 1 ]]
```

`<arg>` can be a value, a function, a `[ ]` or `[[ ]]` test, anything that you can pass to `eval`.

```shell
% ztr test 'test -f myfile.txt'
% ztr test '[ -f myfile.txt ]'
% ztr test '[[ -f myfile.txt ]]'
% ztr test my_function
# etc
```

Choose your quote level to control what is logged.

```shell
% my_var=1
% ztr test "[[ $my_var == 1 ]]"
PASS [[ 1 == 1 ]]
% ztr test '[[ $my_var == 1 ]]'
PASS [[ $my_var == 1 ]]
```

A passing test has a passing exit code; a failing test has a failing exit code:

```shell
% ztr test true 'passing exit code'
PASS passing exit code
% echo $?
0
% ztr test false 'failing exit code'
FAIL failing exit code
% echo $?
1
```

##### `(--quiet | -q)`

Optionally silence output.

```shell
% ztr test true
PASS true
% ztr test --quiet true
% ztr test true
PASS true
```

##### `--emulate <shell>`

Use one of zsh's emulation modes (see "`emulate`" in [_The Z Shell Manual_, chapter 17 "Shell Builtin Commands"](http://zsh.sourceforge.net/Doc/Release/Shell-Builtin-Commands.html#Shell-Builtin-Commands)).

For example, `<shell>` could be `csh`, `ksh`, or `sh`.

> Note that zsh's `emulate` builtin treats anything starting with `s` or `b` is treated as `sh` (the **B**ourne **s**hell).

If an unsupported option is passed, `zsh` is the fallback. If anything other than `zsh` is used a note is printed after the result, indented.

The following examples rely on the fact that when called without any arguments the zsh builtin `emulate` prints the current emulation mode.

```shell
% ztr test '[[ $(emulate) == zsh ]]'
PASS [[ $(emulate) == zsh ]]
% ztr test --emulate sh '[[ $(emulate) == zsh ]]'
FAIL [[ $(emulate) == zsh ]]
    emulation mode: sh
% ztr test --emulate sh '[[ $(emulate) == sh ]]'
PASS [[ $(emulate) == sh ]]
```

If you always emulate a different shell, consider setting `ZSH_EMULATION_MODE` instead of always passing the `--emulate` option.

#### `--quiet-emulate`

Optionally do not warn when a non-zsh shell is emulated.

```
% ztr test --emulate sh --quiet-emulate '[[ $(emulate) == zsh ]]'
FAIL [[ $(emulate) == zsh ]]
```

##### `<name>`

Optionally pass a name as a second parameter.

```shell
% ztr test '[[ 1 == 1 ]]' '<name> appears instead of <arg>'
PASS <name> appears instead of <arg>
```

##### `<notes>`

Optionally pass notes as a third parameter. For example, noting dependencies can help with troubleshooting. In the output notes are indented.

```shell
% cat my_tests.ztr
# --- snip ---
ztr test my_test_10
# --- snip ---
ztr test my_test_20 my_test_20 'Dependencies: my_test_10'
# --- snip ---
ztr test my_test_30 my_test_30 'Dependencies: my_test_10'
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

#### `( --help | -h | help)`

Show the manpage.

#### `( --version | -v | version )`

Print the command name and current version.

### Variables

#### Results

| Variable      | Type              | Default                                 | Use                 |
| ------------- | ----------------- | --------------------------------------- | ------------------- |
| `ZTR_RESULTS` | associative array | `( [failed]=0 [passed]=0 [skipped]=0 )` | The running results |

Note that "tests" in the above are not necessarily unique:

```shell
% ztr test true --quiet
% echo $ZTR_RESULTS[passed]
1
% ztr test true --quiet
% echo $ZTR_RESULTS[passed]
2
```

Use `ztr clear` to zero out results:

```shell
% ztr test true --quiet
% ztr clear
% echo $ZTR_RESULTS
0 0 0
```

`ZTR_RESULTS[failed]` is a convenient way to check for 100% pass rate:

```
% (( ZTR_RESULTS[failed] )) || echo all tests pass
```

#### Configuration

| Variable                   | Type    | Default    | Use                                                                                                                                                                                                                |
| -------------------------- | ------- | ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `NO_COLOR`                 | any     | undeclared | To suppress color output, set to any value or simply declare (`NO_COLOR=`), for example in `.zshrc`.<br>See [Running test suites](#running-test-suites) for other uses, and <https://no-color.org/> for more info. |
| `ZTR_DEBUG`                | integer | `0`        | If non-zero, print debugging messages                                                                                                                                                                              |
| `ZTR_EMULATION_MODE`       | string  | `zsh`      | The emulation mode to use                                                                                                                                                                                          |
| `ZTR_QUIET`                | integer | `0`        | If non-zero, use quiet mode without passing `--quiet`                                                                                                                                                              |
| `ZTR_QUIET_EMULATION_MODE` | integer | `0`        | If non-zero, use quiet emulation mode without passing `--quiet-emulate`                                                                                                                                            |

#### Other

| Variable   | Type   | Use                                                       |
| ---------- | ------ | --------------------------------------------------------- |
| `ZTR_PATH` | string | `source $ZTR_PATH` in scripts that include `ztr` commands |

## Running test suites

You can run a test suite from a file. The following examples suppose the file is in the current working directory; adjust the path to fit your situation.

> ℹ️ Tip: Most test suites should start with `ztr clear`.

1. Prepare your test suite.

    ```shell
    % cat suite.ztr
    my_test=false

    ztr clear
    ztr test true 'my first test'
    ztr test my_test 'my second test'
    ztr test 'my_test && true' 'my third test' 'depends on my second test'
    ztr skip my_other_test 'my other test' '@TODO build the api for this!'

    echo
    ztr summary
    ```

1. Run your test suite either by

    - sourcing it:

        ```shell
        % . ./suite.ztr # or the longhand `source ./suite.ztr`
        PASS my first test
        FAIL my second test
        FAIL my third test
        	depends on my second test
        SKIP my other test
        	@TODO build the api for this!

        4 tests total
        2 (40%) failed
        1 was skipped
        1 (20%) passed
        ```

        This method has advantage that the results are available to the parent shell. It has the potential disadvantage that any other side effects of your tests are not sandboxed.

        ```shell
        % zsh suite.ztr
        # --- snip ---
        4 tests total
        2 (40%) failed
        1 was skipped
        1 (20%) passed

        % ztr summary # suite's summary is available
        4 tests total
        2 (50%) failed
        1 was skipped
        1 (25%) passed

        % echo $my_test # suite's context is available
        false
        ```

    - running it in a subshell

        > In this case you must explicitly source `ztr.zsh` in your test suite. zsh-test-runner provides the variable `ZTR_PATH` to make this easy

        ```shell
        % cat suite.ztr
        source $ZTR_PATH
        # --- snip ---
        ```

        To run the suite in a subshell pass the file to `zsh`:

        ```shell
        % zsh suite.ztr
        PASS my first test
        FAIL my second test
        FAIL my third test
        	depends on my second test
        SKIP my other test
        	@TODO build the api for this!

        4 tests total
        2 (40%) failed
        1 was skipped
        1 (20%) passed
        ```

        This method has the potential advantage of sandboxing your tests. It has the potential disadvantage that the results are not available to the parent shell.

        ```shell
        % zsh suite.ztr
        # --- snip ---
        4 tests total
        2 (40%) failed
        1 was skipped
        1 (20%) passed

        % ztr summary # suite's summary is not available
        0 tests total
        0 failed
        0 were skipped
        0 passed

        % echo $my_test # suite's context is not available

        %
        ```

To write a log to a file simply redirect the zsh-test-runner output. To prevent ANSI codes from cluttering the log, disable `ztr`'s color support (see [configuration variables](#configuration)).

-   if you have already disabled colored output, run the tests:

    ```shell
    % . ./suite.ztr > ./suite.ztr.log # or `zsh` instead of `.`
    ```

-   if you have not already disabled colored output, do so temporarily while running the tests:

    ```shell
    % NO_COLOR=
    % . ./suite.ztr > ./suite.ztr.log # or `zsh` instead of `.`
    % unset NO_COLOR
    ```

### Examples

[`zsh-abbr`](https://github.com/olets/zsh-abbr) uses zsh-test-runner for its test suite. For a real world example of `ztr` use, check out [`zsh-abbr/tests/abbr.ztr`](https://github.com/olets/zsh-abbr/blob/main/tests/abbr.ztr).

## Changelog

See the [CHANGELOG](CHANGELOG.md) file.

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
