# Roadmap

## Done, not yet released

### Functions automatically run with every test

-   [x] `ZTR_SETUP_FN` is a user-definable function
-   [x] `ZTR_TEARDOWN_FN` is a user-definable function
-   [x] `ztr test` runs `ZTR_SETUP_FN` before `eval`ing the input
-   [x] `ztr test` runs `ZTR_TEARDOWN_FN` after `eval`ing the input

### Queue

-   [x] `ztr queue <cmd> [<notes>]` queues a command for later testing
-   [x] `ztr run-queue [(--quiet | -q)]` runs all queued commands
    -   [x] `(--quiet | -q)` applies `--quiet` to all the `ztr test`s run in the queue

### Functions manually run with every set of tests

-   [x] `ZTR_BOOTSTRAP_FN` is a user-definable function
-   [x] `ZTR_CLEAN_FN` is a user-definable function
