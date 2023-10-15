# OCaml-Buck-2-Examples

This contains documentation and examples on how to use Buck 2 to build OCaml projects.

- [Installation](#installation)
  - [Optional Tools and Extensions](#optional-tools-and-extensions)
- [Usage](#usage)
- [Examples](#examples)
- [Other OCaml Examples using Buck 2](#other-ocaml-examples-using-buck-2)
- [Questions and Answers](#questions-and-answers)
  - [Does Buck2 support OCaml on Windows?](#does-buck2-support-ocaml-on-windows)
  - [Can I use Dune (or any other build system) too?](#can-i-use-dune-or-any-other-build-system-too)
  - [Why Buck 2 and not Dune (or other build systems)?](#why-buck-2-and-not-dune-or-other-build-systems)
  - [Why Buck 2 and not Bazel?](#why-buck-2-and-not-bazel)
- [Contributions](#contributions)
- [License](#license)

## Installation

You need the following:

- Buck 2: [Buck2 Official Website](https://buck2.build/)
- Facebook's/Meta's Python-scripts to handle dependencies on Opam packages and generate Buck 2 configuration files: [ocaml-scripts at GitHub](https://github.com/Release-Candidate/ocaml-scripts).

Install Buck 2 like documented at [Buck 2 - Getting Started](https://buck2.build/docs/getting_started/).

Copy the scripts `meta2json.py`, `rules.py` and `dromedary.py` from the `ocaml-scripts` repository to some place you can use it in your project(s), no "real" installation needed. But all three must be in the same directory.

### Optional Tools and Extensions

Buck 2 has an integrated (Starlark) LSP, which can be started using `buck2 lsp` in the root directory of a Buck 2 project. To use this to help with writing `BUCK` (Starlark) files, you need a plugin for your editor of choice:

- VS Code/VSCodium: [Buck2 LSP](https://marketplace.visualstudio.com/items?itemName=PeerStudios.buck2-lsp-adapter) GitHub: [Buck2 LSP - GitHub](https://github.com/PeerStudios/buck2-lsp-adapter)

## Usage

## Examples

Each example project directory contains a `README.md` file explaining its Buck 2 configuration files and how to generate them.

- [./basic_example/](./basic_example/) - a OCaml project which uses Opam package dependencies, but no PPX. Contains a library, an executable that uses the library and tests of the library.
- [./ocamllex_menhir_example/](./ocamllex_menhir_example/) - a OCaml project which uses OCamlLex and Menhir to generate OCaml code. Contains a library, an executable that uses the library and tests of the library.
- [./ppx_usage_example/](./ppx_usage_example/) - a OCaml project which uses Sedlex and Menhir as code generators and PPX for Sedlex to show the usage of PPX libraries. Contains a library, an executable that uses the library and tests of the library.

All of these examples also use Dune configuration files, so you can compare them to the `BUCK` files.

## Other OCaml Examples using Buck 2

- the official Facebook/Meta examples in the [Buck 2 GitHub Repo](https://github.com/facebook/buck2/tree/main/examples/with_prelude/ocaml).

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

## Contributions

If you want to add tips or tricks on using Buck 2, examples, a link to other examples, blog or forum posts, or found an error, please open an issue or pull request with your changes.

## License

All files in this repository are licensed under the MIT license, see file [./LICENSE](./LICENSE).
