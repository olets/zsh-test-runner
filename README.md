# zsh-test-runner (ztr) ![GitHub release (latest by date)](https://img.shields.io/github/v/release/olets/zsh-test-runner)

> Straight-forward tests and coverage reports for zsh and —under zsh's emulation— csh, ksh, and sh

**What it features**: everything you need for testing zsh scripts.

-   test [zsh](https://www.zsh.org/) and, to a degree, [csh](https://en.wikipedia.org/wiki/C_shell), [ksh](http://kornshell.com/), and [sh](https://en.wikipedia.org/wiki/Bourne_shell) thanks to zsh's [`emulate`](https://zsh.sourceforge.io/Doc/Release/Shell-Builtin-Commands.html) builtin
    -   optionally give tests descriptive names and additional notes
-   run one or more tests on the command line
-   run one or more tests saved in a test suite file
-   optionally run a setup function before each test
-   optionally run a teardown function after each test
-   skip tests
-   queue tests to run in a batch
    -   optionally run a bootstrap function before each batch
    -   optionally run a clean function after each batch
-   access cumulative failure, pass, and skip counts as shell variables
-   print coverage summaries with total count, failure count and rate, pass count and rate, and skip count
-   short and gentle learning curve

**What it does not feature**: its own human language-like declarative test syntax.

There's no "describe", "expect", etc. Downside is the tests don't read like a story. Upside is —because the shell already has rich support for tests— there is nothing idiomatic to learn, there are no artificial limits on what can be tested, the cost to migrating to zsh-test-runner (or from it, if you must) is very low, and there is no risk that assertions were incorrectly implemented. Just write your `[[ ]]`s, `(( ))`s, even your `test`s and `[ ]`s.

## Documentation

📖 See the guide at https://zsh-test-runner.olets.dev/

## Examples

See the [examples' README](examples/README.md).

## Changelog

See [CHANGELOG](CHANGELOG.md).

## Roadmap

See [ROADMAP](ROADMAP.md).

## Contributing

_Looking for the documentation site's source? See <https://github.com/olets/zsh-test-runner-docs>_

Thanks for your interest. Contributions are welcome!

> Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

Check the [Issues](https://github.com/olets/zsh-test-runner/issues) to see if your topic has been discussed before or if it is being worked on. You may also want to check the roadmap (see above).

Please read [CONTRIBUTING.md](CONTRIBUTING.md) before opening a pull request.

To test `ztr` run `zsh ./tests/ztr.ztr.zsh`

## License

<a href="https://www.github.com/olets/zsh-test-runner">zsh-test-runner</a> by <a href="https://www.github.com/olets">Henry Bley-Vroman</a> is licensed under a license which is the unmodified text of <a href="https://creativecommons.org/licenses/by-nc-sa/4.0">CC BY-NC-SA 4.0</a> and the unmodified text of a <a href="https://firstdonoharm.dev/build?modules=eco,extr,media,mil,sv,usta">Hippocratic License 3</a>. It is not affiliated with Creative Commons or the Organization for Ethical Source.

Human-readable summary of (and not a substitute for) the [LICENSE](LICENSE) file:

You are free to

-   Share — copy and redistribute the material in any medium or format
-   Adapt — remix, transform, and build upon the material

Under the following terms

-   Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
-   Non-commercial — You may not use the material for commercial purposes.
-   Ethics - You must abide by the ethical standards specified in the Hippocratic License 3 with Ecocide, Extractive Industries, US Tariff Act, Mass Surveillance, Military Activities, and Media modules.
-   Preserve terms — If you remix, transform, or build upon the material, you must distribute your contributions under the same license as the original.
-   No additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.
