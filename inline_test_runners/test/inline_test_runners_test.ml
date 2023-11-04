(*
   SPDX-FileCopyrightText:  Copyright 2023 Roland Csaszar
   SPDX-License-Identifier: MIT

   Project:  OCaml-Buck-2-Examples, inline_test_runners
   File:     inline_test_runners.ml
   Date:     08.Oct.2023

   =============================================================================

   Tests of the library `inline_test_runners` using Alcotest.
*)

open Inline_test_runners.Fibonacci

let%test "F0 is 0" = Alcotest.(check int) "same ints" (fibonacci 5) (fibonacci_tailrec 5)
let%test "F0 is 0" = Alcotest.(check int) "same ints" 0 (fibonacci 0)
let%test "F1 is 1" = Alcotest.(check int) "same ints" 1 (fibonacci 1)
let%test "F2 is 1" = Alcotest.(check int) "same ints" 1 (fibonacci 2)
let%test "F3 is 2" = Alcotest.(check int) "same ints" 2 (fibonacci 3)
let%test "F4 is 3" = Alcotest.(check int) "same ints" 3 (fibonacci 4)
let%test "F5 is 5" = Alcotest.(check int) "same ints" 5 (fibonacci 5)
let%test "F6 is 8" = Alcotest.(check int) "same ints" 8 (fibonacci 6)
let%test "F7 is 13" = Alcotest.(check int) "same ints" 13 (fibonacci 7)
let%test "F8 is 21" = Alcotest.(check int) "same ints" 21 (fibonacci 8)
let%test "F9 is 34" = Alcotest.(check int) "same ints" 34 (fibonacci 9)
let%test "F10 is 55" = Alcotest.(check int) "same ints" 55 (fibonacci 10)
let () = Ppx_inline_alcotest_runner.run ()
