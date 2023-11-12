(*
   SPDX-FileCopyrightText:  Copyright 2023 Roland Csaszar
   SPDX-License-Identifier: MIT

   Project:  OCaml-Buck-2-Examples, ppx_usage_example
   File:     main.ml
   Date:     08.Oct.2023

   ============================================================================== *)

open Ppx_usage_example

let list_of_terms =
  [ "1 + 2 * 5"
  ; "1.486 - 2.5 / 0.123"
  ; "let a = 5 in a / 3"
  ; "let a = 4.0 - 5.2 in let b = a * 0.123 in let c = 5.6 in a + b + c"
  ]

let () =
  print_endline "Some examples:";
  List.iter (fun t -> t ^ " = " ^ Interpreter.interp_env t |> print_endline) list_of_terms
