# Roadmap

## Done, not yet released

### Functions automatically run with every test

-   [ ] `ZTR_SETUP_FN` is a user-definable function
-   [ ] `ZTR_TEARDOWN_FN` is a user-definable function
-   [ ] `ztr test` runs `ZTR_SETUP_FN` before `eval`ing the input
-   [ ] `ztr test` runs `ZTR_TEARDOWN_FN` after `eval`ing the input

### Queue

-   [x] `ztr queue <cmd> [<notes>]` queues a command for later testing
-   [x] `ztr run-queue [(--quiet | -q)]` runs all queued commands
    -   [x] `(--quiet | -q)` applies `--quiet` to all the `ztr test`s run in the queue

## Next

### Functions manually run with every set of tests

-   [ ] `ZTR_BOOTSTRAP_FN` is a user-definable function
-   [ ] `ztr bootstrap` runs the bootstrap function
-   [ ] `ZTR_CLEAN_FN` is a user-definable function
-   [ ] `ztr clean` runs the clean function
-   [ ] `ztr reset` is a shorthand for `ztr clean && ztr clear`
