# OCaml-Buck-2-Examples

This contains documentation and examples on how to use Buck 2 to build OCaml projects.

- [Installation](#installation)
  - [This Repository](#this-repository)
  - [Optional Tools and Extensions](#optional-tools-and-extensions)
- [Buck 2 Usage with OCaml](#buck-2-usage-with-ocaml)
  - [Initialize a Buck 2 Project](#initialize-a-buck-2-project)
  - [Generate a New Opam Switch and Install Packages](#generate-a-new-opam-switch-and-install-packages)
  - [Use the Packages of an Existing Opam Switch](#use-the-packages-of-an-existing-opam-switch)
  - [Buck 2 Target Configuration](#buck-2-target-configuration)
    - [Libraries](#libraries)
    - [Executables](#executables)
    - [PPX](#ppx)
    - [Inline Tests (Runners)](#inline-tests-runners)
      - [Alcotest Inline Runner for a Library](#alcotest-inline-runner-for-a-library)
      - [Alcotest Inline Runner for a Test Executable](#alcotest-inline-runner-for-a-test-executable)
    - [Aliases](#aliases)
- [Using Buck 2 with OCaml-LSP or Merlin](#using-buck-2-with-ocaml-lsp-or-merlin)
- [Examples](#examples)
- [Other Buck 2 with OCaml Resources](#other-buck-2-with-ocaml-resources)
- [Questions and Answers](#questions-and-answers)
  - [Does Buck2 support OCaml on Windows?](#does-buck2-support-ocaml-on-windows)
  - [Can I use Dune (or any other build system) too?](#can-i-use-dune-or-any-other-build-system-too)
  - [Why Buck 2 and not Dune (or other build systems)?](#why-buck-2-and-not-dune-or-other-build-systems)
  - [Why Buck 2 and not Bazel?](#why-buck-2-and-not-bazel)
  - [Error Message "inconsistent assumptions over implementation"](#error-message-inconsistent-assumptions-over-implementation)
- [Buck 2 Examples for other Languages](#buck-2-examples-for-other-languages)
- [Contributions](#contributions)
- [License](#license)

## Installation

You need the following:

- Buck 2: [Buck2 Official Website](https://buck2.build/)
- Facebook's/Meta's Python scripts to handle dependencies on Opam packages and generate Buck 2 configuration files: [ocaml-scripts at GitHub](https://github.com/facebook/ocaml-scripts).
- Python 3, Python 3.8 or newer.

Install Buck 2 like documented at [Buck 2 - Getting Started](https://buck2.build/docs/getting_started/).

Copy the scripts `meta2json.py`, `rules.py` and `dromedary.py` from the `ocaml-scripts` repository to some place you can use it in your project(s), no "real" installation needed. **Warning**: all three must be in the same directory.

### This Repository

To actually clone the Buck 2 prelude into the `prelude` subdirectories of this repository, you have to update them:

- Run `git submodule update --init` in the root directory [./](./).

### Optional Tools and Extensions

Buck 2 has an integrated (Starlark) LSP, which can be started using `buck2 lsp` in the root directory of a Buck 2 project. To use this to help with writing `BUCK` (Starlark) files, you need a plugin for your editor of choice:

- VS Code/VSCodium: [Buck2 LSP](https://marketplace.visualstudio.com/items?itemName=PeerStudios.buck2-lsp-adapter) GitHub: [Buck2 LSP - GitHub](https://github.com/PeerStudios/buck2-lsp-adapter)

## Buck 2 Usage with OCaml

To generate a new OCaml project with Buck 2:

1. Generate the Buck 2 project structure using `buck2 init`
2. Generate a new Opam switch (a sandbox) and a Buck 2 configuration file for the Opam packages, using `dromedary.py` and a **dromedary** configuration file from Meta's `ocaml-scripts`.
3. Edit the Buck 2 configuration files for the build targets

To use Buck 2 for an existing OCaml project:

1. Generate the Buck 2 project structure using `buck2 init`
2. Generate a Buck 2 configuration file for the Opam packages of an existing Opam switch (sandbox), using `dromedary.py` from Meta's `ocaml-scripts`.
3. Edit the Buck 2 configuration files for the build targets

### Initialize a Buck 2 Project

The following steps are needed to setup a Buck 2 project. These are the same for new and already existing OCaml projects.

- `buck2 init --git` to generate all needed files and directories and add the Buck 2 prelude directory as a git submodule, so you are able to update it using git. The [Prelude](https://github.com/facebook/buck2/tree/main/prelude) of Buck 2 contains the build rules for every language, for example the ones for [OCaml](https://github.com/facebook/buck2/tree/main/prelude/ocaml).
- Building the generated default target using `buck2 build //..` should work without errors now:

    ```text
    % buck2 build //...

    Build ID: a125ba60-835a-4afb-813f-cede508c833f
    Jobs completed: 6. Time elapsed: 0.0s.
    Cache hits: 0%. Commands: 1 (cached: 0, remote: 0, local: 1)
    BUILD SUCCEEDED
    ```

- Set the execution platform in `./.buckconfig` to the default one of the prelude.

  ```ini
  [build]
  execution_platforms = prelude//platforms:default
  ```

- Add the needed toolchains to `./toolchains/BUCK`:. edit the file `./toolchains/BUCK` as follows, to include the Python and C++ toolchains, which are always needed, and the OCaml toolchain:

```python
load("@prelude//toolchains:cxx.bzl", "system_cxx_toolchain")
load("@prelude//toolchains:genrule.bzl", "system_genrule_toolchain")
load("@prelude//toolchains:ocaml.bzl", "system_ocaml_toolchain")
load("@prelude//toolchains:python.bzl", "system_python_bootstrap_toolchain")

system_cxx_toolchain(
    name = "cxx",
    visibility = ["PUBLIC"],
)

system_genrule_toolchain(
    name = "genrule",
    visibility = ["PUBLIC"],
)

system_ocaml_toolchain(
    name = "ocaml",
    visibility = ["PUBLIC"],
)

system_python_bootstrap_toolchain(
    name = "python_bootstrap",
    visibility = ["PUBLIC"],
)

```

- Generate a subdirectory `./third-party` in the prohect root directory to hold the information about third-party packages. The name can be any you like, but `third-party` is the canonical one, that's also used in all examples. If you've chosen another one, substitute `third-party` with your directory name in all of the documentation.

### Generate a New Opam Switch and Install Packages

To generate a new switch and install Opam packages in this switch, do the following:

- Edit the JSON configuration file `./third-party/dromedary.json`.
- Fields, these are the arguments you would pass to `opam create`:
  - `name`, a string: the path to the Opam sandbox or the name of the global Opam switch to create.
  - `compiler`, a string: the name of the compiler to use.
  - `packages`, a list of strings: the name and optionally versions of the packages to install in the Opam switch.
- The only mandatory field is `packages`, the default for `name` is `./` and the default for `compiler` is `ocaml-variants`.

- Example file `./third-party/dromedary.json`:

  ```json
  {
      "name": "./",
      "compiler": "ocaml-variants",
      "packages": [
          "menhirLib",
          "sedlex=3.2",
          "alcotest>=1.7.0"
      ]
  }
  ```

  results in the following opam command in the project root: `opam switch create ./third-party/ ocaml-variants 'menhirLib' 'sedlex=3.2' 'alcotest>=1.7.0'`

- Run `python3 dromedary.py -o ./third-party/BUCK ./third-party/dromedary.json`. Instead of `dromedary.py` you need to use the actual path to the Python script. Substitute `third-party` with the name you have chosen for your subdirectory.
- The file `./third-party/BUCK` should now have been created.
- The symlink `./third-party/opam` should link to the generated Opam switch.
- Running `buck2 targets //third-party:` (or the name of your subdirectory instead of `third-party`) should now list all installed Opam packages of the switch.

```text
% buck2 targets //third-party:
Build ID: ed8ad382-6848-44c7-842c-a537fa916411
Jobs completed: 4. Time elapsed: 0.3s.
root//third-party:alcotest
root//third-party:alcotest.alcotest-plugin
root//third-party:alcotest.engine
root//third-party:alcotest.engine.alcotest_engine-plugin
root//third-party:alcotest.runtime.js
root//third-party:alcotest.stdlib_ext
root//third-party:alcotest.stdlib_ext.alcotest_stdlib_ext-plugin
root//third-party:astring
root//third-party:astring.astring-plugin
root//third-party:astring.top
root//third-party:astring.top.astring_top-plugin
root//third-party:base
root//third-party:base.base-plugin
...
```

### Use the Packages of an Existing Opam Switch

To use all opam packages of an existing Opam switch (or sandbox) with name or directory `OPAM_SWITCH`, do the following:

- Run `python3 dromedary.py --switch OPAM_SWITCH -o ./third-party/BUCK`. Instead of `dromedary.py` you need to use the actual path to the Python script. Substitute `third-party` with the name you have chosen for your subdirectory.
- The file `./third-party/BUCK` should now have been created.
- The symlink `./third-party/opam` should link to the path of the Opam switch.
- Running `buck2 targets //third-party:` (or the name of your subdirectory instead of `third-party`) should now list all installed Opam packages of the switch.

```text
% buck2 targets //third-party:
Build ID: ed8ad382-6848-44c7-842c-a537fa916411
Jobs completed: 4. Time elapsed: 0.3s.
root//third-party:alcotest
root//third-party:alcotest.alcotest-plugin
root//third-party:alcotest.engine
root//third-party:alcotest.engine.alcotest_engine-plugin
root//third-party:alcotest.runtime.js
root//third-party:alcotest.stdlib_ext
root//third-party:alcotest.stdlib_ext.alcotest_stdlib_ext-plugin
root//third-party:astring
root//third-party:astring.astring-plugin
root//third-party:astring.top
root//third-party:astring.top.astring_top-plugin
root//third-party:base
root//third-party:base.base-plugin
...
```

### Buck 2 Target Configuration

#### Libraries

**File `./lib/BUCK`**

This is the easiest case, just compile all `ml` files into a library named `my_project`. `deps` would hold library names the library depends on.

```python
ocaml_library(
    name = "my_project",
    srcs = glob(["./*.ml"]),
    deps = [],
    visibility = ["PUBLIC"],
) if not host_info().os.is_windows else None
```

But this library does not contain the files in a single module. For example the module `Bar` of the file `bar.ml` is named `Bar`, not `My_project.Bar`.

To have all the files of the library contained in a parent module `My_project`, you need to do a mapping:

**File `./lib/my_project.mli`**

```ocaml
(* for file foo.ml *)
module Foo = Foo

(* for file bar.ml *)
module Bar = Bar
```

**File `./lib/my_project.ml`**

```ocaml
(* for file foo.ml *)
module Foo = Foo

(* for file bar.ml *)
module Bar = Bar
```

**File `./lib/BUCK`**

Give a `name` to the file `my_project.mli`, so we can use that in other rules.

```python
export_file(
    name = "my_project.mli",
    src = "my_project.mli",
    visibility = [
        ":my_project",
        ":my_project__",
    ],
)
```

Add the mapping as an extra target.

```python
# buildifier: disable=no-effect
ocaml_library(
    name = "my_project__",
    srcs = [
        "my_project.ml",
        ":my_project.mli",
    ],
    compiler_flags = [
        "-no-alias-deps",
    ],
    visibility = [":my_project"],
) if not host_info().os.is_windows else None
```

Compiler the library, using the mapping. `ocamldep_flags` are flags to be passed to `ocamldep`.

```python
# buildifier: disable=no-effect
ocaml_library(
    name = "my_project",
    srcs = ["./foo.ml", "./bar.ml"],
    compiler_flags = [
        "-no-alias-deps",
        "-open",
        "My_project",
    ],
    ocamldep_flags = [
        "-open",
        "My_project",
        "-map",
        "$(location :my_project.mli)",
    ],
    deps = [":my_project__"],
    visibility = ["PUBLIC"],
) if not host_info().os.is_windows else None
```

#### Executables

**File `./bin/BUCK`**

This binary named `my_project` is contained in one source file, `./main.ml` and uses the "internal" library `my_project` located in the subdirectory `lib` of the project root.

```python
ocaml_binary(
    name = "my_project",
    srcs = ["./main.ml"],
    deps = [
        "//lib:my_project",
    ],
    visibility = ["PUBLIC"],
) if not host_info().os.is_windows else None
```

**File `./test/BUCK`**

This test binary named `my_project` is contained in one source file, `./my_project_test.ml` and uses the "internal" library `my_project` located in the subdirectory `lib` of the project root and the libraries `alcotest` and `qcheck-alcotest` from the `third-party` subdirectory.

The binary is missing some libraries when linking, we have to pass `-cclib -lunixbyt -cclib -lunixnat` to the OCaml compiler.

```python
ocaml_binary(
    name = "my_project",
    srcs = ["./my_project_test.ml"],
    deps = [
        "//lib:my_project",
        "//third-party:alcotest",
        "//third-party:qcheck-alcotest"
    ],
    compiler_flags = [
        "-cclib",
        "-lunixbyt",
        "-cclib",
        "-lunixnat",
    ],
    visibility = ["PUBLIC"],
) if not host_info().os.is_windows else None
```

#### PPX

To compile a library using a PPX library, we have to first generate an executable from the PPX. Than use this executable to parse the the source file and generate the actual OCaml source file to be compiled by the OCaml compiler.

**File `./lib/driver.ml`**

This file (yes, that is all) is compiled to an executable, that later parses the source files containing the PPX syntax.

```python
let () = Ppxlib.Driver.standalone ()
```

**File `./lib/BUCK`**

This rule generates the executable named `ppx` from the `./lib/driver.ml` source file and the PPX libraries.

```python
ocaml_binary(
    name = "ppx",
    srcs = ["./driver.ml"],
    compiler_flags = [
        "-linkall",
    ],
    deps = [
        "//third-party:sedlex",
        "//third-party:sedlex.ppx",
    ],
) if not host_info().os.is_windows else None
```

**File `./lib/BUCK`**

Now we use the PPX executable named `ppx` from above to parse the PPX syntax. It is passed to the OCaml compiler using `-ppx $(exe_target :ppx) --as-ppx`.

```python
ocaml_library(
    name = "my_project",
    srcs = ["./ast.ml", "./interpreter.ml", "./lexer_ex.ml"],
    compiler_flags = [
        "-no-alias-deps",
        "-ppx",
        "$(exe_target :ppx) --as-ppx",
    ],
    deps = ["//third-party:sedlex",
            "//third-party:sedlex.ppx"],
    visibility = ["PUBLIC"],
) if not host_info().os.is_windows else None
```

#### Inline Tests (Runners)

To be able to use inline tests, we have to also compile a test runner executable for these to be called. This needs an extra `ocaml_binary` target to run the inline tests.

##### Alcotest Inline Runner for a Library

**File `./lib/BUCK`**

We have to generate an inline test runner executable and link all libraries containing inline tests and the Alcotest inline runner library `ppx_inline_alcotest.runner` with it.

```ocaml
ocaml_binary(
    name = "inline_runner",
    srcs = ["./inline_runner.ml"],
    compiler_flags = [
        "-linkall",
        "-cclib",
        "-lunixbyt",
        "-cclib",
        "-lunixnat",
    ],
    deps = [":inline_test_runners",
            "//third-party:ppx_inline_alcotest.runner",],
    visibility = ["PUBLIC"],
) if not host_info().os.is_windows else None
```

The processing of the library's sources works the same as above, with a PPX driver executable `:ppx`.

**File `./lib/inline_runner.ml`**

The test runner executable's source.

```ocaml
let () = Ppx_inline_alcotest_runner.run ()
```

##### Alcotest Inline Runner for a Test Executable

**File `./test/BUCK`**

We have to generate an inline test runner executable and link all libraries containing inline tests and the Alcotest inline runner library `ppx_inline_alcotest.runner` with it.

ocaml_binary(
    name = "ppx",
    srcs = ["./driver.ml"],
    compiler_flags = [
        "-linkall",
    ],
    deps = ["//third-party:ppx_inline_alcotest",
    ],
) if not host_info().os.is_windows else None

**File `./test/inline_tests.ml`**

The test runner executable's source, add the stanza `let () = Ppx_inline_alcotest_runner.run ()` to run the inline tests.

```ocaml
(* ... *)

let%test "1 is 1" = Alcotest.(check int) "same ints" 1 1

let () = Ppx_inline_alcotest_runner.run ()
```

The processing of the executable's sources works the same as above, with a PPX driver executable `:ppx` and by adding the PPX driver to the test executable's config:

```python
ocaml_binary(
    name = "inline_test_runner",
    srcs = [YOUR_SOURCES],
    deps = [
        "//lib:LIBRARY_TO_TEST",
        "//third-party:ppx_inline_alcotest",
        "//third-party:ppx_inline_alcotest.runner",
        "//third-party:alcotest"
    ],
    compiler_flags = [
        "-cclib",
        "-lunixbyt",
        "-cclib",
        "-lunixnat",
         "-ppx",
        "$(exe_target :ppx) --as-ppx",
    ],
    visibility = ["PUBLIC"],
) if not host_info().os.is_windows else None
```

#### Aliases

You can use aliases for targets, for example in subdirectories.

If you have 3 subdirectories, `bin`, `lib` and `test`, and the target in each subdirectory has the name `my_project` defined in its `BUCK` file, you can define the following aliases:

File `./BUCK` in the project root defines the aliases:

```python
alias(
    name="bin",
    actual="//bin:my_project",
    visibility=["PUBLIC"],
)

alias(
    name="lib",
    actual="//lib:my_project",
    visibility=["PUBLIC"],
)

alias(
    name="test",
    actual="//test:my_project",
    visibility=["PUBLIC"],
)
```

So, instead of `buck2 run //test:my_project` you can now use `buck2 run //:test`

See [Examples](#examples).

## Using Buck 2 with OCaml-LSP or Merlin

You need to generate a `.merlin` file containing the paths to the source and build directories and the list of Opam packages (but using `ocamlfind` names!), see [Merlin - Project Configuration](https://github.com/ocaml/merlin/wiki/project-configuration)

Example:

```text
S bin/**
S lib/**
S test/**

B ./buck-out/v2/gen/root/*/bin/__ppx_usage_example__/_nativeobj_
B ./buck-out/v2/gen/root/*/lib/__ppx__/_nativeobj_
B ./buck-out/v2/gen/root/*/lib/__ppx_usage_example__/_nativeobj_
B ./buck-out/v2/gen/root/*/lib/__ppx_usage_example__/_nativeobj_/_native_gen_
B ./buck-out/v2/gen/root/*/lib/__ppx_usage_example____/_nativeobj_
B ./buck-out/v2/gen/root/*/test/__ppx_usage_example__/_nativeobj_

PKG sedlex menhirLib qcheck-alcotest alcotest sedlex.ppx
```

You can generate the `B` stanzas using `find`, the `cmi` files are located at `_nativeobj_` directories in `buck-out`.

```shell
dirname $(find ./buck-out -name "*.cmi") | sort | uniq
```

To be able to use the `.merlin` file with OCaml-LSP, you need to add the command line argument `--fallback-read-dot-merlin` to the ocaml-lsp invocation and need the Opam package `dot-merlin-reader` installed. OCaml-LSP documentation: [Merlin configuration](https://github.com/ocaml/ocaml-lsp#merlin-configuration-advanced)

For VS Code or Codium the setting to add the command line argument is

```json
    "ocaml.server.args": [
        "--fallback-read-dot-merlin"
    ],
```

## Examples

Each example project directory contains a `README.md` file explaining its Buck 2 configuration files.

- [./basic_example/](./basic_example/) - a OCaml project which uses Opam package dependencies, but no PPX. Contains a library, an executable that uses the library and tests of the library.
- [./ocamllex_menhir_example/](./ocamllex_menhir_example/) - a OCaml project which uses OCamlLex and Menhir to generate OCaml code. Contains a library, an executable that uses the library and tests of the library.
- [./ppx_usage_example/](./ppx_usage_example/) - a OCaml project which uses Sedlex and Menhir as code generators and PPX for Sedlex to show the usage of PPX libraries. Contains a library, an executable that uses the library and tests of the library.
- [./inline_test_runners](./inline_test_runners/) - a OCaml project which uses PPX inline tests, the library uses  Alcotest inline PPX. Contains a library, an executable that uses the library and tests and inline tests of the library.

All of these examples also use Dune configuration files, so you can compare them to the `BUCK` files.

## Other Buck 2 with OCaml Resources

- the official Facebook/Meta examples in the [Buck 2 GitHub Repo](https://github.com/facebook/buck2/tree/main/examples/with_prelude/ocaml).
- ICFP 2023, **Shayne Fletcher, Neil Mitchell**: [Buck2 for OCaml Users and Developers](https://ndmitchell.com/downloads/slides-buck2_for_ocaml_users_and_developers-09_sep_2023.pdf)

## Questions and Answers

### Does Buck2 support OCaml on Windows?

No. Buck2 itself works on Windows, but OCaml's build rules do not support Windows so far. But you can change this: see [OCaml rules in Buck 2 Prelude at GitHub](https://github.com/facebook/buck2/tree/main/prelude/ocaml).

### Can I use Dune (or any other build system) too?

The short answer is "yes". The longer answer is: yes, but you need to manually add changes to `dune` files to `BUCK` files and vice versa. There does not exist a script (so far) that does this work for you.

### Why Buck 2 and not Dune (or other build systems)?

If you have to ask, you may not need it ;). It's mostly useful if you use more than one language (more than just OCaml) that you want to build.

### Why Buck 2 and not Bazel?

Buck2 has OCaml support from Meta itself, not a third party and it is written in Rust, which I use myself, so there is no additional dependency *for me* on a JVM (which Bazel uses). And, last but not least, Bazel is made by Google, which sometimes (*ahem*) abruptly stops supporting some of their projects.
But Bazel has more mature support as Buck 2 is much younger and less used.

There is Bazel support for OCaml by [OBazl](https://github.com/obazl), documentation: [The OBazl Book](https://obazl.github.io/docs_obazl/). I have never tried Bazel (or the OCaml support), so I cannot say anything about it. Try it out for yourself.

### Error Message "inconsistent assumptions over implementation"

If you are getting an error message like

```text
Error: Files third-party/opam/lib/uutf/uutf.cmxa
       and /Users/roland/.opam/5.0.0/lib/ocaml/stdlib.cmxa
       make inconsistent assumptions over implementation Stdlib__String
```

The Opam environment of your shell and the one used by Buck 2 may be off. Set the Opam environment to the one of the right switch using `opam switch BUCK2_SWICH_NAME` and call `opam env` afterwards. The output of `opam switch BUCK2_SWICH_NAME` tells you how. Then clean your project: `buck2 clean` and rebuild everything: `buck2 build //...`

## Buck 2 Examples for other Languages

I've also made example projects using C++ with vcpkg  as package manager: [Cxx-Buck2-vcpkg-Examples](https://github.com/Release-Candidate/Cxx-Buck2-vcpkg-Examples) and with  Conan (the C++ package manager) at [Cxx-Buck2-Conan-Examples](https://github.com/Release-Candidate/Cxx-Buck2-Conan-Examples).

## Contributions

If you want to add tips or tricks on using Buck 2, examples, a link to other examples, blog or forum posts, or found an error, please open an issue or pull request with your changes.

## License

All files in this repository are licensed under the MIT license, see file [./LICENSE](./LICENSE).
