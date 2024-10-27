# [v2.1.1](https://github.com/olets/zsh-test-runner/compare/v2.1.0...v2.1.1) (2024-10-26)


### Bug Fixes

* **manpage:** fix release date ([7f3a76d](https://github.com/olets/zsh-test-runner/commit/7f3a76d8de689a501d2a1f8b8b2127e0d0435e15))



# [v2.1.0](https://github.com/olets/zsh-test-runner/compare/v2.0.0...v2.1.0) (2024-10-26)

### Features

* **skip,test:** support hiding output by result category ([63eb049](https://github.com/olets/zsh-test-runner/commit/63eb049d3c4dd68e89823c4f6a3d04450862a290))



# [v2.0.0](https://github.com/olets/zsh-test-runner/compare/v1.2.0...v2.0.0) (2023-10-12)

v2.0.0 introduces queues, setup and teardown functions, renames `clear` to `clear-summary`, makes a few fixes and other changes, and updates the Hippocratic License portion of the license.

### Bug Fixes

-   **eval:** fallback emulation mode ([cf418fb](https://github.com/olets/zsh-test-runner/commit/cf418fb2d98a0625602a3fbfa8ed373bd66219e2))
-   **manpage:** text formatting ([3d0fb95](https://github.com/olets/zsh-test-runner/commit/3d0fb9560883c4f010bcc64c0930d81d57d37345))

### Features

-   **clear-summary:** rename from clear ([eb02c57](https://github.com/olets/zsh-test-runner/commit/eb02c578b8e8462c5c94be658f35a78032fd974c))
    -   ⚠️ Breaking change
-   **completions:** show help and version in ztr[tab] ([edef33c](https://github.com/olets/zsh-test-runner/commit/edef33cf976ed9a4393d6b95b36d7ae6815dec50)), list all flags ([635ca08](https://github.com/olets/zsh-test-runner/commit/635ca08d7424a998192b5b3835647b76b83635e1))
-   **github:** action to release new github releases on homebrew ([20a3b07](https://github.com/olets/zsh-test-runner/commit/20a3b071d99b5f933a5d402d33874d22dee4b64b))
-   **git:** ignore zsh binaries ([1165ade](https://github.com/olets/zsh-test-runner/commit/1165adebbda6884451f95d7640ad61b1cc4e8e57))
-   **license:** hippocratic is latest ([44818e4](https://github.com/olets/zsh-test-runner/commit/44818e4f8ac8b7f18fab638343a3f150a29268cd))
-   **test:** failing exit code if test fails ([6adec5d](https://github.com/olets/zsh-test-runner/commit/6adec5d1eadeb474b56bf267c57e3baa503eacd3))

#### Examples

-   **examples:** add bats and zunit ([32d58fc](https://github.com/olets/zsh-test-runner/commit/32d58fc29023865b86a0892c1a4ae3925b40b62d))

#### Setup and teardown

New `ZTR_SETUP_FN` and `ZTR_TEARDOWN_FN`.

-   **setup, teardown:** support ([92b617a](https://github.com/olets/zsh-test-runner/commit/92b617a704ea471b6fa6c6a893d4ad39d20061f9))

#### Queues

New commands `ztr clear-queue`, `ztr queue`, and `ztr run-queue`.

-   **completions:** clear-queue, queue, run-queue; rename clear-summary ([35c5dcf](https://github.com/olets/zsh-test-runner/commit/35c5dcfcfa0ad214302d792f424e99c0f45bc044))
-   **clear-queue, queue, run-queue:** add support ([b41288e](https://github.com/olets/zsh-test-runner/commit/b41288e46549a8fd2b80e66ba349990190d152e2))
-   **queue:** let user use same quote level as test ([9a2bbc0](https://github.com/olets/zsh-test-runner/commit/9a2bbc01b24788a065303bfb9a896eaa6ae0b9f6))
-   **queue:** retain flags ([6650ec9](https://github.com/olets/zsh-test-runner/commit/6650ec92a11d6c4045cebd38add224f03f81a488))
-   **queue:** support skipping ([385df28](https://github.com/olets/zsh-test-runner/commit/385df286f793c760540593767a2bcfb3b17b98f4))
-   **run-queue:** name can start with '-' ([1753de7](https://github.com/olets/zsh-test-runner/commit/1753de7b5602b2cdc3899282101cb1a5a9f13e42))
-   **run-queue:** results are saved to summary ([d6324af](https://github.com/olets/zsh-test-runner/commit/d6324af9c48d9357c5845dbd27c85d16f72588e0))
-   **run-queue:** support bootstrap and clean functions ([c20f2ed](https://github.com/olets/zsh-test-runner/commit/c20f2edd85a41bafeb8cbfe514b1a995f3dc4989))
-   **run-queue:** support named batch ([ef57c09](https://github.com/olets/zsh-test-runner/commit/ef57c098f25708dc4259b89f2bf36ca613c89975))

# [v1.2.0](https://github.com/olets/zsh-test-runner/compare/v1.1.1...v1.2.0) (2021-09-24)

### Features

-   **completions:** add new + support in plugin use ([3eaa542](https://github.com/olets/zsh-test-runner/commit/3eaa542d4d7541336b21361ed2c9e3dccd6ae8ee))
-   **results:** counts are in an associate array ZTR_RESULTS ([e5f7969](https://github.com/olets/zsh-test-runner/commit/e5f796960bfab58e69e540f674c390d8ed8cf6d6))
-   **skip, summary, test:** no color codes if NO_COLOR is declared ([b273bee](https://github.com/olets/zsh-test-runner/commit/b273beee52a4b364456fd133d5128338f74b9d27))
    -   **color:** more reliable respect for NO_COLOR ([7dc7682](https://github.com/olets/zsh-test-runner/commit/7dc76827203587c5b92fedebb2f5863406bed5f7))
-   **test:** support emulation modes ([035b0c2](https://github.com/olets/zsh-test-runner/commit/035b0c256641d0b1f1776da06330f22954b4d6f5))
-   **test:** warn if non-zsh emulation mode used ([a7e779e](https://github.com/olets/zsh-test-runner/commit/a7e779e7d75e4953f2e3e42aff2f4f78167f2896))
    -   **test:** --quiet-emulate flag silences emulation warning ([7318a1d](https://github.com/olets/zsh-test-runner/commit/7318a1d9198a539ae669fb2ad9273423cefabe9e))

# [v1.1.1](https://github.com/olets/zsh-test-runner/compare/v1.1.1...v) (2021-03-28)

### Features

-   **skip, summary, test:** check NO_COLOR preference every time ([8b024d8](https://github.com/olets/zsh-test-runner/commit/8b024d81774a1310053fd8ff54c954a00b4891d5))

# [v1.1.0](https://github.com/olets/zsh-test-runner/compare/v1.0.0...v1.1.0) (2021-03-28)

### Features

-   **installation:** homebrew is now supported ([13a51d7](https://github.com/olets/zsh-test-runner/commit/13a51d72366199b3404adf3836164794b7e14b3a))
-   **skip, summary, test:** support NO_COLOR to opt of colored output ([81da821](https://github.com/olets/zsh-test-runner/commit/81da821dc0cfbd1b6838f7126684379073b889c0))
-   **ztr:** run files in subshell (with ZTR_PATH) or by sourcing ([125788e](https://github.com/olets/zsh-test-runner/commit/125788e4146908e502fd39d674065b802d4a65ac))

# [v1.0.0](https://github.com/olets/nitro-zsh-completions/compare/initial...v1.0.0) (2021-03-27)

Initial release

## Features

-   `clear`
-   `skip`
-   `summary`
-   `test`
-   can run test suites

## Other

-   Code of Conduct
-   License
-   README
-   Roadmap
