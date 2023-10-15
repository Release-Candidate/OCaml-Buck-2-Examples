(*
   SPDX-FileCopyrightText:  Copyright 2023 Roland Csaszar
   SPDX-License-Identifier: MIT

   Project:  OCaml-Buck-2-Examples, ppx_usage_example
   File:     ppx_usage_example_test.ml
   Date:     08.Oct.2023

   ============================================================================= *)

open Ppx_usage_example.Interpreter

let () =
  let open Alcotest in
  let open QCheck_alcotest in
  run
    "Interpreter Tests"
    [ ( "Fixed terms and results"
      , [ test_case "1 - 1 = 0" `Quick (fun () ->
            (check int) "same ints" 0 (interp_env "1 - 1" |> int_of_string))
        ; test_case "2.0 * 1.75 - 4.5 = -1.0" `Quick (fun () ->
            (check (float 0.00001))
              "same floats"
              (-1.0)
              (interp_env "2.0 * 1.75 - 4.5" |> float_of_string))
        ; test_case "let a = 5.21 in a - 0.21 = 5.0" `Quick (fun () ->
            (check (float 0.00001))
              "same floats"
              5.0
              (interp_env "let a = 5.21 in a - 0.21" |> float_of_string))
        ] )
    ; ( "Generated Terms"
      , [ to_alcotest
            ~colors:true
            ~verbose:true
            ~long:true
            QCheck2.(
              Test.make
                ~name:"n - m"
                ~count:100
                ~print:Print.(pair int int)
                Gen.(tup2 nat nat)
                (fun (n, m) ->
                  let term = string_of_int n ^ "-" ^ string_of_int m in
                  n - m = (interp_env term |> int_of_string)))
        ; to_alcotest
            ~colors:true
            ~verbose:true
            ~long:true
            QCheck2.(
              Test.make
                ~name:"n + m"
                ~count:100
                ~print:Print.(pair int int)
                Gen.(tup2 nat nat)
                (fun (n, m) ->
                  let term = string_of_int n ^ "+" ^ string_of_int m in
                  n + m = (interp_env term |> int_of_string)))
        ; to_alcotest
            ~colors:true
            ~verbose:true
            ~long:true
            QCheck2.(
              Test.make
                ~name:"n * m"
                ~count:100
                ~print:Print.(pair int int)
                Gen.(tup2 nat nat)
                (fun (n, m) ->
                  let term = string_of_int n ^ "*" ^ string_of_int m in
                  n * m = (interp_env term |> int_of_string)))
        ; to_alcotest
            ~colors:true
            ~verbose:true
            ~long:true
            QCheck2.(
              Test.make
                ~name:"n / m"
                ~count:100
                ~print:Print.(pair int int)
                Gen.(tup2 nat Gen.(int_range 1 156845))
                (fun (n, m) ->
                  let term = string_of_int n ^ "/" ^ string_of_int m in
                  n / m = (interp_env term |> int_of_string)))
        ] )
    ]
;;
