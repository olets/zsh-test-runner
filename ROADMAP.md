# Roadmap

## Done, not yet released

-   [x] CLI completion definitions
-   [x] No $reset_color color codes in output if NO_COLOR is enabled

## Next

### Functions automatically run with every test

-   [ ] `ZTR_SETUP_FN` is a user-definable function
-   [ ] `ZTR_TEARDOWN_FN` is a user-definable function
-   [ ] `ztr test` runs `ZTR_SETUP_FN` before `eval`ing the input
-   [ ] `ztr test` runs `ZTR_TEARDOWN_FN` after `eval`ing the input

## Next next

### Functions manually run with every set of tests

-   [ ] `ZTR_BOOTSTRAP_FN` is a user-definable function
-   [ ] `ztr bootstrap` runs the bootstrap function
-   [ ] `ZTR_CLEAN_FN` is a user-definable function
-   [ ] `ztr clean` runs the clean function
-   [ ] `ztr reset` is a shorthand for `ztr clean && ztr clear`

## Next next next

### Queue

-   [ ] `ztr queue <cmd> [<notes>]` queues a command for later testing
-   [ ] `ztr run-queue [(--quiet | -q)] [--summary]` runs all queued commands
    -   [ ] `(--quiet | -q)` behaves as in `ztr test`
    -   [ ] `--summary` runs `ztr summary` after the last queued command
    -   [ ] regardless of whether or not `--summary` is passed, exit code is `$ZTR_COUNT_FAIL`
