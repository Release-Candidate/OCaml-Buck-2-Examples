# Basic Example

- [Buck 2 Targets](#buck-2-targets)
  - [Examples](#examples)
  - [Buck 2 Files](#buck-2-files)

## Buck 2 Targets

- `buck2 clean` - deletes all generated files (in the directory `./buck-out/v2/`).
- `buck2 targets //...` - lists all available targets, including all Opam packages. The packages have a prefix of `root//third-party`.
- `buck2 build //...` - builds all targets.
- `buck2 run //:bin` - run the generated executable. This is an alias for `buck2 run //bin:basic_example`.
- `buck2 run //:test` - run the generated executable. This is an alias for `buck2 run //test:basic_example`.

### Examples

List only the targets of `basic_example`, without the Opam packages:

```text
> buck2 targets //lib: //bin: //test: //:
Build ID: a1878688-a5d3-4e12-a25d-b90bb38d8648
Jobs completed: 2. Time elapsed: 0.0s.
root//:bin
root//:lib
root//:test
root//bin:basic_example
root//lib:basic_example
root//lib:basic_example.mli
root//lib:basic_example__
root//test:basic_example
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

Run the tests:

```text
> buck2 run //:test
File changed: root//README.md
Build ID: 6e716b79-1c5b-4ef3-90ea-f1a58933892e
Jobs completed: 3. Time elapsed: 0.0s.
BUILD SUCCEEDED
qcheck random seed: 514228815
Testing `Fibonacci Tests'.
This run has ID `9WQ30JBU'.

  [OK]          Naive Fibonacci tests                     0   F0 is 0.
  [OK]          Naive Fibonacci tests                     1   F1 is 1.
  [OK]          Naive Fibonacci tests                     2   F2 is 1.
  [OK]          Naive Fibonacci tests                     3   F3 is 2.
  [OK]          Naive Fibonacci tests                     4   F4 is 3.
  [OK]          Naive Fibonacci tests                     5   F5 is 5.
  [OK]          Naive Fibonacci tests                     6   F6 is 8.
  [OK]          Naive Fibonacci tests                     7   F7 is 13.
  [OK]          Naive Fibonacci tests                     8   F8 is 21.
  [OK]          Naive Fibonacci tests                     9   F9 is 34.
  [OK]          Naive Fibonacci tests                    10   F10 is 55.
  [OK]          Compare naive and tail recursive          0   Using Quickcheck.

Full test results in `./OCaml-Buck-2-Examples/basic_example/_build/_tests/Fibonacci Tests'.
Test Successful in 0.882s. 12 tests run.
```

### Buck 2 Files

- [./.buckroot](./.buckroot)
- [./.buckconfig](./.buckconfig)
- [./toolchains/BUCK](./toolchains/BUCK)
- [./third-party/BUCK](./third-party/BUCK)
- [./BUCK](./BUCK)
- [./bin/BUCK](./bin/BUCK)
- [./lib/BUCK](./lib/BUCK)
- [./test/BUCK](./test/BUCK)
- [./prelude/](./prelude/)
