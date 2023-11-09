# Inline Test Runners

This shows how to build an OCaml project containing a library in [./lib/](./lib/) with Alcotest inline tests (`ppx_inline_alcotest`), a binary in [./bin/](./bin/) that uses the library and inline Alcotest tests of the library in [./test/](./test/) using Buck 2.

- [Setup](#setup)
- [Buck 2 Targets](#buck-2-targets)
  - [Examples](#examples)
- [Buck 2 Files](#buck-2-files)

## Setup

All you need to do to be able to build this project, is to install a new Opam switch and the needed packages.

In this directory `inline_test_runners`, run the following command to create the Opam switch and install the packages configured in the file [./third-party/dromedary.json](./third-party/dromedary.json):

Use the actual path to `dromedary.py` instead of just `dromedary.py` in the example.

```text
python3 dromedary.py -o third-party/BUCK third-party/dromedary.json
```

Then, the Opam switch's environment must be activated:

```text
opam switch ./third-party
eval $(opam env --switch=./third-party --set-switch)
```

Now all needed packages should be installed and set up, so you can build and run the executable:

```text
buck2 run //:bin
```

and the tests:

```text
buck2 run //:test
```

## Buck 2 Targets

- `buck2 clean` - deletes all generated files (in the directory `./buck-out/v2/`).
- `buck2 targets //...` - lists all available targets, including all Opam packages. The packages have a prefix of `root//third-party`.
- `buck2 build //...` - builds all targets.
- `buck2 run //:bin` - run the generated executable. This is an alias for `buck2 run //bin:inline_test_runners`.
- `buck2 run //:lib-inline-runner` - run the inline tests of the library. This is an alias for `buck2 run //lib:inline_runner`.
- `buck2 run //:test` - run the generated test executable of the inline tests. This is an alias for `buck2 run //test:inline_test_runners`.

### Examples

List only the targets of `inline_test_runners`, without the Opam packages:

```text
> % buck2 targets //lib: //bin: //test: //:
Build ID: 10a658d7-5a4f-4427-a532-31e96c6336e2
Jobs completed: 4. Time elapsed: 0.0s.
root//:bin
root//:lib
root//:lib-inline-runner
root//:test
root//bin:inline_test_runners
root//lib:inline_runner
root//lib:inline_test_runners
root//lib:inline_test_runners.mli
root//lib:inline_test_runners__
root//lib:ppx
root//test:inline_test_runners
```

Run the generated executable:

```text
> buck2 run //:bin
File changed: root//README.md
Build ID: 9010eae3-43ac-4403-a5f8-25087c1aef7f
Jobs completed: 3. Time elapsed: 0.0s.
BUILD SUCCEEDED
Hello, World!
Btw. Fibonacci number F_10 is 55
```

Run the inline tests:

```text
> buck2 run //:lib-inline-runner
Build ID: 1f6ce806-1644-4a3a-97f0-4e58d9554add
Jobs completed: 5. Time elapsed: 0.0s.
BUILD SUCCEEDED
Testing `./OCaml-Buck-2-Examples/inline_test_runners/buck-out/v2/gen/root/213ed1b7ab869379/lib/__inline_runner__/inline_runner'.
This run has ID `E12RHEYQ'.

  [OK]          lib/fibonacci.ml          0   fib 5 = fib_tailrec 5.
  [OK]          lib/fibonacci.ml          1   fib 2 = fib_tailrec 2.

Full test results in `./OCaml-Buck-2-Examples/inline_test_runners/_build/_tests/-Users-roland-Documents-code-OCaml-Buck-2-Examples-inline_test_runners-buck-out-v2-gen-root-213ed1b7ab869379-lib-__inline_runner__-inline_runner'.
Test Successful in 0.001s. 2 tests run.
```

Run the tests:

```text
> buck2 run :test
Build ID: 4d666109-86fe-4d2d-b830-6afa9c9fc9cb
Jobs completed: 5. Time elapsed: 0.0s.
BUILD SUCCEEDED
Testing `./OCaml-Buck-2-Examples/inline_test_runners/buck-out/v2/gen/root/213ed1b7ab869379/test/__inline_test_runners__/inline_test_runners'.
This run has ID `K79WIV7M'.

  [OK]          test/inline_test_runners_test.ml          0   F10 is 55.
  [OK]          test/inline_test_runners_test.ml          1   F9 is 34.
  [OK]          test/inline_test_runners_test.ml          2   F8 is 21.
  [OK]          test/inline_test_runners_test.ml          3   F7 is 13.
  [OK]          test/inline_test_runners_test.ml          4   F6 is 8.
  [OK]          test/inline_test_runners_test.ml          5   F5 is 5.
  [OK]          test/inline_test_runners_test.ml          6   F4 is 3.
  [OK]          test/inline_test_runners_test.ml          7   F3 is 2.
  [OK]          test/inline_test_runners_test.ml          8   F2 is 1.
  [OK]          test/inline_test_runners_test.ml          9   F1 is 1.
  [OK]          test/inline_test_runners_test.ml         10   F0 is 0.
  [OK]          test/inline_test_runners_test.ml         11   F0 is 0.
  [OK]          lib/fibonacci.ml                          0   fib 5 = fib_tailrec 5.
  [OK]          lib/fibonacci.ml                          1   fib 2 = fib_tailrec 2.

Full test results in `./OCaml-Buck-2-Examples/inline_test_runners/_build/_tests/buck-out-v2-gen-root-213ed1b7ab869379-test-__inline_test_runners__-inline_test_runners'.
Test Successful in 0.003s. 14 tests run.
```

## Buck 2 Files

- [./.buckroot](./.buckroot) - this marks the directory as the root of the Buck 2 directories. In real examples you might want to put all your projects in subdirectories of the Buck 2 root directory. This is an empty file.
- [./.buckconfig](./.buckconfig) - Contains the configuration generated by `buck2 init --git`. Set the execution platform to the default one of the prelude.

  ```ini
  [build]
  execution_platforms = prelude//platforms:default
  ```

- [./toolchains/BUCK](./toolchains/BUCK) - The configuration of the toolchains to use. You always need C++ (`system_cxx_toolchain`) and  Python (`system_python_bootstrap_toolchain`). The OCaml tool chain is `system_ocaml_toolchain`.
- [./third-party/](./third-party/) - This directory contains all third party dependencies and their configuration, like Opam packages. In a bigger Buck 2 configuration you want to use one subdirectory for each language or for each project, e.g. `third-party/ocaml` for all OCaml project dependencies or `third-party/basic-example` for the dependencies of `inline_test_runners`, if for example Opam package versions differ from project to project.
- [./third-party/dromedary.json](./third-party/dromedary.json) - This is the configuration of the Opam switch to create and the packages to install.
- [./third-party/BUCK](./third-party/BUCK) - The configuration of the Opam packages. Generated by the `ocaml-script` `dromedary.py`, and should not be edited manually.
- [./BUCK](./BUCK) - The main Buck 2 configuration file. Contains shorter aliases for the `bin` and `test` targets.
- [./bin/BUCK](./bin/BUCK) - The rules to build the binary.
- [./lib/BUCK](./lib/BUCK) - The rules to build the library.
- [./test/BUCK](./test/BUCK) - The rules to build the test.
- [./prelude/](./prelude/) - Contains all toolchains and rules for all supported languages of Buck 2. A Git submodule.
- [./.merlin](./.merlin) - Merlin configuration file for Merlin and the OCaml-LSP
