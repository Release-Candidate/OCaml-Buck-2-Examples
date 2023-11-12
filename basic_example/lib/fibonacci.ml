(*
   SPDX-FileCopyrightText:  Copyright 2023 Roland Csaszar
   SPDX-License-Identifier: MIT

   Project:  OCaml-Buck-2-Examples, basic_example
   File:     fibonacci.ml
   Date:     08.Oct.2023

   =============================================================================
   Let's use something nobody has ever used as an example for a functional
   programming language: a Fibonacci sequence!
*)

(** A naive implementation of the fibonacci sequence.
    f_0 = 0
    f_1 = 1
    f_n = f_(n-1) + f_(n-2)

    Return the `n`-th fibonacci number Fn. *)
let rec fibonacci n =
  match n with
  | 0 -> 0
  | 1 -> 1
  | n' -> fibonacci (n' - 1) + fibonacci (n' - 2)

(** A tail recursive implementation of the fibonacci sequence.
    f_0 = 0
    f_1 = 1
    f_n = f_(n-1) + f_(n-2)

    Return the `n`-th fibonacci number Fn. *)
let fibonacci_tailrec n =
  let rec go i a b = if i = n then a else go (i + 1) b (a + b) in
  go 0 0 1
